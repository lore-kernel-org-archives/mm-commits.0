From: akpm@linux-foundation.org
Subject: + mm-anon-rmap-remove-anon_vma_moveto_tail.patch added to -mm tree
Date: Fri, 07 Sep 2012 15:16:19 -0700
Message-ID: <20120907221619.6A06F1E00F3@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:34501 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab2IGWQU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Sep 2012 18:16:20 -0400
Received: by ggnu1 with SMTP id u1so12218ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 07 Sep 2012 15:16:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, daniel.santos@pobox.com, hughd@google.com, riel@redhat.com


The patch titled
     Subject: mm anon rmap: remove anon_vma_moveto_tail
has been added to the -mm tree.  Its filename is
     mm-anon-rmap-remove-anon_vma_moveto_tail.patch

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
Subject: mm anon rmap: remove anon_vma_moveto_tail

mremap() had a clever optimization where move_ptes() did not take the
anon_vma lock to avoid a race with anon rmap users such as page migration.
 Instead, the avc's were ordered in such a way that the origin vma was
always visited by rmap before the destination.  This ordering and the use
of page table locks rmap usage safe.  However, we want to replace the use
of linked lists in anon rmap with an interval tree, and this will make it
harder to impose such ordering as the interval tree will always be sorted
by the avc->vma->vm_pgoff value.  For now, let's replace the
anon_vma_moveto_tail() ordering function with proper anon_vma locking in
move_ptes().  Once we have the anon interval tree in place, we will
re-introduce an optimization to avoid taking these locks in the most
common cases.

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Daniel Santos <daniel.santos@pobox.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    1 
 mm/mmap.c            |    3 --
 mm/mremap.c          |   14 ++++--------
 mm/rmap.c            |   45 -----------------------------------------
 4 files changed, 6 insertions(+), 57 deletions(-)

diff -puN include/linux/rmap.h~mm-anon-rmap-remove-anon_vma_moveto_tail include/linux/rmap.h
--- a/include/linux/rmap.h~mm-anon-rmap-remove-anon_vma_moveto_tail
+++ a/include/linux/rmap.h
@@ -120,7 +120,6 @@ void anon_vma_init(void);	/* create anon
 int  anon_vma_prepare(struct vm_area_struct *);
 void unlink_anon_vmas(struct vm_area_struct *);
 int anon_vma_clone(struct vm_area_struct *, struct vm_area_struct *);
-void anon_vma_moveto_tail(struct vm_area_struct *);
 int anon_vma_fork(struct vm_area_struct *, struct vm_area_struct *);
 
 static inline void anon_vma_merge(struct vm_area_struct *vma,
diff -puN mm/mmap.c~mm-anon-rmap-remove-anon_vma_moveto_tail mm/mmap.c
--- a/mm/mmap.c~mm-anon-rmap-remove-anon_vma_moveto_tail
+++ a/mm/mmap.c
@@ -2379,8 +2379,7 @@ struct vm_area_struct *copy_vma(struct v
 			 */
 			VM_BUG_ON(faulted_in_anon_vma);
 			*vmap = new_vma;
-		} else
-			anon_vma_moveto_tail(new_vma);
+		}
 	} else {
 		new_vma = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 		if (new_vma) {
diff -puN mm/mremap.c~mm-anon-rmap-remove-anon_vma_moveto_tail mm/mremap.c
--- a/mm/mremap.c~mm-anon-rmap-remove-anon_vma_moveto_tail
+++ a/mm/mremap.c
@@ -74,6 +74,7 @@ static void move_ptes(struct vm_area_str
 		unsigned long new_addr)
 {
 	struct address_space *mapping = NULL;
+	struct anon_vma *anon_vma = vma->anon_vma;
 	struct mm_struct *mm = vma->vm_mm;
 	pte_t *old_pte, *new_pte, pte;
 	spinlock_t *old_ptl, *new_ptl;
@@ -88,6 +89,8 @@ static void move_ptes(struct vm_area_str
 		mapping = vma->vm_file->f_mapping;
 		mutex_lock(&mapping->i_mmap_mutex);
 	}
+	if (anon_vma)
+		anon_vma_lock(anon_vma);
 
 	/*
 	 * We don't have to worry about the ordering of src and dst
@@ -114,6 +117,8 @@ static void move_ptes(struct vm_area_str
 		spin_unlock(new_ptl);
 	pte_unmap(new_pte - 1);
 	pte_unmap_unlock(old_pte - 1, old_ptl);
+	if (anon_vma)
+		anon_vma_unlock(anon_vma);
 	if (mapping)
 		mutex_unlock(&mapping->i_mmap_mutex);
 }
@@ -221,15 +226,6 @@ static unsigned long move_vma(struct vm_
 	moved_len = move_page_tables(vma, old_addr, new_vma, new_addr, old_len);
 	if (moved_len < old_len) {
 		/*
-		 * Before moving the page tables from the new vma to
-		 * the old vma, we need to be sure the old vma is
-		 * queued after new vma in the same_anon_vma list to
-		 * prevent SMP races with rmap_walk (that could lead
-		 * rmap_walk to miss some page table).
-		 */
-		anon_vma_moveto_tail(vma);
-
-		/*
 		 * On error, move entries back from new area to old,
 		 * which will succeed since page tables still there,
 		 * and then proceed to unmap new area instead of old.
diff -puN mm/rmap.c~mm-anon-rmap-remove-anon_vma_moveto_tail mm/rmap.c
--- a/mm/rmap.c~mm-anon-rmap-remove-anon_vma_moveto_tail
+++ a/mm/rmap.c
@@ -269,51 +269,6 @@ int anon_vma_clone(struct vm_area_struct
 }
 
 /*
- * Some rmap walk that needs to find all ptes/hugepmds without false
- * negatives (like migrate and split_huge_page) running concurrent
- * with operations that copy or move pagetables (like mremap() and
- * fork()) to be safe. They depend on the anon_vma "same_anon_vma"
- * list to be in a certain order: the dst_vma must be placed after the
- * src_vma in the list. This is always guaranteed by fork() but
- * mremap() needs to call this function to enforce it in case the
- * dst_vma isn't newly allocated and chained with the anon_vma_clone()
- * function but just an extension of a pre-existing vma through
- * vma_merge.
- *
- * NOTE: the same_anon_vma list can still be changed by other
- * processes while mremap runs because mremap doesn't hold the
- * anon_vma mutex to prevent modifications to the list while it
- * runs. All we need to enforce is that the relative order of this
- * process vmas isn't changing (we don't care about other vmas
- * order). Each vma corresponds to an anon_vma_chain structure so
- * there's no risk that other processes calling anon_vma_moveto_tail()
- * and changing the same_anon_vma list under mremap() will screw with
- * the relative order of this process vmas in the list, because we
- * they can't alter the order of any vma that belongs to this
- * process. And there can't be another anon_vma_moveto_tail() running
- * concurrently with mremap() coming from this process because we hold
- * the mmap_sem for the whole mremap(). fork() ordering dependency
- * also shouldn't be affected because fork() only cares that the
- * parent vmas are placed in the list before the child vmas and
- * anon_vma_moveto_tail() won't reorder vmas from either the fork()
- * parent or child.
- */
-void anon_vma_moveto_tail(struct vm_area_struct *dst)
-{
-	struct anon_vma_chain *pavc;
-	struct anon_vma *root = NULL;
-
-	list_for_each_entry_reverse(pavc, &dst->anon_vma_chain, same_vma) {
-		struct anon_vma *anon_vma = pavc->anon_vma;
-		VM_BUG_ON(pavc->vma != dst);
-		root = lock_anon_vma_root(root, anon_vma);
-		list_del(&pavc->same_anon_vma);
-		list_add_tail(&pavc->same_anon_vma, &anon_vma->head);
-	}
-	unlock_anon_vma_root(root);
-}
-
-/*
  * Attach vma to its own anon_vma, as well as to the anon_vmas that
  * the corresponding VMA in the parent process is attached to.
  * Returns 0 on success, non-zero on failure.
_

Patches currently in -mm which might be from walken@google.com are

linux-next.patch
mm-adjust-final-endif-position-in-mm-internalh.patch
mm-fix-potential-anon_vma-locking-issue-in-mprotect.patch
ipc-mqueue-remove-unnecessary-rb_init_node-calls.patch
rbtree-reference-documentation-rbtreetxt-for-usage-instructions.patch
rbtree-empty-nodes-have-no-color.patch
rbtree-empty-nodes-have-no-color-fix.patch
rbtree-fix-incorrect-rbtree-node-insertion-in-fs-proc-proc_sysctlc.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec-fix.patch
rbtree-performance-and-correctness-test.patch
rbtree-performance-and-correctness-test-fix.patch
rbtree-break-out-of-rb_insert_color-loop-after-tree-rotation.patch
rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary.patch
rbtree-low-level-optimizations-in-rb_insert_color.patch
rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary.patch
rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary-fix.patch
rbtree-optimize-case-selection-logic-in-__rb_erase_color.patch
rbtree-low-level-optimizations-in-__rb_erase_color.patch
rbtree-coding-style-adjustments.patch
rbtree-optimize-fetching-of-sibling-node.patch
rbtree-test-fix-sparse-warning-about-64-bit-constant.patch
rbtree-add-__rb_change_child-helper-function.patch
rbtree-place-easiest-case-first-in-rb_erase.patch
rbtree-handle-1-child-recoloring-in-rb_erase-instead-of-rb_erase_color.patch
rbtree-low-level-optimizations-in-rb_erase.patch
rbtree-augmented-rbtree-test.patch
rbtree-faster-augmented-rbtree-manipulation.patch
rbtree-remove-prior-augmented-rbtree-implementation.patch
rbtree-add-rb_declare_callbacks-macro.patch
rbtree-add-prio-tree-and-interval-tree-tests.patch
mm-replace-vma-prio_tree-with-an-interval-tree.patch
kmemleak-use-rbtree-instead-of-prio-tree.patch
prio_tree-remove.patch
rbtree-move-augmented-rbtree-functionality-to-rbtree_augmentedh.patch
mm-interval-tree-updates.patch
mm-anon-rmap-remove-anon_vma_moveto_tail.patch
mm-anon-rmap-replace-same_anon_vma-linked-list-with-an-interval-tree.patch
mm-rmap-remove-vma_address-check-for-address-inside-vma.patch
mm-add-config_debug_vm_rb-build-option.patch
mm-avoid-taking-rmap-locks-in-move_ptes.patch

