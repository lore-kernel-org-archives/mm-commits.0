From: akpm@linux-foundation.org
Subject: [merged]
 hugetlbfs-use-i_mmap_rwsem-for-more-pmd-sharing-synchronization.patch
 removed from -mm tree
Date: Fri, 03 Apr 2020 13:40:25 -0700
Message-ID: <20200403204025.wkWkVPi7G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727835AbgDCUk1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:40:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, dave@stgolabs.net, hughd@google.com, kirill.shutemov@linux.intel.com, mhocko@kernel.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, prakash.sangappa@oracle.com


The patch titled
     Subject: hugetlbfs: use i_mmap_rwsem for more pmd sharing synchronization
has been removed from the -mm tree.  Its filename was
     hugetlbfs-use-i_mmap_rwsem-for-more-pmd-sharing-synchronization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlbfs: use i_mmap_rwsem for more pmd sharing synchronization

Patch series "hugetlbfs: use i_mmap_rwsem for more synchronization", v2.

While discussing the issue with huge_pte_offset [1], I remembered that
there were more outstanding hugetlb races.  These issues are:

1) For shared pmds, huge PTE pointers returned by huge_pte_alloc can become
   invalid via a call to huge_pmd_unshare by another thread.
2) hugetlbfs page faults can race with truncation causing invalid global
   reserve counts and state.

A previous attempt was made to use i_mmap_rwsem in this manner as
described at [2].  However, those patches were reverted starting with [3]
due to locking issues.

To effectively use i_mmap_rwsem to address the above issues it needs to be
held (in read mode) during page fault processing.  However, during fault
processing we need to lock the page we will be adding.  Lock ordering
requires we take page lock before i_mmap_rwsem.  Waiting until after
taking the page lock is too late in the fault process for the
synchronization we want to do.

To address this lock ordering issue, the following patches change the lock
ordering for hugetlb pages.  This is not too invasive as hugetlbfs
processing is done separate from core mm in many places.  However, I don't
really like this idea.  Much ugliness is contained in the new routine
hugetlb_page_mapping_lock_write() of patch 1.

The only other way I can think of to address these issues is by catching
all the races.  After catching a race, cleanup, backout, retry ...  etc,
as needed.  This can get really ugly, especially for huge page
reservations.  At one time, I started writing some of the reservation
backout code for page faults and it got so ugly and complicated I went
down the path of adding synchronization to avoid the races.  Any other
suggestions would be welcome.

[1] https://lore.kernel.org/linux-mm/1582342427-230392-1-git-send-email-longpeng2@huawei.com/
[2] https://lore.kernel.org/linux-mm/20181222223013.22193-1-mike.kravetz@oracle.com/
[3] https://lore.kernel.org/linux-mm/20190103235452.29335-1-mike.kravetz@oracle.com
[4] https://lore.kernel.org/linux-mm/1584028670.7365.182.camel@lca.pw/
[5] https://lore.kernel.org/lkml/20200312183142.108df9ac@canb.auug.org.au/


This patch (of 2):

While looking at BUGs associated with invalid huge page map counts, it was
discovered and observed that a huge pte pointer could become 'invalid' and
point to another task's page table.  Consider the following:

A task takes a page fault on a shared hugetlbfs file and calls
huge_pte_alloc to get a ptep.  Suppose the returned ptep points to a
shared pmd.

Now, another task truncates the hugetlbfs file.  As part of truncation, it
unmaps everyone who has the file mapped.  If the range being truncated is
covered by a shared pmd, huge_pmd_unshare will be called.  For all but the
last user of the shared pmd, huge_pmd_unshare will clear the pud pointing
to the pmd.  If the task in the middle of the page fault is not the last
user, the ptep returned by huge_pte_alloc now points to another task's
page table or worse.  This leads to bad things such as incorrect page
map/reference counts or invalid memory references.

To fix, expand the use of i_mmap_rwsem as follows:
- i_mmap_rwsem is held in read mode whenever huge_pmd_share is called.
  huge_pmd_share is only called via huge_pte_alloc, so callers of
  huge_pte_alloc take i_mmap_rwsem before calling.  In addition, callers
  of huge_pte_alloc continue to hold the semaphore until finished with
  the ptep.
- i_mmap_rwsem is held in write mode whenever huge_pmd_unshare is called.

One problem with this scheme is that it requires taking i_mmap_rwsem
before taking the page lock during page faults.  This is not the order
specified in the rest of mm code.  Handling of hugetlbfs pages is mostly
isolated today.  Therefore, we use this alternative locking order for
PageHuge() pages.

         mapping->i_mmap_rwsem
           hugetlb_fault_mutex (hugetlbfs specific page fault mutex)
             page->flags PG_locked (lock_page)

To help with lock ordering issues, hugetlb_page_mapping_lock_write() is
introduced to write lock the i_mmap_rwsem associated with a page.

In most cases it is easy to get address_space via vma->vm_file->f_mapping.
However, in the case of migration or memory errors for anon pages we do
not have an associated vma.  A new routine _get_hugetlb_page_mapping()
will use anon_vma to get address_space in these cases.

Link: http://lkml.kernel.org/r/20200316205756.146666-2-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Prakash Sangappa <prakash.sangappa@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c    |    2 
 include/linux/fs.h      |    5 +
 include/linux/hugetlb.h |    8 +
 mm/hugetlb.c            |  156 +++++++++++++++++++++++++++++++++++---
 mm/memory-failure.c     |   29 ++++++-
 mm/migrate.c            |   25 +++++-
 mm/rmap.c               |   17 +++-
 mm/userfaultfd.c        |   11 ++
 8 files changed, 234 insertions(+), 19 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-use-i_mmap_rwsem-for-more-pmd-sharing-synchronization
+++ a/fs/hugetlbfs/inode.c
@@ -450,7 +450,9 @@ static void remove_inode_hugepages(struc
 			if (unlikely(page_mapped(page))) {
 				BUG_ON(truncate_op);
 
+				mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 				i_mmap_lock_write(mapping);
+				mutex_lock(&hugetlb_fault_mutex_table[hash]);
 				hugetlb_vmdelete_list(&mapping->i_mmap,
 					index * pages_per_huge_page(h),
 					(index + 1) * pages_per_huge_page(h));
--- a/include/linux/fs.h~hugetlbfs-use-i_mmap_rwsem-for-more-pmd-sharing-synchronization
+++ a/include/linux/fs.h
@@ -526,6 +526,11 @@ static inline void i_mmap_lock_write(str
 	down_write(&mapping->i_mmap_rwsem);
 }
 
+static inline int i_mmap_trylock_write(struct address_space *mapping)
+{
+	return down_write_trylock(&mapping->i_mmap_rwsem);
+}
+
 static inline void i_mmap_unlock_write(struct address_space *mapping)
 {
 	up_write(&mapping->i_mmap_rwsem);
--- a/include/linux/hugetlb.h~hugetlbfs-use-i_mmap_rwsem-for-more-pmd-sharing-synchronization
+++ a/include/linux/hugetlb.h
@@ -109,6 +109,8 @@ u32 hugetlb_fault_mutex_hash(struct addr
 
 pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud);
 
+struct address_space *hugetlb_page_mapping_lock_write(struct page *hpage);
+
 extern int sysctl_hugetlb_shm_group;
 extern struct list_head huge_boot_pages;
 
@@ -151,6 +153,12 @@ static inline unsigned long hugetlb_tota
 	return 0;
 }
 
+static inline struct address_space *hugetlb_page_mapping_lock_write(
+							struct page *hpage)
+{
+	return NULL;
+}
+
 static inline int huge_pmd_unshare(struct mm_struct *mm, unsigned long *addr,
 					pte_t *ptep)
 {
--- a/mm/hugetlb.c~hugetlbfs-use-i_mmap_rwsem-for-more-pmd-sharing-synchronization
+++ a/mm/hugetlb.c
@@ -1322,6 +1322,106 @@ int PageHeadHuge(struct page *page_head)
 	return get_compound_page_dtor(page_head) == free_huge_page;
 }
 
+/*
+ * Find address_space associated with hugetlbfs page.
+ * Upon entry page is locked and page 'was' mapped although mapped state
+ * could change.  If necessary, use anon_vma to find vma and associated
+ * address space.  The returned mapping may be stale, but it can not be
+ * invalid as page lock (which is held) is required to destroy mapping.
+ */
+static struct address_space *_get_hugetlb_page_mapping(struct page *hpage)
+{
+	struct anon_vma *anon_vma;
+	pgoff_t pgoff_start, pgoff_end;
+	struct anon_vma_chain *avc;
+	struct address_space *mapping = page_mapping(hpage);
+
+	/* Simple file based mapping */
+	if (mapping)
+		return mapping;
+
+	/*
+	 * Even anonymous hugetlbfs mappings are associated with an
+	 * underlying hugetlbfs file (see hugetlb_file_setup in mmap
+	 * code).  Find a vma associated with the anonymous vma, and
+	 * use the file pointer to get address_space.
+	 */
+	anon_vma = page_lock_anon_vma_read(hpage);
+	if (!anon_vma)
+		return mapping;  /* NULL */
+
+	/* Use first found vma */
+	pgoff_start = page_to_pgoff(hpage);
+	pgoff_end = pgoff_start + hpage_nr_pages(hpage) - 1;
+	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root,
+					pgoff_start, pgoff_end) {
+		struct vm_area_struct *vma = avc->vma;
+
+		mapping = vma->vm_file->f_mapping;
+		break;
+	}
+
+	anon_vma_unlock_read(anon_vma);
+	return mapping;
+}
+
+/*
+ * Find and lock address space (mapping) in write mode.
+ *
+ * Upon entry, the page is locked which allows us to find the mapping
+ * even in the case of an anon page.  However, locking order dictates
+ * the i_mmap_rwsem be acquired BEFORE the page lock.  This is hugetlbfs
+ * specific.  So, we first try to lock the sema while still holding the
+ * page lock.  If this works, great!  If not, then we need to drop the
+ * page lock and then acquire i_mmap_rwsem and reacquire page lock.  Of
+ * course, need to revalidate state along the way.
+ */
+struct address_space *hugetlb_page_mapping_lock_write(struct page *hpage)
+{
+	struct address_space *mapping, *mapping2;
+
+	mapping = _get_hugetlb_page_mapping(hpage);
+retry:
+	if (!mapping)
+		return mapping;
+
+	/*
+	 * If no contention, take lock and return
+	 */
+	if (i_mmap_trylock_write(mapping))
+		return mapping;
+
+	/*
+	 * Must drop page lock and wait on mapping sema.
+	 * Note:  Once page lock is dropped, mapping could become invalid.
+	 * As a hack, increase map count until we lock page again.
+	 */
+	atomic_inc(&hpage->_mapcount);
+	unlock_page(hpage);
+	i_mmap_lock_write(mapping);
+	lock_page(hpage);
+	atomic_add_negative(-1, &hpage->_mapcount);
+
+	/* verify page is still mapped */
+	if (!page_mapped(hpage)) {
+		i_mmap_unlock_write(mapping);
+		return NULL;
+	}
+
+	/*
+	 * Get address space again and verify it is the same one
+	 * we locked.  If not, drop lock and retry.
+	 */
+	mapping2 = _get_hugetlb_page_mapping(hpage);
+	if (mapping2 != mapping) {
+		i_mmap_unlock_write(mapping);
+		mapping = mapping2;
+		goto retry;
+	}
+
+	return mapping;
+}
+
 pgoff_t __basepage_index(struct page *page)
 {
 	struct page *page_head = compound_head(page);
@@ -3312,6 +3412,7 @@ int copy_hugetlb_page_range(struct mm_st
 	int cow;
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
+	struct address_space *mapping = vma->vm_file->f_mapping;
 	struct mmu_notifier_range range;
 	int ret = 0;
 
@@ -3322,6 +3423,14 @@ int copy_hugetlb_page_range(struct mm_st
 					vma->vm_start,
 					vma->vm_end);
 		mmu_notifier_invalidate_range_start(&range);
+	} else {
+		/*
+		 * For shared mappings i_mmap_rwsem must be held to call
+		 * huge_pte_alloc, otherwise the returned ptep could go
+		 * away if part of a shared pmd and another thread calls
+		 * huge_pmd_unshare.
+		 */
+		i_mmap_lock_read(mapping);
 	}
 
 	for (addr = vma->vm_start; addr < vma->vm_end; addr += sz) {
@@ -3399,6 +3508,8 @@ int copy_hugetlb_page_range(struct mm_st
 
 	if (cow)
 		mmu_notifier_invalidate_range_end(&range);
+	else
+		i_mmap_unlock_read(mapping);
 
 	return ret;
 }
@@ -3847,13 +3958,15 @@ retry:
 			};
 
 			/*
-			 * hugetlb_fault_mutex must be dropped before
-			 * handling userfault.  Reacquire after handling
-			 * fault to make calling code simpler.
+			 * hugetlb_fault_mutex and i_mmap_rwsem must be
+			 * dropped before handling userfault.  Reacquire
+			 * after handling fault to make calling code simpler.
 			 */
 			hash = hugetlb_fault_mutex_hash(mapping, idx);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+			i_mmap_unlock_read(mapping);
 			ret = handle_userfault(&vmf, VM_UFFD_MISSING);
+			i_mmap_lock_read(mapping);
 			mutex_lock(&hugetlb_fault_mutex_table[hash]);
 			goto out;
 		}
@@ -4018,6 +4131,11 @@ vm_fault_t hugetlb_fault(struct mm_struc
 
 	ptep = huge_pte_offset(mm, haddr, huge_page_size(h));
 	if (ptep) {
+		/*
+		 * Since we hold no locks, ptep could be stale.  That is
+		 * OK as we are only making decisions based on content and
+		 * not actually modifying content here.
+		 */
 		entry = huge_ptep_get(ptep);
 		if (unlikely(is_hugetlb_entry_migration(entry))) {
 			migration_entry_wait_huge(vma, mm, ptep);
@@ -4031,14 +4149,29 @@ vm_fault_t hugetlb_fault(struct mm_struc
 			return VM_FAULT_OOM;
 	}
 
+	/*
+	 * Acquire i_mmap_rwsem before calling huge_pte_alloc and hold
+	 * until finished with ptep.  This prevents huge_pmd_unshare from
+	 * being called elsewhere and making the ptep no longer valid.
+	 *
+	 * ptep could have already be assigned via huge_pte_offset.  That
+	 * is OK, as huge_pte_alloc will return the same value unless
+	 * something has changed.
+	 */
 	mapping = vma->vm_file->f_mapping;
-	idx = vma_hugecache_offset(h, vma, haddr);
+	i_mmap_lock_read(mapping);
+	ptep = huge_pte_alloc(mm, haddr, huge_page_size(h));
+	if (!ptep) {
+		i_mmap_unlock_read(mapping);
+		return VM_FAULT_OOM;
+	}
 
 	/*
 	 * Serialize hugepage allocation and instantiation, so that we don't
 	 * get spurious allocation failures if two CPUs race to instantiate
 	 * the same page in the page cache.
 	 */
+	idx = vma_hugecache_offset(h, vma, haddr);
 	hash = hugetlb_fault_mutex_hash(mapping, idx);
 	mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
@@ -4126,6 +4259,7 @@ out_ptl:
 	}
 out_mutex:
 	mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+	i_mmap_unlock_read(mapping);
 	/*
 	 * Generally it's safe to hold refcount during waiting page lock. But
 	 * here we just wait to defer the next page fault to avoid busy loop and
@@ -4776,10 +4910,12 @@ void adjust_range_if_pmd_sharing_possibl
  * Search for a shareable pmd page for hugetlb. In any case calls pmd_alloc()
  * and returns the corresponding pte. While this is not necessary for the
  * !shared pmd case because we can allocate the pmd later as well, it makes the
- * code much cleaner. pmd allocation is essential for the shared case because
- * pud has to be populated inside the same i_mmap_rwsem section - otherwise
- * racing tasks could either miss the sharing (see huge_pte_offset) or select a
- * bad pmd for sharing.
+ * code much cleaner.
+ *
+ * This routine must be called with i_mmap_rwsem held in at least read mode.
+ * For hugetlbfs, this prevents removal of any page table entries associated
+ * with the address space.  This is important as we are setting up sharing
+ * based on existing page table entries (mappings).
  */
 pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud)
 {
@@ -4796,7 +4932,6 @@ pte_t *huge_pmd_share(struct mm_struct *
 	if (!vma_shareable(vma, addr))
 		return (pte_t *)pmd_alloc(mm, pud, addr);
 
-	i_mmap_lock_read(mapping);
 	vma_interval_tree_foreach(svma, &mapping->i_mmap, idx, idx) {
 		if (svma == vma)
 			continue;
@@ -4826,7 +4961,6 @@ pte_t *huge_pmd_share(struct mm_struct *
 	spin_unlock(ptl);
 out:
 	pte = (pte_t *)pmd_alloc(mm, pud, addr);
-	i_mmap_unlock_read(mapping);
 	return pte;
 }
 
@@ -4837,7 +4971,7 @@ out:
  * indicated by page_count > 1, unmap is achieved by clearing pud and
  * decrementing the ref count. If count == 1, the pte page is not shared.
  *
- * called with page table lock held.
+ * Called with page table lock held and i_mmap_rwsem held in write mode.
  *
  * returns: 1 successfully unmapped a shared pte page
  *	    0 the underlying pte page is not shared, or it is the last user
--- a/mm/memory-failure.c~hugetlbfs-use-i_mmap_rwsem-for-more-pmd-sharing-synchronization
+++ a/mm/memory-failure.c
@@ -954,7 +954,7 @@ static bool hwpoison_user_mappings(struc
 	enum ttu_flags ttu = TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS;
 	struct address_space *mapping;
 	LIST_HEAD(tokill);
-	bool unmap_success;
+	bool unmap_success = true;
 	int kill = 1, forcekill;
 	struct page *hpage = *hpagep;
 	bool mlocked = PageMlocked(hpage);
@@ -1016,7 +1016,32 @@ static bool hwpoison_user_mappings(struc
 	if (kill)
 		collect_procs(hpage, &tokill, flags & MF_ACTION_REQUIRED);
 
-	unmap_success = try_to_unmap(hpage, ttu);
+	if (!PageHuge(hpage)) {
+		unmap_success = try_to_unmap(hpage, ttu);
+	} else {
+		/*
+		 * For hugetlb pages, try_to_unmap could potentially call
+		 * huge_pmd_unshare.  Because of this, take semaphore in
+		 * write mode here and set TTU_RMAP_LOCKED to indicate we
+		 * have taken the lock at this higer level.
+		 *
+		 * Note that the call to hugetlb_page_mapping_lock_write
+		 * is necessary even if mapping is already set.  It handles
+		 * ugliness of potentially having to drop page lock to obtain
+		 * i_mmap_rwsem.
+		 */
+		mapping = hugetlb_page_mapping_lock_write(hpage);
+
+		if (mapping) {
+			unmap_success = try_to_unmap(hpage,
+						     ttu|TTU_RMAP_LOCKED);
+			i_mmap_unlock_write(mapping);
+		} else {
+			pr_info("Memory failure: %#lx: could not find mapping for mapped huge page\n",
+				pfn);
+			unmap_success = false;
+		}
+	}
 	if (!unmap_success)
 		pr_err("Memory failure: %#lx: failed to unmap page (mapcount=%d)\n",
 		       pfn, page_mapcount(hpage));
--- a/mm/migrate.c~hugetlbfs-use-i_mmap_rwsem-for-more-pmd-sharing-synchronization
+++ a/mm/migrate.c
@@ -1282,6 +1282,7 @@ static int unmap_and_move_huge_page(new_
 	int page_was_mapped = 0;
 	struct page *new_hpage;
 	struct anon_vma *anon_vma = NULL;
+	struct address_space *mapping = NULL;
 
 	/*
 	 * Migratability of hugepages depends on architectures and their size.
@@ -1329,18 +1330,36 @@ static int unmap_and_move_huge_page(new_
 		goto put_anon;
 
 	if (page_mapped(hpage)) {
+		/*
+		 * try_to_unmap could potentially call huge_pmd_unshare.
+		 * Because of this, take semaphore in write mode here and
+		 * set TTU_RMAP_LOCKED to let lower levels know we have
+		 * taken the lock.
+		 */
+		mapping = hugetlb_page_mapping_lock_write(hpage);
+		if (unlikely(!mapping))
+			goto unlock_put_anon;
+
 		try_to_unmap(hpage,
-			TTU_MIGRATION|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS);
+			TTU_MIGRATION|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS|
+			TTU_RMAP_LOCKED);
 		page_was_mapped = 1;
+		/*
+		 * Leave mapping locked until after subsequent call to
+		 * remove_migration_ptes()
+		 */
 	}
 
 	if (!page_mapped(hpage))
 		rc = move_to_new_page(new_hpage, hpage, mode);
 
-	if (page_was_mapped)
+	if (page_was_mapped) {
 		remove_migration_ptes(hpage,
-			rc == MIGRATEPAGE_SUCCESS ? new_hpage : hpage, false);
+			rc == MIGRATEPAGE_SUCCESS ? new_hpage : hpage, true);
+		i_mmap_unlock_write(mapping);
+	}
 
+unlock_put_anon:
 	unlock_page(new_hpage);
 
 put_anon:
--- a/mm/rmap.c~hugetlbfs-use-i_mmap_rwsem-for-more-pmd-sharing-synchronization
+++ a/mm/rmap.c
@@ -22,9 +22,10 @@
  *
  * inode->i_mutex	(while writing or truncating, not reading or faulting)
  *   mm->mmap_sem
- *     page->flags PG_locked (lock_page)
+ *     page->flags PG_locked (lock_page)   * (see huegtlbfs below)
  *       hugetlbfs_i_mmap_rwsem_key (in huge_pmd_share)
  *         mapping->i_mmap_rwsem
+ *           hugetlb_fault_mutex (hugetlbfs specific page fault mutex)
  *           anon_vma->rwsem
  *             mm->page_table_lock or pte_lock
  *               pgdat->lru_lock (in mark_page_accessed, isolate_lru_page)
@@ -43,6 +44,11 @@
  * anon_vma->rwsem,mapping->i_mutex      (memory_failure, collect_procs_anon)
  *   ->tasklist_lock
  *     pte map lock
+ *
+ * * hugetlbfs PageHuge() pages take locks in this order:
+ *         mapping->i_mmap_rwsem
+ *           hugetlb_fault_mutex (hugetlbfs specific page fault mutex)
+ *             page->flags PG_locked (lock_page)
  */
 
 #include <linux/mm.h>
@@ -1409,6 +1415,9 @@ static bool try_to_unmap_one(struct page
 		/*
 		 * If sharing is possible, start and end will be adjusted
 		 * accordingly.
+		 *
+		 * If called for a huge page, caller must hold i_mmap_rwsem
+		 * in write mode as it is possible to call huge_pmd_unshare.
 		 */
 		adjust_range_if_pmd_sharing_possible(vma, &range.start,
 						     &range.end);
@@ -1456,6 +1465,12 @@ static bool try_to_unmap_one(struct page
 		address = pvmw.address;
 
 		if (PageHuge(page)) {
+			/*
+			 * To call huge_pmd_unshare, i_mmap_rwsem must be
+			 * held in write mode.  Caller needs to explicitly
+			 * do this outside rmap routines.
+			 */
+			VM_BUG_ON(!(flags & TTU_RMAP_LOCKED));
 			if (huge_pmd_unshare(mm, &address, pvmw.pte)) {
 				/*
 				 * huge_pmd_unshare unmapped an entire PMD
--- a/mm/userfaultfd.c~hugetlbfs-use-i_mmap_rwsem-for-more-pmd-sharing-synchronization
+++ a/mm/userfaultfd.c
@@ -276,10 +276,14 @@ retry:
 		BUG_ON(dst_addr >= dst_start + len);
 
 		/*
-		 * Serialize via hugetlb_fault_mutex
+		 * Serialize via i_mmap_rwsem and hugetlb_fault_mutex.
+		 * i_mmap_rwsem ensures the dst_pte remains valid even
+		 * in the case of shared pmds.  fault mutex prevents
+		 * races with other faulting threads.
 		 */
-		idx = linear_page_index(dst_vma, dst_addr);
 		mapping = dst_vma->vm_file->f_mapping;
+		i_mmap_lock_read(mapping);
+		idx = linear_page_index(dst_vma, dst_addr);
 		hash = hugetlb_fault_mutex_hash(mapping, idx);
 		mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
@@ -287,6 +291,7 @@ retry:
 		dst_pte = huge_pte_alloc(dst_mm, dst_addr, vma_hpagesize);
 		if (!dst_pte) {
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+			i_mmap_unlock_read(mapping);
 			goto out_unlock;
 		}
 
@@ -294,6 +299,7 @@ retry:
 		dst_pteval = huge_ptep_get(dst_pte);
 		if (!huge_pte_none(dst_pteval)) {
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+			i_mmap_unlock_read(mapping);
 			goto out_unlock;
 		}
 
@@ -301,6 +307,7 @@ retry:
 						dst_addr, src_addr, &page);
 
 		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+		i_mmap_unlock_read(mapping);
 		vm_alloc_shared = vm_shared;
 
 		cond_resched();
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are
