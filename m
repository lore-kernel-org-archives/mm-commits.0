From: akpm@linux-foundation.org
Subject: + bias-the-placement-of-kernel-pages-at-lower-pfns.patch added to -mm tree
Date: Fri, 02 Mar 2007 13:41:45 -0800
Message-ID: <200703022141.l22LfjMq019782@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42066 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030359AbXCBVlt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 16:41:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie


The patch titled
     Bias the placement of kernel pages at lower PFNs
has been added to the -mm tree.  Its filename is
     bias-the-placement-of-kernel-pages-at-lower-pfns.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Bias the placement of kernel pages at lower PFNs
From: Mel Gorman <mel@csn.ul.ie>

This patch chooses blocks with lower PFNs when placing kernel allocations. 
This is particularly important during fallback in low memory situations to
stop unmovable pages being placed throughout the entire address space.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+)

diff -puN mm/page_alloc.c~bias-the-placement-of-kernel-pages-at-lower-pfns mm/page_alloc.c
--- a/mm/page_alloc.c~bias-the-placement-of-kernel-pages-at-lower-pfns
+++ a/mm/page_alloc.c
@@ -735,6 +735,23 @@ int move_freepages_block(struct zone *zo
 	return move_freepages(zone, start_page, end_page, migratetype);
 }
 
+/* Return the page with the lowest PFN in the list */
+static struct page *min_page(struct list_head *list)
+{
+	unsigned long min_pfn = -1UL;
+	struct page *min_page = NULL, *page;;
+
+	list_for_each_entry(page, list, lru) {
+		unsigned long pfn = page_to_pfn(page);
+		if (pfn < min_pfn) {
+			min_pfn = pfn;
+			min_page = page;
+		}
+	}
+
+	return min_page;
+}
+
 /* Remove an element from the buddy allocator from the fallback list */
 static struct page *__rmqueue_fallback(struct zone *zone, int order,
 						int start_migratetype)
@@ -765,8 +782,11 @@ retry:
 			if (list_empty(&area->free_list[migratetype]))
 				continue;
 
+			/* Bias kernel allocations towards low pfns */
 			page = list_entry(area->free_list[migratetype].next,
 					struct page, lru);
+			if (unlikely(start_migratetype != MIGRATE_MOVABLE))
+				page = min_page(&area->free_list[migratetype]);
 			area->nr_free--;
 
 			/*
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
