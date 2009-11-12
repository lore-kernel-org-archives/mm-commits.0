From: akpm@linux-foundation.org
Subject: + vmscan-kill-hibernation-specific-reclaim-logic-and-unify-it.patch added to -mm tree
Date: Thu, 12 Nov 2009 13:50:37 -0800
Message-ID: <200911122150.nACLocRh019777@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754274AbZKLVvz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 16:51:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com, rjw@sisk.pl


The patch titled
     vmscan: kill hibernation specific reclaim logic and unify it
has been added to the -mm tree.  Its filename is
     vmscan-kill-hibernation-specific-reclaim-logic-and-unify-it.patch

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
Subject: vmscan: kill hibernation specific reclaim logic and unify it
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

shrink_all_zone() was introduced by commit d6277db4ab (swsusp: rework
memory shrinker) for hibernate performance improvement.  and
sc.swap_cluster_max was introduced by commit a06fe4d307 (Speed freeing
memory for suspend).

commit a06fe4d307 said

   Without the patch:
   Freed  14600 pages in  1749 jiffies = 32.61 MB/s (Anomolous!)
   Freed  88563 pages in 14719 jiffies = 23.50 MB/s
   Freed 205734 pages in 32389 jiffies = 24.81 MB/s

   With the patch:
   Freed  68252 pages in   496 jiffies = 537.52 MB/s
   Freed 116464 pages in   569 jiffies = 798.54 MB/s
   Freed 209699 pages in   705 jiffies = 1161.89 MB/s

At that time, their patch was pretty worth.  However, Modern Hardware
trend and recent VM improvement broke its worth.  From several reason, I
think we should remove shrink_all_zones() at all.

detail:

1) Old days, shrink_zone()'s slowness was mainly caused by stupid io-throttle
  at no i/o congestion.
  but current shrink_zone() is sane, not slow.

2) shrink_all_zone() try to shrink all pages at a time. but it doesn't works
  fine on numa system.
  example)
    System has 4GB memory and each node have 2GB. and hibernate need 1GB.

    optimal)
       steal 500MB from each node.
    shrink_all_zones)
       steal 1GB from node-0.

  Oh, Cache balancing logic was broken. ;)
  Unfortunately, Desktop system moved ahead NUMA at nowadays.
  (Side note, if hibernate require 2GB, shrink_all_zones() never success
   on above machine)

3) if the node has several I/O flighting pages, shrink_all_zones() makes
  pretty bad result.

  schenario) hibernate need 1GB

  1) shrink_all_zones() try to reclaim 1GB from Node-0
  2) but it only reclaimed 990MB
  3) stupidly, shrink_all_zones() try to reclaim 1GB from Node-1
  4) it reclaimed 990MB

  Oh, well. it reclaimed twice much than required.
  In the other hand, current shrink_zone() has sane baling out logic.
  then, it doesn't make overkill reclaim. then, we lost shrink_zones()'s risk.

4) SplitLRU VM always keep active/inactive ratio very carefully. inactive list only
  shrinking break its assumption. it makes unnecessary OOM risk. it obviously suboptimal.

Now, shrink_all_memory() is only the wrapper function of do_try_to_free_pages().
it bring good reviewability and debuggability, and solve above problems.

side note: Reclaim logic unificication makes two good side effect.
 - Fix recursive reclaim bug on shrink_all_memory().
   it did forgot to use PF_MEMALLOC. it mean the system be able to stuck into deadlock.
 - Now, shrink_all_memory() got lockdep awareness. it bring good debuggability.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |  153 ++++++++------------------------------------------
 1 file changed, 26 insertions(+), 127 deletions(-)

diff -puN mm/vmscan.c~vmscan-kill-hibernation-specific-reclaim-logic-and-unify-it mm/vmscan.c
--- a/mm/vmscan.c~vmscan-kill-hibernation-specific-reclaim-logic-and-unify-it
+++ a/mm/vmscan.c
@@ -58,6 +58,8 @@ struct scan_control {
 	/* How many pages shrink_list() should reclaim */
 	unsigned long nr_to_reclaim;
 
+	unsigned long hibernation_mode;
+
 	/* This context's GFP mask */
 	gfp_t gfp_mask;
 
@@ -1800,7 +1802,8 @@ static unsigned long do_try_to_free_page
 		}
 
 		/* Take a nap, wait for some writeback to complete */
-		if (sc->nr_scanned && priority < DEF_PRIORITY - 2)
+		if (!sc->hibernation_mode && sc->nr_scanned &&
+		    priority < DEF_PRIORITY - 2)
 			congestion_wait(BLK_RW_BOTH, HZ/10);
 	}
 	/* top priority shrink_zones still had more to do? don't OOM, then */
@@ -2330,148 +2333,44 @@ unsigned long zone_reclaimable_pages(str
 
 #ifdef CONFIG_HIBERNATION
 /*
- * Helper function for shrink_all_memory().  Tries to reclaim 'nr_pages' pages
- * from LRU lists system-wide, for given pass and priority.
- *
- * For pass > 3 we also try to shrink the LRU lists that contain a few pages
- */
-static void shrink_all_zones(unsigned long nr_pages, int prio,
-				      int pass, struct scan_control *sc)
-{
-	struct zone *zone;
-	unsigned long nr_reclaimed = 0;
-	struct zone_reclaim_stat *reclaim_stat;
-
-	for_each_populated_zone(zone) {
-		enum lru_list l;
-
-		if (zone_is_all_unreclaimable(zone) && prio != DEF_PRIORITY)
-			continue;
-
-		for_each_evictable_lru(l) {
-			enum zone_stat_item ls = NR_LRU_BASE + l;
-			unsigned long lru_pages = zone_page_state(zone, ls);
-
-			/* For pass = 0, we don't shrink the active list */
-			if (pass == 0 && (l == LRU_ACTIVE_ANON ||
-						l == LRU_ACTIVE_FILE))
-				continue;
-
-			reclaim_stat = get_reclaim_stat(zone, sc);
-			reclaim_stat->nr_saved_scan[l] +=
-						(lru_pages >> prio) + 1;
-			if (reclaim_stat->nr_saved_scan[l]
-						>= nr_pages || pass > 3) {
-				unsigned long nr_to_scan;
-
-				reclaim_stat->nr_saved_scan[l] = 0;
-				nr_to_scan = min(nr_pages, lru_pages);
-				nr_reclaimed += shrink_list(l, nr_to_scan, zone,
-								sc, prio);
-				if (nr_reclaimed >= nr_pages) {
-					sc->nr_reclaimed += nr_reclaimed;
-					return;
-				}
-			}
-		}
-	}
-	sc->nr_reclaimed += nr_reclaimed;
-}
-
-/*
- * Try to free `nr_pages' of memory, system-wide, and return the number of
+ * Try to free `nr_to_reclaim' of memory, system-wide, and return the number of
  * freed pages.
  *
  * Rather than trying to age LRUs the aim is to preserve the overall
  * LRU order by reclaiming preferentially
  * inactive > active > active referenced > active mapped
  */
-unsigned long shrink_all_memory(unsigned long nr_pages)
+unsigned long shrink_all_memory(unsigned long nr_to_reclaim)
 {
-	unsigned long lru_pages, nr_slab;
-	int pass;
 	struct reclaim_state reclaim_state;
 	struct scan_control sc = {
-		.gfp_mask = GFP_KERNEL,
-		.may_unmap = 0,
+		.gfp_mask = GFP_HIGHUSER_MOVABLE,
+		.may_swap = 1,
+		.may_unmap = 1,
 		.may_writepage = 1,
+		.swap_cluster_max = SWAP_CLUSTER_MAX,
+		.nr_to_reclaim = nr_to_reclaim,
+		.hibernation_mode = 1,
+		.swappiness = vm_swappiness,
+		.order = 0,
 		.isolate_pages = isolate_pages_global,
-		.nr_reclaimed = 0,
 	};
+	struct zonelist * zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
+	struct task_struct *p = current;
+	unsigned long nr_reclaimed;
 
-	current->reclaim_state = &reclaim_state;
-
-	lru_pages = global_reclaimable_pages();
-	nr_slab = global_page_state(NR_SLAB_RECLAIMABLE);
-	/* If slab caches are huge, it's better to hit them first */
-	while (nr_slab >= lru_pages) {
-		reclaim_state.reclaimed_slab = 0;
-		shrink_slab(nr_pages, sc.gfp_mask, lru_pages);
-		if (!reclaim_state.reclaimed_slab)
-			break;
-
-		sc.nr_reclaimed += reclaim_state.reclaimed_slab;
-		if (sc.nr_reclaimed >= nr_pages)
-			goto out;
-
-		nr_slab -= reclaim_state.reclaimed_slab;
-	}
-
-	/*
-	 * We try to shrink LRUs in 5 passes:
-	 * 0 = Reclaim from inactive_list only
-	 * 1 = Reclaim from active list but don't reclaim mapped
-	 * 2 = 2nd pass of type 1
-	 * 3 = Reclaim mapped (normal reclaim)
-	 * 4 = 2nd pass of type 3
-	 */
-	for (pass = 0; pass < 5; pass++) {
-		int prio;
-
-		/* Force reclaiming mapped pages in the passes #3 and #4 */
-		if (pass > 2)
-			sc.may_unmap = 1;
-
-		for (prio = DEF_PRIORITY; prio >= 0; prio--) {
-			unsigned long nr_to_scan = nr_pages - sc.nr_reclaimed;
-
-			sc.nr_scanned = 0;
-			sc.swap_cluster_max = nr_to_scan;
-			shrink_all_zones(nr_to_scan, prio, pass, &sc);
-			if (sc.nr_reclaimed >= nr_pages)
-				goto out;
-
-			reclaim_state.reclaimed_slab = 0;
-			shrink_slab(sc.nr_scanned, sc.gfp_mask,
-				    global_reclaimable_pages());
-			sc.nr_reclaimed += reclaim_state.reclaimed_slab;
-			if (sc.nr_reclaimed >= nr_pages)
-				goto out;
-
-			if (sc.nr_scanned && prio < DEF_PRIORITY - 2)
-				congestion_wait(BLK_RW_ASYNC, HZ / 10);
-		}
-	}
-
-	/*
-	 * If sc.nr_reclaimed = 0, we could not shrink LRUs, but there may be
-	 * something in slab caches
-	 */
-	if (!sc.nr_reclaimed) {
-		do {
-			reclaim_state.reclaimed_slab = 0;
-			shrink_slab(nr_pages, sc.gfp_mask,
-				    global_reclaimable_pages());
-			sc.nr_reclaimed += reclaim_state.reclaimed_slab;
-		} while (sc.nr_reclaimed < nr_pages &&
-				reclaim_state.reclaimed_slab > 0);
-	}
+	p->flags |= PF_MEMALLOC;
+	lockdep_set_current_reclaim_state(sc.gfp_mask);
+	reclaim_state.reclaimed_slab = 0;
+	p->reclaim_state = &reclaim_state;
 
+	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
 
-out:
-	current->reclaim_state = NULL;
+	p->reclaim_state = NULL;
+	lockdep_clear_current_reclaim_state();
+	p->flags &= ~PF_MEMALLOC;
 
-	return sc.nr_reclaimed;
+	return nr_reclaimed;
 }
 #endif /* CONFIG_HIBERNATION */
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
page-allocator-always-wake-kswapd-when-restarting-an-allocation-attempt-after-direct-reclaim-failed.patch
page-allocator-do-not-allow-interrupts-to-use-alloc_harder.patch
linux-next.patch
oom-dump-stack-and-vm-state-when-oom-killer-panics.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
mm-move-inc_zone_page_statenr_isolated-to-just-isolated-place.patch
rmap-simplify-try_to_unmap_file.patch
oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process-fix.patch
page-allocator-wait-on-both-sync-and-async-congestion-after-direct-reclaim.patch
vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep.patch
vmscan-take-order-into-consideration-when-deciding-if-kswapd-is-in-trouble.patch
mm-define-page_mapping_flags.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-config_mmu-for-pg_mlocked.patch
mm-pass-address-down-to-rmap-ones.patch
mm-stop-ptlock-enlarging-struct-page.patch
mm-sigbus-instead-of-abusing-oom.patch
mm-add-numa-node-symlink-for-memory-section-in-sysfs.patch
mm-refactor-register_cpu_under_node.patch
mm-refactor-unregister_cpu_under_node.patch
mm-add-numa-node-symlink-for-cpu-devices-in-sysfs.patch
documentation-abi-sys-devices-system-cpu-cpu-node.patch
vmscan-separate-scswap_cluster_max-and-scnr_max_reclaim.patch
vmscan-kill-hibernation-specific-reclaim-logic-and-unify-it.patch
vmscan-zone_reclaim-dont-use-insane-swap_cluster_max.patch
vmscan-kill-scswap_cluster_max.patch
vmscan-make-consistent-of-reclaim-bale-out-between-do_try_to_free_page-and-shrink_zone.patch
lib-introduce-strim.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

