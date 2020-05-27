From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-fix-vmstats-for-huge-pages.patch added to -mm
 tree
Date: Wed, 27 May 2020 12:12:01 -0700
Message-ID: <20200527191201.NAEmkLhxZ%akpm@linux-foundation.org>
References: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725795AbgE0TMD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 May 2020 15:12:03 -0400
In-Reply-To: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, hannes@cmpxchg.org, mgorman@suse.de, mhocko@kernel.org, minchan@kernel.org, mm-commits@vger.kernel.org, riel@surriel.com, shakeelb@google.com


The patch titled
     Subject: mm: swap: fix vmstats for huge pages
has been added to the -mm tree.  Its filename is
     mm-swap-fix-vmstats-for-huge-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-fix-vmstats-for-huge-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-fix-vmstats-for-huge-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: mm: swap: fix vmstats for huge pages

Many of the callbacks called by pagevec_lru_move_fn() does not correctly
update the vmstats for huge pages.  Fix that.  Also __pagevec_lru_add_fn()
use the irq-unsafe alternative to update the stat as the irqs are already
disabled.

Link: http://lkml.kernel.org/r/20200527182916.249910-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/mm/swap.c~mm-swap-fix-vmstats-for-huge-pages
+++ a/mm/swap.c
@@ -225,7 +225,7 @@ static void pagevec_move_tail_fn(struct
 		del_page_from_lru_list(page, lruvec, page_lru(page));
 		ClearPageActive(page);
 		add_page_to_lru_list_tail(page, lruvec, page_lru(page));
-		(*pgmoved)++;
+		(*pgmoved) += hpage_nr_pages(page);
 	}
 }
 
@@ -285,7 +285,7 @@ static void __activate_page(struct page
 		add_page_to_lru_list(page, lruvec, lru);
 		trace_mm_lru_activate(page);
 
-		__count_vm_event(PGACTIVATE);
+		__count_vm_events(PGACTIVATE, hpage_nr_pages(page));
 		update_page_reclaim_stat(lruvec, file, 1);
 	}
 }
@@ -503,6 +503,7 @@ static void lru_deactivate_file_fn(struc
 {
 	int lru, file;
 	bool active;
+	int nr_pages = hpage_nr_pages(page);
 
 	if (!PageLRU(page))
 		return;
@@ -536,11 +537,11 @@ static void lru_deactivate_file_fn(struc
 		 * We moves tha page into tail of inactive.
 		 */
 		add_page_to_lru_list_tail(page, lruvec, lru);
-		__count_vm_event(PGROTATED);
+		__count_vm_events(PGROTATED, nr_pages);
 	}
 
 	if (active)
-		__count_vm_event(PGDEACTIVATE);
+		__count_vm_events(PGDEACTIVATE, nr_pages);
 	update_page_reclaim_stat(lruvec, file, 0);
 }
 
@@ -928,6 +929,7 @@ static void __pagevec_lru_add_fn(struct
 {
 	enum lru_list lru;
 	int was_unevictable = TestClearPageUnevictable(page);
+	int nr_pages = hpage_nr_pages(page);
 
 	VM_BUG_ON_PAGE(PageLRU(page), page);
 
@@ -965,13 +967,13 @@ static void __pagevec_lru_add_fn(struct
 		update_page_reclaim_stat(lruvec, page_is_file_lru(page),
 					 PageActive(page));
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

Patches currently in -mm which might be from shakeelb@google.com are

memcg-optimize-memorynuma_stat-like-memorystat.patch
mm-swap-fix-vmstats-for-huge-pages.patch
mm-swap-memcg-fix-memcg-stats-for-huge-pages.patch
memcg-expose-root-cgroups-memorystat.patch
