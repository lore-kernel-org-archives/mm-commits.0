Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26D66C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 09:16:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C679221548
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 09:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602580563;
	bh=EBrVr/CSZ5V8ByWEOd9R4lblDLKoLncvLzZG2h+d52g=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=piNP/59eCuwJLzoV295VEQxsv0phYgorBwALeVdIlHeW1nVOJKL38nuehfy2nilAd
	 o/Eush++neAMMAqRh2fGhIdZmzcOkjvhxOvxeBJXOUkjSYxVsmywOUpeff3rSO5IJw
	 VWHwX3ytkjRpqMj9wDj3r4cneoDYOp3h2YfQlo7A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404242AbgJMJQD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 05:16:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404241AbgJMJQD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 05:16:03 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEFE9208D5;
        Tue, 13 Oct 2020 09:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602580562;
        bh=EBrVr/CSZ5V8ByWEOd9R4lblDLKoLncvLzZG2h+d52g=;
        h=Date:From:To:Subject:From;
        b=RxR/Vnk/4PtJBdGSHkfzN/V0zh56drtQ4DZwIZ65CXrZOi7PanzF5pc8ZZ/VY0C5/
         YyTl07Z4l86O/LzfaB3EMgOI8rYCMPQxtvzkV66dsQCg6oGCdQ4wFlAs6zkav9sBEk
         VCVaoSZsrW0U7+I1QNJdiuLBf9HBh+VYKtc6FryM=
Date:   Tue, 13 Oct 2020 02:16:01 -0700
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, hughd@google.com,
        mm-commits@vger.kernel.org, yuzhao@google.com
Subject:  [to-be-updated]
 mm-use-add_page_to_lru_list-page_lru-page_off_lru.patch removed from -mm
 tree
Message-ID: <20201013091601.LkNtR-zUT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use add_page_to_lru_list()/page_lru()/page_off_lru()
has been removed from the -mm tree.  Its filename was
     mm-use-add_page_to_lru_list-page_lru-page_off_lru.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm: use add_page_to_lru_list()/page_lru()/page_off_lru()

This is a trivial but worth having clean-up patch.  There should be no
side effects except page->lru is temporarily poisoned after it's deleted
but before it's added to the new list in move_pages_to_lru() (which is not
a problem).

Link: http://lkml.kernel.org/r/20200831175042.3527153-1-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c   |    4 +---
 mm/vmscan.c |   13 ++++---------
 2 files changed, 5 insertions(+), 12 deletions(-)

--- a/mm/swap.c~mm-use-add_page_to_lru_list-page_lru-page_off_lru
+++ a/mm/swap.c
@@ -596,11 +596,9 @@ static void lru_lazyfree_fn(struct page
 {
 	if (PageLRU(page) && PageAnon(page) && PageSwapBacked(page) &&
 	    !PageSwapCache(page) && !PageUnevictable(page)) {
-		bool active = PageActive(page);
 		int nr_pages = thp_nr_pages(page);
 
-		del_page_from_lru_list(page, lruvec,
-				       LRU_INACTIVE_ANON + active);
+		del_page_from_lru_list(page, lruvec, page_lru(page));
 		ClearPageActive(page);
 		ClearPageReferenced(page);
 		/*
--- a/mm/vmscan.c~mm-use-add_page_to_lru_list-page_lru-page_off_lru
+++ a/mm/vmscan.c
@@ -1847,13 +1847,12 @@ static unsigned noinline_for_stack move_
 	int nr_pages, nr_moved = 0;
 	LIST_HEAD(pages_to_free);
 	struct page *page;
-	enum lru_list lru;
 
 	while (!list_empty(list)) {
 		page = lru_to_page(list);
 		VM_BUG_ON_PAGE(PageLRU(page), page);
+		list_del(&page->lru);
 		if (unlikely(!page_evictable(page))) {
-			list_del(&page->lru);
 			spin_unlock_irq(&pgdat->lru_lock);
 			putback_lru_page(page);
 			spin_lock_irq(&pgdat->lru_lock);
@@ -1862,16 +1861,11 @@ static unsigned noinline_for_stack move_
 		lruvec = mem_cgroup_page_lruvec(page, pgdat);
 
 		SetPageLRU(page);
-		lru = page_lru(page);
-
-		nr_pages = thp_nr_pages(page);
-		update_lru_size(lruvec, lru, page_zonenum(page), nr_pages);
-		list_move(&page->lru, &lruvec->lists[lru]);
+		add_page_to_lru_list(page, lruvec, page_lru(page));
 
 		if (put_page_testzero(page)) {
 			__ClearPageLRU(page);
-			__ClearPageActive(page);
-			del_page_from_lru_list(page, lruvec, lru);
+			del_page_from_lru_list(page, lruvec, page_off_lru(page));
 
 			if (unlikely(PageCompound(page))) {
 				spin_unlock_irq(&pgdat->lru_lock);
@@ -1880,6 +1874,7 @@ static unsigned noinline_for_stack move_
 			} else
 				list_add(&page->lru, &pages_to_free);
 		} else {
+			nr_pages = thp_nr_pages(page);
 			nr_moved += nr_pages;
 			if (PageActive(page))
 				workingset_age_nonresident(lruvec, nr_pages);
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-remove-activate_page-from-unuse_pte.patch
mm-remove-superfluous-__clearpageactive.patch
mm-use-self-explanatory-macros-rather-than-2.patch

