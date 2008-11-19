From: akpm@linux-foundation.org
Subject: + scripts-extract-ikconfig-remove-bashisms.patch added to -mm tree
Date: Wed, 19 Nov 2008 11:22:35 -0800
Message-ID: <200811191922.mAJJMZRv027599@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752506AbYKSTX3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Nov 2008 14:23:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: werner@openmoko.org, randy.dunlap@oracle.com, sam@ravnborg.org


The patch titled
     scripts/extract-ikconfig: remove bashisms
has been added to the -mm tree.  Its filename is
     scripts-extract-ikconfig-remove-bashisms.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

scripts-extract-ikconfig-remove-bashisms.patch

