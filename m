From: akpm@linux-foundation.org
Subject: - vmscan-bail-out-of-direct-reclaim-after-swap_cluster_max-pages.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:13:45 -0800
Message-ID: <200901072213.n07MDjfi013765@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60760 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759021AbZAGWOa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:14:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: bail out of direct reclaim after swap_cluster_max pages
has been removed from the -mm tree.  Its filename was
     vmscan-bail-out-of-direct-reclaim-after-swap_cluster_max-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: bail out of direct reclaim after swap_cluster_max pages
From: Rik van Riel <riel@redhat.com>

When the VM is under pressure, it can happen that several direct reclaim
processes are in the pageout code simultaneously.  It also happens that
the reclaiming processes run into mostly referenced, mapped and dirty
pages in the first round.

This results in multiple direct reclaim processes having a lower
pageout priority, which corresponds to a higher target of pages to
scan.

This in turn can result in each direct reclaim process freeing
many pages.  Together, they can end up freeing way too many pages.

This kicks useful data out of memory (in some cases more than half
of all memory is swapped out).  It also impacts performance by
keeping tasks stuck in the pageout code for too long.

A 30% improvement in hackbench has been observed with this patch.

The fix is relatively simple: in shrink_zone() we can check how many
pages we have already freed, direct reclaim tasks break out of the
scanning loop if they have already freed enough pages and have reached
a lower priority level.

We do not break out of shrink_zone() when priority == DEF_PRIORITY,
to ensure that equal pressure is applied to every zone in the common
case.

However, in order to do this we do need to know how many pages we already
freed, so move nr_reclaimed into scan_control.


akpm: a historical interlude...

We tried this in 2004:

:commit e468e46a9bea3297011d5918663ce6d19094cf87
:Author: akpm <akpm>
:Date:   Thu Jun 24 15:53:52 2004 +0000
:
:[PATCH] vmscan.c: dont reclaim too many pages
:    
:    The shrink_zone() logic can, under some circumstances, cause far too many
:    pages to be reclaimed.  Say, we're scanning at high priority and suddenly hit
:    a large number of reclaimable pages on the LRU.                                                                        
:    Change things so we bale out when SWAP_CLUSTER_MAX pages have been reclaimed.

And we reverted it in 2006:

:commit 210fe530305ee50cd889fe9250168228b2994f32
:Author: Andrew Morton <akpm@osdl.org>
:Date:   Fri Jan 6 00:11:14 2006 -0800
:
:    [PATCH] vmscan: balancing fix
:    
:    Revert a patch which went into 2.6.8-rc1.  The changelog for that patch was:
:    
:      The shrink_zone() logic can, under some circumstances, cause far too many
:      pages to be reclaimed.  Say, we're scanning at high priority and suddenly
:      hit a large number of reclaimable pages on the LRU.
:    
:      Change things so we bale out when SWAP_CLUSTER_MAX pages have been
:      reclaimed.
:    
:    Problem is, this change caused significant imbalance in inter-zone scan
:    balancing by truncating scans of larger zones.
:    
:    Suppose, for example, ZONE_HIGHMEM is 10x the size of ZONE_NORMAL.  The zone
:    balancing algorithm would require that if we're scanning 100 pages of
:    ZONE_HIGHMEM, we should scan 10 pages of ZONE_NORMAL.  But this logic will
:    cause the scanning of ZONE_HIGHMEM to bale out after only 32 pages are
:    reclaimed.  Thus effectively causing smaller zones to be scanned relatively
:    harder than large ones.
:    
:    Now I need to remember what the workload was which caused me to write this
:    patch originally, then fix it up in a different way...


And we haven't demonstrated that whatever problem caused that reversion is
not being reintroduced by this change in 2008.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   62 ++++++++++++++++++++++++++------------------------
 1 file changed, 33 insertions(+), 29 deletions(-)

diff -puN mm/vmscan.c~vmscan-bail-out-of-direct-reclaim-after-swap_cluster_max-pages mm/vmscan.c
--- a/mm/vmscan.c~vmscan-bail-out-of-direct-reclaim-after-swap_cluster_max-pages
+++ a/mm/vmscan.c
@@ -52,6 +52,9 @@ struct scan_control {
 	/* Incremented by the number of inactive pages that were scanned */
 	unsigned long nr_scanned;
 
+	/* Number of pages freed so far during a call to shrink_zones() */
+	unsigned long nr_reclaimed;
+
 	/* This context's GFP mask */
 	gfp_t gfp_mask;
 
@@ -1400,12 +1403,11 @@ static void get_scan_ratio(struct zone *
 /*
  * This is a basic per-zone page freer.  Used by both kswapd and direct reclaim.
  */
-static unsigned long shrink_zone(int priority, struct zone *zone,
+static void shrink_zone(int priority, struct zone *zone,
 				struct scan_control *sc)
 {
 	unsigned long nr[NR_LRU_LISTS];
 	unsigned long nr_to_scan;
-	unsigned long nr_reclaimed = 0;
 	unsigned long percent[2];	/* anon @ 0; file @ 1 */
 	enum lru_list l;
 
@@ -1446,10 +1448,21 @@ static unsigned long shrink_zone(int pri
 					(unsigned long)sc->swap_cluster_max);
 				nr[l] -= nr_to_scan;
 
-				nr_reclaimed += shrink_list(l, nr_to_scan,
+				sc->nr_reclaimed += shrink_list(l, nr_to_scan,
 							zone, sc, priority);
 			}
 		}
+		/*
+		 * On large memory systems, scan >> priority can become
+		 * really large. This is fine for the starting priority;
+		 * we want to put equal scanning pressure on each zone.
+		 * However, if the VM has a harder time of freeing pages,
+		 * with multiple processes reclaiming pages, the total
+		 * freeing target can get unreasonably large.
+		 */
+		if (sc->nr_reclaimed > sc->swap_cluster_max &&
+			priority < DEF_PRIORITY && !current_is_kswapd())
+			break;
 	}
 
 	/*
@@ -1462,7 +1475,6 @@ static unsigned long shrink_zone(int pri
 		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
 
 	throttle_vm_writeout(sc->gfp_mask);
-	return nr_reclaimed;
 }
 
 /*
@@ -1476,16 +1488,13 @@ static unsigned long shrink_zone(int pri
  * b) The zones may be over pages_high but they must go *over* pages_high to
  *    satisfy the `incremental min' zone defense algorithm.
  *
- * Returns the number of reclaimed pages.
- *
  * If a zone is deemed to be full of pinned pages then just give it a light
  * scan then give up on it.
  */
-static unsigned long shrink_zones(int priority, struct zonelist *zonelist,
+static void shrink_zones(int priority, struct zonelist *zonelist,
 					struct scan_control *sc)
 {
 	enum zone_type high_zoneidx = gfp_zone(sc->gfp_mask);
-	unsigned long nr_reclaimed = 0;
 	struct zoneref *z;
 	struct zone *zone;
 
@@ -1516,10 +1525,8 @@ static unsigned long shrink_zones(int pr
 							priority);
 		}
 
-		nr_reclaimed += shrink_zone(priority, zone, sc);
+		shrink_zone(priority, zone, sc);
 	}
-
-	return nr_reclaimed;
 }
 
 /*
@@ -1544,7 +1551,6 @@ static unsigned long do_try_to_free_page
 	int priority;
 	unsigned long ret = 0;
 	unsigned long total_scanned = 0;
-	unsigned long nr_reclaimed = 0;
 	struct reclaim_state *reclaim_state = current->reclaim_state;
 	unsigned long lru_pages = 0;
 	struct zoneref *z;
@@ -1572,7 +1578,7 @@ static unsigned long do_try_to_free_page
 		sc->nr_scanned = 0;
 		if (!priority)
 			disable_swap_token();
-		nr_reclaimed += shrink_zones(priority, zonelist, sc);
+		shrink_zones(priority, zonelist, sc);
 		/*
 		 * Don't shrink slabs when reclaiming memory from
 		 * over limit cgroups
@@ -1580,13 +1586,13 @@ static unsigned long do_try_to_free_page
 		if (scan_global_lru(sc)) {
 			shrink_slab(sc->nr_scanned, sc->gfp_mask, lru_pages);
 			if (reclaim_state) {
-				nr_reclaimed += reclaim_state->reclaimed_slab;
+				sc->nr_reclaimed += reclaim_state->reclaimed_slab;
 				reclaim_state->reclaimed_slab = 0;
 			}
 		}
 		total_scanned += sc->nr_scanned;
-		if (nr_reclaimed >= sc->swap_cluster_max) {
-			ret = nr_reclaimed;
+		if (sc->nr_reclaimed >= sc->swap_cluster_max) {
+			ret = sc->nr_reclaimed;
 			goto out;
 		}
 
@@ -1609,7 +1615,7 @@ static unsigned long do_try_to_free_page
 	}
 	/* top priority shrink_zones still had more to do? don't OOM, then */
 	if (!sc->all_unreclaimable && scan_global_lru(sc))
-		ret = nr_reclaimed;
+		ret = sc->nr_reclaimed;
 out:
 	/*
 	 * Now that we've scanned all the zones at this priority level, note
@@ -1704,7 +1710,6 @@ static unsigned long balance_pgdat(pg_da
 	int priority;
 	int i;
 	unsigned long total_scanned;
-	unsigned long nr_reclaimed;
 	struct reclaim_state *reclaim_state = current->reclaim_state;
 	struct scan_control sc = {
 		.gfp_mask = GFP_KERNEL,
@@ -1723,7 +1728,7 @@ static unsigned long balance_pgdat(pg_da
 
 loop_again:
 	total_scanned = 0;
-	nr_reclaimed = 0;
+	sc.nr_reclaimed = 0;
 	sc.may_writepage = !laptop_mode;
 	count_vm_event(PAGEOUTRUN);
 
@@ -1809,11 +1814,11 @@ loop_again:
 			 */
 			if (!zone_watermark_ok(zone, order, 8*zone->pages_high,
 						end_zone, 0))
-				nr_reclaimed += shrink_zone(priority, zone, &sc);
+				shrink_zone(priority, zone, &sc);
 			reclaim_state->reclaimed_slab = 0;
 			nr_slab = shrink_slab(sc.nr_scanned, GFP_KERNEL,
 						lru_pages);
-			nr_reclaimed += reclaim_state->reclaimed_slab;
+			sc.nr_reclaimed += reclaim_state->reclaimed_slab;
 			total_scanned += sc.nr_scanned;
 			if (zone_is_all_unreclaimable(zone))
 				continue;
@@ -1827,7 +1832,7 @@ loop_again:
 			 * even in laptop mode
 			 */
 			if (total_scanned > SWAP_CLUSTER_MAX * 2 &&
-			    total_scanned > nr_reclaimed + nr_reclaimed / 2)
+			    total_scanned > sc.nr_reclaimed + sc.nr_reclaimed / 2)
 				sc.may_writepage = 1;
 		}
 		if (all_zones_ok)
@@ -1845,7 +1850,7 @@ loop_again:
 		 * matches the direct reclaim path behaviour in terms of impact
 		 * on zone->*_priority.
 		 */
-		if (nr_reclaimed >= SWAP_CLUSTER_MAX)
+		if (sc.nr_reclaimed >= SWAP_CLUSTER_MAX)
 			break;
 	}
 out:
@@ -1867,7 +1872,7 @@ out:
 		goto loop_again;
 	}
 
-	return nr_reclaimed;
+	return sc.nr_reclaimed;
 }
 
 /*
@@ -2219,7 +2224,6 @@ static int __zone_reclaim(struct zone *z
 	struct task_struct *p = current;
 	struct reclaim_state reclaim_state;
 	int priority;
-	unsigned long nr_reclaimed = 0;
 	struct scan_control sc = {
 		.may_writepage = !!(zone_reclaim_mode & RECLAIM_WRITE),
 		.may_swap = !!(zone_reclaim_mode & RECLAIM_SWAP),
@@ -2252,9 +2256,9 @@ static int __zone_reclaim(struct zone *z
 		priority = ZONE_RECLAIM_PRIORITY;
 		do {
 			note_zone_scanning_priority(zone, priority);
-			nr_reclaimed += shrink_zone(priority, zone, &sc);
+			shrink_zone(priority, zone, &sc);
 			priority--;
-		} while (priority >= 0 && nr_reclaimed < nr_pages);
+		} while (priority >= 0 && sc.nr_reclaimed < nr_pages);
 	}
 
 	slab_reclaimable = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
@@ -2278,13 +2282,13 @@ static int __zone_reclaim(struct zone *z
 		 * Update nr_reclaimed by the number of slab pages we
 		 * reclaimed from this zone.
 		 */
-		nr_reclaimed += slab_reclaimable -
+		sc.nr_reclaimed += slab_reclaimable -
 			zone_page_state(zone, NR_SLAB_RECLAIMABLE);
 	}
 
 	p->reclaim_state = NULL;
 	current->flags &= ~(PF_MEMALLOC | PF_SWAPWRITE);
-	return nr_reclaimed >= nr_pages;
+	return sc.nr_reclaimed >= nr_pages;
 }
 
 int zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
mm-fix-pdflush-thread-creation-upper-bound.patch
mm-add-proc-controls-for-pdflush-threads.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch

