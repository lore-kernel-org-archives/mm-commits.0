From: akpm@linux-foundation.org
Subject: - scripts-checksyscallssh-fix-for-non-gnu-sed.patch removed from -mm tree
Date: Thu, 30 Oct 2008 12:04:41 -0700
Message-ID: <200810301904.m9UJ4fsv024885@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758714AbYJ3TEt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 15:04:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tvolpini@gmx.net, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     scripts/checksyscalls.sh: fix for non-gnu sed
has been removed from the -mm tree.  Its filename was
     scripts-checksyscallssh-fix-for-non-gnu-sed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 
 (ignore_list && syscall_list ${srctree}/arch/x86/include/asm/unistd_32.h) | \
_

Patches currently in -mm which might be from tvolpini@gmx.net are

linux-next.patch

