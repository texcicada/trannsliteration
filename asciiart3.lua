colorascii = function ( picture )
  -- read a picture in .ppm format
  local file = io.open(picture, "r")
  if file==nil then
    tex.sprint("file not found")
    return
  end
  local arr = {}
  for line in file:lines() do
    if line:sub(1,1)~="#" then--if line starts with # don't insert it
      table.insert(arr,line);
    end
  end
  file:close()
  if arr[1]~="P3" then
    tex.sprint("i don't like this file")
    --TODO: implement moar ways to detect if the file is corrupt
    return
  end
  local sizes = {}
  for i in string.gmatch(arr[2],"%d+") do
    table.insert(sizes,i)
  end
  local xsize = tonumber(sizes[1])
  local ysize = tonumber(sizes[2])
  table.remove(arr,1)--remove "P3"
  table.remove(arr,1)--remove sizes
  table.remove(arr,1)--remove maxval and assume no value is bigger than 255
  colors = ""
  for k,v in pairs(arr) do
    colors = colors..v.." "
  end
  colors = string.gsub(colors, " +", " ")
  --now all our picture is in a single string
  rgb = {}
  for i in string.gmatch(colors,"%d+ %d+ %d+") do
    temp = {}
    for j in string.gmatch(i, "%d+") do
      table.insert(temp,j)
    end
    table.insert(rgb, temp)
  end
  tex.sprint("\\noindent\\resizebox{\\textwidth}{!}{")
  tex.sprint("\\noindent\\begin{minipage}{"..xsize.."\\correctem}\\setlength\\baselineskip{1\\correctex}\\setlength\\lineskip{0pt}\\setlength\\prevdepth{0pt}")
  for i = 1,#rgb do
    tex.sprint("\\definecolor{mycolor}{RGB}{"..rgb[i][1]..","..rgb[i][2]..","..rgb[i][3].."}\\textcolor{mycolor}x\\hspace{0pt}")
  end
  tex.sprint("\\end{minipage}}")
end

valchar = function (val)--takes an integer from 0 to 255 and returns a character
  val = tonumber(val)
  valuetable = {"\\$","B","Q","Y","v","~","."," "}--return darker characters for darker values
  return valuetable[math.floor(val/32)+1]
end


bwasciitextshade = function ( picture, bsl, thresholda, thresholdb, mystring )
  local file = io.open(picture, "r")
  if file==nil then
    tex.sprint("file not found")
    return
  end
  local arr = {}
  for line in file:lines() do
    if line:sub(1,1)~="#" then
      table.insert(arr,line);
    end
  end
  file:close()
  if arr[1]~="P2" then
    tex.sprint("i don't like this file")
    return
  end
  local sizes = {}
  for i in string.gmatch(arr[2],"%d+") do
    table.insert(sizes,i)
  end
  local xsize = tonumber(sizes[1])
  local ysize = tonumber(sizes[2])
  table.remove(arr,1)
  table.remove(arr,1)
  table.remove(arr,1)
  greys = ""
  for k,v in pairs(arr) do
    greys = greys..v.." "
  end
  greys = string.gsub(greys, " +", " ")
  value = {}
  for i in string.gmatch(greys,"%d+") do
    table.insert(value, i)
  end
  tex.sprint("\\noindent\\resizebox{\\textwidth}{!}{")
  tex.sprint("\\noindent\\begin{minipage}{"..xsize.."\\correctem}\\setlength\\baselineskip{"..bsl.."\\correctex}\\setlength\\lineskip{0pt}\\setlength\\prevdepth{0pt}\\leavevmode")
  local letterarray = {}
    local targetStr = mystring
-- Looping through strings require gmatch.
    for c in string.gmatch(targetStr, ".") do 
      table.insert(letterarray, c)
    end 
 local i = 0
	local itemcount = 1
  for i = 1,#value do
  		if (tonumber(value[i]) >  tonumber(thresholda)) and
  		     (tonumber(value[i]) <  tonumber(thresholdb)) then
--    tex.sprint("\\smash{"..valchar(value[i]).."}\\hspace{0pt}")
			if #letterarray > 0 then
    tex.sprint("\\color[gray]{"..(tonumber(value[i])/255).."}\\smash{"..letterarray[itemcount].."}\\hspace{0pt}")
    itemcount=itemcount+1
    if itemcount == #letterarray + 1 then
    			itemcount = 1
    end
    end
    else
    tex.sprint("\\smash{".."\\ ".."}\\hspace{0pt}")
    end
  end
  tex.sprint("\\end{minipage}}")
end

--
bwasciitextshape = function ( picture, bsl, thresholda, thresholdb, mystring )
  local file = io.open(picture, "r")
  if file==nil then
    tex.sprint("file not found")
    return
  end
  local arr = {}
  for line in file:lines() do
    if line:sub(1,1)~="#" then
      table.insert(arr,line);
    end
  end
  file:close()
  if arr[1]~="P2" then
    tex.sprint("i don't like this file")
    return
  end
  local sizes = {}
  for i in string.gmatch(arr[2],"%d+") do
    table.insert(sizes,i)
  end
  local xsize = tonumber(sizes[1])
  local ysize = tonumber(sizes[2])
  table.remove(arr,1)
  table.remove(arr,1)
  table.remove(arr,1)
  greys = ""
  for k,v in pairs(arr) do
    greys = greys..v.." "
  end
  greys = string.gsub(greys, " +", " ")
  value = {}
  for i in string.gmatch(greys,"%d+") do
    table.insert(value, i)
  end
  tex.sprint("\\noindent\\resizebox{\\textwidth}{!}{")
  tex.sprint("\\noindent\\begin{minipage}{"..xsize.."\\correctem}\\setlength\\baselineskip{"..bsl.."\\correctex}\\setlength\\lineskip{0pt}\\setlength\\prevdepth{0pt}\\leavevmode")
  local letterarray = {}
    local targetStr = mystring
-- Looping through strings require gmatch.
    for c in string.gmatch(targetStr, ".") do 
      table.insert(letterarray, c)
    end 
 local i = 0
	local itemcount = 1
  for i = 1,#value do
  		if (tonumber(value[i]) >  tonumber(thresholda)) and
  		     (tonumber(value[i]) <  tonumber(thresholdb)) then
--    tex.sprint("\\smash{"..valchar(value[i]).."}\\hspace{0pt}")
			if #letterarray > 0 then
    tex.sprint("\\smash{"..letterarray[itemcount].."}\\hspace{0pt}")
    itemcount=itemcount+1
    if itemcount == #letterarray + 1 then
    			itemcount = 1
    end
    end
    else
    tex.sprint("\\smash{".."\\ ".."}\\hspace{0pt}")
    end
  end
  tex.sprint("\\end{minipage}}")
end

--
bwascii = function ( picture )
  local file = io.open(picture, "r")
  if file==nil then
    tex.sprint("file not found")
    return
  end
  local arr = {}
  for line in file:lines() do
    if line:sub(1,1)~="#" then
      table.insert(arr,line);
    end
  end
  file:close()
  if arr[1]~="P2" then
    tex.sprint("i don't like this file")
    return
  end
  local sizes = {}
  for i in string.gmatch(arr[2],"%d+") do
    table.insert(sizes,i)
  end
  local xsize = tonumber(sizes[1])
  local ysize = tonumber(sizes[2])
  table.remove(arr,1)
  table.remove(arr,1)
  table.remove(arr,1)
  greys = ""
  for k,v in pairs(arr) do
    greys = greys..v.." "
  end
  greys = string.gsub(greys, " +", " ")
  value = {}
  for i in string.gmatch(greys,"%d+") do
    table.insert(value, i)
  end
  tex.sprint("\\noindent\\resizebox{\\textwidth}{!}{")
  tex.sprint("\\noindent\\begin{minipage}{"..xsize.."\\correctem}\\setlength\\baselineskip{1\\correctex}\\setlength\\lineskip{0pt}\\setlength\\prevdepth{0pt}\\leavevmode")
 local i = 0
  for i = 1,#value do
    tex.sprint("\\smash{"..valchar(value[i]).."}\\hspace{0pt}")
  end
  tex.sprint("\\end{minipage}}")
end
