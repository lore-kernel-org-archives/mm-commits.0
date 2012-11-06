From: akpm@linux-foundation.org
Subject: + mm-use-vm_unmapped_area-on-sh-architecture.patch added to -mm tree
Date: Tue, 06 Nov 2012 14:39:54 -0800
Message-ID: <20121106223955.C82C720004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:36465 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab2KFWj7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2012 17:39:59 -0500
Received: by mail-wi0-f202.google.com with SMTP id hr7so66769wib.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Nov 2012 14:39:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, cmetcalf@tilera.com, davem@davemloft.net, hpa@zytor.com, hughd@google.com, lethal@linux-sh.org, linux@arm.linux.org.uk, mingo@elte.hu, ralf@linux-mips.org, riel@redhat.com, tglx@linutronix.de


The patch titled
     Subject: mm: use vm_unmapped_area() on sh architecture
has been added to the -mm tree.  Its filename is
     mm-use-vm_unmapped_area-on-sh-architecture.patch

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
Subject: mm: use vm_unmapped_area() on sh architecture

Update the sh arch_get_unmapped_area[_topdown] functions to make use of
vm_unmapped_area() instead of implementing a brute force search.

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

 arch/sh/mm/mmap.c |  124 ++++++++------------------------------------
 1 file changed, 23 insertions(+), 101 deletions(-)

diff -puN arch/sh/mm/mmap.c~mm-use-vm_unmapped_area-on-sh-architecture arch/sh/mm/mmap.c
--- a/arch/sh/mm/mmap.c~mm-use-vm_unmapped_area-on-sh-architecture
+++ a/arch/sh/mm/mmap.c
@@ -49,6 +49,7 @@ unsigned long arch_get_unmapped_area(str
 	struct vm_area_struct *vma;
 	unsigned long start_addr;
 	int do_colour_align;
+	struct vm_unmapped_area_info info;
 
 	if (flags & MAP_FIXED) {
 		/* We do not accept a shared mapping if it would violate
@@ -79,47 +80,13 @@ unsigned long arch_get_unmapped_area(str
 			return addr;
 	}
 
-	if (len > mm->cached_hole_size) {
-		start_addr = addr = mm->free_area_cache;
-	} else {
-	        mm->cached_hole_size = 0;
-		start_addr = addr = TASK_UNMAPPED_BASE;
-	}
-
-full_search:
-	if (do_colour_align)
-		addr = COLOUR_ALIGN(addr, pgoff);
-	else
-		addr = PAGE_ALIGN(mm->free_area_cache);
-
-	for (vma = find_vma(mm, addr); ; vma = vma->vm_next) {
-		/* At this point:  (!vma || addr < vma->vm_end). */
-		if (unlikely(TASK_SIZE - len < addr)) {
-			/*
-			 * Start a new search - just in case we missed
-			 * some holes.
-			 */
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
-		if (do_colour_align)
-			addr = COLOUR_ALIGN(addr, pgoff);
-	}
+	info.flags = 0;
+	info.length = len;
+	info.low_limit = TASK_UNMAPPED_BASE;
+	info.high_limit = TASK_SIZE;
+	info.align_mask = do_colour_align ? (PAGE_MASK & shm_align_mask) : 0;
+	info.align_offset = pgoff << PAGE_SHIFT;
+	return vm_unmapped_area(&info);
 }
 
 unsigned long
@@ -131,6 +98,7 @@ arch_get_unmapped_area_topdown(struct fi
 	struct mm_struct *mm = current->mm;
 	unsigned long addr = addr0;
 	int do_colour_align;
+	struct vm_unmapped_area_info info;
 
 	if (flags & MAP_FIXED) {
 		/* We do not accept a shared mapping if it would violate
@@ -162,73 +130,27 @@ arch_get_unmapped_area_topdown(struct fi
 			return addr;
 	}
 
-	/* check if free_area_cache is useful for us */
-	if (len <= mm->cached_hole_size) {
-	        mm->cached_hole_size = 0;
-		mm->free_area_cache = mm->mmap_base;
-	}
-
-	/* either no address requested or can't fit in requested address hole */
-	addr = mm->free_area_cache;
-	if (do_colour_align) {
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
-	if (do_colour_align)
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
-		/* remember the largest hole we saw so far */
-		if (addr + mm->cached_hole_size < vma->vm_start)
-		        mm->cached_hole_size = vma->vm_start - addr;
+	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
+	info.length = len;
+	info.low_limit = PAGE_SIZE;
+	info.high_limit = mm->mmap_base;
+	info.align_mask = do_colour_align ? (PAGE_MASK & shm_align_mask) : 0;
+	info.align_offset = pgoff << PAGE_SHIFT;
+	addr = vm_unmapped_area(&info);
 
-		/* try just below the current vma->vm_start */
-		addr = vma->vm_start-len;
-		if (do_colour_align)
-			addr = COLOUR_ALIGN_DOWN(addr, pgoff);
-	} while (likely(len < vma->vm_start));
-
-bottomup:
 	/*
 	 * A failed mmap() very likely causes application failure,
 	 * so fall back to the bottom-up function here. This scenario
 	 * can happen with large stack limits and large mmap()
 	 * allocations.
 	 */
-	mm->cached_hole_size = ~0UL;
-	mm->free_area_cache = TASK_UNMAPPED_BASE;
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
+		info.high_limit = TASK_SIZE;
+		addr = vm_unmapped_area(&info);
+	}
 
 	return addr;
 }
_

Patches currently in -mm which might be from walken@google.com are

linux-next.patch
mm-add-anon_vma_lock-to-validate_mm.patch
mm-augment-vma-rbtree-with-rb_subtree_gap.patch
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
mm-use-vm_unmapped_area-on-mips-architecture.patch
mm-use-vm_unmapped_area-on-mips-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix.patch
mm-use-vm_unmapped_area-on-sh-architecture.patch
mm-use-vm_unmapped_area-on-sh-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc64-architecture.patch
mm-use-vm_unmapped_area-on-sparc64-architecture-fix.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-sparc64-architecture.patch
mm-use-vm_unmapped_area-on-sparc32-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture.patch

