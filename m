From: akpm@linux-foundation.org
Subject: + mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture.patch added to -mm tree
Date: Tue, 06 Nov 2012 14:39:33 -0800
Message-ID: <20121106223934.3CC3F100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:64120 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2KFWjf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2012 17:39:35 -0500
Received: by mail-gh0-f202.google.com with SMTP id z15so108589ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Nov 2012 14:39:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, cmetcalf@tilera.com, davem@davemloft.net, hpa@zytor.com, hughd@google.com, lethal@linux-sh.org, linux@arm.linux.org.uk, mingo@elte.hu, ralf@linux-mips.org, riel@redhat.com, tglx@linutronix.de


The patch titled
     Subject: mm: use vm_unmapped_area() in hugetlbfs on i386 architecture
has been added to the -mm tree.  Its filename is
     mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture.patch

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
Subject: mm: use vm_unmapped_area() in hugetlbfs on i386 architecture

Update the i386 hugetlb_get_unmapped_area function to make use of
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

 arch/x86/mm/hugetlbpage.c |  128 ++++++------------------------------
 1 file changed, 24 insertions(+), 104 deletions(-)

diff -puN arch/x86/mm/hugetlbpage.c~mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture arch/x86/mm/hugetlbpage.c
--- a/arch/x86/mm/hugetlbpage.c~mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture
+++ a/arch/x86/mm/hugetlbpage.c
@@ -274,42 +274,15 @@ static unsigned long hugetlb_get_unmappe
 		unsigned long pgoff, unsigned long flags)
 {
 	struct hstate *h = hstate_file(file);
-	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
-	unsigned long start_addr;
-
-	if (len > mm->cached_hole_size) {
-	        start_addr = mm->free_area_cache;
-	} else {
-	        start_addr = TASK_UNMAPPED_BASE;
-	        mm->cached_hole_size = 0;
-	}
-
-full_search:
-	addr = ALIGN(start_addr, huge_page_size(h));
+	struct vm_unmapped_area_info info;
 
-	for (vma = find_vma(mm, addr); ; vma = vma->vm_next) {
-		/* At this point:  (!vma || addr < vma->vm_end). */
-		if (TASK_SIZE - len < addr) {
-			/*
-			 * Start a new search - just in case we missed
-			 * some holes.
-			 */
-			if (start_addr != TASK_UNMAPPED_BASE) {
-				start_addr = TASK_UNMAPPED_BASE;
-				mm->cached_hole_size = 0;
-				goto full_search;
-			}
-			return -ENOMEM;
-		}
-		if (!vma || addr + len <= vma->vm_start) {
-			mm->free_area_cache = addr + len;
-			return addr;
-		}
-		if (addr + mm->cached_hole_size < vma->vm_start)
-		        mm->cached_hole_size = vma->vm_start - addr;
-		addr = ALIGN(vma->vm_end, huge_page_size(h));
-	}
+	info.flags = 0;
+	info.length = len;
+	info.low_limit = TASK_UNMAPPED_BASE;
+	info.high_limit = TASK_SIZE;
+	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
+	info.align_offset = 0;
+	return vm_unmapped_area(&info);
 }
 
 static unsigned long hugetlb_get_unmapped_area_topdown(struct file *file,
@@ -317,83 +290,30 @@ static unsigned long hugetlb_get_unmappe
 		unsigned long pgoff, unsigned long flags)
 {
 	struct hstate *h = hstate_file(file);
-	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
-	unsigned long base = mm->mmap_base;
-	unsigned long addr = addr0;
-	unsigned long largest_hole = mm->cached_hole_size;
-	unsigned long start_addr;
-
-	/* don't allow allocations above current base */
-	if (mm->free_area_cache > base)
-		mm->free_area_cache = base;
-
-	if (len <= largest_hole) {
-	        largest_hole = 0;
-		mm->free_area_cache  = base;
-	}
-try_again:
-	start_addr = mm->free_area_cache;
+	struct vm_unmapped_area_info info;
+	unsigned long addr;
 
-	/* make sure it can fit in the remaining address space */
-	if (mm->free_area_cache < len)
-		goto fail;
-
-	/* either no address requested or can't fit in requested address hole */
-	addr = (mm->free_area_cache - len) & huge_page_mask(h);
-	do {
-		/*
-		 * Lookup failure means no vma is above this address,
-		 * i.e. return with success:
-		 */
-		vma = find_vma(mm, addr);
-		if (!vma)
-			return addr;
-
-		if (addr + len <= vma->vm_start) {
-			/* remember the address as a hint for next time */
-		        mm->cached_hole_size = largest_hole;
-		        return (mm->free_area_cache = addr);
-		} else if (mm->free_area_cache == vma->vm_end) {
-			/* pull free_area_cache down to the first hole */
-			mm->free_area_cache = vma->vm_start;
-			mm->cached_hole_size = largest_hole;
-		}
-
-		/* remember the largest hole we saw so far */
-		if (addr + largest_hole < vma->vm_start)
-		        largest_hole = vma->vm_start - addr;
-
-		/* try just below the current vma->vm_start */
-		addr = (vma->vm_start - len) & huge_page_mask(h);
-	} while (len <= vma->vm_start);
+	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
+	info.length = len;
+	info.low_limit = PAGE_SIZE;
+	info.high_limit = mm->mmap_base;
+	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
+	info.align_offset = 0;
+	addr = vm_unmapped_area(&info);
 
-fail:
-	/*
-	 * if hint left us with no space for the requested
-	 * mapping then try again:
-	 */
-	if (start_addr != base) {
-		mm->free_area_cache = base;
-		largest_hole = 0;
-		goto try_again;
-	}
 	/*
 	 * A failed mmap() very likely causes application failure,
 	 * so fall back to the bottom-up function here. This scenario
 	 * can happen with large stack limits and large mmap()
 	 * allocations.
 	 */
-	mm->free_area_cache = TASK_UNMAPPED_BASE;
-	mm->cached_hole_size = ~0UL;
-	addr = hugetlb_get_unmapped_area_bottomup(file, addr0,
-			len, pgoff, flags);
-
-	/*
-	 * Restore the topdown base:
-	 */
-	mm->free_area_cache = base;
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

