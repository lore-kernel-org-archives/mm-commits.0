Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A683EC04AA5
	for <mm-commits@archiver.kernel.org>; Wed, 24 Aug 2022 20:14:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239909AbiHXUOK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Aug 2022 16:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240057AbiHXUOB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Aug 2022 16:14:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7534C7C300
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 13:13:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2D30B826A2
        for <mm-commits@vger.kernel.org>; Wed, 24 Aug 2022 20:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895A5C433D6;
        Wed, 24 Aug 2022 20:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661372036;
        bh=3PQJfzC9w8UK342+fyA15ZFMNAyEfd94aGE8zDXxT7Q=;
        h=Date:To:From:Subject:From;
        b=TKJhH1CH8Vejzb3v6hVTsrqRDmYBwNEeoKkBYuTaaxhfZZwWqC7of0gttELI2oTJA
         oTGbocNNvdQxVnBDilBhhqrRiorDHhhxdRZSSgeEkNFT5Yjwlj3CUhRffcXpoWoYHi
         ziNnxiuOruQdNh77Kcoax8MFAiHvaJOQYEBytJ04=
Date:   Wed, 24 Aug 2022 13:13:55 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        prakash.sangappa@oracle.com, peterx@redhat.com,
        pasha.tatashin@soleen.com, naoya.horiguchi@linux.dev,
        mhocko@suse.com, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, jthoughton@google.com,
        david@redhat.com, dave@stgolabs.net, axelrasmussen@google.com,
        aneesh.kumar@linux.vnet.ibm.com, almasrymina@google.com,
        aarcange@redhat.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-handle-truncate-racing-with-page-faults.patch added to mm-unstable branch
Message-Id: <20220824201356.895A5C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: handle truncate racing with page faults
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-handle-truncate-racing-with-page-faults.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-handle-truncate-racing-with-page-faults.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: handle truncate racing with page faults
Date: Wed, 24 Aug 2022 10:57:53 -0700

When page fault code needs to allocate and instantiate a new hugetlb page
(huegtlb_no_page), it checks early to determine if the fault is beyond
i_size.  When discovered early, it is easy to abort the fault and return
an error.  However, it becomes much more difficult to handle when
discovered later after allocating the page and consuming reservations and
adding to the page cache.  Backing out changes in such instances becomes
difficult and error prone.

Instead of trying to catch and backout all such races, use the hugetlb
fault mutex to handle truncate racing with page faults.  The most
significant change is modification of the routine remove_inode_hugepages
such that it will take the fault mutex for EVERY index in the truncated
range (or hole in the case of hole punch).  Since remove_inode_hugepages
is called in the truncate path after updating i_size, we can experience
races as follows:

- truncate code updates i_size and takes fault mutex before a racing
  fault.  After fault code takes mutex, it will notice fault beyond
  i_size and abort early.
- fault code obtains mutex, and truncate updates i_size after early
  checks in fault code.  fault code will add page beyond i_size.
  When truncate code takes mutex for page/index, it will remove the
  page.
- truncate updates i_size, but fault code obtains mutex first.  If
  fault code sees updated i_size it will abort early.  If fault code
  does not see updated i_size, it will add page beyond i_size and
  truncate code will remove page when it obtains fault mutex.

Note, for performance reasons remove_inode_hugepages will still use
filemap_get_folios for bulk folio lookups.  For indicies not returned in
the bulk lookup, it will need to lookup individual folios to check for
races with page fault.

Link: https://lkml.kernel.org/r/20220824175757.20590-5-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: James Houghton <jthoughton@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Prakash Sangappa <prakash.sangappa@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |  184 +++++++++++++++++++++++++++++------------
 mm/hugetlb.c         |   41 ++++-----
 2 files changed, 152 insertions(+), 73 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlb-handle-truncate-racing-with-page-faults
+++ a/fs/hugetlbfs/inode.c
@@ -412,17 +412,105 @@ hugetlb_vmdelete_list(struct rb_root_cac
 }
 
 /*
+ * Called with hugetlb fault mutex held.
+ * Returns true if page was actually removed, false otherwise.
+ */
+static bool remove_inode_single_folio(struct hstate *h, struct inode *inode,
+					struct address_space *mapping,
+					struct folio *folio, pgoff_t index,
+					bool truncate_op)
+{
+	bool ret = false;
+
+	/*
+	 * If folio is mapped, it was faulted in after being
+	 * unmapped in caller.  Unmap (again) while holding
+	 * the fault mutex.  The mutex will prevent faults
+	 * until we finish removing the folio.
+	 */
+	if (unlikely(folio_mapped(folio))) {
+		i_mmap_lock_write(mapping);
+		hugetlb_vmdelete_list(&mapping->i_mmap,
+					index * pages_per_huge_page(h),
+					(index + 1) * pages_per_huge_page(h),
+					ZAP_FLAG_DROP_MARKER);
+		i_mmap_unlock_write(mapping);
+	}
+
+	folio_lock(folio);
+	/*
+	 * After locking page, make sure mapping is the same.
+	 * We could have raced with page fault populate and
+	 * backout code.
+	 */
+	if (folio_mapping(folio) == mapping) {
+		/*
+		 * We must remove the folio from page cache before removing
+		 * the region/ reserve map (hugetlb_unreserve_pages).  In
+		 * rare out of memory conditions, removal of the region/reserve
+		 * map could fail.  Correspondingly, the subpool and global
+		 * reserve usage count can need to be adjusted.
+		 */
+		VM_BUG_ON(HPageRestoreReserve(&folio->page));
+		hugetlb_delete_from_page_cache(&folio->page);
+		ret = true;
+		if (!truncate_op) {
+			if (unlikely(hugetlb_unreserve_pages(inode, index,
+								index + 1, 1)))
+				hugetlb_fix_reserve_counts(inode);
+		}
+	}
+
+	folio_unlock(folio);
+	return ret;
+}
+
+/*
+ * Take hugetlb fault mutex for a set of inode indicies.
+ * Check for and remove any found folios.  Return the number of
+ * any removed folios.
+ *
+ */
+static long fault_lock_inode_indicies(struct hstate *h,
+					struct inode *inode,
+					struct address_space *mapping,
+					pgoff_t start, pgoff_t end,
+					bool truncate_op)
+{
+	struct folio *folio;
+	long freed = 0;
+	pgoff_t index;
+	u32 hash;
+
+	for (index = start; index < end; index++) {
+		hash = hugetlb_fault_mutex_hash(mapping, index);
+		mutex_lock(&hugetlb_fault_mutex_table[hash]);
+
+		folio = filemap_get_folio(mapping, index);
+		if (folio) {
+			if (remove_inode_single_folio(h, inode, mapping, folio,
+							index, truncate_op))
+				freed++;
+			folio_put(folio);
+		}
+
+		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+	}
+
+	return freed;
+}
+
+/*
  * remove_inode_hugepages handles two distinct cases: truncation and hole
  * punch.  There are subtle differences in operation for each case.
  *
  * truncation is indicated by end of range being LLONG_MAX
  *	In this case, we first scan the range and release found pages.
  *	After releasing pages, hugetlb_unreserve_pages cleans up region/reserve
- *	maps and global counts.  Page faults can not race with truncation
- *	in this routine.  hugetlb_no_page() prevents page faults in the
- *	truncated range.  It checks i_size before allocation, and again after
- *	with the page table lock for the page held.  The same lock must be
- *	acquired to unmap a page.
+ *	maps and global counts.  Page faults can race with truncation.
+ *	During faults, hugetlb_no_page() checks i_size before page allocation,
+ *	and again after	obtaining page table lock.  It will 'back out'
+ *	allocations in the truncated range.
  * hole punch is indicated if end is not LLONG_MAX
  *	In the hole punch case we scan the range and release found pages.
  *	Only when releasing a page is the associated region/reserve map
@@ -431,75 +519,69 @@ hugetlb_vmdelete_list(struct rb_root_cac
  *	This is indicated if we find a mapped page.
  * Note: If the passed end of range value is beyond the end of file, but
  * not LLONG_MAX this routine still performs a hole punch operation.
+ *
+ * Since page faults can race with this routine, care must be taken as both
+ * modify huge page reservation data.  To somewhat synchronize these operations
+ * the hugetlb fault mutex is taken for EVERY index in the range to be hole
+ * punched or truncated.  In this way, we KNOW either:
+ * - fault code has added a page beyond i_size, and we will remove here
+ * - fault code will see updated i_size and not add a page beyond
+ * The parameter 'lm__end' indicates the offset of the end of hole or file
+ * before truncation.  For hole punch lm_end == lend.
  */
 static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
-				   loff_t lend)
+				   loff_t lend, loff_t lm_end)
 {
 	struct hstate *h = hstate_inode(inode);
 	struct address_space *mapping = &inode->i_data;
 	const pgoff_t start = lstart >> huge_page_shift(h);
 	const pgoff_t end = lend >> huge_page_shift(h);
+	pgoff_t m_end = lm_end >> huge_page_shift(h);
+	pgoff_t m_start, m_index;
 	struct folio_batch fbatch;
+	struct folio *folio;
 	pgoff_t next, index;
-	int i, freed = 0;
+	unsigned int i;
+	long freed = 0;
+	u32 hash;
 	bool truncate_op = (lend == LLONG_MAX);
 
 	folio_batch_init(&fbatch);
-	next = start;
+	next = m_start = start;
 	while (filemap_get_folios(mapping, &next, end - 1, &fbatch)) {
 		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
-			struct folio *folio = fbatch.folios[i];
-			u32 hash = 0;
+			folio = fbatch.folios[i];
 
 			index = folio->index;
-			hash = hugetlb_fault_mutex_hash(mapping, index);
-			mutex_lock(&hugetlb_fault_mutex_table[hash]);
-
 			/*
-			 * If folio is mapped, it was faulted in after being
-			 * unmapped in caller.  Unmap (again) now after taking
-			 * the fault mutex.  The mutex will prevent faults
-			 * until we finish removing the folio.
-			 *
-			 * This race can only happen in the hole punch case.
-			 * Getting here in a truncate operation is a bug.
+			 * Take fault mutex for missing folios before index,
+			 * while checking folios that might have been added
+			 * due to a race with fault code.
 			 */
-			if (unlikely(folio_mapped(folio))) {
-				BUG_ON(truncate_op);
-
-				i_mmap_lock_write(mapping);
-				hugetlb_vmdelete_list(&mapping->i_mmap,
-					index * pages_per_huge_page(h),
-					(index + 1) * pages_per_huge_page(h),
-					ZAP_FLAG_DROP_MARKER);
-				i_mmap_unlock_write(mapping);
-			}
+			freed += fault_lock_inode_indicies(h, inode, mapping,
+						m_start, m_index, truncate_op);
 
-			folio_lock(folio);
 			/*
-			 * We must free the huge page and remove from page
-			 * cache BEFORE removing the * region/reserve map
-			 * (hugetlb_unreserve_pages).  In rare out of memory
-			 * conditions, removal of the region/reserve map could
-			 * fail. Correspondingly, the subpool and global
-			 * reserve usage count can need to be adjusted.
+			 * Remove folio that was part of folio_batch.
 			 */
-			VM_BUG_ON(HPageRestoreReserve(&folio->page));
-			hugetlb_delete_from_page_cache(&folio->page);
-			freed++;
-			if (!truncate_op) {
-				if (unlikely(hugetlb_unreserve_pages(inode,
-							index, index + 1, 1)))
-					hugetlb_fix_reserve_counts(inode);
-			}
-
-			folio_unlock(folio);
+			hash = hugetlb_fault_mutex_hash(mapping, index);
+			mutex_lock(&hugetlb_fault_mutex_table[hash]);
+			if (remove_inode_single_folio(h, inode, mapping, folio,
+							index, truncate_op))
+				freed++;
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 		}
 		folio_batch_release(&fbatch);
 		cond_resched();
 	}
 
+	/*
+	 * Take fault mutex for missing folios at end of range while checking
+	 * for folios that might have been added due to a race with fault code.
+	 */
+	freed += fault_lock_inode_indicies(h, inode, mapping, m_start, m_end,
+						truncate_op);
+
 	if (truncate_op)
 		(void)hugetlb_unreserve_pages(inode, start, LONG_MAX, freed);
 }
@@ -507,8 +589,9 @@ static void remove_inode_hugepages(struc
 static void hugetlbfs_evict_inode(struct inode *inode)
 {
 	struct resv_map *resv_map;
+	loff_t prev_size = i_size_read(inode);
 
-	remove_inode_hugepages(inode, 0, LLONG_MAX);
+	remove_inode_hugepages(inode, 0, LLONG_MAX, prev_size);
 
 	/*
 	 * Get the resv_map from the address space embedded in the inode.
@@ -528,6 +611,7 @@ static void hugetlb_vmtruncate(struct in
 	pgoff_t pgoff;
 	struct address_space *mapping = inode->i_mapping;
 	struct hstate *h = hstate_inode(inode);
+	loff_t prev_size = i_size_read(inode);
 
 	BUG_ON(offset & ~huge_page_mask(h));
 	pgoff = offset >> PAGE_SHIFT;
@@ -538,7 +622,7 @@ static void hugetlb_vmtruncate(struct in
 		hugetlb_vmdelete_list(&mapping->i_mmap, pgoff, 0,
 				      ZAP_FLAG_DROP_MARKER);
 	i_mmap_unlock_write(mapping);
-	remove_inode_hugepages(inode, offset, LLONG_MAX);
+	remove_inode_hugepages(inode, offset, LLONG_MAX, prev_size);
 }
 
 static void hugetlbfs_zero_partial_page(struct hstate *h,
@@ -610,7 +694,7 @@ static long hugetlbfs_punch_hole(struct
 
 	/* Remove full pages from the file. */
 	if (hole_end > hole_start)
-		remove_inode_hugepages(inode, hole_start, hole_end);
+		remove_inode_hugepages(inode, hole_start, hole_end, hole_end);
 
 	inode_unlock(inode);
 
--- a/mm/hugetlb.c~hugetlb-handle-truncate-racing-with-page-faults
+++ a/mm/hugetlb.c
@@ -5511,6 +5511,7 @@ static vm_fault_t hugetlb_no_page(struct
 	spinlock_t *ptl;
 	unsigned long haddr = address & huge_page_mask(h);
 	bool new_page, new_pagecache_page = false;
+	bool reserve_alloc = false;
 
 	/*
 	 * Currently, we are forced to kill the process in the event the
@@ -5567,9 +5568,13 @@ static vm_fault_t hugetlb_no_page(struct
 		clear_huge_page(page, address, pages_per_huge_page(h));
 		__SetPageUptodate(page);
 		new_page = true;
+		if (HPageRestoreReserve(page))
+			reserve_alloc = true;
 
 		if (vma->vm_flags & VM_MAYSHARE) {
-			int err = hugetlb_add_to_page_cache(page, mapping, idx);
+			int err;
+
+			err = hugetlb_add_to_page_cache(page, mapping, idx);
 			if (err) {
 				/*
 				 * err can't be -EEXIST which implies someone
@@ -5630,10 +5635,6 @@ static vm_fault_t hugetlb_no_page(struct
 	}
 
 	ptl = huge_pte_lock(h, mm, ptep);
-	size = i_size_read(mapping->host) >> huge_page_shift(h);
-	if (idx >= size)
-		goto backout;
-
 	ret = 0;
 	/* If pte changed from under us, retry */
 	if (!pte_same(huge_ptep_get(ptep), old_pte))
@@ -5677,10 +5678,18 @@ out:
 backout:
 	spin_unlock(ptl);
 backout_unlocked:
-	unlock_page(page);
-	/* restore reserve for newly allocated pages not in page cache */
-	if (new_page && !new_pagecache_page)
+	if (new_page && !new_pagecache_page) {
+		/*
+		 * If reserve was consumed, make sure flag is set so that it
+		 * will be restored in free_huge_page().
+		 */
+		if (reserve_alloc)
+			SetHPageRestoreReserve(page);
+
 		restore_reserve_on_error(h, vma, haddr, page);
+	}
+
+	unlock_page(page);
 	put_page(page);
 	goto out;
 }
@@ -5998,25 +6007,11 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 	spin_lock(ptl);
 
 	/*
-	 * Recheck the i_size after holding PT lock to make sure not
-	 * to leave any page mapped (as page_mapped()) beyond the end
-	 * of the i_size (remove_inode_hugepages() is strict about
-	 * enforcing that). If we bail out here, we'll also leave a
-	 * page in the radix tree in the vm_shared case beyond the end
-	 * of the i_size, but remove_inode_hugepages() will take care
-	 * of it as soon as we drop the hugetlb_fault_mutex_table.
-	 */
-	size = i_size_read(mapping->host) >> huge_page_shift(h);
-	ret = -EFAULT;
-	if (idx >= size)
-		goto out_release_unlock;
-
-	ret = -EEXIST;
-	/*
 	 * We allow to overwrite a pte marker: consider when both MISSING|WP
 	 * registered, we firstly wr-protect a none pte which has no page cache
 	 * page backing it, then access the page.
 	 */
+	ret = -EEXIST;
 	if (!huge_pte_none_mostly(huge_ptep_get(dst_pte)))
 		goto out_release_unlock;
 
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlbfs-revert-use-i_mmap_rwsem-to-address-page-fault-truncate-race.patch
hugetlbfs-revert-use-i_mmap_rwsem-for-more-pmd-sharing-synchronization.patch
hugetlb-rename-remove_huge_page-to-hugetlb_delete_from_page_cache.patch
hugetlb-handle-truncate-racing-with-page-faults.patch
hugetlb-rename-vma_shareable-and-refactor-code.patch
hugetlb-add-vma-based-lock-for-pmd-sharing.patch
hugetlb-create-hugetlb_unmap_file_folio-to-unmap-single-file-folio.patch
hugetlb-use-new-vma_lock-for-pmd-sharing-synchronization.patch

