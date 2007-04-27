From: akpm@linux-foundation.org
Subject: - add-__gfp_movable-for-callers-to-flag-allocations-from-low-memory-that-may-be-migrated.patch removed from -mm tree
Date: Fri, 27 Apr 2007 01:07:29 -0700
Message-ID: <200704270807.l3R87TN8022883@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47358 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755476AbXD0IHg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 04:07:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Add __GFP_MOVABLE for callers to flag allocations from low memory that may be migrated
has been removed from the -mm tree.  Its filename was
     add-__gfp_movable-for-callers-to-flag-allocations-from-low-memory-that-may-be-migrated.patch

This patch was dropped because it was folded into add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch

------------------------------------------------------
Subject: Add __GFP_MOVABLE for callers to flag allocations from low memory that may be migrated
From: Mel Gorman <mel@csn.ul.ie>

This patch flags the allocations from low memory that may be migrated.

A GFP_USER_MOVABLE similar to GFP_HIGH_MOVABLE is not provided in this patch
because it would only be used once.  This patch uses __GFP_MOVABLE twice for a
GFP_USER and a GFP_NOIO allocation.  There is little point defining
GFP_*_MOVABLE for one use unless people feel it would help self-documentation.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    2 +-
 fs/buffer.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/block_dev.c~add-__gfp_movable-for-callers-to-flag-allocations-from-low-memory-that-may-be-migrated fs/block_dev.c
--- a/fs/block_dev.c~add-__gfp_movable-for-callers-to-flag-allocations-from-low-memory-that-may-be-migrated
+++ a/fs/block_dev.c
@@ -575,7 +575,7 @@ struct block_device *bdget(dev_t dev)
 		inode->i_rdev = dev;
 		inode->i_bdev = bdev;
 		inode->i_data.a_ops = &def_blk_aops;
-		mapping_set_gfp_mask(&inode->i_data, GFP_USER);
+		mapping_set_gfp_mask(&inode->i_data, GFP_USER|__GFP_MOVABLE);
 		inode->i_data.backing_dev_info = &default_backing_dev_info;
 		spin_lock(&bdev_lock);
 		list_add(&bdev->bd_list, &all_bdevs);
diff -puN fs/buffer.c~add-__gfp_movable-for-callers-to-flag-allocations-from-low-memory-that-may-be-migrated fs/buffer.c
--- a/fs/buffer.c~add-__gfp_movable-for-callers-to-flag-allocations-from-low-memory-that-may-be-migrated
+++ a/fs/buffer.c
@@ -2650,7 +2650,7 @@ int submit_bh(int rw, struct buffer_head
 	 * from here on down, it's all bio -- do the initial mapping,
 	 * submit_bio -> generic_make_request may further map this bio around
 	 */
-	bio = bio_alloc(GFP_NOIO, 1);
+	bio = bio_alloc(GFP_NOIO|__GFP_MOVABLE, 1);
 
 	bio->bi_sector = bh->b_blocknr * (bh->b_size >> 9);
 	bio->bi_bdev = bh->b_bdev;
_

Patches currently in -mm which might be from mel@csn.ul.ie are

add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-low-memory-that-may-be-migrated.patch
split-the-free-lists-for-movable-and-unmovable-allocations.patch
choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
add-a-configure-option-to-group-pages-by-mobility.patch
add-a-configure-option-to-group-pages-by-mobility-speedup.patch
drain-per-cpu-lists-when-high-order-allocations-fail.patch
move-free-pages-between-lists-on-steal.patch
move-free-pages-between-lists-on-steal-fix.patch
move-free-pages-between-lists-on-steal-fix-2.patch
move-free-pages-between-lists-on-steal-avoid-unsafe-use-of-struct-pages-in-move_freepages-when-config_holes_in_zone-is-set.patch
move-free-pages-between-lists-on-steal-do-not-cross-section-boundary-when-moving-pages-between-mobility-lists.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
group-high-order-atomic-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
bias-the-placement-of-kernel-pages-at-lower-pfns.patch
be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
create-the-zone_movable-zone.patch
create-the-zone_movable-zone-align-zone_movable-to-a-max_order_nr_pages-boundary.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
x86-specify-amount-of-kernel-memory-at-boot-time.patch
ppc-and-powerpc-specify-amount-of-kernel-memory-at-boot-time.patch
x86_64-specify-amount-of-kernel-memory-at-boot-time.patch
ia64-specify-amount-of-kernel-memory-at-boot-time.patch
add-documentation-for-additional-boot-parameter-and-sysctl.patch
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
do-not-disable-interrupts-when-reading-min_free_kbytes.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
add-debugging-aid-for-memory-initialisation-problems.patch
