From: akpm@linux-foundation.org
Subject: + remove-bashisms-from-scripts.patch added to -mm tree
Date: Tue, 26 May 2009 14:57:21 -0700
Message-ID: <200905262157.n4QLvLfn008200@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34981 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756978AbZEZV5e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 17:57:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dannf@debian.org, sam@ravnborg.org


The patch titled
     Remove bashisms from scripts
has been added to the -mm tree.  Its filename is
     remove-bashisms-from-scripts.patch

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

remove-bashisms-from-scripts.patch

