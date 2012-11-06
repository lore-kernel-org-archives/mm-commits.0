From: akpm@linux-foundation.org
Subject: + mm-augment-vma-rbtree-with-rb_subtree_gap.patch added to -mm tree
Date: Tue, 06 Nov 2012 14:38:51 -0800
Message-ID: <20121106223851.DB99920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:55965 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab2KFWiz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2012 17:38:55 -0500
Received: by mail-ee0-f74.google.com with SMTP id b57so67741eek.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Nov 2012 14:38:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, cmetcalf@tilera.com, davem@davemloft.net, hpa@zytor.com, hughd@google.com, lethal@linux-sh.org, linux@arm.linux.org.uk, mingo@elte.hu, ralf@linux-mips.org, riel@redhat.com, tglx@linutronix.de


The patch titled
     Subject: mm: augment vma rbtree with rb_subtree_gap
has been added to the -mm tree.  Its filename is
     mm-augment-vma-rbtree-with-rb_subtree_gap.patch

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
Subject: mm: augment vma rbtree with rb_subtree_gap

Define vma->rb_subtree_gap as the largest gap between any vma in the
subtree rooted at that vma, and their predecessor.  Or, for a recursive
definition, vma->rb_subtree_gap is the max of:

- vma->vm_start - vma->vm_prev->vm_end
- rb_subtree_gap fields of the vmas pointed by vma->rb.rb_left and
  vma->rb.rb_right

This will allow get_unmapped_area_* to find a free area of the right size
in O(log(N)) time, instead of potentially having to do a linear walk
across all the VMAs.

Also define mm->highest_vm_end as the vm_end field of the highest vma, so
that we can easily check if the following gap is suitable.

This does have the potential to make unmapping VMAs more expensive,
especially for processes with very large numbers of VMAs, where the VMA
rbtree can grow quite deep.

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

 include/linux/mm_types.h |    9 ++
 mm/mmap.c                |  114 ++++++++++++++++++++++++++++++++++---
 2 files changed, 114 insertions(+), 9 deletions(-)

diff -puN include/linux/mm_types.h~mm-augment-vma-rbtree-with-rb_subtree_gap include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-augment-vma-rbtree-with-rb_subtree_gap
+++ a/include/linux/mm_types.h
@@ -240,6 +240,14 @@ struct vm_area_struct {
 	struct rb_node vm_rb;
 
 	/*
+	 * Largest free memory gap in bytes to the left of this VMA.
+	 * Either between this VMA and vma->vm_prev, or between one of the
+	 * VMAs below us in the VMA rbtree and its ->vm_prev. This helps
+	 * get_unmapped_area find a free area of the right size.
+	 */
+	unsigned long rb_subtree_gap;
+
+	/*
 	 * For areas with an address space and backing store,
 	 * linkage into the address_space->i_mmap interval tree, or
 	 * linkage of vma in the address_space->i_mmap_nonlinear list.
@@ -324,6 +332,7 @@ struct mm_struct {
 	unsigned long task_size;		/* size of task vm space */
 	unsigned long cached_hole_size; 	/* if non-zero, the largest hole below free_area_cache */
 	unsigned long free_area_cache;		/* first hole of size cached_hole_size or larger */
+	unsigned long highest_vm_end;		/* highest vma end address */
 	pgd_t * pgd;
 	atomic_t mm_users;			/* How many users with user space? */
 	atomic_t mm_count;			/* How many references to "struct mm_struct" (users count as 1) */
diff -puN mm/mmap.c~mm-augment-vma-rbtree-with-rb_subtree_gap mm/mmap.c
--- a/mm/mmap.c~mm-augment-vma-rbtree-with-rb_subtree_gap
+++ a/mm/mmap.c
@@ -31,6 +31,7 @@
 #include <linux/audit.h>
 #include <linux/khugepaged.h>
 #include <linux/uprobes.h>
+#include <linux/rbtree_augmented.h>
 
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
@@ -297,6 +298,70 @@ out:
 	return retval;
 }
 
+static long vma_compute_subtree_gap(struct vm_area_struct *vma)
+{
+	unsigned long max, subtree_gap;
+	max = vma->vm_start;
+	if (vma->vm_prev)
+		max -= vma->vm_prev->vm_end;
+	if (vma->vm_rb.rb_left) {
+		subtree_gap = rb_entry(vma->vm_rb.rb_left,
+				struct vm_area_struct, vm_rb)->rb_subtree_gap;
+		if (subtree_gap > max)
+			max = subtree_gap;
+	}
+	if (vma->vm_rb.rb_right) {
+		subtree_gap = rb_entry(vma->vm_rb.rb_right,
+				struct vm_area_struct, vm_rb)->rb_subtree_gap;
+		if (subtree_gap > max)
+			max = subtree_gap;
+	}
+	return max;
+}
+
+RB_DECLARE_CALLBACKS(static, vma_gap_callbacks, struct vm_area_struct, vm_rb,
+		     unsigned long, rb_subtree_gap, vma_compute_subtree_gap)
+
+/*
+ * Update augmented rbtree rb_subtree_gap values after vma->vm_start or
+ * vma->vm_prev->vm_end values changed, without modifying the vma's position
+ * in the rbtree.
+ */
+static void vma_gap_update(struct vm_area_struct *vma)
+{
+	/*
+	 * As it turns out, RB_DECLARE_CALLBACKS() already created a callback
+	 * function that does exacltly what we want.
+	 */
+	vma_gap_callbacks_propagate(&vma->vm_rb, NULL);
+}
+
+static inline void vma_rb_insert(struct vm_area_struct *vma,
+				 struct rb_root *root)
+{
+	/*
+	 * vma->vm_prev wasn't known when we followed the rbtree to find the
+	 * correct insertion point for that vma. As a result, we could not
+	 * update the vma vm_rb parents rb_subtree_gap values on the way down.
+	 * So, we first insert the vma with a zero rb_subtree_gap value
+	 * (to be consistent with what we did on the way down), and then
+	 * immediately update the gap to the correct value.
+	 */
+	vma->rb_subtree_gap = 0;
+	rb_insert_augmented(&vma->vm_rb, root, &vma_gap_callbacks);
+	vma_gap_update(vma);
+}
+
+static void vma_rb_erase(struct vm_area_struct *vma, struct rb_root *root)
+{
+	/*
+	 * Note rb_erase_augmented is a fairly large inline function,
+	 * so make sure we instantiate it only once with our desired
+	 * augmented rbtree callbacks.
+	 */
+	rb_erase_augmented(&vma->vm_rb, root, &vma_gap_callbacks);
+}
+
 #ifdef CONFIG_DEBUG_VM_RB
 static int browse_rb(struct rb_root *root)
 {
@@ -422,7 +487,11 @@ void __vma_link_rb(struct mm_struct *mm,
 		struct rb_node **rb_link, struct rb_node *rb_parent)
 {
 	rb_link_node(&vma->vm_rb, rb_parent, rb_link);
-	rb_insert_color(&vma->vm_rb, &mm->mm_rb);
+	vma_rb_insert(vma, &mm->mm_rb);
+	if (vma->vm_next)
+		vma_gap_update(vma->vm_next);
+	else
+		mm->highest_vm_end = vma->vm_end;
 }
 
 static void __vma_link_file(struct vm_area_struct *vma)
@@ -503,7 +572,7 @@ __vma_unlink(struct mm_struct *mm, struc
 	prev->vm_next = next;
 	if (next)
 		next->vm_prev = prev;
-	rb_erase(&vma->vm_rb, &mm->mm_rb);
+	vma_rb_erase(vma, &mm->mm_rb);
 	if (mm->mmap_cache == vma)
 		mm->mmap_cache = prev;
 }
@@ -525,6 +594,7 @@ int vma_adjust(struct vm_area_struct *vm
 	struct rb_root *root = NULL;
 	struct anon_vma *anon_vma = NULL;
 	struct file *file = vma->vm_file;
+	bool start_changed = false, end_changed = false;
 	long adjust_next = 0;
 	int remove_next = 0;
 
@@ -615,8 +685,14 @@ again:			remove_next = 1 + (end > next->
 			vma_interval_tree_remove(next, root);
 	}
 
-	vma->vm_start = start;
-	vma->vm_end = end;
+	if (start != vma->vm_start) {
+		vma->vm_start = start;
+		start_changed = true;
+	}
+	if (end != vma->vm_end) {
+		vma->vm_end = end;
+		end_changed = true;
+	}
 	vma->vm_pgoff = pgoff;
 	if (adjust_next) {
 		next->vm_start += adjust_next << PAGE_SHIFT;
@@ -645,6 +721,15 @@ again:			remove_next = 1 + (end > next->
 		 * (it may either follow vma or precede it).
 		 */
 		__insert_vm_struct(mm, insert);
+	} else {
+		if (start_changed)
+			vma_gap_update(vma);
+		if (end_changed) {
+			if (!next)
+				mm->highest_vm_end = end;
+			else if (!adjust_next)
+				vma_gap_update(next);
+		}
 	}
 
 	if (anon_vma) {
@@ -678,10 +763,13 @@ again:			remove_next = 1 + (end > next->
 		 * we must remove another next too. It would clutter
 		 * up the code too much to do both in one go.
 		 */
-		if (remove_next == 2) {
-			next = vma->vm_next;
+		next = vma->vm_next;
+		if (remove_next == 2)
 			goto again;
-		}
+		else if (next)
+			vma_gap_update(next);
+		else
+			mm->highest_vm_end = end;
 	}
 	if (insert && file)
 		uprobe_mmap(insert);
@@ -1784,6 +1872,10 @@ int expand_upwards(struct vm_area_struct
 				anon_vma_interval_tree_pre_update_vma(vma);
 				vma->vm_end = address;
 				anon_vma_interval_tree_post_update_vma(vma);
+				if (vma->vm_next)
+					vma_gap_update(vma->vm_next);
+				else
+					mm->highest_vm_end = address;
 				perf_event_mmap(vma);
 			}
 		}
@@ -1838,6 +1930,7 @@ int expand_downwards(struct vm_area_stru
 				vma->vm_start = address;
 				vma->vm_pgoff -= grow;
 				anon_vma_interval_tree_post_update_vma(vma);
+				vma_gap_update(vma);
 				perf_event_mmap(vma);
 			}
 		}
@@ -1960,14 +2053,17 @@ detach_vmas_to_be_unmapped(struct mm_str
 	insertion_point = (prev ? &prev->vm_next : &mm->mmap);
 	vma->vm_prev = NULL;
 	do {
-		rb_erase(&vma->vm_rb, &mm->mm_rb);
+		vma_rb_erase(vma, &mm->mm_rb);
 		mm->map_count--;
 		tail_vma = vma;
 		vma = vma->vm_next;
 	} while (vma && vma->vm_start < end);
 	*insertion_point = vma;
-	if (vma)
+	if (vma) {
 		vma->vm_prev = prev;
+		vma_gap_update(vma);
+	} else
+		mm->highest_vm_end = prev ? prev->vm_end : 0;
 	tail_vma->vm_next = NULL;
 	if (mm->unmap_area == arch_unmap_area)
 		addr = prev ? prev->vm_end : mm->mmap_base;
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

