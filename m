Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC15C46467
	for <mm-commits@archiver.kernel.org>; Fri, 20 Jan 2023 04:28:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjATE2Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Jan 2023 23:28:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbjATE2X (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2023 23:28:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B12FB2785
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 20:28:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56BA1B82761
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 22:32:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4569C433D2;
        Thu, 19 Jan 2023 22:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674167561;
        bh=71lDqUnftbeMUf8UOzCpFlvcvyFW+8PpwSbxIVUGRDw=;
        h=Date:To:From:Subject:From;
        b=K90IwnIzpiMphW+ssXascjSLwBzft+B9TRljo3h3OLlpvs4CQk6ylHp4joD2z+4hm
         AAGa1V8U+ray1GUPvqtGRPCfGGn3qVF4wxveLVfgSEo7lpUxEmflq7odRrbyuI655c
         PUb4zFWVRvkdvPbrTrRn6Aj4SyK31pAQl8tfgO2s=
Date:   Thu, 19 Jan 2023 14:32:40 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-hugetlb_wp-to-take-in-a-folio.patch added to mm-unstable branch
Message-Id: <20230119223240.E4569C433D2@smtp.kernel.org>
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
Date: Thu, 19 Jan 2023 13:14:45 -0800

Change the pagecache_page argument of hugetlb_wp to pagecache_folio. 
Replaces a call to find_lock_page() with filemap_lock_folio().

Link: https://lkml.kernel.org/r/20230119211446.54165-9-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
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
@@ -5923,7 +5923,7 @@ static vm_fault_t hugetlb_no_page(struct
 	hugetlb_count_add(pages_per_huge_page(h), mm);
 	if ((flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED)) {
 		/* Optimization, do the COW without a second fault */
-		ret = hugetlb_wp(mm, vma, address, ptep, flags, &folio->page, ptl);
+		ret = hugetlb_wp(mm, vma, address, ptep, flags, folio, ptl);
 	}
 
 	spin_unlock(ptl);
@@ -5986,7 +5986,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	u32 hash;
 	pgoff_t idx;
 	struct page *page = NULL;
-	struct page *pagecache_page = NULL;
+	struct folio *pagecache_folio = NULL;
 	struct hstate *h = hstate_vma(vma);
 	struct address_space *mapping;
 	int need_wait_lock = 0;
@@ -6068,7 +6068,7 @@ vm_fault_t hugetlb_fault(struct mm_struc
 		/* Just decrements count, does not deallocate */
 		vma_end_reservation(h, vma, haddr);
 
-		pagecache_page = find_lock_page(mapping, idx);
+		pagecache_folio = filemap_lock_folio(mapping, idx);
 	}
 
 	ptl = huge_pte_lock(h, mm, ptep);
@@ -6088,9 +6088,9 @@ vm_fault_t hugetlb_fault(struct mm_struc
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
@@ -6099,22 +6099,22 @@ vm_fault_t hugetlb_fault(struct mm_struc
 
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
 		}
 
-	get_page(page);
+	folio_get(pagecache_folio);
 
 	if (flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)) {
 		if (!huge_pte_write(entry)) {
 			ret = hugetlb_wp(mm, vma, address, ptep, flags,
-					 pagecache_page, ptl);
+					 pagecache_folio, ptl);
 			goto out_put_page;
 		} else if (likely(flags & FAULT_FLAG_WRITE)) {
 			entry = huge_pte_mkdirty(entry);
@@ -6125,15 +6125,15 @@ vm_fault_t hugetlb_fault(struct mm_struc
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
mm-rmap-change-hugepage_add_new_anon_rmap-to-take-in-a-folio.patch
mm-hugetlb-convert-alloc_huge_page-to-alloc_hugetlb_folio.patch
mm-hugetlb-convert-restore_reserve_on_error-to-take-in-a-folio.patch
mm-hugetlb-convert-hugetlb_add_to_page_cache-to-take-in-a-folio.patch
mm-hugetlb-convert-hugetlb_wp-to-take-in-a-folio.patch
documentation-mm-update-hugetlbfs-documentation-to-mention-alloc_hugetlb_folio.patch

