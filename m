From: akpm@linux-foundation.org
Subject: [merged] mm-restore-zone-all_unreclaimable-to-independence-word.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:03:38 -0800
Message-ID: <201003091903.o29J3c2n030979@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755699Ab0CITDs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:03:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, rientjes@google.com, shijie8@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: restore zone->all_unreclaimable to independence word
has been removed from the -mm tree.  Its filename was
     mm-restore-zone-all_unreclaimable-to-independence-word.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: restore zone->all_unreclaimable to independence word
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit e815af95 ("change all_unreclaimable zone member to flags") changed
all_unreclaimable member to bit flag.  But it had an undesireble side
effect.  free_one_page() is one of most hot path in linux kernel and
increasing atomic ops in it can reduce kernel performance a bit.

Thus, this patch revert such commit partially. at least
all_unreclaimable shouldn't share memory word with other zone flags.

[akpm@linux-foundation.org: fix patch interaction]
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Huang Shijie <shijie8@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    7 +------
 mm/page_alloc.c        |    6 +++---
 mm/vmscan.c            |   22 +++++++++-------------
 mm/vmstat.c            |    2 +-
 4 files changed, 14 insertions(+), 23 deletions(-)

diff -puN include/linux/mmzone.h~mm-restore-zone-all_unreclaimable-to-independence-word include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-restore-zone-all_unreclaimable-to-independence-word
+++ a/include/linux/mmzone.h
@@ -306,6 +306,7 @@ struct zone {
 	 * free areas of different sizes
 	 */
 	spinlock_t		lock;
+	int                     all_unreclaimable; /* All pages pinned */
 #ifdef CONFIG_MEMORY_HOTPLUG
 	/* see spanned/present_pages for more description */
 	seqlock_t		span_seqlock;
@@ -417,7 +418,6 @@ struct zone {
 } ____cacheline_internodealigned_in_smp;
 
 typedef enum {
-	ZONE_ALL_UNRECLAIMABLE,		/* all pages pinned */
 	ZONE_RECLAIM_LOCKED,		/* prevents concurrent reclaim */
 	ZONE_OOM_LOCKED,		/* zone is in OOM killer zonelist */
 } zone_flags_t;
@@ -437,11 +437,6 @@ static inline void zone_clear_flag(struc
 	clear_bit(flag, &zone->flags);
 }
 
-static inline int zone_is_all_unreclaimable(const struct zone *zone)
-{
-	return test_bit(ZONE_ALL_UNRECLAIMABLE, &zone->flags);
-}
-
 static inline int zone_is_reclaim_locked(const struct zone *zone)
 {
 	return test_bit(ZONE_RECLAIM_LOCKED, &zone->flags);
diff -puN mm/page_alloc.c~mm-restore-zone-all_unreclaimable-to-independence-word mm/page_alloc.c
--- a/mm/page_alloc.c~mm-restore-zone-all_unreclaimable-to-independence-word
+++ a/mm/page_alloc.c
@@ -530,7 +530,7 @@ static void free_pcppages_bulk(struct zo
 	int batch_free = 0;
 
 	spin_lock(&zone->lock);
-	zone_clear_flag(zone, ZONE_ALL_UNRECLAIMABLE);
+	zone->all_unreclaimable = 0;
 	zone->pages_scanned = 0;
 
 	__mod_zone_page_state(zone, NR_FREE_PAGES, count);
@@ -568,7 +568,7 @@ static void free_one_page(struct zone *z
 				int migratetype)
 {
 	spin_lock(&zone->lock);
-	zone_clear_flag(zone, ZONE_ALL_UNRECLAIMABLE);
+	zone->all_unreclaimable = 0;
 	zone->pages_scanned = 0;
 
 	__mod_zone_page_state(zone, NR_FREE_PAGES, 1 << order);
@@ -2262,7 +2262,7 @@ void show_free_areas(void)
 			K(zone_page_state(zone, NR_BOUNCE)),
 			K(zone_page_state(zone, NR_WRITEBACK_TEMP)),
 			zone->pages_scanned,
-			(zone_is_all_unreclaimable(zone) ? "yes" : "no")
+			(zone->all_unreclaimable ? "yes" : "no")
 			);
 		printk("lowmem_reserve[]:");
 		for (i = 0; i < MAX_NR_ZONES; i++)
diff -puN mm/vmscan.c~mm-restore-zone-all_unreclaimable-to-independence-word mm/vmscan.c
--- a/mm/vmscan.c~mm-restore-zone-all_unreclaimable-to-independence-word
+++ a/mm/vmscan.c
@@ -1699,8 +1699,7 @@ static void shrink_zones(int priority, s
 				continue;
 			note_zone_scanning_priority(zone, priority);
 
-			if (zone_is_all_unreclaimable(zone) &&
-						priority != DEF_PRIORITY)
+			if (zone->all_unreclaimable && priority != DEF_PRIORITY)
 				continue;	/* Let kswapd poll it */
 			sc->all_unreclaimable = 0;
 		} else {
@@ -1927,7 +1926,7 @@ static int sleeping_prematurely(pg_data_
 		if (!populated_zone(zone))
 			continue;
 
-		if (zone_is_all_unreclaimable(zone))
+		if (zone->all_unreclaimable)
 			continue;
 
 		if (!zone_watermark_ok(zone, order, high_wmark_pages(zone),
@@ -2017,8 +2016,7 @@ loop_again:
 			if (!populated_zone(zone))
 				continue;
 
-			if (zone_is_all_unreclaimable(zone) &&
-			    priority != DEF_PRIORITY)
+			if (zone->all_unreclaimable && priority != DEF_PRIORITY)
 				continue;
 
 			/*
@@ -2061,8 +2059,7 @@ loop_again:
 			if (!populated_zone(zone))
 				continue;
 
-			if (zone_is_all_unreclaimable(zone) &&
-					priority != DEF_PRIORITY)
+			if (zone->all_unreclaimable && priority != DEF_PRIORITY)
 				continue;
 
 			temp_priority[i] = priority;
@@ -2089,12 +2086,11 @@ loop_again:
 						lru_pages);
 			sc.nr_reclaimed += reclaim_state->reclaimed_slab;
 			total_scanned += sc.nr_scanned;
-			if (zone_is_all_unreclaimable(zone))
+			if (zone->all_unreclaimable)
 				continue;
-			if (nr_slab == 0 && zone->pages_scanned >=
-					(zone_reclaimable_pages(zone) * 6))
-					zone_set_flag(zone,
-						      ZONE_ALL_UNRECLAIMABLE);
+			if (nr_slab == 0 &&
+			    zone->pages_scanned >= (zone_reclaimable_pages(zone) * 6))
+				zone->all_unreclaimable = 1;
 			/*
 			 * If we've done a decent amount of scanning and
 			 * the reclaim ratio is low, start doing writepage
@@ -2624,7 +2620,7 @@ int zone_reclaim(struct zone *zone, gfp_
 	    zone_page_state(zone, NR_SLAB_RECLAIMABLE) <= zone->min_slab_pages)
 		return ZONE_RECLAIM_FULL;
 
-	if (zone_is_all_unreclaimable(zone))
+	if (zone->all_unreclaimable)
 		return ZONE_RECLAIM_FULL;
 
 	/*
diff -puN mm/vmstat.c~mm-restore-zone-all_unreclaimable-to-independence-word mm/vmstat.c
--- a/mm/vmstat.c~mm-restore-zone-all_unreclaimable-to-independence-word
+++ a/mm/vmstat.c
@@ -763,7 +763,7 @@ static void zoneinfo_show_print(struct s
 		   "\n  prev_priority:     %i"
 		   "\n  start_pfn:         %lu"
 		   "\n  inactive_ratio:    %u",
-			   zone_is_all_unreclaimable(zone),
+		   zone->all_unreclaimable,
 		   zone->prev_priority,
 		   zone->zone_start_pfn,
 		   zone->inactive_ratio);
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

prctl-add-pr_set_proctitle_area-option-for-prctl.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
memcg-move-charges-of-anonymous-swap-fix-2.patch
sysctl-clean-up-vm-related-variable-declarations.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch
reiser4.patch

