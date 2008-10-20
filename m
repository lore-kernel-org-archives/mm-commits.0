From: akpm@linux-foundation.org
Subject: - vmscan-fix-pagecache-reclaim-referenced-bit-check.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:32:42 -0700
Message-ID: <200810202032.m9KKWg2j010459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753737AbYJTUgl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:36:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: fix pagecache reclaim referenced bit check
has been removed from the -mm tree.  Its filename was
     vmscan-fix-pagecache-reclaim-referenced-bit-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: fix pagecache reclaim referenced bit check
From: Rik van Riel <riel@redhat.com>

Moving referenced pages back to the head of the active list creates a huge
scalability problem, because by the time a large memory system finally
runs out of free memory, every single page in the system will have been
referenced.

Not only do we not have the time to scan every single page on the active
list, but since they have will all have the referenced bit set, that bit
conveys no useful information.

A more scalable solution is to just move every page that hits the end of
the active list to the inactive list.

We clear the referenced bit off of mapped pages, which need just one
reference to be moved back onto the active list.

Unmapped pages will be moved back to the active list after two references
(see mark_page_accessed).  We preserve the PG_referenced flag on unmapped
pages to preserve accesses that were made while the page was on the active
list.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   45 +++++++++++++--------------------------------
 1 file changed, 13 insertions(+), 32 deletions(-)

diff -puN mm/vmscan.c~vmscan-fix-pagecache-reclaim-referenced-bit-check mm/vmscan.c
--- a/mm/vmscan.c~vmscan-fix-pagecache-reclaim-referenced-bit-check
+++ a/mm/vmscan.c
@@ -1064,7 +1064,6 @@ static void shrink_active_list(unsigned 
 	int pgdeactivate = 0;
 	unsigned long pgscanned;
 	LIST_HEAD(l_hold);	/* The pages which were snipped off */
-	LIST_HEAD(l_active);
 	LIST_HEAD(l_inactive);
 	struct page *page;
 	struct pagevec pvec;
@@ -1095,21 +1094,28 @@ static void shrink_active_list(unsigned 
 		cond_resched();
 		page = lru_to_page(&l_hold);
 		list_del(&page->lru);
+
+		/* page_referenced clears PageReferenced */
+		if (page_mapping_inuse(page) &&
+		    page_referenced(page, 0, sc->mem_cgroup))
+			pgmoved++;
+
 		list_add(&page->lru, &l_inactive);
 	}
 
 	/*
-	 * Count the referenced pages as rotated, even when they are moved
-	 * to the inactive list.  This helps balance scan pressure between
-	 * file and anonymous pages in get_scan_ratio.
- 	 */
+	 * Count referenced pages from currently used mappings as
+	 * rotated, even though they are moved to the inactive list.
+	 * This helps balance scan pressure between file and anonymous
+	 * pages in get_scan_ratio.
+	 */
 	zone->recent_rotated[!!file] += pgmoved;
 
 	/*
-	 * Now put the pages back on the appropriate [file or anon] inactive
-	 * and active lists.
+	 * Move the pages to the [file or anon] inactive list.
 	 */
 	pagevec_init(&pvec, 1);
+
 	pgmoved = 0;
 	lru = LRU_BASE + file * LRU_FILE;
 	spin_lock_irq(&zone->lru_lock);
@@ -1142,31 +1148,6 @@ static void shrink_active_list(unsigned 
 		pagevec_strip(&pvec);
 		spin_lock_irq(&zone->lru_lock);
 	}
-
-	pgmoved = 0;
-	lru = LRU_ACTIVE + file * LRU_FILE;
-	while (!list_empty(&l_active)) {
-		page = lru_to_page(&l_active);
-		prefetchw_prev_lru_page(page, &l_active, flags);
-		VM_BUG_ON(PageLRU(page));
-		SetPageLRU(page);
-		VM_BUG_ON(!PageActive(page));
-
-		list_move(&page->lru, &zone->lru[lru].list);
-		mem_cgroup_move_lists(page, true);
-		pgmoved++;
-		if (!pagevec_add(&pvec, page)) {
-			__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
-			pgmoved = 0;
-			spin_unlock_irq(&zone->lru_lock);
-			if (vm_swap_full())
-				pagevec_swap_free(&pvec);
-			__pagevec_release(&pvec);
-			spin_lock_irq(&zone->lru_lock);
-		}
-	}
-	__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
