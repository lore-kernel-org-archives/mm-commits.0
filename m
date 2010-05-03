From: akpm@linux-foundation.org
Subject: + vmscan-remove-isolate_pages-callback-scan-control.patch added to -mm tree
Date: Mon, 03 May 2010 14:44:45 -0700
Message-ID: <201005032144.o43LikOn023371@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756863Ab0ECVpy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 May 2010 17:45:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com


The patch titled
     vmscan: remove isolate_pages callback scan control
has been added to the -mm tree.  Its filename is
     vmscan-remove-isolate_pages-callback-scan-control.patch

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
Subject: vmscan: remove isolate_pages callback scan control
From: Johannes Weiner <hannes@cmpxchg.org>

For now, we have global isolation vs.  memory control group isolation, do
not allow the reclaim entry function to set an arbitrary page isolation
callback, we do not need that flexibility.

And since we already pass around the group descriptor for the memory
control group isolation case, just use it to decide which one of the two
isolator functions to use.

The decisions can be merged into nearby branches, so no extra cost there. 
In fact, we save the indirect calls.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   13 ++++----
 mm/vmscan.c                |   52 ++++++++++++++++++-----------------
 2 files changed, 35 insertions(+), 30 deletions(-)

diff -puN include/linux/memcontrol.h~vmscan-remove-isolate_pages-callback-scan-control include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~vmscan-remove-isolate_pages-callback-scan-control
+++ a/include/linux/memcontrol.h
@@ -25,6 +25,13 @@ struct page_cgroup;
 struct page;
 struct mm_struct;
 
+extern unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
+					struct list_head *dst,
+					unsigned long *scanned, int order,
+					int mode, struct zone *z,
+					struct mem_cgroup *mem_cont,
+					int active, int file);
+
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 /*
  * All "charge" functions with gfp_mask should use GFP_KERNEL or
@@ -64,12 +71,6 @@ extern void mem_cgroup_uncharge_cache_pa
 extern int mem_cgroup_shmem_charge_fallback(struct page *page,
 			struct mm_struct *mm, gfp_t gfp_mask);
 
-extern unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
-					struct list_head *dst,
-					unsigned long *scanned, int order,
-					int mode, struct zone *z,
-					struct mem_cgroup *mem_cont,
-					int active, int file);
 extern void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask);
 int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem);
 
diff -puN mm/vmscan.c~vmscan-remove-isolate_pages-callback-scan-control mm/vmscan.c
--- a/mm/vmscan.c~vmscan-remove-isolate_pages-callback-scan-control
+++ a/mm/vmscan.c
@@ -82,12 +82,6 @@ struct scan_control {
 	 * are scanned.
 	 */
 	nodemask_t	*nodemask;
-
-	/* Pluggable isolate pages callback */
-	unsigned long (*isolate_pages)(unsigned long nr, struct list_head *dst,
-			unsigned long *scanned, int order, int mode,
-			struct zone *z, struct mem_cgroup *mem_cont,
-			int active, int file);
 };
 
 #define lru_to_page(_head) (list_entry((_head)->prev, struct page, lru))
@@ -1000,7 +994,6 @@ static unsigned long isolate_pages_globa
 					struct list_head *dst,
 					unsigned long *scanned, int order,
 					int mode, struct zone *z,
-					struct mem_cgroup *mem_cont,
 					int active, int file)
 {
 	int lru = LRU_BASE;
@@ -1144,11 +1137,11 @@ static unsigned long shrink_inactive_lis
 		unsigned long nr_anon;
 		unsigned long nr_file;
 
-		nr_taken = sc->isolate_pages(SWAP_CLUSTER_MAX,
-			     &page_list, &nr_scan, sc->order, mode,
-				zone, sc->mem_cgroup, 0, file);
-
 		if (scanning_global_lru(sc)) {
+			nr_taken = isolate_pages_global(SWAP_CLUSTER_MAX,
+							&page_list, &nr_scan,
+							sc->order, mode,
+							zone, 0, file);
 			zone->pages_scanned += nr_scan;
 			if (current_is_kswapd())
 				__count_zone_vm_events(PGSCAN_KSWAPD, zone,
@@ -1156,6 +1149,16 @@ static unsigned long shrink_inactive_lis
 			else
 				__count_zone_vm_events(PGSCAN_DIRECT, zone,
 						       nr_scan);
+		} else {
+			nr_taken = mem_cgroup_isolate_pages(SWAP_CLUSTER_MAX,
+							&page_list, &nr_scan,
+							sc->order, mode,
+							zone, sc->mem_cgroup,
+							0, file);
+			/*
+			 * mem_cgroup_isolate_pages() keeps track of
+			 * scanned pages on its own.
+			 */
 		}
 
 		if (nr_taken == 0)
@@ -1333,16 +1336,23 @@ static void shrink_active_list(unsigned 
 
 	lru_add_drain();
 	spin_lock_irq(&zone->lru_lock);
-	nr_taken = sc->isolate_pages(nr_pages, &l_hold, &pgscanned, sc->order,
-					ISOLATE_ACTIVE, zone,
-					sc->mem_cgroup, 1, file);
-	/*
-	 * zone->pages_scanned is used for detect zone's oom
-	 * mem_cgroup remembers nr_scan by itself.
-	 */
 	if (scanning_global_lru(sc)) {
+		nr_taken = isolate_pages_global(nr_pages, &l_hold,
+						&pgscanned, sc->order,
+						ISOLATE_ACTIVE, zone,
+						1, file);
 		zone->pages_scanned += pgscanned;
+	} else {
+		nr_taken = mem_cgroup_isolate_pages(nr_pages, &l_hold,
+						&pgscanned, sc->order,
+						ISOLATE_ACTIVE, zone,
+						sc->mem_cgroup, 1, file);
+		/*
+		 * mem_cgroup_isolate_pages() keeps track of
+		 * scanned pages on its own.
+		 */
 	}
+
 	reclaim_stat->recent_scanned[file] += nr_taken;
 
 	__count_zone_vm_events(PGREFILL, zone, pgscanned);
@@ -1864,7 +1874,6 @@ unsigned long try_to_free_pages(struct z
 		.swappiness = vm_swappiness,
 		.order = order,
 		.mem_cgroup = NULL,
-		.isolate_pages = isolate_pages_global,
 		.nodemask = nodemask,
 	};
 
@@ -1884,7 +1893,6 @@ unsigned long mem_cgroup_shrink_node_zon
 		.swappiness = swappiness,
 		.order = 0,
 		.mem_cgroup = mem,
-		.isolate_pages = mem_cgroup_isolate_pages,
 	};
 	nodemask_t nm  = nodemask_of_node(nid);
 
@@ -1917,7 +1925,6 @@ unsigned long try_to_free_mem_cgroup_pag
 		.swappiness = swappiness,
 		.order = 0,
 		.mem_cgroup = mem_cont,
-		.isolate_pages = mem_cgroup_isolate_pages,
 		.nodemask = NULL, /* we don't care the placement */
 	};
 
@@ -1994,7 +2001,6 @@ static unsigned long balance_pgdat(pg_da
 		.swappiness = vm_swappiness,
 		.order = order,
 		.mem_cgroup = NULL,
-		.isolate_pages = isolate_pages_global,
 	};
 	/*
 	 * temp_priority is used to remember the scanning priority at which
@@ -2372,7 +2378,6 @@ unsigned long shrink_all_memory(unsigned
 		.hibernation_mode = 1,
 		.swappiness = vm_swappiness,
 		.order = 0,
-		.isolate_pages = isolate_pages_global,
 	};
 	struct zonelist * zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
 	struct task_struct *p = current;
@@ -2556,7 +2561,6 @@ static int __zone_reclaim(struct zone *z
 		.gfp_mask = gfp_mask,
 		.swappiness = vm_swappiness,
 		.order = order,
-		.isolate_pages = isolate_pages_global,
 	};
 	unsigned long slab_reclaimable;
 
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

