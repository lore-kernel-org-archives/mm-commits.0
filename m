From: akpm@linux-foundation.org
Subject: + move-free-pages-between-lists-on-steal-avoid-unsafe-use-of-struct-pages-in-move_freepages-when-config_holes_in_zone-is-set.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:52:25 -0800
Message-ID: <200703151852.l2FIqR9x023386@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35689 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340AbXCOSwh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:52:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, bjorn.helgaas@hp.com


The patch titled
     Avoid unsafe use of struct pages in move_freepages when CONFIG_HOLES_IN_ZONE is set
has been added to the -mm tree.  Its filename is
     move-free-pages-between-lists-on-steal-avoid-unsafe-use-of-struct-pages-in-move_freepages-when-config_holes_in_zone-is-set.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Avoid unsafe use of struct pages in move_freepages when CONFIG_HOLES_IN_ZONE is set
From: Mel Gorman <mel@csn.ul.ie>

In the majority of situations, mem_map is guaranteed to be valid within a
MAX_ORDER_NR_PAGES block of pages.  However, when CONFIG_HOLES_IN_ZONE is
set, there is no guarantee that mem_map exists for the entire block.  This
means that when checking struct pages around a known valid page, there is
no guarantee they are valid.

move_freepages() operates on a MAX_ORDER_NR_PAGES range of pages based on
a known valid page retrieved from the free lists. However, a bug check is
unsafe when CONFIG_HOLES_IN_ZONE is set and pfn_valid() is called too late.

This patch disables the bug check when CONFIG_HOLES_IN_ZONE and checks
pfn_valid() earlier before calling PageBuddy().  It applies on top of
move-free-pages-between-lists-on-steal-fix-2.patch from Yasunori Goto in
-mm.

Credit to Bjorn Helgaas for reporting this bug and testing.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~move-free-pages-between-lists-on-steal-avoid-unsafe-use-of-struct-pages-in-move_freepages-when-config_holes_in_zone-is-set mm/page_alloc.c
--- a/mm/page_alloc.c~move-free-pages-between-lists-on-steal-avoid-unsafe-use-of-struct-pages-in-move_freepages-when-config_holes_in_zone-is-set
+++ a/mm/page_alloc.c
@@ -673,13 +673,18 @@ int move_freepages(struct zone *zone,
 	unsigned long order;
 	int blocks_moved = 0;
 
+#ifndef CONFIG_HOLES_IN_ZONE
+	/*
+	 * page_zone is not safe to call in this context when
+	 * CONFIG_HOLES_IN_ZONE is set. This bug check is probably redundant
+	 * anyway as we check zone boundaries in move_freepages_block().
+	 * Remove at a later date when no bug reports exist related to
+	 * CONFIG_PAGE_GROUP_BY_MOBILITY
+	 */
 	BUG_ON(page_zone(start_page) != page_zone(end_page - 1));
+#endif
 
 	for (page = start_page; page < end_page;) {
-		if (!PageBuddy(page)) {
-			page++;
-			continue;
-		}
 #ifdef CONFIG_HOLES_IN_ZONE
 		if (!pfn_valid(page_to_pfn(page))) {
 			page++;
@@ -687,6 +692,11 @@ int move_freepages(struct zone *zone,
 		}
 #endif
 
+		if (!PageBuddy(page)) {
+			page++;
+			continue;
+		}
+
 		order = page_order(page);
 		list_del(&page->lru);
 		list_add(&page->lru,
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
move-free-pages-between-lists-on-steal-fix-2.patch
move-free-pages-between-lists-on-steal-avoid-unsafe-use-of-struct-pages-in-move_freepages-when-config_holes_in_zone-is-set.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
group-high-order-atomic-allocations.patch
bias-the-placement-of-kernel-pages-at-lower-pfns.patch
be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
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
