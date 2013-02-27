From: akpm@linux-foundation.org
Subject: [merged] mm-use-vm_unmapped_area-on-ia64-architecture.patch removed from -mm tree
Date: Wed, 27 Feb 2013 12:50:59 -0800
Message-ID: <20130227205059.B0DC531C071@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:51598 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767Ab3B0UvD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 15:51:03 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so111132ghb.0
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 12:51:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, riel@redhat.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use vm_unmapped_area() on ia64 architecture
has been removed from the -mm tree.  Its filename was
     mm-use-vm_unmapped_area-on-ia64-architecture.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: use vm_unmapped_area() on ia64 architecture

Update the ia64 arch_get_unmapped_area function to make use of
vm_unmapped_area() instead of implementing a brute force search.

Signed-off-by: Michel Lespinasse <walken@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/sys_ia64.c |   35 ++++++++++------------------------
 1 file changed, 11 insertions(+), 24 deletions(-)

diff -puN arch/ia64/kernel/sys_ia64.c~mm-use-vm_unmapped_area-on-ia64-architecture arch/ia64/kernel/sys_ia64.c
--- a/arch/ia64/kernel/sys_ia64.c~mm-use-vm_unmapped_area-on-ia64-architecture
+++ a/arch/ia64/kernel/sys_ia64.c
@@ -25,9 +25,9 @@ arch_get_unmapped_area (struct file *fil
 			unsigned long pgoff, unsigned long flags)
 {
 	long map_shared = (flags & MAP_SHARED);
-	unsigned long start_addr, align_mask = PAGE_SIZE - 1;
+	unsigned long align_mask = 0;
 	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
+	struct vm_unmapped_area_info info;
 
 	if (len > RGN_MAP_LIMIT)
 		return -ENOMEM;
@@ -44,7 +44,7 @@ arch_get_unmapped_area (struct file *fil
 		addr = 0;
 #endif
 	if (!addr)
-		addr = mm->free_area_cache;
+		addr = TASK_UNMAPPED_BASE;
 
 	if (map_shared && (TASK_SIZE > 0xfffffffful))
 		/*
@@ -53,28 +53,15 @@ arch_get_unmapped_area (struct file *fil
 		 * tasks, we prefer to avoid exhausting the address space too quickly by
 		 * limiting alignment to a single page.
 		 */
-		align_mask = SHMLBA - 1;
+		align_mask = PAGE_MASK & (SHMLBA - 1);
 
-  full_search:
-	start_addr = addr = (addr + align_mask) & ~align_mask;
-
-	for (vma = find_vma(mm, addr); ; vma = vma->vm_next) {
-		/* At this point:  (!vma || addr < vma->vm_end). */
-		if (TASK_SIZE - len < addr || RGN_MAP_LIMIT - len < REGION_OFFSET(addr)) {
-			if (start_addr != TASK_UNMAPPED_BASE) {
-				/* Start a new search --- just in case we missed some holes.  */
-				addr = TASK_UNMAPPED_BASE;
-				goto full_search;
-			}
-			return -ENOMEM;
-		}
-		if (!vma || addr + len <= vma->vm_start) {
-			/* Remember the address where we stopped this search:  */
-			mm->free_area_cache = addr + len;
-			return addr;
-		}
-		addr = (vma->vm_end + align_mask) & ~align_mask;
-	}
+	info.flags = 0;
+	info.length = len;
+	info.low_limit = addr;
+	info.high_limit = TASK_SIZE;
+	info.align_mask = align_mask;
+	info.align_offset = 0;
+	return vm_unmapped_area(&info);
 }
 
 asmlinkage long
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
linux-next.patch
mm-use-vm_unmapped_area-on-parisc-architecture.patch
mm-use-vm_unmapped_area-on-parisc-architecture-fix.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch
mm-remove-free_area_cache-use-in-powerpc-architecture.patch
mm-use-vm_unmapped_area-on-powerpc-architecture.patch
mm-remove-free_area_cache.patch
mm-use-vm_unmapped_area-on-frv-architecture.patch
mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch
mtd-mtd_oobtest-convert-to-use-prandom-library.patch
mtd-mtd_pagetest-convert-to-use-prandom-library.patch
mtd-mtd_speedtest-use-prandom_bytes.patch
mtd-mtd_subpagetest-convert-to-use-prandom-library.patch
mtd-mtd_stresstest-use-prandom_bytes.patch
mutex-subsystem-synchro-test-module.patch

