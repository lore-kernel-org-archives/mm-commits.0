Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2027C6379F
	for <mm-commits@archiver.kernel.org>; Sat, 14 Jan 2023 03:53:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbjANDxd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Jan 2023 22:53:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbjANDxU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2023 22:53:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5EDAE98
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2023 19:53:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BA60623AF
        for <mm-commits@vger.kernel.org>; Sat, 14 Jan 2023 03:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B7EC433D2;
        Sat, 14 Jan 2023 03:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673668383;
        bh=pJT04oTd2V7tBgdy4y1ZEOu0WykO4pCfL1O/T16Pu64=;
        h=Date:To:From:Subject:From;
        b=l5H8k5TXHr2BPqbVqLZpubv5EDPrCgVrzDLJTEFdoKaFzseZoeUsvxAs1pH2Ion8S
         L9JwfRGCJg67gHZdAH/iHvdahuXP2NJq0zdY7P6q8FYiSWFgeSe/LFvHhPTZp1AFjL
         0ocKBDAvwTLyrP2PbcxzR0qkcQ/+N8BsTWmlsqp0=
Date:   Fri, 13 Jan 2023 19:53:03 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-alloc_surplus_huge_page-to-folios.patch added to mm-unstable branch
Message-Id: <20230114035303.A3B7EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: convert alloc_surplus_huge_page() to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-alloc_surplus_huge_page-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-alloc_surplus_huge_page-to-folios.patch

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
Subject: mm/hugetlb: convert alloc_surplus_huge_page() to folios
Date: Fri, 13 Jan 2023 16:30:53 -0600

Change alloc_surplus_huge_page() to alloc_surplus_hugetlb_folio() and
update its callers.

Link: https://lkml.kernel.org/r/20230113223057.173292-5-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/hugetlb.c~mm-hugetlb-convert-alloc_surplus_huge_page-to-folios
+++ a/mm/hugetlb.c
@@ -2378,8 +2378,8 @@ int dissolve_free_huge_pages(unsigned lo
 /*
  * Allocates a fresh surplus page from the page allocator.
  */
-static struct page *alloc_surplus_huge_page(struct hstate *h, gfp_t gfp_mask,
-						int nid, nodemask_t *nmask)
+static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
+				gfp_t gfp_mask,	int nid, nodemask_t *nmask)
 {
 	struct folio *folio = NULL;
 
@@ -2416,7 +2416,7 @@ static struct page *alloc_surplus_huge_p
 out_unlock:
 	spin_unlock_irq(&hugetlb_lock);
 
-	return &folio->page;
+	return folio;
 }
 
 static struct page *alloc_migrate_huge_page(struct hstate *h, gfp_t gfp_mask,
@@ -2449,7 +2449,7 @@ static
 struct page *alloc_buddy_huge_page_with_mpol(struct hstate *h,
 		struct vm_area_struct *vma, unsigned long addr)
 {
-	struct page *page = NULL;
+	struct folio *folio = NULL;
 	struct mempolicy *mpol;
 	gfp_t gfp_mask = htlb_alloc_mask(h);
 	int nid;
@@ -2460,16 +2460,16 @@ struct page *alloc_buddy_huge_page_with_
 		gfp_t gfp = gfp_mask | __GFP_NOWARN;
 
 		gfp &=  ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
-		page = alloc_surplus_huge_page(h, gfp, nid, nodemask);
+		folio = alloc_surplus_hugetlb_folio(h, gfp, nid, nodemask);
 
 		/* Fallback to all nodes if page==NULL */
 		nodemask = NULL;
 	}
 
-	if (!page)
-		page = alloc_surplus_huge_page(h, gfp_mask, nid, nodemask);
+	if (!folio)
+		folio = alloc_surplus_hugetlb_folio(h, gfp_mask, nid, nodemask);
 	mpol_cond_put(mpol);
-	return page;
+	return &folio->page;
 }
 
 /* page migration callback function */
@@ -2518,6 +2518,7 @@ static int gather_surplus_pages(struct h
 	__must_hold(&hugetlb_lock)
 {
 	LIST_HEAD(surplus_list);
+	struct folio *folio;
 	struct page *page, *tmp;
 	int ret;
 	long i;
@@ -2537,13 +2538,13 @@ static int gather_surplus_pages(struct h
 retry:
 	spin_unlock_irq(&hugetlb_lock);
 	for (i = 0; i < needed; i++) {
-		page = alloc_surplus_huge_page(h, htlb_alloc_mask(h),
+		folio = alloc_surplus_hugetlb_folio(h, htlb_alloc_mask(h),
 				NUMA_NO_NODE, NULL);
-		if (!page) {
+		if (!folio) {
 			alloc_ok = false;
 			break;
 		}
-		list_add(&page->lru, &surplus_list);
+		list_add(&folio->lru, &surplus_list);
 		cond_resched();
 	}
 	allocated += i;
@@ -3496,7 +3497,7 @@ static int set_max_huge_pages(struct hst
 	 * First take pages out of surplus state.  Then make up the
 	 * remaining difference by allocating fresh huge pages.
 	 *
-	 * We might race with alloc_surplus_huge_page() here and be unable
+	 * We might race with alloc_surplus_hugetlb_folio() here and be unable
 	 * to convert a surplus huge page to a normal huge page. That is
 	 * not critical, though, it just means the overall size of the
 	 * pool might be one hugepage larger than it needs to be, but
@@ -3539,7 +3540,7 @@ static int set_max_huge_pages(struct hst
 	 * By placing pages into the surplus state independent of the
 	 * overcommit value, we are allowing the surplus pool size to
 	 * exceed overcommit. There are few sane options here. Since
-	 * alloc_surplus_huge_page() is checking the global counter,
+	 * alloc_surplus_hugetlb_folio() is checking the global counter,
 	 * though, we'll note that we're not allowed to exceed surplus
 	 * and won't grow the pool anywhere else. Not until one of the
 	 * sysctls are changed, or the surplus pages go out of use.
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

