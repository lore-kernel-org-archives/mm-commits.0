Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A8F1ECAAD3
	for <mm-commits@archiver.kernel.org>; Wed, 14 Sep 2022 23:01:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiINXBI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Sep 2022 19:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiINXBC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Sep 2022 19:01:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D78EF52FD8
        for <mm-commits@vger.kernel.org>; Wed, 14 Sep 2022 16:01:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F66161F79
        for <mm-commits@vger.kernel.org>; Wed, 14 Sep 2022 23:01:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE53C433C1;
        Wed, 14 Sep 2022 23:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663196460;
        bh=QWvK7XKgLU/yexjfUZwCml6kM0WxMxF7sx4wdIM1bE8=;
        h=Date:To:From:Subject:From;
        b=zKvwNovvz6a7fcAPnMgOX4lOcPcLLs4CjKWeqfiN2QiV4zZwY+iPoXClJ0r92gWVV
         8guaEvNBt/5KpedxhO51QMo6TbeZzIDf+xl+7rmYytYIaKxC/xSM4eas9Z3b1aHoWB
         ld0qHNyAl2E6GlJ6DBPGo1I4oFilJ2bk9oUyXnRA=
Date:   Wed, 14 Sep 2022 16:01:00 -0700
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
Subject: + hugetlb-rename-remove_huge_page-to-hugetlb_delete_from_page_cache.patch added to mm-unstable branch
Message-Id: <20220914230100.ABE53C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: rename remove_huge_page to hugetlb_delete_from_page_cache
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-rename-remove_huge_page-to-hugetlb_delete_from_page_cache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-rename-remove_huge_page-to-hugetlb_delete_from_page_cache.patch

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

hugetlbfs-revert-use-i_mmap_rwsem-to-address-page-fault-truncate-race.patch
hugetlbfs-revert-use-i_mmap_rwsem-for-more-pmd-sharing-synchronization.patch
hugetlb-rename-remove_huge_page-to-hugetlb_delete_from_page_cache.patch
hugetlb-create-remove_inode_single_folio-to-remove-single-file-folio.patch
hugetlb-rename-vma_shareable-and-refactor-code.patch
hugetlb-add-vma-based-lock-for-pmd-sharing.patch
hugetlb-create-hugetlb_unmap_file_folio-to-unmap-single-file-folio.patch
hugetlb-use-new-vma_lock-for-pmd-sharing-synchronization.patch
hugetlb-clean-up-code-checking-for-fault-truncation-races.patch

