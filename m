From: akpm@linux-foundation.org
Subject: - bias-the-placement-of-kernel-pages-at-lower-pfns.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:34:48 -0700
Message-ID: <200710162034.l9GKYmII014995@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46104 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965700AbXJPVhj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:37:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Bias the placement of kernel pages at lower PFNs
has been removed from the -mm tree.  Its filename was
     bias-the-placement-of-kernel-pages-at-lower-pfns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 20 insertions(+)

diff -puN mm/page_alloc.c~bias-the-placement-of-kernel-pages-at-lower-pfns mm/page_alloc.c
--- a/mm/page_alloc.c~bias-the-placement-of-kernel-pages-at-lower-pfns
+++ a/mm/page_alloc.c
@@ -765,6 +765,23 @@ int move_freepages_block(struct zone *zo
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
@@ -795,8 +812,11 @@ retry:
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

origin.patch
ext2-reservations.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch
