From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-reclaim-writepage-is-io-cost.patch added to
 -mm tree
Date: Wed, 20 May 2020 20:32:16 -0700
Message-ID: <20200521033216.jeNhNn8Jj%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728078AbgEUDcT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 May 2020 23:32:19 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com


The patch titled
     Subject: mm: vmscan: reclaim writepage is IO cost
has been added to the -mm tree.  Its filename is
     mm-vmscan-reclaim-writepage-is-io-cost.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-reclaim-writepage-is-io-cost.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-reclaim-writepage-is-io-cost.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmscan: reclaim writepage is IO cost

The VM tries to balance reclaim pressure between anon and file so as to
reduce the amount of IO incurred due to the memory shortage.  It already
counts refaults and swapins, but in addition it should also count
writepage calls during reclaim.

For swap, this is obvious: it's IO that wouldn't have occurred if the
anonymous memory hadn't been under memory pressure.  From a relative
balancing point of view this makes sense as well: even if anon is cold and
reclaimable, a cache that isn't thrashing may have equally cold pages that
don't require IO to reclaim.

For file writeback, it's trickier: some of the reclaim writepage IO would
have likely occurred anyway due to dirty expiration.  But not all of it -
premature writeback reduces batching and generates additional writes. 
Since the flushers are already woken up by the time the VM starts writing
cache pages one by one, let's assume that we'e likely causing writes that
wouldn't have happened without memory pressure.  In addition, the per-page
cost of IO would have probably been much cheaper if written in larger
batches from the flusher thread rather than the single-page-writes from
kswapd.

For our purposes - getting the trend right to accelerate convergence on a
stable state that doesn't require paging at all - this is sufficiently
accurate.  If we later wanted to optimize for sustained thrashing, we can
still refine the measurements.

Count all writepage calls from kswapd as IO cost toward the LRU that the
page belongs to.

Why do this dynamically?  Don't we know in advance that anon pages require
IO to reclaim, and so could build in a static bias?

First, scanning is not the same as reclaiming.  If all the anon pages are
referenced, we may not swap for a while just because we're scanning the
anon list.  During this time, however, it's important that we age
anonymous memory and the page cache at the same rate so that their
hot-cold gradients are comparable.  Everything else being equal, we still
want to reclaim the coldest memory overall.

Second, we keep copies in swap unless the page changes.  If there is
swap-backed data that's mostly read (tmpfs file) and has been swapped out
before, we can reclaim it without incurring additional IO.

Link: http://lkml.kernel.org/r/20200520232525.798933-14-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h   |    4 +++-
 include/linux/vmstat.h |    1 +
 mm/swap.c              |   16 ++++++++++------
 mm/swap_state.c        |    2 +-
 mm/vmscan.c            |    3 +++
 mm/workingset.c        |    2 +-
 6 files changed, 19 insertions(+), 9 deletions(-)

--- a/include/linux/swap.h~mm-vmscan-reclaim-writepage-is-io-cost
+++ a/include/linux/swap.h
@@ -334,7 +334,9 @@ extern unsigned long nr_free_pagecache_p
 
 
 /* linux/mm/swap.c */
-extern void lru_note_cost(struct page *);
+extern void lru_note_cost(struct lruvec *lruvec, bool file,
+			  unsigned int nr_pages);
+extern void lru_note_cost_page(struct page *);
 extern void lru_cache_add(struct page *);
 extern void lru_add_page_tail(struct page *page, struct page *page_tail,
 			 struct lruvec *lruvec, struct list_head *head);
--- a/include/linux/vmstat.h~mm-vmscan-reclaim-writepage-is-io-cost
+++ a/include/linux/vmstat.h
@@ -26,6 +26,7 @@ struct reclaim_stat {
 	unsigned nr_congested;
 	unsigned nr_writeback;
 	unsigned nr_immediate;
+	unsigned nr_pageout;
 	unsigned nr_activate[2];
 	unsigned nr_ref_keep;
 	unsigned nr_unmap_fail;
--- a/mm/swap.c~mm-vmscan-reclaim-writepage-is-io-cost
+++ a/mm/swap.c
@@ -262,18 +262,16 @@ void rotate_reclaimable_page(struct page
 	}
 }
 
-void lru_note_cost(struct page *page)
+void lru_note_cost(struct lruvec *lruvec, bool file, unsigned int nr_pages)
 {
-	struct lruvec *lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
-
 	do {
 		unsigned long lrusize;
 
 		/* Record cost event */
-		if (page_is_file_lru(page))
-			lruvec->file_cost++;
+		if (file)
+			lruvec->file_cost += nr_pages;
 		else
-			lruvec->anon_cost++;
+			lruvec->anon_cost += nr_pages;
 
 		/*
 		 * Decay previous events
@@ -295,6 +293,12 @@ void lru_note_cost(struct page *page)
 	} while ((lruvec = parent_lruvec(lruvec)));
 }
 
+void lru_note_cost_page(struct page *page)
+{
+	lru_note_cost(mem_cgroup_page_lruvec(page, page_pgdat(page)),
+		      page_is_file_lru(page), hpage_nr_pages(page));
+}
+
 static void __activate_page(struct page *page, struct lruvec *lruvec,
 			    void *arg)
 {
--- a/mm/swap_state.c~mm-vmscan-reclaim-writepage-is-io-cost
+++ a/mm/swap_state.c
@@ -432,7 +432,7 @@ struct page *__read_swap_cache_async(swp
 
 	/* XXX: Move to lru_cache_add() when it supports new vs putback */
 	spin_lock_irq(&page_pgdat(page)->lru_lock);
-	lru_note_cost(page);
+	lru_note_cost_page(page);
 	spin_unlock_irq(&page_pgdat(page)->lru_lock);
 
 	/* Initiate read into locked page */
--- a/mm/vmscan.c~mm-vmscan-reclaim-writepage-is-io-cost
+++ a/mm/vmscan.c
@@ -1359,6 +1359,8 @@ static unsigned int shrink_page_list(str
 			case PAGE_ACTIVATE:
 				goto activate_locked;
 			case PAGE_SUCCESS:
+				stat->nr_pageout += hpage_nr_pages(page);
+
 				if (PageWriteback(page))
 					goto keep;
 				if (PageDirty(page))
@@ -1964,6 +1966,7 @@ shrink_inactive_list(unsigned long nr_to
 	move_pages_to_lru(lruvec, &page_list);
 
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
+	lru_note_cost(lruvec, file, stat.nr_pageout);
 	item = current_is_kswapd() ? PGSTEAL_KSWAPD : PGSTEAL_DIRECT;
 	if (!cgroup_reclaim(sc))
 		__count_vm_events(item, nr_reclaimed);
--- a/mm/workingset.c~mm-vmscan-reclaim-writepage-is-io-cost
+++ a/mm/workingset.c
@@ -367,7 +367,7 @@ void workingset_refault(struct page *pag
 		SetPageWorkingset(page);
 		/* XXX: Move to lru_cache_add() when it supports new vs putback */
 		spin_lock_irq(&page_pgdat(page)->lru_lock);
-		lru_note_cost(page);
+		lru_note_cost_page(page);
 		spin_unlock_irq(&page_pgdat(page)->lru_lock);
 		inc_lruvec_state(lruvec, WORKINGSET_RESTORE);
 	}
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-fix-numa-node-file-count-error-in-replace_page_cache.patch
mm-memcontrol-fix-stat-corrupting-race-in-charge-moving.patch
mm-memcontrol-drop-compound-parameter-from-memcg-charging-api.patch
mm-shmem-remove-rare-optimization-when-swapin-races-with-hole-punching.patch
mm-memcontrol-move-out-cgroup-swaprate-throttling.patch
mm-memcontrol-convert-page-cache-to-a-new-mem_cgroup_charge-api.patch
mm-memcontrol-prepare-uncharging-for-removal-of-private-page-type-counters.patch
mm-memcontrol-prepare-move_account-for-removal-of-private-page-type-counters.patch
mm-memcontrol-prepare-cgroup-vmstat-infrastructure-for-native-anon-counters.patch
mm-memcontrol-switch-to-native-nr_file_pages-and-nr_shmem-counters.patch
mm-memcontrol-switch-to-native-nr_anon_mapped-counter.patch
mm-memcontrol-switch-to-native-nr_anon_thps-counter.patch
mm-memcontrol-switch-to-native-nr_anon_thps-counter-fix.patch
mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api.patch
mm-memcontrol-convert-anon-and-file-thp-to-new-mem_cgroup_charge-api-fix.patch
mm-memcontrol-drop-unused-try-commit-cancel-charge-api.patch
mm-memcontrol-prepare-swap-controller-setup-for-integration.patch
mm-memcontrol-make-swap-tracking-an-integral-part-of-memory-control.patch
mm-memcontrol-charge-swapin-pages-on-instantiation.patch
mm-memcontrol-delete-unused-lrucare-handling.patch
mm-memcontrol-update-page-mem_cgroup-stability-rules.patch
mm-fix-lru-balancing-effect-of-new-transparent-huge-pages.patch
mm-keep-separate-anon-and-file-statistics-on-page-reclaim-activity.patch
mm-allow-swappiness-that-prefers-reclaiming-anon-over-the-file-workingset.patch
mm-fold-and-remove-lru_cache_add_anon-and-lru_cache_add_file.patch
mm-workingset-let-cache-workingset-challenge-anon.patch
mm-remove-use-once-cache-bias-from-lru-balancing.patch
mm-vmscan-drop-unnecessary-div0-avoidance-rounding-in-get_scan_count.patch
mm-base-lru-balancing-on-an-explicit-cost-model.patch
mm-deactivations-shouldnt-bias-the-lru-balance.patch
mm-only-count-actual-rotations-as-lru-reclaim-cost.patch
mm-balance-lru-lists-based-on-relative-thrashing.patch
mm-vmscan-determine-anon-file-pressure-balance-at-the-reclaim-root.patch
mm-vmscan-reclaim-writepage-is-io-cost.patch
mm-vmscan-limit-the-range-of-lru-type-balancing.patch
