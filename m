From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-only-wakeup-kswapd-once-per-node-for-the-requested-classzone.patch removed from -mm tree
Date: Fri, 29 Jul 2016 11:55:07 -0700
Message-ID: <579ba68b.IBzEQZtqOWbVIV3d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37325 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbcG2SzI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:55:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: only wakeup kswapd once per node for the requested classzone
has been removed from the -mm tree.  Its filename was
     mm-vmscan-only-wakeup-kswapd-once-per-node-for-the-requested-classzone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, vmscan: only wakeup kswapd once per node for the requested classzone

kswapd is woken when zones are below the low watermark but the wakeup
decision is not taking the classzone into account.  Now that reclaim is
node-based, it is only required to wake kswapd once per node and only if
all zones are unbalanced for the requested classzone.

Note that one node might be checked multiple times if the zonelist is
ordered by node because there is no cheap way of tracking what nodes have
already been visited.  For zone-ordering, each node should be checked only
once.

Link: http://lkml.kernel.org/r/1467970510-21195-22-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++++--
 mm/vmscan.c     |   13 +++++++++++--
 2 files changed, 17 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~mm-vmscan-only-wakeup-kswapd-once-per-node-for-the-requested-classzone mm/page_alloc.c
--- a/mm/page_alloc.c~mm-vmscan-only-wakeup-kswapd-once-per-node-for-the-requested-classzone
+++ a/mm/page_alloc.c
@@ -3367,10 +3367,14 @@ static void wake_all_kswapds(unsigned in
 {
 	struct zoneref *z;
 	struct zone *zone;
+	pg_data_t *last_pgdat = NULL;
 
 	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist,
-						ac->high_zoneidx, ac->nodemask)
-		wakeup_kswapd(zone, order, ac_classzone_idx(ac));
+					ac->high_zoneidx, ac->nodemask) {
+		if (last_pgdat != zone->zone_pgdat)
+			wakeup_kswapd(zone, order, ac_classzone_idx(ac));
+		last_pgdat = zone->zone_pgdat;
+	}
 }
 
 static inline unsigned int
diff -puN mm/vmscan.c~mm-vmscan-only-wakeup-kswapd-once-per-node-for-the-requested-classzone mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-only-wakeup-kswapd-once-per-node-for-the-requested-classzone
+++ a/mm/vmscan.c
@@ -3421,6 +3421,7 @@ kswapd_try_sleep:
 void wakeup_kswapd(struct zone *zone, int order, enum zone_type classzone_idx)
 {
 	pg_data_t *pgdat;
+	int z;
 
 	if (!populated_zone(zone))
 		return;
@@ -3432,8 +3433,16 @@ void wakeup_kswapd(struct zone *zone, in
 	pgdat->kswapd_order = max(pgdat->kswapd_order, order);
 	if (!waitqueue_active(&pgdat->kswapd_wait))
 		return;
-	if (zone_balanced(zone, order, 0))
-		return;
+
+	/* Only wake kswapd if all zones are unbalanced */
+	for (z = 0; z <= classzone_idx; z++) {
+		zone = pgdat->node_zones + z;
+		if (!populated_zone(zone))
+			continue;
+
+		if (zone_balanced(zone, order, classzone_idx))
+			return;
+	}
 
 	trace_mm_vmscan_wakeup_kswapd(pgdat->node_id, zone_idx(zone), order);
 	wake_up_interruptible(&pgdat->kswapd_wait);
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


