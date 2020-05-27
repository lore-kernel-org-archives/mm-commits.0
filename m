From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-memcg-fix-memcg-stats-for-huge-pages.patch
 added to -mm tree
Date: Wed, 27 May 2020 12:12:04 -0700
Message-ID: <20200527191204.ingoxEKWk%akpm@linux-foundation.org>
References: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726770AbgE0TMG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 May 2020 15:12:06 -0400
In-Reply-To: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, hannes@cmpxchg.org, mgorman@suse.de, mhocko@kernel.org, minchan@kernel.org, mm-commits@vger.kernel.org, riel@surriel.com, shakeelb@google.com


The patch titled
     Subject: mm: swap: memcg: fix memcg stats for huge pages
has been added to the -mm tree.  Its filename is
     mm-swap-memcg-fix-memcg-stats-for-huge-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-memcg-fix-memcg-stats-for-huge-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-memcg-fix-memcg-stats-for-huge-pages.patch

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
Subject: mm: swap: memcg: fix memcg stats for huge pages

Commit 2262185c5b28 ("mm: per-cgroup memory reclaim stats") added
PGLAZYFREE, PGACTIVATE & PGDEACTIVATE stats for cgroups but missed couple
of places and PGLAZYFREE missed huge page handling.  Fix that.  Also for
PGLAZYFREE use the irq-unsafe function to update as the irq is already
disabled.

Link: http://lkml.kernel.org/r/20200527182947.251343-1-shakeelb@google.com
Fixes: 2262185c5b28 ("mm: per-cgroup memory reclaim stats")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/mm/swap.c~mm-swap-memcg-fix-memcg-stats-for-huge-pages
+++ a/mm/swap.c
@@ -278,6 +278,7 @@ static void __activate_page(struct page
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
 		int file = page_is_file_lru(page);
 		int lru = page_lru_base_type(page);
+		int nr_pages = hpage_nr_pages(page);
 
 		del_page_from_lru_list(page, lruvec, lru);
 		SetPageActive(page);
@@ -285,7 +286,8 @@ static void __activate_page(struct page
 		add_page_to_lru_list(page, lruvec, lru);
 		trace_mm_lru_activate(page);
 
-		__count_vm_events(PGACTIVATE, hpage_nr_pages(page));
+		__count_vm_events(PGACTIVATE, nr_pages);
+		__count_memcg_events(lruvec_memcg(lruvec), PGACTIVATE, nr_pages);
 		update_page_reclaim_stat(lruvec, file, 1);
 	}
 }
@@ -540,8 +542,10 @@ static void lru_deactivate_file_fn(struc
 		__count_vm_events(PGROTATED, nr_pages);
 	}
 
-	if (active)
+	if (active) {
 		__count_vm_events(PGDEACTIVATE, nr_pages);
+		__count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_pages);
+	}
 	update_page_reclaim_stat(lruvec, file, 0);
 }
 
@@ -551,13 +555,15 @@ static void lru_deactivate_fn(struct pag
 	if (PageLRU(page) && PageActive(page) && !PageUnevictable(page)) {
 		int file = page_is_file_lru(page);
 		int lru = page_lru_base_type(page);
+		int nr_pages = hpage_nr_pages(page);
 
 		del_page_from_lru_list(page, lruvec, lru + LRU_ACTIVE);
 		ClearPageActive(page);
 		ClearPageReferenced(page);
 		add_page_to_lru_list(page, lruvec, lru);
 
-		__count_vm_events(PGDEACTIVATE, hpage_nr_pages(page));
+		__count_vm_events(PGDEACTIVATE, nr_pages);
+		__count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_pages);
 		update_page_reclaim_stat(lruvec, file, 0);
 	}
 }
@@ -568,6 +574,7 @@ static void lru_lazyfree_fn(struct page
 	if (PageLRU(page) && PageAnon(page) && PageSwapBacked(page) &&
 	    !PageSwapCache(page) && !PageUnevictable(page)) {
 		bool active = PageActive(page);
+		int nr_pages = hpage_nr_pages(page);
 
 		del_page_from_lru_list(page, lruvec,
 				       LRU_INACTIVE_ANON + active);
@@ -581,8 +588,8 @@ static void lru_lazyfree_fn(struct page
 		ClearPageSwapBacked(page);
 		add_page_to_lru_list(page, lruvec, LRU_INACTIVE_FILE);
 
-		__count_vm_events(PGLAZYFREE, hpage_nr_pages(page));
-		count_memcg_page_event(page, PGLAZYFREE);
+		__count_vm_events(PGLAZYFREE, nr_pages);
+		__count_memcg_events(lruvec_memcg(lruvec), PGLAZYFREE, nr_pages);
 		update_page_reclaim_stat(lruvec, 1, 0);
 	}
 }
_

Patches currently in -mm which might be from shakeelb@google.com are

memcg-optimize-memorynuma_stat-like-memorystat.patch
mm-swap-fix-vmstats-for-huge-pages.patch
mm-swap-memcg-fix-memcg-stats-for-huge-pages.patch
memcg-expose-root-cgroups-memorystat.patch
