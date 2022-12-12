Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09E93C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:16:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbiLLCQR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:16:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbiLLCOf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:14:35 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A9DDF0E
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:14:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D522BCE0CF9
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04DDBC433F0;
        Mon, 12 Dec 2022 02:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811260;
        bh=nQ+7JIQDGPnUIWa7u8SxL1PG+OJFv3nkMpWOFjytUw8=;
        h=Date:To:From:Subject:From;
        b=NbJv84q7/Spbgn60Q6+90YtBNCtP+iiQJPObjblsbkZESu1HpEXZvgSna4aZuC3SB
         hqe3mLoOSJg/r9jT4YsTMhWbIM1BAvCsmfgv676TWRbc2cPkjRRlNIcVsICBrxg9Pd
         D6HlOFk7k1RLlmSoSAfGNuOIzpsdBbR5Rqwz+BEY=
Date:   Sun, 11 Dec 2022 18:14:19 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tsahu@linux.ibm.com, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linux@rasmusvillemoes.dk,
        linmiaohe@huawei.com, jhubbard@nvidia.com,
        harperchen1110@gmail.com, david@redhat.com, almasrymina@google.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-convert-update_and_free_page-to-folios.patch removed from -mm tree
Message-Id: <20221212021420.04DDBC433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: convert update_and_free_page() to folios
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-convert-update_and_free_page-to-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/hugetlb: convert update_and_free_page() to folios
Date: Tue, 29 Nov 2022 14:50:34 -0800

Make more progress on converting the free_huge_page() destructor to
operate on folios by converting update_and_free_page() to folios.

Link: https://lkml.kernel.org/r/20221129225039.82257-6-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>\
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

 mm/hugetlb.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-convert-update_and_free_page-to-folios
+++ a/mm/hugetlb.c
@@ -1478,7 +1478,7 @@ static void __remove_hugetlb_folio(struc
 	 * apply.
 	 *
 	 * This handles the case where more than one ref is held when and
-	 * after update_and_free_page is called.
+	 * after update_and_free_hugetlb_folio is called.
 	 *
 	 * In the case of demote we do not ref count the page as it will soon
 	 * be turned into a page of smaller size.
@@ -1609,7 +1609,7 @@ static void __update_and_free_page(struc
 }
 
 /*
- * As update_and_free_page() can be called under any context, so we cannot
+ * As update_and_free_hugetlb_folio() can be called under any context, so we cannot
  * use GFP_KERNEL to allocate vmemmap pages. However, we can defer the
  * actual freeing in a workqueue to prevent from using GFP_ATOMIC to allocate
  * the vmemmap pages.
@@ -1657,11 +1657,11 @@ static inline void flush_free_hpage_work
 		flush_work(&free_hpage_work);
 }
 
-static void update_and_free_page(struct hstate *h, struct page *page,
+static void update_and_free_hugetlb_folio(struct hstate *h, struct folio *folio,
 				 bool atomic)
 {
-	if (!HPageVmemmapOptimized(page) || !atomic) {
-		__update_and_free_page(h, page);
+	if (!folio_test_hugetlb_vmemmap_optimized(folio) || !atomic) {
+		__update_and_free_page(h, &folio->page);
 		return;
 	}
 
@@ -1672,16 +1672,18 @@ static void update_and_free_page(struct
 	 * empty. Otherwise, schedule_work() had been called but the workfn
 	 * hasn't retrieved the list yet.
 	 */
-	if (llist_add((struct llist_node *)&page->mapping, &hpage_freelist))
+	if (llist_add((struct llist_node *)&folio->mapping, &hpage_freelist))
 		schedule_work(&free_hpage_work);
 }
 
 static void update_and_free_pages_bulk(struct hstate *h, struct list_head *list)
 {
 	struct page *page, *t_page;
+	struct folio *folio;
 
 	list_for_each_entry_safe(page, t_page, list, lru) {
-		update_and_free_page(h, page, false);
+		folio = page_folio(page);
+		update_and_free_hugetlb_folio(h, folio, false);
 		cond_resched();
 	}
 }
@@ -1751,12 +1753,12 @@ void free_huge_page(struct page *page)
 	if (folio_test_hugetlb_temporary(folio)) {
 		remove_hugetlb_folio(h, folio, false);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
-		update_and_free_page(h, page, true);
+		update_and_free_hugetlb_folio(h, folio, true);
 	} else if (h->surplus_huge_pages_node[nid]) {
 		/* remove the page from active list */
 		remove_hugetlb_folio(h, folio, true);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
-		update_and_free_page(h, page, true);
+		update_and_free_hugetlb_folio(h, folio, true);
 	} else {
 		arch_clear_hugepage_flags(page);
 		enqueue_huge_page(h, page);
@@ -2172,8 +2174,8 @@ retry:
 		spin_unlock_irq(&hugetlb_lock);
 
 		/*
-		 * Normally update_and_free_page will allocate required vmemmmap
-		 * before freeing the page.  update_and_free_page will fail to
+		 * Normally update_and_free_hugtlb_folio will allocate required vmemmmap
+		 * before freeing the page.  update_and_free_hugtlb_folio will fail to
 		 * free the page if it can not allocate required vmemmap.  We
 		 * need to adjust max_huge_pages if the page is not freed.
 		 * Attempt to allocate vmemmmap here so that we can take
@@ -2181,7 +2183,7 @@ retry:
 		 */
 		rc = hugetlb_vmemmap_restore(h, &folio->page);
 		if (!rc) {
-			update_and_free_page(h, &folio->page, false);
+			update_and_free_hugetlb_folio(h, folio, false);
 		} else {
 			spin_lock_irq(&hugetlb_lock);
 			add_hugetlb_page(h, &folio->page, false);
@@ -2818,7 +2820,7 @@ retry:
 		 * Pages have been replaced, we can safely free the old one.
 		 */
 		spin_unlock_irq(&hugetlb_lock);
-		update_and_free_page(h, old_page, false);
+		update_and_free_hugetlb_folio(h, old_folio, false);
 	}
 
 	return ret;
@@ -2827,7 +2829,7 @@ free_new:
 	spin_unlock_irq(&hugetlb_lock);
 	/* Page has a zero ref count, but needs a ref to be freed */
 	folio_ref_unfreeze(new_folio, 1);
-	update_and_free_page(h, new_page, false);
+	update_and_free_hugetlb_folio(h, new_folio, false);
 
 	return ret;
 }
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


