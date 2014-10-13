From: akpm@linux-foundation.org
Subject: [merged] mm-clean-up-zone-flags.patch removed from -mm tree
Date: Mon, 13 Oct 2014 11:20:35 -0700
Message-ID: <543c17f3.d8fiEwYT0Fca0AlB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60621 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592AbaJMSUf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:20:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mgorman@suse.de, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: clean up zone flags
has been removed from the -mm tree.  Its filename was
     mm-clean-up-zone-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: clean up zone flags

Page reclaim tests zone_is_reclaim_dirty(), but the site that actually
sets this state does zone_set_flag(zone, ZONE_TAIL_LRU_DIRTY), sending the
reader through layers indirection just to track down a simple bit.

Remove all zone flag wrappers and just use bitops against zone->flags
directly.  It's just as readable and the lines are barely any longer.

Also rename ZONE_TAIL_LRU_DIRTY to ZONE_DIRTY to match ZONE_WRITEBACK, and
remove the zone_flags_t typedef.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   51 ++-------------------------------------
 mm/backing-dev.c       |    2 -
 mm/oom_kill.c          |    6 ++--
 mm/page_alloc.c        |    8 +++---
 mm/vmscan.c            |   28 ++++++++++-----------
 5 files changed, 25 insertions(+), 70 deletions(-)

diff -puN include/linux/mmzone.h~mm-clean-up-zone-flags include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-clean-up-zone-flags
+++ a/include/linux/mmzone.h
@@ -521,13 +521,13 @@ struct zone {
 	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
 } ____cacheline_internodealigned_in_smp;
 
-typedef enum {
+enum zone_flags {
 	ZONE_RECLAIM_LOCKED,		/* prevents concurrent reclaim */
 	ZONE_OOM_LOCKED,		/* zone is in OOM killer zonelist */
 	ZONE_CONGESTED,			/* zone has many dirty pages backed by
 					 * a congested BDI
 					 */
-	ZONE_TAIL_LRU_DIRTY,		/* reclaim scanning has recently found
+	ZONE_DIRTY,			/* reclaim scanning has recently found
 					 * many dirty file pages at the tail
 					 * of the LRU.
 					 */
@@ -535,52 +535,7 @@ typedef enum {
 					 * many pages under writeback
 					 */
 	ZONE_FAIR_DEPLETED,		/* fair zone policy batch depleted */
-} zone_flags_t;
-
-static inline void zone_set_flag(struct zone *zone, zone_flags_t flag)
-{
-	set_bit(flag, &zone->flags);
-}
-
-static inline int zone_test_and_set_flag(struct zone *zone, zone_flags_t flag)
-{
-	return test_and_set_bit(flag, &zone->flags);
-}
-
-static inline void zone_clear_flag(struct zone *zone, zone_flags_t flag)
-{
-	clear_bit(flag, &zone->flags);
-}
-
-static inline int zone_is_reclaim_congested(const struct zone *zone)
-{
-	return test_bit(ZONE_CONGESTED, &zone->flags);
-}
-
-static inline int zone_is_reclaim_dirty(const struct zone *zone)
-{
-	return test_bit(ZONE_TAIL_LRU_DIRTY, &zone->flags);
-}
-
-static inline int zone_is_reclaim_writeback(const struct zone *zone)
-{
-	return test_bit(ZONE_WRITEBACK, &zone->flags);
-}
-
-static inline int zone_is_reclaim_locked(const struct zone *zone)
-{
-	return test_bit(ZONE_RECLAIM_LOCKED, &zone->flags);
-}
-
-static inline int zone_is_fair_depleted(const struct zone *zone)
-{
-	return test_bit(ZONE_FAIR_DEPLETED, &zone->flags);
-}
-
-static inline int zone_is_oom_locked(const struct zone *zone)
-{
-	return test_bit(ZONE_OOM_LOCKED, &zone->flags);
-}
+};
 
 static inline unsigned long zone_end_pfn(const struct zone *zone)
 {
diff -puN mm/backing-dev.c~mm-clean-up-zone-flags mm/backing-dev.c
--- a/mm/backing-dev.c~mm-clean-up-zone-flags
+++ a/mm/backing-dev.c
@@ -631,7 +631,7 @@ long wait_iff_congested(struct zone *zon
 	 * of sleeping on the congestion queue
 	 */
 	if (atomic_read(&nr_bdi_congested[sync]) == 0 ||
-			!zone_is_reclaim_congested(zone)) {
+	    !test_bit(ZONE_CONGESTED, &zone->flags)) {
 		cond_resched();
 
 		/* In case we scheduled, work out time remaining */
diff -puN mm/oom_kill.c~mm-clean-up-zone-flags mm/oom_kill.c
--- a/mm/oom_kill.c~mm-clean-up-zone-flags
+++ a/mm/oom_kill.c
@@ -565,7 +565,7 @@ bool oom_zonelist_trylock(struct zonelis
 
 	spin_lock(&zone_scan_lock);
 	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask))
-		if (zone_is_oom_locked(zone)) {
+		if (test_bit(ZONE_OOM_LOCKED, &zone->flags)) {
 			ret = false;
 			goto out;
 		}
@@ -575,7 +575,7 @@ bool oom_zonelist_trylock(struct zonelis
 	 * call to oom_zonelist_trylock() doesn't succeed when it shouldn't.
 	 */
 	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask))
-		zone_set_flag(zone, ZONE_OOM_LOCKED);
+		set_bit(ZONE_OOM_LOCKED, &zone->flags);
 
 out:
 	spin_unlock(&zone_scan_lock);
@@ -594,7 +594,7 @@ void oom_zonelist_unlock(struct zonelist
 
 	spin_lock(&zone_scan_lock);
 	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask))
-		zone_clear_flag(zone, ZONE_OOM_LOCKED);
+		clear_bit(ZONE_OOM_LOCKED, &zone->flags);
 	spin_unlock(&zone_scan_lock);
 }
 
diff -puN mm/page_alloc.c~mm-clean-up-zone-flags mm/page_alloc.c
--- a/mm/page_alloc.c~mm-clean-up-zone-flags
+++ a/mm/page_alloc.c
@@ -1614,8 +1614,8 @@ again:
 
 	__mod_zone_page_state(zone, NR_ALLOC_BATCH, -(1 << order));
 	if (atomic_long_read(&zone->vm_stat[NR_ALLOC_BATCH]) <= 0 &&
-	    !zone_is_fair_depleted(zone))
-		zone_set_flag(zone, ZONE_FAIR_DEPLETED);
+	    !test_bit(ZONE_FAIR_DEPLETED, &zone->flags))
+		set_bit(ZONE_FAIR_DEPLETED, &zone->flags);
 
 	__count_zone_vm_events(PGALLOC, zone, 1 << order);
 	zone_statistics(preferred_zone, zone, gfp_flags);
@@ -1935,7 +1935,7 @@ static void reset_alloc_batches(struct z
 		mod_zone_page_state(zone, NR_ALLOC_BATCH,
 			high_wmark_pages(zone) - low_wmark_pages(zone) -
 			atomic_long_read(&zone->vm_stat[NR_ALLOC_BATCH]));
-		zone_clear_flag(zone, ZONE_FAIR_DEPLETED);
+		clear_bit(ZONE_FAIR_DEPLETED, &zone->flags);
 	} while (zone++ != preferred_zone);
 }
 
@@ -1986,7 +1986,7 @@ zonelist_scan:
 		if (alloc_flags & ALLOC_FAIR) {
 			if (!zone_local(preferred_zone, zone))
 				break;
-			if (zone_is_fair_depleted(zone)) {
+			if (test_bit(ZONE_FAIR_DEPLETED, &zone->flags)) {
 				nr_fair_skipped++;
 				continue;
 			}
diff -puN mm/vmscan.c~mm-clean-up-zone-flags mm/vmscan.c
--- a/mm/vmscan.c~mm-clean-up-zone-flags
+++ a/mm/vmscan.c
@@ -920,7 +920,7 @@ static unsigned long shrink_page_list(st
 			/* Case 1 above */
 			if (current_is_kswapd() &&
 			    PageReclaim(page) &&
-			    zone_is_reclaim_writeback(zone)) {
+			    test_bit(ZONE_WRITEBACK, &zone->flags)) {
 				nr_immediate++;
 				goto keep_locked;
 
@@ -1002,7 +1002,7 @@ static unsigned long shrink_page_list(st
 			 */
 			if (page_is_file_cache(page) &&
 					(!current_is_kswapd() ||
-					 !zone_is_reclaim_dirty(zone))) {
+					 !test_bit(ZONE_DIRTY, &zone->flags))) {
 				/*
 				 * Immediately reclaim when written back.
 				 * Similar in principal to deactivate_page()
@@ -1563,7 +1563,7 @@ shrink_inactive_list(unsigned long nr_to
 	 * are encountered in the nr_immediate check below.
 	 */
 	if (nr_writeback && nr_writeback == nr_taken)
-		zone_set_flag(zone, ZONE_WRITEBACK);
+		set_bit(ZONE_WRITEBACK, &zone->flags);
 
 	/*
 	 * memcg will stall in page writeback so only consider forcibly
@@ -1575,16 +1575,16 @@ shrink_inactive_list(unsigned long nr_to
 		 * backed by a congested BDI and wait_iff_congested will stall.
 		 */
 		if (nr_dirty && nr_dirty == nr_congested)
-			zone_set_flag(zone, ZONE_CONGESTED);
+			set_bit(ZONE_CONGESTED, &zone->flags);
 
 		/*
 		 * If dirty pages are scanned that are not queued for IO, it
 		 * implies that flushers are not keeping up. In this case, flag
-		 * the zone ZONE_TAIL_LRU_DIRTY and kswapd will start writing
-		 * pages from reclaim context.
+		 * the zone ZONE_DIRTY and kswapd will start writing pages from
+		 * reclaim context.
 		 */
 		if (nr_unqueued_dirty == nr_taken)
-			zone_set_flag(zone, ZONE_TAIL_LRU_DIRTY);
+			set_bit(ZONE_DIRTY, &zone->flags);
 
 		/*
 		 * If kswapd scans pages marked marked for immediate
@@ -2984,7 +2984,7 @@ static bool kswapd_shrink_zone(struct zo
 	/* Account for the number of pages attempted to reclaim */
 	*nr_attempted += sc->nr_to_reclaim;
 
-	zone_clear_flag(zone, ZONE_WRITEBACK);
+	clear_bit(ZONE_WRITEBACK, &zone->flags);
 
 	/*
 	 * If a zone reaches its high watermark, consider it to be no longer
@@ -2994,8 +2994,8 @@ static bool kswapd_shrink_zone(struct zo
 	 */
 	if (zone_reclaimable(zone) &&
 	    zone_balanced(zone, testorder, 0, classzone_idx)) {
-		zone_clear_flag(zone, ZONE_CONGESTED);
-		zone_clear_flag(zone, ZONE_TAIL_LRU_DIRTY);
+		clear_bit(ZONE_CONGESTED, &zone->flags);
+		clear_bit(ZONE_DIRTY, &zone->flags);
 	}
 
 	return sc->nr_scanned >= sc->nr_to_reclaim;
@@ -3086,8 +3086,8 @@ static unsigned long balance_pgdat(pg_da
 				 * If balanced, clear the dirty and congested
 				 * flags
 				 */
-				zone_clear_flag(zone, ZONE_CONGESTED);
-				zone_clear_flag(zone, ZONE_TAIL_LRU_DIRTY);
+				clear_bit(ZONE_CONGESTED, &zone->flags);
+				clear_bit(ZONE_DIRTY, &zone->flags);
 			}
 		}
 
@@ -3714,11 +3714,11 @@ int zone_reclaim(struct zone *zone, gfp_
 	if (node_state(node_id, N_CPU) && node_id != numa_node_id())
 		return ZONE_RECLAIM_NOSCAN;
 
-	if (zone_test_and_set_flag(zone, ZONE_RECLAIM_LOCKED))
+	if (test_and_set_bit(ZONE_RECLAIM_LOCKED, &zone->flags))
 		return ZONE_RECLAIM_NOSCAN;
 
 	ret = __zone_reclaim(zone, gfp_mask, order);
-	zone_clear_flag(zone, ZONE_RECLAIM_LOCKED);
+	clear_bit(ZONE_RECLAIM_LOCKED, &zone->flags);
 
 	if (!ret)
 		count_vm_event(PGSCAN_ZONE_RECLAIM_FAILED);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

