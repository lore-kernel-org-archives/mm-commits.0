From: akpm@linux-foundation.org
Subject: - bugfix-for-scripts-patch-kernel-in-26-sublevel-stepping.patch removed from -mm tree
Date: Wed, 06 Aug 2008 13:57:30 -0700
Message-ID: <200808062057.m76KvUpM014775@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756494AbYHFVBM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 17:01:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebirdie@iki.fi, randy.dunlap@oracle.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     bugfix for scripts/patch-kernel in 2.6 sublevel stepping
has been removed from the -mm tree.  Its filename was
     bugfix-for-scripts-patch-kernel-in-26-sublevel-stepping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-kbuild-fixes.patch

