Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4860DC46467
	for <mm-commits@archiver.kernel.org>; Sat, 14 Jan 2023 03:53:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbjANDx1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Jan 2023 22:53:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbjANDxU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2023 22:53:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015A6C1A
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2023 19:53:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D5DA62397
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 03:53:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0EB8C433EF;
        Sat, 14 Jan 2023 03:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673668382;
        bh=iJAQRA7A40m9nE9ssu4YwcHNBbKPwL2SWLLhlIGHl2M=;
        h=Date:To:From:Subject:From;
        b=GVs3QBHg/Py/VRrw8ZknmNOdBbUtvEsQjJh93QEvxqeZUf3Kux3gaLjngjvvYfRuZ
         ipDFY+3gGcgX4Qx0qJivAGp8cBs9ilL6y+h7cHc0xOc52MIK/7wJCVAF0kDnvJY24m
         VKMfcPYiL4A655f1srwEA3+aSy4UT0tFRYXwCaM0=
Date:   Fri, 13 Jan 2023 19:53:01 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-dequeue_hugetlb_page-functions-to-folios.patch added to mm-unstable branch
Message-Id: <20230114035301.E0EB8C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: convert dequeue_hugetlb_page functions to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-dequeue_hugetlb_page-functions-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-dequeue_hugetlb_page-functions-to-folios.patch

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
Subject: mm/hugetlb: convert dequeue_hugetlb_page functions to folios
Date: Fri, 13 Jan 2023 16:30:52 -0600

dequeue_huge_page_node_exact() is changed to dequeue_hugetlb_folio_node_
exact() and dequeue_huge_page_nodemask() is changed to dequeue_hugetlb_
folio_nodemask().  Update their callers to pass in a folio.

Link: https://lkml.kernel.org/r/20230113223057.173292-4-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/hugetlb.c~mm-hugetlb-convert-dequeue_hugetlb_page-functions-to-folios
+++ a/mm/hugetlb.c
@@ -1282,32 +1282,33 @@ static void enqueue_hugetlb_folio(struct
 	folio_set_hugetlb_freed(folio);
 }
 
-static struct page *dequeue_huge_page_node_exact(struct hstate *h, int nid)
+static struct folio *dequeue_hugetlb_folio_node_exact(struct hstate *h,
+								int nid)
 {
-	struct page *page;
+	struct folio *folio;
 	bool pin = !!(current->flags & PF_MEMALLOC_PIN);
 
 	lockdep_assert_held(&hugetlb_lock);
-	list_for_each_entry(page, &h->hugepage_freelists[nid], lru) {
-		if (pin && !is_longterm_pinnable_page(page))
+	list_for_each_entry(folio, &h->hugepage_freelists[nid], lru) {
+		if (pin && !folio_is_longterm_pinnable(folio))
 			continue;
 
-		if (PageHWPoison(page))
+		if (folio_test_hwpoison(folio))
 			continue;
 
-		list_move(&page->lru, &h->hugepage_activelist);
-		set_page_refcounted(page);
-		ClearHPageFreed(page);
+		list_move(&folio->lru, &h->hugepage_activelist);
+		folio_ref_unfreeze(folio, 1);
+		folio_clear_hugetlb_freed(folio);
 		h->free_huge_pages--;
 		h->free_huge_pages_node[nid]--;
-		return page;
+		return folio;
 	}
 
 	return NULL;
 }
 
-static struct page *dequeue_huge_page_nodemask(struct hstate *h, gfp_t gfp_mask, int nid,
-		nodemask_t *nmask)
+static struct folio *dequeue_hugetlb_folio_nodemask(struct hstate *h, gfp_t gfp_mask,
+							int nid, nodemask_t *nmask)
 {
 	unsigned int cpuset_mems_cookie;
 	struct zonelist *zonelist;
@@ -1320,7 +1321,7 @@ static struct page *dequeue_huge_page_no
 retry_cpuset:
 	cpuset_mems_cookie = read_mems_allowed_begin();
 	for_each_zone_zonelist_nodemask(zone, z, zonelist, gfp_zone(gfp_mask), nmask) {
-		struct page *page;
+		struct folio *folio;
 
 		if (!cpuset_zone_allowed(zone, gfp_mask))
 			continue;
@@ -1332,9 +1333,9 @@ retry_cpuset:
 			continue;
 		node = zone_to_nid(zone);
 
-		page = dequeue_huge_page_node_exact(h, node);
-		if (page)
-			return page;
+		folio = dequeue_hugetlb_folio_node_exact(h, node);
+		if (folio)
+			return folio;
 	}
 	if (unlikely(read_mems_allowed_retry(cpuset_mems_cookie)))
 		goto retry_cpuset;
@@ -1352,7 +1353,7 @@ static struct page *dequeue_huge_page_vm
 				unsigned long address, int avoid_reserve,
 				long chg)
 {
-	struct page *page = NULL;
+	struct folio *folio = NULL;
 	struct mempolicy *mpol;
 	gfp_t gfp_mask;
 	nodemask_t *nodemask;
@@ -1374,22 +1375,24 @@ static struct page *dequeue_huge_page_vm
 	nid = huge_node(vma, address, gfp_mask, &mpol, &nodemask);
 
 	if (mpol_is_preferred_many(mpol)) {
-		page = dequeue_huge_page_nodemask(h, gfp_mask, nid, nodemask);
+		folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask,
+							nid, nodemask);
 
 		/* Fallback to all nodes if page==NULL */
 		nodemask = NULL;
 	}
 
-	if (!page)
-		page = dequeue_huge_page_nodemask(h, gfp_mask, nid, nodemask);
+	if (!folio)
+		folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask,
+							nid, nodemask);
 
-	if (page && !avoid_reserve && vma_has_reserves(vma, chg)) {
-		SetHPageRestoreReserve(page);
+	if (folio && !avoid_reserve && vma_has_reserves(vma, chg)) {
+		folio_set_hugetlb_restore_reserve(folio);
 		h->resv_huge_pages--;
 	}
 
 	mpol_cond_put(mpol);
-	return page;
+	return &folio->page;
 
 err:
 	return NULL;
@@ -2475,12 +2478,13 @@ struct page *alloc_huge_page_nodemask(st
 {
 	spin_lock_irq(&hugetlb_lock);
 	if (available_huge_pages(h)) {
-		struct page *page;
+		struct folio *folio;
 
-		page = dequeue_huge_page_nodemask(h, gfp_mask, preferred_nid, nmask);
-		if (page) {
+		folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask,
+						preferred_nid, nmask);
+		if (folio) {
 			spin_unlock_irq(&hugetlb_lock);
-			return page;
+			return &folio->page;
 		}
 	}
 	spin_unlock_irq(&hugetlb_lock);
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-move-folio_set_compound_order-to-mm-internalh.patch
mm-introduce-folio_is_pfmemalloc.patch
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

