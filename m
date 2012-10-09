From: akpm@linux-foundation.org
Subject: [merged] mm-anon-rmap-replace-same_anon_vma-linked-list-with-an-interval-tree.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:10:45 -0700
Message-ID: <20121009181045.C724B100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:61728 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756686Ab2JISKr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:10:47 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so662197vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:10:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, daniel.santos@pobox.com, hughd@google.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm anon rmap: replace same_anon_vma linked list with an interval tree.
has been removed from the -mm tree.  Its filename was
     mm-anon-rmap-replace-same_anon_vma-linked-list-with-an-interval-tree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm anon rmap: replace same_anon_vma linked list with an interval tree.

When a large VMA (anon or private file mapping) is first touched, which
will populate its anon_vma field, and then split into many regions through
the use of mprotect(), the original anon_vma ends up linking all of the
vmas on a linked list.  This can cause rmap to become inefficient, as we
have to walk potentially thousands of irrelevent vmas before finding the
one a given anon page might fall into.

By replacing the same_anon_vma linked list with an interval tree (where
each avc's interval is determined by its vma's start and last pgoffs), we
can make rmap efficient for this use case again.

While the change is large, all of its pieces are fairly simple.

Most places that were walking the same_anon_vma list were looking for a
known pgoff, so they can just use the anon_vma_interval_tree_foreach()
interval tree iterator instead.  The exception here is ksm, where the
page's index is not known.  It would probably be possible to rework ksm so
that the index would be known, but for now I have decided to keep things
simple and just walk the entirety of the interval tree there.

When updating vma's that already have an anon_vma assigned, we must take
care to re-index the corresponding avc's on their interval tree.  This is
done through the use of anon_vma_interval_tree_pre_update_vma() and
anon_vma_interval_tree_post_update_vma(), which remove the avc's from
their interval tree before the update and re-insert them after the update.
 The anon_vma stays locked during the update, so there is no chance that
rmap would miss the vmas that are being updated.

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Daniel Santos <daniel.santos@pobox.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h   |   14 +++++++
 include/linux/rmap.h |   11 +++---
 mm/huge_memory.c     |    5 +-
 mm/interval_tree.c   |   14 +++++++
 mm/ksm.c             |    9 +++--
 mm/memory-failure.c  |    5 ++
 mm/mmap.c            |   73 ++++++++++++++++++++++++++++++-----------
 mm/rmap.c            |   24 ++++++-------
 8 files changed, 114 insertions(+), 41 deletions(-)

diff -puN include/linux/mm.h~mm-anon-rmap-replace-same_anon_vma-linked-list-with-an-interval-tree include/linux/mm.h
--- a/include/linux/mm.h~mm-anon-rmap-replace-same_anon_vma-linked-list-with-an-interval-tree
+++ a/include/linux/mm.h
@@ -20,6 +20,7 @@
 
 struct mempolicy;
 struct anon_vma;
+struct anon_vma_chain;
 struct file_ra_state;
 struct user_struct;
 struct writeback_control;
@@ -1377,6 +1378,19 @@ static inline void vma_nonlinear_insert(
 	list_add_tail(&vma->shared.nonlinear, list);
 }
 
+void anon_vma_interval_tree_insert(struct anon_vma_chain *node,
+				   struct rb_root *root);
+void anon_vma_interval_tree_remove(struct anon_vma_chain *node,
+				   struct rb_root *root);
+struct anon_vma_chain *anon_vma_interval_tree_iter_first(
+	struct rb_root *root, unsigned long start, unsigned long last);
+struct anon_vma_chain *anon_vma_interval_tree_iter_next(
+	struct anon_vma_chain *node, unsigned long start, unsigned long last);
+
+#define anon_vma_interval_tree_foreach(avc, root, start, last)		 \
+	for (avc = anon_vma_interval_tree_iter_first(root, start, last); \
+	     avc; avc = anon_vma_interval_tree_iter_next(avc, start, last))
+
 /* mmap.c */
 extern int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin);
 extern int vma_adjust(struct vm_area_struct *vma, unsigned long start,
diff -puN include/linux/rmap.h~mm-anon-rmap-replace-same_anon_vma-linked-list-with-an-interval-tree include/linux/rmap.h
--- a/include/linux/rmap.h~mm-anon-rmap-replace-same_anon_vma-linked-list-with-an-interval-tree
+++ a/include/linux/rmap.h
@@ -37,14 +37,14 @@ struct anon_vma {
 	atomic_t refcount;
 
 	/*
-	 * NOTE: the LSB of the head.next is set by
+	 * NOTE: the LSB of the rb_root.rb_node is set by
 	 * mm_take_all_locks() _after_ taking the above lock. So the
-	 * head must only be read/written after taking the above lock
+	 * rb_root must only be read/written after taking the above lock
 	 * to be sure to see a valid next pointer. The LSB bit itself
 	 * is serialized by a system wide lock only visible to
 	 * mm_take_all_locks() (mm_all_locks_mutex).
 	 */
-	struct list_head head;	/* Chain of private "related" vmas */
+	struct rb_root rb_root;	/* Interval tree of private "related" vmas */
 };
 
 /*
@@ -57,14 +57,15 @@ struct anon_vma {
  * with a VMA, or the VMAs associated with an anon_vma.
  * The "same_vma" list contains the anon_vma_chains linking
  * all the anon_vmas associated with this VMA.
- * The "same_anon_vma" list contains the anon_vma_chains
+ * The "rb" field indexes on an interval tree the anon_vma_chains
  * which link all the VMAs associated with this anon_vma.
  */
 struct anon_vma_chain {
 	struct vm_area_struct *vma;
 	struct anon_vma *anon_vma;
 	struct list_head same_vma;   /* locked by mmap_sem & page_table_lock */
-	struct list_head same_anon_vma;	/* locked by anon_vma->mutex */
+	struct rb_node rb;			/* locked by anon_vma->mutex */
+	unsigned long rb_subtree_last;
 };
 
 #ifdef CONFIG_MMU
diff -puN mm/huge_memory.c~mm-anon-rmap-replace-same_anon_vma-linked-list-with-an-interval-tree mm/huge_memory.c
--- a/mm/huge_memory.c~mm-anon-rmap-replace-same_anon_vma-linked-list-with-an-interval-tree
+++ a/mm/huge_memory.c
@@ -1375,13 +1375,14 @@ static void __split_huge_page(struct pag
 			      struct anon_vma *anon_vma)
 {
 	int mapcount, mapcount2;
+	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
 	struct anon_vma_chain *avc;
 
 	BUG_ON(!PageHead(page));
 	BUG_ON(PageTail(page));
 
 	mapcount = 0;
-	list_for_each_entry(avc, &anon_vma->head, same_anon_vma) {
+	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root, pgoff, pgoff) {
 		struct vm_area_struct *vma = avc->vma;
 		unsigned long addr = vma_address(page, vma);
 		BUG_ON(is_vma_temporary_stack(vma));
@@ -1407,7 +1408,7 @@ static void __split_huge_page(struct pag
 	__split_huge_page_refcount(page);
 
 	mapcount2 = 0;
-	list_for_each_entry(avc, &anon_vma->head, same_anon_vma) {
+	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root, pgoff, pgoff) {
 		struct vm_area_struct *vma = avc->vma;
 		unsigned long addr = vma_address(page, vma);
 		BUG_ON(is_vma_temporary_stack(vma));
diff -puN mm/interval_tree.c~mm-anon-rmap-replace-same_anon_vma-linked-list-with-an-interval-tree mm/interval_tree.c
--- a/mm/interval_tree.c~mm-anon-rmap-replace-same_anon_vma-linked-list-with-an-interval-tree
+++ a/mm/interval_tree.c
@@ -8,6 +8,7 @@
 
 #include <linux/mm.h>
 #include <linux/fs.h>
+#include <linux/rmap.h>
 #include <linux/interval_tree_generic.h>
 
 static inline unsigned long vma_start_pgoff(struct vm_area_struct *v)
@@ -57,3 +58,16 @@ void vma_interval_tree_insert_after(stru
 	rb_insert_augmented(&node->shared.linear.rb, root,
 			    &vma_interval_tree_augment);
 }
+
+static inline unsigned long avc_start_pgoff(struct anon_vma_chain *avc)
+{
+	return vma_start_pgoff(avc->vma);
+}
+
+static inline unsigned long avc_last_pgoff(struct anon_vma_chain *avc)
+{
+	return vma_last_pgoff(avc->vma);
+}
+
+INTERVAL_TREE_DEFINE(struct anon_vma_chain, rb, unsigned long, rb_subtree_last,
+		     avc_start_pgoff, avc_last_pgoff,, anon_vma_interval_tree)
diff -puN mm/ksm.c~mm-anon-rmap-replace-same_anon_vma-linked-list-with-an-interval-tree mm/ksm.c
--- a/mm/ksm.c~mm-anon-rmap-replace-same_anon_vma-linked-list-with-an-interval-tree
+++ a/mm/ksm.c
@@ -1618,7 +1618,8 @@ again:
 		struct vm_area_struct *vma;
 
 		anon_vma_lock(anon_vma);
-		list_for_each_entry(vmac, &anon_vma->head, same_anon_vma) {
+		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
+					       0, ULONG_MAX) {
 			vma = vmac->vma;
 			if (rmap_item->address < vma->vm_start ||
 			    rmap_item->address >= vma->vm_end)
@@ -1671,7 +1672,8 @@ again:
 		struct vm_area_struct *vma;
 
 		anon_vma_lock(anon_vma);
-		list_for_each_entry(vmac, &anon_vma->head, same_anon_vma) {
+		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
+					       0, ULONG_MAX) {
 			vma = vmac->vma;
 			if (rmap_item->address < vma->vm_start ||
 			    rmap_item->address >= vma->vm_end)
@@ -1723,7 +1725,8 @@ again:
 		struct vm_area_struct *vma;
 
 		anon_vma_lock(anon_vma);
-		list_for_each_entry(vmac, &anon_vma->head, same_anon_vma) {
+		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
+					       0, ULONG_MAX) {
 			vma = vmac->vma;
 			if (rmap_item->address < vma->vm_start ||
 			    rmap_item->address >= vma->vm_end)
diff -puN mm/memory-failure.c~mm-anon-rmap-replace-same_anon_vma-linked-list-with-an-interval-tree mm/memory-failure.c
--- a/mm/memory-failure.c~mm-anon-rmap-replace-same_anon_vma-linked-list-with-an-interval-tree
+++ a/mm/memory-failure.c
@@ -400,18 +400,21 @@ static void collect_procs_anon(struct pa
 	struct vm_area_struct *vma;
 	struct task_struct *tsk;
 	struct anon_vma *av;
+	pgoff_t pgoff;
 
 	av = page_lock_anon_vma(page);
 	if (av == NULL)	/* Not actually mapped anymore */
 		return;
 
+	pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
 	read_lock(&tasklist_lock);
 	for_each_process (tsk) {
 		struct anon_vma_chain *vmac;
 
 		if (!task_early_kill(tsk))
 			continue;
-		list_for_each_entry(vmac, &av->head, same_anon_vma) {
+		anon_vma_interval_tree_foreach(vmac, &av->rb_root,
+					       pgoff, pgoff) {
 			vma = vmac->vma;
 			if (!page_mapped_in_vma(page, vma))
 				continue;
diff -puN mm/mmap.c~mm-anon-rmap-replace-same_anon_vma-linked-list-with-an-interval-tree mm/mmap.c
--- a/mm/mmap.c~mm-anon-rmap-replace-same_anon_vma-linked-list-with-an-interval-tree
+++ a/mm/mmap.c
@@ -353,6 +353,38 @@ void validate_mm(struct mm_struct *mm)
 #define validate_mm(mm) do { } while (0)
 #endif
 
+/*
+ * vma has some anon_vma assigned, and is already inserted on that
+ * anon_vma's interval trees.
+ *
+ * Before updating the vma's vm_start / vm_end / vm_pgoff fields, the
+ * vma must be removed from the anon_vma's interval trees using
+ * anon_vma_interval_tree_pre_update_vma().
+ *
+ * After the update, the vma will be reinserted using
+ * anon_vma_interval_tree_post_update_vma().
+ *
+ * The entire update must be protected by exclusive mmap_sem and by
+ * the root anon_vma's mutex.
+ */
+static inline void
+anon_vma_interval_tree_pre_update_vma(struct vm_area_struct *vma)
+{
+	struct anon_vma_chain *avc;
+
+	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
+		anon_vma_interval_tree_remove(avc, &avc->anon_vma->rb_root);
+}
+
+static inline void
+anon_vma_interval_tree_post_update_vma(struct vm_area_struct *vma)
+{
+	struct anon_vma_chain *avc;
+
+	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
+		anon_vma_interval_tree_insert(avc, &avc->anon_vma->rb_root);
+}
+
 static int find_vma_links(struct mm_struct *mm, unsigned long addr,
 		unsigned long end, struct vm_area_struct **pprev,
 		struct rb_node ***rb_link, struct rb_node **rb_parent)
@@ -565,20 +597,17 @@ again:			remove_next = 1 + (end > next->
 
 	vma_adjust_trans_huge(vma, start, end, adjust_next);
 
-	/*
-	 * When changing only vma->vm_end, we don't really need anon_vma
-	 * lock. This is a fairly rare case by itself, but the anon_vma
-	 * lock may be shared between many sibling processes.  Skipping
-	 * the lock for brk adjustments makes a difference sometimes.
-	 */
-	if (vma->anon_vma && (importer || start != vma->vm_start)) {
-		anon_vma = vma->anon_vma;
+	anon_vma = vma->anon_vma;
+	if (!anon_vma && adjust_next)
+		anon_vma = next->anon_vma;
+	if (anon_vma) {
 		VM_BUG_ON(adjust_next && next->anon_vma &&
 			  anon_vma != next->anon_vma);
-	} else if (adjust_next && next->anon_vma)
-		anon_vma = next->anon_vma;
-	if (anon_vma)
 		anon_vma_lock(anon_vma);
+		anon_vma_interval_tree_pre_update_vma(vma);
+		if (adjust_next)
+			anon_vma_interval_tree_pre_update_vma(next);
+	}
 
 	if (root) {
 		flush_dcache_mmap_lock(mapping);
@@ -619,8 +648,12 @@ again:			remove_next = 1 + (end > next->
 		__insert_vm_struct(mm, insert);
 	}
 
-	if (anon_vma)
+	if (anon_vma) {
+		anon_vma_interval_tree_post_update_vma(vma);
+		if (adjust_next)
+			anon_vma_interval_tree_post_update_vma(next);
 		anon_vma_unlock(anon_vma);
+	}
 	if (mapping)
 		mutex_unlock(&mapping->i_mmap_mutex);
 
@@ -1748,7 +1781,9 @@ int expand_upwards(struct vm_area_struct
 		if (vma->vm_pgoff + (size >> PAGE_SHIFT) >= vma->vm_pgoff) {
 			error = acct_stack_growth(vma, size, grow);
 			if (!error) {
+				anon_vma_interval_tree_pre_update_vma(vma);
 				vma->vm_end = address;
+				anon_vma_interval_tree_post_update_vma(vma);
 				perf_event_mmap(vma);
 			}
 		}
@@ -1798,8 +1833,10 @@ int expand_downwards(struct vm_area_stru
 		if (grow <= vma->vm_pgoff) {
 			error = acct_stack_growth(vma, size, grow);
 			if (!error) {
+				anon_vma_interval_tree_pre_update_vma(vma);
 				vma->vm_start = address;
 				vma->vm_pgoff -= grow;
+				anon_vma_interval_tree_post_update_vma(vma);
 				perf_event_mmap(vma);
 			}
 		}
@@ -2515,7 +2552,7 @@ static DEFINE_MUTEX(mm_all_locks_mutex);
 
 static void vm_lock_anon_vma(struct mm_struct *mm, struct anon_vma *anon_vma)
 {
-	if (!test_bit(0, (unsigned long *) &anon_vma->root->head.next)) {
+	if (!test_bit(0, (unsigned long *) &anon_vma->root->rb_root.rb_node)) {
 		/*
 		 * The LSB of head.next can't change from under us
 		 * because we hold the mm_all_locks_mutex.
@@ -2531,7 +2568,7 @@ static void vm_lock_anon_vma(struct mm_s
 		 * anon_vma->root->mutex.
 		 */
 		if (__test_and_set_bit(0, (unsigned long *)
-				       &anon_vma->root->head.next))
+				       &anon_vma->root->rb_root.rb_node))
 			BUG();
 	}
 }
@@ -2572,7 +2609,7 @@ static void vm_lock_mapping(struct mm_st
  * A single task can't take more than one mm_take_all_locks() in a row
  * or it would deadlock.
  *
- * The LSB in anon_vma->head.next and the AS_MM_ALL_LOCKS bitflag in
+ * The LSB in anon_vma->rb_root.rb_node and the AS_MM_ALL_LOCKS bitflag in
  * mapping->flags avoid to take the same lock twice, if more than one
  * vma in this mm is backed by the same anon_vma or address_space.
  *
@@ -2619,13 +2656,13 @@ out_unlock:
 
 static void vm_unlock_anon_vma(struct anon_vma *anon_vma)
 {
-	if (test_bit(0, (unsigned long *) &anon_vma->root->head.next)) {
+	if (test_bit(0, (unsigned long *) &anon_vma->root->rb_root.rb_node)) {
 		/*
 		 * The LSB of head.next can't change to 0 from under
 		 * us because we hold the mm_all_locks_mutex.
 		 *
 		 * We must however clear the bitflag before unlocking
-		 * the vma so the users using the anon_vma->head will
+		 * the vma so the users using the anon_vma->rb_root will
 		 * never see our bitflag.
 		 *
 		 * No need of atomic instructions here, head.next
@@ -2633,7 +2670,7 @@ static void vm_unlock_anon_vma(struct an
 		 * anon_vma->root->mutex.
 		 */
 		if (!__test_and_clear_bit(0, (unsigned long *)
-					  &anon_vma->root->head.next))
+					  &anon_vma->root->rb_root.rb_node))
 			BUG();
 		anon_vma_unlock(anon_vma);
 	}
diff -puN mm/rmap.c~mm-anon-rmap-replace-same_anon_vma-linked-list-with-an-interval-tree mm/rmap.c
--- a/mm/rmap.c~mm-anon-rmap-replace-same_anon_vma-linked-list-with-an-interval-tree
+++ a/mm/rmap.c
@@ -127,12 +127,7 @@ static void anon_vma_chain_link(struct v
 	avc->vma = vma;
 	avc->anon_vma = anon_vma;
 	list_add(&avc->same_vma, &vma->anon_vma_chain);
-
-	/*
-	 * It's critical to add new vmas to the tail of the anon_vma,
-	 * see comment in huge_memory.c:__split_huge_page().
-	 */
-	list_add_tail(&avc->same_anon_vma, &anon_vma->head);
+	anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
 }
 
 /**
@@ -336,13 +331,13 @@ void unlink_anon_vmas(struct vm_area_str
 		struct anon_vma *anon_vma = avc->anon_vma;
 
 		root = lock_anon_vma_root(root, anon_vma);
-		list_del(&avc->same_anon_vma);
+		anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
 
 		/*
 		 * Leave empty anon_vmas on the list - we'll need
 		 * to free them outside the lock.
 		 */
-		if (list_empty(&anon_vma->head))
+		if (RB_EMPTY_ROOT(&anon_vma->rb_root))
 			continue;
 
 		list_del(&avc->same_vma);
@@ -371,7 +366,7 @@ static void anon_vma_ctor(void *data)
 
 	mutex_init(&anon_vma->mutex);
 	atomic_set(&anon_vma->refcount, 0);
-	INIT_LIST_HEAD(&anon_vma->head);
+	anon_vma->rb_root = RB_ROOT;
 }
 
 void __init anon_vma_init(void)
@@ -724,6 +719,7 @@ static int page_referenced_anon(struct p
 {
 	unsigned int mapcount;
 	struct anon_vma *anon_vma;
+	pgoff_t pgoff;
 	struct anon_vma_chain *avc;
 	int referenced = 0;
 
@@ -732,7 +728,8 @@ static int page_referenced_anon(struct p
 		return referenced;
 
 	mapcount = page_mapcount(page);
-	list_for_each_entry(avc, &anon_vma->head, same_anon_vma) {
+	pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root, pgoff, pgoff) {
 		struct vm_area_struct *vma = avc->vma;
 		unsigned long address = vma_address(page, vma);
 		if (address == -EFAULT)
@@ -1445,6 +1442,7 @@ bool is_vma_temporary_stack(struct vm_ar
 static int try_to_unmap_anon(struct page *page, enum ttu_flags flags)
 {
 	struct anon_vma *anon_vma;
+	pgoff_t pgoff;
 	struct anon_vma_chain *avc;
 	int ret = SWAP_AGAIN;
 
@@ -1452,7 +1450,8 @@ static int try_to_unmap_anon(struct page
 	if (!anon_vma)
 		return ret;
 
-	list_for_each_entry(avc, &anon_vma->head, same_anon_vma) {
+	pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root, pgoff, pgoff) {
 		struct vm_area_struct *vma = avc->vma;
 		unsigned long address;
 
@@ -1668,6 +1667,7 @@ static int rmap_walk_anon(struct page *p
 		struct vm_area_struct *, unsigned long, void *), void *arg)
 {
 	struct anon_vma *anon_vma;
+	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
 	struct anon_vma_chain *avc;
 	int ret = SWAP_AGAIN;
 
@@ -1681,7 +1681,7 @@ static int rmap_walk_anon(struct page *p
 	if (!anon_vma)
 		return ret;
 	anon_vma_lock(anon_vma);
-	list_for_each_entry(avc, &anon_vma->head, same_anon_vma) {
+	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root, pgoff, pgoff) {
 		struct vm_area_struct *vma = avc->vma;
 		unsigned long address = vma_address(page, vma);
 		if (address == -EFAULT)
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
prio_tree-remove-fix.patch

