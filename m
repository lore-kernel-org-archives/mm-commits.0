Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 943FAC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:09:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5428164F26
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:09:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235152AbhBXUJT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:09:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:59446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235182AbhBXUIl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:08:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B902F64F0E;
        Wed, 24 Feb 2021 20:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197306;
        bh=Z1dPdMVUtCMcxzFTOSbKrbwASX4qh9o6g9mKPLE0Tw4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WXAhxOSgFWMjGsKQt+5aZvh0KcF71NuU7/YeOB4y0XNwxnFhP94VlQjd8MbZ7J8FC
         ATeKhdYIRqs3EnSsY1q7CQ4OLEDj8IxwCyn+2/DwpgCmK2Ba075wd6j76pZTKe1KXx
         MdY9/SGIWEWbUVLadNRIxjaSOZ8tq03/+aoE6dgk=
Date:   Wed, 24 Feb 2021 12:08:25 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com, guro@fb.com,
        hannes@cmpxchg.org, hughd@google.com, linux-mm@kvack.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        vdavydov.dev@gmail.com, willy@infradead.org, yuzhao@google.com
Subject:  [patch 139/173] mm/swap.c: don't pass "enum lru_list" to
 del_page_from_lru_list()
Message-ID: <20210224200825._eP-FQyg3%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yu Zhao <yuzhao@google.com>
Subject: mm/swap.c: don't pass "enum lru_list" to del_page_from_lru_list()

The parameter is redundant in the sense that it can be potentially
extracted from the "struct page" parameter by page_lru(). We need to
make sure that existing PageActive() or PageUnevictable() remains
until the function returns. A few places don't conform, and simple
reordering fixes them.

This patch may have left page_off_lru() seemingly odd, and we'll take
care of it in the next patch.

Link: https://lore.kernel.org/linux-mm/20201207220949.830352-6-yuzhao@google.com/
Link: https://lkml.kernel.org/r/20210122220600.906146-6-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |    5 +++--
 mm/compaction.c           |    2 +-
 mm/mlock.c                |    3 +--
 mm/swap.c                 |   26 ++++++++++----------------
 mm/vmscan.c               |    4 ++--
 5 files changed, 17 insertions(+), 23 deletions(-)

--- a/include/linux/mm_inline.h~mm-dont-pass-enum-lru_list-to-del_page_from_lru_list
+++ a/include/linux/mm_inline.h
@@ -124,9 +124,10 @@ static __always_inline void add_page_to_
 }
 
 static __always_inline void del_page_from_lru_list(struct page *page,
-				struct lruvec *lruvec, enum lru_list lru)
+				struct lruvec *lruvec)
 {
 	list_del(&page->lru);
-	update_lru_size(lruvec, lru, page_zonenum(page), -thp_nr_pages(page));
+	update_lru_size(lruvec, page_lru(page), page_zonenum(page),
+			-thp_nr_pages(page));
 }
 #endif
--- a/mm/compaction.c~mm-dont-pass-enum-lru_list-to-del_page_from_lru_list
+++ a/mm/compaction.c
@@ -1034,7 +1034,7 @@ isolate_migratepages_block(struct compac
 			low_pfn += compound_nr(page) - 1;
 
 		/* Successfully isolated */
-		del_page_from_lru_list(page, lruvec, page_lru(page));
+		del_page_from_lru_list(page, lruvec);
 		mod_node_page_state(page_pgdat(page),
 				NR_ISOLATED_ANON + page_is_file_lru(page),
 				thp_nr_pages(page));
--- a/mm/mlock.c~mm-dont-pass-enum-lru_list-to-del_page_from_lru_list
+++ a/mm/mlock.c
@@ -278,8 +278,7 @@ static void __munlock_pagevec(struct pag
 			 */
 			if (TestClearPageLRU(page)) {
 				lruvec = relock_page_lruvec_irq(page, lruvec);
-				del_page_from_lru_list(page, lruvec,
-							page_lru(page));
+				del_page_from_lru_list(page, lruvec);
 				continue;
 			} else
 				__munlock_isolation_failed(page);
--- a/mm/swap.c~mm-dont-pass-enum-lru_list-to-del_page_from_lru_list
+++ a/mm/swap.c
@@ -85,7 +85,8 @@ static void __page_cache_release(struct
 		lruvec = lock_page_lruvec_irqsave(page, &flags);
 		VM_BUG_ON_PAGE(!PageLRU(page), page);
 		__ClearPageLRU(page);
-		del_page_from_lru_list(page, lruvec, page_off_lru(page));
+		del_page_from_lru_list(page, lruvec);
+		page_off_lru(page);
 		unlock_page_lruvec_irqrestore(lruvec, flags);
 	}
 	__ClearPageWaiters(page);
@@ -229,7 +230,7 @@ static void pagevec_lru_move_fn(struct p
 static void pagevec_move_tail_fn(struct page *page, struct lruvec *lruvec)
 {
 	if (!PageUnevictable(page)) {
-		del_page_from_lru_list(page, lruvec, page_lru(page));
+		del_page_from_lru_list(page, lruvec);
 		ClearPageActive(page);
 		add_page_to_lru_list_tail(page, lruvec);
 		__count_vm_events(PGROTATED, thp_nr_pages(page));
@@ -308,10 +309,9 @@ void lru_note_cost_page(struct page *pag
 static void __activate_page(struct page *page, struct lruvec *lruvec)
 {
 	if (!PageActive(page) && !PageUnevictable(page)) {
-		int lru = page_lru_base_type(page);
 		int nr_pages = thp_nr_pages(page);
 
-		del_page_from_lru_list(page, lruvec, lru);
+		del_page_from_lru_list(page, lruvec);
 		SetPageActive(page);
 		add_page_to_lru_list(page, lruvec);
 		trace_mm_lru_activate(page);
@@ -518,8 +518,7 @@ void lru_cache_add_inactive_or_unevictab
  */
 static void lru_deactivate_file_fn(struct page *page, struct lruvec *lruvec)
 {
-	int lru;
-	bool active;
+	bool active = PageActive(page);
 	int nr_pages = thp_nr_pages(page);
 
 	if (PageUnevictable(page))
@@ -529,10 +528,7 @@ static void lru_deactivate_file_fn(struc
 	if (page_mapped(page))
 		return;
 
-	active = PageActive(page);
-	lru = page_lru_base_type(page);
-
-	del_page_from_lru_list(page, lruvec, lru + active);
+	del_page_from_lru_list(page, lruvec);
 	ClearPageActive(page);
 	ClearPageReferenced(page);
 
@@ -563,10 +559,9 @@ static void lru_deactivate_file_fn(struc
 static void lru_deactivate_fn(struct page *page, struct lruvec *lruvec)
 {
 	if (PageActive(page) && !PageUnevictable(page)) {
-		int lru = page_lru_base_type(page);
 		int nr_pages = thp_nr_pages(page);
 
-		del_page_from_lru_list(page, lruvec, lru + LRU_ACTIVE);
+		del_page_from_lru_list(page, lruvec);
 		ClearPageActive(page);
 		ClearPageReferenced(page);
 		add_page_to_lru_list(page, lruvec);
@@ -581,11 +576,9 @@ static void lru_lazyfree_fn(struct page
 {
 	if (PageAnon(page) && PageSwapBacked(page) &&
 	    !PageSwapCache(page) && !PageUnevictable(page)) {
-		bool active = PageActive(page);
 		int nr_pages = thp_nr_pages(page);
 
-		del_page_from_lru_list(page, lruvec,
-				       LRU_INACTIVE_ANON + active);
+		del_page_from_lru_list(page, lruvec);
 		ClearPageActive(page);
 		ClearPageReferenced(page);
 		/*
@@ -919,7 +912,8 @@ void release_pages(struct page **pages,
 
 			VM_BUG_ON_PAGE(!PageLRU(page), page);
 			__ClearPageLRU(page);
-			del_page_from_lru_list(page, lruvec, page_off_lru(page));
+			del_page_from_lru_list(page, lruvec);
+			page_off_lru(page);
 		}
 
 		__ClearPageWaiters(page);
--- a/mm/vmscan.c~mm-dont-pass-enum-lru_list-to-del_page_from_lru_list
+++ a/mm/vmscan.c
@@ -1766,7 +1766,7 @@ int isolate_lru_page(struct page *page)
 
 		get_page(page);
 		lruvec = lock_page_lruvec_irq(page);
-		del_page_from_lru_list(page, lruvec, page_lru(page));
+		del_page_from_lru_list(page, lruvec);
 		unlock_page_lruvec_irq(lruvec);
 		ret = 0;
 	}
@@ -4283,8 +4283,8 @@ void check_move_unevictable_pages(struct
 		lruvec = relock_page_lruvec_irq(page, lruvec);
 		if (page_evictable(page) && PageUnevictable(page)) {
 			VM_BUG_ON_PAGE(PageActive(page), page);
+			del_page_from_lru_list(page, lruvec);
 			ClearPageUnevictable(page);
-			del_page_from_lru_list(page, lruvec, LRU_UNEVICTABLE);
 			add_page_to_lru_list(page, lruvec);
 			pgrescued += nr_pages;
 		}
_
