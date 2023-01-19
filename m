Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8150AC46467
	for <mm-commits@archiver.kernel.org>; Fri, 20 Jan 2023 04:28:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbjATE2g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Jan 2023 23:28:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbjATE23 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2023 23:28:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D58AEDA5
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 20:28:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1765DB8275A
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 22:32:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02EEC433EF;
        Thu, 19 Jan 2023 22:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674167558;
        bh=EFQFm5HyCoiVFqSh+09gu59F27Zi+Ejf5Wu3kytEu34=;
        h=Date:To:From:Subject:From;
        b=t24fQJ822O477qkOKkczksVXHVkur1IiNYFSlgC4D+WHlnJJS0h/AJPoerngXWIsI
         zCTydjiKe/AQBCoxV9tkiRIdG9C9UaXTFOdj7zfNnm3yo2l61ixDgeWk5TzKYCmPrF
         CCa/kkmERBrtMT/UPbakxu2TGfdhzIO0QV82sZE0=
Date:   Thu, 19 Jan 2023 14:32:38 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-hugetlb_add_to_page_cache-to-take-in-a-folio.patch added to mm-unstable branch
Message-Id: <20230119223238.B02EEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: convert hugetlb_add_to_page_cache to take in a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-hugetlb_add_to_page_cache-to-take-in-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-hugetlb_add_to_page_cache-to-take-in-a-folio.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: convert hugetlb_add_to_page_cache to take in a folio
Date: Thu, 19 Jan 2023 13:14:44 -0800

Every caller of hugetlb_add_to_page_cache() is now passing in
&folio->page, change the function to take in a folio directly and clean up
the call sites.

Link: https://lkml.kernel.org/r/20230119211446.54165-8-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/hugetlbfs/inode.c~mm-hugetlb-convert-hugetlb_add_to_page_cache-to-take-in-a-folio
+++ a/fs/hugetlbfs/inode.c
@@ -869,7 +869,7 @@ static long hugetlbfs_fallocate(struct f
 		}
 		clear_huge_page(&folio->page, addr, pages_per_huge_page(h));
 		__folio_mark_uptodate(folio);
-		error = hugetlb_add_to_page_cache(&folio->page, mapping, index);
+		error = hugetlb_add_to_page_cache(folio, mapping, index);
 		if (unlikely(error)) {
 			restore_reserve_on_error(h, &pseudo_vma, addr, folio);
 			folio_put(folio);
--- a/include/linux/hugetlb.h~mm-hugetlb-convert-hugetlb_add_to_page_cache-to-take-in-a-folio
+++ a/include/linux/hugetlb.h
@@ -722,7 +722,7 @@ struct folio *alloc_hugetlb_folio_nodema
 				nodemask_t *nmask, gfp_t gfp_mask);
 struct folio *alloc_hugetlb_folio_vma(struct hstate *h, struct vm_area_struct *vma,
 				unsigned long address);
-int hugetlb_add_to_page_cache(struct page *page, struct address_space *mapping,
+int hugetlb_add_to_page_cache(struct folio *folio, struct address_space *mapping,
 			pgoff_t idx);
 void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
 				unsigned long address, struct folio *folio);
--- a/mm/hugetlb.c~mm-hugetlb-convert-hugetlb_add_to_page_cache-to-take-in-a-folio
+++ a/mm/hugetlb.c
@@ -5663,10 +5663,9 @@ static bool hugetlbfs_pagecache_present(
 	return folio != NULL;
 }
 
-int hugetlb_add_to_page_cache(struct page *page, struct address_space *mapping,
+int hugetlb_add_to_page_cache(struct folio *folio, struct address_space *mapping,
 			   pgoff_t idx)
 {
-	struct folio *folio = page_folio(page);
 	struct inode *inode = mapping->host;
 	struct hstate *h = hstate_inode(inode);
 	int err;
@@ -5678,7 +5677,7 @@ int hugetlb_add_to_page_cache(struct pag
 		__folio_clear_locked(folio);
 		return err;
 	}
-	ClearHPageRestoreReserve(page);
+	folio_clear_hugetlb_restore_reserve(folio);
 
 	/*
 	 * mark folio dirty so that it will not be removed from cache/file
@@ -5837,7 +5836,7 @@ static vm_fault_t hugetlb_no_page(struct
 		new_page = true;
 
 		if (vma->vm_flags & VM_MAYSHARE) {
-			int err = hugetlb_add_to_page_cache(&folio->page, mapping, idx);
+			int err = hugetlb_add_to_page_cache(folio, mapping, idx);
 			if (err) {
 				/*
 				 * err can't be -EEXIST which implies someone
@@ -6269,7 +6268,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 		 * hugetlb_fault_mutex_table that here must be hold by
 		 * the caller.
 		 */
-		ret = hugetlb_add_to_page_cache(&folio->page, mapping, idx);
+		ret = hugetlb_add_to_page_cache(folio, mapping, idx);
 		if (ret)
 			goto out_release_nounlock;
 		page_in_pagecache = true;
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-remove-the-hugetlb-field-from-struct-page.patch
mm-memory-failure-convert-__get_huge_page_for_hwpoison-to-folios.patch
mm-memory-failure-convert-try_memory_failure_hugetlb-to-folios.patch
mm-memory-failure-convert-hugetlb_clear_page_hwpoison-to-folios.patch
mm-memory-failure-convert-free_raw_hwp_pages-to-folios.patch
mm-memory-failure-convert-raw_hwp_list_head-to-folios.patch
mm-memory-failure-convert-__free_raw_hwp_pages-to-folios.patch
mm-memory-failure-convert-hugetlb_set_page_hwpoison-to-folios.patch
mm-memory-failure-convert-unpoison_memory-to-folios.patch
mm-hugetlb-convert-isolate_hugetlb-to-folios.patch
mm-hugetlb-convert-__update_and_free_page-to-folios.patch
mm-hugetlb-convert-dequeue_hugetlb_page-functions-to-folios.patch
mm-hugetlb-convert-alloc_surplus_huge_page-to-folios.patch
mm-hugetlb-increase-use-of-folios-in-alloc_huge_page.patch
mm-hugetlb-convert-alloc_migrate_huge_page-to-folios.patch
mm-hugetlb-convert-restore_reserve_on_error-to-folios.patch
mm-hugetlb-convert-demote_free_huge_page-to-folios.patch
mm-hugetlb-convert-get_hwpoison_huge_page-to-folios.patch
mm-hugetlb-convert-hugetlb_install_page-to-folios.patch
mm-hugetlb-convert-hugetlbfs_pagecache_present-to-folios.patch
mm-hugetlb-convert-putback_active_hugepage-to-take-in-a-folio.patch
mm-rmap-change-hugepage_add_new_anon_rmap-to-take-in-a-folio.patch
mm-hugetlb-convert-alloc_huge_page-to-alloc_hugetlb_folio.patch
mm-hugetlb-convert-restore_reserve_on_error-to-take-in-a-folio.patch
mm-hugetlb-convert-hugetlb_add_to_page_cache-to-take-in-a-folio.patch
mm-hugetlb-convert-hugetlb_wp-to-take-in-a-folio.patch
documentation-mm-update-hugetlbfs-documentation-to-mention-alloc_hugetlb_folio.patch

