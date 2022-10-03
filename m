Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C222C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:14:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiJCVOg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbiJCVNA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:13:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAEA952DDA
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:08:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C30D611F9
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EFBEC433D7;
        Mon,  3 Oct 2022 21:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831282;
        bh=0U/qhBx5fidBtNi4gMUch6dISgcbkb0pq61ETV2WgTc=;
        h=Date:To:From:Subject:From;
        b=QcdqAz0xmAmWT3ZTGRgl7Wb8hyDyAqGHejSY1JvQpfq3vnbsLqQLQ5ND5jrnfOGFT
         GyW3PnSc97HuRvmSedPBDI5ZncAk4MrXbTJCunEHQTpJR3aOjQP7Jo7FvHi1yxQ0Km
         43IgTMqdC+l7XuhZRRznzLP0pTW+W1rYR20Obigg=
Date:   Mon, 03 Oct 2022 14:08:01 -0700
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
Subject: [merged mm-stable] hugetlb-clean-up-code-checking-for-fault-truncation-races.patch removed from -mm tree
Message-Id: <20221003210802.8EFBEC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: clean up code checking for fault/truncation races
has been removed from the -mm tree.  Its filename was
     hugetlb-clean-up-code-checking-for-fault-truncation-races.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[mike.kravetz@oracle.com: fix reserve_alloc set but not used compiler warning]
  Link: https://lkml.kernel.org/r/Yyj7HsJWfHDoU24U@monkey
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
 mm/hugetlb.c         |   24 +++---------------------
 2 files changed, 15 insertions(+), 40 deletions(-)

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
@@ -5680,10 +5680,6 @@ static vm_fault_t hugetlb_no_page(struct
 	}
 
 	ptl = huge_pte_lock(h, mm, ptep);
-	size = i_size_read(mapping->host) >> huge_page_shift(h);
-	if (idx >= size)
-		goto backout;
-
 	ret = 0;
 	/* If pte changed from under us, retry */
 	if (!pte_same(huge_ptep_get(ptep), old_pte))
@@ -5727,10 +5723,10 @@ out:
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
@@ -6063,25 +6059,11 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
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

hugetlb-simplify-hugetlb-handling-in-follow_page_mask.patch

