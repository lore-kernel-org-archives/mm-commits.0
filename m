From: akpm@linux-foundation.org
Subject: + mm-vmscan-fix-do_try_to_free_pages-livelock.patch added to -mm
 tree
Date: Tue, 20 Aug 2013 15:16:38 -0700
Message-ID: <5213eac6.Ob4O3nE7DHYEtqm/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38303 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab3HTWQk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Aug 2013 18:16:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangwm@marvell.com, yinghan@google.com, riel@redhat.com, npiggin@gmail.com, minchan@kernel.org, mhocko@suse.cz, mel@csn.ul.ie, lliubbo@gmail.com, linux@arm.linux.org.uk, kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, cl@linux.com, aaditya.kumar.30@gmail.com, cldu@marvell.com

Subject: + mm-vmscan-fix-do_try_to_free_pages-livelock.patch added to -mm tree
To: cldu@marvell.com,aaditya.kumar.30@gmail.com,cl@linux.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,linux@arm.linux.org.uk,lliubbo@gmail.com,mel@csn.ul.ie,mhocko@suse.cz,minchan@kernel.org,npiggin@gmail.com,riel@redhat.com,yinghan@google.com,zhangwm@marvell.com
From: akpm@linux-foundation.org
Date: Tue, 20 Aug 2013 15:16:38 -0700


The patch titled
     Subject: mm: vmscan: fix do_try_to_free_pages() livelock
has been added to the -mm tree.  Its filename is
     mm-vmscan-fix-do_try_to_free_pages-livelock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-fix-do_try_to_free_pages-livelock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-fix-do_try_to_free_pages-livelock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lisa Du <cldu@marvell.com>
Subject: mm: vmscan: fix do_try_to_free_pages() livelock

This patch is based on KOSAKI's work and I add a little more description,
please refer https://lkml.org/lkml/2012/6/14/74.

Currently, I found system can enter a state that there are lots of free
pages in a zone but only order-0 and order-1 pages which means the zone is
heavily fragmented, then high order allocation could make direct reclaim
path's long stall(ex, 60 seconds) especially in no swap and no compaciton
enviroment.  This problem happened on v3.4, but it seems issue still lives
in current tree, the reason is do_try_to_free_pages enter live lock:

kswapd will go to sleep if the zones have been fully scanned and are still
not balanced.  As kswapd thinks there's little point trying all over again
to avoid infinite loop.  Instead it changes order from high-order to
0-order because kswapd think order-0 is the most important.  Look at
73ce02e9 in detail.  If watermarks are ok, kswapd will go back to sleep
and may leave zone->all_unreclaimable =3D 0.  It assume high-order users
can still perform direct reclaim if they wish.

Direct reclaim continue to reclaim for a high order which is not a
COSTLY_ORDER without oom-killer until kswapd turn on
zone->all_unreclaimble= .  This is because to avoid too early oom-kill. 
So it means direct_reclaim depends on kswapd to break this loop.

In worst case, direct-reclaim may continue to page reclaim forever when
kswapd sleeps forever until someone like watchdog detect and finally kill
the process.  As described in:
http://thread.gmane.org/gmane.linux.kernel.mm/103737

We can't turn on zone->all_unreclaimable from direct reclaim path because
direct reclaim path don't take any lock and this way is racy.  Thus this
patch removes zone->all_unreclaimable field completely and recalculates
zone reclaimable state every time.

Note: we can't take the idea that direct-reclaim see zone->pages_scanned
directly and kswapd continue to use zone->all_unreclaimable.  Because, it
is racy.  commit 929bea7c71 (vmscan: all_unreclaimable() use
zone->all_unreclaimable as a name) describes the detail.

Cc: Aaditya Kumar <aaditya.kumar.30@gmail.com>
Cc: Ying Han <yinghan@google.com>
Cc: Nick Piggin <npiggin@gmail.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Bob Liu <lliubbo@gmail.com>
Cc: Neil Zhang <zhangwm@marvell.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Lisa Du <cldu@marvell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   20 +++++++++++++++
 include/linux/mmzone.h    |    1 
 include/linux/vmstat.h    |    1 
 mm/page-writeback.c       |    1 
 mm/page_alloc.c           |    5 +--
 mm/vmscan.c               |   47 +++++++++---------------------------
 mm/vmstat.c               |    3 +-
 7 files changed, 37 insertions(+), 41 deletions(-)

diff -puN include/linux/mm_inline.h~mm-vmscan-fix-do_try_to_free_pages-livelock include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~mm-vmscan-fix-do_try_to_free_pages-livelock
+++ a/include/linux/mm_inline.h
@@ -2,6 +2,7 @@
 #define LINUX_MM_INLINE_H
 
 #include <linux/huge_mm.h>
+#include <linux/swap.h>
 
 /**
  * page_is_file_cache - should the page be on a file LRU or anon LRU?
@@ -99,4 +100,23 @@ static __always_inline enum lru_list pag
 	return lru;
 }
 
+static inline unsigned long zone_reclaimable_pages(struct zone *zone)
+{
+	int nr;
+
+	nr = zone_page_state(zone, NR_ACTIVE_FILE) +
+	     zone_page_state(zone, NR_INACTIVE_FILE);
+
+	if (get_nr_swap_pages() > 0)
+		nr += zone_page_state(zone, NR_ACTIVE_ANON) +
+		      zone_page_state(zone, NR_INACTIVE_ANON);
+
+	return nr;
+}
+
+static inline bool zone_reclaimable(struct zone *zone)
+{
+	return zone->pages_scanned < zone_reclaimable_pages(zone) * 6;
+}
+
 #endif
diff -puN include/linux/mmzone.h~mm-vmscan-fix-do_try_to_free_pages-livelock include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-vmscan-fix-do_try_to_free_pages-livelock
+++ a/include/linux/mmzone.h
@@ -353,7 +353,6 @@ struct zone {
 	 * free areas of different sizes
 	 */
 	spinlock_t		lock;
-	int                     all_unreclaimable; /* All pages pinned */
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 	/* Set to true when the PG_migrate_skip bits should be cleared */
 	bool			compact_blockskip_flush;
diff -puN include/linux/vmstat.h~mm-vmscan-fix-do_try_to_free_pages-livelock include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-vmscan-fix-do_try_to_free_pages-livelock
+++ a/include/linux/vmstat.h
@@ -143,7 +143,6 @@ static inline unsigned long zone_page_st
 }
 
 extern unsigned long global_reclaimable_pages(void);
-extern unsigned long zone_reclaimable_pages(struct zone *zone);
 
 #ifdef CONFIG_NUMA
 /*
diff -puN mm/page-writeback.c~mm-vmscan-fix-do_try_to_free_pages-livelock mm/page-writeback.c
--- a/mm/page-writeback.c~mm-vmscan-fix-do_try_to_free_pages-livelock
+++ a/mm/page-writeback.c
@@ -36,6 +36,7 @@
 #include <linux/pagevec.h>
 #include <linux/timer.h>
 #include <linux/sched/rt.h>
+#include <linux/mm_inline.h>
 #include <trace/events/writeback.h>
 
 /*
diff -puN mm/page_alloc.c~mm-vmscan-fix-do_try_to_free_pages-livelock mm/page_alloc.c
--- a/mm/page_alloc.c~mm-vmscan-fix-do_try_to_free_pages-livelock
+++ a/mm/page_alloc.c
@@ -56,6 +56,7 @@
 #include <linux/ftrace_event.h>
 #include <linux/memcontrol.h>
 #include <linux/prefetch.h>
+#include <linux/mm_inline.h>
 #include <linux/migrate.h>
 #include <linux/page-debug-flags.h>
 #include <linux/hugetlb.h>
@@ -648,7 +649,6 @@ static void free_pcppages_bulk(struct zo
 	int to_free = count;
 
 	spin_lock(&zone->lock);
-	zone->all_unreclaimable = 0;
 	zone->pages_scanned = 0;
 
 	while (to_free) {
@@ -697,7 +697,6 @@ static void free_one_page(struct zone *z
 				int migratetype)
 {
 	spin_lock(&zone->lock);
-	zone->all_unreclaimable = 0;
 	zone->pages_scanned = 0;
 
 	__free_one_page(page, zone, order, migratetype);
@@ -3165,7 +3164,7 @@ void show_free_areas(unsigned int filter
 			K(zone_page_state(zone, NR_FREE_CMA_PAGES)),
 			K(zone_page_state(zone, NR_WRITEBACK_TEMP)),
 			zone->pages_scanned,
-			(zone->all_unreclaimable ? "yes" : "no")
+			(!zone_reclaimable(zone) ? "yes" : "no")
 			);
 		printk("lowmem_reserve[]:");
 		for (i = 0; i < MAX_NR_ZONES; i++)
diff -puN mm/vmscan.c~mm-vmscan-fix-do_try_to_free_pages-livelock mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-fix-do_try_to_free_pages-livelock
+++ a/mm/vmscan.c
@@ -1789,7 +1789,7 @@ static void get_scan_count(struct lruvec
 	 * latencies, so it's better to scan a minimum amount there as
 	 * well.
 	 */
-	if (current_is_kswapd() && zone->all_unreclaimable)
+	if (current_is_kswapd() && !zone_reclaimable(zone))
 		force_scan = true;
 	if (!global_reclaim(sc))
 		force_scan = true;
@@ -2244,8 +2244,8 @@ static bool shrink_zones(struct zonelist
 		if (global_reclaim(sc)) {
 			if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
 				continue;
-			if (zone->all_unreclaimable &&
-					sc->priority != DEF_PRIORITY)
+			if (sc->priority != DEF_PRIORITY &&
+			    !zone_reclaimable(zone))
 				continue;	/* Let kswapd poll it */
 			if (IS_ENABLED(CONFIG_COMPACTION)) {
 				/*
@@ -2283,11 +2283,6 @@ static bool shrink_zones(struct zonelist
 	return aborted_reclaim;
 }
 
-static bool zone_reclaimable(struct zone *zone)
-{
-	return zone->pages_scanned < zone_reclaimable_pages(zone) * 6;
-}
-
 /* All zones in zonelist are unreclaimable? */
 static bool all_unreclaimable(struct zonelist *zonelist,
 		struct scan_control *sc)
@@ -2301,7 +2296,7 @@ static bool all_unreclaimable(struct zon
 			continue;
 		if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
 			continue;
-		if (!zone->all_unreclaimable)
+		if (zone_reclaimable(zone))
 			return false;
 	}
 
@@ -2712,7 +2707,7 @@ static bool pgdat_balanced(pg_data_t *pg
 		 * DEF_PRIORITY. Effectively, it considers them balanced so
 		 * they must be considered balanced here as well!
 		 */
-		if (zone->all_unreclaimable) {
+		if (!zone_reclaimable(zone)) {
 			balanced_pages += zone->managed_pages;
 			continue;
 		}
@@ -2773,7 +2768,6 @@ static bool kswapd_shrink_zone(struct zo
 			       unsigned long lru_pages,
 			       unsigned long *nr_attempted)
 {
-	unsigned long nr_slab;
 	int testorder = sc->order;
 	unsigned long balance_gap;
 	struct reclaim_state *reclaim_state = current->reclaim_state;
@@ -2818,15 +2812,12 @@ static bool kswapd_shrink_zone(struct zo
 	shrink_zone(zone, sc);
 
 	reclaim_state->reclaimed_slab = 0;
-	nr_slab = shrink_slab(&shrink, sc->nr_scanned, lru_pages);
+	shrink_slab(&shrink, sc->nr_scanned, lru_pages);
 	sc->nr_reclaimed += reclaim_state->reclaimed_slab;
 
 	/* Account for the number of pages attempted to reclaim */
 	*nr_attempted += sc->nr_to_reclaim;
 
-	if (nr_slab == 0 && !zone_reclaimable(zone))
-		zone->all_unreclaimable = 1;
-
 	zone_clear_flag(zone, ZONE_WRITEBACK);
 
 	/*
@@ -2835,7 +2826,7 @@ static bool kswapd_shrink_zone(struct zo
 	 * BDIs but as pressure is relieved, speculatively avoid congestion
 	 * waits.
 	 */
-	if (!zone->all_unreclaimable &&
+	if (zone_reclaimable(zone) &&
 	    zone_balanced(zone, testorder, 0, classzone_idx)) {
 		zone_clear_flag(zone, ZONE_CONGESTED);
 		zone_clear_flag(zone, ZONE_TAIL_LRU_DIRTY);
@@ -2901,8 +2892,8 @@ static unsigned long balance_pgdat(pg_da
 			if (!populated_zone(zone))
 				continue;
 
-			if (zone->all_unreclaimable &&
-			    sc.priority != DEF_PRIORITY)
+			if (sc.priority != DEF_PRIORITY &&
+			    !zone_reclaimable(zone))
 				continue;
 
 			/*
@@ -2980,8 +2971,8 @@ static unsigned long balance_pgdat(pg_da
 			if (!populated_zone(zone))
 				continue;
 
-			if (zone->all_unreclaimable &&
-			    sc.priority != DEF_PRIORITY)
+			if (sc.priority != DEF_PRIORITY &&
+			    !zone_reclaimable(zone))
 				continue;
 
 			sc.nr_scanned = 0;
@@ -3265,20 +3256,6 @@ unsigned long global_reclaimable_pages(v
 	return nr;
 }
 
-unsigned long zone_reclaimable_pages(struct zone *zone)
-{
-	int nr;
-
-	nr = zone_page_state(zone, NR_ACTIVE_FILE) +
-	     zone_page_state(zone, NR_INACTIVE_FILE);
-
-	if (get_nr_swap_pages() > 0)
-		nr += zone_page_state(zone, NR_ACTIVE_ANON) +
-		      zone_page_state(zone, NR_INACTIVE_ANON);
-
-	return nr;
-}
-
 #ifdef CONFIG_HIBERNATION
 /*
  * Try to free `nr_to_reclaim' of memory, system-wide, and return the number of
@@ -3576,7 +3553,7 @@ int zone_reclaim(struct zone *zone, gfp_
 	    zone_page_state(zone, NR_SLAB_RECLAIMABLE) <= zone->min_slab_pages)
 		return ZONE_RECLAIM_FULL;
 
-	if (zone->all_unreclaimable)
+	if (!zone_reclaimable(zone))
 		return ZONE_RECLAIM_FULL;
 
 	/*
diff -puN mm/vmstat.c~mm-vmscan-fix-do_try_to_free_pages-livelock mm/vmstat.c
--- a/mm/vmstat.c~mm-vmscan-fix-do_try_to_free_pages-livelock
+++ a/mm/vmstat.c
@@ -19,6 +19,7 @@
 #include <linux/math64.h>
 #include <linux/writeback.h>
 #include <linux/compaction.h>
+#include <linux/mm_inline.h>
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
 DEFINE_PER_CPU(struct vm_event_state, vm_event_states) = {{0}};
@@ -1088,7 +1089,7 @@ static void zoneinfo_show_print(struct s
 		   "\n  all_unreclaimable: %u"
 		   "\n  start_pfn:         %lu"
 		   "\n  inactive_ratio:    %u",
-		   zone->all_unreclaimable,
+		   !zone_reclaimable(zone),
 		   zone->zone_start_pfn,
 		   zone->inactive_ratio);
 	seq_putc(m, '\n');
_

Patches currently in -mm which might be from cldu@marvell.com are

mm-vmscan-fix-do_try_to_free_pages-livelock.patch
mm-vmscan-fix-do_try_to_free_pages-livelock-fix.patch

