From: akpm@linux-foundation.org
Subject: [folded] vmscan-limit-direct-reclaim-for-higher-order-allocations-fix.patch removed from -mm tree
Date: Mon, 31 Oct 2011 16:46:59 -0700
Message-ID: <201110312347.p9VNl0Nw007997@wpaz13.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:53116 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab1JaXrG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2011 19:47:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jweiner@redhat.com, aarcange@redhat.com, mgorman@suse.de, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan-limit-direct-reclaim-for-higher-order-allocations-fix
has been removed from the -mm tree.  Its filename was
     vmscan-limit-direct-reclaim-for-higher-order-allocations-fix.patch

This patch was dropped because it was folded into vmscan-limit-direct-reclaim-for-higher-order-allocations.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <jweiner@redhat.com>
Subject: vmscan-limit-direct-reclaim-for-higher-order-allocations-fix

change comment to explain the order check

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~vmscan-limit-direct-reclaim-for-higher-order-allocations-fix mm/vmscan.c
--- a/mm/vmscan.c~vmscan-limit-direct-reclaim-for-higher-order-allocations-fix
+++ a/mm/vmscan.c
@@ -2115,8 +2115,14 @@ static void shrink_zones(int priority, s
 				continue;	/* Let kswapd poll it */
 			if (COMPACTION_BUILD) {
 				/*
-				 * If we already have plenty of memory free
-				 * for compaction, don't free any more.
+				 * If we already have plenty of memory
+				 * free for compaction, don't free any
+				 * more.  Even though compaction is
+				 * invoked for any non-zero order,
+				 * only frequent costly order
+				 * reclamation is disruptive enough to
+				 * become a noticable problem, like
+				 * transparent huge page allocations.
 				 */
 				if (sc->order > PAGE_ALLOC_COSTLY_ORDER &&
 					(compaction_suitable(zone, sc->order) ||
_

Patches currently in -mm which might be from jweiner@redhat.com are

mm-page-writebackc-document-bdi_min_ratio.patch
mm-vmscan-drop-nr_force_scan-from-get_scan_count.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
mm-vmscan-remove-dead-code-related-to-lumpy-reclaim-waiting-on-pages-under-writeback.patch
xfs-warn-if-direct-reclaim-tries-to-writeback-pages.patch
ext4-warn-if-direct-reclaim-tries-to-writeback-pages.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-kswapd-except-in-high-priority.patch
mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback.patch
mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes.patch
mremap-check-for-overflow-using-deltas.patch
mremap-avoid-sending-one-ipi-per-page.patch
thp-mremap-support-and-tlb-optimization.patch
vmscanc-fix-invalid-strict_strtoul-check-in-write_scan_unevictable_node.patch
mm-disable-user-interface-to-manually-rescue-unevictable-pages.patch
mm-huge_memoryc-quiet-sparse-noise.patch
vmscan-add-barrier-to-prevent-evictable-page-in-unevictable-list.patch
vmscan-limit-direct-reclaim-for-higher-order-allocations.patch
vmscan-abort-reclaim-compaction-if-compaction-can-proceed.patch
mm-do-not-drain-pagevecs-for-mlockallmcl_future.patch
mm-huge_memory-fix-copying-user-highpage.patch
mm-huge_memory-fix-typo-when-updating-mmu-cache.patch

