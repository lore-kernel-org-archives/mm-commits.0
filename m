From: akpm@linux-foundation.org
Subject: [merged] page-allocator-maintain-rolling-count-of-pages-to-free-from-the-pcp.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:42:33 -0700
Message-ID: <200909222042.n8MKgXPr009833@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752927AbZIVUmk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:42:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, cl@linux-foundation.org, minchan.kim@gmail.com, npiggin@suse.de, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     page-allocator: maintain rolling count of pages to free from the PCP
has been removed from the -mm tree.  Its filename was
     page-allocator-maintain-rolling-count-of-pages-to-free-from-the-pcp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-allocator: maintain rolling count of pages to free from the PCP
From: Mel Gorman <mel@csn.ul.ie>

When round-robin freeing pages from the PCP lists, empty lists may be
encountered.  In the event one of the lists has more pages than another,
there may be numerous checks for list_empty() which is undesirable.  This
patch maintains a count of pages to free which is incremented when empty
lists are encountered.  The intention is that more pages will then be
freed from fuller lists than the empty ones reducing the number of empty
list checks in the free path.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff -puN mm/page_alloc.c~page-allocator-maintain-rolling-count-of-pages-to-free-from-the-pcp mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-maintain-rolling-count-of-pages-to-free-from-the-pcp
+++ a/mm/page_alloc.c
@@ -525,32 +525,38 @@ static void free_pcppages_bulk(struct zo
 					struct per_cpu_pages *pcp)
 {
 	int migratetype = 0;
+	int batch_free = 0;
 
 	spin_lock(&zone->lock);
 	zone_clear_flag(zone, ZONE_ALL_UNRECLAIMABLE);
 	zone->pages_scanned = 0;
 
 	__mod_zone_page_state(zone, NR_FREE_PAGES, count);
-	while (count--) {
+	while (count) {
 		struct page *page;
 		struct list_head *list;
 
 		/*
-		 * Remove pages from lists in a round-robin fashion. This spinning
-		 * around potentially empty lists is bloody awful, alternatives that
-		 * don't suck are welcome
+		 * Remove pages from lists in a round-robin fashion. A
+		 * batch_free count is maintained that is incremented when an
+		 * empty list is encountered.  This is so more pages are freed
+		 * off fuller lists instead of spinning excessively around empty
+		 * lists
 		 */
 		do {
+			batch_free++;
 			if (++migratetype == MIGRATE_PCPTYPES)
 				migratetype = 0;
 			list = &pcp->lists[migratetype];
 		} while (list_empty(list));
 
-		page = list_entry(list->prev, struct page, lru);
-		/* have to delete it as __free_one_page list manipulates */
-		list_del(&page->lru);
-		trace_mm_page_pcpu_drain(page, 0, migratetype);
-		__free_one_page(page, zone, 0, migratetype);
+		do {
+			page = list_entry(list->prev, struct page, lru);
+			/* must delete as __free_one_page list manipulates */
+			list_del(&page->lru);
+			__free_one_page(page, zone, 0, migratetype);
+			trace_mm_page_pcpu_drain(page, 0, migratetype);
+		} while (--count && --batch_free && !list_empty(list));
 	}
 	spin_unlock(&zone->lock);
 }
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch
add-debugging-aid-for-memory-initialisation-problems.patch

