From: akpm@linux-foundation.org
Subject: [merged] remove-bashisms-from-scripts.patch removed from -mm tree
Date: Wed, 10 Jun 2009 10:44:15 -0700
Message-ID: <200906101744.n5AHiF4p031008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54368 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760210AbZFJRpE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jun 2009 13:45:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dannf@debian.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     Remove bashisms from scripts
has been removed from the -mm tree.  Its filename was
     remove-bashisms-from-scripts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Remove bashisms from scripts
From: dann frazier <dannf@debian.org>

The '-e' option to echo and brace expansion are not guaranteed to be supported
by a POSIX-compliant /bin/sh (e.g. dash)

Signed-off-by: dann frazier <dannf@debian.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gcc-version.sh |    2 +-
 scripts/ver_linux      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/gcc-version.sh~remove-bashisms-from-scripts scripts/gcc-version.sh
--- a/scripts/gcc-version.sh~remove-bashisms-from-scripts
+++ a/scripts/gcc-version.sh
@@ -18,7 +18,7 @@ compiler="$*"
 
 if [ ${#compiler} -eq 0 ]; then
 	echo "Error: No compiler specified."
-	echo -e "Usage:\n\t$0 <gcc-command>"
+	printf "Usage:\n\t$0 <gcc-command>\n"
 	exit 1
 fi
 
diff -puN scripts/ver_linux~remove-bashisms-from-scripts scripts/ver_linux
--- a/scripts/ver_linux~remove-bashisms-from-scripts
+++ a/scripts/ver_linux
@@ -65,7 +65,7 @@ sed -n -e '/^.*\/libc-\([^/]*\)\.so$/{s/
 ldd -v > /dev/null 2>&1 && ldd -v || ldd --version |head -n 1 | awk \
 'NR==1{print "Dynamic linker (ldd)  ", $NF}'
 
-ls -l /usr/lib/lib{g,stdc}++.so  2>/dev/null | awk -F. \
+ls -l /usr/lib/libg++.so /usr/lib/libstdc++.so  2>/dev/null | awk -F. \
        '{print "Linux C++ Library      " $4"."$5"."$6}'
 
 ps --version 2>&1 | grep version | awk \
_

Patches currently in -mm which might be from dannf@debian.org are

linux-next.patch

