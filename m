Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92769C6FA82
	for <mm-commits@archiver.kernel.org>; Wed, 14 Sep 2022 23:01:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiINXBn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Sep 2022 19:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiINXBX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Sep 2022 19:01:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DCD52FD8
        for <mm-commits@vger.kernel.org>; Wed, 14 Sep 2022 16:01:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B206B81D02
        for <mm-commits@vger.kernel.org>; Wed, 14 Sep 2022 23:01:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98783C433D6;
        Wed, 14 Sep 2022 23:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663196479;
        bh=ObD6R6N9RBQ380CLUsUJo+odrDH9Z10vMJwVBkUU4ug=;
        h=Date:To:From:Subject:From;
        b=hM4HDG6qHw4hwVhCv3O/Ua51NtwDXuTIC417ebrYokVY3wPrsq+B3mJxBsei9i9R9
         IkTu+VfcRiO7dxB7WJnQdG7ceHAP7lMjO/aTZAoraHH7fa3Pb0LwyBu9cZb3fMIVnf
         PTm6iZIC9b96KwixSOZLIIdXtQnbBExxuC8rOxCU=
Date:   Wed, 14 Sep 2022 16:01:18 -0700
To:     mm-commits@vger.kernel.org, svens@linux.ibm.com,
        songmuchun@bytedance.com, prakash.sangappa@oracle.com,
        peterx@redhat.com, pasha.tatashin@soleen.com,
        naoya.horiguchi@linux.dev, mhocko@suse.com, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, jthoughton@google.com,
        david@redhat.com, dave@stgolabs.net, axelrasmussen@google.com,
        aneesh.kumar@linux.vnet.ibm.com, almasrymina@google.com,
        aarcange@redhat.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-clean-up-code-checking-for-fault-truncation-races.patch added to mm-unstable branch
Message-Id: <20220914230119.98783C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: clean up code checking for fault/truncation races
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-clean-up-code-checking-for-fault-truncation-races.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-clean-up-code-checking-for-fault-truncation-races.patch

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
Subject: hugetlb: clean up code checking for fault/truncation races
Date: Wed, 14 Sep 2022 15:18:10 -0700

With the new hugetlb vma lock in place, it can also be used to handle page
fault races with file truncation.  The lock is taken at the beginning of
the code fault path in read mode.  During truncation, it is taken in write
mode for each vma which has the file mapped.  The file's size (i_size) is
modified before taking the vma lock to unmap.

How are races handled?

The page fault code checks i_size early in processing after taking the vma
lock.  If the fault is beyond i_size, the fault is aborted.  If the fault
is not beyond i_size the fault will continue and a new page will be added
to the file.  It could be that truncation code modifies i_size after the
check in fault code.  That is OK, as truncation code will soon remove the
page.  The truncation code will wait until the fault is finished, as it
must obtain the vma lock in write mode.

This patch cleans up/removes late checks in the fault paths that try to
back out pages racing with truncation.  As noted above, we just let the
truncation code remove the pages.

Link: https://lkml.kernel.org/r/20220914221810.95771-10-mike.kravetz@oracle.com
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
Cc: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   31 ++++++++++++-------------------
 mm/hugetlb.c         |   27 ++++++---------------------
 2 files changed, 18 insertions(+), 40 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlb-clean-up-code-checking-for-fault-truncation-races
+++ a/fs/hugetlbfs/inode.c
@@ -568,26 +568,19 @@ static bool remove_inode_single_folio(st
 
 	folio_lock(folio);
 	/*
-	 * After locking page, make sure mapping is the same.
-	 * We could have raced with page fault populate and
-	 * backout code.
+	 * We must remove the folio from page cache before removing
+	 * the region/ reserve map (hugetlb_unreserve_pages).  In
+	 * rare out of memory conditions, removal of the region/reserve
+	 * map could fail.  Correspondingly, the subpool and global
+	 * reserve usage count can need to be adjusted.
 	 */
-	if (folio_mapping(folio) == mapping) {
-		/*
-		 * We must remove the folio from page cache before removing
-		 * the region/ reserve map (hugetlb_unreserve_pages).  In
-		 * rare out of memory conditions, removal of the region/reserve
-		 * map could fail.  Correspondingly, the subpool and global
-		 * reserve usage count can need to be adjusted.
-		 */
-		VM_BUG_ON(HPageRestoreReserve(&folio->page));
-		hugetlb_delete_from_page_cache(&folio->page);
-		ret = true;
-		if (!truncate_op) {
-			if (unlikely(hugetlb_unreserve_pages(inode, index,
-								index + 1, 1)))
-				hugetlb_fix_reserve_counts(inode);
-		}
+	VM_BUG_ON(HPageRestoreReserve(&folio->page));
+	hugetlb_delete_from_page_cache(&folio->page);
+	ret = true;
+	if (!truncate_op) {
+		if (unlikely(hugetlb_unreserve_pages(inode, index,
+							index + 1, 1)))
+			hugetlb_fix_reserve_counts(inode);
 	}
 
 	folio_unlock(folio);
--- a/mm/hugetlb.c~hugetlb-clean-up-code-checking-for-fault-truncation-races
+++ a/mm/hugetlb.c
@@ -5562,6 +5562,7 @@ static vm_fault_t hugetlb_no_page(struct
 	spinlock_t *ptl;
 	unsigned long haddr = address & huge_page_mask(h);
 	bool new_page, new_pagecache_page = false;
+	bool reserve_alloc = false;
 
 	/*
 	 * Currently, we are forced to kill the process in the event the
@@ -5617,6 +5618,8 @@ static vm_fault_t hugetlb_no_page(struct
 		clear_huge_page(page, address, pages_per_huge_page(h));
 		__SetPageUptodate(page);
 		new_page = true;
+		if (HPageRestoreReserve(page))
+			reserve_alloc = true;
 
 		if (vma->vm_flags & VM_MAYSHARE) {
 			int err = hugetlb_add_to_page_cache(page, mapping, idx);
@@ -5680,10 +5683,6 @@ static vm_fault_t hugetlb_no_page(struct
 	}
 
 	ptl = huge_pte_lock(h, mm, ptep);
-	size = i_size_read(mapping->host) >> huge_page_shift(h);
-	if (idx >= size)
-		goto backout;
-
 	ret = 0;
 	/* If pte changed from under us, retry */
 	if (!pte_same(huge_ptep_get(ptep), old_pte))
@@ -5727,10 +5726,10 @@ out:
 backout:
 	spin_unlock(ptl);
 backout_unlocked:
-	unlock_page(page);
-	/* restore reserve for newly allocated pages not in page cache */
 	if (new_page && !new_pagecache_page)
 		restore_reserve_on_error(h, vma, haddr, page);
+
+	unlock_page(page);
 	put_page(page);
 	goto out;
 }
@@ -6063,25 +6062,11 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 	ptl = huge_pte_lock(h, dst_mm, dst_pte);
 
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
hugetlb-create-remove_inode_single_folio-to-remove-single-file-folio.patch
hugetlb-rename-vma_shareable-and-refactor-code.patch
hugetlb-add-vma-based-lock-for-pmd-sharing.patch
hugetlb-create-hugetlb_unmap_file_folio-to-unmap-single-file-folio.patch
hugetlb-use-new-vma_lock-for-pmd-sharing-synchronization.patch
hugetlb-clean-up-code-checking-for-fault-truncation-races.patch

