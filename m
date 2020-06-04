From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-determine-anon-file-pressure-balance-at-the-reclaim-root.patch
 removed from -mm tree
Date: Thu, 04 Jun 2020 10:21:04 -0700
Message-ID: <20200604172104.xz0ju5HaA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730128AbgFDRVF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:21:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@surriel.com


The patch titled
     Subject: mm: vmscan: determine anon/file pressure balance at the reclaim root
has been removed from the -mm tree.  Its filename was
     mm-vmscan-determine-anon-file-pressure-balance-at-the-reclaim-root.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   13 +++++++++++
 mm/swap.c                  |   32 +++++++++++++++++++++++----
 mm/vmscan.c                |   41 ++++++++++++++---------------------
 3 files changed, 57 insertions(+), 29 deletions(-)

--- a/include/linux/memcontrol.h~mm-vmscan-determine-anon-file-pressure-balance-at-the-reclaim-root
+++ a/include/linux/memcontrol.h
@@ -1242,6 +1242,19 @@ static inline void dec_lruvec_page_state
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
@@ -282,11 +282,33 @@ void lru_note_cost(struct page *page)
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
@@ -2688,6 +2673,14 @@ again:
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
