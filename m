From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:42:47 -0700
Message-ID: <52321937.tzNgEe4I+V/e/oNO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58040 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab3ILTms (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:42:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, minchan@kernel.org, mel@csn.ul.ie, cody@linux.vnet.ibm.com, srivatsa.bhat@linux.vnet.ibm.com

Subject: [merged] mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug.patch removed from -mm tree
To: srivatsa.bhat@linux.vnet.ibm.com,cody@linux.vnet.ibm.com,mel@csn.ul.ie,minchan@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:42:47 -0700


The patch titled
     Subject: mm/page_allo.c: restructure free-page stealing code and fix a bug
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: mm/page_allo.c: restructure free-page stealing code and fix a bug

The free-page stealing code in __rmqueue_fallback() is somewhat hard to
follow, and has an incredible amount of subtlety hidden inside!

First off, there is a minor bug in the reporting of change-of-ownership of
pageblocks.  Under some conditions, we try to move upto
'pageblock_nr_pages' no.  of pages to the preferred allocation list.  But
we change the ownership of that pageblock to the preferred type only if we
manage to successfully move atleast half of that pageblock (or if
page_group_by_mobility_disabled is set).

However, the current code ignores the latter part and sets the
'migratetype' variable to the preferred type, irrespective of whether we
actually changed the pageblock migratetype of that block or not.  So, the
page_alloc_extfrag tracepoint can end up printing incorrect info (i.e.,
'change_ownership' might be shown as 1 when it must have been 0).

So fixing this involves moving the update of the 'migratetype' variable to
the right place.  But looking closer, we observe that the 'migratetype'
variable is used subsequently for checks such as "is_migrate_cma()". 
Obviously the intent there is to check if the *fallback* type is
MIGRATE_CMA, but since we already set the 'migratetype' variable to
start_migratetype, we end up checking if the *preferred* type is
MIGRATE_CMA!!

To make things more interesting, this actually doesn't cause a bug in
practice, because we never change *anything* if the fallback type is CMA.

So, restructure the code in such a way that it is trivial to understand
what is going on, and also fix the above mentioned bug.  And while at it,
also add a comment explaining the subtlety behind the migratetype used in
the call to expand().

[akpm@linux-foundation.org: remove unneeded `inline', small coding-style fix]
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   95 ++++++++++++++++++++++++++++------------------
 1 file changed, 59 insertions(+), 36 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug
+++ a/mm/page_alloc.c
@@ -1008,6 +1008,52 @@ static void change_pageblock_range(struc
 	}
 }
 
+/*
+ * If breaking a large block of pages, move all free pages to the preferred
+ * allocation list. If falling back for a reclaimable kernel allocation, be
+ * more aggressive about taking ownership of free pages.
+ *
+ * On the other hand, never change migration type of MIGRATE_CMA pageblocks
+ * nor move CMA pages to different free lists. We don't want unmovable pages
+ * to be allocated from MIGRATE_CMA areas.
+ *
+ * Returns the new migratetype of the pageblock (or the same old migratetype
+ * if it was unchanged).
+ */
+static int try_to_steal_freepages(struct zone *zone, struct page *page,
+				  int start_type, int fallback_type)
+{
+	int current_order = page_order(page);
+
+	if (is_migrate_cma(fallback_type))
+		return fallback_type;
+
+	/* Take ownership for orders >= pageblock_order */
+	if (current_order >= pageblock_order) {
+		change_pageblock_range(page, current_order, start_type);
+		return start_type;
+	}
+
+	if (current_order >= pageblock_order / 2 ||
+	    start_type == MIGRATE_RECLAIMABLE ||
+	    page_group_by_mobility_disabled) {
+		int pages;
+
+		pages = move_freepages_block(zone, page, start_type);
+
+		/* Claim the whole block if over half of it is free */
+		if (pages >= (1 << (pageblock_order-1)) ||
+				page_group_by_mobility_disabled) {
+
+			set_pageblock_migratetype(page, start_type);
+			return start_type;
+		}
+
+	}
+
+	return fallback_type;
+}
+
 /* Remove an element from the buddy allocator from the fallback list */
 static inline struct page *
 __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
@@ -1015,7 +1061,7 @@ __rmqueue_fallback(struct zone *zone, in
 	struct free_area *area;
 	int current_order;
 	struct page *page;
-	int migratetype, i;
+	int migratetype, new_type, i;
 
 	/* Find the largest possible block of pages in the other list */
 	for (current_order = MAX_ORDER-1; current_order >= order;
@@ -1035,51 +1081,28 @@ __rmqueue_fallback(struct zone *zone, in
 					struct page, lru);
 			area->nr_free--;
 
-			/*
-			 * If breaking a large block of pages, move all free
-			 * pages to the preferred allocation list. If falling
-			 * back for a reclaimable kernel allocation, be more
-			 * aggressive about taking ownership of free pages
-			 *
-			 * On the other hand, never change migration
-			 * type of MIGRATE_CMA pageblocks nor move CMA
-			 * pages on different free lists. We don't
-			 * want unmovable pages to be allocated from
-			 * MIGRATE_CMA areas.
-			 */
-			if (!is_migrate_cma(migratetype) &&
-			    (current_order >= pageblock_order / 2 ||
-			     start_migratetype == MIGRATE_RECLAIMABLE ||
-			     page_group_by_mobility_disabled)) {
-				int pages;
-				pages = move_freepages_block(zone, page,
-								start_migratetype);
-
-				/* Claim the whole block if over half of it is free */
-				if (pages >= (1 << (pageblock_order-1)) ||
-						page_group_by_mobility_disabled)
-					set_pageblock_migratetype(page,
-								start_migratetype);
-
-				migratetype = start_migratetype;
-			}
+			new_type = try_to_steal_freepages(zone, page,
+							  start_migratetype,
+							  migratetype);
 
 			/* Remove the page from the freelists */
 			list_del(&page->lru);
 			rmv_page_order(page);
 
-			/* Take ownership for orders >= pageblock_order */
-			if (current_order >= pageblock_order &&
-			    !is_migrate_cma(migratetype))
-				change_pageblock_range(page, current_order,
-							start_migratetype);
