Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30025C4167B
	for <mm-commits@archiver.kernel.org>; Tue, 29 Nov 2022 23:57:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbiK2X5m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Nov 2022 18:57:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiK2X50 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 29 Nov 2022 18:57:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722175B861
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2022 15:57:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF4E6B8196F
        for <mm-commits@vger.kernel.org>; Tue, 29 Nov 2022 23:57:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A610FC433D6;
        Tue, 29 Nov 2022 23:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669766241;
        bh=thMhZ7zBI9TU6ZKLj6Ed6hQvAbvyIjOTGkmOSidf0Pk=;
        h=Date:To:From:Subject:From;
        b=06gIRW8V20kOEZ2MZtU2uQZvZDSRszjzlC/S5rCU3/Mgyf0nrolzOJh5HRE/Kdq2H
         +m4TDzrqlLUVi9c82Hd+KwEyJ5OJM9piG7WUJu6AYXIa4li6ObK2DGAvFblEgGq0aE
         1BO4UGyg9OroIcgURcR5yKrD+4zaWrvMMVMuFFO8=
Date:   Tue, 29 Nov 2022 15:57:21 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tsahu@linux.ibm.com, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linux@rasmusvillemoes.dk,
        linmiaohe@huawei.com, jhubbard@nvidia.com,
        harperchen1110@gmail.com, david@redhat.com, almasrymina@google.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-change-hugetlb-allocation-functions-to-return-a-folio.patch added to mm-unstable branch
Message-Id: <20221129235721.A610FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: change hugetlb allocation functions to return a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-change-hugetlb-allocation-functions-to-return-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-change-hugetlb-allocation-functions-to-return-a-folio.patch

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
Subject: mm/hugetlb: change hugetlb allocation functions to return a folio
Date: Tue, 29 Nov 2022 14:50:39 -0800

Many hugetlb allocation helper functions have now been converting to
folios, update their higher level callers to be compatible with folios. 
alloc_pool_huge_page is reorganized to avoid a smatch warning reporting
the folio variable is unintialized.

Link: https://lkml.kernel.org/r/20221129225039.82257-11-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reported-by: Wei Chen <harperchen1110@gmail.com>
Suggested-by: John Hubbard <jhubbard@nvidia.com>
Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Tarun Sahu <tsahu@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |  120 +++++++++++++++++++++++--------------------------
 1 file changed, 57 insertions(+), 63 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-change-hugetlb-allocation-functions-to-return-a-folio
+++ a/mm/hugetlb.c
@@ -1378,23 +1378,23 @@ static void free_gigantic_folio(struct f
 }
 
 #ifdef CONFIG_CONTIG_ALLOC
-static struct page *alloc_gigantic_page(struct hstate *h, gfp_t gfp_mask,
+static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t gfp_mask,
 		int nid, nodemask_t *nodemask)
 {
+	struct page *page;
 	unsigned long nr_pages = pages_per_huge_page(h);
 	if (nid == NUMA_NO_NODE)
 		nid = numa_mem_id();
 
 #ifdef CONFIG_CMA
 	{
-		struct page *page;
 		int node;
 
 		if (hugetlb_cma[nid]) {
 			page = cma_alloc(hugetlb_cma[nid], nr_pages,
 					huge_page_order(h), true);
 			if (page)
-				return page;
+				return page_folio(page);
 		}
 
 		if (!(gfp_mask & __GFP_THISNODE)) {
@@ -1405,17 +1405,18 @@ static struct page *alloc_gigantic_page(
 				page = cma_alloc(hugetlb_cma[node], nr_pages,
 						huge_page_order(h), true);
 				if (page)
-					return page;
+					return page_folio(page);
 			}
 		}
 	}
 #endif
 
-	return alloc_contig_pages(nr_pages, gfp_mask, nid, nodemask);
+	page = alloc_contig_pages(nr_pages, gfp_mask, nid, nodemask);
+	return page ? page_folio(page) : NULL;
 }
 
 #else /* !CONFIG_CONTIG_ALLOC */
-static struct page *alloc_gigantic_page(struct hstate *h, gfp_t gfp_mask,
+static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t gfp_mask,
 					int nid, nodemask_t *nodemask)
 {
 	return NULL;
@@ -1423,7 +1424,7 @@ static struct page *alloc_gigantic_page(
 #endif /* CONFIG_CONTIG_ALLOC */
 
 #else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE */
-static struct page *alloc_gigantic_page(struct hstate *h, gfp_t gfp_mask,
+static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t gfp_mask,
 					int nid, nodemask_t *nodemask)
 {
 	return NULL;
@@ -1950,7 +1951,7 @@ pgoff_t hugetlb_basepage_index(struct pa
 	return (index << compound_order(page_head)) + compound_idx;
 }
 
-static struct page *alloc_buddy_huge_page(struct hstate *h,
+static struct folio *alloc_buddy_hugetlb_folio(struct hstate *h,
 		gfp_t gfp_mask, int nid, nodemask_t *nmask,
 		nodemask_t *node_alloc_noretry)
 {
@@ -1988,11 +1989,6 @@ retry:
 		page = NULL;
 	}
 
-	if (page)
-		__count_vm_event(HTLB_BUDDY_PGALLOC);
-	else
-		__count_vm_event(HTLB_BUDDY_PGALLOC_FAIL);
-
 	/*
 	 * If we did not specify __GFP_RETRY_MAYFAIL, but still got a page this
 	 * indicates an overall state change.  Clear bit so that we resume
@@ -2009,7 +2005,13 @@ retry:
 	if (node_alloc_noretry && !page && alloc_try_hard)
 		node_set(nid, *node_alloc_noretry);
 
-	return page;
+	if (!page) {
+		__count_vm_event(HTLB_BUDDY_PGALLOC_FAIL);
+		return NULL;
+	}
+
+	__count_vm_event(HTLB_BUDDY_PGALLOC);
+	return page_folio(page);
 }
 
 /*
@@ -2019,23 +2021,21 @@ retry:
  * Note that returned page is 'frozen':  ref count of head page and all tail
  * pages is zero.
  */
-static struct page *alloc_fresh_huge_page(struct hstate *h,
+static struct folio *alloc_fresh_hugetlb_folio(struct hstate *h,
 		gfp_t gfp_mask, int nid, nodemask_t *nmask,
 		nodemask_t *node_alloc_noretry)
 {
-	struct page *page;
 	struct folio *folio;
 	bool retry = false;
 
 retry:
 	if (hstate_is_gigantic(h))
-		page = alloc_gigantic_page(h, gfp_mask, nid, nmask);
+		folio = alloc_gigantic_folio(h, gfp_mask, nid, nmask);
 	else
-		page = alloc_buddy_huge_page(h, gfp_mask,
+		folio = alloc_buddy_hugetlb_folio(h, gfp_mask,
 				nid, nmask, node_alloc_noretry);
-	if (!page)
+	if (!folio)
 		return NULL;
-	folio = page_folio(page);
 	if (hstate_is_gigantic(h)) {
 		if (!prep_compound_gigantic_folio(folio, huge_page_order(h))) {
 			/*
@@ -2052,7 +2052,7 @@ retry:
 	}
 	prep_new_hugetlb_folio(h, folio, folio_nid(folio));
 
-	return page;
+	return folio;
 }
 
 /*
@@ -2062,23 +2062,20 @@ retry:
 static int alloc_pool_huge_page(struct hstate *h, nodemask_t *nodes_allowed,
 				nodemask_t *node_alloc_noretry)
 {
-	struct page *page;
+	struct folio *folio;
 	int nr_nodes, node;
 	gfp_t gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
 
 	for_each_node_mask_to_alloc(h, nr_nodes, node, nodes_allowed) {
-		page = alloc_fresh_huge_page(h, gfp_mask, node, nodes_allowed,
-						node_alloc_noretry);
-		if (page)
-			break;
+		folio = alloc_fresh_hugetlb_folio(h, gfp_mask, node,
+					nodes_allowed, node_alloc_noretry);
+		if (folio) {
+			free_huge_page(&folio->page); /* free it into the hugepage allocator */
+			return 1;
+		}
 	}
 
-	if (!page)
-		return 0;
-
-	free_huge_page(page); /* free it into the hugepage allocator */
-
-	return 1;
+	return 0;
 }
 
 /*
@@ -2237,7 +2234,7 @@ int dissolve_free_huge_pages(unsigned lo
 static struct page *alloc_surplus_huge_page(struct hstate *h, gfp_t gfp_mask,
 						int nid, nodemask_t *nmask)
 {
-	struct page *page = NULL;
+	struct folio *folio = NULL;
 
 	if (hstate_is_gigantic(h))
 		return NULL;
@@ -2247,8 +2244,8 @@ static struct page *alloc_surplus_huge_p
 		goto out_unlock;
 	spin_unlock_irq(&hugetlb_lock);
 
-	page = alloc_fresh_huge_page(h, gfp_mask, nid, nmask, NULL);
-	if (!page)
+	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
+	if (!folio)
 		return NULL;
 
 	spin_lock_irq(&hugetlb_lock);
@@ -2260,43 +2257,42 @@ static struct page *alloc_surplus_huge_p
 	 * codeflow
 	 */
 	if (h->surplus_huge_pages >= h->nr_overcommit_huge_pages) {
-		SetHPageTemporary(page);
+		folio_set_hugetlb_temporary(folio);
 		spin_unlock_irq(&hugetlb_lock);
-		free_huge_page(page);
+		free_huge_page(&folio->page);
 		return NULL;
 	}
 
 	h->surplus_huge_pages++;
-	h->surplus_huge_pages_node[page_to_nid(page)]++;
+	h->surplus_huge_pages_node[folio_nid(folio)]++;
 
 out_unlock:
 	spin_unlock_irq(&hugetlb_lock);
 
-	return page;
+	return &folio->page;
 }
 
 static struct page *alloc_migrate_huge_page(struct hstate *h, gfp_t gfp_mask,
 				     int nid, nodemask_t *nmask)
 {
-	struct page *page;
+	struct folio *folio;
 
 	if (hstate_is_gigantic(h))
 		return NULL;
 
-	page = alloc_fresh_huge_page(h, gfp_mask, nid, nmask, NULL);
-	if (!page)
+	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
+	if (!folio)
 		return NULL;
 
 	/* fresh huge pages are frozen */
-	set_page_refcounted(page);
-
+	folio_ref_unfreeze(folio, 1);
 	/*
 	 * We do not account these pages as surplus because they are only
 	 * temporary and will be released properly on the last reference
 	 */
-	SetHPageTemporary(page);
+	folio_set_hugetlb_temporary(folio);
 
-	return page;
+	return &folio->page;
 }
 
 /*
@@ -2745,19 +2741,18 @@ void restore_reserve_on_error(struct hst
 }
 
 /*
- * alloc_and_dissolve_huge_page - Allocate a new page and dissolve the old one
+ * alloc_and_dissolve_hugetlb_folio - Allocate a new folio and dissolve
+ * the old one
  * @h: struct hstate old page belongs to
- * @old_page: Old page to dissolve
+ * @old_folio: Old folio to dissolve
  * @list: List to isolate the page in case we need to
  * Returns 0 on success, otherwise negated error.
  */
-static int alloc_and_dissolve_huge_page(struct hstate *h, struct page *old_page,
-					struct list_head *list)
+static int alloc_and_dissolve_hugetlb_folio(struct hstate *h,
+			struct folio *old_folio, struct list_head *list)
 {
 	gfp_t gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
-	struct folio *old_folio = page_folio(old_page);
 	int nid = folio_nid(old_folio);
-	struct page *new_page;
 	struct folio *new_folio;
 	int ret = 0;
 
@@ -2768,26 +2763,25 @@ static int alloc_and_dissolve_huge_page(
 	 * the pool.  This simplifies and let us do most of the processing
 	 * under the lock.
 	 */
-	new_page = alloc_buddy_huge_page(h, gfp_mask, nid, NULL, NULL);
-	if (!new_page)
+	new_folio = alloc_buddy_hugetlb_folio(h, gfp_mask, nid, NULL, NULL);
+	if (!new_folio)
 		return -ENOMEM;
-	new_folio = page_folio(new_page);
 	__prep_new_hugetlb_folio(h, new_folio);
 
 retry:
 	spin_lock_irq(&hugetlb_lock);
 	if (!folio_test_hugetlb(old_folio)) {
 		/*
-		 * Freed from under us. Drop new_page too.
+		 * Freed from under us. Drop new_folio too.
 		 */
 		goto free_new;
 	} else if (folio_ref_count(old_folio)) {
 		/*
-		 * Someone has grabbed the page, try to isolate it here.
+		 * Someone has grabbed the folio, try to isolate it here.
 		 * Fail with -EBUSY if not possible.
 		 */
 		spin_unlock_irq(&hugetlb_lock);
-		ret = isolate_hugetlb(old_page, list);
+		ret = isolate_hugetlb(&old_folio->page, list);
 		spin_lock_irq(&hugetlb_lock);
 		goto free_new;
 	} else if (!folio_test_hugetlb_freed(old_folio)) {
@@ -2865,7 +2859,7 @@ int isolate_or_dissolve_huge_page(struct
 	if (folio_ref_count(folio) && !isolate_hugetlb(&folio->page, list))
 		ret = 0;
 	else if (!folio_ref_count(folio))
-		ret = alloc_and_dissolve_huge_page(h, &folio->page, list);
+		ret = alloc_and_dissolve_hugetlb_folio(h, folio, list);
 
 	return ret;
 }
@@ -3083,14 +3077,14 @@ static void __init hugetlb_hstate_alloc_
 			if (!alloc_bootmem_huge_page(h, nid))
 				break;
 		} else {
-			struct page *page;
+			struct folio *folio;
 			gfp_t gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
 
-			page = alloc_fresh_huge_page(h, gfp_mask, nid,
+			folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
 					&node_states[N_MEMORY], NULL);
-			if (!page)
+			if (!folio)
 				break;
-			free_huge_page(page); /* free it into the hugepage allocator */
+			free_huge_page(&folio->page); /* free it into the hugepage allocator */
 		}
 		cond_resched();
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

