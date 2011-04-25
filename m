From: akpm@linux-foundation.org
Subject: + vmscan-change-shrink_slab-interfaces-by-passing-shrink_control.patch added to -mm tree
Date: Mon, 25 Apr 2011 15:35:26 -0700
Message-ID: <201104252235.p3PMZRck015088@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44974 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756804Ab1DYWg5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Apr 2011 18:36:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghan@google.com, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com, xemul@openvz.org


The patch titled
     vmscan: change shrink_slab() interfaces by passing shrink_control
has been added to the -mm tree.  Its filename is
     vmscan-change-shrink_slab-interfaces-by-passing-shrink_control.patch

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
Subject: vmscan: change shrink_slab() interfaces by passing shrink_control
From: Ying Han <yinghan@google.com>

Consolidate the existing parameters to shrink_slab() into a new
shrink_control struct.  This is needed later to pass the same struct to
shrinkers.

Signed-off-by: Ying Han <yinghan@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/drop_caches.c   |    6 +++++-
 include/linux/mm.h |   13 +++++++++++--
 mm/vmscan.c        |   30 ++++++++++++++++++++++--------
 3 files changed, 38 insertions(+), 11 deletions(-)

diff -puN fs/drop_caches.c~vmscan-change-shrink_slab-interfaces-by-passing-shrink_control fs/drop_caches.c
--- a/fs/drop_caches.c~vmscan-change-shrink_slab-interfaces-by-passing-shrink_control
+++ a/fs/drop_caches.c
@@ -40,9 +40,13 @@ static void drop_pagecache_sb(struct sup
 static void drop_slab(void)
 {
 	int nr_objects;
+	struct shrink_control shrink = {
+		.gfp_mask = GFP_KERNEL,
+		.nr_scanned = 1000,
+	};
 
 	do {
-		nr_objects = shrink_slab(1000, GFP_KERNEL, 1000);
+		nr_objects = shrink_slab(&shrink, 1000);
 	} while (nr_objects > 10);
 }
 
diff -puN include/linux/mm.h~vmscan-change-shrink_slab-interfaces-by-passing-shrink_control include/linux/mm.h
--- a/include/linux/mm.h~vmscan-change-shrink_slab-interfaces-by-passing-shrink_control
+++ a/include/linux/mm.h
@@ -1140,6 +1140,15 @@ static inline void sync_mm_rss(struct ta
 #endif
 
 /*
+ * This struct is used to pass information from page reclaim to the shrinkers.
+ * We consolidate the values for easier extention later.
+ */
+struct shrink_control {
+	unsigned long nr_scanned;
+	gfp_t gfp_mask;
+};
+
+/*
  * A callback you can register to apply pressure to ageable caches.
  *
  * 'shrink' is passed a count 'nr_to_scan' and a 'gfpmask'.  It should
@@ -1612,8 +1621,8 @@ int in_gate_area_no_mm(unsigned long add
 
 int drop_caches_sysctl_handler(struct ctl_table *, int,
 					void __user *, size_t *, loff_t *);
-unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
-			unsigned long lru_pages);
+unsigned long shrink_slab(struct shrink_control *shrink,
+				unsigned long lru_pages);
 
 #ifndef CONFIG_MMU
 #define randomize_va_space 0
diff -puN mm/vmscan.c~vmscan-change-shrink_slab-interfaces-by-passing-shrink_control mm/vmscan.c
--- a/mm/vmscan.c~vmscan-change-shrink_slab-interfaces-by-passing-shrink_control
+++ a/mm/vmscan.c
@@ -221,11 +221,13 @@ EXPORT_SYMBOL(unregister_shrinker);
  *
  * Returns the number of slab objects which we shrunk.
  */
-unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
-			unsigned long lru_pages)
+unsigned long shrink_slab(struct shrink_control *shrink,
+			  unsigned long lru_pages)
 {
 	struct shrinker *shrinker;
 	unsigned long ret = 0;
+	unsigned long scanned = shrink->nr_scanned;
+	gfp_t gfp_mask = shrink->gfp_mask;
 
 	if (scanned == 0)
 		scanned = SWAP_CLUSTER_MAX;
@@ -2029,7 +2031,8 @@ static bool all_unreclaimable(struct zon
  * 		else, the number of pages reclaimed
  */
 static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
-					struct scan_control *sc)
+					struct scan_control *sc,
+					struct shrink_control *shrink)
 {
 	int priority;
 	unsigned long total_scanned = 0;
@@ -2063,7 +2066,8 @@ static unsigned long do_try_to_free_page
 				lru_pages += zone_reclaimable_pages(zone);
 			}
 
-			shrink_slab(sc->nr_scanned, sc->gfp_mask, lru_pages);
+			shrink->nr_scanned = sc->nr_scanned;
+			shrink_slab(shrink, lru_pages);
 			if (reclaim_state) {
 				sc->nr_reclaimed += reclaim_state->reclaimed_slab;
 				reclaim_state->reclaimed_slab = 0;
@@ -2135,12 +2139,15 @@ unsigned long try_to_free_pages(struct z
 		.mem_cgroup = NULL,
 		.nodemask = nodemask,
 	};
+	struct shrink_control shrink = {
+		.gfp_mask = sc.gfp_mask,
+	};
 
 	trace_mm_vmscan_direct_reclaim_begin(order,
 				sc.may_writepage,
 				gfp_mask);
 
-	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
+	nr_reclaimed = do_try_to_free_pages(zonelist, &sc, &shrink);
 
 	trace_mm_vmscan_direct_reclaim_end(nr_reclaimed);
 
@@ -2338,6 +2345,9 @@ static unsigned long balance_pgdat(pg_da
 		.order = order,
 		.mem_cgroup = NULL,
 	};
+	struct shrink_control shrink = {
+		.gfp_mask = sc.gfp_mask,
+	};
 loop_again:
 	total_scanned = 0;
 	sc.nr_reclaimed = 0;
@@ -2437,8 +2447,8 @@ loop_again:
 					end_zone, 0))
 				shrink_zone(priority, zone, &sc);
 			reclaim_state->reclaimed_slab = 0;
-			nr_slab = shrink_slab(sc.nr_scanned, GFP_KERNEL,
-						lru_pages);
+			shrink.nr_scanned = sc.nr_scanned;
+			nr_slab = shrink_slab(&shrink, lru_pages);
 			sc.nr_reclaimed += reclaim_state->reclaimed_slab;
 			total_scanned += sc.nr_scanned;
 
@@ -2974,6 +2984,9 @@ static int __zone_reclaim(struct zone *z
 		.swappiness = vm_swappiness,
 		.order = order,
 	};
+	struct shrink_control shrink = {
+		.gfp_mask = sc.gfp_mask,
+	};
 	unsigned long nr_slab_pages0, nr_slab_pages1;
 
 	cond_resched();
@@ -3000,6 +3013,7 @@ static int __zone_reclaim(struct zone *z
 	}
 
 	nr_slab_pages0 = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
+	shrink.nr_scanned = sc.nr_scanned;
 	if (nr_slab_pages0 > zone->min_slab_pages) {
 		/*
 		 * shrink_slab() does not currently allow us to determine how
@@ -3015,7 +3029,7 @@ static int __zone_reclaim(struct zone *z
 			unsigned long lru_pages = zone_reclaimable_pages(zone);
 
 			/* No reclaimable slab or very low memory pressure */
-			if (!shrink_slab(sc.nr_scanned, gfp_mask, lru_pages))
+			if (!shrink_slab(&shrink, lru_pages))
 				break;
 
 			/* Freed enough memory */
_

Patches currently in -mm which might be from yinghan@google.com are

vmscan-change-shrink_slab-interfaces-by-passing-shrink_control.patch
change-shrinker-api-by-passing-shrink_control-struct.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-stats-to-monitor-soft_limit-reclaim.patch
add-the-pagefault-count-into-memcg-stats.patch
add-the-pagefault-count-into-memcg-stats-fix.patch

