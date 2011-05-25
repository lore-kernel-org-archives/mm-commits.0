From: akpm@linux-foundation.org
Subject: [merged] mm-convert-i_mmap_lock-to-a-mutex.patch removed from -mm tree
Date: Wed, 25 May 2011 13:28:50 -0700
Message-ID: <201105252027.p4PKRDUV014558@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932218Ab1EYU20 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:28:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, benh@kernel.crashing.org, davem@davemloft.net, hughd@google.com, jdike@addtoit.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lethal@linu


The patch titled
     mm: Convert i_mmap_lock to a mutex
has been removed from the -mm tree.  Its filename was
     mm-convert-i_mmap_lock-to-a-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: Convert i_mmap_lock to a mutex
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Straightforward conversion of i_mmap_lock to a mutex.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Tony Luck <tony.luck@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/lockstat.txt   |    2 +-
 Documentation/vm/locking     |    2 +-
 arch/x86/mm/hugetlbpage.c    |    4 ++--
 fs/hugetlbfs/inode.c         |    4 ++--
 fs/inode.c                   |    2 +-
 include/linux/fs.h           |    2 +-
 include/linux/mmu_notifier.h |    2 +-
 kernel/fork.c                |    4 ++--
 mm/filemap.c                 |   10 +++++-----
 mm/filemap_xip.c             |    4 ++--
 mm/fremap.c                  |    4 ++--
 mm/hugetlb.c                 |   14 +++++++-------
 mm/memory-failure.c          |    4 ++--
 mm/memory.c                  |    4 ++--
 mm/mmap.c                    |   22 +++++++++++-----------
 mm/mremap.c                  |    4 ++--
 mm/rmap.c                    |   28 ++++++++++++++--------------
 17 files changed, 58 insertions(+), 58 deletions(-)

diff -puN Documentation/lockstat.txt~mm-convert-i_mmap_lock-to-a-mutex Documentation/lockstat.txt
--- a/Documentation/lockstat.txt~mm-convert-i_mmap_lock-to-a-mutex
+++ a/Documentation/lockstat.txt
@@ -136,7 +136,7 @@ View the top contending locks:
                              dcache_lock:          1037           1161           0.38          45.32         774.51           6611         243371           0.15         306.48       77387.24
                          &inode->i_mutex:           161            286 18446744073709       62882.54     1244614.55           3653          20598 18446744073709       62318.60     1693822.74
                          &zone->lru_lock:            94             94           0.53           7.33          92.10           4366          32690           0.29          59.81       16350.06
-              &inode->i_data.i_mmap_lock:            79             79           0.40           3.77          53.03          11779          87755           0.28         116.93       29898.44
+              &inode->i_data.i_mmap_mutex:            79             79           0.40           3.77          53.03          11779          87755           0.28         116.93       29898.44
                         &q->__queue_lock:            48             50           0.52          31.62          86.31            774          13131           0.17         113.08       12277.52
                         &rq->rq_lock_key:            43             47           0.74          68.50         170.63           3706          33929           0.22         107.99       17460.62
                       &rq->rq_lock_key#2:            39             46           0.75           6.68          49.03           2979          32292           0.17         125.17       17137.63
diff -puN Documentation/vm/locking~mm-convert-i_mmap_lock-to-a-mutex Documentation/vm/locking
--- a/Documentation/vm/locking~mm-convert-i_mmap_lock-to-a-mutex
+++ a/Documentation/vm/locking
@@ -66,7 +66,7 @@ in some cases it is not really needed. E
 expand_stack(), it is hard to come up with a destructive scenario without 
 having the vmlist protection in this case.
 
-The page_table_lock nests with the inode i_mmap_lock and the kmem cache
+The page_table_lock nests with the inode i_mmap_mutex and the kmem cache
 c_spinlock spinlocks.  This is okay, since the kmem code asks for pages after
 dropping c_spinlock.  The page_table_lock also nests with pagecache_lock and
 pagemap_lru_lock spinlocks, and no code asks for memory with these locks
diff -puN arch/x86/mm/hugetlbpage.c~mm-convert-i_mmap_lock-to-a-mutex arch/x86/mm/hugetlbpage.c
--- a/arch/x86/mm/hugetlbpage.c~mm-convert-i_mmap_lock-to-a-mutex
+++ a/arch/x86/mm/hugetlbpage.c
@@ -72,7 +72,7 @@ static void huge_pmd_share(struct mm_str
 	if (!vma_shareable(vma, addr))
 		return;
 
-	spin_lock(&mapping->i_mmap_lock);
+	mutex_lock(&mapping->i_mmap_mutex);
 	vma_prio_tree_foreach(svma, &iter, &mapping->i_mmap, idx, idx) {
 		if (svma == vma)
 			continue;
@@ -97,7 +97,7 @@ static void huge_pmd_share(struct mm_str
 		put_page(virt_to_page(spte));
 	spin_unlock(&mm->page_table_lock);
 out:
-	spin_unlock(&mapping->i_mmap_lock);
+	mutex_unlock(&mapping->i_mmap_mutex);
 }
 
 /*
diff -puN fs/hugetlbfs/inode.c~mm-convert-i_mmap_lock-to-a-mutex fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-convert-i_mmap_lock-to-a-mutex
+++ a/fs/hugetlbfs/inode.c
@@ -412,10 +412,10 @@ static int hugetlb_vmtruncate(struct ino
 	pgoff = offset >> PAGE_SHIFT;
 
 	i_size_write(inode, offset);
-	spin_lock(&mapping->i_mmap_lock);
+	mutex_lock(&mapping->i_mmap_mutex);
 	if (!prio_tree_empty(&mapping->i_mmap))
 		hugetlb_vmtruncate_list(&mapping->i_mmap, pgoff);
-	spin_unlock(&mapping->i_mmap_lock);
+	mutex_unlock(&mapping->i_mmap_mutex);
 	truncate_hugepages(inode, offset);
 	return 0;
 }
diff -puN fs/inode.c~mm-convert-i_mmap_lock-to-a-mutex fs/inode.c
--- a/fs/inode.c~mm-convert-i_mmap_lock-to-a-mutex
+++ a/fs/inode.c
@@ -326,7 +326,7 @@ void address_space_init_once(struct addr
 	memset(mapping, 0, sizeof(*mapping));
 	INIT_RADIX_TREE(&mapping->page_tree, GFP_ATOMIC);
 	spin_lock_init(&mapping->tree_lock);
-	spin_lock_init(&mapping->i_mmap_lock);
+	mutex_init(&mapping->i_mmap_mutex);
 	INIT_LIST_HEAD(&mapping->private_list);
 	spin_lock_init(&mapping->private_lock);
 	INIT_RAW_PRIO_TREE_ROOT(&mapping->i_mmap);
diff -puN include/linux/fs.h~mm-convert-i_mmap_lock-to-a-mutex include/linux/fs.h
--- a/include/linux/fs.h~mm-convert-i_mmap_lock-to-a-mutex
+++ a/include/linux/fs.h
@@ -634,7 +634,7 @@ struct address_space {
 	unsigned int		i_mmap_writable;/* count VM_SHARED mappings */
 	struct prio_tree_root	i_mmap;		/* tree of private and shared mappings */
 	struct list_head	i_mmap_nonlinear;/*list VM_NONLINEAR mappings */
-	spinlock_t		i_mmap_lock;	/* protect tree, count, list */
+	struct mutex		i_mmap_mutex;	/* protect tree, count, list */
 	unsigned long		nrpages;	/* number of total pages */
 	pgoff_t			writeback_index;/* writeback starts here */
 	const struct address_space_operations *a_ops;	/* methods */
diff -puN include/linux/mmu_notifier.h~mm-convert-i_mmap_lock-to-a-mutex include/linux/mmu_notifier.h
--- a/include/linux/mmu_notifier.h~mm-convert-i_mmap_lock-to-a-mutex
+++ a/include/linux/mmu_notifier.h
@@ -150,7 +150,7 @@ struct mmu_notifier_ops {
  * Therefore notifier chains can only be traversed when either
  *
  * 1. mmap_sem is held.
- * 2. One of the reverse map locks is held (i_mmap_lock or anon_vma->lock).
+ * 2. One of the reverse map locks is held (i_mmap_mutex or anon_vma->lock).
  * 3. No other concurrent thread can access the list (release)
  */
 struct mmu_notifier {
diff -puN kernel/fork.c~mm-convert-i_mmap_lock-to-a-mutex kernel/fork.c
--- a/kernel/fork.c~mm-convert-i_mmap_lock-to-a-mutex
+++ a/kernel/fork.c
@@ -383,14 +383,14 @@ static int dup_mmap(struct mm_struct *mm
 			get_file(file);
 			if (tmp->vm_flags & VM_DENYWRITE)
 				atomic_dec(&inode->i_writecount);
-			spin_lock(&mapping->i_mmap_lock);
+			mutex_lock(&mapping->i_mmap_mutex);
 			if (tmp->vm_flags & VM_SHARED)
 				mapping->i_mmap_writable++;
 			flush_dcache_mmap_lock(mapping);
 			/* insert tmp into the share list, just after mpnt */
 			vma_prio_tree_add(tmp, mpnt);
 			flush_dcache_mmap_unlock(mapping);
-			spin_unlock(&mapping->i_mmap_lock);
+			mutex_unlock(&mapping->i_mmap_mutex);
 		}
 
 		/*
diff -puN mm/filemap.c~mm-convert-i_mmap_lock-to-a-mutex mm/filemap.c
--- a/mm/filemap.c~mm-convert-i_mmap_lock-to-a-mutex
+++ a/mm/filemap.c
@@ -58,16 +58,16 @@
 /*
  * Lock ordering:
  *
- *  ->i_mmap_lock		(truncate_pagecache)
+ *  ->i_mmap_mutex		(truncate_pagecache)
  *    ->private_lock		(__free_pte->__set_page_dirty_buffers)
  *      ->swap_lock		(exclusive_swap_page, others)
  *        ->mapping->tree_lock
  *
  *  ->i_mutex
- *    ->i_mmap_lock		(truncate->unmap_mapping_range)
+ *    ->i_mmap_mutex		(truncate->unmap_mapping_range)
  *
  *  ->mmap_sem
- *    ->i_mmap_lock
+ *    ->i_mmap_mutex
  *      ->page_table_lock or pte_lock	(various, mainly in memory.c)
  *        ->mapping->tree_lock	(arch-dependent flush_dcache_mmap_lock)
  *
@@ -84,7 +84,7 @@
  *    sb_lock			(fs/fs-writeback.c)
  *    ->mapping->tree_lock	(__sync_single_inode)
  *
- *  ->i_mmap_lock
+ *  ->i_mmap_mutex
  *    ->anon_vma.lock		(vma_adjust)
  *
  *  ->anon_vma.lock
@@ -106,7 +106,7 @@
  *
  *  (code doesn't rely on that order, so you could switch it around)
  *  ->tasklist_lock             (memory_failure, collect_procs_ao)
- *    ->i_mmap_lock
+ *    ->i_mmap_mutex
  */
 
 /*
diff -puN mm/filemap_xip.c~mm-convert-i_mmap_lock-to-a-mutex mm/filemap_xip.c
--- a/mm/filemap_xip.c~mm-convert-i_mmap_lock-to-a-mutex
+++ a/mm/filemap_xip.c
@@ -183,7 +183,7 @@ __xip_unmap (struct address_space * mapp
 		return;
 
 retry:
-	spin_lock(&mapping->i_mmap_lock);
+	mutex_lock(&mapping->i_mmap_mutex);
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
 		mm = vma->vm_mm;
 		address = vma->vm_start +
@@ -201,7 +201,7 @@ retry:
 			page_cache_release(page);
 		}
 	}
-	spin_unlock(&mapping->i_mmap_lock);
+	mutex_unlock(&mapping->i_mmap_mutex);
 
 	if (locked) {
 		mutex_unlock(&xip_sparse_mutex);
diff -puN mm/fremap.c~mm-convert-i_mmap_lock-to-a-mutex mm/fremap.c
--- a/mm/fremap.c~mm-convert-i_mmap_lock-to-a-mutex
+++ a/mm/fremap.c
@@ -211,13 +211,13 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 			}
 			goto out;
 		}
-		spin_lock(&mapping->i_mmap_lock);
+		mutex_lock(&mapping->i_mmap_mutex);
 		flush_dcache_mmap_lock(mapping);
 		vma->vm_flags |= VM_NONLINEAR;
 		vma_prio_tree_remove(vma, &mapping->i_mmap);
 		vma_nonlinear_insert(vma, &mapping->i_mmap_nonlinear);
 		flush_dcache_mmap_unlock(mapping);
-		spin_unlock(&mapping->i_mmap_lock);
+		mutex_unlock(&mapping->i_mmap_mutex);
 	}
 
 	if (vma->vm_flags & VM_LOCKED) {
diff -puN mm/hugetlb.c~mm-convert-i_mmap_lock-to-a-mutex mm/hugetlb.c
--- a/mm/hugetlb.c~mm-convert-i_mmap_lock-to-a-mutex
+++ a/mm/hugetlb.c
@@ -2205,7 +2205,7 @@ void __unmap_hugepage_range(struct vm_ar
 	unsigned long sz = huge_page_size(h);
 
 	/*
-	 * A page gathering list, protected by per file i_mmap_lock. The
+	 * A page gathering list, protected by per file i_mmap_mutex. The
 	 * lock is used to avoid list corruption from multiple unmapping
 	 * of the same page since we are using page->lru.
 	 */
@@ -2274,9 +2274,9 @@ void __unmap_hugepage_range(struct vm_ar
 void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
 			  unsigned long end, struct page *ref_page)
 {
-	spin_lock(&vma->vm_file->f_mapping->i_mmap_lock);
+	mutex_lock(&vma->vm_file->f_mapping->i_mmap_mutex);
 	__unmap_hugepage_range(vma, start, end, ref_page);
-	spin_unlock(&vma->vm_file->f_mapping->i_mmap_lock);
+	mutex_unlock(&vma->vm_file->f_mapping->i_mmap_mutex);
 }
 
 /*
@@ -2308,7 +2308,7 @@ static int unmap_ref_private(struct mm_s
 	 * this mapping should be shared between all the VMAs,
 	 * __unmap_hugepage_range() is called as the lock is already held
 	 */
-	spin_lock(&mapping->i_mmap_lock);
+	mutex_lock(&mapping->i_mmap_mutex);
 	vma_prio_tree_foreach(iter_vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
 		/* Do not unmap the current VMA */
 		if (iter_vma == vma)
@@ -2326,7 +2326,7 @@ static int unmap_ref_private(struct mm_s
 				address, address + huge_page_size(h),
 				page);
 	}
-	spin_unlock(&mapping->i_mmap_lock);
+	mutex_unlock(&mapping->i_mmap_mutex);
 
 	return 1;
 }
@@ -2810,7 +2810,7 @@ void hugetlb_change_protection(struct vm
 	BUG_ON(address >= end);
 	flush_cache_range(vma, address, end);
 
-	spin_lock(&vma->vm_file->f_mapping->i_mmap_lock);
+	mutex_lock(&vma->vm_file->f_mapping->i_mmap_mutex);
 	spin_lock(&mm->page_table_lock);
 	for (; address < end; address += huge_page_size(h)) {
 		ptep = huge_pte_offset(mm, address);
@@ -2825,7 +2825,7 @@ void hugetlb_change_protection(struct vm
 		}
 	}
 	spin_unlock(&mm->page_table_lock);
-	spin_unlock(&vma->vm_file->f_mapping->i_mmap_lock);
+	mutex_unlock(&vma->vm_file->f_mapping->i_mmap_mutex);
 
 	flush_tlb_range(vma, start, end);
 }
diff -puN mm/memory-failure.c~mm-convert-i_mmap_lock-to-a-mutex mm/memory-failure.c
--- a/mm/memory-failure.c~mm-convert-i_mmap_lock-to-a-mutex
+++ a/mm/memory-failure.c
@@ -429,7 +429,7 @@ static void collect_procs_file(struct pa
 	 */
 
 	read_lock(&tasklist_lock);
-	spin_lock(&mapping->i_mmap_lock);
+	mutex_lock(&mapping->i_mmap_mutex);
 	for_each_process(tsk) {
 		pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
 
@@ -449,7 +449,7 @@ static void collect_procs_file(struct pa
 				add_to_kill(tsk, page, vma, to_kill, tkc);
 		}
 	}
-	spin_unlock(&mapping->i_mmap_lock);
+	mutex_unlock(&mapping->i_mmap_mutex);
 	read_unlock(&tasklist_lock);
 }
 
diff -puN mm/memory.c~mm-convert-i_mmap_lock-to-a-mutex mm/memory.c
--- a/mm/memory.c~mm-convert-i_mmap_lock-to-a-mutex
+++ a/mm/memory.c
@@ -2667,12 +2667,12 @@ void unmap_mapping_range(struct address_
 		details.last_index = ULONG_MAX;
 
 
-	spin_lock(&mapping->i_mmap_lock);
+	mutex_lock(&mapping->i_mmap_mutex);
 	if (unlikely(!prio_tree_empty(&mapping->i_mmap)))
 		unmap_mapping_range_tree(&mapping->i_mmap, &details);
 	if (unlikely(!list_empty(&mapping->i_mmap_nonlinear)))
 		unmap_mapping_range_list(&mapping->i_mmap_nonlinear, &details);
-	spin_unlock(&mapping->i_mmap_lock);
+	mutex_unlock(&mapping->i_mmap_mutex);
 }
 EXPORT_SYMBOL(unmap_mapping_range);
 
diff -puN mm/mmap.c~mm-convert-i_mmap_lock-to-a-mutex mm/mmap.c
--- a/mm/mmap.c~mm-convert-i_mmap_lock-to-a-mutex
+++ a/mm/mmap.c
@@ -194,7 +194,7 @@ error:
 }
 
 /*
- * Requires inode->i_mapping->i_mmap_lock
+ * Requires inode->i_mapping->i_mmap_mutex
  */
 static void __remove_shared_vm_struct(struct vm_area_struct *vma,
 		struct file *file, struct address_space *mapping)
@@ -222,9 +222,9 @@ void unlink_file_vma(struct vm_area_stru
 
 	if (file) {
 		struct address_space *mapping = file->f_mapping;
-		spin_lock(&mapping->i_mmap_lock);
+		mutex_lock(&mapping->i_mmap_mutex);
 		__remove_shared_vm_struct(vma, file, mapping);
-		spin_unlock(&mapping->i_mmap_lock);
+		mutex_unlock(&mapping->i_mmap_mutex);
 	}
 }
 
@@ -446,13 +446,13 @@ static void vma_link(struct mm_struct *m
 		mapping = vma->vm_file->f_mapping;
 
 	if (mapping)
-		spin_lock(&mapping->i_mmap_lock);
+		mutex_lock(&mapping->i_mmap_mutex);
 
 	__vma_link(mm, vma, prev, rb_link, rb_parent);
 	__vma_link_file(vma);
 
 	if (mapping)
-		spin_unlock(&mapping->i_mmap_lock);
+		mutex_unlock(&mapping->i_mmap_mutex);
 
 	mm->map_count++;
 	validate_mm(mm);
@@ -555,7 +555,7 @@ again:			remove_next = 1 + (end > next->
 		mapping = file->f_mapping;
 		if (!(vma->vm_flags & VM_NONLINEAR))
 			root = &mapping->i_mmap;
-		spin_lock(&mapping->i_mmap_lock);
+		mutex_lock(&mapping->i_mmap_mutex);
 		if (insert) {
 			/*
 			 * Put into prio_tree now, so instantiated pages
@@ -622,7 +622,7 @@ again:			remove_next = 1 + (end > next->
 	if (anon_vma)
 		anon_vma_unlock(anon_vma);
 	if (mapping)
-		spin_unlock(&mapping->i_mmap_lock);
+		mutex_unlock(&mapping->i_mmap_mutex);
 
 	if (remove_next) {
 		if (file) {
@@ -2291,7 +2291,7 @@ void exit_mmap(struct mm_struct *mm)
 
 /* Insert vm structure into process list sorted by address
  * and into the inode's i_mmap tree.  If vm_file is non-NULL
- * then i_mmap_lock is taken here.
+ * then i_mmap_mutex is taken here.
  */
 int insert_vm_struct(struct mm_struct * mm, struct vm_area_struct * vma)
 {
@@ -2533,7 +2533,7 @@ static void vm_lock_mapping(struct mm_st
 		 */
 		if (test_and_set_bit(AS_MM_ALL_LOCKS, &mapping->flags))
 			BUG();
-		spin_lock_nest_lock(&mapping->i_mmap_lock, &mm->mmap_sem);
+		mutex_lock_nest_lock(&mapping->i_mmap_mutex, &mm->mmap_sem);
 	}
 }
 
@@ -2560,7 +2560,7 @@ static void vm_lock_mapping(struct mm_st
  * vma in this mm is backed by the same anon_vma or address_space.
  *
  * We can take all the locks in random order because the VM code
- * taking i_mmap_lock or anon_vma->lock outside the mmap_sem never
+ * taking i_mmap_mutex or anon_vma->lock outside the mmap_sem never
  * takes more than one of them in a row. Secondly we're protected
  * against a concurrent mm_take_all_locks() by the mm_all_locks_mutex.
  *
@@ -2632,7 +2632,7 @@ static void vm_unlock_mapping(struct add
 		 * AS_MM_ALL_LOCKS can't change to 0 from under us
 		 * because we hold the mm_all_locks_mutex.
 		 */
-		spin_unlock(&mapping->i_mmap_lock);
+		mutex_unlock(&mapping->i_mmap_mutex);
 		if (!test_and_clear_bit(AS_MM_ALL_LOCKS,
 					&mapping->flags))
 			BUG();
diff -puN mm/mremap.c~mm-convert-i_mmap_lock-to-a-mutex mm/mremap.c
--- a/mm/mremap.c~mm-convert-i_mmap_lock-to-a-mutex
+++ a/mm/mremap.c
@@ -93,7 +93,7 @@ static void move_ptes(struct vm_area_str
 		 * and we propagate stale pages into the dst afterward.
 		 */
 		mapping = vma->vm_file->f_mapping;
-		spin_lock(&mapping->i_mmap_lock);
+		mutex_lock(&mapping->i_mmap_mutex);
 	}
 
 	/*
@@ -122,7 +122,7 @@ static void move_ptes(struct vm_area_str
 	pte_unmap(new_pte - 1);
 	pte_unmap_unlock(old_pte - 1, old_ptl);
 	if (mapping)
-		spin_unlock(&mapping->i_mmap_lock);
+		mutex_unlock(&mapping->i_mmap_mutex);
 	mmu_notifier_invalidate_range_end(vma->vm_mm, old_start, old_end);
 }
 
diff -puN mm/rmap.c~mm-convert-i_mmap_lock-to-a-mutex mm/rmap.c
--- a/mm/rmap.c~mm-convert-i_mmap_lock-to-a-mutex
+++ a/mm/rmap.c
@@ -24,7 +24,7 @@
  *   inode->i_alloc_sem (vmtruncate_range)
  *   mm->mmap_sem
  *     page->flags PG_locked (lock_page)
- *       mapping->i_mmap_lock
+ *       mapping->i_mmap_mutex
  *         anon_vma->lock
  *           mm->page_table_lock or pte_lock
  *             zone->lru_lock (in mark_page_accessed, isolate_lru_page)
@@ -646,14 +646,14 @@ static int page_referenced_file(struct p
 	 * The page lock not only makes sure that page->mapping cannot
 	 * suddenly be NULLified by truncation, it makes sure that the
 	 * structure at mapping cannot be freed and reused yet,
-	 * so we can safely take mapping->i_mmap_lock.
+	 * so we can safely take mapping->i_mmap_mutex.
 	 */
 	BUG_ON(!PageLocked(page));
 
-	spin_lock(&mapping->i_mmap_lock);
+	mutex_lock(&mapping->i_mmap_mutex);
 
 	/*
-	 * i_mmap_lock does not stabilize mapcount at all, but mapcount
+	 * i_mmap_mutex does not stabilize mapcount at all, but mapcount
 	 * is more likely to be accurate if we note it after spinning.
 	 */
 	mapcount = page_mapcount(page);
@@ -675,7 +675,7 @@ static int page_referenced_file(struct p
 			break;
 	}
 
-	spin_unlock(&mapping->i_mmap_lock);
+	mutex_unlock(&mapping->i_mmap_mutex);
 	return referenced;
 }
 
@@ -762,7 +762,7 @@ static int page_mkclean_file(struct addr
 
 	BUG_ON(PageAnon(page));
 
-	spin_lock(&mapping->i_mmap_lock);
+	mutex_lock(&mapping->i_mmap_mutex);
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
 		if (vma->vm_flags & VM_SHARED) {
 			unsigned long address = vma_address(page, vma);
@@ -771,7 +771,7 @@ static int page_mkclean_file(struct addr
 			ret += page_mkclean_one(page, vma, address);
 		}
 	}
-	spin_unlock(&mapping->i_mmap_lock);
+	mutex_unlock(&mapping->i_mmap_mutex);
 	return ret;
 }
 
@@ -1122,7 +1122,7 @@ out_mlock:
 	/*
 	 * We need mmap_sem locking, Otherwise VM_LOCKED check makes
 	 * unstable result and race. Plus, We can't wait here because
-	 * we now hold anon_vma->lock or mapping->i_mmap_lock.
+	 * we now hold anon_vma->lock or mapping->i_mmap_mutex.
 	 * if trylock failed, the page remain in evictable lru and later
 	 * vmscan could retry to move the page to unevictable lru if the
 	 * page is actually mlocked.
@@ -1348,7 +1348,7 @@ static int try_to_unmap_file(struct page
 	unsigned long max_nl_size = 0;
 	unsigned int mapcount;
 
-	spin_lock(&mapping->i_mmap_lock);
+	mutex_lock(&mapping->i_mmap_mutex);
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
 		unsigned long address = vma_address(page, vma);
 		if (address == -EFAULT)
@@ -1394,7 +1394,7 @@ static int try_to_unmap_file(struct page
 	mapcount = page_mapcount(page);
 	if (!mapcount)
 		goto out;
-	cond_resched_lock(&mapping->i_mmap_lock);
+	cond_resched();
 
 	max_nl_size = (max_nl_size + CLUSTER_SIZE - 1) & CLUSTER_MASK;
 	if (max_nl_cursor == 0)
@@ -1416,7 +1416,7 @@ static int try_to_unmap_file(struct page
 			}
 			vma->vm_private_data = (void *) max_nl_cursor;
 		}
-		cond_resched_lock(&mapping->i_mmap_lock);
+		cond_resched();
 		max_nl_cursor += CLUSTER_SIZE;
 	} while (max_nl_cursor <= max_nl_size);
 
@@ -1428,7 +1428,7 @@ static int try_to_unmap_file(struct page
 	list_for_each_entry(vma, &mapping->i_mmap_nonlinear, shared.vm_set.list)
 		vma->vm_private_data = NULL;
 out:
-	spin_unlock(&mapping->i_mmap_lock);
+	mutex_unlock(&mapping->i_mmap_mutex);
 	return ret;
 }
 
@@ -1547,7 +1547,7 @@ static int rmap_walk_file(struct page *p
 
 	if (!mapping)
 		return ret;
-	spin_lock(&mapping->i_mmap_lock);
+	mutex_lock(&mapping->i_mmap_mutex);
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
 		unsigned long address = vma_address(page, vma);
 		if (address == -EFAULT)
@@ -1561,7 +1561,7 @@ static int rmap_walk_file(struct page *p
 	 * never contain migration ptes.  Decide what to do about this
 	 * limitation to linear when we need rmap_walk() on nonlinear.
 	 */
-	spin_unlock(&mapping->i_mmap_lock);
+	mutex_unlock(&mapping->i_mmap_mutex);
 	return ret;
 }
 
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
linux-next.patch
cpumask-convert-cpumask_of_cpu-to-cpumask_of.patch

