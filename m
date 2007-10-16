From: akpm@linux-foundation.org
Subject: - fix-calculation-in-move_freepages_block-for-counting-pages.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:35:02 -0700
Message-ID: <200710162035.l9GKZ2hB015019@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59402 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966206AbXJPVt3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:49:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, apw@shadowen.org, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Fix calculation in move_freepages_block for counting pages
has been removed from the -mm tree.  Its filename was
     fix-calculation-in-move_freepages_block-for-counting-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix calculation in move_freepages_block for counting pages
From: Mel Gorman <mel@csn.ul.ie>

move_freepages_block() returns the number of blocks moved.  This value is used
to determine if a block of pages should be stolen for the exclusive use of a
migrate type or not.  However, the value returned is being used correctly. 
This patch fixes the calculation to return the number of base pages that have
been moved.

This should be considered a fix to the patch
move-free-pages-between-lists-on-steal.patch

Credit to Andy Whitcroft for spotting the problem.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~fix-calculation-in-move_freepages_block-for-counting-pages mm/page_alloc.c
--- a/mm/page_alloc.c~fix-calculation-in-move_freepages_block-for-counting-pages
+++ a/mm/page_alloc.c
@@ -718,7 +718,7 @@ int move_freepages(struct zone *zone,
 {
 	struct page *page;
 	unsigned long order;
-	int blocks_moved = 0;
+	int pages_moved = 0;
 
 #ifndef CONFIG_HOLES_IN_ZONE
 	/*
@@ -747,10 +747,10 @@ int move_freepages(struct zone *zone,
 		list_add(&page->lru,
 			&zone->free_area[order].free_list[migratetype]);
 		page += 1 << order;
-		blocks_moved++;
+		pages_moved += 1 << order;
 	}
 
-	return blocks_moved;
+	return pages_moved;
 }
 
 int move_freepages_block(struct zone *zone, struct page *page, int migratetype)
@@ -833,7 +833,7 @@ static struct page *__rmqueue_fallback(s
 								start_migratetype);
 
 				/* Claim the whole block if over half of it is free */
-				if ((pages << current_order) >= (1 << (MAX_ORDER-2)))
+				if (pages >= (1 << (MAX_ORDER-2)))
 					set_pageblock_migratetype(page,
 								start_migratetype);
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
ext2-reservations.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch
