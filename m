From: akpm@linux-foundation.org
Subject: + mm-use-vm_unmapped_area-on-mips-architecture.patch added to -mm tree
Date: Tue, 06 Nov 2012 14:39:36 -0800
Message-ID: <20121106223937.C78D35C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:62686 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2KFWjk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2012 17:39:40 -0500
Received: by mail-we0-f202.google.com with SMTP id x43so66937wey.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Nov 2012 14:39:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, cmetcalf@tilera.com, davem@davemloft.net, hpa@zytor.com, hughd@google.com, lethal@linux-sh.org, linux@arm.linux.org.uk, mingo@elte.hu, ralf@linux-mips.org, riel@redhat.com, tglx@linutronix.de


The patch titled
     Subject: mm: use vm_unmapped_area() on mips architecture
has been added to the -mm tree.  Its filename is
     mm-use-vm_unmapped_area-on-mips-architecture.patch

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
Subject: mm: use vm_unmapped_area() on mips architecture

Update the mips arch_get_unmapped_area[_topdown] functions to make use of
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

 arch/mips/mm/mmap.c |   99 +++++++-----------------------------------
 1 file changed, 17 insertions(+), 82 deletions(-)

diff -puN arch/mips/mm/mmap.c~mm-use-vm_unmapped_area-on-mips-architecture arch/mips/mm/mmap.c
--- a/arch/mips/mm/mmap.c~mm-use-vm_unmapped_area-on-mips-architecture
+++ a/arch/mips/mm/mmap.c
@@ -71,6 +71,7 @@ static unsigned long arch_get_unmapped_a
 	struct vm_area_struct *vma;
 	unsigned long addr = addr0;
 	int do_color_align;
+	struct vm_unmapped_area_info info;
 
 	if (unlikely(len > TASK_SIZE))
 		return -ENOMEM;
@@ -107,97 +108,31 @@ static unsigned long arch_get_unmapped_a
 			return addr;
 	}
 
-	if (dir == UP) {
-		addr = mm->mmap_base;
-		if (do_color_align)
-			addr = COLOUR_ALIGN(addr, pgoff);
-		else
-			addr = PAGE_ALIGN(addr);
-
-		for (vma = find_vma(current->mm, addr); ; vma = vma->vm_next) {
-			/* At this point:  (!vma || addr < vma->vm_end). */
-			if (TASK_SIZE - len < addr)
-				return -ENOMEM;
-			if (!vma || addr + len <= vma->vm_start)
-				return addr;
-			addr = vma->vm_end;
-			if (do_color_align)
-				addr = COLOUR_ALIGN(addr, pgoff);
-		 }
-	 } else {
-		/* check if free_area_cache is useful for us */
-		if (len <= mm->cached_hole_size) {
-			mm->cached_hole_size = 0;
-			mm->free_area_cache = mm->mmap_base;
-		}
-
-		/*
-		 * either no address requested, or the mapping can't fit into
-		 * the requested address hole
-		 */
-		addr = mm->free_area_cache;
-		if (do_color_align) {
-			unsigned long base =
-				COLOUR_ALIGN_DOWN(addr - len, pgoff);
-			addr = base + len;
-		}
-
-		/* make sure it can fit in the remaining address space */
-		if (likely(addr > len)) {
-			vma = find_vma(mm, addr - len);
-			if (!vma || addr <= vma->vm_start) {
-				/* cache the address as a hint for next time */
-				return mm->free_area_cache = addr - len;
-			}
-		}
-
-		if (unlikely(mm->mmap_base < len))
-			goto bottomup;
+	info.length = len;
+	info.align_mask = do_color_align ? (PAGE_MASK & shm_align_mask) : 0;
+	info.align_offset = pgoff << PAGE_SHIFT;
+
+	if (dir == DOWN) {
+		info.flags = VM_UNMAPPED_AREA_TOPDOWN;
+		info.low_limit = PAGE_SIZE;
+		info.high_limit = mm->mmap_base;
+		addr = vm_unmapped_area(&info);
 
-		addr = mm->mmap_base - len;
-		if (do_color_align)
-			addr = COLOUR_ALIGN_DOWN(addr, pgoff);
-
-		do {
-			/*
-			 * Lookup failure means no vma is above this address,
-			 * else if new region fits below vma->vm_start,
-			 * return with success:
-			 */
-			vma = find_vma(mm, addr);
-			if (likely(!vma || addr + len <= vma->vm_start)) {
-				/* cache the address as a hint for next time */
-				return mm->free_area_cache = addr;
-			}
-
-			/* remember the largest hole we saw so far */
-			if (addr + mm->cached_hole_size < vma->vm_start)
-				mm->cached_hole_size = vma->vm_start - addr;
-
-			/* try just below the current vma->vm_start */
-			addr = vma->vm_start - len;
-			if (do_color_align)
-				addr = COLOUR_ALIGN_DOWN(addr, pgoff);
-		} while (likely(len < vma->vm_start));
+		if (!(addr & ~PAGE_MASK))
+			return addr;
 
-bottomup:
 		/*
 		 * A failed mmap() very likely causes application failure,
 		 * so fall back to the bottom-up function here. This scenario
 		 * can happen with large stack limits and large mmap()
 		 * allocations.
 		 */
-		mm->cached_hole_size = ~0UL;
-		mm->free_area_cache = TASK_UNMAPPED_BASE;
-		addr = arch_get_unmapped_area(filp, addr0, len, pgoff, flags);
-		/*
-		 * Restore the topdown base:
-		 */
-		mm->free_area_cache = mm->mmap_base;
-		mm->cached_hole_size = ~0UL;
-
-		return addr;
 	}
+
+	info.flags = 0;
+	info.low_limit = mm->mmap_base;
+	info.high_limit = TASK_SIZE;
+	return vm_unmapped_area(&info);
 }
 
 unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr0,
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

