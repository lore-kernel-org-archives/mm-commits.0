From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-vmscan-determine-anon-file-pressure-balance-at-the-reclaim-root.patch
 added to -mm tree
Date: Wed, 20 May 2020 20:32:13 -0700
Message-ID: <20200521033213.zs6B6buDq%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728264AbgEUDcP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 May 2020 23:32:15 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com


The patch titled
     Subject: mm: vmscan: determine anon/file pressure balance at the reclaim root
has been added to the -mm tree.  Its filename is
     mm-vmscan-determine-anon-file-pressure-balance-at-the-reclaim-root.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-determine-anon-file-pressure-balance-at-the-reclaim-root.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-determine-anon-file-pressure-balance-at-the-reclaim-root.patch

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
Subject: mm: vmscan: determine anon/file pressure balance at the reclaim root

We split the LRU lists into anon and file, and we rebalance the scan
pressure between them when one of them begins thrashing: if the file cache
experiences workingset refaults, we increase the pressure on anonymous
pages; if the workload is stalled on swapins, we increase the pressure on
the file cache instead.

With cgroups and their nested LRU lists, we currently don't do this
correctly.  While recursive cgroup reclaim establishes a relative LRU
order among the pages of all involved cgroups, LRU pressure balancing is
done on an individual cgroup LRU level.  As a result, when one cgroup is
thrashing on the filesystem cache while a sibling may have cold anonymous
pages, pressure doesn't get equalized between them.

This patch moves LRU balancing decision to the root of reclaim - the same
level where the LRU order is established.

It does this by tracking LRU cost recursively, so that every level of the
cgroup tree knows the aggregate LRU cost of all memory within its domain. 
When the page scanner calculates the scan balance for any given individual
cgroup's LRU list, it uses the values from the ancestor cgroup that
initiated the reclaim cycle.

If one sibling is then thrashing on the cache, it will tip the pressure
balance inside its ancestors, and the next hierarchical reclaim iteration
will go more after the anon pages in the tree.

Link: http://lkml.kernel.org/r/20200520232525.798933-13-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   13 +++++++++++
 mm/swap.c                  |   32 +++++++++++++++++++++++----
 mm/vmscan.c                |   41 ++++++++++++++---------------------
 3 files changed, 57 insertions(+), 29 deletions(-)

--- a/include/linux/memcontrol.h~mm-vmscan-determine-anon-file-pressure-balance-at-the-reclaim-root
+++ a/include/linux/memcontrol.h
@@ -1303,6 +1303,19 @@ static inline void dec_lruvec_page_state
 	mod_lruvec_page_state(page, idx, -1);
 }
 
+static inline struct lruvec *parent_lruvec(struct lruvec *lruvec)
+{
+	struct mem_cgroup *memcg;
+
+	memcg = lruvec_memcg(lruvec);
+	if (!memcg)
+		return NULL;
+	memcg = parent_mem_cgroup(memcg);
+	if (!memcg)
+		return NULL;
+	return mem_cgroup_lruvec(memcg, lruvec_pgdat(lruvec));
+}
+
 #ifdef CONFIG_CGROUP_WRITEBACK
 
 struct wb_domain *mem_cgroup_wb_domain(struct bdi_writeback *wb);
--- a/mm/swap.c~mm-vmscan-determine-anon-file-pressure-balance-at-the-reclaim-root
+++ a/mm/swap.c
@@ -266,11 +266,33 @@ void lru_note_cost(struct page *page)
 {
 	struct lruvec *lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
 
-	/* Record new data point */
-	if (page_is_file_lru(page))
-		lruvec->file_cost++;
-	else
-		lruvec->anon_cost++;
+	do {
+		unsigned long lrusize;
+
+		/* Record cost event */
+		if (page_is_file_lru(page))
+			lruvec->file_cost++;
+		else
+			lruvec->anon_cost++;
+
+		/*
+		 * Decay previous events
+		 *
+		 * Because workloads change over time (and to avoid
+		 * overflow) we keep these statistics as a floating
+		 * average, which ends up weighing recent refaults
+		 * more than old ones.
+		 */
+		lrusize = lruvec_page_state(lruvec, NR_INACTIVE_ANON) +
+			  lruvec_page_state(lruvec, NR_ACTIVE_ANON) +
+			  lruvec_page_state(lruvec, NR_INACTIVE_FILE) +
+			  lruvec_page_state(lruvec, NR_ACTIVE_FILE);
+
+		if (lruvec->file_cost + lruvec->anon_cost > lrusize / 4) {
+			lruvec->file_cost /= 2;
+			lruvec->anon_cost /= 2;
+		}
+	} while ((lruvec = parent_lruvec(lruvec)));
 }
 
 static void __activate_page(struct page *page, struct lruvec *lruvec,
--- a/mm/vmscan.c~mm-vmscan-determine-anon-file-pressure-balance-at-the-reclaim-root
+++ a/mm/vmscan.c
@@ -79,6 +79,12 @@ struct scan_control {
 	 */
 	struct mem_cgroup *target_mem_cgroup;
 
+	/*
+	 * Scan pressure balancing between anon and file LRUs
+	 */
+	unsigned long	anon_cost;
+	unsigned long	file_cost;
+
 	/* Can active pages be deactivated as part of reclaim? */
 #define DEACTIVATE_ANON 1
 #define DEACTIVATE_FILE 2
@@ -2231,10 +2237,8 @@ static void get_scan_count(struct lruvec
 	int swappiness = mem_cgroup_swappiness(memcg);
 	u64 fraction[2];
 	u64 denominator = 0;	/* gcc */
-	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	unsigned long anon_prio, file_prio;
 	enum scan_balance scan_balance;
-	unsigned long anon, file;
 	unsigned long totalcost;
 	unsigned long ap, fp;
 	enum lru_list lru;
@@ -2285,7 +2289,6 @@ static void get_scan_count(struct lruvec
 	}
 
 	scan_balance = SCAN_FRACT;
-
 	/*
 	 * Calculate the pressure balance between anon and file pages.
 	 *
@@ -2300,30 +2303,12 @@ static void get_scan_count(struct lruvec
 	anon_prio = swappiness;
 	file_prio = 200 - anon_prio;
 
-	/*
-	 * Because workloads change over time (and to avoid overflow)
-	 * we keep these statistics as a floating average, which ends
-	 * up weighing recent refaults more than old ones.
-	 */
-
-	anon  = lruvec_lru_size(lruvec, LRU_ACTIVE_ANON, MAX_NR_ZONES) +
-		lruvec_lru_size(lruvec, LRU_INACTIVE_ANON, MAX_NR_ZONES);
-	file  = lruvec_lru_size(lruvec, LRU_ACTIVE_FILE, MAX_NR_ZONES) +
-		lruvec_lru_size(lruvec, LRU_INACTIVE_FILE, MAX_NR_ZONES);
-
-	spin_lock_irq(&pgdat->lru_lock);
-	totalcost = lruvec->anon_cost + lruvec->file_cost;
-	if (unlikely(totalcost > (anon + file) / 4)) {
-		lruvec->anon_cost /= 2;
-		lruvec->file_cost /= 2;
-		totalcost /= 2;
-	}
+	totalcost = sc->anon_cost + sc->file_cost;
 	ap = anon_prio * (totalcost + 1);
-	ap /= lruvec->anon_cost + 1;
+	ap /= sc->anon_cost + 1;
 
 	fp = file_prio * (totalcost + 1);
-	fp /= lruvec->file_cost + 1;
-	spin_unlock_irq(&pgdat->lru_lock);
+	fp /= sc->file_cost + 1;
 
 	fraction[0] = ap;
 	fraction[1] = fp;
@@ -2680,6 +2665,14 @@ again:
 	nr_scanned = sc->nr_scanned;
 
 	/*
+	 * Determine the scan balance between anon and file LRUs.
+	 */
+	spin_lock_irq(&pgdat->lru_lock);
+	sc->anon_cost = target_lruvec->anon_cost;
+	sc->file_cost = target_lruvec->file_cost;
+	spin_unlock_irq(&pgdat->lru_lock);
+
+	/*
 	 * Target desirable inactive:active list ratios for the anon
 	 * and file LRU lists.
 	 */
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
