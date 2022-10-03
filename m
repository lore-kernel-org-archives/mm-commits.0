Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 782F4C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:14:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiJCVOd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiJCVMr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:12:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B922252823
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 567E4611E3
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4FCC433B5;
        Mon,  3 Oct 2022 21:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831273;
        bh=iL3dRM2MkGYsnDLxOKdv+qX3GtSHakAVwfO5nrbz0NY=;
        h=Date:To:From:Subject:From;
        b=oSL2NzqJb3G2HYBMDOeRWS+whfxKLEZ5M+7GUnfJoJ1bpqSVlEXKdcXMB+vTkl7Qa
         YZSKXbSB8i8k+AGRGvrvnIRR5YrwNsOvCT7coTff0VQxHPHgn/kBdxFedS7FFmr0l+
         dsjG88/aHbsj3J1csEe9cA1/v/57r4zSNwrIfHrg=
Date:   Mon, 03 Oct 2022 14:07:53 -0700
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
Subject: [merged mm-stable] hugetlb-rename-remove_huge_page-to-hugetlb_delete_from_page_cache.patch removed from -mm tree
Message-Id: <20221003210753.AB4FCC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: rename remove_huge_page to hugetlb_delete_from_page_cache
has been removed from the -mm tree.  Its filename was
     hugetlb-rename-remove_huge_page-to-hugetlb_delete_from_page_cache.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: rename remove_huge_page to hugetlb_delete_from_page_cache
Date: Wed, 14 Sep 2022 15:18:04 -0700

remove_huge_page removes a hugetlb page from the page cache.  Change to
hugetlb_delete_from_page_cache as it is a more descriptive name. 
huge_add_to_page_cache is global in scope, but only deals with hugetlb
pages.  For consistency and clarity, rename to hugetlb_add_to_page_cache.

Link: https://lkml.kernel.org/r/20220914221810.95771-4-mike.kravetz@oracle.com
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

 fs/hugetlbfs/inode.c    |   21 ++++++++++-----------
 include/linux/hugetlb.h |    2 +-
 mm/hugetlb.c            |    8 ++++----
 3 files changed, 15 insertions(+), 16 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlb-rename-remove_huge_page-to-hugetlb_delete_from_page_cache
+++ a/fs/hugetlbfs/inode.c
@@ -364,7 +364,7 @@ static int hugetlbfs_write_end(struct fi
 	return -EINVAL;
 }
 
-static void remove_huge_page(struct page *page)
+static void hugetlb_delete_from_page_cache(struct page *page)
 {
 	ClearPageDirty(page);
 	ClearPageUptodate(page);
@@ -478,15 +478,14 @@ static void remove_inode_hugepages(struc
 			folio_lock(folio);
 			/*
 			 * We must free the huge page and remove from page
-			 * cache (remove_huge_page) BEFORE removing the
-			 * region/reserve map (hugetlb_unreserve_pages).  In
-			 * rare out of memory conditions, removal of the
-			 * region/reserve map could fail. Correspondingly,
-			 * the subpool and global reserve usage count can need
-			 * to be adjusted.
+			 * cache BEFORE removing the region/reserve map
+			 * (hugetlb_unreserve_pages).  In rare out of memory
+			 * conditions, removal of the region/reserve map could
+			 * fail. Correspondingly, the subpool and global
+			 * reserve usage count can need to be adjusted.
 			 */
 			VM_BUG_ON(HPageRestoreReserve(&folio->page));
-			remove_huge_page(&folio->page);
+			hugetlb_delete_from_page_cache(&folio->page);
 			freed++;
 			if (!truncate_op) {
 				if (unlikely(hugetlb_unreserve_pages(inode,
@@ -723,7 +722,7 @@ static long hugetlbfs_fallocate(struct f
 		}
 		clear_huge_page(page, addr, pages_per_huge_page(h));
 		__SetPageUptodate(page);
-		error = huge_add_to_page_cache(page, mapping, index);
+		error = hugetlb_add_to_page_cache(page, mapping, index);
 		if (unlikely(error)) {
 			restore_reserve_on_error(h, &pseudo_vma, addr, page);
 			put_page(page);
@@ -735,7 +734,7 @@ static long hugetlbfs_fallocate(struct f
 
 		SetHPageMigratable(page);
 		/*
-		 * unlock_page because locked by huge_add_to_page_cache()
+		 * unlock_page because locked by hugetlb_add_to_page_cache()
 		 * put_page() due to reference from alloc_huge_page()
 		 */
 		unlock_page(page);
@@ -980,7 +979,7 @@ static int hugetlbfs_error_remove_page(s
 	struct inode *inode = mapping->host;
 	pgoff_t index = page->index;
 
-	remove_huge_page(page);
+	hugetlb_delete_from_page_cache(page);
 	if (unlikely(hugetlb_unreserve_pages(inode, index, index + 1, 1)))
 		hugetlb_fix_reserve_counts(inode);
 
--- a/include/linux/hugetlb.h~hugetlb-rename-remove_huge_page-to-hugetlb_delete_from_page_cache
+++ a/include/linux/hugetlb.h
@@ -666,7 +666,7 @@ struct page *alloc_huge_page_nodemask(st
 				nodemask_t *nmask, gfp_t gfp_mask);
 struct page *alloc_huge_page_vma(struct hstate *h, struct vm_area_struct *vma,
 				unsigned long address);
-int huge_add_to_page_cache(struct page *page, struct address_space *mapping,
+int hugetlb_add_to_page_cache(struct page *page, struct address_space *mapping,
 			pgoff_t idx);
 void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
 				unsigned long address, struct page *page);
--- a/mm/hugetlb.c~hugetlb-rename-remove_huge_page-to-hugetlb_delete_from_page_cache
+++ a/mm/hugetlb.c
@@ -5430,7 +5430,7 @@ static bool hugetlbfs_pagecache_present(
 	return page != NULL;
 }
 
-int huge_add_to_page_cache(struct page *page, struct address_space *mapping,
+int hugetlb_add_to_page_cache(struct page *page, struct address_space *mapping,
 			   pgoff_t idx)
 {
 	struct folio *folio = page_folio(page);
@@ -5569,7 +5569,7 @@ static vm_fault_t hugetlb_no_page(struct
 		new_page = true;
 
 		if (vma->vm_flags & VM_MAYSHARE) {
-			int err = huge_add_to_page_cache(page, mapping, idx);
+			int err = hugetlb_add_to_page_cache(page, mapping, idx);
 			if (err) {
 				/*
 				 * err can't be -EEXIST which implies someone
@@ -5981,11 +5981,11 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 
 		/*
 		 * Serialization between remove_inode_hugepages() and
-		 * huge_add_to_page_cache() below happens through the
+		 * hugetlb_add_to_page_cache() below happens through the
 		 * hugetlb_fault_mutex_table that here must be hold by
 		 * the caller.
 		 */
-		ret = huge_add_to_page_cache(page, mapping, idx);
+		ret = hugetlb_add_to_page_cache(page, mapping, idx);
 		if (ret)
 			goto out_release_nounlock;
 		page_in_pagecache = true;
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-simplify-hugetlb-handling-in-follow_page_mask.patch

