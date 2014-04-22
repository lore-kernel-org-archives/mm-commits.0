From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal.patch added to -mm tree
Date: Tue, 22 Apr 2014 12:32:03 -0700
Message-ID: <5356c3b3.i/WvY1axt77Mq8M6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48640 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbaDVTcE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Apr 2014 15:32:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de

Subject: + mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal.patch added to -mm tree
To: mgorman@suse.de
From: akpm@linux-foundation.org
Date: Tue, 22 Apr 2014 12:32:03 -0700


The patch titled
     Subject: mm: vmscan: do not throttle based on pfmemalloc reserves if node has no ZONE_NORMAL
has been added to the -mm tree.  Its filename is
     mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmscan: do not throttle based on pfmemalloc reserves if node has no ZONE_NORMAL

throttle_direct_reclaim() is meant to trigger during swap-over-network
during which the min watermark is treated as a pfmemalloc reserve.  It
throttes on the first node in the zonelist but this is flawed.

On a NUMA machine running a 32-bit kernel (I know) allocation requests
freom CPUs on node 1 would detect no pfmemalloc reserves and the process
gets throttled.  This patch adjusts throttling of direct reclaim to
throttle based on the first node in the zonelist that has a usable
ZONE_NORMAL or lower zone.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal
+++ a/mm/vmscan.c
@@ -2522,10 +2522,17 @@ static bool pfmemalloc_watermark_ok(pg_d
 
 	for (i = 0; i <= ZONE_NORMAL; i++) {
 		zone = &pgdat->node_zones[i];
+		if (!populated_zone(zone))
+			continue;
+
 		pfmemalloc_reserve += min_wmark_pages(zone);
 		free_pages += zone_page_state(zone, NR_FREE_PAGES);
 	}
 
+	/* If there are no reserves (unexpected config) then do not throttle */
+	if (!pfmemalloc_reserve)
+		return true;
+
 	wmark_ok = free_pages > pfmemalloc_reserve / 2;
 
 	/* kswapd must be awake if processes are being throttled */
@@ -2550,9 +2557,9 @@ static bool pfmemalloc_watermark_ok(pg_d
 static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
 					nodemask_t *nodemask)
 {
+	struct zoneref *z;
 	struct zone *zone;
-	int high_zoneidx = gfp_zone(gfp_mask);
-	pg_data_t *pgdat;
+	pg_data_t *pgdat = NULL;
 
 	/*
 	 * Kernel threads should not be throttled as they may be indirectly
@@ -2571,10 +2578,24 @@ static bool throttle_direct_reclaim(gfp_
 	if (fatal_signal_pending(current))
 		goto out;
 
-	/* Check if the pfmemalloc reserves are ok */
-	first_zones_zonelist(zonelist, high_zoneidx, NULL, &zone);
-	pgdat = zone->zone_pgdat;
-	if (pfmemalloc_watermark_ok(pgdat))
+	/*
+	 * Check if the pfmemalloc reserves are ok by finding the first node
+	 * with a usable ZONE_NORMAL or lower zone
+	 */
+        for_each_zone_zonelist_nodemask(zone, z, zonelist,
+                                        gfp_mask, nodemask) {
+		if (zone_idx(zone) > ZONE_NORMAL)
+			continue;
+
+		/* Throttle based on the first usable node */
+		pgdat = zone->zone_pgdat;
+		if (pfmemalloc_watermark_ok(pgdat))
+			goto out;
+		break;
+	}
+
+	/* If no zone was usable by the allocation flags then do not throttle */
+	if (!pgdat)
 		goto out;
 
 	/* Account for the throttling */
_

Patches currently in -mm which might be from mgorman@suse.de are

hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported.patch
hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix.patch
mm-compaction-make-isolate_freepages-start-at-pageblock-boundary.patch
x86-require-x86-64-for-automatic-numa-balancing.patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels.patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
mm-disable-zone_reclaim_mode-by-default.patch
mm-page_alloc-do-not-cache-reclaim-distances.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
mm-swapc-clean-up-lru_cache_add-functions.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

