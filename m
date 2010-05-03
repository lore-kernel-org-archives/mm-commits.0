From: akpm@linux-foundation.org
Subject: + vmscan-remove-all_unreclaimable-scan-control.patch added to -mm tree
Date: Mon, 03 May 2010 14:44:43 -0700
Message-ID: <201005032144.o43LihnX023366@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757337Ab0ECVpz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 May 2010 17:45:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com


The patch titled
     vmscan: remove all_unreclaimable scan control
has been added to the -mm tree.  Its filename is
     vmscan-remove-all_unreclaimable-scan-control.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: remove all_unreclaimable scan control
From: Johannes Weiner <hannes@cmpxchg.org>

This scan control is abused to communicate a return value from
shrink_zones().  Write this idiomatically and remove the knob.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN mm/vmscan.c~vmscan-remove-all_unreclaimable-scan-control mm/vmscan.c
--- a/mm/vmscan.c~vmscan-remove-all_unreclaimable-scan-control
+++ a/mm/vmscan.c
@@ -70,8 +70,6 @@ struct scan_control {
 
 	int swappiness;
 
-	int all_unreclaimable;
-
 	int order;
 
 	int lumpy_reclaim;
@@ -1701,14 +1699,14 @@ static void shrink_zone(int priority, st
  * If a zone is deemed to be full of pinned pages then just give it a light
  * scan then give up on it.
  */
-static void shrink_zones(int priority, struct zonelist *zonelist,
+static int shrink_zones(int priority, struct zonelist *zonelist,
 					struct scan_control *sc)
 {
 	enum zone_type high_zoneidx = gfp_zone(sc->gfp_mask);
 	struct zoneref *z;
 	struct zone *zone;
+	int progress = 0;
 
-	sc->all_unreclaimable = 1;
 	for_each_zone_zonelist_nodemask(zone, z, zonelist, high_zoneidx,
 					sc->nodemask) {
 		if (!populated_zone(zone))
@@ -1724,19 +1722,19 @@ static void shrink_zones(int priority, s
 
 			if (zone->all_unreclaimable && priority != DEF_PRIORITY)
 				continue;	/* Let kswapd poll it */
-			sc->all_unreclaimable = 0;
 		} else {
 			/*
 			 * Ignore cpuset limitation here. We just want to reduce
 			 * # of used pages by us regardless of memory shortage.
 			 */
-			sc->all_unreclaimable = 0;
 			mem_cgroup_note_reclaim_priority(sc->mem_cgroup,
 							priority);
 		}
 
 		shrink_zone(priority, zone, sc);
+		progress = 1;
 	}
+	return progress;
 }
 
 /*
@@ -1789,7 +1787,7 @@ static unsigned long do_try_to_free_page
 		sc->nr_scanned = 0;
 		if (!priority)
 			disable_swap_token();
-		shrink_zones(priority, zonelist, sc);
+		ret = shrink_zones(priority, zonelist, sc);
 		/*
 		 * Don't shrink slabs when reclaiming memory from
 		 * over limit cgroups
@@ -1826,7 +1824,7 @@ static unsigned long do_try_to_free_page
 			congestion_wait(BLK_RW_ASYNC, HZ/10);
 	}
 	/* top priority shrink_zones still had more to do? don't OOM, then */
-	if (!sc->all_unreclaimable && scanning_global_lru(sc))
+	if (ret && scanning_global_lru(sc))
 		ret = sc->nr_reclaimed;
 out:
 	/*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

sparsemem-on-no-vmemmap-path-put-mem_map-on-node-high-too.patch
mincore-cleanups.patch
mincore-break-do_mincore-into-logical-pieces.patch
mincore-pass-ranges-as-startend-address-pairs.patch
mincore-do-nested-page-table-walks.patch
mm-document-follow_page.patch
vmscan-fix-unmapping-behaviour-for-reclaim_swap.patch
vmscan-remove-may_unmap-scan-control.patch
vmscan-remove-all_unreclaimable-scan-control.patch
vmscan-remove-isolate_pages-callback-scan-control.patch
vmscan-remove-may_swap-scan-control.patch

