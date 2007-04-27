From: akpm@linux-foundation.org
Subject: - kswapd-use-reclaim-order-in-background-reclaim.patch removed from -mm tree
Date: Fri, 27 Apr 2007 01:17:01 -0700
Message-ID: <200704270817.l3R8H1Ae023127@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755502AbXD0IRh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 04:17:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     kswapd: use reclaim order in background reclaim
has been removed from the -mm tree.  Its filename was
     kswapd-use-reclaim-order-in-background-reclaim.patch

This patch was dropped because it was folded into lumpy-reclaim-v4.patch

------------------------------------------------------
Subject: kswapd: use reclaim order in background reclaim
From: Andy Whitcroft <apw@shadowen.org>

When an allocator has to dip below the low water mark for a zone, kswapd is
awoken to start background reclaim.  The highest order of these dipping
allocations are accumulated on the zone.  With this patch kswapd uses this
hint to force reclaim at that order via balance_pgdat().

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/vmscan.c~kswapd-use-reclaim-order-in-background-reclaim mm/vmscan.c
--- a/mm/vmscan.c~kswapd-use-reclaim-order-in-background-reclaim
+++ a/mm/vmscan.c
@@ -1226,6 +1226,7 @@ static unsigned long balance_pgdat(pg_da
 		.may_swap = 1,
 		.swap_cluster_max = SWAP_CLUSTER_MAX,
 		.swappiness = vm_swappiness,
+		.order = order,
 	};
 	/*
 	 * temp_priority is used to remember the scanning priority at which
_

Patches currently in -mm which might be from apw@shadowen.org are

pci-device-ensure-sysdata-initialised-v2.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-a-configure-option-to-group-pages-by-mobility.patch
move-free-pages-between-lists-on-steal.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
create-the-zone_movable-zone.patch
handle-kernelcore=-boot-parameter-in-common-code-to-avoid-boot-problem-on-ia64.patch
lumpy-reclaim-v4.patch
kswapd-use-reclaim-order-in-background-reclaim.patch
lumpy-increase-pressure-at-the-end-of-the-inactive-list.patch
introduce-high_order-delineating-easily-reclaimable-orders.patch
introduce-high_order-delineating-easily-reclaimable-orders-cleanups.patch
lumpy-increase-pressure-at-the-end-of-the-inactive-list-cleanups.patch
add-pfn_valid_within-helper-for-sub-max_order-hole-detection.patch
anti-fragmentation-switch-over-to-pfn_valid_within.patch
lumpy-move-to-using-pfn_valid_within.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy-fix.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
slab-numa-kmem_cache-diet.patch
sched-implement-staircase-deadline-cpu-scheduler-misc-fixes.patch
