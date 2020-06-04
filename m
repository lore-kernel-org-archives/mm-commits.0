From: akpm@linux-foundation.org
Subject: [merged]
 mm-remove-use-once-cache-bias-from-lru-balancing.patch removed from -mm
 tree
Date: Thu, 04 Jun 2020 10:20:51 -0700
Message-ID: <20200604172051.KSCzKV-VU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730072AbgFDRUw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:20:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@surriel.com


The patch titled
     Subject: mm: remove use-once cache bias from LRU balancing
has been removed from the -mm tree.  Its filename was
     mm-remove-use-once-cache-bias-from-lru-balancing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: remove use-once cache bias from LRU balancing

When the splitlru patches divided page cache and swap-backed pages into
separate LRU lists, the pressure balance between the lists was biased to
account for the fact that streaming IO can cause memory pressure with a
flood of pages that are used only once.  New page cache additions would
tip the balance toward the file LRU, and repeat access would neutralize
that bias again.  This ensured that page reclaim would always go for
used-once cache first.

Since e9868505987a ("mm,vmscan: only evict file pages when we have
plenty"), page reclaim generally skips over swap-backed memory entirely as
long as there is used-once cache present, and will apply the LRU balancing
when only repeatedly accessed cache pages are left - at which point the
previous use-once bias will have been neutralized.  This makes the
use-once cache balancing bias unnecessary.

Link: http://lkml.kernel.org/r/20200520232525.798933-7-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/mm/swap.c~mm-remove-use-once-cache-bias-from-lru-balancing
+++ a/mm/swap.c
@@ -293,7 +293,6 @@ static void __activate_page(struct page
 			    void *arg)
 {
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
-		int file = page_is_file_lru(page);
 		int lru = page_lru_base_type(page);
 
 		del_page_from_lru_list(page, lruvec, lru);
@@ -303,7 +302,6 @@ static void __activate_page(struct page
 		trace_mm_lru_activate(page);
 
 		__count_vm_event(PGACTIVATE);
-		update_page_reclaim_stat(lruvec, file, 1, hpage_nr_pages(page));
 	}
 }
 
@@ -975,9 +973,6 @@ static void __pagevec_lru_add_fn(struct
 
 	if (page_evictable(page)) {
 		lru = page_lru(page);
-		update_page_reclaim_stat(lruvec, is_file_lru(lru),
-					 PageActive(page),
-					 hpage_nr_pages(page));
 		if (was_unevictable)
 			count_vm_event(UNEVICTABLE_PGRESCUED);
 	} else {
_

Patches currently in -mm which might be from hannes@cmpxchg.org are
