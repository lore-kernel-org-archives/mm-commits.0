From: akpm@linux-foundation.org
Subject: [merged] mm-vm_unmapped_area-lookup-function.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:59:17 -0800
Message-ID: <20121212195917.DA6B782004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:52715 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602Ab2LLT7T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 14:59:19 -0500
Received: by mail-yh0-f73.google.com with SMTP id 47so116923yhr.4
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 11:59:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, cmetcalf@tilera.com, davem@davemloft.net, hpa@zytor.com, hughd@google.com, lethal@linux-sh.org, linux@arm.linux.org.uk, mingo@elte.hu, ralf@linux-mips.org, riel@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vm_unmapped_area() lookup function
has been removed from the -mm tree.  Its filename was
     mm-vm_unmapped_area-lookup-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: vm_unmapped_area() lookup function

Implement vm_unmapped_area() using the rb_subtree_gap and highest_vm_end
information to look up for suitable virtual address space gaps.

struct vm_unmapped_area_info is used to define the desired allocation
request:
- lowest or highest possible address matching the remaining constraints
- desired gap length
- low/high address limits that the gap must fit into
- alignment mask and offset

Also update the generic arch_get_unmapped_area[_topdown] functions to make
use of vm_unmapped_area() instead of implementing a brute force search.

[akpm@linux-foundation.org: checkpatch fixes]
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

 include/linux/mm.h |   31 ++++
 mm/mmap.c          |  312 ++++++++++++++++++++++++++++++-------------
 2 files changed, 253 insertions(+), 90 deletions(-)

diff -puN include/linux/mm.h~mm-vm_unmapped_area-lookup-function include/linux/mm.h
--- a/include/linux/mm.h~mm-vm_unmapped_area-lookup-function
+++ a/include/linux/mm.h
@@ -1456,6 +1456,37 @@ extern unsigned long vm_mmap(struct file
         unsigned long, unsigned long,
         unsigned long, unsigned long);
 
+struct vm_unmapped_area_info {
+#define VM_UNMAPPED_AREA_TOPDOWN 1
+	unsigned long flags;
+	unsigned long length;
+	unsigned long low_limit;
+	unsigned long high_limit;
+	unsigned long align_mask;
+	unsigned long align_offset;
+};
+
+extern unsigned long unmapped_area(struct vm_unmapped_area_info *info);
+extern unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info);
+
+/*
+ * Search for an unmapped address range.
+ *
+ * We are looking for a range that:
+ * - does not intersect with any VMA;
+ * - is contained within the [low_limit, high_limit) interval;
+ * - is at least the desired size.
+ * - satisfies (begin_addr & align_mask) == (align_offset & align_mask)
+ */
+static inline unsigned long
+vm_unmapped_area(struct vm_unmapped_area_info *info)
+{
+	if (!(info->flags & VM_UNMAPPED_AREA_TOPDOWN))
+		return unmapped_area(info);
+	else
+		return unmapped_area_topdown(info);
+}
+
 /* truncate.c */
 extern void truncate_inode_pages(struct address_space *, loff_t);
 extern void truncate_inode_pages_range(struct address_space *,
diff -puN mm/mmap.c~mm-vm_unmapped_area-lookup-function mm/mmap.c
--- a/mm/mmap.c~mm-vm_unmapped_area-lookup-function
+++ a/mm/mmap.c
@@ -1539,6 +1539,206 @@ unacct_error:
 	return error;
 }
 
+unsigned long unmapped_area(struct vm_unmapped_area_info *info)
+{
+	/*
+	 * We implement the search by looking for an rbtree node that
+	 * immediately follows a suitable gap. That is,
+	 * - gap_start = vma->vm_prev->vm_end <= info->high_limit - length;
+	 * - gap_end   = vma->vm_start        >= info->low_limit  + length;
+	 * - gap_end - gap_start >= length
+	 */
+
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma;
+	unsigned long length, low_limit, high_limit, gap_start, gap_end;
+
+	/* Adjust search length to account for worst case alignment overhead */
+	length = info->length + info->align_mask;
+	if (length < info->length)
+		return -ENOMEM;
+
+	/* Adjust search limits by the desired length */
+	if (info->high_limit < length)
+		return -ENOMEM;
+	high_limit = info->high_limit - length;
+
+	if (info->low_limit > high_limit)
+		return -ENOMEM;
+	low_limit = info->low_limit + length;
+
+	/* Check if rbtree root looks promising */
+	if (RB_EMPTY_ROOT(&mm->mm_rb))
+		goto check_highest;
+	vma = rb_entry(mm->mm_rb.rb_node, struct vm_area_struct, vm_rb);
+	if (vma->rb_subtree_gap < length)
+		goto check_highest;
+
+	while (true) {
+		/* Visit left subtree if it looks promising */
+		gap_end = vma->vm_start;
+		if (gap_end >= low_limit && vma->vm_rb.rb_left) {
+			struct vm_area_struct *left =
+				rb_entry(vma->vm_rb.rb_left,
+					 struct vm_area_struct, vm_rb);
+			if (left->rb_subtree_gap >= length) {
+				vma = left;
+				continue;
+			}
+		}
+
+		gap_start = vma->vm_prev ? vma->vm_prev->vm_end : 0;
+check_current:
+		/* Check if current node has a suitable gap */
+		if (gap_start > high_limit)
+			return -ENOMEM;
+		if (gap_end >= low_limit && gap_end - gap_start >= length)
+			goto found;
+
+		/* Visit right subtree if it looks promising */
+		if (vma->vm_rb.rb_right) {
+			struct vm_area_struct *right =
+				rb_entry(vma->vm_rb.rb_right,
+					 struct vm_area_struct, vm_rb);
+			if (right->rb_subtree_gap >= length) {
+				vma = right;
+				continue;
+			}
+		}
+
+		/* Go back up the rbtree to find next candidate node */
+		while (true) {
+			struct rb_node *prev = &vma->vm_rb;
+			if (!rb_parent(prev))
+				goto check_highest;
+			vma = rb_entry(rb_parent(prev),
+				       struct vm_area_struct, vm_rb);
+			if (prev == vma->vm_rb.rb_left) {
+				gap_start = vma->vm_prev->vm_end;
+				gap_end = vma->vm_start;
+				goto check_current;
+			}
+		}
+	}
+
+check_highest:
+	/* Check highest gap, which does not precede any rbtree node */
+	gap_start = mm->highest_vm_end;
+	gap_end = ULONG_MAX;  /* Only for VM_BUG_ON below */
+	if (gap_start > high_limit)
+		return -ENOMEM;
+
+found:
+	/* We found a suitable gap. Clip it with the original low_limit. */
+	if (gap_start < info->low_limit)
+		gap_start = info->low_limit;
+
+	/* Adjust gap address to the desired alignment */
+	gap_start += (info->align_offset - gap_start) & info->align_mask;
+
+	VM_BUG_ON(gap_start + info->length > info->high_limit);
+	VM_BUG_ON(gap_start + info->length > gap_end);
+	return gap_start;
+}
+
+unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
+{
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma;
+	unsigned long length, low_limit, high_limit, gap_start, gap_end;
+
+	/* Adjust search length to account for worst case alignment overhead */
+	length = info->length + info->align_mask;
+	if (length < info->length)
+		return -ENOMEM;
+
+	/*
+	 * Adjust search limits by the desired length.
+	 * See implementation comment at top of unmapped_area().
+	 */
+	gap_end = info->high_limit;
+	if (gap_end < length)
+		return -ENOMEM;
+	high_limit = gap_end - length;
+
+	if (info->low_limit > high_limit)
+		return -ENOMEM;
+	low_limit = info->low_limit + length;
+
+	/* Check highest gap, which does not precede any rbtree node */
+	gap_start = mm->highest_vm_end;
+	if (gap_start <= high_limit)
+		goto found_highest;
+
+	/* Check if rbtree root looks promising */
+	if (RB_EMPTY_ROOT(&mm->mm_rb))
+		return -ENOMEM;
+	vma = rb_entry(mm->mm_rb.rb_node, struct vm_area_struct, vm_rb);
+	if (vma->rb_subtree_gap < length)
+		return -ENOMEM;
+
+	while (true) {
+		/* Visit right subtree if it looks promising */
+		gap_start = vma->vm_prev ? vma->vm_prev->vm_end : 0;
+		if (gap_start <= high_limit && vma->vm_rb.rb_right) {
+			struct vm_area_struct *right =
+				rb_entry(vma->vm_rb.rb_right,
+					 struct vm_area_struct, vm_rb);
+			if (right->rb_subtree_gap >= length) {
+				vma = right;
+				continue;
+			}
+		}
+
+check_current:
+		/* Check if current node has a suitable gap */
+		gap_end = vma->vm_start;
+		if (gap_end < low_limit)
+			return -ENOMEM;
+		if (gap_start <= high_limit && gap_end - gap_start >= length)
+			goto found;
+
+		/* Visit left subtree if it looks promising */
+		if (vma->vm_rb.rb_left) {
+			struct vm_area_struct *left =
+				rb_entry(vma->vm_rb.rb_left,
+					 struct vm_area_struct, vm_rb);
+			if (left->rb_subtree_gap >= length) {
+				vma = left;
+				continue;
+			}
+		}
+
+		/* Go back up the rbtree to find next candidate node */
+		while (true) {
+			struct rb_node *prev = &vma->vm_rb;
+			if (!rb_parent(prev))
+				return -ENOMEM;
+			vma = rb_entry(rb_parent(prev),
+				       struct vm_area_struct, vm_rb);
+			if (prev == vma->vm_rb.rb_right) {
+				gap_start = vma->vm_prev ?
+					vma->vm_prev->vm_end : 0;
+				goto check_current;
+			}
+		}
+	}
+
+found:
+	/* We found a suitable gap. Clip it with the original high_limit. */
+	if (gap_end > info->high_limit)
+		gap_end = info->high_limit;
+
+found_highest:
+	/* Compute highest gap address at the desired alignment */
+	gap_end -= info->length;
+	gap_end -= (gap_end - info->align_offset) & info->align_mask;
+
+	VM_BUG_ON(gap_end < info->low_limit);
+	VM_BUG_ON(gap_end < gap_start);
+	return gap_end;
+}
+
 /* Get an address range which is currently unmapped.
  * For shmat() with addr=0.
  *
@@ -1557,7 +1757,7 @@ arch_get_unmapped_area(struct file *filp
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
-	unsigned long start_addr;
+	struct vm_unmapped_area_info info;
 
 	if (len > TASK_SIZE)
 		return -ENOMEM;
@@ -1572,40 +1772,13 @@ arch_get_unmapped_area(struct file *filp
 		    (!vma || addr + len <= vma->vm_start))
 			return addr;
 	}
-	if (len > mm->cached_hole_size) {
-	        start_addr = addr = mm->free_area_cache;
-	} else {
-	        start_addr = addr = TASK_UNMAPPED_BASE;
-	        mm->cached_hole_size = 0;
-	}
 
-full_search:
-	for (vma = find_vma(mm, addr); ; vma = vma->vm_next) {
-		/* At this point:  (!vma || addr < vma->vm_end). */
-		if (TASK_SIZE - len < addr) {
-			/*
-			 * Start a new search - just in case we missed
-			 * some holes.
-			 */
-			if (start_addr != TASK_UNMAPPED_BASE) {
-				addr = TASK_UNMAPPED_BASE;
-			        start_addr = addr;
-				mm->cached_hole_size = 0;
-				goto full_search;
-			}
-			return -ENOMEM;
-		}
-		if (!vma || addr + len <= vma->vm_start) {
-			/*
-			 * Remember the place where we stopped the search:
-			 */
-			mm->free_area_cache = addr + len;
-			return addr;
-		}
-		if (addr + mm->cached_hole_size < vma->vm_start)
-		        mm->cached_hole_size = vma->vm_start - addr;
-		addr = vma->vm_end;
-	}
+	info.flags = 0;
+	info.length = len;
+	info.low_limit = TASK_UNMAPPED_BASE;
+	info.high_limit = TASK_SIZE;
+	info.align_mask = 0;
+	return vm_unmapped_area(&info);
 }
 #endif	
 
@@ -1630,7 +1803,8 @@ arch_get_unmapped_area_topdown(struct fi
 {
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
-	unsigned long addr = addr0, start_addr;
+	unsigned long addr = addr0;
+	struct vm_unmapped_area_info info;
 
 	/* requested length too big for entire address space */
 	if (len > TASK_SIZE)
@@ -1648,53 +1822,12 @@ arch_get_unmapped_area_topdown(struct fi
 			return addr;
 	}
 
-	/* check if free_area_cache is useful for us */
-	if (len <= mm->cached_hole_size) {
- 	        mm->cached_hole_size = 0;
- 		mm->free_area_cache = mm->mmap_base;
- 	}
-
-try_again:
-	/* either no address requested or can't fit in requested address hole */
-	start_addr = addr = mm->free_area_cache;
-
-	if (addr < len)
-		goto fail;
-
-	addr -= len;
-	do {
-		/*
-		 * Lookup failure means no vma is above this address,
-		 * else if new region fits below vma->vm_start,
-		 * return with success:
-		 */
-		vma = find_vma(mm, addr);
-		if (!vma || addr+len <= vma->vm_start)
-			/* remember the address as a hint for next time */
-			return (mm->free_area_cache = addr);
-
- 		/* remember the largest hole we saw so far */
- 		if (addr + mm->cached_hole_size < vma->vm_start)
- 		        mm->cached_hole_size = vma->vm_start - addr;
-
-		/* try just below the current vma->vm_start */
-		addr = vma->vm_start-len;
-	} while (len < vma->vm_start);
-
-fail:
-	/*
-	 * if hint left us with no space for the requested
-	 * mapping then try again:
-	 *
-	 * Note: this is different with the case of bottomup
-	 * which does the fully line-search, but we use find_vma
-	 * here that causes some holes skipped.
-	 */
-	if (start_addr != mm->mmap_base) {
-		mm->free_area_cache = mm->mmap_base;
-		mm->cached_hole_size = 0;
-		goto try_again;
-	}
+	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
+	info.length = len;
+	info.low_limit = PAGE_SIZE;
+	info.high_limit = mm->mmap_base;
+	info.align_mask = 0;
+	addr = vm_unmapped_area(&info);
 
 	/*
 	 * A failed mmap() very likely causes application failure,
@@ -1702,14 +1835,13 @@ fail:
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
+		info.high_limit = TASK_SIZE;
+		addr = vm_unmapped_area(&info);
+	}
 
 	return addr;
 }
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

