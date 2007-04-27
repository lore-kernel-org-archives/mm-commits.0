From: akpm@linux-foundation.org
Subject: - lumpy-back-out-removal-of-active-check-in-isolate_lru_pages.patch removed from -mm tree
Date: Fri, 27 Apr 2007 01:16:56 -0700
Message-ID: <200704270816.l3R8GuPi023119@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755492AbXD0IRe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 04:17:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     lumpy: back out removal of active check in isolate_lru_pages
has been removed from the -mm tree.  Its filename was
     lumpy-back-out-removal-of-active-check-in-isolate_lru_pages.patch

This patch was dropped because it was folded into lumpy-reclaim-v4.patch

------------------------------------------------------
Subject: lumpy: back out removal of active check in isolate_lru_pages
From: Andy Whitcroft <apw@shadowen.org>

As pointed out by Christop Lameter it should not be possible for a page to
change its active/inactive state without taking the lru_lock.  Reinstate this
safety net.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~lumpy-back-out-removal-of-active-check-in-isolate_lru_pages mm/vmscan.c
--- a/mm/vmscan.c~lumpy-back-out-removal-of-active-check-in-isolate_lru_pages
+++ a/mm/vmscan.c
@@ -683,10 +683,13 @@ static unsigned long isolate_lru_pages(u
 			nr_taken++;
 			break;
 
-		default:
-			/* page is being freed, or is a missmatch */
+		case -EBUSY:
+			/* else it is being freed elsewhere */
 			list_move(&page->lru, src);
 			continue;
+
+		default:
+			BUG();
 		}
 
 		if (!order)
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
lumpy-back-out-removal-of-active-check-in-isolate_lru_pages.patch
lumpy-only-count-taken-pages-as-scanned.patch
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
