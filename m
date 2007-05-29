From: akpm@linux-foundation.org
Subject: + breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch added to -mm tree
Date: Tue, 29 May 2007 13:35:54 -0700
Message-ID: <200705292035.l4TKZs2g010894@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41120 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760389AbXE2UhB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 16:37:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, apw@shadowen.org, clameter@sgi.com


The patch titled
     Breakout page_order() to internal.h to avoid special knowledge of the buddy allocator
has been added to the -mm tree.  Its filename is
     breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Breakout page_order() to internal.h to avoid special knowledge of the buddy allocator
From: Mel Gorman <mel@csn.ul.ie>

The statistics patch later needs to know what order a free page is on the free
lists.  Rather than having special knowledge of page_private() when
PageBuddy() is set, this patch places out page_order() in internal.h and adds
a VM_BUG_ON to catch using it on non-PageBuddy pages.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |   10 ++++++++++
 mm/page_alloc.c |   10 ----------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff -puN mm/internal.h~breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator mm/internal.h
--- a/mm/internal.h~breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator
+++ a/mm/internal.h
@@ -37,4 +37,14 @@ static inline void __put_page(struct pag
 extern void fastcall __init __free_pages_bootmem(struct page *page,
 						unsigned int order);
 
+/*
+ * function for dealing with page's order in buddy system.
+ * zone->lock is already acquired when we use these.
+ * So, we don't need atomic page->flags operations here.
+ */
+static inline unsigned long page_order(struct page *page)
+{
+	VM_BUG_ON(!PageBuddy(page));
+	return page_private(page);
+}
 #endif
diff -puN mm/page_alloc.c~breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator mm/page_alloc.c
--- a/mm/page_alloc.c~breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator
+++ a/mm/page_alloc.c
@@ -313,16 +313,6 @@ static inline void prep_zero_page(struct
 		clear_highpage(page + i);
 }
 
-/*
- * function for dealing with page's order in buddy system.
- * zone->lock is already acquired when we use these.
- * So, we don't need atomic page->flags operations here.
- */
-static inline unsigned long page_order(struct page *page)
-{
-	return page_private(page);
-}
-
 static inline void set_page_order(struct page *page, int order)
 {
 	set_page_private(page, order);
_

Patches currently in -mm which might be from mel@csn.ul.ie are

x86_64-extract-helper-function-from-e820_register_active_regions.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
split-the-free-lists-for-movable-and-unmovable-allocations.patch
choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
add-a-configure-option-to-group-pages-by-mobility.patch
drain-per-cpu-lists-when-high-order-allocations-fail.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
group-high-order-atomic-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
bias-the-placement-of-kernel-pages-at-lower-pfns.patch
be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
remove-alloc_zeroed_user_highpage.patch
create-the-zone_movable-zone.patch
create-the-zone_movable-zone-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix-2.patch
handle-kernelcore=-generic.patch
lumpy-reclaim-v4.patch
lumpy-move-to-using-pfn_valid_within.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance.patch
add-debugging-aid-for-memory-initialisation-problems.patch
