/*HOW THIS SKETCH WORKS:
1. Starts in 'Input Mode.' User types an input string, which displays on screen. 
2. User presses Enter key, shifting the sketch to 'Draw Squares' mode.
3. 'Draw Squares' does the following:
3a. It cycles through each character in the input string, turning it into a hexidecimal value that it stores in an array.
3b. It cycles through that array, pulling values for the red, green and blue arguments of the fill() method.
3c. Before passing these arguments, it converts them into integers using the unhex() method.
3d. It uses the row and column indices of a 2D loop to set the position for a new square, coloured individually using the results of the fill() method. This accumulates into a grid.
3e. It waits for user input to either save the resulting image ('S') or return to 'Input Mode.' ('R')*/


String inputString, displayString = "", caratString;
int size, caratTick; //Axis size of output grid, measured in squares
Boolean inputMode = true, drewSquares = false; //inputMode: Are we inputting text? | drewSquares: Do we need to draw squares this frame?

void setup()
{
  size (1024, 768);
  background (255);
  noStroke(); textSize (16);
}

void draw()
{
  if ( inputMode )  
  {
    if ( caratTick <= 25 ) { caratString = "|"; }
    else if ( caratTick >= 25 && caratTick <= 50 ) { caratString = " "; }
    else if ( caratTick > 25 ) { caratTick = 0; }
    
    background (255); fill (0); text ( displayString + caratString, 32, 32 ); 
  }
  else  { if (!drewSquares) { drawSquares(); } } //If we're not typing in text and we haven't drawn the output yet, go do that
  
  caratTick++;
}

void keyPressed()
{
  if ( inputMode ) //If we're typing in text
  {
    switch ( key )
    {
      case ENTER: { inputMode = false; } //'ENTER' key exits input mode
    
      case BACKSPACE:
      {
        if ( inputString.length() > 0 ) {inputString = inputString.substring (0, inputString.length() - 1); } //Trims down the length of the array itself -- prevents empty indices
        if ( displayString.length() > 0 ) {displayString = displayString.substring (0, displayString.length() - 1); } //Trims down the length of the array itself -- prevents empty indices
        break;
      }
      
      case DELETE: { inputString = ""; displayString = ""; }
    
      case CODED: { break; } //'CODED' meaning a key that's neither a number nor on the alphabet (CTRL, SHIFT, etc). Placed here to give 'ENTER' and 'BACKSPACE' special functionality
      
      default: //Final case: the key just entered was actually displayable (A-Z, 0-9, punctuation)
      {
        inputString += key; //Add it to the string we'll pass to the squares function
        displayString += key;
        if ( displayString.length() % 70 == 0) { displayString += "\n"; } break; // If the length of the input string is a multiple of 70 add a new line
      }
    }
    caratTick = 0;
  }
  else //If we're doing something else (probably looking @ squares)
  {
    switch ( key )
    {
      case 'r':      {        inputMode = true; drewSquares = false; break;      } //'R' returns to input mode. Sets 'drewSquares' to false to anticipate new input
      case 's':      {        saveFrame ("output-#####"); break; } //'S' saves an image. ##### is the frame count. The method fills that in automatically.
      default: { break; }
    }
  }
}

void drawSquares()
{
  String[] readStrings = convertStringToHexTriads(inputString); //As a happy accident hex() returns a string -- so that's the type of data we'll work with
  size = (int)Math.ceil ( Math.sqrt ( (readStrings.length / 3 ) ) ); //Get the square-root of one third of our hexadecimal array's length. (Because three elements to one color) Round it up.
  
  background (255);
  
  for (int row = 0, index = 0; row < size; row++)
  {
    for (int column = 0; column < size && index < readStrings.length - 2; column++, index += 3)
    {
      fill
      ( 
        min ( unhex (readStrings[index]) * 1.25, 255), //Multiply it by 1.25 to improve vividness of color (tends to hover around grey). Clamp it bt 0 and 255 so it's still a valid 8-bit value
        min ( unhex ( readStrings[ index + 1 ] ) * 1.25, 255),
        min ( unhex ( readStrings[ index + 2 ] ) * 1.25, 255)
      );
      
      rect ( 16 + (16 * column), 16 + (16 * row), 16, (16 * size) - (16 * row) );
        //Position the square by row and column. Stretch it out to cover the remaining height of the grid (prevents blank spots, squares off the output)
    }
  }
  
  drewSquares = true;
}

String[] convertStringToHexTriads ( String inputString ) //String[] because hex() only wants to make strings
{
     ArrayList<String> outputHexStrings = new ArrayList<String>(); //Dynamically-sized array for arbitrary input
     String[] outputStrings;
    
     for ( int i = 0; i < inputString.length(); i++ )
       { outputHexStrings.add ( hex( inputString.charAt(i), 2) ); } //Run hex() on every character in the string, store in the ArrayList
     
    outputStrings = new String [ outputHexStrings.size() ];
    outputStrings = outputHexStrings.toArray ( outputStrings ); //Turn the ArrayList into an array for more flexible output (method courtesy Java Documentation)
    
    return outputStrings;
}