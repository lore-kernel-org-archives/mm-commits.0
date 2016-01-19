From: akpm@linux-foundation.org
Subject: [merged] mm-fix-locking-order-in-mm_take_all_locks.patch removed
 from -mm tree
Date: Tue, 19 Jan 2016 12:14:16 -0800
Message-ID: <569e9918.XT2FBsygb+r8C1CJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44449 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139AbcASUOR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:14:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, dvyukov@google.com, mhocko@suse.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix locking order in mm_take_all_locks()
has been removed from the -mm tree.  Its filename was
     mm-fix-locking-order-in-mm_take_all_locks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: fix locking order in mm_take_all_locks()

Dmitry Vyukov has reported[1] possible deadlock (triggered by his
syzkaller fuzzer):

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&hugetlbfs_i_mmap_rwsem_key);
                               lock(&mapping->i_mmap_rwsem);
                               lock(&hugetlbfs_i_mmap_rwsem_key);
  lock(&mapping->i_mmap_rwsem);

Both traces points to mm_take_all_locks() as a source of the problem.  It
doesn't take care about ordering or hugetlbfs_i_mmap_rwsem_key (aka
mapping->i_mmap_rwsem for hugetlb mapping) vs.  i_mmap_rwsem.

huge_pmd_share() does memory allocation under hugetlbfs_i_mmap_rwsem_key
and allocator can take i_mmap_rwsem if it hit reclaim.  So we need to take
i_mmap_rwsem from all hugetlb VMAs before taking i_mmap_rwsem from rest of
VMAs.

The patch also documents locking order for hugetlbfs_i_mmap_rwsem_key.

[1] http://lkml.kernel.org/r/CACT4Y+Zu95tBs-0EvdiAKzUOsb4tczRRfCRTpLr4bg_OP9HuVg@mail.gmail.com

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Michal Hocko <mhocko@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 +-
 mm/mmap.c            |   25 ++++++++++++++++++++-----
 mm/rmap.c            |   31 ++++++++++++++++---------------
 3 files changed, 37 insertions(+), 21 deletions(-)

diff -puN fs/hugetlbfs/inode.c~mm-fix-locking-order-in-mm_take_all_locks fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-fix-locking-order-in-mm_take_all_locks
+++ a/fs/hugetlbfs/inode.c
@@ -708,7 +708,7 @@ static struct inode *hugetlbfs_get_root(
 /*
  * Hugetlbfs is not reclaimable; therefore its i_mmap_rwsem will never
  * be taken from reclaim -- unlike regular filesystems. This needs an
- * annotation because huge_pmd_share() does an allocation under
+ * annotation because huge_pmd_share() does an allocation under hugetlb's
  * i_mmap_rwsem.
  */
 static struct lock_class_key hugetlbfs_i_mmap_rwsem_key;
diff -puN mm/mmap.c~mm-fix-locking-order-in-mm_take_all_locks mm/mmap.c
--- a/mm/mmap.c~mm-fix-locking-order-in-mm_take_all_locks
+++ a/mm/mmap.c
@@ -3184,10 +3184,16 @@ static void vm_lock_mapping(struct mm_st
  * mapping->flags avoid to take the same lock twice, if more than one
  * vma in this mm is backed by the same anon_vma or address_space.
  *
- * We can take all the locks in random order because the VM code
- * taking i_mmap_rwsem or anon_vma->rwsem outside the mmap_sem never
- * takes more than one of them in a row. Secondly we're protected
- * against a concurrent mm_take_all_locks() by the mm_all_locks_mutex.
+ * We take locks in following order, accordingly to comment at beginning
+ * of mm/rmap.c:
+ *   - all hugetlbfs_i_mmap_rwsem_key locks (aka mapping->i_mmap_rwsem for
+ *     hugetlb mapping);
+ *   - all i_mmap_rwsem locks;
+ *   - all anon_vma->rwseml
+ *
+ * We can take all locks within these types randomly because the VM code
+ * doesn't nest them and we protected from parallel mm_take_all_locks() by
+ * mm_all_locks_mutex.
  *
  * mm_take_all_locks() and mm_drop_all_locks are expensive operations
  * that may have to take thousand of locks.
@@ -3206,7 +3212,16 @@ int mm_take_all_locks(struct mm_struct *
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
 		if (signal_pending(current))
 			goto out_unlock;
-		if (vma->vm_file && vma->vm_file->f_mapping)
+		if (vma->vm_file && vma->vm_file->f_mapping &&
+				is_vm_hugetlb_page(vma))
+			vm_lock_mapping(mm, vma->vm_file->f_mapping);
+	}
+
+	for (vma = mm->mmap; vma; vma = vma->vm_next) {
+		if (signal_pending(current))
+			goto out_unlock;
+		if (vma->vm_file && vma->vm_file->f_mapping &&
+				!is_vm_hugetlb_page(vma))
 			vm_lock_mapping(mm, vma->vm_file->f_mapping);
 	}
 
diff -puN mm/rmap.c~mm-fix-locking-order-in-mm_take_all_locks mm/rmap.c
--- a/mm/rmap.c~mm-fix-locking-order-in-mm_take_all_locks
+++ a/mm/rmap.c
@@ -23,21 +23,22 @@
  * inode->i_mutex	(while writing or truncating, not reading or faulting)
  *   mm->mmap_sem
  *     page->flags PG_locked (lock_page)
- *       mapping->i_mmap_rwsem
- *         anon_vma->rwsem
- *           mm->page_table_lock or pte_lock
- *             zone->lru_lock (in mark_page_accessed, isolate_lru_page)
- *             swap_lock (in swap_duplicate, swap_info_get)
- *               mmlist_lock (in mmput, drain_mmlist and others)
- *               mapping->private_lock (in __set_page_dirty_buffers)
- *                 mem_cgroup_{begin,end}_page_stat (memcg->move_lock)
- *                   mapping->tree_lock (widely used)
- *               inode->i_lock (in set_page_dirty's __mark_inode_dirty)
- *               bdi.wb->list_lock (in set_page_dirty's __mark_inode_dirty)
- *                 sb_lock (within inode_lock in fs/fs-writeback.c)
- *                 mapping->tree_lock (widely used, in set_page_dirty,
- *                           in arch-dependent flush_dcache_mmap_lock,
- *                           within bdi.wb->list_lock in __sync_single_inode)
+ *       hugetlbfs_i_mmap_rwsem_key (in huge_pmd_share)
+ *         mapping->i_mmap_rwsem
+ *           anon_vma->rwsem
+ *             mm->page_table_lock or pte_lock
+ *               zone->lru_lock (in mark_page_accessed, isolate_lru_page)
+ *               swap_lock (in swap_duplicate, swap_info_get)
+ *                 mmlist_lock (in mmput, drain_mmlist and others)
+ *                 mapping->private_lock (in __set_page_dirty_buffers)
+ *                   mem_cgroup_{begin,end}_page_stat (memcg->move_lock)
+ *                     mapping->tree_lock (widely used)
+ *                 inode->i_lock (in set_page_dirty's __mark_inode_dirty)
+ *                 bdi.wb->list_lock (in set_page_dirty's __mark_inode_dirty)
+ *                   sb_lock (within inode_lock in fs/fs-writeback.c)
+ *                   mapping->tree_lock (widely used, in set_page_dirty,
+ *                             in arch-dependent flush_dcache_mmap_lock,
+ *                             within bdi.wb->list_lock in __sync_single_inode)
  *
  * anon_vma->rwsem,mapping->i_mutex      (memory_failure, collect_procs_anon)
  *   ->tasklist_lock
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

