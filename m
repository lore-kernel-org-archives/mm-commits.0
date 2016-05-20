From: akpm@linux-foundation.org
Subject: [merged] mm-page_alloc-shorten-the-page-allocator-fast-path.patch removed from -mm tree
Date: Fri, 20 May 2016 14:06:40 -0700
Message-ID: <573f7c60.lvLY//ZEDmsbx3n0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47351 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbcETVGl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:06:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: shorten the page allocator fast path
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-shorten-the-page-allocator-fast-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: shorten the page allocator fast path

The page allocator fast path checks page multiple times unnecessarily. 
This patch avoids all the slowpath checks if the first allocation attempt
succeeds.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-shorten-the-page-allocator-fast-path mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-shorten-the-page-allocator-fast-path
+++ a/mm/page_alloc.c
@@ -3398,31 +3398,26 @@ retry_cpuset:
 				ac.nodemask, &ac.preferred_zone);
 	if (!ac.preferred_zone) {
 		page = NULL;
-		goto out;
+		goto no_zone;
 	}
 
 	ac.classzone_idx = zonelist_zone_idx(preferred_zoneref);
 
 	/* First allocation attempt */
 	page = get_page_from_freelist(alloc_mask, order, alloc_flags, &ac);
-	if (unlikely(!page)) {
-		/*
-		 * Runtime PM, block IO and its error handling path
-		 * can deadlock because I/O on the device might not
-		 * complete.
-		 */
-		alloc_mask = memalloc_noio_flags(gfp_mask);
-		ac.spread_dirty_pages = false;
-
-		page = __alloc_pages_slowpath(alloc_mask, order, &ac);
-	}
+	if (likely(page))
+		goto out;
 
-	if (kmemcheck_enabled && page)
-		kmemcheck_pagealloc_alloc(page, order, gfp_mask);
+	/*
+	 * Runtime PM, block IO and its error handling path can deadlock
+	 * because I/O on the device might not complete.
+	 */
+	alloc_mask = memalloc_noio_flags(gfp_mask);
+	ac.spread_dirty_pages = false;
 
-	trace_mm_page_alloc(page, order, alloc_mask, ac.migratetype);
+	page = __alloc_pages_slowpath(alloc_mask, order, &ac);
 
-out:
+no_zone:
 	/*
 	 * When updating a task's mems_allowed, it is possible to race with
 	 * parallel threads in such a way that an allocation can fail while
@@ -3434,6 +3429,12 @@ out:
 		goto retry_cpuset;
 	}
 
+out:
+	if (kmemcheck_enabled && page)
+		kmemcheck_pagealloc_alloc(page, order, gfp_mask);
+
+	trace_mm_page_alloc(page, order, alloc_mask, ac.migratetype);
+
 	return page;
 }
 EXPORT_SYMBOL(__alloc_pages_nodemask);
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


