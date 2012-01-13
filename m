From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-distinguish-global-reclaim-from-global-lru-scanning.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:32:29 -0800
Message-ID: <20120113203229.EE65D10004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:51298 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759086Ab2AMUcb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:32:31 -0500
Received: by mail-gy0-f202.google.com with SMTP id r18so207082ghr.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:32:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jweiner@redhat.com, bsingharora@gmail.com, gthelen@google.com, hch@infradead.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, mhocko@suse.cz, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, riel@redhat.com, walken@google.com, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: distinguish global reclaim from global LRU scanning
has been removed from the -mm tree.  Its filename was
     mm-vmscan-distinguish-global-reclaim-from-global-lru-scanning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <jweiner@redhat.com>
Subject: mm: vmscan: distinguish global reclaim from global LRU scanning

The traditional zone reclaim code is scanning the per-zone LRU lists
during direct reclaim and kswapd, and the per-zone per-memory cgroup LRU
lists when reclaiming on behalf of a memory cgroup limit.

Subsequent patches will convert the traditional reclaim code to reclaim
exclusively from the per-memory cgroup LRU lists.  As a result, using the
predicate for which LRU list is scanned will no longer be appropriate to
tell global reclaim from limit reclaim.

This patch adds a global_reclaim() predicate to tell direct/kswapd reclaim
from memory cgroup limit reclaim and substitutes it in all places where
currently scanning_global_lru() is used for that.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Ying Han <yinghan@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   62 +++++++++++++++++++++++++++++---------------------
 1 file changed, 37 insertions(+), 25 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-distinguish-global-reclaim-from-global-lru-scanning mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-distinguish-global-reclaim-from-global-lru-scanning
+++ a/mm/vmscan.c
@@ -153,9 +153,25 @@ static LIST_HEAD(shrinker_list);
 static DECLARE_RWSEM(shrinker_rwsem);
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
-#define scanning_global_lru(sc)	(!(sc)->mem_cgroup)
+static bool global_reclaim(struct scan_control *sc)
+{
+	return !sc->mem_cgroup;
+}
+
+static bool scanning_global_lru(struct scan_control *sc)
+{
+	return !sc->mem_cgroup;
+}
 #else
-#define scanning_global_lru(sc)	(1)
+static bool global_reclaim(struct scan_control *sc)
+{
+	return true;
+}
+
+static bool scanning_global_lru(struct scan_control *sc)
+{
+	return true;
+}
 #endif
 
 static struct zone_reclaim_stat *get_reclaim_stat(struct zone *zone,
@@ -994,7 +1010,7 @@ keep_lumpy:
 	 * back off and wait for congestion to clear because further reclaim
 	 * will encounter the same problem
 	 */
-	if (nr_dirty && nr_dirty == nr_congested && scanning_global_lru(sc))
+	if (nr_dirty && nr_dirty == nr_congested && global_reclaim(sc))
 		zone_set_flag(zone, ZONE_CONGESTED);
 
 	free_hot_cold_page_list(&free_pages, 1);
@@ -1313,7 +1329,7 @@ static int too_many_isolated(struct zone
 	if (current_is_kswapd())
 		return 0;
 
-	if (!scanning_global_lru(sc))
+	if (!global_reclaim(sc))
 		return 0;
 
 	if (file) {
@@ -1491,6 +1507,12 @@ shrink_inactive_list(unsigned long nr_to
 	if (scanning_global_lru(sc)) {
 		nr_taken = isolate_pages_global(nr_to_scan, &page_list,
 			&nr_scanned, sc->order, reclaim_mode, zone, 0, file);
+	} else {
+		nr_taken = mem_cgroup_isolate_pages(nr_to_scan, &page_list,
+			&nr_scanned, sc->order, reclaim_mode, zone,
+			sc->mem_cgroup, 0, file);
+	}
+	if (global_reclaim(sc)) {
 		zone->pages_scanned += nr_scanned;
 		if (current_is_kswapd())
 			__count_zone_vm_events(PGSCAN_KSWAPD, zone,
@@ -1498,14 +1520,6 @@ shrink_inactive_list(unsigned long nr_to
 		else
 			__count_zone_vm_events(PGSCAN_DIRECT, zone,
 					       nr_scanned);
-	} else {
-		nr_taken = mem_cgroup_isolate_pages(nr_to_scan, &page_list,
-			&nr_scanned, sc->order, reclaim_mode, zone,
-			sc->mem_cgroup, 0, file);
-		/*
-		 * mem_cgroup_isolate_pages() keeps track of
-		 * scanned pages on its own.
-		 */
 	}
 
 	if (nr_taken == 0) {
@@ -1646,18 +1660,16 @@ static void shrink_active_list(unsigned 
 						&pgscanned, sc->order,
 						reclaim_mode, zone,
 						1, file);
-		zone->pages_scanned += pgscanned;
 	} else {
 		nr_taken = mem_cgroup_isolate_pages(nr_pages, &l_hold,
 						&pgscanned, sc->order,
 						reclaim_mode, zone,
 						sc->mem_cgroup, 1, file);
-		/*
-		 * mem_cgroup_isolate_pages() keeps track of
-		 * scanned pages on its own.
-		 */
 	}
 
+	if (global_reclaim(sc))
+		zone->pages_scanned += pgscanned;
+
 	reclaim_stat->recent_scanned[file] += nr_taken;
 
 	__count_zone_vm_events(PGREFILL, zone, pgscanned);
@@ -1827,7 +1839,7 @@ static unsigned long shrink_list(enum lr
 
 static int vmscan_swappiness(struct scan_control *sc)
 {
-	if (scanning_global_lru(sc))
+	if (global_reclaim(sc))
 		return vm_swappiness;
 	return mem_cgroup_swappiness(sc->mem_cgroup);
 }
@@ -1862,9 +1874,9 @@ static void get_scan_count(struct zone *
 	 * latencies, so it's better to scan a minimum amount there as
 	 * well.
 	 */
-	if (scanning_global_lru(sc) && current_is_kswapd())
+	if (current_is_kswapd())
 		force_scan = true;
-	if (!scanning_global_lru(sc))
+	if (!global_reclaim(sc))
 		force_scan = true;
 
 	/* If we have no swap space, do not bother scanning anon pages. */
@@ -1881,7 +1893,7 @@ static void get_scan_count(struct zone *
 	file  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_FILE) +
 		zone_nr_lru_pages(zone, sc, LRU_INACTIVE_FILE);
 
-	if (scanning_global_lru(sc)) {
+	if (global_reclaim(sc)) {
 		free  = zone_page_state(zone, NR_FREE_PAGES);
 		/* If we have very few page cache pages,
 		   force-scan anon pages. */
@@ -2114,7 +2126,7 @@ static bool shrink_zones(int priority, s
 		 * Take care memory controller reclaiming has small influence
 		 * to global LRU.
 		 */
-		if (scanning_global_lru(sc)) {
+		if (global_reclaim(sc)) {
 			if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
 				continue;
 			if (zone->all_unreclaimable && priority != DEF_PRIORITY)
@@ -2212,7 +2224,7 @@ static unsigned long do_try_to_free_page
 	get_mems_allowed();
 	delayacct_freepages_start();
 
-	if (scanning_global_lru(sc))
+	if (global_reclaim(sc))
 		count_vm_event(ALLOCSTALL);
 
 	for (priority = DEF_PRIORITY; priority >= 0; priority--) {
@@ -2226,7 +2238,7 @@ static unsigned long do_try_to_free_page
 		 * Don't shrink slabs when reclaiming memory from
 		 * over limit cgroups
 		 */
-		if (scanning_global_lru(sc)) {
+		if (global_reclaim(sc)) {
 			unsigned long lru_pages = 0;
 			for_each_zone_zonelist(zone, z, zonelist,
 					gfp_zone(sc->gfp_mask)) {
@@ -2288,7 +2300,7 @@ out:
 		return 0;
 
 	/* top priority shrink_zones still had more to do? don't OOM, then */
-	if (scanning_global_lru(sc) && !all_unreclaimable(zonelist, sc))
+	if (global_reclaim(sc) && !all_unreclaimable(zonelist, sc))
 		return 1;
 
 	return 0;
_

Patches currently in -mm which might be from jweiner@redhat.com are

origin.patch
mm-add-extra-free-kbytes-tunable.patch

