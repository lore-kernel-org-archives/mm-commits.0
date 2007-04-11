From: akpm@linux-foundation.org
Subject: + do-not-group-pages-by-mobility-type-on-low-memory-systems.patch added to -mm tree
Date: Tue, 10 Apr 2007 17:14:14 -0700
Message-ID: <200704110014.l3B0EEkA023818@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53345 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161133AbXDKAOY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 20:14:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, apw@shadowen.org


The patch titled
     Do not group pages by mobility type on low memory systems
has been added to the -mm tree.  Its filename is
     do-not-group-pages-by-mobility-type-on-low-memory-systems.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Do not group pages by mobility type on low memory systems
From: Mel Gorman <mel@csn.ul.ie>

Grouping pages by mobility can only successfully operate when there are more
MAX_ORDER_NR_PAGES areas than mobility types.  When there are insufficient
areas, fallbacks cannot be avoided.  This has noticeable performance impacts
on machines with small amounts of memory in comparison to MAX_ORDER_NR_PAGES. 
For example, on IA64 with a configuration including huge pages spans 1GiB with
MAX_ORDER_NR_PAGES so would need at least 4GiB of RAM before grouping pages by
mobility would be useful.  In comparison, an x86 would need 16MB.

This patch checks the size of vm_total_pages in build_all_zonelists(). If
there are not enough areas,  mobility is effectivly disabled by considering
all allocations as the same type (UNMOVABLE).  This is achived via a
__read_mostly flag.

With this patch, performance is comparable to disabling grouping pages
by mobility at compile-time on a test machine with insufficient memory.
With this patch, it is reasonable to get rid of grouping pages by mobility
a compile-time option.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   27 +++++++++++++++++++++++++--
 1 files changed, 25 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~do-not-group-pages-by-mobility-type-on-low-memory-systems mm/page_alloc.c
--- a/mm/page_alloc.c~do-not-group-pages-by-mobility-type-on-low-memory-systems
+++ a/mm/page_alloc.c
@@ -137,8 +137,13 @@ static unsigned long __initdata dma_rese
 #endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
 
 #ifdef CONFIG_PAGE_GROUP_BY_MOBILITY
+int page_group_by_mobility_disabled __read_mostly;
+
 static inline int get_pageblock_migratetype(struct page *page)
 {
+	if (unlikely(page_group_by_mobility_disabled))
+		return MIGRATE_UNMOVABLE;
+
 	return get_pageblock_flags_group(page, PB_migrate, PB_migrate_end);
 }
 
@@ -152,6 +157,9 @@ static inline int allocflags_to_migratet
 {
 	WARN_ON((gfp_flags & GFP_MOVABLE_MASK) == GFP_MOVABLE_MASK);
 
+	if (unlikely(page_group_by_mobility_disabled))
+		return MIGRATE_UNMOVABLE;
+
 	/* Cluster high-order atomic allocations together */
 	if (unlikely(order > 0) &&
 			(!(gfp_flags & __GFP_WAIT) || in_interrupt()))
@@ -2129,8 +2137,23 @@ void __meminit build_all_zonelists(void)
 		/* cpuset refresh routine should be here */
 	}
 	vm_total_pages = nr_free_pagecache_pages();
-	printk("Built %i zonelists.  Total pages: %ld\n",
-			num_online_nodes(), vm_total_pages);
+
+	/*
+	 * Disable grouping by mobility if the number of pages in the
+	 * system is too low to allow the mechanism to work. It would be
+	 * more accurate, but expensive to check per-zone. This check is
+	 * made on memory-hotadd so a system can start with mobility
+	 * disabled and enable it later
+	 */
+	if (vm_total_pages < (MAX_ORDER_NR_PAGES * MIGRATE_TYPES))
+		page_group_by_mobility_disabled = 1;
+	else
+		page_group_by_mobility_disabled = 0;
+
+	printk("Built %i zonelists, mobility grouping %s.  Total pages: %ld\n",
+			num_online_nodes(),
+			page_group_by_mobility_disabled ? "off" : "on",
+			vm_total_pages);
 }
 
 /*
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
move-free-pages-between-lists-on-steal-do-not-cross-section-boundary-when-moving-pages-between-mobility-lists.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
group-high-order-atomic-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
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
lumpy-reclaim-v4.patch
lumpy-back-out-removal-of-active-check-in-isolate_lru_pages.patch
lumpy-only-count-taken-pages-as-scanned.patch
add-pfn_valid_within-helper-for-sub-max_order-hole-detection.patch
anti-fragmentation-switch-over-to-pfn_valid_within.patch
lumpy-move-to-using-pfn_valid_within.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy-fix.patch
reduce-the-amount-of-time-spent-in-the-per-cpu-allocator.patch
do-not-block-align-pfn-when-looking-up-the-pageblock-pfn.patch
do-not-disable-interrupts-when-reading-min_free_kbytes.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
add-debugging-aid-for-memory-initialisation-problems.patch
