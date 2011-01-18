From: akpm@linux-foundation.org
Subject: [merged] parisc-fix-compile-breakage-caused-by-inlining-maybe_mkwrite.patch removed from -mm tree
Date: Tue, 18 Jan 2011 12:30:10 -0800
Message-ID: <201101182030.p0IKUACb003538@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42910 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753274Ab1ARUn4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Jan 2011 15:43:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, aarcange@redhat.com, mm-commits@vger.kernel.org


The patch titled
     parisc: fix compile breakage caused by inlining maybe_mkwrite
has been removed from the -mm tree.  Its filename was
     parisc-fix-compile-breakage-caused-by-inlining-maybe_mkwrite.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: parisc: fix compile breakage caused by inlining maybe_mkwrite
From: James Bottomley <James.Bottomley@HansenPartnership.com>

on Parisc, we have an include of linux/mm.h inside our asm/pgtable.h, so
14fd403f2 ("thp: export maybe_mkwrite") causes us an unsatisfiable use of
pte_mkwrite in linux/mm.h

The fix is obviously not to include linux/mm.h in our pgtable.h, which
unbreaks the build.

Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/include/asm/pgtable.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/parisc/include/asm/pgtable.h~parisc-fix-compile-breakage-caused-by-inlining-maybe_mkwrite arch/parisc/include/asm/pgtable.h
--- a/arch/parisc/include/asm/pgtable.h~parisc-fix-compile-breakage-caused-by-inlining-maybe_mkwrite
+++ a/arch/parisc/include/asm/pgtable.h
@@ -10,11 +10,13 @@
  * we simulate an x86-style page table for the linux mm code
  */
 
-#include <linux/mm.h>		/* for vm_area_struct */
 #include <linux/bitops.h>
+#include <linux/spinlock.h>
 #include <asm/processor.h>
 #include <asm/cache.h>
 
+struct vm_area_struct;
+
 /*
  * kern_addr_valid(ADDR) tests if ADDR is pointing to valid kernel
  * memory.  For the return value to be meaningful, ADDR must be >=
_

Patches currently in -mm which might be from James.Bottomley@HansenPartnership.com are

origin.patch
linux-next.patch
drivers-message-fusion-mptsasc-fix-warning.patch
scsi-fix-a-header-to-include-linux-typesh.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-fix.patch

