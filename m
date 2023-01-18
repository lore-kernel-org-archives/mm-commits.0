Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72F68C32793
	for <mm-commits@archiver.kernel.org>; Wed, 18 Jan 2023 21:04:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjARVEu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 16:04:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjARVEt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 16:04:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9A2552B7
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 13:04:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B412B81F0B
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 21:04:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE1FC433EF;
        Wed, 18 Jan 2023 21:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674075885;
        bh=bkpNU7nYAb99D7XtYATPBOQgnzb7/zNwqF2iOZCPokg=;
        h=Date:To:From:Subject:From;
        b=PPzGwLpEwUKRqEbN1o5zlu2+ZTbt7W32gaFFCCRuRrDHnjVcwDe02/NyuIpGlWpzt
         KD8ar7E6oJvidobKDuxI8KsXfkG4n2BYAYenm32rF7/cfldINGbbiwpfLnl2spLctV
         5KN3oyFCw3SwhKnbi7RJtBJFyCXVlCkundMyADUs=
Date:   Wed, 18 Jan 2023 13:04:44 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, naoya.horiguchi@nec.com,
        mike.kravetz@oracle.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-get_hwpoison_huge_page-to-folios.patch added to mm-unstable branch
Message-Id: <20230118210445.BFE1FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: convert get_hwpoison_huge_page() to folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-get_hwpoison_huge_page-to-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-get_hwpoison_huge_page-to-folios.patch

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
Subject: mm/hugetlb: convert get_hwpoison_huge_page() to folios
Date: Wed, 18 Jan 2023 09:40:39 -0800

Straightforward conversion of get_hwpoison_huge_page() to
get_hwpoison_hugetlb_folio().  Reduces two references to a head page in
memory-failure.c

Link: https://lkml.kernel.org/r/20230118174039.14247-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 +-
 mm/hugetlb.c            |   10 +++++-----
 mm/memory-failure.c     |   22 +++++++++++-----------
 3 files changed, 17 insertions(+), 17 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-convert-get_hwpoison_huge_page-to-folios
+++ a/include/linux/hugetlb.h
@@ -171,7 +171,7 @@ bool hugetlb_reserve_pages(struct inode
 long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
 						long freed);
 int isolate_hugetlb(struct folio *folio, struct list_head *list);
-int get_hwpoison_huge_page(struct page *page, bool *hugetlb, bool unpoison);
+int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison);
 int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
 				bool *migratable_cleared);
 void putback_active_hugepage(struct page *page);
--- a/mm/hugetlb.c~mm-hugetlb-convert-get_hwpoison_huge_page-to-folios
+++ a/mm/hugetlb.c
@@ -7272,18 +7272,18 @@ unlock:
 	return ret;
 }
 
-int get_hwpoison_huge_page(struct page *page, bool *hugetlb, bool unpoison)
+int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison)
 {
 	int ret = 0;
 
 	*hugetlb = false;
 	spin_lock_irq(&hugetlb_lock);
-	if (PageHeadHuge(page)) {
+	if (folio_test_hugetlb(folio)) {
 		*hugetlb = true;
-		if (HPageFreed(page))
+		if (folio_test_hugetlb_freed(folio))
 			ret = 0;
-		else if (HPageMigratable(page) || unpoison)
-			ret = get_page_unless_zero(page);
+		else if (folio_test_hugetlb_migratable(folio) || unpoison)
+			ret = folio_try_get(folio);
 		else
 			ret = -EBUSY;
 	}
--- a/mm/memory-failure.c~mm-hugetlb-convert-get_hwpoison_huge_page-to-folios
+++ a/mm/memory-failure.c
@@ -1328,28 +1328,28 @@ static inline bool HWPoisonHandlable(str
 
 static int __get_hwpoison_page(struct page *page, unsigned long flags)
 {
-	struct page *head = compound_head(page);
+	struct folio *folio = page_folio(page);
 	int ret = 0;
 	bool hugetlb = false;
 
-	ret = get_hwpoison_huge_page(head, &hugetlb, false);
+	ret = get_hwpoison_hugetlb_folio(folio, &hugetlb, false);
 	if (hugetlb)
 		return ret;
 
 	/*
-	 * This check prevents from calling get_page_unless_zero() for any
-	 * unsupported type of page in order to reduce the risk of unexpected
-	 * races caused by taking a page refcount.
+	 * This check prevents from calling folio_try_get() for any
+	 * unsupported type of folio in order to reduce the risk of unexpected
+	 * races caused by taking a folio refcount.
 	 */
-	if (!HWPoisonHandlable(head, flags))
+	if (!HWPoisonHandlable(&folio->page, flags))
 		return -EBUSY;
 
-	if (get_page_unless_zero(head)) {
-		if (head == compound_head(page))
+	if (folio_try_get(folio)) {
+		if (folio == page_folio(page))
 			return 1;
 
 		pr_info("%#lx cannot catch tail\n", page_to_pfn(page));
-		put_page(head);
+		folio_put(folio);
 	}
 
 	return 0;
@@ -1418,11 +1418,11 @@ out:
 
 static int __get_unpoison_page(struct page *page)
 {
-	struct page *head = compound_head(page);
+	struct folio *folio = page_folio(page);
 	int ret = 0;
 	bool hugetlb = false;
 
-	ret = get_hwpoison_huge_page(head, &hugetlb, true);
+	ret = get_hwpoison_hugetlb_folio(folio, &hugetlb, true);
 	if (hugetlb)
 		return ret;
 
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
mm-hugetlb-convert-get_hwpoison_huge_page-to-folios.patch

