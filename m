Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31D4EC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 17 Nov 2022 21:25:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240812AbiKQVZp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Nov 2022 16:25:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240884AbiKQVZW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2022 16:25:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B9E2F20
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2022 13:23:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9972B82208
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2022 21:23:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF4FC433D6;
        Thu, 17 Nov 2022 21:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668720232;
        bh=f8OKBKOM4bofyD98cJhPKL9CQEzDthOHgYJ30vihK1I=;
        h=Date:To:From:Subject:From;
        b=L2+s42qbJcXPQqxCuGbugDrlmOsvr7N4Jpl6Ru75Wmlov+X39RhWfXJMWqW65gdnV
         JuGm1D7lAoXhcN/Nxj1daubNGKEh6gmeNSt+bJmRBLQxjLQ0akv7CbGcfFV+6ZOJ2i
         oVihkA9JfqffZtfUMTUyNthwI8JXF181wqezf+jk=
Date:   Thu, 17 Nov 2022 13:23:51 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, hughd@google.com, almasrymina@google.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-remove_hugetlb_page-to-folios.patch added to mm-unstable branch
Message-Id: <20221117212352.5FF4FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: convert remove_hugetlb_page() to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-remove_hugetlb_page-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-remove_hugetlb_page-to-folios.patch

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
Subject: mm/hugetlb: convert remove_hugetlb_page() to folios
Date: Thu, 17 Nov 2022 13:14:55 -0800

Remove page_folio() call by converting callers to directly pass a folio
into __remove_hugetlb_page().

Link: https://lkml.kernel.org/r/20221117211501.17150-5-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
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
@@ -2090,6 +2090,7 @@ static struct page *remove_pool_huge_pag
 {
 	int nr_nodes, node;
 	struct page *page = NULL;
+	struct folio *folio;
 
 	lockdep_assert_held(&hugetlb_lock);
 	for_each_node_mask_to_free(h, nr_nodes, node, nodes_allowed) {
@@ -2101,7 +2102,8 @@ static struct page *remove_pool_huge_pag
 		    !list_empty(&h->hugepage_freelists[node])) {
 			page = list_entry(h->hugepage_freelists[node].next,
 					  struct page, lru);
-			remove_hugetlb_page(h, page, acct_surplus);
+			folio = page_folio(page);
+			remove_hugetlb_folio(h, folio, acct_surplus);
 			break;
 		}
 	}
@@ -2163,7 +2165,7 @@ retry:
 			goto retry;
 		}
 
-		remove_hugetlb_page(h, &folio->page, false);
+		remove_hugetlb_folio(h, folio, false);
 		h->max_huge_pages--;
 		spin_unlock_irq(&hugetlb_lock);
 
@@ -2801,7 +2803,7 @@ retry:
 		 * and enqueue_huge_page() for new_page. The counters will remain
 		 * stable since this happens under the lock.
 		 */
-		remove_hugetlb_page(h, old_page, false);
+		remove_hugetlb_folio(h, old_folio, false);
 
 		/*
 		 * Ref count on new page is already zero as it was dropped
@@ -3228,7 +3230,7 @@ static void try_to_free_low(struct hstat
 				goto out;
 			if (PageHighMem(page))
 				continue;
-			remove_hugetlb_page(h, page, false);
+			remove_hugetlb_folio(h, page_folio(page), false);
 			list_add(&page->lru, &page_list);
 		}
 	}
@@ -3439,7 +3441,7 @@ static int demote_free_huge_page(struct
 
 	target_hstate = size_to_hstate(PAGE_SIZE << h->demote_order);
 
-	remove_hugetlb_page_for_demote(h, page, false);
+	remove_hugetlb_folio_for_demote(h, folio, false);
 	spin_unlock_irq(&hugetlb_lock);
 
 	rc = hugetlb_vmemmap_restore(h, page);
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

