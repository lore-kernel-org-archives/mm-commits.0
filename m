From: akpm@linux-foundation.org
Subject: + allow-page_owner-to-be-set-on-any-architecture-fix-fix.patch added to -mm tree
Date: Thu, 05 Jul 2007 14:57:59 -0700
Message-ID: <200707052158.l65Lvx3l021602@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57069 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760001AbXGEV6o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 17:58:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, apw@shadowen.org


The patch titled
     allow-page_owner-to-be-set-on-any-architecture-fix fix
has been added to the -mm tree.  Its filename is
     allow-page_owner-to-be-set-on-any-architecture-fix-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: allow-page_owner-to-be-set-on-any-architecture-fix fix
From: mel@skynet.ie (Mel Gorman)

Page-owner-tracking stores the a backtrace of an allocation in the struct
page.  How the stack trace is generated depends on whether
CONFIG_FRAME_POINTER is set or not.  If CONFIG_FRAME_POINTER is set, the
frame pointer must be read using some inline assembler which is not
available for all architectures.

This patch uses the frame pointer where it is available but has a fallback
where it is not.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff -puN mm/page_alloc.c~allow-page_owner-to-be-set-on-any-architecture-fix-fix mm/page_alloc.c
--- a/mm/page_alloc.c~allow-page_owner-to-be-set-on-any-architecture-fix-fix
+++ a/mm/page_alloc.c
@@ -1479,14 +1479,17 @@ static inline void __stack_trace(struct 
 	memset(page->trace, 0, sizeof(long) * 8);
 
 #ifdef CONFIG_FRAME_POINTER
-	while (valid_stack_ptr(tinfo, (void *)bp)) {
-		addr = *(unsigned long *)(bp + sizeof(long));
-		page->trace[i] = addr;
-		if (++i >= 8)
-			break;
-		bp = *(unsigned long *)bp;
+	if (bp) {
+		while (valid_stack_ptr(tinfo, (void *)bp)) {
+			addr = *(unsigned long *)(bp + sizeof(long));
+			page->trace[i] = addr;
+			if (++i >= 8)
+				break;
+			bp = *(unsigned long *)bp;
+		}
+		return;
 	}
-#else
+#endif /* CONFIG_FRAME_POINTER */
 	while (valid_stack_ptr(tinfo, stack)) {
 		addr = *stack++;
 		if (__kernel_text_address(addr)) {
@@ -1495,7 +1498,6 @@ static inline void __stack_trace(struct 
 				break;
 		}
 	}
-#endif
 }
 
 static void set_page_owner(struct page *page, unsigned int order,
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
create-the-zone_movable-zone-fix-2.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix-2.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix-3.patch
handle-kernelcore=-generic.patch
handle-kernelcore=-generic-fix.patch
lumpy-reclaim-v4.patch
lumpy-move-to-using-pfn_valid_within.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
update-page-order-at-an-appropriate-time-when-tracking-page_owner.patch
print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance.patch
allow-page_owner-to-be-set-on-any-architecture.patch
allow-page_owner-to-be-set-on-any-architecture-fix.patch
allow-page_owner-to-be-set-on-any-architecture-fix-fix.patch
add-debugging-aid-for-memory-initialisation-problems.patch
