From: akpm@linux-foundation.org
Subject: - scripts-ver_linux-use-gcc-dumpversion.patch removed from -mm tree
Date: Tue, 27 May 2008 00:28:27 -0700
Message-ID: <200805270728.m4R7SRt0014943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756060AbYE0H3E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 03:29:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nix.or.die@googlemail.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     scripts/ver_linux use 'gcc -dumpversion'
has been removed from the -mm tree.  Its filename was
     scripts-ver_linux-use-gcc-dumpversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/ver_linux use 'gcc -dumpversion'
From: Gabriel C <nix.or.die@googlemail.com>

These magic greps and hacks in ver_linux to get the gcc version always
break after some gcc releases.

Since now gcc >4.3 allows compiling with '--with-pkgversion' ( which can
be everything 'My Cool Gcc' or something ) ver_linux will report random
junk for these.

Simply use 'gcc -dumpversion' to get the gcc version which should always
work.

Signed-off-by: Gabriel C <nix.or.die@googlemail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/ver_linux |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN scripts/ver_linux~scripts-ver_linux-use-gcc-dumpversion scripts/ver_linux
--- a/scripts/ver_linux~scripts-ver_linux-use-gcc-dumpversion
+++ a/scripts/ver_linux
@@ -12,12 +12,9 @@ echo ' '
 uname -a
 echo ' '
 
-gcc --version 2>&1| head -n 1 | grep -v gcc | awk \
+gcc -dumpversion 2>&1| awk \
 'NR==1{print "Gnu C                 ", $1}'
 
-gcc --version 2>&1| grep gcc | awk \
-'NR==1{print "Gnu C                 ", $3}'
