From: akpm@linux-foundation.org
Subject: + vmscan-bail-out-of-direct-reclaim-after-swap_cluster_max-pages.patch added to -mm tree
Date: Fri, 28 Nov 2008 23:29:28 -0800
Message-ID: <200811290729.mAT7TSWx021185@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40909 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750865AbYK2H3q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 29 Nov 2008 02:29:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com


The patch titled
     vmscan: bail out of direct reclaim after swap_cluster_max pages
has been added to the -mm tree.  Its filename is
     vmscan-bail-out-of-direct-reclaim-after-swap_cluster_max-pages.patch

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
 
@@ -1447,12 +1450,11 @@ static void get_scan_ratio(struct zone *
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
 
@@ -1493,10 +1495,21 @@ static unsigned long shrink_zone(int pri
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
@@ -1509,7 +1522,6 @@ static unsigned long shrink_zone(int pri
 		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
 
 	throttle_vm_writeout(sc->gfp_mask);
-	return nr_reclaimed;
 }
 
 /*
@@ -1523,16 +1535,13 @@ static unsigned long shrink_zone(int pri
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
 
@@ -1563,10 +1572,8 @@ static unsigned long shrink_zones(int pr
 							priority);
 		}
 
-		nr_reclaimed += shrink_zone(priority, zone, sc);
+		shrink_zone(priority, zone, sc);
 	}
-
-	return nr_reclaimed;
 }
 
 /*
@@ -1591,7 +1598,6 @@ static unsigned long do_try_to_free_page
 	int priority;
 	unsigned long ret = 0;
 	unsigned long total_scanned = 0;
-	unsigned long nr_reclaimed = 0;
 	struct reclaim_state *reclaim_state = current->reclaim_state;
 	unsigned long lru_pages = 0;
 	struct zoneref *z;
@@ -1619,7 +1625,7 @@ static unsigned long do_try_to_free_page
 		sc->nr_scanned = 0;
 		if (!priority)
 			disable_swap_token();
-		nr_reclaimed += shrink_zones(priority, zonelist, sc);
+		shrink_zones(priority, zonelist, sc);
 		/*
 		 * Don't shrink slabs when reclaiming memory from
 		 * over limit cgroups
@@ -1627,13 +1633,13 @@ static unsigned long do_try_to_free_page
 		if (scan_global_lru(sc)) {
 			shrink_slab(sc->nr_scanned, sc->gfp_mask, lru_pages, NULL);
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
 
@@ -1656,7 +1662,7 @@ static unsigned long do_try_to_free_page
 	}
 	/* top priority shrink_zones still had more to do? don't OOM, then */
 	if (!sc->all_unreclaimable && scan_global_lru(sc))
-		ret = nr_reclaimed;
+		ret = sc->nr_reclaimed;
 out:
 	/*
 	 * Now that we've scanned all the zones at this priority level, note
@@ -1751,7 +1757,6 @@ static unsigned long balance_pgdat(pg_da
 	int priority;
 	int i;
 	unsigned long total_scanned;
-	unsigned long nr_reclaimed;
 	struct reclaim_state *reclaim_state = current->reclaim_state;
 	struct scan_control sc = {
 		.gfp_mask = GFP_KERNEL,
@@ -1770,7 +1775,7 @@ static unsigned long balance_pgdat(pg_da
 
 loop_again:
 	total_scanned = 0;
-	nr_reclaimed = 0;
+	sc.nr_reclaimed = 0;
 	sc.may_writepage = !laptop_mode;
 	count_vm_event(PAGEOUTRUN);
 
@@ -1856,11 +1861,11 @@ loop_again:
 			 */
 			if (!zone_watermark_ok(zone, order, 8*zone->pages_high,
 						end_zone, 0))
-				nr_reclaimed += shrink_zone(priority, zone, &sc);
+				shrink_zone(priority, zone, &sc);
 			reclaim_state->reclaimed_slab = 0;
 			nr_slab = shrink_slab(sc.nr_scanned, GFP_KERNEL,
 						lru_pages, zone);
-			nr_reclaimed += reclaim_state->reclaimed_slab;
+			sc.nr_reclaimed += reclaim_state->reclaimed_slab;
 			total_scanned += sc.nr_scanned;
 			if (zone_is_all_unreclaimable(zone))
 				continue;
@@ -1874,7 +1879,7 @@ loop_again:
 			 * even in laptop mode
 			 */
 			if (total_scanned > SWAP_CLUSTER_MAX * 2 &&
-			    total_scanned > nr_reclaimed + nr_reclaimed / 2)
+			    total_scanned > sc.nr_reclaimed + sc.nr_reclaimed / 2)
 				sc.may_writepage = 1;
 		}
 		if (all_zones_ok)
@@ -1892,7 +1897,7 @@ loop_again:
 		 * matches the direct reclaim path behaviour in terms of impact
 		 * on zone->*_priority.
 		 */
-		if (nr_reclaimed >= SWAP_CLUSTER_MAX)
+		if (sc.nr_reclaimed >= SWAP_CLUSTER_MAX)
 			break;
 	}
 out:
@@ -1914,7 +1919,7 @@ out:
 		goto loop_again;
 	}
 
-	return nr_reclaimed;
+	return sc.nr_reclaimed;
 }
 
 /*
@@ -2266,7 +2271,6 @@ static int __zone_reclaim(struct zone *z
 	struct task_struct *p = current;
 	struct reclaim_state reclaim_state;
 	int priority;
-	unsigned long nr_reclaimed = 0;
 	struct scan_control sc = {
 		.may_writepage = !!(zone_reclaim_mode & RECLAIM_WRITE),
 		.may_swap = !!(zone_reclaim_mode & RECLAIM_SWAP),
@@ -2299,9 +2303,9 @@ static int __zone_reclaim(struct zone *z
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
@@ -2326,13 +2330,13 @@ static int __zone_reclaim(struct zone *z
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

linux-next.patch
vmscan-evict-streaming-io-first.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-add_active_or_unevictable-into-rmap.patch
mm-further-cleanup-page_add_new_anon_rmap.patch
mm-gup-persist-for-write-permission.patch
mm-wp-lock-page-before-deciding-cow.patch
mm-reuse_swap_page-replaces-can_share_swap_page.patch
mm-try_to_free_swap-replaces-remove_exclusive_swap_page.patch
mm-try_to_unuse-check-removing-right-swap.patch
mm-remove-try_to_munlock-from-vmscan.patch
mm-remove-gfp_mask-from-add_to_swap.patch
mm-add-add_to_swap-stub.patch
mm-optimize-get_scan_ratio-for-no-swap.patch
memcg-reclaim-shouldnt-change-zone-recent_rotated-statistics.patch
vmscan-bail-out-of-direct-reclaim-after-swap_cluster_max-pages.patch

