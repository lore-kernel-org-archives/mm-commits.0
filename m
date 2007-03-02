From: akpm@linux-foundation.org
Subject: + be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch added to -mm tree
Date: Fri, 02 Mar 2007 13:41:47 -0800
Message-ID: <200703022141.l22LflV4019786@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42069 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030468AbXCBVlv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 16:41:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie


The patch titled
     Be more agressive about stealing when MIGRATE_RECLAIMABLE allocations fallback
has been added to the -mm tree.  Its filename is
     be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Be more agressive about stealing when MIGRATE_RECLAIMABLE allocations fallback
From: Mel Gorman <mel@csn.ul.ie>

MIGRATE_RECLAIMABLE allocations tend to be very bursty in nature like when
updatedb starts.  It is likely this will occur in situations where MAX_ORDER
blocks of pages are not free.  This means that updatedb can scatter
MIGRATE_RECLAIMABLE pages throughout the address space.  This patch is more
agressive about stealing blocks of pages for MIGRATE_RECLAIMABLE.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback mm/page_alloc.c
--- a/mm/page_alloc.c~be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback
+++ a/mm/page_alloc.c
@@ -791,11 +791,23 @@ retry:
 
 			/*
 			 * If breaking a large block of pages, move all free
-			 * pages to the preferred allocation list
+			 * pages to the preferred allocation list. If falling
+			 * back for a reclaimable kernel allocation, be more
+			 * agressive about taking ownership of free pages
 			 */
-			if (unlikely(current_order >= MAX_ORDER / 2)) {
+			if (unlikely(current_order >= MAX_ORDER / 2) ||
+					start_migratetype == MIGRATE_RECLAIMABLE) {
+				unsigned long pages;
+				pages = move_freepages_block(zone, page,
+								start_migratetype);
+
+				/* Claim the whole block if over half of it is free */
+				if ((pages << current_order) >= (1 << (MAX_ORDER-2)) &&
+						migratetype != MIGRATE_HIGHATOMIC)
+					set_pageblock_migratetype(page,
+								start_migratetype);
+
 				migratetype = start_migratetype;
-				move_freepages_block(zone, page, migratetype);
 			}
 
 			/* Remove the page from the freelists */
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
