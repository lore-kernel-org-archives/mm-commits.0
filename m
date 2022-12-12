Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13F93C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:16:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbiLLCQD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:16:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbiLLCOe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:14:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A8DDED3
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:14:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4846160EC5
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:14:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EDFDC433EF;
        Mon, 12 Dec 2022 02:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811258;
        bh=p53wtZeWkJrUw+WFMy2/LFEJ8zyvODlUB2nmFb7RDTc=;
        h=Date:To:From:Subject:From;
        b=vinY0UCGDhTmwpBY0+aZQRZzQeA/oLrvgIO7ix+dW/a2zAoQH2j6flbw0bkiMNklO
         PZEZzjgIefu/jS+av5hSoieA9OTyiZUSmKjapJuhumVqqiQNr2ymsaSNdSjGcCvyAe
         mW/OGLRNTk/KKo8rHjcgwYYYLT54Y/hraLuaaHxI=
Date:   Sun, 11 Dec 2022 18:14:17 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tsahu@linux.ibm.com, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linux@rasmusvillemoes.dk,
        linmiaohe@huawei.com, jhubbard@nvidia.com,
        harperchen1110@gmail.com, david@redhat.com, almasrymina@google.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-convert-remove_hugetlb_page-to-folios.patch removed from -mm tree
Message-Id: <20221212021418.9EDFDC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: convert remove_hugetlb_page() to folios
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-convert-remove_hugetlb_page-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: convert remove_hugetlb_page() to folios
Date: Tue, 29 Nov 2022 14:50:33 -0800

Removes page_folio() call by converting callers to directly pass a folio
into __remove_hugetlb_page().

Link: https://lkml.kernel.org/r/20221129225039.82257-5-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Tarun Sahu <tsahu@linux.ibm.com>
Cc: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   48 +++++++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 23 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-convert-remove_hugetlb_page-to-folios
+++ a/mm/hugetlb.c
@@ -1432,19 +1432,18 @@ static inline void destroy_compound_giga
 #endif
 
 /*
- * Remove hugetlb page from lists, and update dtor so that page appears
+ * Remove hugetlb folio from lists, and update dtor so that the folio appears
  * as just a compound page.
  *
- * A reference is held on the page, except in the case of demote.
+ * A reference is held on the folio, except in the case of demote.
  *
  * Must be called with hugetlb lock held.
  */
-static void __remove_hugetlb_page(struct hstate *h, struct page *page,
+static void __remove_hugetlb_folio(struct hstate *h, struct folio *folio,
 							bool adjust_surplus,
 							bool demote)
 {
-	int nid = page_to_nid(page);
-	struct folio *folio = page_folio(page);
+	int nid = folio_nid(folio);
 
 	VM_BUG_ON_FOLIO(hugetlb_cgroup_from_folio(folio), folio);
 	VM_BUG_ON_FOLIO(hugetlb_cgroup_from_folio_rsvd(folio), folio);
@@ -1453,9 +1452,9 @@ static void __remove_hugetlb_page(struct
 	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
 		return;
 
-	list_del(&page->lru);
+	list_del(&folio->lru);
 
-	if (HPageFreed(page)) {
+	if (folio_test_hugetlb_freed(folio)) {
 		h->free_huge_pages--;
 		h->free_huge_pages_node[nid]--;
 	}
@@ -1485,26 +1484,26 @@ static void __remove_hugetlb_page(struct
 	 * be turned into a page of smaller size.
 	 */
 	if (!demote)
-		set_page_refcounted(page);
+		folio_ref_unfreeze(folio, 1);
 	if (hstate_is_gigantic(h))
-		set_compound_page_dtor(page, NULL_COMPOUND_DTOR);
+		folio_set_compound_dtor(folio, NULL_COMPOUND_DTOR);
 	else
-		set_compound_page_dtor(page, COMPOUND_PAGE_DTOR);
+		folio_set_compound_dtor(folio, COMPOUND_PAGE_DTOR);
 
 	h->nr_huge_pages--;
 	h->nr_huge_pages_node[nid]--;
 }
 
-static void remove_hugetlb_page(struct hstate *h, struct page *page,
+static void remove_hugetlb_folio(struct hstate *h, struct folio *folio,
 							bool adjust_surplus)
 {
-	__remove_hugetlb_page(h, page, adjust_surplus, false);
+	__remove_hugetlb_folio(h, folio, adjust_surplus, false);
 }
 
-static void remove_hugetlb_page_for_demote(struct hstate *h, struct page *page,
+static void remove_hugetlb_folio_for_demote(struct hstate *h, struct folio *folio,
 							bool adjust_surplus)
 {
-	__remove_hugetlb_page(h, page, adjust_surplus, true);
+	__remove_hugetlb_folio(h, folio, adjust_surplus, true);
 }
 
 static void add_hugetlb_page(struct hstate *h, struct page *page,
@@ -1639,8 +1638,9 @@ static void free_hpage_workfn(struct wor
 		/*
 		 * The VM_BUG_ON_PAGE(!PageHuge(page), page) in page_hstate()
 		 * is going to trigger because a previous call to
-		 * remove_hugetlb_page() will set_compound_page_dtor(page,
-		 * NULL_COMPOUND_DTOR), so do not use page_hstate() directly.
+		 * remove_hugetlb_folio() will call folio_set_compound_dtor
+		 * (folio, NULL_COMPOUND_DTOR), so do not use page_hstate()
+		 * directly.
 		 */
 		h = size_to_hstate(page_size(page));
 
@@ -1749,12 +1749,12 @@ void free_huge_page(struct page *page)
 		h->resv_huge_pages++;
 
 	if (folio_test_hugetlb_temporary(folio)) {
-		remove_hugetlb_page(h, page, false);
+		remove_hugetlb_folio(h, folio, false);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 		update_and_free_page(h, page, true);
 	} else if (h->surplus_huge_pages_node[nid]) {
 		/* remove the page from active list */
-		remove_hugetlb_page(h, page, true);
+		remove_hugetlb_folio(h, folio, true);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 		update_and_free_page(h, page, true);
 	} else {
@@ -2092,6 +2092,7 @@ static struct page *remove_pool_huge_pag
 {
 	int nr_nodes, node;
 	struct page *page = NULL;
+	struct folio *folio;
 
 	lockdep_assert_held(&hugetlb_lock);
 	for_each_node_mask_to_free(h, nr_nodes, node, nodes_allowed) {
@@ -2103,7 +2104,8 @@ static struct page *remove_pool_huge_pag
 		    !list_empty(&h->hugepage_freelists[node])) {
 			page = list_entry(h->hugepage_freelists[node].next,
 					  struct page, lru);
-			remove_hugetlb_page(h, page, acct_surplus);
+			folio = page_folio(page);
+			remove_hugetlb_folio(h, folio, acct_surplus);
 			break;
 		}
 	}
@@ -2165,7 +2167,7 @@ retry:
 			goto retry;
 		}
 
-		remove_hugetlb_page(h, &folio->page, false);
+		remove_hugetlb_folio(h, folio, false);
 		h->max_huge_pages--;
 		spin_unlock_irq(&hugetlb_lock);
 
@@ -2803,7 +2805,7 @@ retry:
 		 * and enqueue_huge_page() for new_page. The counters will remain
 		 * stable since this happens under the lock.
 		 */
-		remove_hugetlb_page(h, old_page, false);
+		remove_hugetlb_folio(h, old_folio, false);
 
 		/*
 		 * Ref count on new page is already zero as it was dropped
@@ -3230,7 +3232,7 @@ static void try_to_free_low(struct hstat
 				goto out;
 			if (PageHighMem(page))
 				continue;
-			remove_hugetlb_page(h, page, false);
+			remove_hugetlb_folio(h, page_folio(page), false);
 			list_add(&page->lru, &page_list);
 		}
 	}
@@ -3441,7 +3443,7 @@ static int demote_free_huge_page(struct
 
 	target_hstate = size_to_hstate(PAGE_SIZE << h->demote_order);
 
-	remove_hugetlb_page_for_demote(h, page, false);
+	remove_hugetlb_folio_for_demote(h, folio, false);
 	spin_unlock_irq(&hugetlb_lock);
 
 	rc = hugetlb_vmemmap_restore(h, page);
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


