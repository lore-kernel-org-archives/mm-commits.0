From: akpm@linux-foundation.org
Subject: [merged] mm-convert-i_mmap_mutex-to-rwsem.patch removed from -mm
 tree
Date: Sat, 13 Dec 2014 20:06:26 -0800
Message-ID: <548d0cc2.0Vo+9HwqvibvVlXz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47440 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbaLNEGT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:06:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, hughd@google.com, kirill@shutemov.name, mgorman@suse.de, oleg@redhat.com, peterz@infradead.org, riel@redhat.com, sfr@canb.auug.org.au, srikar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert i_mmap_mutex to rwsem
has been removed from the -mm tree.  Its filename was
     mm-convert-i_mmap_mutex-to-rwsem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: mm: convert i_mmap_mutex to rwsem

The i_mmap_mutex is a close cousin of the anon vma lock, both protecting
similar data, one for file backed pages and the other for anon memory.  To
this end, this lock can also be a rwsem.  In addition, there are some
important opportunities to share the lock when there are no tree
modifications.

This conversion is straightforward.  For now, all users take the write
lock.

[sfr@canb.auug.org.au: update fremap.c]
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: "Kirill A. Shutemov" <kirill@shutemov.name>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c         |   10 +++++-----
 fs/inode.c                   |    2 +-
 include/linux/fs.h           |    7 ++++---
 include/linux/mmu_notifier.h |    2 +-
 kernel/events/uprobes.c      |    2 +-
 mm/filemap.c                 |   10 +++++-----
 mm/hugetlb.c                 |   10 +++++-----
 mm/mmap.c                    |    8 ++++----
 mm/mremap.c                  |    2 +-
 mm/rmap.c                    |    6 +++---
 10 files changed, 30 insertions(+), 29 deletions(-)

diff -puN fs/hugetlbfs/inode.c~mm-convert-i_mmap_mutex-to-rwsem fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-convert-i_mmap_mutex-to-rwsem
+++ a/fs/hugetlbfs/inode.c
@@ -472,12 +472,12 @@ static struct inode *hugetlbfs_get_root(
 }
 
 /*
- * Hugetlbfs is not reclaimable; therefore its i_mmap_mutex will never
+ * Hugetlbfs is not reclaimable; therefore its i_mmap_rwsem will never
  * be taken from reclaim -- unlike regular filesystems. This needs an
  * annotation because huge_pmd_share() does an allocation under
- * i_mmap_mutex.
+ * i_mmap_rwsem.
  */
-static struct lock_class_key hugetlbfs_i_mmap_mutex_key;
+static struct lock_class_key hugetlbfs_i_mmap_rwsem_key;
 
 static struct inode *hugetlbfs_get_inode(struct super_block *sb,
 					struct inode *dir,
@@ -495,8 +495,8 @@ static struct inode *hugetlbfs_get_inode
 		struct hugetlbfs_inode_info *info;
 		inode->i_ino = get_next_ino();
 		inode_init_owner(inode, dir, mode);
-		lockdep_set_class(&inode->i_mapping->i_mmap_mutex,
-				&hugetlbfs_i_mmap_mutex_key);
+		lockdep_set_class(&inode->i_mapping->i_mmap_rwsem,
+				&hugetlbfs_i_mmap_rwsem_key);
 		inode->i_mapping->a_ops = &hugetlbfs_aops;
 		inode->i_mapping->backing_dev_info =&hugetlbfs_backing_dev_info;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
diff -puN fs/inode.c~mm-convert-i_mmap_mutex-to-rwsem fs/inode.c
--- a/fs/inode.c~mm-convert-i_mmap_mutex-to-rwsem
+++ a/fs/inode.c
@@ -346,7 +346,7 @@ void address_space_init_once(struct addr
 	memset(mapping, 0, sizeof(*mapping));
 	INIT_RADIX_TREE(&mapping->page_tree, GFP_ATOMIC);
 	spin_lock_init(&mapping->tree_lock);
-	mutex_init(&mapping->i_mmap_mutex);
+	init_rwsem(&mapping->i_mmap_rwsem);
 	INIT_LIST_HEAD(&mapping->private_list);
 	spin_lock_init(&mapping->private_lock);
 	mapping->i_mmap = RB_ROOT;
diff -puN include/linux/fs.h~mm-convert-i_mmap_mutex-to-rwsem include/linux/fs.h
--- a/include/linux/fs.h~mm-convert-i_mmap_mutex-to-rwsem
+++ a/include/linux/fs.h
@@ -18,6 +18,7 @@
 #include <linux/pid.h>
 #include <linux/bug.h>
 #include <linux/mutex.h>
+#include <linux/rwsem.h>
 #include <linux/capability.h>
 #include <linux/semaphore.h>
 #include <linux/fiemap.h>
@@ -401,7 +402,7 @@ struct address_space {
 	atomic_t		i_mmap_writable;/* count VM_SHARED mappings */
 	struct rb_root		i_mmap;		/* tree of private and shared mappings */
 	struct list_head	i_mmap_nonlinear;/*list VM_NONLINEAR mappings */
-	struct mutex		i_mmap_mutex;	/* protect tree, count, list */
+	struct rw_semaphore	i_mmap_rwsem;	/* protect tree, count, list */
 	/* Protected by tree_lock together with the radix tree */
 	unsigned long		nrpages;	/* number of total pages */
 	unsigned long		nrshadows;	/* number of shadow entries */
@@ -469,12 +470,12 @@ int mapping_tagged(struct address_space
 
 static inline void i_mmap_lock_write(struct address_space *mapping)
 {
-	mutex_lock(&mapping->i_mmap_mutex);
+	down_write(&mapping->i_mmap_rwsem);
 }
 
 static inline void i_mmap_unlock_write(struct address_space *mapping)
 {
-	mutex_unlock(&mapping->i_mmap_mutex);
+	up_write(&mapping->i_mmap_rwsem);
 }
 
 /*
diff -puN include/linux/mmu_notifier.h~mm-convert-i_mmap_mutex-to-rwsem include/linux/mmu_notifier.h
--- a/include/linux/mmu_notifier.h~mm-convert-i_mmap_mutex-to-rwsem
+++ a/include/linux/mmu_notifier.h
@@ -154,7 +154,7 @@ struct mmu_notifier_ops {
  * Therefore notifier chains can only be traversed when either
  *
  * 1. mmap_sem is held.
- * 2. One of the reverse map locks is held (i_mmap_mutex or anon_vma->rwsem).
+ * 2. One of the reverse map locks is held (i_mmap_rwsem or anon_vma->rwsem).
  * 3. No other concurrent thread can access the list (release)
  */
 struct mmu_notifier {
diff -puN kernel/events/uprobes.c~mm-convert-i_mmap_mutex-to-rwsem kernel/events/uprobes.c
--- a/kernel/events/uprobes.c~mm-convert-i_mmap_mutex-to-rwsem
+++ a/kernel/events/uprobes.c
@@ -731,7 +731,7 @@ build_map_info(struct address_space *map
 
 		if (!prev && !more) {
 			/*
-			 * Needs GFP_NOWAIT to avoid i_mmap_mutex recursion through
+			 * Needs GFP_NOWAIT to avoid i_mmap_rwsem recursion through
 			 * reclaim. This is optimistic, no harm done if it fails.
 			 */
 			prev = kmalloc(sizeof(struct map_info),
diff -puN mm/filemap.c~mm-convert-i_mmap_mutex-to-rwsem mm/filemap.c
--- a/mm/filemap.c~mm-convert-i_mmap_mutex-to-rwsem
+++ a/mm/filemap.c
@@ -62,16 +62,16 @@
 /*
  * Lock ordering:
  *
- *  ->i_mmap_mutex		(truncate_pagecache)
+ *  ->i_mmap_rwsem		(truncate_pagecache)
  *    ->private_lock		(__free_pte->__set_page_dirty_buffers)
  *      ->swap_lock		(exclusive_swap_page, others)
  *        ->mapping->tree_lock
  *
  *  ->i_mutex
- *    ->i_mmap_mutex		(truncate->unmap_mapping_range)
+ *    ->i_mmap_rwsem		(truncate->unmap_mapping_range)
  *
  *  ->mmap_sem
- *    ->i_mmap_mutex
+ *    ->i_mmap_rwsem
  *      ->page_table_lock or pte_lock	(various, mainly in memory.c)
  *        ->mapping->tree_lock	(arch-dependent flush_dcache_mmap_lock)
  *
@@ -85,7 +85,7 @@
  *    sb_lock			(fs/fs-writeback.c)
  *    ->mapping->tree_lock	(__sync_single_inode)
  *
- *  ->i_mmap_mutex
+ *  ->i_mmap_rwsem
  *    ->anon_vma.lock		(vma_adjust)
  *
  *  ->anon_vma.lock
@@ -105,7 +105,7 @@
  *    ->inode->i_lock		(zap_pte_range->set_page_dirty)
  *    ->private_lock		(zap_pte_range->__set_page_dirty_buffers)
  *
- * ->i_mmap_mutex
+ * ->i_mmap_rwsem
  *   ->tasklist_lock            (memory_failure, collect_procs_ao)
  */
 
diff -puN mm/hugetlb.c~mm-convert-i_mmap_mutex-to-rwsem mm/hugetlb.c
--- a/mm/hugetlb.c~mm-convert-i_mmap_mutex-to-rwsem
+++ a/mm/hugetlb.c
@@ -2726,9 +2726,9 @@ void __unmap_hugepage_range_final(struct
 	 * on its way out.  We're lucky that the flag has such an appropriate
 	 * name, and can in fact be safely cleared here. We could clear it
 	 * before the __unmap_hugepage_range above, but all that's necessary
-	 * is to clear it before releasing the i_mmap_mutex. This works
+	 * is to clear it before releasing the i_mmap_rwsem. This works
 	 * because in the context this is called, the VMA is about to be
-	 * destroyed and the i_mmap_mutex is held.
+	 * destroyed and the i_mmap_rwsem is held.
 	 */
 	vma->vm_flags &= ~VM_MAYSHARE;
 }
@@ -3370,9 +3370,9 @@ unsigned long hugetlb_change_protection(
 		spin_unlock(ptl);
 	}
 	/*
-	 * Must flush TLB before releasing i_mmap_mutex: x86's huge_pmd_unshare
+	 * Must flush TLB before releasing i_mmap_rwsem: x86's huge_pmd_unshare
 	 * may have cleared our pud entry and done put_page on the page table:
-	 * once we release i_mmap_mutex, another task can do the final put_page
+	 * once we release i_mmap_rwsem, another task can do the final put_page
 	 * and that page table be reused and filled with junk.
 	 */
 	flush_tlb_range(vma, start, end);
@@ -3525,7 +3525,7 @@ static int vma_shareable(struct vm_area_
  * and returns the corresponding pte. While this is not necessary for the
  * !shared pmd case because we can allocate the pmd later as well, it makes the
  * code much cleaner. pmd allocation is essential for the shared case because
- * pud has to be populated inside the same i_mmap_mutex section - otherwise
+ * pud has to be populated inside the same i_mmap_rwsem section - otherwise
  * racing tasks could either miss the sharing (see huge_pte_offset) or select a
  * bad pmd for sharing.
  */
diff -puN mm/mmap.c~mm-convert-i_mmap_mutex-to-rwsem mm/mmap.c
--- a/mm/mmap.c~mm-convert-i_mmap_mutex-to-rwsem
+++ a/mm/mmap.c
@@ -232,7 +232,7 @@ error:
 }
 
 /*
- * Requires inode->i_mapping->i_mmap_mutex
+ * Requires inode->i_mapping->i_mmap_rwsem
  */
 static void __remove_shared_vm_struct(struct vm_area_struct *vma,
 		struct file *file, struct address_space *mapping)
@@ -2791,7 +2791,7 @@ void exit_mmap(struct mm_struct *mm)
 
 /* Insert vm structure into process list sorted by address
  * and into the inode's i_mmap tree.  If vm_file is non-NULL
- * then i_mmap_mutex is taken here.
+ * then i_mmap_rwsem is taken here.
  */
 int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 {
@@ -3086,7 +3086,7 @@ static void vm_lock_mapping(struct mm_st
 		 */
 		if (test_and_set_bit(AS_MM_ALL_LOCKS, &mapping->flags))
 			BUG();
-		mutex_lock_nest_lock(&mapping->i_mmap_mutex, &mm->mmap_sem);
+		down_write_nest_lock(&mapping->i_mmap_rwsem, &mm->mmap_sem);
 	}
 }
 
@@ -3113,7 +3113,7 @@ static void vm_lock_mapping(struct mm_st
  * vma in this mm is backed by the same anon_vma or address_space.
  *
  * We can take all the locks in random order because the VM code
- * taking i_mmap_mutex or anon_vma->rwsem outside the mmap_sem never
+ * taking i_mmap_rwsem or anon_vma->rwsem outside the mmap_sem never
  * takes more than one of them in a row. Secondly we're protected
  * against a concurrent mm_take_all_locks() by the mm_all_locks_mutex.
  *
diff -puN mm/mremap.c~mm-convert-i_mmap_mutex-to-rwsem mm/mremap.c
--- a/mm/mremap.c~mm-convert-i_mmap_mutex-to-rwsem
+++ a/mm/mremap.c
@@ -99,7 +99,7 @@ static void move_ptes(struct vm_area_str
 	spinlock_t *old_ptl, *new_ptl;
 
 	/*
-	 * When need_rmap_locks is true, we take the i_mmap_mutex and anon_vma
+	 * When need_rmap_locks is true, we take the i_mmap_rwsem and anon_vma
 	 * locks to ensure that rmap will always observe either the old or the
 	 * new ptes. This is the easiest way to avoid races with
 	 * truncate_pagecache(), page migration, etc...
diff -puN mm/rmap.c~mm-convert-i_mmap_mutex-to-rwsem mm/rmap.c
--- a/mm/rmap.c~mm-convert-i_mmap_mutex-to-rwsem
+++ a/mm/rmap.c
@@ -23,7 +23,7 @@
  * inode->i_mutex	(while writing or truncating, not reading or faulting)
  *   mm->mmap_sem
  *     page->flags PG_locked (lock_page)
- *       mapping->i_mmap_mutex
+ *       mapping->i_mmap_rwsem
  *         anon_vma->rwsem
  *           mm->page_table_lock or pte_lock
  *             zone->lru_lock (in mark_page_accessed, isolate_lru_page)
@@ -1260,7 +1260,7 @@ out_mlock:
 	/*
 	 * We need mmap_sem locking, Otherwise VM_LOCKED check makes
 	 * unstable result and race. Plus, We can't wait here because
-	 * we now hold anon_vma->rwsem or mapping->i_mmap_mutex.
+	 * we now hold anon_vma->rwsem or mapping->i_mmap_rwsem.
 	 * if trylock failed, the page remain in evictable lru and later
 	 * vmscan could retry to move the page to unevictable lru if the
 	 * page is actually mlocked.
@@ -1684,7 +1684,7 @@ static int rmap_walk_file(struct page *p
 	 * The page lock not only makes sure that page->mapping cannot
 	 * suddenly be NULLified by truncation, it makes sure that the
 	 * structure at mapping cannot be freed and reused yet,
-	 * so we can safely take mapping->i_mmap_mutex.
+	 * so we can safely take mapping->i_mmap_rwsem.
 	 */
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 
_

Patches currently in -mm which might be from dave@stgolabs.net are

origin.patch

