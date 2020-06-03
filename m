From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 104/131] mm: keep separate anon and file
 statistics on page reclaim activity
Date: Wed, 03 Jun 2020 16:02:34 -0700
Message-ID: <20200603230234.BtSVDatRM%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbgFCXIl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 19:08:41 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, linux-mm@kvack.org, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@surriel.com, torvalds@linux-foundation.org

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: keep separate anon and file statistics on page reclaim activity

Having statistics on pages scanned and pages reclaimed for both anon and
file pages makes it easier to evaluate changes to LRU balancing.

While at it, clean up the stat-keeping mess for isolation, putback,
reclaim stats etc.  a bit: first the physical LRU operation (isolation and
putback), followed by vmstats, reclaim_stats, and then vm events.

Link: http://lkml.kernel.org/r/20200520232525.798933-3-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    4 ++++
 mm/vmscan.c                   |   17 +++++++++--------
 mm/vmstat.c                   |    4 ++++
 3 files changed, 17 insertions(+), 8 deletions(-)

--- a/include/linux/vm_event_item.h~mm-keep-separate-anon-and-file-statistics-on-page-reclaim-activity
+++ a/include/linux/vm_event_item.h
@@ -35,6 +35,10 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		PGSCAN_KSWAPD,
 		PGSCAN_DIRECT,
 		PGSCAN_DIRECT_THROTTLE,
+		PGSCAN_ANON,
+		PGSCAN_FILE,
+		PGSTEAL_ANON,
+		PGSTEAL_FILE,
 #ifdef CONFIG_NUMA
 		PGSCAN_ZONE_RECLAIM_FAILED,
 #endif
--- a/mm/vmscan.c~mm-keep-separate-anon-and-file-statistics-on-page-reclaim-activity
+++ a/mm/vmscan.c
@@ -1913,7 +1913,7 @@ shrink_inactive_list(unsigned long nr_to
 	unsigned int nr_reclaimed = 0;
 	unsigned long nr_taken;
 	struct reclaim_stat stat;
-	int file = is_file_lru(lru);
+	bool file = is_file_lru(lru);
 	enum vm_event_item item;
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
@@ -1941,11 +1941,12 @@ shrink_inactive_list(unsigned long nr_to
 
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, nr_taken);
 	reclaim_stat->recent_scanned[file] += nr_taken;
-
 	item = current_is_kswapd() ? PGSCAN_KSWAPD : PGSCAN_DIRECT;
 	if (!cgroup_reclaim(sc))
 		__count_vm_events(item, nr_scanned);
 	__count_memcg_events(lruvec_memcg(lruvec), item, nr_scanned);
+	__count_vm_events(PGSCAN_ANON + file, nr_scanned);
+
 	spin_unlock_irq(&pgdat->lru_lock);
 
 	if (nr_taken == 0)
@@ -1956,16 +1957,16 @@ shrink_inactive_list(unsigned long nr_to
 
 	spin_lock_irq(&pgdat->lru_lock);
 
+	move_pages_to_lru(lruvec, &page_list);
+
+	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
+	reclaim_stat->recent_rotated[0] += stat.nr_activate[0];
+	reclaim_stat->recent_rotated[1] += stat.nr_activate[1];
 	item = current_is_kswapd() ? PGSTEAL_KSWAPD : PGSTEAL_DIRECT;
 	if (!cgroup_reclaim(sc))
 		__count_vm_events(item, nr_reclaimed);
 	__count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
-	reclaim_stat->recent_rotated[0] += stat.nr_activate[0];
-	reclaim_stat->recent_rotated[1] += stat.nr_activate[1];
-
-	move_pages_to_lru(lruvec, &page_list);
