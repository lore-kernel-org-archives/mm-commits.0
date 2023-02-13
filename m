Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 951DCC636CC
	for <mm-commits@archiver.kernel.org>; Mon, 13 Feb 2023 23:55:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbjBMXzc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Feb 2023 18:55:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbjBMXz2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2023 18:55:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B792616AF9
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 15:55:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DDF86135E
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 23:55:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3810C433EF;
        Mon, 13 Feb 2023 23:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676332525;
        bh=HRObQrTDUpGv8DYQWZVJToU494DqbcTJZpVJU8+oeeQ=;
        h=Date:To:From:Subject:From;
        b=KjI9g33XHa5Rm7x/mBxz4fdIQKAD4GmhyDweztuExttbt4enNc1jqec+J6KaC+Xik
         mTsmrS4SzNAV3ybYmk/jnwLErrLFkPAke/K+mA4RPR7a4DeixqAyPNBA67dp7nj1b/
         CQMgmrJmNTv/9d5z6eIVRV6sz7ySlajTxIf75hss=
Date:   Mon, 13 Feb 2023 15:55:25 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-convert-hugetlb_wp-to-take-in-a-folio.patch removed from -mm tree
Message-Id: <20230213235525.A3810C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: convert hugetlb_wp() to take in a folio
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-convert-hugetlb_wp-to-take-in-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: convert hugetlb_wp() to take in a folio
Date: Wed, 25 Jan 2023 09:05:36 -0800

Change the pagecache_page argument of hugetlb_wp to pagecache_folio. 
Replaces a call to find_lock_page() with filemap_lock_folio().

Link: https://lkml.kernel.org/r/20230125170537.96973-8-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reported-by: gerald.schaefer@linux.ibm.com
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/hugetlb.c~mm-hugetlb-convert-hugetlb_wp-to-take-in-a-folio
+++ a/mm/hugetlb.c
@@ -5472,7 +5472,7 @@ static void unmap_ref_private(struct mm_
  */
 static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
 		       unsigned long address, pte_t *ptep, unsigned int flags,
-		       struct page *pagecache_page, spinlock_t *ptl)
+		       struct folio *pagecache_folio, spinlock_t *ptl)
 {
 	const bool unshare = flags & FAULT_FLAG_UNSHARE;
 	pte_t pte;
@@ -5529,7 +5529,7 @@ retry_avoidcopy:
 	 * of the full address range.
 	 */
 	if (is_vma_resv_set(vma, HPAGE_RESV_OWNER) &&
-			old_page != pagecache_page)
+			page_folio(old_page) != pagecache_folio)
 		outside_reserve = 1;
 
 	get_page(old_page);
@@ -5922,7 +5922,7 @@ static vm_fault_t hugetlb_no_page(struct
 	hugetlb_count_add(pages_per_huge_page(h), mm);
 	if ((flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED)) {
 		/* Optimization, do the COW without a second fault */
-		ret = hugetlb_wp(mm, vma, address, ptep, flags, &folio->page, ptl);
+		ret = hugetlb_wp(mm, vma, address, ptep, flags, folio, ptl);
 	}
 
 	spin_unlock(ptl);
@@ -5985,7 +5985,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	u32 hash;
 	pgoff_t idx;
 	struct page *page = NULL;
-	struct page *pagecache_page = NULL;
+	struct folio *pagecache_folio = NULL;
 	struct hstate *h = hstate_vma(vma);
 	struct address_space *mapping;
 	int need_wait_lock = 0;
@@ -6067,7 +6067,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 		/* Just decrements count, does not deallocate */
 		vma_end_reservation(h, vma, haddr);
 
-		pagecache_page = find_lock_page(mapping, idx);
+		pagecache_folio = filemap_lock_folio(mapping, idx);
 	}
 
 	ptl = huge_pte_lock(h, mm, ptep);
@@ -6087,9 +6087,9 @@ vm_fault_t hugetlb_fault(struct mm_struc
 		};
 
 		spin_unlock(ptl);
-		if (pagecache_page) {
-			unlock_page(pagecache_page);
-			put_page(pagecache_page);
+		if (pagecache_folio) {
+			folio_unlock(pagecache_folio);
+			folio_put(pagecache_folio);
 		}
 		hugetlb_vma_unlock_read(vma);
 		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
@@ -6098,11 +6098,11 @@ vm_fault_t hugetlb_fault(struct mm_struc
 
 	/*
 	 * hugetlb_wp() requires page locks of pte_page(entry) and
-	 * pagecache_page, so here we need take the former one
-	 * when page != pagecache_page or !pagecache_page.
+	 * pagecache_folio, so here we need take the former one
+	 * when page != pagecache_folio or !pagecache_folio.
 	 */
 	page = pte_page(entry);
-	if (page != pagecache_page)
+	if (page_folio(page) != pagecache_folio)
 		if (!trylock_page(page)) {
 			need_wait_lock = 1;
 			goto out_ptl;
@@ -6113,7 +6113,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	if (flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)) {
 		if (!huge_pte_write(entry)) {
 			ret = hugetlb_wp(mm, vma, address, ptep, flags,
-					 pagecache_page, ptl);
+					 pagecache_folio, ptl);
 			goto out_put_page;
 		} else if (likely(flags & FAULT_FLAG_WRITE)) {
 			entry = huge_pte_mkdirty(entry);
@@ -6124,15 +6124,15 @@ vm_fault_t hugetlb_fault(struct mm_struc
 						flags & FAULT_FLAG_WRITE))
 		update_mmu_cache(vma, haddr, ptep);
 out_put_page:
-	if (page != pagecache_page)
+	if (page_folio(page) != pagecache_folio)
 		unlock_page(page);
 	put_page(page);
 out_ptl:
 	spin_unlock(ptl);
 
-	if (pagecache_page) {
-		unlock_page(pagecache_page);
-		put_page(pagecache_page);
+	if (pagecache_folio) {
+		folio_unlock(pagecache_folio);
+		folio_put(pagecache_folio);
 	}
 out_mutex:
 	hugetlb_vma_unlock_read(vma);
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


