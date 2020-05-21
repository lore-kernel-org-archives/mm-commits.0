From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-keep-separate-anon-and-file-statistics-on-page-reclaim-activity.patch
 added to -mm tree
Date: Wed, 20 May 2020 20:31:46 -0700
Message-ID: <20200521033146.HCqxijDDJ%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727958AbgEUDbs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 May 2020 23:31:48 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com


The patch titled
     Subject: mm: keep separate anon and file statistics on page reclaim activity
has been added to the -mm tree.  Its filename is
     mm-keep-separate-anon-and-file-statistics-on-page-reclaim-activity.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-keep-separate-anon-and-file-statistics-on-page-reclaim-activity.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-keep-separate-anon-and-file-statistics-on-page-reclaim-activity.patch

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
Cc: Rik van Riel <riel@redhat.com>
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
-
-	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
+	__count_vm_events(PGSTEAL_ANON + file, nr_reclaimed);
 
 	spin_unlock_irq(&pgdat->lru_lock);
 
--- a/mm/vmstat.c~mm-keep-separate-anon-and-file-statistics-on-page-reclaim-activity
+++ a/mm/vmstat.c
@@ -1201,6 +1201,10 @@ const char * const vmstat_text[] = {
 	"pgscan_kswapd",
 	"pgscan_direct",
 	"pgscan_direct_throttle",
+	"pgscan_anon",
+	"pgscan_file",
+	"pgsteal_anon",
+	"pgsteal_file",
 
 #ifdef CONFIG_NUMA
 	"zone_reclaim_failed",
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
