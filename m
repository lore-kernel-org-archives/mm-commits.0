From: akpm@linux-foundation.org
Subject: [merged] memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch removed from -mm tree
Date: Fri, 27 May 2011 12:57:57 -0700
Message-ID: <201105271956.p4RJu2fD017514@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756210Ab1E0URY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 16:17:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghan@google.com, balbir@linux.vnet.ibm.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, min


The patch titled
     memcg: add the soft_limit reclaim in global direct reclaim.
has been removed from the -mm tree.  Its filename was
     memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: add the soft_limit reclaim in global direct reclaim.
From: Ying Han <yinghan@google.com>

We recently added the change in global background reclaim which counts the
return value of soft_limit reclaim.  Now this patch adds the similar logic
on global direct reclaim.

We should skip scanning global LRU on shrink_zone if soft_limit reclaim
does enough work.  This is the first step where we start with counting the
nr_scanned and nr_reclaimed from soft_limit reclaim into global
scan_control.

Signed-off-by: Ying Han <yinghan@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim mm/vmscan.c
--- a/mm/vmscan.c~memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim
+++ a/mm/vmscan.c
@@ -1977,11 +1977,14 @@ restart:
  * If a zone is deemed to be full of pinned pages then just give it a light
  * scan then give up on it.
  */
-static void shrink_zones(int priority, struct zonelist *zonelist,
+static unsigned long shrink_zones(int priority, struct zonelist *zonelist,
 					struct scan_control *sc)
 {
 	struct zoneref *z;
 	struct zone *zone;
+	unsigned long nr_soft_reclaimed;
+	unsigned long nr_soft_scanned;
+	unsigned long total_scanned = 0;
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(sc->gfp_mask), sc->nodemask) {
@@ -1998,8 +2001,17 @@ static void shrink_zones(int priority, s
 				continue;	/* Let kswapd poll it */
 		}
 
+		nr_soft_scanned = 0;
+		nr_soft_reclaimed = mem_cgroup_soft_limit_reclaim(zone,
+							sc->order, sc->gfp_mask,
+							&nr_soft_scanned);
+		sc->nr_reclaimed += nr_soft_reclaimed;
+		total_scanned += nr_soft_scanned;
+
 		shrink_zone(priority, zone, sc);
 	}
+
+	return total_scanned;
 }
 
 static bool zone_reclaimable(struct zone *zone)
@@ -2064,7 +2076,7 @@ static unsigned long do_try_to_free_page
 		sc->nr_scanned = 0;
 		if (!priority)
 			disable_swap_token();
-		shrink_zones(priority, zonelist, sc);
+		total_scanned += shrink_zones(priority, zonelist, sc);
 		/*
 		 * Don't shrink slabs when reclaiming memory from
 		 * over limit cgroups
_

Patches currently in -mm which might be from yinghan@google.com are

origin.patch

