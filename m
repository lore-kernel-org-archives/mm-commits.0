Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B200C636CC
	for <mm-commits@archiver.kernel.org>; Mon, 13 Feb 2023 23:55:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbjBMXzg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Feb 2023 18:55:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbjBMXz3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2023 18:55:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A2A617CF3
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 15:55:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7141B81A2F
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 23:55:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50DA5C4339B;
        Mon, 13 Feb 2023 23:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676332524;
        bh=BQ9AvidOfRlaBUC8G3nZKrTWOE/FoXq3MQrGF2HOJUM=;
        h=Date:To:From:Subject:From;
        b=YcNI8KW0uSYyKMmP47ukGLnoN6cU97tYp0/Zk1SG6oOZ3LIZxzv8DQ1G4nheIE6ef
         llUG1JFpU9lNRwrkJCaJTVghYNOeYs5qYbXNuRmJaroejDe90JEgkLcRJ553Kv6D2U
         QcEm84XhtEl8/klDFEetFtZCY5rnNKRMqtFRIhVM=
Date:   Mon, 13 Feb 2023 15:55:23 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, gerald.schaefer@linux.ibm.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-convert-hugetlb_add_to_page_cache-to-take-in-a-folio.patch removed from -mm tree
Message-Id: <20230213235524.50DA5C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: convert hugetlb_add_to_page_cache to take in a folio
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-convert-hugetlb_add_to_page_cache-to-take-in-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: convert hugetlb_add_to_page_cache to take in a folio
Date: Wed, 25 Jan 2023 09:05:35 -0800

Every caller of hugetlb_add_to_page_cache() is now passing in
&folio->page, change the function to take in a folio directly and clean up
the call sites.

Link: https://lkml.kernel.org/r/20230125170537.96973-7-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/hugetlbfs/inode.c~mm-hugetlb-convert-hugetlb_add_to_page_cache-to-take-in-a-folio
+++ a/fs/hugetlbfs/inode.c
@@ -871,7 +871,7 @@ static long hugetlbfs_fallocate(struct f
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
@@ -723,7 +723,7 @@ struct folio *alloc_hugetlb_folio_nodema
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
@@ -5662,10 +5662,9 @@ static bool hugetlbfs_pagecache_present(
 	return present;
 }
 
-int hugetlb_add_to_page_cache(struct page *page, struct address_space *mapping,
+int hugetlb_add_to_page_cache(struct folio *folio, struct address_space *mapping,
 			   pgoff_t idx)
 {
-	struct folio *folio = page_folio(page);
 	struct inode *inode = mapping->host;
 	struct hstate *h = hstate_inode(inode);
 	int err;
@@ -5677,7 +5676,7 @@ int hugetlb_add_to_page_cache(struct pag
 		__folio_clear_locked(folio);
 		return err;
 	}
-	ClearHPageRestoreReserve(page);
+	folio_clear_hugetlb_restore_reserve(folio);
 
 	/*
 	 * mark folio dirty so that it will not be removed from cache/file
@@ -5836,7 +5835,7 @@ static vm_fault_t hugetlb_no_page(struct
 		new_folio = true;
 
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
 		folio_in_pagecache = true;
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


