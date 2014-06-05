From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:50:15 -0700
Message-ID: <5390c9f7.hOduOkbVLFGP5cKM%akpm__48293.335925746$1401997832$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55970 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbaFETuQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:50:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, mgorman@suse.de

Subject: [merged] mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal.patch removed from -mm tree
To: mgorman@suse.de,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:50:15 -0700


The patch titled
     Subject: mm: vmscan: do not throttle based on pfmemalloc reserves if node has no ZONE_NORMAL
has been removed from the -mm tree.  Its filename was
     mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmscan: do not throttle based on pfmemalloc reserves if node has no ZONE_NORMAL

throttle_direct_reclaim() is meant to trigger during swap-over-network
during which the min watermark is treated as a pfmemalloc reserve.  It
throttes on the first node in the zonelist but this is flawed.

The user-visible impact is that a process running on CPU whose local
memory node has no ZONE_NORMAL will stall for prolonged periods of time,
possibly indefintely.  This is due to throttle_direct_reclaim thinking the
pfmemalloc reserves are depleted when in fact they don't exist on that
node.

On a NUMA machine running a 32-bit kernel (I know) allocation requests
from CPUs on node 1 would detect no pfmemalloc reserves and the process
gets throttled.  This patch adjusts throttling of direct reclaim to
throttle based on the first node in the zonelist that has a usable
ZONE_NORMAL or lower zone.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   43 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 6 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal
+++ a/mm/vmscan.c
@@ -2537,10 +2537,17 @@ static bool pfmemalloc_watermark_ok(pg_d
 
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
@@ -2565,9 +2572,9 @@ static bool pfmemalloc_watermark_ok(pg_d
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
@@ -2586,10 +2593,34 @@ static bool throttle_direct_reclaim(gfp_
 	if (fatal_signal_pending(current))
 		goto out;
 
-	/* Check if the pfmemalloc reserves are ok */
-	first_zones_zonelist(zonelist, high_zoneidx, NULL, &zone);
-	pgdat = zone->zone_pgdat;
-	if (pfmemalloc_watermark_ok(pgdat))
+	/*
+	 * Check if the pfmemalloc reserves are ok by finding the first node
+	 * with a usable ZONE_NORMAL or lower zone. The expectation is that
+	 * GFP_KERNEL will be required for allocating network buffers when
+	 * swapping over the network so ZONE_HIGHMEM is unusable.
+	 *
+	 * Throttling is based on the first usable node and throttled processes
+	 * wait on a queue until kswapd makes progress and wakes them. There
+	 * is an affinity then between processes waking up and where reclaim
+	 * progress has been made assuming the process wakes on the same node.
+	 * More importantly, processes running on remote nodes will not compete
+	 * for remote pfmemalloc reserves and processes on different nodes
+	 * should make reasonable progress.
+	 */
+	for_each_zone_zonelist_nodemask(zone, z, zonelist,
+					gfp_mask, nodemask) {
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

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
linux-next.patch

