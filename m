From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-check-for-fatal-signals-iff-the-process-was-throttled.patch removed from -mm tree
Date: Fri, 30 Nov 2012 13:28:32 -0800
Message-ID: <20121130212833.4E53320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:65060 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab2K3V2g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Nov 2012 16:28:36 -0500
Received: by mail-fa0-f74.google.com with SMTP id t1so64400fae.1
        for <mm-commits@vger.kernel.org>; Fri, 30 Nov 2012 13:28:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, dan.magenheimer@oracle.com, kosaki.motohiro@jp.fujitsu.com, minchan@kernel.org, rientjes@google.com, semenzato@google.com, sonnyrao@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: check for fatal signals iff the process was throttled
has been removed from the -mm tree.  Its filename was
     mm-vmscan-check-for-fatal-signals-iff-the-process-was-throttled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmscan: check for fatal signals iff the process was throttled

commit 5515061d22f0 ("mm: throttle direct reclaimers if PF_MEMALLOC
reserves are low and swap is backed by network storage") introduced a
check for fatal signals after a process gets throttled for network
storage.  The intention was that if a process was throttled and got killed
that it should not trigger the OOM killer.  As pointed out by Minchan Kim
and David Rientjes, this check is in the wrong place and too broad.  If a
system is in am OOM situation and a process is exiting, it can loop in
__alloc_pages_slowpath() and calling direct reclaim in a loop.  As the
fatal signal is pending it returns 1 as if it is making forward progress
and can effectively deadlock.

This patch moves the fatal_signal_pending() check after throttling to
throttle_direct_reclaim() where it belongs.  If the process is killed
while throttled, it will return immediately without direct reclaim except
now it will have TIF_MEMDIE set and will use the PFMEMALLOC reserves.

Minchan pointed out that it may be better to direct reclaim before
returning to avoid using the reserves because there may be pages that can
easily reclaim that would avoid using the reserves.  However, we do no
such targetted reclaim and there is no guarantee that suitable pages are
available.  As it is expected that this throttling happens when
swap-over-NFS is used there is a possibility that the process will instead
swap which may allocate network buffers from the PFMEMALLOC reserves. 
Hence, in the swap-over-nfs case where a process can be throtted and be
killed it can use the reserves to exit or it can potentially use reserves
to swap a few pages and then exit.  This patch takes the option of using
the reserves if necessary to allow the process exit quickly.

If this patch passes review it should be considered a -stable candidate
for 3.6.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Luigi Semenzato <semenzato@google.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Sonny Rao <sonnyrao@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-check-for-fatal-signals-iff-the-process-was-throttled mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-check-for-fatal-signals-iff-the-process-was-throttled
+++ a/mm/vmscan.c
@@ -2207,9 +2207,12 @@ static bool pfmemalloc_watermark_ok(pg_d
  * Throttle direct reclaimers if backing storage is backed by the network
  * and the PFMEMALLOC reserve for the preferred node is getting dangerously
  * depleted. kswapd will continue to make progress and wake the processes
- * when the low watermark is reached
+ * when the low watermark is reached.
+ *
+ * Returns true if a fatal signal was delivered during throttling. If this
+ * happens, the page allocator should not consider triggering the OOM killer.
  */
-static void throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
+static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
 					nodemask_t *nodemask)
 {
 	struct zone *zone;
@@ -2224,13 +2227,20 @@ static void throttle_direct_reclaim(gfp_
 	 * processes to block on log_wait_commit().
 	 */
 	if (current->flags & PF_KTHREAD)
-		return;
+		goto out;
+
+	/*
+	 * If a fatal signal is pending, this process should not throttle.
+	 * It should return quickly so it can exit and free its memory
+	 */
+	if (fatal_signal_pending(current))
+		goto out;
 
 	/* Check if the pfmemalloc reserves are ok */
 	first_zones_zonelist(zonelist, high_zoneidx, NULL, &zone);
 	pgdat = zone->zone_pgdat;
 	if (pfmemalloc_watermark_ok(pgdat))
-		return;
+		goto out;
 
 	/* Account for the throttling */
 	count_vm_event(PGSCAN_DIRECT_THROTTLE);
@@ -2246,12 +2256,20 @@ static void throttle_direct_reclaim(gfp_
 	if (!(gfp_mask & __GFP_FS)) {
 		wait_event_interruptible_timeout(pgdat->pfmemalloc_wait,
 			pfmemalloc_watermark_ok(pgdat), HZ);
-		return;
+
+		goto check_pending;
 	}
 
 	/* Throttle until kswapd wakes the process */
 	wait_event_killable(zone->zone_pgdat->pfmemalloc_wait,
 		pfmemalloc_watermark_ok(pgdat));
+
+check_pending:
+	if (fatal_signal_pending(current))
+		return true;
+
+out:
+	return false;
 }
 
 unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
@@ -2273,13 +2291,12 @@ unsigned long try_to_free_pages(struct z
 		.gfp_mask = sc.gfp_mask,
 	};
 
-	throttle_direct_reclaim(gfp_mask, zonelist, nodemask);
-
 	/*
-	 * Do not enter reclaim if fatal signal is pending. 1 is returned so
-	 * that the page allocator does not consider triggering OOM
+	 * Do not enter reclaim if fatal signal was delivered while throttled.
+	 * 1 is returned so that the page allocator does not OOM kill at this
+	 * point.
 	 */
-	if (fatal_signal_pending(current))
+	if (throttle_direct_reclaim(gfp_mask, zonelist, nodemask))
 		return 1;
 
 	trace_mm_vmscan_direct_reclaim_begin(order,
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
memory_hotplug-fix-possible-incorrect-node_states.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mm-add-comment-on-storage-key-dirty-bit-semantics.patch
mm-refactor-reinsert-of-swap_info-in-sys_swapoff.patch
mm-do-not-call-frontswap_init-during-swapoff.patch
mm-memmap_init_zone-performance-improvement.patch
mm-allocate-kernel-pages-to-the-right-memcg.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory.patch
memory_hotplug-handle-empty-zone-when-online_movable-online_kernel.patch
memory_hotplug-ensure-every-online-node-has-normal-memory.patch
mm-compaction-fix-compiler-warning.patch
mm-add-a-reminder-comment-for-__gfp_bits_shift.patch
numa-add-config_movable_node-for-movable-dedicated-node.patch
numa-add-config_movable_node-for-movable-dedicated-node-fix.patch
memory_hotplug-allow-online-offline-memory-to-result-movable-node.patch
mm-introduce-new-field-managed_pages-to-struct-zone.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap-fix.patch

