From: akpm@linux-foundation.org
Subject: + mm-fix-locking-order-in-mm_take_all_locks.patch added to -mm
 tree
Date: Mon, 11 Jan 2016 13:35:26 -0800
Message-ID: <5694201e.HmphEAl4VlAMbgf4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48792 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758236AbcAKVf1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jan 2016 16:35:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, dvyukov@google.com, mhocko@suse.cz, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix locking order in mm_take_all_locks()
has been added to the -mm tree.  Its filename is
     mm-fix-locking-order-in-mm_take_all_locks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-locking-order-in-mm_take_all_locks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-locking-order-in-mm_take_all_locks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Michal Hocko <mhocko@suse.cz>
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
@@ -711,7 +711,7 @@ static struct inode *hugetlbfs_get_root(
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

mm-make-sure-isolate_lru_page-is-never-called-for-tail-page.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-move-code-around.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages-fix.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-at-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
page-flags-drop-__testclearpage-helpers.patch
mm-proc-adjust-pss-calculation.patch
rmap-add-argument-to-charge-compound-page.patch
memcg-adjust-to-support-new-thp-refcounting.patch
mm-thp-adjust-conditions-when-we-can-reuse-the-page-on-wp-fault.patch
mm-adjust-foll_split-for-new-refcounting.patch
mm-handle-pte-mapped-tail-pages-in-gerneric-fast-gup-implementaiton.patch
thp-mlock-do-not-allow-huge-pages-in-mlocked-area.patch
khugepaged-ignore-pmd-tables-with-thp-mapped-with-ptes.patch
thp-rename-split_huge_page_pmd-to-split_huge_pmd.patch
mm-vmstats-new-thp-splitting-event.patch
mm-temporally-mark-thp-broken.patch
thp-drop-all-split_huge_page-related-code.patch
mm-drop-tail-page-refcounting.patch
futex-thp-remove-special-case-for-thp-in-get_futex_key.patch
ksm-prepare-to-new-thp-semantics.patch
mm-thp-remove-compound_lock.patch
arm64-thp-remove-infrastructure-for-handling-splitting-pmds.patch
arm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mips-thp-remove-infrastructure-for-handling-splitting-pmds.patch
powerpc-thp-remove-infrastructure-for-handling-splitting-pmds.patch
s390-thp-remove-infrastructure-for-handling-splitting-pmds.patch
sparc-thp-remove-infrastructure-for-handling-splitting-pmds.patch
tile-thp-remove-infrastructure-for-handling-splitting-pmds.patch
x86-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-2.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-3.patch
mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages.patch
mm-numa-skip-pte-mapped-thp-on-numa-fault.patch
thp-implement-split_huge_pmd.patch
thp-add-option-to-setup-migration-entries-during-pmd-split.patch
thp-mm-split_huge_page-caller-need-to-lock-page.patch
thp-reintroduce-split_huge_page.patch
thp-reintroduce-split_huge_page-fix-3.patch
thp-reintroduce-split_huge_page-fix-4.patch
migrate_pages-try-to-split-pages-on-qeueuing.patch
thp-introduce-deferred_split_huge_page.patch
thp-introduce-deferred_split_huge_page-fix.patch
mm-re-enable-thp.patch
thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
thp-allow-mlocked-thp-again-fix.patch
thp-allow-mlocked-thp-again-fix-2.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-fix-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-fix-fix-fix.patch
thp-add-debugfs-handle-to-split-all-huge-pages.patch
thp-increase-split_huge_page-success-rate.patch
mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-fix.patch
memblock-fix-section-mismatch.patch
mm-oom-introduce-oom-reaper-fix-6.patch
mm-fix-locking-order-in-mm_take_all_locks.patch

