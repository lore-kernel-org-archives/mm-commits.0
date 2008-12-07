From: akpm@linux-foundation.org
Subject: - scripts-extract-ikconfig-remove-bashisms.patch removed from -mm tree
Date: Sat, 06 Dec 2008 16:05:13 -0800
Message-ID: <200812070005.mB705DDK021211@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753534AbYLGAFl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 6 Dec 2008 19:05:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: werner@openmoko.org, randy.dunlap@oracle.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     scripts/extract-ikconfig: remove bashisms
has been removed from the -mm tree.  Its filename was
     scripts-extract-ikconfig-remove-bashisms.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/extract-ikconfig: remove bashisms
From: Werner Almesberger <werner@openmoko.org>

scripts/extract-ikconfig contains a lot of gratuituous bashisms, which
make it fail if /bin/sh isn't bash.  This patch replaces them with regular
Bourne shell constructs.

Signed-off-by: Werner Almesberger <werner@openmoko.org>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/extract-ikconfig |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN scripts/extract-ikconfig~scripts-extract-ikconfig-remove-bashisms scripts/extract-ikconfig
--- a/scripts/extract-ikconfig~scripts-extract-ikconfig-remove-bashisms
+++ a/scripts/extract-ikconfig
@@ -8,8 +8,8 @@ test -e $binoffset || cc -o $binoffset .
 
 IKCFG_ST="0x49 0x4b 0x43 0x46 0x47 0x5f 0x53 0x54"
 IKCFG_ED="0x49 0x4b 0x43 0x46 0x47 0x5f 0x45 0x44"
-function dump_config {
-    typeset file="$1"
+dump_config() {
+    file="$1"
 
     start=`$binoffset $file $IKCFG_ST 2>/dev/null`
     [ "$?" != "0" ] && start="-1"
@@ -18,8 +18,8 @@ function dump_config {
     fi
     end=`$binoffset $file $IKCFG_ED 2>/dev/null`
 
-    let start="$start + 8"
-    let size="$end - $start"
+    start=`expr $start + 8`
+    size=`expr $end - $start`
 
     dd if="$file" ibs=1 skip="$start" count="$size" 2>/dev/null | zcat
 
_

Patches currently in -mm which might be from werner@openmoko.org are

linux-next.patch

