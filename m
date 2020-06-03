From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 117/131] mm: swap: fix vmstats for huge pages
Date: Wed, 03 Jun 2020 16:03:16 -0700
Message-ID: <20200603230316.bjn_Vzl_h%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726512AbgFCXIj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 19:08:39 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, shakeelb@google.com, torvalds@linux-foundation.org

From: Shakeel Butt <shakeelb@google.com>
Subject: mm: swap: fix vmstats for huge pages

Many of the callbacks called by pagevec_lru_move_fn() does not correctly
update the vmstats for huge pages. Fix that. Also __pagevec_lru_add_fn()
use the irq-unsafe alternative to update the stat as the irqs are
already disabled.

Link: http://lkml.kernel.org/r/20200527182916.249910-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/mm/swap.c~mm-swap-fix-vmstats-for-huge-pages
+++ a/mm/swap.c
@@ -241,7 +241,7 @@ static void pagevec_move_tail_fn(struct
 		del_page_from_lru_list(page, lruvec, page_lru(page));
 		ClearPageActive(page);
 		add_page_to_lru_list_tail(page, lruvec, page_lru(page));
-		(*pgmoved)++;
+		(*pgmoved) += hpage_nr_pages(page);
 	}
 }
 
@@ -327,7 +327,7 @@ static void __activate_page(struct page
 		add_page_to_lru_list(page, lruvec, lru);
 		trace_mm_lru_activate(page);
 
-		__count_vm_event(PGACTIVATE);
+		__count_vm_events(PGACTIVATE, hpage_nr_pages(page));
 	}
 }
 
@@ -529,6 +529,7 @@ static void lru_deactivate_file_fn(struc
 {
 	int lru;
 	bool active;
+	int nr_pages = hpage_nr_pages(page);
 
 	if (!PageLRU(page))
 		return;
@@ -561,11 +562,11 @@ static void lru_deactivate_file_fn(struc
 		 * We moves tha page into tail of inactive.
 		 */
 		add_page_to_lru_list_tail(page, lruvec, lru);
-		__count_vm_event(PGROTATED);
+		__count_vm_events(PGROTATED, nr_pages);
 	}
 
 	if (active)
-		__count_vm_event(PGDEACTIVATE);
+		__count_vm_events(PGDEACTIVATE, nr_pages);
 }
 
 static void lru_deactivate_fn(struct page *page, struct lruvec *lruvec,
@@ -960,6 +961,7 @@ static void __pagevec_lru_add_fn(struct
 {
 	enum lru_list lru;
 	int was_unevictable = TestClearPageUnevictable(page);
+	int nr_pages = hpage_nr_pages(page);
 
 	VM_BUG_ON_PAGE(PageLRU(page), page);
 
@@ -995,13 +997,13 @@ static void __pagevec_lru_add_fn(struct
 	if (page_evictable(page)) {
 		lru = page_lru(page);
 		if (was_unevictable)
-			count_vm_event(UNEVICTABLE_PGRESCUED);
+			__count_vm_events(UNEVICTABLE_PGRESCUED, nr_pages);
 	} else {
 		lru = LRU_UNEVICTABLE;
 		ClearPageActive(page);
 		SetPageUnevictable(page);
 		if (!was_unevictable)
-			count_vm_event(UNEVICTABLE_PGCULLED);
+			__count_vm_events(UNEVICTABLE_PGCULLED, nr_pages);
 	}
 
 	add_page_to_lru_list(page, lruvec, lru);
_
