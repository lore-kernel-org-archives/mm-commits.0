From: akpm@linux-foundation.org
Subject: [merged] mm-use-vm_unmapped_area-on-mips-architecture.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:59:41 -0800
Message-ID: <20121212195941.D3405100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:48987 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab2LLT7n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 14:59:43 -0500
Received: by mail-yh0-f74.google.com with SMTP id 10so116058yhl.5
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 11:59:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, cmetcalf@tilera.com, davem@davemloft.net, hpa@zytor.com, hughd@google.com, lethal@linux-sh.org, linux@arm.linux.org.uk, mingo@elte.hu, ralf@linux-mips.org, riel@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use vm_unmapped_area() on mips architecture
has been removed from the -mm tree.  Its filename was
     mm-use-vm_unmapped_area-on-mips-architecture.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: use vm_unmapped_area() on mips architecture

Update the mips arch_get_unmapped_area[_topdown] functions to make use of
vm_unmapped_area() instead of implementing a brute force search.

[akpm@linux-foundation.org: remove now-unused COLOUR_ALIGN_DOWN()]
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

 arch/mips/mm/mmap.c |  111 ++++++------------------------------------
 1 file changed, 17 insertions(+), 94 deletions(-)

diff -puN arch/mips/mm/mmap.c~mm-use-vm_unmapped_area-on-mips-architecture arch/mips/mm/mmap.c
--- a/arch/mips/mm/mmap.c~mm-use-vm_unmapped_area-on-mips-architecture
+++ a/arch/mips/mm/mmap.c
@@ -45,18 +45,6 @@ static unsigned long mmap_base(unsigned 
 	return PAGE_ALIGN(TASK_SIZE - gap - rnd);
 }
 
-static inline unsigned long COLOUR_ALIGN_DOWN(unsigned long addr,
-					      unsigned long pgoff)
-{
-	unsigned long base = addr & ~shm_align_mask;
-	unsigned long off = (pgoff << PAGE_SHIFT) & shm_align_mask;
-
-	if (base + off <= addr)
-		return base + off;
-
-	return base - off;
-}
-
 #define COLOUR_ALIGN(addr, pgoff)				\
 	((((addr) + shm_align_mask) & ~shm_align_mask) +	\
 	 (((pgoff) << PAGE_SHIFT) & shm_align_mask))
@@ -71,6 +59,7 @@ static unsigned long arch_get_unmapped_a
 	struct vm_area_struct *vma;
 	unsigned long addr = addr0;
 	int do_color_align;
+	struct vm_unmapped_area_info info;
 
 	if (unlikely(len > TASK_SIZE))
 		return -ENOMEM;
@@ -107,97 +96,31 @@ static unsigned long arch_get_unmapped_a
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

