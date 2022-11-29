Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39F60C4167B
	for <mm-commits@archiver.kernel.org>; Tue, 29 Nov 2022 23:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiK2X5V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Nov 2022 18:57:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiK2X5R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 29 Nov 2022 18:57:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0695E5ADE3
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2022 15:57:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB390B80EFA
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2022 23:57:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E86C433D6;
        Tue, 29 Nov 2022 23:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669766233;
        bh=5shKdn0B9s8saSLw8f6SpGB4xhtYyuv5DOBA2tciVck=;
        h=Date:To:From:Subject:From;
        b=Dp2VtMJNr2xAph5KMbJFXwxi3blen+ClKUvjNz+6qqBwpPySHJxGfTEX2FMT9OuOG
         qtj6lwrikrdUfNUtrLjQFe28TxDH6TuugpQhwD9SmwENHLbtHMslgEQ0/E1LUZwBMC
         XxBjfb562md40YJFLAsST/+Xj0Dqlk+0algvtwtM=
Date:   Tue, 29 Nov 2022 15:57:12 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tsahu@linux.ibm.com, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linux@rasmusvillemoes.dk,
        linmiaohe@huawei.com, jhubbard@nvidia.com,
        harperchen1110@gmail.com, david@redhat.com, almasrymina@google.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-add_hugetlb_page-to-folios-and-add-hugetlb_cma_folio.patch added to mm-unstable branch
Message-Id: <20221129235713.61E86C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: convert add_hugetlb_page() to folios and add hugetlb_cma_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-add_hugetlb_page-to-folios-and-add-hugetlb_cma_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-add_hugetlb_page-to-folios-and-add-hugetlb_cma_folio.patch

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
Subject: mm/hugetlb: convert add_hugetlb_page() to folios and add hugetlb_cma_folio()
Date: Tue, 29 Nov 2022 14:50:35 -0800

Convert add_hugetlb_page() to take in a folio, also convert
hugetlb_cma_page() to take in a folio.

Link: https://lkml.kernel.org/r/20221129225039.82257-7-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Tarun Sahu <tsahu@linux.ibm.com>
Cc: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-convert-add_hugetlb_page-to-folios-and-add-hugetlb_cma_folio
+++ a/mm/hugetlb.c
@@ -54,13 +54,13 @@ struct hstate hstates[HUGE_MAX_HSTATE];
 #ifdef CONFIG_CMA
 static struct cma *hugetlb_cma[MAX_NUMNODES];
 static unsigned long hugetlb_cma_size_in_node[MAX_NUMNODES] __initdata;
-static bool hugetlb_cma_page(struct page *page, unsigned int order)
+static bool hugetlb_cma_folio(struct folio *folio, unsigned int order)
 {
-	return cma_pages_valid(hugetlb_cma[page_to_nid(page)], page,
+	return cma_pages_valid(hugetlb_cma[folio_nid(folio)], &folio->page,
 				1 << order);
 }
 #else
-static bool hugetlb_cma_page(struct page *page, unsigned int order)
+static bool hugetlb_cma_folio(struct folio *folio, unsigned int order)
 {
 	return false;
 }
@@ -1506,17 +1506,17 @@ static void remove_hugetlb_folio_for_dem
 	__remove_hugetlb_folio(h, folio, adjust_surplus, true);
 }
 
-static void add_hugetlb_page(struct hstate *h, struct page *page,
+static void add_hugetlb_folio(struct hstate *h, struct folio *folio,
 			     bool adjust_surplus)
 {
 	int zeroed;
-	int nid = page_to_nid(page);
+	int nid = folio_nid(folio);
 
-	VM_BUG_ON_PAGE(!HPageVmemmapOptimized(page), page);
+	VM_BUG_ON_FOLIO(!folio_test_hugetlb_vmemmap_optimized(folio), folio);
 
 	lockdep_assert_held(&hugetlb_lock);
 
-	INIT_LIST_HEAD(&page->lru);
+	INIT_LIST_HEAD(&folio->lru);
 	h->nr_huge_pages++;
 	h->nr_huge_pages_node[nid]++;
 
@@ -1525,21 +1525,21 @@ static void add_hugetlb_page(struct hsta
 		h->surplus_huge_pages_node[nid]++;
 	}
 
-	set_compound_page_dtor(page, HUGETLB_PAGE_DTOR);
-	set_page_private(page, 0);
+	folio_set_compound_dtor(folio, HUGETLB_PAGE_DTOR);
+	folio_change_private(folio, NULL);
 	/*
-	 * We have to set HPageVmemmapOptimized again as above
-	 * set_page_private(page, 0) cleared it.
+	 * We have to set hugetlb_vmemmap_optimized again as above
+	 * folio_change_private(folio, NULL) cleared it.
 	 */
-	SetHPageVmemmapOptimized(page);
+	folio_set_hugetlb_vmemmap_optimized(folio);
 
 	/*
-	 * This page is about to be managed by the hugetlb allocator and
+	 * This folio is about to be managed by the hugetlb allocator and
 	 * should have no users.  Drop our reference, and check for others
 	 * just in case.
 	 */
-	zeroed = put_page_testzero(page);
-	if (!zeroed)
+	zeroed = folio_put_testzero(folio);
+	if (unlikely(!zeroed))
 		/*
 		 * It is VERY unlikely soneone else has taken a ref on
 		 * the page.  In this case, we simply return as the
@@ -1548,8 +1548,8 @@ static void add_hugetlb_page(struct hsta
 		 */
 		return;
 
-	arch_clear_hugepage_flags(page);
-	enqueue_huge_page(h, page);
+	arch_clear_hugepage_flags(&folio->page);
+	enqueue_huge_page(h, &folio->page);
 }
 
 static void __update_and_free_page(struct hstate *h, struct page *page)
@@ -1575,7 +1575,7 @@ static void __update_and_free_page(struc
 		 * page and put the page back on the hugetlb free list and treat
 		 * as a surplus page.
 		 */
-		add_hugetlb_page(h, page, true);
+		add_hugetlb_folio(h, page_folio(page), true);
 		spin_unlock_irq(&hugetlb_lock);
 		return;
 	}
@@ -1600,7 +1600,7 @@ static void __update_and_free_page(struc
 	 * need to be given back to CMA in free_gigantic_page.
 	 */
 	if (hstate_is_gigantic(h) ||
-	    hugetlb_cma_page(page, huge_page_order(h))) {
+	    hugetlb_cma_folio(folio, huge_page_order(h))) {
 		destroy_compound_gigantic_folio(folio, huge_page_order(h));
 		free_gigantic_page(page, huge_page_order(h));
 	} else {
@@ -2186,7 +2186,7 @@ retry:
 			update_and_free_hugetlb_folio(h, folio, false);
 		} else {
 			spin_lock_irq(&hugetlb_lock);
-			add_hugetlb_page(h, &folio->page, false);
+			add_hugetlb_folio(h, folio, false);
 			h->max_huge_pages++;
 			spin_unlock_irq(&hugetlb_lock);
 		}
@@ -3453,7 +3453,7 @@ static int demote_free_huge_page(struct
 		/* Allocation of vmemmmap failed, we can not demote page */
 		spin_lock_irq(&hugetlb_lock);
 		set_page_refcounted(page);
-		add_hugetlb_page(h, page, false);
+		add_hugetlb_folio(h, page_folio(page), false);
 		return rc;
 	}
 
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

