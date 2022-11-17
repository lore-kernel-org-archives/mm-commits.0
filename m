Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D8AAC4321E
	for <mm-commits@archiver.kernel.org>; Thu, 17 Nov 2022 21:25:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240838AbiKQVZq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Nov 2022 16:25:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240882AbiKQVZW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2022 16:25:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D2A1D65C
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2022 13:23:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE78E62277
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2022 21:23:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA48C433C1;
        Thu, 17 Nov 2022 21:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668720234;
        bh=L1bUKNA7Ekh99oGNx2LJxd3ms9NSA+rqc8akyR88Mng=;
        h=Date:To:From:Subject:From;
        b=zDWyHxlUvLTDHF2H/O+bGKm1qnER5GD0bM5dV/nqxQbLyRAg5vv/D+x3jzpASH69t
         Gqhfyw/YX24adh5Rk2U8lZmLExmEAIE2nwQfkJuXWjbLsJG8+WHw4KCh+pTX1SNWX+
         92YRX7JXoEbv8ZqH5rmAmS2zbPi+72De9ijIIRDU=
Date:   Thu, 17 Nov 2022 13:23:53 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, hughd@google.com, almasrymina@google.com,
        sidhartha.kumar@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-update_and_free_page-to-folios.patch added to mm-unstable branch
Message-Id: <20221117212354.3EA48C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: convert update_and_free_page() to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-update_and_free_page-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-update_and_free_page-to-folios.patch

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
Subject: mm/hugetlb: convert update_and_free_page() to folios
Date: Thu, 17 Nov 2022 13:14:56 -0800

Make more progress on converting the free_huge_page() destructor to
operate on folios by converting update_and_free_page() to folios.

Link: https://lkml.kernel.org/r/20221117211501.17150-6-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
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
@@ -2170,8 +2172,8 @@ retry:
 		spin_unlock_irq(&hugetlb_lock);
 
 		/*
-		 * Normally update_and_free_page will allocate required vmemmmap
-		 * before freeing the page.  update_and_free_page will fail to
+		 * Normally update_and_free_hugtlb_folio will allocate required vmemmmap
+		 * before freeing the page.  update_and_free_hugtlb_folio will fail to
 		 * free the page if it can not allocate required vmemmap.  We
 		 * need to adjust max_huge_pages if the page is not freed.
 		 * Attempt to allocate vmemmmap here so that we can take
@@ -2179,7 +2181,7 @@ retry:
 		 */
 		rc = hugetlb_vmemmap_restore(h, &folio->page);
 		if (!rc) {
-			update_and_free_page(h, &folio->page, false);
+			update_and_free_hugetlb_folio(h, folio, false);
 		} else {
 			spin_lock_irq(&hugetlb_lock);
 			add_hugetlb_page(h, &folio->page, false);
@@ -2816,7 +2818,7 @@ retry:
 		 * Pages have been replaced, we can safely free the old one.
 		 */
 		spin_unlock_irq(&hugetlb_lock);
-		update_and_free_page(h, old_page, false);
+		update_and_free_hugetlb_folio(h, old_folio, false);
 	}
 
 	return ret;
@@ -2825,7 +2827,7 @@ free_new:
 	spin_unlock_irq(&hugetlb_lock);
 	/* Page has a zero ref count, but needs a ref to be freed */
 	folio_ref_unfreeze(new_folio, 1);
-	update_and_free_page(h, new_page, false);
+	update_and_free_hugetlb_folio(h, new_folio, false);
 
 	return ret;
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

