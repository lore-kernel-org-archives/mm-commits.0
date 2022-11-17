Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EFF6C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 17 Nov 2022 21:25:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240804AbiKQVZp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Nov 2022 16:25:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240881AbiKQVZW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2022 16:25:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294DE248C5
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2022 13:24:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9340362278
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2022 21:24:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA66C433D6;
        Thu, 17 Nov 2022 21:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668720240;
        bh=JezG4S1Kyvx59ZHusUUN82xJ5/VvWVRiid8s9hbpH9Y=;
        h=Date:To:From:Subject:From;
        b=NfSRlsUQnf4rJhgZRn+qgCqr9IUC38poIMl5qerUwaD+MaTbFHOwPaWr7Mz5oKUlO
         0M7x/HKlhllIawt3RbSpDi/1fSuU9WRnFLNV2TXK0f8ZBA9jcpKn9SqR9V6IjYqrMG
         xV5LgLcZdeaHbeqJmy8EopDH3N4eif8pv8pbQkqs=
Date:   Thu, 17 Nov 2022 13:23:59 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, hughd@google.com, almasrymina@google.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-free_gigantic_page-to-folios.patch added to mm-unstable branch
Message-Id: <20221117212359.EBA66C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: convert free_gigantic_page() to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-free_gigantic_page-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-free_gigantic_page-to-folios.patch

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
Subject: mm/hugetlb: convert free_gigantic_page() to folios
Date: Thu, 17 Nov 2022 13:14:59 -0800

Convert callers of free_gigantic_page() to use folios, function is then
renamed to free_gigantic_folio().

Link: https://lkml.kernel.org/r/20221117211501.17150-9-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-convert-free_gigantic_page-to-folios
+++ a/mm/hugetlb.c
@@ -1361,18 +1361,20 @@ static void destroy_compound_gigantic_fo
 	__destroy_compound_gigantic_folio(folio, order, false);
 }
 
-static void free_gigantic_page(struct page *page, unsigned int order)
+static void free_gigantic_folio(struct folio *folio, unsigned int order)
 {
 	/*
 	 * If the page isn't allocated using the cma allocator,
 	 * cma_release() returns false.
 	 */
 #ifdef CONFIG_CMA
-	if (cma_release(hugetlb_cma[page_to_nid(page)], page, 1 << order))
+	int nid = folio_nid(folio);
+
+	if (cma_release(hugetlb_cma[nid], &folio->page, 1 << order))
 		return;
 #endif
 
-	free_contig_range(page_to_pfn(page), 1 << order);
+	free_contig_range(folio_pfn(folio), 1 << order);
 }
 
 #ifdef CONFIG_CONTIG_ALLOC
@@ -1426,7 +1428,8 @@ static struct page *alloc_gigantic_page(
 {
 	return NULL;
 }
-static inline void free_gigantic_page(struct page *page, unsigned int order) { }
+static inline void free_gigantic_folio(struct folio *folio,
+						unsigned int order) { }
 static inline void destroy_compound_gigantic_folio(struct folio *folio,
 						unsigned int order) { }
 #endif
@@ -1565,7 +1568,7 @@ static void __update_and_free_page(struc
 	 * If we don't know which subpages are hwpoisoned, we can't free
 	 * the hugepage, so it's leaked intentionally.
 	 */
-	if (HPageRawHwpUnreliable(page))
+	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
 		return;
 
 	if (hugetlb_vmemmap_restore(h, page)) {
@@ -1575,7 +1578,7 @@ static void __update_and_free_page(struc
 		 * page and put the page back on the hugetlb free list and treat
 		 * as a surplus page.
 		 */
-		add_hugetlb_folio(h, page_folio(page), true);
+		add_hugetlb_folio(h, folio, true);
 		spin_unlock_irq(&hugetlb_lock);
 		return;
 	}
@@ -1588,7 +1591,7 @@ static void __update_and_free_page(struc
 		hugetlb_clear_page_hwpoison(&folio->page);
 
 	for (i = 0; i < pages_per_huge_page(h); i++) {
-		subpage = nth_page(page, i);
+		subpage = folio_page(folio, i);
 		subpage->flags &= ~(1 << PG_locked | 1 << PG_error |
 				1 << PG_referenced | 1 << PG_dirty |
 				1 << PG_active | 1 << PG_private |
@@ -1597,12 +1600,12 @@ static void __update_and_free_page(struc
 
 	/*
 	 * Non-gigantic pages demoted from CMA allocated gigantic pages
-	 * need to be given back to CMA in free_gigantic_page.
+	 * need to be given back to CMA in free_gigantic_folio.
 	 */
 	if (hstate_is_gigantic(h) ||
 	    hugetlb_cma_folio(folio, huge_page_order(h))) {
 		destroy_compound_gigantic_folio(folio, huge_page_order(h));
-		free_gigantic_page(page, huge_page_order(h));
+		free_gigantic_folio(folio, huge_page_order(h));
 	} else {
 		__free_pages(page, huge_page_order(h));
 	}
@@ -2023,6 +2026,7 @@ static struct page *alloc_fresh_huge_pag
 		nodemask_t *node_alloc_noretry)
 {
 	struct page *page;
+	struct folio *folio;
 	bool retry = false;
 
 retry:
@@ -2033,14 +2037,14 @@ retry:
 				nid, nmask, node_alloc_noretry);
 	if (!page)
 		return NULL;
-
+	folio = page_folio(page);
 	if (hstate_is_gigantic(h)) {
 		if (!prep_compound_gigantic_page(page, huge_page_order(h))) {
 			/*
 			 * Rare failure to convert pages to compound page.
 			 * Free pages and try again - ONCE!
 			 */
-			free_gigantic_page(page, huge_page_order(h));
+			free_gigantic_folio(folio, huge_page_order(h));
 			if (!retry) {
 				retry = true;
 				goto retry;
@@ -3048,6 +3052,7 @@ static void __init gather_bootmem_preall
 
 	list_for_each_entry(m, &huge_boot_pages, list) {
 		struct page *page = virt_to_page(m);
+		struct folio *folio = page_folio(page);
 		struct hstate *h = m->hstate;
 
 		VM_BUG_ON(!hstate_is_gigantic(h));
@@ -3058,7 +3063,7 @@ static void __init gather_bootmem_preall
 			free_huge_page(page); /* add to the hugepage allocator */
 		} else {
 			/* VERY unlikely inflated ref count on a tail page */
-			free_gigantic_page(page, huge_page_order(h));
+			free_gigantic_folio(folio, huge_page_order(h));
 		}
 
 		/*
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-hugetlb_cgroup-convert-__set_hugetlb_cgroup-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_from_page-to-folios.patch
mm-hugetlb_cgroup-convert-set_hugetlb_cgroup-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_migrate-to-folios.patch
mm-hugetlb-convert-isolate_or_dissolve_huge_page-to-folios.patch
mm-hugetlb-convert-free_huge_page-to-folios.patch
mm-hugetlb_cgroup-convert-hugetlb_cgroup_uncharge_page-to-folios.patch
mm-hugeltb_cgroup-convert-hugetlb_cgroup_commit_charge-to-folios.patch
mm-hugetlb-convert-move_hugetlb_state-to-folios.patch
mm-add-folio-dtor-and-order-setter-functions.patch
mm-hugetlb-convert-destroy_compound_gigantic_page-to-folios.patch
mm-hugetlb-convert-dissolve_free_huge_page-to-folios.patch
mm-hugetlb-convert-remove_hugetlb_page-to-folios.patch
mm-hugetlb-convert-update_and_free_page-to-folios.patch
mm-hugetlb-convert-add_hugetlb_page-to-folios-and-add-hugetlb_cma_folio.patch
mm-hugetlb-convert-enqueue_huge_page-to-folios.patch
mm-hugetlb-convert-free_gigantic_page-to-folios.patch
mm-hugetlb-convert-hugetlb-prep-functions-to-folios.patch
mm-hugetlb-change-hugetlb-allocation-functions-to-return-a-folio.patch

