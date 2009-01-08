From: akpm@linux-foundation.org
Subject: - memcg-rename-scan-global-lru.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:49:23 -0800
Message-ID: <200901082249.n08MnN8I028664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762795AbZAHWuC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:50:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, hugh@veritas.com, kosaki.motohiro@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: rename scan global lru
has been removed from the -mm tree.  Its filename was
     memcg-rename-scan-global-lru.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: rename scan global lru
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Rename scan_global_lru() to scanning_global_lru().

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff -puN mm/vmscan.c~memcg-rename-scan-global-lru mm/vmscan.c
--- a/mm/vmscan.c~memcg-rename-scan-global-lru
+++ a/mm/vmscan.c
@@ -125,15 +125,15 @@ static LIST_HEAD(shrinker_list);
 static DECLARE_RWSEM(shrinker_rwsem);
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
-#define scan_global_lru(sc)	(!(sc)->mem_cgroup)
+#define scanning_global_lru(sc)	(!(sc)->mem_cgroup)
 #else
-#define scan_global_lru(sc)	(1)
+#define scanning_global_lru(sc)	(1)
 #endif
 
 static struct zone_reclaim_stat *get_reclaim_stat(struct zone *zone,
 						  struct scan_control *sc)
 {
-	if (!scan_global_lru(sc))
+	if (!scanning_global_lru(sc))
 		return mem_cgroup_get_reclaim_stat(sc->mem_cgroup, zone);
 
 	return &zone->reclaim_stat;
@@ -142,7 +142,7 @@ static struct zone_reclaim_stat *get_rec
 static unsigned long zone_nr_pages(struct zone *zone, struct scan_control *sc,
 				   enum lru_list lru)
 {
-	if (!scan_global_lru(sc))
+	if (!scanning_global_lru(sc))
 		return mem_cgroup_zone_nr_pages(sc->mem_cgroup, zone, lru);
 
 	return zone_page_state(zone, NR_LRU_BASE + lru);
@@ -1090,7 +1090,7 @@ static unsigned long shrink_inactive_lis
 		__mod_zone_page_state(zone, NR_INACTIVE_ANON,
 						-count[LRU_INACTIVE_ANON]);
 
-		if (scan_global_lru(sc))
+		if (scanning_global_lru(sc))
 			zone->pages_scanned += nr_scan;
 
 		reclaim_stat->recent_scanned[0] += count[LRU_INACTIVE_ANON];
@@ -1129,7 +1129,7 @@ static unsigned long shrink_inactive_lis
 		if (current_is_kswapd()) {
 			__count_zone_vm_events(PGSCAN_KSWAPD, zone, nr_scan);
 			__count_vm_events(KSWAPD_STEAL, nr_freed);
-		} else if (scan_global_lru(sc))
+		} else if (scanning_global_lru(sc))
 			__count_zone_vm_events(PGSCAN_DIRECT, zone, nr_scan);
 
 		__count_zone_vm_events(PGSTEAL, zone, nr_freed);
@@ -1228,7 +1228,7 @@ static void shrink_active_list(unsigned 
 	 * zone->pages_scanned is used for detect zone's oom
 	 * mem_cgroup remembers nr_scan by itself.
 	 */
-	if (scan_global_lru(sc)) {
+	if (scanning_global_lru(sc)) {
 		zone->pages_scanned += pgscanned;
 	}
 	reclaim_stat->recent_scanned[!!file] += pgmoved;
@@ -1337,7 +1337,7 @@ static int inactive_anon_is_low(struct z
 {
 	int low;
 
-	if (scan_global_lru(sc))
+	if (scanning_global_lru(sc))
 		low = inactive_anon_is_low_global(zone);
 	else
 		low = mem_cgroup_inactive_anon_is_low(sc->mem_cgroup, zone);
@@ -1390,7 +1390,7 @@ static void get_scan_ratio(struct zone *
 	file  = zone_nr_pages(zone, sc, LRU_ACTIVE_FILE) +
 		zone_nr_pages(zone, sc, LRU_INACTIVE_FILE);
 
-	if (scan_global_lru(sc)) {
+	if (scanning_global_lru(sc)) {
 		free  = zone_page_state(zone, NR_FREE_PAGES);
 		/* If we have very few page cache pages,
 		   force-scan anon pages. */
@@ -1474,7 +1474,7 @@ static void shrink_zone(int priority, st
 			scan >>= priority;
 			scan = (scan * percent[file]) / 100;
 		}
-		if (scan_global_lru(sc)) {
+		if (scanning_global_lru(sc)) {
 			zone->lru[l].nr_scan += scan;
 			nr[l] = zone->lru[l].nr_scan;
 			if (nr[l] >= swap_cluster_max)
@@ -1550,7 +1550,7 @@ static void shrink_zones(int priority, s
 		 * Take care memory controller reclaiming has small influence
 		 * to global LRU.
 		 */
-		if (scan_global_lru(sc)) {
+		if (scanning_global_lru(sc)) {
 			if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
 				continue;
 			note_zone_scanning_priority(zone, priority);
@@ -1603,12 +1603,12 @@ static unsigned long do_try_to_free_page
 
 	delayacct_freepages_start();
 
-	if (scan_global_lru(sc))
+	if (scanning_global_lru(sc))
 		count_vm_event(ALLOCSTALL);
 	/*
 	 * mem_cgroup will not do shrink_slab.
 	 */
-	if (scan_global_lru(sc)) {
+	if (scanning_global_lru(sc)) {
 		for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
 
 			if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
@@ -1627,7 +1627,7 @@ static unsigned long do_try_to_free_page
 		 * Don't shrink slabs when reclaiming memory from
 		 * over limit cgroups
 		 */
-		if (scan_global_lru(sc)) {
+		if (scanning_global_lru(sc)) {
 			shrink_slab(sc->nr_scanned, sc->gfp_mask, lru_pages);
 			if (reclaim_state) {
 				sc->nr_reclaimed += reclaim_state->reclaimed_slab;
@@ -1658,7 +1658,7 @@ static unsigned long do_try_to_free_page
 			congestion_wait(WRITE, HZ/10);
 	}
 	/* top priority shrink_zones still had more to do? don't OOM, then */
-	if (!sc->all_unreclaimable && scan_global_lru(sc))
+	if (!sc->all_unreclaimable && scanning_global_lru(sc))
 		ret = sc->nr_reclaimed;
 out:
 	/*
@@ -1671,7 +1671,7 @@ out:
 	if (priority < 0)
 		priority = 0;
 
-	if (scan_global_lru(sc)) {
+	if (scanning_global_lru(sc)) {
 		for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
 
 			if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch

