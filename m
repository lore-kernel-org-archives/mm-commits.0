From: akpm@linux-foundation.org
Subject: + add-__gfp_movable-for-callers-to-flag-allocations-from-low-memory-that-may-be-migrated.patch added to -mm tree
Date: Fri, 02 Mar 2007 13:41:29 -0800
Message-ID: <200703022141.l22LfUsu019756@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42037 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbXCBVle (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 16:41:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie


The patch titled
     Add __GFP_MOVABLE for callers to flag allocations from low memory that may be migrated
has been added to the -mm tree.  Its filename is
     add-__gfp_movable-for-callers-to-flag-allocations-from-low-memory-that-may-be-migrated.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -574,7 +574,7 @@ struct block_device *bdget(dev_t dev)
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
@@ -2633,7 +2633,7 @@ int submit_bh(int rw, struct buffer_head
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
drain-per-cpu-lists-when-high-order-allocations-fail.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
group-high-order-atomic-allocations.patch
bias-the-placement-of-kernel-pages-at-lower-pfns.patch
be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch
create-the-zone_movable-zone.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
x86-specify-amount-of-kernel-memory-at-boot-time.patch
ppc-and-powerpc-specify-amount-of-kernel-memory-at-boot-time.patch
x86_64-specify-amount-of-kernel-memory-at-boot-time.patch
ia64-specify-amount-of-kernel-memory-at-boot-time.patch
add-documentation-for-additional-boot-parameter-and-sysctl.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
add-debugging-aid-for-memory-initialisation-problems.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
