From: akpm@linux-foundation.org
Subject: + eradicate-bashisms-in-scripts-patch-kernel.patch added to -mm tree
Date: Wed, 31 Oct 2007 14:23:09 -0700
Message-ID: <200710312123.l9VLN9UD029250@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44051 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753886AbXJaVXf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Oct 2007 17:23:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@lisas.de, sam@ravnborg.org


The patch titled
     eradicate bashisms in scripts/patch-kernel
has been added to the -mm tree.  Its filename is
     eradicate-bashisms-in-scripts-patch-kernel.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: eradicate bashisms in scripts/patch-kernel
From: Andreas Mohr <andi@lisas.de>

I was non-mildly horrified to find that the rather widely used patch-kernel
script seems to rely on bash despite specifying the interpreter as #!/bin/sh,
since my dash-using Debian install choked on it.

- replace "==" by "="

- the "source" statement most likely needs the ./ prepended, as can be
  gathered from e.g. 
  http://osdir.com/ml/colinux.devel/2005-12/msg00036.html

- the newly replaced sed expression below: is it ok? correct? strict enough?

Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/patch-kernel |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff -puN scripts/patch-kernel~eradicate-bashisms-in-scripts-patch-kernel scripts/patch-kernel
--- a/scripts/patch-kernel~eradicate-bashisms-in-scripts-patch-kernel
+++ a/scripts/patch-kernel
@@ -65,7 +65,7 @@ sourcedir=${1-/usr/src/linux}
 patchdir=${2-.}
 stopvers=${3-default}
 
-if [ "$1" == -h -o "$1" == --help -o ! -r "$sourcedir/Makefile" ]; then
+if [ "$1" = "-h" -o "$1" = "--help" -o ! -r "$sourcedir/Makefile" ]; then
 cat << USAGE
 usage: $PNAME [-h] [ sourcedir [ patchdir [ stopversion ] [ -acxx ] ] ]
   source directory defaults to /usr/src/linux,
@@ -185,7 +185,7 @@ reversePatch () {
 TMPFILE=`mktemp .tmpver.XXXXXX` || { echo "cannot make temp file" ; exit 1; }
 grep -E "^(VERSION|PATCHLEVEL|SUBLEVEL|EXTRAVERSION)" $sourcedir/Makefile > $TMPFILE
 tr -d [:blank:] < $TMPFILE > $TMPFILE.1
-source $TMPFILE.1
+. ./$TMPFILE.1
 rm -f $TMPFILE*
 if [ -z "$VERSION" -o -z "$PATCHLEVEL" -o -z "$SUBLEVEL" ]
 then
@@ -202,13 +202,7 @@ echo "Current kernel version is $VERSION
 EXTRAVER=
 if [ x$EXTRAVERSION != "x" ]
 then
-	if [ ${EXTRAVERSION:0:1} == "." ]; then
-		EXTRAVER=${EXTRAVERSION:1}
-	else
-		EXTRAVER=$EXTRAVERSION
-	fi
-	EXTRAVER=${EXTRAVER%%[[:punct:]]*}
-	#echo "$PNAME: changing EXTRAVERSION from $EXTRAVERSION to $EXTRAVER"
+	EXTRAVER=`echo $EXTRAVERSION|sed -s 's/^[\.]\?\([^[:punct:]]*\).*/\1/'`
 fi
 
 #echo "stopvers=$stopvers"
@@ -251,16 +245,16 @@ while :				# incrementing SUBLEVEL (s in
 do
     CURRENTFULLVERSION="$VERSION.$PATCHLEVEL.$SUBLEVEL"
     EXTRAVER=
-    if [ $stopvers == $CURRENTFULLVERSION ]; then
+    if [ $stopvers = $CURRENTFULLVERSION ]; then
         echo "Stopping at $CURRENTFULLVERSION base as requested."
         break
     fi
 
-    SUBLEVEL=$((SUBLEVEL + 1))
+    SUBLEVEL=$(( $SUBLEVEL + 1 ))
     FULLVERSION="$VERSION.$PATCHLEVEL.$SUBLEVEL"
     #echo "#___ trying $FULLVERSION ___"
 
-    if [ $((SUBLEVEL)) -gt $((STOPSUBLEVEL)) ]; then
+    if [ $SUBLEVEL -gt $STOPSUBLEVEL ]; then
 	echo "Stopping since sublevel ($SUBLEVEL) is beyond stop-sublevel ($STOPSUBLEVEL)"
 	exit 1
     fi
@@ -297,7 +291,7 @@ fi
 if [ x$gotac != x ]; then
   # Out great user wants the -ac patches
 	# They could have done -ac (get latest) or -acxx where xx=version they want
-	if [ $gotac == "-ac" ]; then
+	if [ $gotac = "-ac" ]; then
 	  # They want the latest version
 		HIGHESTPATCH=0
 		for PATCHNAMES in $patchdir/patch-${CURRENTFULLVERSION}-ac*\.*
_

Patches currently in -mm which might be from andi@lisas.de are

working-3d-dri-intel-agpko-resume-for-i815-chip.patch
eradicate-bashisms-in-scripts-patch-kernel.patch
