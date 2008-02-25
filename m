From: akpm@linux-foundation.org
Subject: - proc-pid-pagemap-fix-pm_special-macro.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:44:21 -0800
Message-ID: <200802250044.m1P0iLdj006102@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753085AbYBYAo7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:44:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hans.rosenfeld@amd.com, Hans.Rosenfeld@amd.com, haveblue@us.ibm.com, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     /proc/pid/pagemap: fix PM_SPECIAL macro
has been removed from the -mm tree.  Its filename was
     proc-pid-pagemap-fix-pm_special-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: /proc/pid/pagemap: fix PM_SPECIAL macro
From: "Hans Rosenfeld" <hans.rosenfeld@amd.com>

There seems to be a bug in the PM_SPECIAL macro for /proc/pid/pagemap.  I
think masking out those other bits makes more sense then setting all those
mask bits.

Signed-off-by: Hans Rosenfeld <Hans.Rosenfeld@amd.com>
Acked-by: Matt Mackall <mpm@selenic.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~proc-pid-pagemap-fix-pm_special-macro fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-pid-pagemap-fix-pm_special-macro
+++ a/fs/proc/task_mmu.c
@@ -531,7 +531,7 @@ struct pagemapread {
 #define PM_RESERVED_BITS    3
 #define PM_RESERVED_OFFSET  (64 - PM_RESERVED_BITS)
 #define PM_RESERVED_MASK    (((1LL<<PM_RESERVED_BITS)-1) << PM_RESERVED_OFFSET)
-#define PM_SPECIAL(nr)      (((nr) << PM_RESERVED_OFFSET) | PM_RESERVED_MASK)
+#define PM_SPECIAL(nr)      (((nr) << PM_RESERVED_OFFSET) & PM_RESERVED_MASK)
 #define PM_NOT_PRESENT      PM_SPECIAL(1LL)
 #define PM_SWAP             PM_SPECIAL(2LL)
 #define PM_END_OF_BUFFER    1
_

Patches currently in -mm which might be from hans.rosenfeld@amd.com are

git-x86.patch
