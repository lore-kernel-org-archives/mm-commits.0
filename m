From: akpm@linux-foundation.org
Subject: + move-free-pages-between-lists-on-steal-fix.patch added to -mm tree
Date: Wed, 07 Mar 2007 13:28:40 -0800
Message-ID: <200703072128.l27LSeln009617@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59280 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992611AbXCGV2v (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 16:28:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, apw@shadowen.org, clameter@engr.sgi.com


The patch titled
     Fix boot problem on IA64 with CONFIG_HOLE_IN_ZONES and CONFIG_PAGE_GROUP_BY_MOBILITY
has been added to the -mm tree.  Its filename is
     move-free-pages-between-lists-on-steal-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix boot problem on IA64 with CONFIG_HOLE_IN_ZONES and CONFIG_PAGE_GROUP_BY_MOBILITY
From: mel@skynet.ie (Mel Gorman)

Usually, a mem_map is aligned on MAX_ORDER_NR_PAGES boundaries and the
struct pages are always valid.  However, this is not always the case when
CONFIG_HOLES_IN_ZONE is set.

move_freepages_block() checks that pages within a MAX_ORDER_NR_PAGES block
are in the same zone using page_zone().  However, if an invalid page is
passed to page_zone(), it can result in breakage on machines requiring
CONFIG_HOLES_IN_ZONE.  This patch avoids the use of page_zone() and instead
checks the PFNs against the PFN ranges of the zone.  This fixes a boot
problem on IA64 using the config arch/ia64/configs/sn2_defconfig .

Credit to Christoph Lameter for testing, reporting the bug and verifying
this fixes the problem.  Credit to Andy Whitcroft for giving the patch a
quick review to ensure no functionality was changed.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~move-free-pages-between-lists-on-steal-fix mm/page_alloc.c
--- a/mm/page_alloc.c~move-free-pages-between-lists-on-steal-fix
+++ a/mm/page_alloc.c
@@ -700,18 +700,19 @@ int move_freepages(struct zone *zone,
 
 int move_freepages_block(struct zone *zone, struct page *page, int migratetype)
 {
-	unsigned long start_pfn;
+	unsigned long start_pfn, end_pfn;
 	struct page *start_page, *end_page;
 
 	start_pfn = page_to_pfn(page);
 	start_pfn = start_pfn & ~(MAX_ORDER_NR_PAGES-1);
 	start_page = pfn_to_page(start_pfn);
 	end_page = start_page + MAX_ORDER_NR_PAGES;
+	end_pfn = start_pfn + MAX_ORDER_NR_PAGES;
 
 	/* Do not cross zone boundaries */
-	if (page_zone(page) != page_zone(start_page))
+	if (start_pfn < zone->zone_start_pfn)
 		start_page = page;
-	if (page_zone(page) != page_zone(end_page))
+	if (end_pfn >= zone->zone_start_pfn + zone->spanned_pages)
 		return 0;
 
 	return move_freepages(zone, start_page, end_page, migratetype);
_

Patches currently in -mm which might be from mel@csn.ul.ie are

add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-low-memory-that-may-be-migrated.patch
split-the-free-lists-for-movable-and-unmovable-allocations.patch
choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
add-a-configure-option-to-group-pages-by-mobility.patch
drain-per-cpu-lists-when-high-order-allocations-fail.patch
move-free-pages-between-lists-on-steal.patch
move-free-pages-between-lists-on-steal-fix.patch
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
