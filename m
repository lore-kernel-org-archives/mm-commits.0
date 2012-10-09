From: akpm@linux-foundation.org
Subject: [merged] mm-avoid-taking-rmap-locks-in-move_ptes.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:11:02 -0700
Message-ID: <20121009181103.3E9AF5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:62261 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756686Ab2JISLG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:11:06 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so360435fae.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:11:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, daniel.santos@pobox.com, hughd@google.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: avoid taking rmap locks in move_ptes()
has been removed from the -mm tree.  Its filename was
     mm-avoid-taking-rmap-locks-in-move_ptes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: avoid taking rmap locks in move_ptes()

During mremap(), the destination VMA is generally placed after the
original vma in rmap traversal order: in move_vma(), we always have
new_pgoff >= vma->vm_pgoff, and as a result new_vma->vm_pgoff >=
vma->vm_pgoff unless vma_merge() merged the new vma with an adjacent one.

When the destination VMA is placed after the original in rmap traversal
order, we can avoid taking the rmap locks in move_ptes().

Essentially, this reintroduces the optimization that had been disabled in
"mm anon rmap: remove anon_vma_moveto_tail".  The difference is that we
don't try to impose the rmap traversal order; instead we just rely on
things being in the desired order in the common case and fall back to
taking locks in the uncommon case.  Also we skip the i_mmap_mutex in
addition to the anon_vma lock: in both cases, the vmas are traversed in
increasing vm_pgoff order with ties resolved in tree insertion order.

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Daniel Santos <daniel.santos@pobox.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c          |    2 -
 include/linux/mm.h |    6 +++-
 mm/mmap.c          |    7 +++--
 mm/mremap.c        |   57 +++++++++++++++++++++++++++++--------------
 4 files changed, 49 insertions(+), 23 deletions(-)

diff -puN fs/exec.c~mm-avoid-taking-rmap-locks-in-move_ptes fs/exec.c
--- a/fs/exec.c~mm-avoid-taking-rmap-locks-in-move_ptes
+++ a/fs/exec.c
@@ -603,7 +603,7 @@ static int shift_arg_pages(struct vm_are
 	 * process cleanup to remove whatever mess we made.
 	 */
 	if (length != move_page_tables(vma, old_start,
-				       vma, new_start, length))
+				       vma, new_start, length, false))
 		return -ENOMEM;
 
 	lru_add_drain();
diff -puN include/linux/mm.h~mm-avoid-taking-rmap-locks-in-move_ptes include/linux/mm.h
--- a/include/linux/mm.h~mm-avoid-taking-rmap-locks-in-move_ptes
+++ a/include/linux/mm.h
@@ -1060,7 +1060,8 @@ vm_is_stack(struct task_struct *task, st
 
 extern unsigned long move_page_tables(struct vm_area_struct *vma,
 		unsigned long old_addr, struct vm_area_struct *new_vma,
-		unsigned long new_addr, unsigned long len);
+		unsigned long new_addr, unsigned long len,
+		bool need_rmap_locks);
 extern unsigned long do_mremap(unsigned long addr,
 			       unsigned long old_len, unsigned long new_len,
 			       unsigned long flags, unsigned long new_addr);
@@ -1410,7 +1411,8 @@ extern void __vma_link_rb(struct mm_stru
 	struct rb_node **, struct rb_node *);
 extern void unlink_file_vma(struct vm_area_struct *);
 extern struct vm_area_struct *copy_vma(struct vm_area_struct **,
-	unsigned long addr, unsigned long len, pgoff_t pgoff);
+	unsigned long addr, unsigned long len, pgoff_t pgoff,
+	bool *need_rmap_locks);
 extern void exit_mmap(struct mm_struct *);
 
 extern int mm_take_all_locks(struct mm_struct *mm);
diff -puN mm/mmap.c~mm-avoid-taking-rmap-locks-in-move_ptes mm/mmap.c
--- a/mm/mmap.c~mm-avoid-taking-rmap-locks-in-move_ptes
+++ a/mm/mmap.c
@@ -2371,7 +2371,8 @@ int insert_vm_struct(struct mm_struct *m
  * prior to moving page table entries, to effect an mremap move.
  */
 struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
-	unsigned long addr, unsigned long len, pgoff_t pgoff)
+	unsigned long addr, unsigned long len, pgoff_t pgoff,
+	bool *need_rmap_locks)
 {
 	struct vm_area_struct *vma = *vmap;
 	unsigned long vma_start = vma->vm_start;
@@ -2413,8 +2414,9 @@ struct vm_area_struct *copy_vma(struct v
 			 * linear if there are no pages mapped yet.
 			 */
 			VM_BUG_ON(faulted_in_anon_vma);
-			*vmap = new_vma;
+			*vmap = vma = new_vma;
 		}
+		*need_rmap_locks = (new_vma->vm_pgoff <= vma->vm_pgoff);
 	} else {
 		new_vma = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 		if (new_vma) {
@@ -2434,6 +2436,7 @@ struct vm_area_struct *copy_vma(struct v
 			if (new_vma->vm_ops && new_vma->vm_ops->open)
 				new_vma->vm_ops->open(new_vma);
 			vma_link(mm, new_vma, prev, rb_link, rb_parent);
+			*need_rmap_locks = false;
 		}
 	}
 	return new_vma;
diff -puN mm/mremap.c~mm-avoid-taking-rmap-locks-in-move_ptes mm/mremap.c
--- a/mm/mremap.c~mm-avoid-taking-rmap-locks-in-move_ptes
+++ a/mm/mremap.c
@@ -71,26 +71,42 @@ static pmd_t *alloc_new_pmd(struct mm_st
 static void move_ptes(struct vm_area_struct *vma, pmd_t *old_pmd,
 		unsigned long old_addr, unsigned long old_end,
 		struct vm_area_struct *new_vma, pmd_t *new_pmd,
-		unsigned long new_addr)
+		unsigned long new_addr, bool need_rmap_locks)
 {
 	struct address_space *mapping = NULL;
-	struct anon_vma *anon_vma = vma->anon_vma;
+	struct anon_vma *anon_vma = NULL;
 	struct mm_struct *mm = vma->vm_mm;
 	pte_t *old_pte, *new_pte, pte;
 	spinlock_t *old_ptl, *new_ptl;
 
-	if (vma->vm_file) {
-		/*
-		 * Subtle point from Rajesh Venkatasubramanian: before
-		 * moving file-based ptes, we must lock truncate_pagecache
-		 * out, since it might clean the dst vma before the src vma,
-		 * and we propagate stale pages into the dst afterward.
-		 */
-		mapping = vma->vm_file->f_mapping;
-		mutex_lock(&mapping->i_mmap_mutex);
+	/*
+	 * When need_rmap_locks is true, we take the i_mmap_mutex and anon_vma
+	 * locks to ensure that rmap will always observe either the old or the
+	 * new ptes. This is the easiest way to avoid races with
+	 * truncate_pagecache(), page migration, etc...
+	 *
+	 * When need_rmap_locks is false, we use other ways to avoid
+	 * such races:
+	 *
+	 * - During exec() shift_arg_pages(), we use a specially tagged vma
+	 *   which rmap call sites look for using is_vma_temporary_stack().
+	 *
+	 * - During mremap(), new_vma is often known to be placed after vma
+	 *   in rmap traversal order. This ensures rmap will always observe
+	 *   either the old pte, or the new pte, or both (the page table locks
+	 *   serialize access to individual ptes, but only rmap traversal
+	 *   order guarantees that we won't miss both the old and new ptes).
+	 */
+	if (need_rmap_locks) {
+		if (vma->vm_file) {
+			mapping = vma->vm_file->f_mapping;
+			mutex_lock(&mapping->i_mmap_mutex);
+		}
+		if (vma->anon_vma) {
+			anon_vma = vma->anon_vma;
+			anon_vma_lock(anon_vma);
+		}
 	}
-	if (anon_vma)
-		anon_vma_lock(anon_vma);
 
 	/*
 	 * We don't have to worry about the ordering of src and dst
@@ -127,7 +143,8 @@ static void move_ptes(struct vm_area_str
 
 unsigned long move_page_tables(struct vm_area_struct *vma,
 		unsigned long old_addr, struct vm_area_struct *new_vma,
-		unsigned long new_addr, unsigned long len)
+		unsigned long new_addr, unsigned long len,
+		bool need_rmap_locks)
 {
 	unsigned long extent, next, old_end;
 	pmd_t *old_pmd, *new_pmd;
@@ -174,7 +191,7 @@ unsigned long move_page_tables(struct vm
 		if (extent > LATENCY_LIMIT)
 			extent = LATENCY_LIMIT;
 		move_ptes(vma, old_pmd, old_addr, old_addr + extent,
-				new_vma, new_pmd, new_addr);
+			  new_vma, new_pmd, new_addr, need_rmap_locks);
 		need_flush = true;
 	}
 	if (likely(need_flush))
@@ -198,6 +215,7 @@ static unsigned long move_vma(struct vm_
 	unsigned long hiwater_vm;
 	int split = 0;
 	int err;
+	bool need_rmap_locks;
 
 	/*
 	 * We'd prefer to avoid failure later on in do_munmap:
@@ -219,18 +237,21 @@ static unsigned long move_vma(struct vm_
 		return err;
 
 	new_pgoff = vma->vm_pgoff + ((old_addr - vma->vm_start) >> PAGE_SHIFT);
-	new_vma = copy_vma(&vma, new_addr, new_len, new_pgoff);
+	new_vma = copy_vma(&vma, new_addr, new_len, new_pgoff,
+			   &need_rmap_locks);
 	if (!new_vma)
 		return -ENOMEM;
 
-	moved_len = move_page_tables(vma, old_addr, new_vma, new_addr, old_len);
+	moved_len = move_page_tables(vma, old_addr, new_vma, new_addr, old_len,
+				     need_rmap_locks);
 	if (moved_len < old_len) {
 		/*
 		 * On error, move entries back from new area to old,
 		 * which will succeed since page tables still there,
 		 * and then proceed to unmap new area instead of old.
 		 */
-		move_page_tables(new_vma, new_addr, vma, old_addr, moved_len);
+		move_page_tables(new_vma, new_addr, vma, old_addr, moved_len,
+				 true);
 		vma = new_vma;
 		old_len = new_len;
 		old_addr = new_addr;
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
prio_tree-remove-fix.patch

