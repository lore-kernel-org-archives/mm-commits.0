From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-convert-global-reclaim-to-per-memcg-lru-lists.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:32:49 -0800
Message-ID: <20120113203249.EFACF1E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:60119 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759097Ab2AMUcv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:32:51 -0500
Received: by yenl1 with SMTP id l1so72097yen.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:32:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jweiner@redhat.com, bsingharora@gmail.com, gthelen@google.com, hch@infradead.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, mhocko@suse.cz, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, riel@redhat.com, walken@google.com, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: convert global reclaim to per-memcg LRU lists
has been removed from the -mm tree.  Its filename was
     mm-vmscan-convert-global-reclaim-to-per-memcg-lru-lists.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <jweiner@redhat.com>
Subject: mm: vmscan: convert global reclaim to per-memcg LRU lists

The global per-zone LRU lists are about to go away on memcg-enabled
kernels, global reclaim must be able to find its pages on the per-memcg
LRU lists.

Since the LRU pages of a zone are distributed over all existing memory
cgroups, a scan target for a zone is complete when all memory cgroups are
scanned for their proportional share of a zone's memory.

The forced scanning of small scan targets from kswapd is limited to zones
marked unreclaimable, otherwise kswapd can quickly overreclaim by
force-scanning the LRU lists of multiple memory cgroups.

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

 mm/vmscan.c |   39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-convert-global-reclaim-to-per-memcg-lru-lists mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-convert-global-reclaim-to-per-memcg-lru-lists
+++ a/mm/vmscan.c
@@ -1886,7 +1886,7 @@ static void get_scan_count(struct mem_cg
 	 * latencies, so it's better to scan a minimum amount there as
 	 * well.
 	 */
-	if (current_is_kswapd())
+	if (current_is_kswapd() && mz->zone->all_unreclaimable)
 		force_scan = true;
 	if (!global_reclaim(sc))
 		force_scan = true;
@@ -2111,16 +2111,6 @@ static void shrink_zone(int priority, st
 	};
 	struct mem_cgroup *memcg;
 
-	if (global_reclaim(sc)) {
-		struct mem_cgroup_zone mz = {
-			.mem_cgroup = NULL,
-			.zone = zone,
-		};
-
-		shrink_mem_cgroup_zone(priority, &mz, sc);
-		return;
-	}
-
 	memcg = mem_cgroup_iter(root, NULL, &reclaim);
 	do {
 		struct mem_cgroup_zone mz = {
@@ -2134,6 +2124,10 @@ static void shrink_zone(int priority, st
 		 * scanned it with decreasing priority levels until
 		 * nr_to_reclaim had been reclaimed.  This priority
 		 * cycle is thus over after a single memcg.
+		 *
+		 * Direct reclaim and kswapd, on the other hand, have
+		 * to scan all memory cgroups to fulfill the overall
+		 * scan target for the zone.
 		 */
 		if (!global_reclaim(sc)) {
 			mem_cgroup_iter_break(root, memcg);
@@ -2478,13 +2472,24 @@ unsigned long try_to_free_mem_cgroup_pag
 static void age_active_anon(struct zone *zone, struct scan_control *sc,
 			    int priority)
 {
-	struct mem_cgroup_zone mz = {
-		.mem_cgroup = NULL,
-		.zone = zone,
-	};
+	struct mem_cgroup *memcg;
+
+	if (!total_swap_pages)
+		return;
+
+	memcg = mem_cgroup_iter(NULL, NULL, NULL);
+	do {
+		struct mem_cgroup_zone mz = {
+			.mem_cgroup = memcg,
+			.zone = zone,
+		};
+
+		if (inactive_anon_is_low(&mz))
+			shrink_active_list(SWAP_CLUSTER_MAX, &mz,
+					   sc, priority, 0);
 
-	if (inactive_anon_is_low(&mz))
-		shrink_active_list(SWAP_CLUSTER_MAX, &mz, sc, priority, 0);
+		memcg = mem_cgroup_iter(NULL, memcg, NULL);
+	} while (memcg);
 }
 
 /*
_

Patches currently in -mm which might be from jweiner@redhat.com are

origin.patch
mm-add-extra-free-kbytes-tunable.patch

