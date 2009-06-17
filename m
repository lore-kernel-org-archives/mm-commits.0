From: akpm@linux-foundation.org
Subject: [merged] page-allocator-inline-__rmqueue_smallest.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:33:58 -0700
Message-ID: <200906171833.n5HIXw6K032428@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759861AbZFQSe1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:34:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, Lee.Schermerhorn@hp.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, dave@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au, penberg@cs.h


The patch titled
     page allocator: inline __rmqueue_smallest()
has been removed from the -mm tree.  Its filename was
     page-allocator-inline-__rmqueue_smallest.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page allocator: inline __rmqueue_smallest()
From: Mel Gorman <mel@csn.ul.ie>

Inline __rmqueue_smallest by altering flow very slightly so that there is
only one call site.  Because there is only one call-site, this function
can then be inlined without causing text bloat.  On an x86-based config,
this patch reduces text by 16 bytes.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~page-allocator-inline-__rmqueue_smallest mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-inline-__rmqueue_smallest
+++ a/mm/page_alloc.c
@@ -661,7 +661,8 @@ static int prep_new_page(struct page *pa
  * Go through the free lists for the given migratetype and remove
  * the smallest available page from the freelists
  */
-static struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
+static inline
+struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 						int migratetype)
 {
 	unsigned int current_order;
@@ -831,8 +832,7 @@ static struct page *__rmqueue_fallback(s
 		}
 	}
 
-	/* Use MIGRATE_RESERVE rather than fail an allocation */
-	return __rmqueue_smallest(zone, order, MIGRATE_RESERVE);
+	return NULL;
 }
 
 /*
@@ -844,11 +844,23 @@ static struct page *__rmqueue(struct zon
 {
 	struct page *page;
 
+retry_reserve:
 	page = __rmqueue_smallest(zone, order, migratetype);
 
-	if (unlikely(!page))
+	if (unlikely(!page) && migratetype != MIGRATE_RESERVE) {
 		page = __rmqueue_fallback(zone, order, migratetype);
 
+		/*
+		 * Use MIGRATE_RESERVE rather than fail an allocation. goto
+		 * is used because __rmqueue_smallest is an inline function
+		 * and we want just one call site
+		 */
+		if (!page) {
+			migratetype = MIGRATE_RESERVE;
+			goto retry_reserve;
+		}
+	}
+
 	return page;
 }
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
linux-next.patch
page_alloc-oops-when-setting-percpu_pagelist_fraction.patch
memcg-fix-lru-rotation-in-isolate_pages.patch
add-debugging-aid-for-memory-initialisation-problems.patch

