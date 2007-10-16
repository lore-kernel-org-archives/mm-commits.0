From: akpm@linux-foundation.org
Subject: - be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:34:50 -0700
Message-ID: <200710162034.l9GKYo4Z014998@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45236 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765631AbXJPViB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:38:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Be more agressive about stealing when MIGRATE_RECLAIMABLE allocations fallback
has been removed from the -mm tree.  Its filename was
     be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Be more agressive about stealing when MIGRATE_RECLAIMABLE allocations fallback
From: Mel Gorman <mel@csn.ul.ie>

MIGRATE_RECLAIMABLE allocations tend to be very bursty in nature like when
updatedb starts.  It is likely this will occur in situations where MAX_ORDER
blocks of pages are not free.  This means that updatedb can scatter
MIGRATE_RECLAIMABLE pages throughout the address space.  This patch is more
agressive about stealing blocks of pages for MIGRATE_RECLAIMABLE.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback mm/page_alloc.c
--- a/mm/page_alloc.c~be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback
+++ a/mm/page_alloc.c
@@ -821,11 +821,23 @@ retry:
 
 			/*
 			 * If breaking a large block of pages, move all free
-			 * pages to the preferred allocation list
+			 * pages to the preferred allocation list. If falling
+			 * back for a reclaimable kernel allocation, be more
+			 * agressive about taking ownership of free pages
 			 */
-			if (unlikely(current_order >= MAX_ORDER / 2)) {
+			if (unlikely(current_order >= MAX_ORDER / 2) ||
+					start_migratetype == MIGRATE_RECLAIMABLE) {
+				unsigned long pages;
+				pages = move_freepages_block(zone, page,
+								start_migratetype);
+
+				/* Claim the whole block if over half of it is free */
+				if ((pages << current_order) >= (1 << (MAX_ORDER-2)) &&
+						migratetype != MIGRATE_HIGHATOMIC)
+					set_pageblock_migratetype(page,
+								start_migratetype);
+
 				migratetype = start_migratetype;
-				move_freepages_block(zone, page, migratetype);
 			}
 
 			/* Remove the page from the freelists */
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
ext2-reservations.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch
