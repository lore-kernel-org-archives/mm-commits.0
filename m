From: akpm@linux-foundation.org
Subject: + bugfix-for-scripts-patch-kernel-in-26-sublevel-stepping.patch added to -mm tree
Date: Mon, 04 Aug 2008 15:34:42 -0700
Message-ID: <200808042234.m74MYgWU003072@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755498AbYHDWgV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 18:36:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebirdie@iki.fi, randy.dunlap@oracle.com, sam@ravnborg.org


The patch titled
     bugfix for scripts/patch-kernel in 2.6 sublevel stepping
has been added to the -mm tree.  Its filename is
     bugfix-for-scripts-patch-kernel-in-26-sublevel-stepping.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bugfix for scripts/patch-kernel in 2.6 sublevel stepping
From: Erkki Lintunen <ebirdie@iki.fi>

scripts/patch-kernel script can't patch a tree, say, from 2.6.25 to
2.6.26.1, because of a wrong comparison in context of patching 2.6.x base.
 Fix it.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/patch-kernel |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN scripts/patch-kernel~bugfix-for-scripts-patch-kernel-in-26-sublevel-stepping scripts/patch-kernel
--- a/scripts/patch-kernel~bugfix-for-scripts-patch-kernel-in-26-sublevel-stepping
+++ a/scripts/patch-kernel
@@ -213,6 +213,7 @@ fi
 if [ $stopvers != "default" ]; then
 	STOPSUBLEVEL=`echo $stopvers | cut -d. -f3`
 	STOPEXTRA=`echo $stopvers | cut -d. -f4`
+	STOPFULLVERSION=${stopvers%%.$STOPEXTRA}
 	#echo "#___STOPSUBLEVEL=/$STOPSUBLEVEL/, STOPEXTRA=/$STOPEXTRA/"
 else
 	STOPSUBLEVEL=9999
@@ -249,7 +250,7 @@ while :				# incrementing SUBLEVEL (s in
 do
     CURRENTFULLVERSION="$VERSION.$PATCHLEVEL.$SUBLEVEL"
     EXTRAVER=
-    if [ $stopvers = $CURRENTFULLVERSION ]; then
+    if [ $STOPFULLVERSION = $CURRENTFULLVERSION ]; then
         echo "Stopping at $CURRENTFULLVERSION base as requested."
         break
     fi
_

Patches currently in -mm which might be from ebirdie@iki.fi are

bugfix-for-scripts-patch-kernel-in-26-sublevel-stepping.patch

