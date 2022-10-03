Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CD7BC43217
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiJCVOa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiJCVMs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:12:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA29EA1A0
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DE08B811BF
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38646C433D6;
        Mon,  3 Oct 2022 21:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831275;
        bh=zh6jwiOxCf2/EpTW0nw/9FW4otbn1rjIwhbAWfhoeSc=;
        h=Date:To:From:Subject:From;
        b=0Ep+hHwnOLII3Pt0jnm+9yeraTM2obJ/GE6nk4oN6q6Lxzx6b5WtOEF/i1oeVKpHG
         IMgDh+FAC+JZt3o7uRK1DMu3lF2bIygde2cgtfRnTSy/bp0Eog/6FWUgIcsKzUK08s
         kZXKcb1QHK1lJAZZbQSx5rHmfsDjEuHsHDHHGI5U=
Date:   Mon, 03 Oct 2022 14:07:54 -0700
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
Subject: [merged mm-stable] hugetlb-create-remove_inode_single_folio-to-remove-single-file-folio.patch removed from -mm tree
Message-Id: <20221003210755.38646C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: create remove_inode_single_folio to remove single file folio
has been removed from the -mm tree.  Its filename was
     hugetlb-create-remove_inode_single_folio-to-remove-single-file-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: James Houghton <jthoughton@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
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

hugetlb-simplify-hugetlb-handling-in-follow_page_mask.patch

