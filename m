From: akpm@linux-foundation.org
Subject: + mm-use-vm_unmapped_area-on-sparc64-architecture.patch added to -mm tree
Date: Wed, 14 Nov 2012 14:28:13 -0800
Message-ID: <20121114222814.3C914100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:62129 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423512Ab2KNW2P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Nov 2012 17:28:15 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so104104yhl.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Nov 2012 14:28:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, cmetcalf@tilera.com, davem@davemloft.net, hpa@zytor.com, hughd@google.com, lethal@linux-sh.org, linux@arm.linux.org.uk, mingo@elte.hu, ralf@linux-mips.org, riel@redhat.com, tglx@linutronix.de


The patch titled
     Subject: mm: use vm_unmapped_area() on sparc64 architecture
has been added to the -mm tree.  Its filename is
     mm-use-vm_unmapped_area-on-sparc64-architecture.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: use vm_unmapped_area() on sparc64 architecture

Update the sparc64 arch_get_unmapped_area[_topdown] functions to make use
of vm_unmapped_area() instead of implementing a brute force search.

Signed-off-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/sys_sparc_64.c |  132 ++++++-----------------------
 1 file changed, 30 insertions(+), 102 deletions(-)

diff -puN arch/sparc/kernel/sys_sparc_64.c~mm-use-vm_unmapped_area-on-sparc64-architecture arch/sparc/kernel/sys_sparc_64.c
--- a/arch/sparc/kernel/sys_sparc_64.c~mm-use-vm_unmapped_area-on-sparc64-architecture
+++ a/arch/sparc/kernel/sys_sparc_64.c
@@ -102,6 +102,7 @@ unsigned long arch_get_unmapped_area(str
 	unsigned long task_size = TASK_SIZE;
 	unsigned long start_addr;
 	int do_color_align;
+	struct vm_unmapped_area_info info;
 
 	if (flags & MAP_FIXED) {
 		/* We do not accept a shared mapping if it would violate
@@ -134,50 +135,22 @@ unsigned long arch_get_unmapped_area(str
 			return addr;
 	}
 
-	if (len > mm->cached_hole_size) {
-	        start_addr = addr = mm->free_area_cache;
-	} else {
-	        start_addr = addr = TASK_UNMAPPED_BASE;
-	        mm->cached_hole_size = 0;
+	info.flags = 0;
+	info.length = len;
+	info.low_limit = TASK_UNMAPPED_BASE;
+	info.high_limit = min(task_size, VA_EXCLUDE_START);
+	info.align_mask = do_color_align ? (PAGE_MASK & (SHMLBA - 1)) : 0;
+	info.align_offset = pgoff << PAGE_SHIFT;
+	addr = vm_unmapped_area(&info);
+
+	if ((addr & ~PAGE_MASK) && task_size > VA_EXCLUDE_END) {
+		VM_BUG_ON(addr != -ENOMEM);
+		info.low_limit = VA_EXCLUDE_END;
+		info.high_limit = task_size;
+		addr = vm_unmapped_area(&info);
 	}
 
-	task_size -= len;
-
-full_search:
-	if (do_color_align)
-		addr = COLOUR_ALIGN(addr, pgoff);
-	else
-		addr = PAGE_ALIGN(addr);
-
-	for (vma = find_vma(mm, addr); ; vma = vma->vm_next) {
-		/* At this point:  (!vma || addr < vma->vm_end). */
-		if (addr < VA_EXCLUDE_START &&
-		    (addr + len) >= VA_EXCLUDE_START) {
-			addr = VA_EXCLUDE_END;
-			vma = find_vma(mm, VA_EXCLUDE_END);
-		}
-		if (unlikely(task_size < addr)) {
-			if (start_addr != TASK_UNMAPPED_BASE) {
-				start_addr = addr = TASK_UNMAPPED_BASE;
-				mm->cached_hole_size = 0;
-				goto full_search;
-			}
-			return -ENOMEM;
-		}
-		if (likely(!vma || addr + len <= vma->vm_start)) {
-			/*
-			 * Remember the place where we stopped the search:
-			 */
-			mm->free_area_cache = addr + len;
-			return addr;
-		}
-		if (addr + mm->cached_hole_size < vma->vm_start)
-		        mm->cached_hole_size = vma->vm_start - addr;
-
-		addr = vma->vm_end;
-		if (do_color_align)
-			addr = COLOUR_ALIGN(addr, pgoff);
-	}
+	return addr;
 }
 
 unsigned long
@@ -190,6 +163,7 @@ arch_get_unmapped_area_topdown(struct fi
 	unsigned long task_size = STACK_TOP32;
 	unsigned long addr = addr0;
 	int do_color_align;
+	struct vm_unmapped_area_info info;
 
 	/* This should only ever run for 32-bit processes.  */
 	BUG_ON(!test_thread_flag(TIF_32BIT));
@@ -224,73 +198,27 @@ arch_get_unmapped_area_topdown(struct fi
 			return addr;
 	}
 
-	/* check if free_area_cache is useful for us */
-	if (len <= mm->cached_hole_size) {
- 	        mm->cached_hole_size = 0;
- 		mm->free_area_cache = mm->mmap_base;
- 	}
-
-	/* either no address requested or can't fit in requested address hole */
-	addr = mm->free_area_cache;
-	if (do_color_align) {
-		unsigned long base = COLOUR_ALIGN_DOWN(addr-len, pgoff);
-
-		addr = base + len;
-	}
-
-	/* make sure it can fit in the remaining address space */
-	if (likely(addr > len)) {
-		vma = find_vma(mm, addr-len);
-		if (!vma || addr <= vma->vm_start) {
-			/* remember the address as a hint for next time */
-			return (mm->free_area_cache = addr-len);
-		}
-	}
-
-	if (unlikely(mm->mmap_base < len))
-		goto bottomup;
-
-	addr = mm->mmap_base-len;
-	if (do_color_align)
-		addr = COLOUR_ALIGN_DOWN(addr, pgoff);
-
-	do {
-		/*
-		 * Lookup failure means no vma is above this address,
-		 * else if new region fits below vma->vm_start,
-		 * return with success:
-		 */
-		vma = find_vma(mm, addr);
-		if (likely(!vma || addr+len <= vma->vm_start)) {
-			/* remember the address as a hint for next time */
-			return (mm->free_area_cache = addr);
-		}
-
- 		/* remember the largest hole we saw so far */
- 		if (addr + mm->cached_hole_size < vma->vm_start)
- 		        mm->cached_hole_size = vma->vm_start - addr;
-
-		/* try just below the current vma->vm_start */
-		addr = vma->vm_start-len;
-		if (do_color_align)
-			addr = COLOUR_ALIGN_DOWN(addr, pgoff);
-	} while (likely(len < vma->vm_start));
+	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
+	info.length = len;
+	info.low_limit = PAGE_SIZE;
+	info.high_limit = mm->mmap_base;
+	info.align_mask = do_colour_align ? (PAGE_MASK & shm_align_mask) : 0;
+	info.align_offset = pgoff << PAGE_SHIFT;
+	addr = vm_unmapped_area(&info);
 
-bottomup:
 	/*
 	 * A failed mmap() very likely causes application failure,
 	 * so fall back to the bottom-up function here. This scenario
 	 * can happen with large stack limits and large mmap()
 	 * allocations.
 	 */
-	mm->cached_hole_size = ~0UL;
-  	mm->free_area_cache = TASK_UNMAPPED_BASE;
-	addr = arch_get_unmapped_area(filp, addr0, len, pgoff, flags);
-	/*
-	 * Restore the topdown base:
-	 */
-	mm->free_area_cache = mm->mmap_base;
-	mm->cached_hole_size = ~0UL;
+	if (addr & ~PAGE_MASK) {
+		VM_BUG_ON(addr != -ENOMEM);
+		info.flags = 0;
+		info.low_limit = TASK_UNMAPPED_BASE;
+		info.high_limit = STACK_TOP32;
+		addr = vm_unmapped_area(&info);
+	}
 
 	return addr;
 }
_

Patches currently in -mm which might be from walken@google.com are

mm-add-anon_vma_lock-to-validate_mm.patch
linux-next.patch
mm-augment-vma-rbtree-with-rb_subtree_gap.patch
mm-augment-vma-rbtree-with-rb_subtree_gap-ensure-safe-rb_subtree_gap-update-when-inserting-new-vma.patch
mm-augment-vma-rbtree-with-rb_subtree_gap-ensure-safe-rb_subtree_gap-update-when-removing-vma.patch
mm-augment-vma-rbtree-with-rb_subtree_gap--debug-code-to-verify-rb_subtree_gap-updates-are-safe.patch
mm-check-rb_subtree_gap-correctness.patch
mm-check-rb_subtree_gap-correctness-fix.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses-checkpatch-fixes.patch
mm-vm_unmapped_area-lookup-function.patch
mm-vm_unmapped_area-lookup-function-checkpatch-fixes.patch
mm-use-vm_unmapped_area-on-x86_64-architecture.patch
mm-fix-cache-coloring-on-x86_64-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture-fix.patch
mm-use-vm_unmapped_area-on-mips-architecture.patch
mm-use-vm_unmapped_area-on-mips-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix-fix.patch
mm-use-vm_unmapped_area-on-sh-architecture.patch
mm-use-vm_unmapped_area-on-sh-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc32-architecture.patch
mm-use-vm_unmapped_area-on-sparc32-architecture-fix.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture.patch
mm-use-vm_unmapped_area-on-sparc64-architecture.patch
mm-use-vm_unmapped_area-on-sparc64-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc64-architecture-fix-fix.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-sparc64-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-sparc64-architecture-fix.patch
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

