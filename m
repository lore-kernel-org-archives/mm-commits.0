From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-balance-lru-lists-based-on-relative-thrashing.patch
 added to -mm tree
Date: Wed, 20 May 2020 20:32:09 -0700
Message-ID: <20200521033209.JF1UvhuZX%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728264AbgEUDcL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 May 2020 23:32:11 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com


The patch titled
     Subject: mm: balance LRU lists based on relative thrashing
has been added to the -mm tree.  Its filename is
     mm-balance-lru-lists-based-on-relative-thrashing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-balance-lru-lists-based-on-relative-thrashing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-balance-lru-lists-based-on-relative-thrashing.patch

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
Subject: mm: balance LRU lists based on relative thrashing

Since the LRUs were split into anon and file lists, the VM has been
balancing between page cache and anonymous pages based on per-list ratios
of scanned vs.  rotated pages.  In most cases that tips page reclaim
towards the list that is easier to reclaim and has the fewest actively
used pages, but there are a few problems with it:

1. Refaults and LRU rotations are weighted the same way, even though
   one costs IO and the other costs a bit of CPU.

2. The less we scan an LRU list based on already observed rotations,
   the more we increase the sampling interval for new references, and
   rotations become even more likely on that list. This can enter a
   death spiral in which we stop looking at one list completely until
   the other one is all but annihilated by page reclaim.

Since commit a528910e12ec ("mm: thrash detection-based file cache sizing")
we have refault detection for the page cache.  Along with swapin events,
they are good indicators of when the file or anon list, respectively, is
too small for its workingset and needs to grow.

For example, if the page cache is thrashing, the cache pages need more
time in memory, while there may be colder pages on the anonymous list. 
Likewise, if swapped pages are faulting back in, it indicates that we
reclaim anonymous pages too aggressively and should back off.

Replace LRU rotations with refaults and swapins as the basis for relative
reclaim cost of the two LRUs.  This will have the VM target list balances
that incur the least amount of IO on aggregate.

Link: http://lkml.kernel.org/r/20200520232525.798933-12-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    3 +--
 mm/swap.c            |   11 +++++++----
 mm/swap_state.c      |    5 +++++
 mm/vmscan.c          |   39 ++++++++++-----------------------------
 mm/workingset.c      |    4 ++++
 5 files changed, 27 insertions(+), 35 deletions(-)

--- a/include/linux/swap.h~mm-balance-lru-lists-based-on-relative-thrashing
+++ a/include/linux/swap.h
@@ -334,8 +334,7 @@ extern unsigned long nr_free_pagecache_p
 
 
 /* linux/mm/swap.c */
-extern void lru_note_cost(struct lruvec *lruvec, bool file,
-			  unsigned int nr_pages);
+extern void lru_note_cost(struct page *);
 extern void lru_cache_add(struct page *);
 extern void lru_add_page_tail(struct page *page, struct page *page_tail,
 			 struct lruvec *lruvec, struct list_head *head);
--- a/mm/swap.c~mm-balance-lru-lists-based-on-relative-thrashing
+++ a/mm/swap.c
@@ -262,12 +262,15 @@ void rotate_reclaimable_page(struct page
 	}
 }
 
-void lru_note_cost(struct lruvec *lruvec, bool file, unsigned int nr_pages)
+void lru_note_cost(struct page *page)
 {
-	if (file)
-		lruvec->file_cost += nr_pages;
+	struct lruvec *lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
+
+	/* Record new data point */
+	if (page_is_file_lru(page))
+		lruvec->file_cost++;
 	else
-		lruvec->anon_cost += nr_pages;
+		lruvec->anon_cost++;
 }
 
 static void __activate_page(struct page *page, struct lruvec *lruvec,
--- a/mm/swap_state.c~mm-balance-lru-lists-based-on-relative-thrashing
+++ a/mm/swap_state.c
@@ -430,6 +430,11 @@ struct page *__read_swap_cache_async(swp
 	if (mem_cgroup_charge(page, NULL, gfp_mask & GFP_KERNEL))
 		goto fail_delete;
 
+	/* XXX: Move to lru_cache_add() when it supports new vs putback */
+	spin_lock_irq(&page_pgdat(page)->lru_lock);
+	lru_note_cost(page);
+	spin_unlock_irq(&page_pgdat(page)->lru_lock);
+
 	/* Initiate read into locked page */
 	SetPageWorkingset(page);
 	lru_cache_add(page);
--- a/mm/vmscan.c~mm-balance-lru-lists-based-on-relative-thrashing
+++ a/mm/vmscan.c
@@ -1958,12 +1958,6 @@ shrink_inactive_list(unsigned long nr_to
 	move_pages_to_lru(lruvec, &page_list);
 
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
-	/*
-	 * Rotating pages costs CPU without actually
-	 * progressing toward the reclaim goal.
-	 */
-	lru_note_cost(lruvec, 0, stat.nr_activate[0]);
-	lru_note_cost(lruvec, 1, stat.nr_activate[1]);
 	item = current_is_kswapd() ? PGSTEAL_KSWAPD : PGSTEAL_DIRECT;
 	if (!cgroup_reclaim(sc))
 		__count_vm_events(item, nr_reclaimed);
@@ -2079,11 +2073,6 @@ static void shrink_active_list(unsigned
 	 * Move pages back to the lru list.
 	 */
 	spin_lock_irq(&pgdat->lru_lock);
-	/*
-	 * Rotating pages costs CPU without actually
-	 * progressing toward the reclaim goal.
-	 */
-	lru_note_cost(lruvec, file, nr_rotated);
 
 	nr_activate = move_pages_to_lru(lruvec, &l_active);
 	nr_deactivate = move_pages_to_lru(lruvec, &l_inactive);
@@ -2298,22 +2287,23 @@ static void get_scan_count(struct lruvec
 	scan_balance = SCAN_FRACT;
 
 	/*
-	 * With swappiness at 100, anonymous and file have the same priority.
-	 * This scanning priority is essentially the inverse of IO cost.
+	 * Calculate the pressure balance between anon and file pages.
+	 *
+	 * The amount of pressure we put on each LRU is inversely
+	 * proportional to the cost of reclaiming each list, as
+	 * determined by the share of pages that are refaulting, times
+	 * the relative IO cost of bringing back a swapped out
+	 * anonymous page vs reloading a filesystem page (swappiness).
+	 *
+	 * With swappiness at 100, anon and file have equal IO cost.
 	 */
 	anon_prio = swappiness;
 	file_prio = 200 - anon_prio;
 
 	/*
-	 * OK, so we have swap space and a fair amount of page cache
-	 * pages.  We use the recently rotated / recently scanned
-	 * ratios to determine how valuable each cache is.
-	 *
 	 * Because workloads change over time (and to avoid overflow)
 	 * we keep these statistics as a floating average, which ends
-	 * up weighing recent references more than old ones.
-	 *
-	 * anon in [0], file in [1]
+	 * up weighing recent refaults more than old ones.
 	 */
 
 	anon  = lruvec_lru_size(lruvec, LRU_ACTIVE_ANON, MAX_NR_ZONES) +
@@ -2328,15 +2318,6 @@ static void get_scan_count(struct lruvec
 		lruvec->file_cost /= 2;
 		totalcost /= 2;
 	}
-
-	/*
-	 * The amount of pressure on anon vs file pages is inversely
-	 * proportional to the assumed cost of reclaiming each list,
-	 * as determined by the share of pages that are likely going
-	 * to refault or rotate on each list (recently referenced),
-	 * times the relative IO cost of bringing back a swapped out
-	 * anonymous page vs reloading a filesystem page (swappiness).
-	 */
 	ap = anon_prio * (totalcost + 1);
 	ap /= lruvec->anon_cost + 1;
 
--- a/mm/workingset.c~mm-balance-lru-lists-based-on-relative-thrashing
+++ a/mm/workingset.c
@@ -365,6 +365,10 @@ void workingset_refault(struct page *pag
 	/* Page was active prior to eviction */
 	if (workingset) {
 		SetPageWorkingset(page);
+		/* XXX: Move to lru_cache_add() when it supports new vs putback */
+		spin_lock_irq(&page_pgdat(page)->lru_lock);
+		lru_note_cost(page);
+		spin_unlock_irq(&page_pgdat(page)->lru_lock);
 		inc_lruvec_state(lruvec, WORKINGSET_RESTORE);
 	}
 out:
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
