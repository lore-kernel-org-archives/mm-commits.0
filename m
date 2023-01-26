Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E41B6C27C76
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 00:48:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjAZAsg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Jan 2023 19:48:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236399AbjAZAsa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2023 19:48:30 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C29636470
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2023 16:48:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B12DBCE2273
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 00:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC98C433D2;
        Thu, 26 Jan 2023 00:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674694105;
        bh=1upaGocd09uTxKz54Yvs2OpH18b7uK9P6vNG0DoyZ/0=;
        h=Date:To:From:Subject:From;
        b=0Md5ITmYZyUSybWrGE3otjqA3VFZAaoyZDJNxHY/OMLd01lpKFbGUXAwe313xc3k/
         gh9N/qal+u731EGOgm/K9ffEc/WkhC5Rp3pZ1EYkib0+4hlr1thWYfFHXEPxZl9y82
         7GFg/k0LEXOjGlgdRcyijoRi9XknofFp4nv7psuU=
Date:   Wed, 25 Jan 2023 16:48:24 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com, lkp@intel.com,
        jhubbard@nvidia.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-hugetlb_wp-to-take-in-a-folio.patch added to mm-unstable branch
Message-Id: <20230126004824.DDC98C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: convert hugetlb_wp() to take in a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-hugetlb_wp-to-take-in-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-hugetlb_wp-to-take-in-a-folio.patch

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
Subject: mm/hugetlb: convert hugetlb_wp() to take in a folio
Date: Wed, 25 Jan 2023 09:05:36 -0800

Change the pagecache_page argument of hugetlb_wp to pagecache_folio. 
Replaces a call to find_lock_page() with filemap_lock_folio().

Link: https://lkml.kernel.org/r/20230125170537.96973-8-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reported-by: gerald.schaefer@linux.ibm.com
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: kernel test robot <lkp@intel.com>
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
mm-hugetlb-convert-hugetlb-fault-paths-to-use-alloc_hugetlb_folio.patch
mm-hugetlb-convert-restore_reserve_on_error-to-take-in-a-folio.patch
mm-hugetlb-convert-hugetlb_add_to_page_cache-to-take-in-a-folio.patch
mm-hugetlb-convert-hugetlb_wp-to-take-in-a-folio.patch
documentation-mm-update-hugetlbfs-documentation-to-mention-alloc_hugetlb_folio.patch

