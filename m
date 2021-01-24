Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F905C433E6
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41C4D22D70
	for <mm-commits@archiver.kernel.org>; Sun, 24 Jan 2021 01:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbhAXBWm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 23 Jan 2021 20:22:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:46946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726412AbhAXBWg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 23 Jan 2021 20:22:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25E6422D2B;
        Sun, 24 Jan 2021 01:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611451314;
        bh=MJCHTwg56f6bVNVYydYrTfhmhhbf3FepRwBBA/bVkgs=;
        h=Date:From:To:Subject:From;
        b=C5HQM++Z/k4qvJNIk+FAQWvc74VIRrUG8yF/mkMqUwOeh3M2vkwJWkv2S4cWaORnf
         TVKwH7L53eMUxR3W9OsimHREPt551PQnv465lEEwX8Rfb25V+aaoKOSB7nbWXlVXct
         nRPqCnk91BupjxCUVJp63UoQx1siQX2dvoPNBDmo=
Date:   Sat, 23 Jan 2021 17:21:53 -0800
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, guro@fb.com, hannes@cmpxchg.org,
        hughd@google.com, mhocko@kernel.org, mm-commits@vger.kernel.org,
        vbabka@suse.cz, vdavydov.dev@gmail.com, willy@infradead.org,
        yuzhao@google.com
Subject:  +
 mm-dont-pass-enum-lru_list-to-lru-list-addition-functions.patch added to
 -mm tree
Message-ID: <20210124012153.4WldrXQpP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't pass "enum lru_list" to lru list addition functions
has been added to the -mm tree.  Its filename is
     mm-dont-pass-enum-lru_list-to-lru-list-addition-functions.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-dont-pass-enum-lru_list-to-lru-list-addition-functions.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-pass-enum-lru_list-to-lru-list-addition-functions.patch

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
Subject: mm: don't pass "enum lru_list" to lru list addition functions

The "enum lru_list" parameter to add_page_to_lru_list() and
add_page_to_lru_list_tail() is redundant in the sense that it can
be extracted from the "struct page" parameter by page_lru().

A caveat is that we need to make sure PageActive() or
PageUnevictable() is correctly set or cleared before calling
these two functions. And they are indeed.

Link: https://lore.kernel.org/linux-mm/20201207220949.830352-4-yuzhao@google.com/
Link: https://lkml.kernel.org/r/20210122220600.906146-4-yuzhao@google.com
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

 include/linux/mm_inline.h |    8 ++++++--
 mm/swap.c                 |   15 +++++++--------
 mm/vmscan.c               |    6 ++----
 3 files changed, 15 insertions(+), 14 deletions(-)

--- a/include/linux/mm_inline.h~mm-dont-pass-enum-lru_list-to-lru-list-addition-functions
+++ a/include/linux/mm_inline.h
@@ -106,15 +106,19 @@ static __always_inline enum lru_list pag
 }
 
 static __always_inline void add_page_to_lru_list(struct page *page,
-				struct lruvec *lruvec, enum lru_list lru)
+				struct lruvec *lruvec)
 {
+	enum lru_list lru = page_lru(page);
+
 	update_lru_size(lruvec, lru, page_zonenum(page), thp_nr_pages(page));
 	list_add(&page->lru, &lruvec->lists[lru]);
 }
 
 static __always_inline void add_page_to_lru_list_tail(struct page *page,
-				struct lruvec *lruvec, enum lru_list lru)
+				struct lruvec *lruvec)
 {
+	enum lru_list lru = page_lru(page);
+
 	update_lru_size(lruvec, lru, page_zonenum(page), thp_nr_pages(page));
 	list_add_tail(&page->lru, &lruvec->lists[lru]);
 }
--- a/mm/swap.c~mm-dont-pass-enum-lru_list-to-lru-list-addition-functions
+++ a/mm/swap.c
@@ -231,7 +231,7 @@ static void pagevec_move_tail_fn(struct
 	if (!PageUnevictable(page)) {
 		del_page_from_lru_list(page, lruvec, page_lru(page));
 		ClearPageActive(page);
-		add_page_to_lru_list_tail(page, lruvec, page_lru(page));
+		add_page_to_lru_list_tail(page, lruvec);
 		__count_vm_events(PGROTATED, thp_nr_pages(page));
 	}
 }
@@ -313,8 +313,7 @@ static void __activate_page(struct page
 
 		del_page_from_lru_list(page, lruvec, lru);
 		SetPageActive(page);
-		lru += LRU_ACTIVE;
-		add_page_to_lru_list(page, lruvec, lru);
+		add_page_to_lru_list(page, lruvec);
 		trace_mm_lru_activate(page);
 
 		__count_vm_events(PGACTIVATE, nr_pages);
@@ -543,14 +542,14 @@ static void lru_deactivate_file_fn(struc
 		 * It can make readahead confusing.  But race window
 		 * is _really_ small and  it's non-critical problem.
 		 */
-		add_page_to_lru_list(page, lruvec, lru);
+		add_page_to_lru_list(page, lruvec);
 		SetPageReclaim(page);
 	} else {
 		/*
 		 * The page's writeback ends up during pagevec
 		 * We moves tha page into tail of inactive.
 		 */
-		add_page_to_lru_list_tail(page, lruvec, lru);
+		add_page_to_lru_list_tail(page, lruvec);
 		__count_vm_events(PGROTATED, nr_pages);
 	}
 
@@ -570,7 +569,7 @@ static void lru_deactivate_fn(struct pag
 		del_page_from_lru_list(page, lruvec, lru + LRU_ACTIVE);
 		ClearPageActive(page);
 		ClearPageReferenced(page);
-		add_page_to_lru_list(page, lruvec, lru);
+		add_page_to_lru_list(page, lruvec);
 
 		__count_vm_events(PGDEACTIVATE, nr_pages);
 		__count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE,
@@ -595,7 +594,7 @@ static void lru_lazyfree_fn(struct page
 		 * anonymous pages
 		 */
 		ClearPageSwapBacked(page);
-		add_page_to_lru_list(page, lruvec, LRU_INACTIVE_FILE);
+		add_page_to_lru_list(page, lruvec);
 
 		__count_vm_events(PGLAZYFREE, nr_pages);
 		__count_memcg_events(lruvec_memcg(lruvec), PGLAZYFREE,
@@ -1005,7 +1004,7 @@ static void __pagevec_lru_add_fn(struct
 			__count_vm_events(UNEVICTABLE_PGCULLED, nr_pages);
 	}
 
-	add_page_to_lru_list(page, lruvec, lru);
+	add_page_to_lru_list(page, lruvec);
 	trace_mm_lru_insertion(page, lru);
 }
 
--- a/mm/vmscan.c~mm-dont-pass-enum-lru_list-to-lru-list-addition-functions
+++ a/mm/vmscan.c
@@ -1867,7 +1867,7 @@ static unsigned noinline_for_stack move_
 		 * inhibits memcg migration).
 		 */
 		VM_BUG_ON_PAGE(!lruvec_holds_page_lru_lock(page, lruvec), page);
-		add_page_to_lru_list(page, lruvec, page_lru(page));
+		add_page_to_lru_list(page, lruvec);
 		nr_pages = thp_nr_pages(page);
 		nr_moved += nr_pages;
 		if (PageActive(page))
@@ -4282,12 +4282,10 @@ void check_move_unevictable_pages(struct
 
 		lruvec = relock_page_lruvec_irq(page, lruvec);
 		if (page_evictable(page) && PageUnevictable(page)) {
-			enum lru_list lru = page_lru_base_type(page);
-
 			VM_BUG_ON_PAGE(PageActive(page), page);
 			ClearPageUnevictable(page);
 			del_page_from_lru_list(page, lruvec, LRU_UNEVICTABLE);
-			add_page_to_lru_list(page, lruvec, lru);
+			add_page_to_lru_list(page, lruvec);
 			pgrescued += nr_pages;
 		}
 		SetPageLRU(page);
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

