From: akpm@linux-foundation.org
Subject: + mm-augment-vma-rbtree-with-rb_subtree_gap-ensure-safe-rb_subtree_gap-update-when-inserting-new-vma.patch added to -mm tree
Date: Mon, 12 Nov 2012 16:24:24 -0800
Message-ID: <20121113002425.4429C100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:51246 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab2KMAY0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Nov 2012 19:24:26 -0500
Received: by mail-gg0-f202.google.com with SMTP id i4so796047ggm.1
        for <mm-commits@vger.kernel.org>; Mon, 12 Nov 2012 16:24:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, hughd@google.com, riel@redhat.com, sasha.levin@oracle.com


The patch titled
     Subject: mm: ensure safe rb_subtree_gap update when inserting new VMA
has been added to the -mm tree.  Its filename is
     mm-augment-vma-rbtree-with-rb_subtree_gap-ensure-safe-rb_subtree_gap-update-when-inserting-new-vma.patch

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
Subject: mm: ensure safe rb_subtree_gap update when inserting new VMA

Using the trinity fuzzer, Sasha Levin uncovered a case where
rb_subtree_gap wasn't correctly updated.

Digging into this, the root cause was that vma insertions and removals
require both an rbtree insert or erase operation (which may trigger tree
rotations), and an update of the next vma's gap (which does not change the
tree topology, but may require iterating on the node's ancestors to
propagate the update).  The rbtree rotations caused the rb_subtree_gap
values to be updated in some of the internal nodes, but without upstream
propagation.  Then the subsequent update on the next vma didn't iterate as
high up the tree as it should have, as it stopped as soon as it hit one of
the internal nodes that had been updated as part of a tree rotation.

The fix is to impose that all rb_subtree_gap values must be up to date
before any rbtree insertion or erase, with the possible exception that the
node being erased doesn't need to have an up to date rb_subtree_gap.

This change: during vma insertion, make sure to update the rb_subtree_gap
values for both the current and next vmas prior to rebalancing the rbtree
to account for the just-inserted vma.

(Thanks to Sasha Levin for uncovering the problem and to Hugh Dickins
for coming up with a simpler test case)

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff -puN mm/mmap.c~mm-augment-vma-rbtree-with-rb_subtree_gap-ensure-safe-rb_subtree_gap-update-when-inserting-new-vma mm/mmap.c
--- a/mm/mmap.c~mm-augment-vma-rbtree-with-rb_subtree_gap-ensure-safe-rb_subtree_gap-update-when-inserting-new-vma
+++ a/mm/mmap.c
@@ -339,17 +339,7 @@ static void vma_gap_update(struct vm_are
 static inline void vma_rb_insert(struct vm_area_struct *vma,
 				 struct rb_root *root)
 {
-	/*
-	 * vma->vm_prev wasn't known when we followed the rbtree to find the
-	 * correct insertion point for that vma. As a result, we could not
-	 * update the vma vm_rb parents rb_subtree_gap values on the way down.
-	 * So, we first insert the vma with a zero rb_subtree_gap value
-	 * (to be consistent with what we did on the way down), and then
-	 * immediately update the gap to the correct value.
-	 */
-	vma->rb_subtree_gap = 0;
 	rb_insert_augmented(&vma->vm_rb, root, &vma_gap_callbacks);
-	vma_gap_update(vma);
 }
 
 static void vma_rb_erase(struct vm_area_struct *vma, struct rb_root *root)
@@ -486,12 +476,25 @@ static int find_vma_links(struct mm_stru
 void __vma_link_rb(struct mm_struct *mm, struct vm_area_struct *vma,
 		struct rb_node **rb_link, struct rb_node *rb_parent)
 {
-	rb_link_node(&vma->vm_rb, rb_parent, rb_link);
-	vma_rb_insert(vma, &mm->mm_rb);
+	/* Update tracking information for the gap following the new vma. */
 	if (vma->vm_next)
 		vma_gap_update(vma->vm_next);
 	else
 		mm->highest_vm_end = vma->vm_end;
+
+	/*
+	 * vma->vm_prev wasn't known when we followed the rbtree to find the
+	 * correct insertion point for that vma. As a result, we could not
+	 * update the vma vm_rb parents rb_subtree_gap values on the way down.
+	 * So, we first insert the vma with a zero rb_subtree_gap value
+	 * (to be consistent with what we did on the way down), and then
+	 * immediately update the gap to the correct value. Finally we
+	 * rebalance the rbtree after all augmented values have been set.
+	 */
+	rb_link_node(&vma->vm_rb, rb_parent, rb_link);
+	vma->rb_subtree_gap = 0;
+	vma_gap_update(vma);
+	vma_rb_insert(vma, &mm->mm_rb);
 }
 
 static void __vma_link_file(struct vm_area_struct *vma)
_

Patches currently in -mm which might be from walken@google.com are

linux-next.patch
mm-add-anon_vma_lock-to-validate_mm.patch
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
mm-use-vm_unmapped_area-on-sh-architecture.patch
mm-use-vm_unmapped_area-on-sh-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc64-architecture.patch
mm-use-vm_unmapped_area-on-sparc64-architecture-fix.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-sparc64-architecture.patch
mm-use-vm_unmapped_area-on-sparc32-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture.patch

