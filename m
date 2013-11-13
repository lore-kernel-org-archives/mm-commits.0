From: akpm@linux-foundation.org
Subject: [merged]
 mm-__rmqueue_fallback-should-respect-pageblock-type.patch removed from -mm
 tree
Date: Wed, 13 Nov 2013 12:39:20 -0800
Message-ID: <5283e378.mLXV+XwWFQmpkNoN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42785 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab3KMUjV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:39:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mina86@mina86.com, mgorman@suse.de, kosaki.motohiro@jp.fujitsu.com

Subject: [merged] mm-__rmqueue_fallback-should-respect-pageblock-type.patch removed from -mm tree
To: kosaki.motohiro@jp.fujitsu.com,mgorman@suse.de,mina86@mina86.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:39:20 -0800


The patch titled
     Subject: mm: __rmqueue_fallback() should respect pageblock type
has been removed from the -mm tree.  Its filename was
     mm-__rmqueue_fallback-should-respect-pageblock-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: mm: __rmqueue_fallback() should respect pageblock type

When __rmqueue_fallback() doesn't find a free block with the required size
it splits a larger page and puts the rest of the page onto the free list.

But it has one serious mistake.  When putting back, __rmqueue_fallback()
always use start_migratetype if type is not CMA.  However,
__rmqueue_fallback() is only called when all of the start_migratetype
queue is empty.  That said, __rmqueue_fallback always puts back memory to
the wrong queue except try_to_steal_freepages() changed pageblock type
(i.e.  requested size is smaller than half of page block).  The end result
is that the antifragmentation framework increases fragmenation instead of
decreasing it.

Mel's original anti fragmentation does the right thing.  But commit
47118af076 ("mm: mmzone: MIGRATE_CMA migration type added") broke it.

This patch restores sane and old behavior.  And also it remvoe an
incorrect comment which introduced at commit fef903efcf (mm/page_alloc.c:
restructure free-page stealing code and fix a bug).

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff -puN mm/page_alloc.c~mm-__rmqueue_fallback-should-respect-pageblock-type mm/page_alloc.c
--- a/mm/page_alloc.c~mm-__rmqueue_fallback-should-respect-pageblock-type
+++ a/mm/page_alloc.c
@@ -1027,6 +1027,10 @@ static int try_to_steal_freepages(struct
 {
 	int current_order = page_order(page);
 
+	/*
+	 * When borrowing from MIGRATE_CMA, we need to release the excess
+	 * buddy pages to CMA itself.
+	 */
 	if (is_migrate_cma(fallback_type))
 		return fallback_type;
 
@@ -1091,17 +1095,8 @@ __rmqueue_fallback(struct zone *zone, in
 			list_del(&page->lru);
 			rmv_page_order(page);
 
-			/*
-			 * Borrow the excess buddy pages as well, irrespective
-			 * of whether we stole freepages, or took ownership of
-			 * the pageblock or not.
-			 *
-			 * Exception: When borrowing from MIGRATE_CMA, release
-			 * the excess buddy pages to CMA itself.
-			 */
 			expand(zone, page, order, current_order, area,
-			       is_migrate_cma(migratetype)
-			     ? migratetype : start_migratetype);
+			       new_type);
 
 			trace_mm_page_alloc_extfrag(page, order, current_order,
 				start_migratetype, migratetype, new_type);
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch

