From: akpm@linux-foundation.org
Subject: + vmscan-check-all_unreclaimable-in-direct-reclaim-path.patch added to -mm tree
Date: Wed, 08 Sep 2010 15:19:44 -0700
Message-ID: <201009082219.o88MJimw013140@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756386Ab0IHWUI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Sep 2010 18:20:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, bicave@superonline.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, rjw@sisk.pl, stable@kernel.org


The patch titled
     vmscan: check all_unreclaimable in direct reclaim path
has been added to the -mm tree.  Its filename is
     vmscan-check-all_unreclaimable-in-direct-reclaim-path.patch

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
Subject: vmscan: check all_unreclaimable in direct reclaim path
From: Minchan Kim <minchan.kim@gmail.com>

M.  Vefa Bicakci reported 2.6.35 kernel hang up when hibernation on his
32bit 3GB mem machine. 
(https://bugzilla.kernel.org/show_bug.cgi?id=16771). Also he bisected
the regression to

  commit bb21c7ce18eff8e6e7877ca1d06c6db719376e3c
  Author: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
  Date:   Fri Jun 4 14:15:05 2010 -0700

     vmscan: fix do_try_to_free_pages() return value when priority==0 reclaim failure

At first impression, this seemed very strange because the above commit
only chenged function return value and hibernate_preallocate_memory()
ignore return value of shrink_all_memory().  But it's related.

Now, page allocation from hibernation code may enter infinite loop if the
system has highmem.  The reasons are that vmscan don't care enough OOM
case when oom_killer_disabled.

The problem sequence is following as.

1. hibernation
2. oom_disable
3. alloc_pages
4. do_try_to_free_pages
       if (scanning_global_lru(sc) && !all_unreclaimable)
               return 1;

If kswapd is not freozen, it would set zone->all_unreclaimable to 1 and
then shrink_zones maybe return true(ie, all_unreclaimable is true).  So at
last, alloc_pages could go to _nopage_.  If it is, it should have no
problem.

This patch adds all_unreclaimable check to protect in direct reclaim path,
too.  It can care of hibernation OOM case and help bailout
all_unreclaimable case slightly.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Reported-by: M. Vefa Bicakci <bicave@superonline.com>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   41 +++++++++++++++++++++++++++++++++--------
 1 file changed, 33 insertions(+), 8 deletions(-)

diff -puN mm/vmscan.c~vmscan-check-all_unreclaimable-in-direct-reclaim-path mm/vmscan.c
--- a/mm/vmscan.c~vmscan-check-all_unreclaimable-in-direct-reclaim-path
+++ a/mm/vmscan.c
@@ -1804,12 +1804,11 @@ static void shrink_zone(int priority, st
  * If a zone is deemed to be full of pinned pages then just give it a light
  * scan then give up on it.
  */
-static bool shrink_zones(int priority, struct zonelist *zonelist,
+static void shrink_zones(int priority, struct zonelist *zonelist,
 					struct scan_control *sc)
 {
 	struct zoneref *z;
 	struct zone *zone;
-	bool all_unreclaimable = true;
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(sc->gfp_mask), sc->nodemask) {
@@ -1827,8 +1826,36 @@ static bool shrink_zones(int priority, s
 		}
 
 		shrink_zone(priority, zone, sc);
-		all_unreclaimable = false;
 	}
+}
+
+static inline bool zone_reclaimable(struct zone *zone)
+{
+	return zone->pages_scanned < zone_reclaimable_pages(zone) * 6;
+}
+
+static inline bool all_unreclaimable(struct zonelist *zonelist,
+		struct scan_control *sc)
+{
+	struct zoneref *z;
+	struct zone *zone;
+	bool all_unreclaimable = true;
+
+	if (!scanning_global_lru(sc))
+		return false;
+
+	for_each_zone_zonelist_nodemask(zone, z, zonelist,
+			gfp_zone(sc->gfp_mask), sc->nodemask) {
+		if (!populated_zone(zone))
+			continue;
+		if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
+			continue;
+		if (zone_reclaimable(zone)) {
+			all_unreclaimable = false;
+			break;
+		}
+	}
+
 	return all_unreclaimable;
 }
 
@@ -1852,7 +1879,6 @@ static unsigned long do_try_to_free_page
 					struct scan_control *sc)
 {
 	int priority;
-	bool all_unreclaimable;
 	unsigned long total_scanned = 0;
 	struct reclaim_state *reclaim_state = current->reclaim_state;
 	struct zoneref *z;
@@ -1869,7 +1895,7 @@ static unsigned long do_try_to_free_page
 		sc->nr_scanned = 0;
 		if (!priority)
 			disable_swap_token();
-		all_unreclaimable = shrink_zones(priority, zonelist, sc);
+		shrink_zones(priority, zonelist, sc);
 		/*
 		 * Don't shrink slabs when reclaiming memory from
 		 * over limit cgroups
@@ -1931,7 +1957,7 @@ out:
 		return sc->nr_reclaimed;
 
 	/* top priority shrink_zones still had more to do? don't OOM, then */
-	if (scanning_global_lru(sc) && !all_unreclaimable)
+	if (!all_unreclaimable(zonelist, sc))
 		return 1;
 
 	return 0;
@@ -2197,8 +2223,7 @@ loop_again:
 			total_scanned += sc.nr_scanned;
 			if (zone->all_unreclaimable)
 				continue;
-			if (nr_slab == 0 &&
-			    zone->pages_scanned >= (zone_reclaimable_pages(zone) * 6))
+			if (nr_slab == 0 && !zone_reclaimable(zone))
 				zone->all_unreclaimable = 1;
 			/*
 			 * If we've done a decent amount of scanning and
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

mm-compaction-handle-active-and-inactive-fairly-in-too_many_isolated.patch
vmscan-check-all_unreclaimable-in-direct-reclaim-path.patch
vmstat-update-zone-stat-threshold-when-onlining-a-cpu.patch
mm-page-allocator-update-free-page-counters-after-pages-are-placed-on-the-free-list.patch
mm-page-allocator-update-free-page-counters-after-pages-are-placed-on-the-free-list-fix.patch
mm-page-allocator-drain-per-cpu-lists-after-direct-reclaim-allocation-fails.patch
mm-vmap-area-cache.patch
mm-compaction-fix-compactpagefailed-counting.patch
vmscan-prevent-background-aging-of-anon-page-in-no-swap-system.patch

