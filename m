From: akpm@linux-foundation.org
Subject: + mm-augment-vma-rbtree-with-rb_subtree_gap--debug-code-to-verify-rb_subtree_gap-updates-are-safe.patch added to -mm tree
Date: Mon, 12 Nov 2012 16:24:31 -0800
Message-ID: <20121113002431.6B69A100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:51246 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab2KMAYc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Nov 2012 19:24:32 -0500
Received: by mail-gg0-f202.google.com with SMTP id i4so796047ggm.1
        for <mm-commits@vger.kernel.org>; Mon, 12 Nov 2012 16:24:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, hughd@google.com, riel@redhat.com, sasha.levin@oracle.com


The patch titled
     Subject: mm: debug code to verify rb_subtree_gap updates are safe
has been added to the -mm tree.  Its filename is
     mm-augment-vma-rbtree-with-rb_subtree_gap--debug-code-to-verify-rb_subtree_gap-updates-are-safe.patch

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
Subject: mm: debug code to verify rb_subtree_gap updates are safe

Using the trinity fuzzer, Sasha Levin uncovered a case where
rb_subtree_gap wasn't correctly updated.

Digging into this, the root cause was that vma insertions and removals
require both an rbtree insert or erase operation (which may trigger
tree rotations), and an update of the next vma's gap (which does not
change the tree topology, but may require iterating on the node's
ancestors to propagate the update). The rbtree rotations caused the
rb_subtree_gap values to be updated in some of the internal nodes, but
without upstream propagation. Then the subsequent update on the next
vma didn't iterate as high up the tree as it should have, as it
stopped as soon as it hit one of the internal nodes that had been
updated as part of a tree rotation.

The fix is to impose that all rb_subtree_gap values must be up to date
before any rbtree insertion or erase, with the possible exception that
the node being erased doesn't need to have an up to date rb_subtree_gap.

This change: introduce validate_mm_rb() to verify that the rbtree does
not include any stale rb_subtree_gap values before node insertion or
erase, so as to avoid the issue where a subsequent vma_gap_update() would
fail to propagate the rb_subtree_gap updates as high up as necessary.

Signed-off-by: Michel Lespinasse <walken@google.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   88 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 55 insertions(+), 33 deletions(-)

diff -puN mm/mmap.c~mm-augment-vma-rbtree-with-rb_subtree_gap--debug-code-to-verify-rb_subtree_gap-updates-are-safe mm/mmap.c
--- a/mm/mmap.c~mm-augment-vma-rbtree-with-rb_subtree_gap--debug-code-to-verify-rb_subtree_gap-updates-are-safe
+++ a/mm/mmap.c
@@ -319,39 +319,6 @@ static long vma_compute_subtree_gap(stru
 	return max;
 }
 
-RB_DECLARE_CALLBACKS(static, vma_gap_callbacks, struct vm_area_struct, vm_rb,
-		     unsigned long, rb_subtree_gap, vma_compute_subtree_gap)
-
-/*
- * Update augmented rbtree rb_subtree_gap values after vma->vm_start or
- * vma->vm_prev->vm_end values changed, without modifying the vma's position
- * in the rbtree.
- */
-static void vma_gap_update(struct vm_area_struct *vma)
-{
-	/*
-	 * As it turns out, RB_DECLARE_CALLBACKS() already created a callback
-	 * function that does exacltly what we want.
-	 */
-	vma_gap_callbacks_propagate(&vma->vm_rb, NULL);
-}
-
-static inline void vma_rb_insert(struct vm_area_struct *vma,
-				 struct rb_root *root)
-{
-	rb_insert_augmented(&vma->vm_rb, root, &vma_gap_callbacks);
-}
-
-static void vma_rb_erase(struct vm_area_struct *vma, struct rb_root *root)
-{
-	/*
-	 * Note rb_erase_augmented is a fairly large inline function,
-	 * so make sure we instantiate it only once with our desired
-	 * augmented rbtree callbacks.
-	 */
-	rb_erase_augmented(&vma->vm_rb, root, &vma_gap_callbacks);
-}
-
 #ifdef CONFIG_DEBUG_VM_RB
 static int browse_rb(struct rb_root *root)
 {
@@ -382,6 +349,18 @@ static int browse_rb(struct rb_root *roo
 	return i;
 }
 
+static void validate_mm_rb(struct rb_root *root, struct vm_area_struct *ignore)
+{
+	struct rb_node *nd;
+
+	for (nd = rb_first(root); nd; nd = rb_next(nd)) {
+		struct vm_area_struct *vma;
+		vma = rb_entry(nd, struct vm_area_struct, vm_rb);
+		BUG_ON(vma != ignore &&
+		       vma->rb_subtree_gap != vma_compute_subtree_gap(vma));
+	}
+}
+
 void validate_mm(struct mm_struct *mm)
 {
 	int bug = 0;
@@ -404,9 +383,52 @@ void validate_mm(struct mm_struct *mm)
 	BUG_ON(bug);
 }
 #else
+#define validate_mm_rb(root, ignore) do { } while (0)
 #define validate_mm(mm) do { } while (0)
 #endif
 
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
+	/* All rb_subtree_gap values must be consistent prior to insertion */
+	validate_mm_rb(root, NULL);
+
+	rb_insert_augmented(&vma->vm_rb, root, &vma_gap_callbacks);
+}
+
+static void vma_rb_erase(struct vm_area_struct *vma, struct rb_root *root)
+{
+	/*
+	 * All rb_subtree_gap values must be consistent prior to erase,
+	 * with the possible exception of the vma being erased.
+	 */
+	validate_mm_rb(root, vma);
+
+	/*
+	 * Note rb_erase_augmented is a fairly large inline function,
+	 * so make sure we instantiate it only once with our desired
+	 * augmented rbtree callbacks.
+	 */
+	rb_erase_augmented(&vma->vm_rb, root, &vma_gap_callbacks);
+}
+
 /*
  * vma has some anon_vma assigned, and is already inserted on that
  * anon_vma's interval trees.
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

