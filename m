Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C0B7C43381
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E30222D2C
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbhAXBWn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 23 Jan 2021 20:22:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:46998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbhAXBWn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 23 Jan 2021 20:22:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E175122D37;
        Sun, 24 Jan 2021 01:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611451322;
        bh=R2NcnHV0nDUzHki179Zz3IogXI+dZovCJoWRrOjD0k8=;
        h=Date:From:To:Subject:From;
        b=txKmKZTC+jcNXLw0SqJIihYBjzN2ZGvYyqHmZKoazU5Y2cHD9ysWpmL8sdQBJseZF
         VDiTTlCrsllqMEi6NejJj/+VCKKxIAIq3bs8I1DCFUG7rNadKTKvITIpDHgUeT0Da3
         DoQdG1SEC7oUeyQIEibVyM6+qHhCWe8kFvxmxjos=
Date:   Sat, 23 Jan 2021 17:22:01 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, guro@fb.com, hannes@cmpxchg.org,
        hughd@google.com, mhocko@kernel.org, mm-commits@vger.kernel.org,
        vbabka@suse.cz, vdavydov.dev@gmail.com, willy@infradead.org,
        yuzhao@google.com
Subject:  +
 mm-dont-pass-enum-lru_list-to-del_page_from_lru_list.patch added to -mm
 tree
Message-ID: <20210124012201.ZeKz2TNuZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap.c: don't pass "enum lru_list" to del_page_from_lru_list()
has been added to the -mm tree.  Its filename is
     mm-dont-pass-enum-lru_list-to-del_page_from_lru_list.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-dont-pass-enum-lru_list-to-del_page_from_lru_list.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-pass-enum-lru_list-to-del_page_from_lru_list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from yuzhao@google.com are

mm-swap-dont-setpageworkingset-unconditionally-during-swapin.patch
mm-use-add_page_to_lru_list.patch
mm-shuffle-lru-list-addition-and-deletion-functions.patch
mm-dont-pass-enum-lru_list-to-lru-list-addition-functions.patch
mm-dont-pass-enum-lru_list-to-trace_mm_lru_insertion.patch
mm-dont-pass-enum-lru_list-to-del_page_from_lru_list.patch
mm-add-__clear_page_lru_flags-to-replace-page_off_lru.patch
mm-vm_bug_on-lru-page-flags.patch
mm-fold-page_lru_base_type-into-its-sole-caller.patch
mm-fold-__update_lru_size-into-its-sole-caller.patch
mm-make-lruvec_lru_size-static.patch

