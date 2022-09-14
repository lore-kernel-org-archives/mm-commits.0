Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53A31C6FA86
	for <mm-commits@archiver.kernel.org>; Wed, 14 Sep 2022 23:01:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiINXBI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Sep 2022 19:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiINXBI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Sep 2022 19:01:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E42DBA4
        for <mm-commits@vger.kernel.org>; Wed, 14 Sep 2022 16:01:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B10961F79
        for <mm-commits@vger.kernel.org>; Wed, 14 Sep 2022 23:01:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817C2C433C1;
        Wed, 14 Sep 2022 23:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663196465;
        bh=hj6i2W/EMJHoDNciY2/BshIYNO7LVCg3HVbiEXhQFWw=;
        h=Date:To:From:Subject:From;
        b=YVPle5IZdcZnh9BnR6lE+39SztT8oygAl//8Ovkd9yje/snOtOvTx1eeY0L29vqFx
         O3Ie1Uek7K9Qb9NoJDzVjURP+Wq0/72bCspu2yx5YAySIuNTeVxZ2f4+S6PMDf+zFk
         icH2/V2+jRPoVKABdPQL5NeYmj3Gtgc8UuDL2re8=
Date:   Wed, 14 Sep 2022 16:01:02 -0700
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
Subject: + hugetlb-create-remove_inode_single_folio-to-remove-single-file-folio.patch added to mm-unstable branch
Message-Id: <20220914230105.817C2C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: create remove_inode_single_folio to remove single file folio
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-create-remove_inode_single_folio-to-remove-single-file-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-create-remove_inode_single_folio-to-remove-single-file-folio.patch

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
Subject: hugetlb: create remove_inode_single_folio to remove single file folio
Date: Wed, 14 Sep 2022 15:18:05 -0700

Create the new routine remove_inode_single_folio that will remove a single
folio from a file.  This is refactored code from remove_inode_hugepages. 
It checks for the uncommon case in which the folio is still mapped and
unmaps.

No functional change.  This refactoring will be put to use and expanded
upon in a subsequent patches.

Link: https://lkml.kernel.org/r/20220914221810.95771-5-mike.kravetz@oracle.com
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

 fs/hugetlbfs/inode.c |  103 ++++++++++++++++++++++++-----------------
 1 file changed, 62 insertions(+), 41 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlb-create-remove_inode_single_folio-to-remove-single-file-folio
+++ a/fs/hugetlbfs/inode.c
@@ -412,17 +412,70 @@ hugetlb_vmdelete_list(struct rb_root_cac
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
+			index * pages_per_huge_page(h),
+			(index + 1) * pages_per_huge_page(h),
+			ZAP_FLAG_DROP_MARKER);
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
+ *	and again after obtaining page table lock.  It will 'back out'
+ *	allocations in the truncated range.
  * hole punch is indicated if end is not LLONG_MAX
  *	In the hole punch case we scan the range and release found pages.
  *	Only when releasing a page is the associated region/reserve map
@@ -456,44 +509,12 @@ static void remove_inode_hugepages(struc
 			mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 			/*
-			 * If folio is mapped, it was faulted in after being
-			 * unmapped in caller.  Unmap (again) now after taking
-			 * the fault mutex.  The mutex will prevent faults
-			 * until we finish removing the folio.
-			 *
-			 * This race can only happen in the hole punch case.
-			 * Getting here in a truncate operation is a bug.
-			 */
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
-
-			folio_lock(folio);
-			/*
-			 * We must free the huge page and remove from page
-			 * cache BEFORE removing the region/reserve map
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
+			if (remove_inode_single_folio(h, inode, mapping, folio,
+							index, truncate_op))
+				freed++;
 
-			folio_unlock(folio);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 		}
 		folio_batch_release(&fbatch);
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

