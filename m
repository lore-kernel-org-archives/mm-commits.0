From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-direct-softlimit-reclaim-to-be-called-in-limit-path.patch removed from -mm tree
Date: Tue, 28 Jun 2011 13:42:43 -0700
Message-ID: <201106282042.p5SKgPBA003011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096Ab1F1Umj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jun 2011 16:42:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     memcg: fix direct softlimit reclaim to be called in limit path
has been removed from the -mm tree.  Its filename was
     memcg-fix-direct-softlimit-reclaim-to-be-called-in-limit-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix direct softlimit reclaim to be called in limit path
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

commit d149e3b ("memcg: add the soft_limit reclaim in global direct
reclaim") adds a softlimit hook to shrink_zones().  By this, soft limit is
called as

   try_to_free_pages()
       do_try_to_free_pages()
           shrink_zones()
               mem_cgroup_soft_limit_reclaim()

Then, direct reclaim is memcg softlimit hint aware, now.

But, the memory cgroup's "limit" path can call softlimit shrinker.

   try_to_free_mem_cgroup_pages()
       do_try_to_free_pages()
           shrink_zones()
               mem_cgroup_soft_limit_reclaim()

This will cause a global reclaim when a memcg hits limit.

This is bug. soft_limit_reclaim() should be called when
scanning_global_lru(sc) == true.

And the commit adds a variable "total_scanned" for counting softlimit
scanned pages....it's not "total".  This patch removes the variable and
update sc->nr_scanned instead of it.  This will affect shrink_slab()'s
scan condition but, global LRU is scanned by softlimit and I think this
change makes sense.

TODO: avoid too much scanning of a zone when softlimit did enough work.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Ying Han <yinghan@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff -puN mm/vmscan.c~memcg-fix-direct-softlimit-reclaim-to-be-called-in-limit-path mm/vmscan.c
--- a/mm/vmscan.c~memcg-fix-direct-softlimit-reclaim-to-be-called-in-limit-path
+++ a/mm/vmscan.c
@@ -1995,14 +1995,13 @@ restart:
  * If a zone is deemed to be full of pinned pages then just give it a light
  * scan then give up on it.
  */
-static unsigned long shrink_zones(int priority, struct zonelist *zonelist,
+static void shrink_zones(int priority, struct zonelist *zonelist,
 					struct scan_control *sc)
 {
 	struct zoneref *z;
 	struct zone *zone;
 	unsigned long nr_soft_reclaimed;
 	unsigned long nr_soft_scanned;
-	unsigned long total_scanned = 0;
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(sc->gfp_mask), sc->nodemask) {
@@ -2017,19 +2016,23 @@ static unsigned long shrink_zones(int pr
 				continue;
 			if (zone->all_unreclaimable && priority != DEF_PRIORITY)
 				continue;	/* Let kswapd poll it */
+			/*
+			 * This steals pages from memory cgroups over softlimit
+			 * and returns the number of reclaimed pages and
+			 * scanned pages. This works for global memory pressure
+			 * and balancing, not for a memcg's limit.
+			 */
+			nr_soft_scanned = 0;
+			nr_soft_reclaimed = mem_cgroup_soft_limit_reclaim(zone,
+						sc->order, sc->gfp_mask,
+						&nr_soft_scanned);
+			sc->nr_reclaimed += nr_soft_reclaimed;
+			sc->nr_scanned += nr_soft_scanned;
+			/* need some check for avoid more shrink_zone() */
 		}
 
-		nr_soft_scanned = 0;
-		nr_soft_reclaimed = mem_cgroup_soft_limit_reclaim(zone,
-							sc->order, sc->gfp_mask,
-							&nr_soft_scanned);
-		sc->nr_reclaimed += nr_soft_reclaimed;
-		total_scanned += nr_soft_scanned;
-
 		shrink_zone(priority, zone, sc);
 	}
