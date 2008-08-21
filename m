From: akpm@linux-foundation.org
Subject: + scripts-checksyscallssh-fix-for-non-gnu-sed.patch added to -mm tree
Date: Thu, 21 Aug 2008 14:28:45 -0700
Message-ID: <200808212128.m7LLSjhT026877@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39240 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754571AbYHUV2v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Aug 2008 17:28:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tvolpini@gmx.net, sam@ravnborg.org


The patch titled
     scripts/checksyscalls.sh: fix for non-gnu sed
has been added to the -mm tree.  Its filename is
     scripts-checksyscallssh-fix-for-non-gnu-sed.patch

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
Subject: scripts/checksyscalls.sh: fix for non-gnu sed
From: Thomas Volpini <tvolpini@gmx.net>

Make the checksyscalls script work even on systems where sed is non-gnu.

Cc: Sam Ravnborg <sam@ravnborg.org>a
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checksyscalls.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checksyscalls.sh~scripts-checksyscallssh-fix-for-non-gnu-sed scripts/checksyscalls.sh
--- a/scripts/checksyscalls.sh~scripts-checksyscallssh-fix-for-non-gnu-sed
+++ a/scripts/checksyscalls.sh
@@ -113,10 +113,10 @@ EOF
 }
 
 syscall_list() {
-sed -n -e '/^\#define/ { s/[^_]*__NR_\([^[:space:]]*\).*/\
+sed -n -e '/^\#define/ s/[^_]*__NR_\([^[:space:]]*\).*/\
 \#if !defined \(__NR_\1\) \&\& !defined \(__IGNORE_\1\)\
 \#warning syscall \1 not implemented\
-\#endif/p }' $1
+\#endif/p' $1
 }
 
 (ignore_list && syscall_list ${srctree}/include/asm-x86/unistd_32.h) | \
_

Patches currently in -mm which might be from tvolpini@gmx.net are

scripts-checksyscallssh-fix-for-non-gnu-sed.patch

