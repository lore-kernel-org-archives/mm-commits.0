From: akpm@linux-foundation.org
Subject: [merged] mm-use-vm_unmapped_area-on-sparc32-architecture.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:59:58 -0800
Message-ID: <20121212195958.E57BE82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:60357 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab2LLUAA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 15:00:00 -0500
Received: by mail-ye0-f202.google.com with SMTP id l7so119715yen.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 12:00:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, cmetcalf@tilera.com, davem@davemloft.net, hpa@zytor.com, hughd@google.com, lethal@linux-sh.org, linux@arm.linux.org.uk, mingo@elte.hu, ralf@linux-mips.org, riel@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use vm_unmapped_area() on sparc32 architecture
has been removed from the -mm tree.  Its filename was
     mm-use-vm_unmapped_area-on-sparc32-architecture.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: use vm_unmapped_area() on sparc32 architecture

Update the sparc32 arch_get_unmapped_area function to make use of
vm_unmapped_area() instead of implementing a brute force search.

[akpm@linux-foundation.org: fix build]
[akpm@linux-foundation.org: remove now-unused COLOUR_ALIGN()]
Signed-off-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Acked-by: "David S. Miller" <davem@davemloft.net>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/sys_sparc_32.c |   27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff -puN arch/sparc/kernel/sys_sparc_32.c~mm-use-vm_unmapped_area-on-sparc32-architecture arch/sparc/kernel/sys_sparc_32.c
--- a/arch/sparc/kernel/sys_sparc_32.c~mm-use-vm_unmapped_area-on-sparc32-architecture
+++ a/arch/sparc/kernel/sys_sparc_32.c
@@ -34,11 +34,9 @@ asmlinkage unsigned long sys_getpagesize
 	return PAGE_SIZE; /* Possibly older binaries want 8192 on sun4's? */
 }
 
-#define COLOUR_ALIGN(addr)      (((addr)+SHMLBA-1)&~(SHMLBA-1))
-
 unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr, unsigned long len, unsigned long pgoff, unsigned long flags)
 {
-	struct vm_area_struct * vmm;
+	struct vm_unmapped_area_info info;
 
 	if (flags & MAP_FIXED) {
 		/* We do not accept a shared mapping if it would violate
@@ -56,21 +54,14 @@ unsigned long arch_get_unmapped_area(str
 	if (!addr)
 		addr = TASK_UNMAPPED_BASE;
 
-	if (flags & MAP_SHARED)
-		addr = COLOUR_ALIGN(addr);
-	else
-		addr = PAGE_ALIGN(addr);
-
-	for (vmm = find_vma(current->mm, addr); ; vmm = vmm->vm_next) {
-		/* At this point:  (!vmm || addr < vmm->vm_end). */
-		if (TASK_SIZE - PAGE_SIZE - len < addr)
-			return -ENOMEM;
-		if (!vmm || addr + len <= vmm->vm_start)
-			return addr;
-		addr = vmm->vm_end;
-		if (flags & MAP_SHARED)
-			addr = COLOUR_ALIGN(addr);
-	}
+	info.flags = 0;
+	info.length = len;
+	info.low_limit = addr;
+	info.high_limit = TASK_SIZE;
+	info.align_mask = (flags & MAP_SHARED) ?
+		(PAGE_MASK & (SHMLBA - 1)) : 0;
+	info.align_offset = pgoff << PAGE_SHIFT;
+	return vm_unmapped_area(&info);
 }
 
 /*
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
mm-protect-against-concurrent-vma-expansion.patch
linux-next.patch
lib-rbtree_testc-fix-uninitialized-variable-warning.patch
random32-rename-random32-to-prandom.patch
prandom-introduce-prandom_bytes-and-prandom_bytes_state.patch
bnx2x-use-prandom_bytes.patch
mtd-nandsim-use-prandom_bytes.patch
ubifs-use-prandom_bytes.patch
mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch
mtd-mtd_oobtest-convert-to-use-prandom-library.patch
mtd-mtd_pagetest-convert-to-use-prandom-library.patch
mtd-mtd_speedtest-use-prandom_bytes.patch
mtd-mtd_subpagetest-convert-to-use-prandom-library.patch
mtd-mtd_stresstest-use-prandom_bytes.patch

