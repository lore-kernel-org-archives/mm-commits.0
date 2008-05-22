From: akpm@linux-foundation.org
Subject: + scripts-ver_linux-use-gcc-dumpversion.patch added to -mm tree
Date: Wed, 21 May 2008 23:29:25 -0700
Message-ID: <200805220629.m4M6TP1B021100@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758688AbYEVG34 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 02:29:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nix.or.die@googlemail.com, sam@ravnborg.org


The patch titled
     scripts/ver_linux use 'gcc -dumpversion'
has been added to the -mm tree.  Its filename is
     scripts-ver_linux-use-gcc-dumpversion.patch

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
