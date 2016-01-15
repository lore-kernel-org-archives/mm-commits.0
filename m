From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-remove-unnecessary-parameter-from-__rmqueue.patch removed
 from -mm tree
Date: Fri, 15 Jan 2016 14:34:03 -0800
Message-ID: <569973db.MQkeoYbxnOgxaJUM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59531 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbcAOWeD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:34:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: remove unnecessary parameter from __rmqueue
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-unnecessary-parameter-from-__rmqueue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc.c: remove unnecessary parameter from __rmqueue

Commit 0aaa29a56e4f ("mm, page_alloc: reserve pageblocks for high-order
atomic allocations on demand") added an unnecessary and unused parameter
to __rmqueue.  It was a parameter that was used in an earlier version of
the patch and then left behind.  This patch cleans it up.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-remove-unnecessary-parameter-from-__rmqueue mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-remove-unnecessary-parameter-from-__rmqueue
+++ a/mm/page_alloc.c
@@ -1781,7 +1781,7 @@ __rmqueue_fallback(struct zone *zone, un
  * Call me with the zone->lock already held.
  */
 static struct page *__rmqueue(struct zone *zone, unsigned int order,
-				int migratetype, gfp_t gfp_flags)
+				int migratetype)
 {
 	struct page *page;
 
@@ -1811,7 +1811,7 @@ static int rmqueue_bulk(struct zone *zon
 
 	spin_lock(&zone->lock);
 	for (i = 0; i < count; ++i) {
-		struct page *page = __rmqueue(zone, order, migratetype, 0);
+		struct page *page = __rmqueue(zone, order, migratetype);
 		if (unlikely(page == NULL))
 			break;
 
@@ -2234,7 +2234,7 @@ struct page *buffered_rmqueue(struct zon
 				trace_mm_page_alloc_zone_locked(page, order, migratetype);
 		}
 		if (!page)
-			page = __rmqueue(zone, order, migratetype, gfp_flags);
+			page = __rmqueue(zone, order, migratetype);
 		spin_unlock(&zone->lock);
 		if (!page)
 			goto failed;
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


