From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch removed from -mm tree
Date: Mon, 13 Oct 2014 11:19:31 -0700
Message-ID: <543c17b3.pVRwa8Tauo5NopVY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60320 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797AbaJMSTb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:19:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: do not count compact_stall if all zones skipped compaction
has been removed from the -mm tree.  Its filename was
     mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: do not count compact_stall if all zones skipped compaction

The compact_stall vmstat counter counts the number of allocations stalled
by direct compaction.  It does not count when all attempted zones had
deferred compaction, but it does count when all zones skipped compaction. 
The skipping is decided based on very early check of
compaction_suitable(), based on watermarks and memory fragmentation. 
Therefore it makes sense not to count skipped compactions as stalls. 
Moreover, compact_success or compact_fail is also already not being
counted when compaction was skipped, so this patch changes the
compact_stall counting to match the other two.

Additionally, restructure __alloc_pages_direct_compact() code for better
readability.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   86 ++++++++++++++++++++++++----------------------
 1 file changed, 46 insertions(+), 40 deletions(-)

diff -puN mm/page_alloc.c~mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction
+++ a/mm/page_alloc.c
@@ -2301,7 +2301,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 {
 	struct zone *last_compact_zone = NULL;
 	unsigned long compact_result;
-
+	struct page *page;
 
 	if (!order)
 		return NULL;
@@ -2313,49 +2313,55 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 						&last_compact_zone);
 	current->flags &= ~PF_MEMALLOC;
 
-	if (compact_result > COMPACT_DEFERRED)
-		count_vm_event(COMPACTSTALL);
-	else
+	switch (compact_result) {
+	case COMPACT_DEFERRED:
 		*deferred_compaction = true;
+		/* fall-through */
+	case COMPACT_SKIPPED:
+		return NULL;
+	default:
+		break;
+	}
 
-	if (compact_result > COMPACT_SKIPPED) {
-		struct page *page;
+	/*
+	 * At least in one zone compaction wasn't deferred or skipped, so let's
+	 * count a compaction stall
+	 */
+	count_vm_event(COMPACTSTALL);
+
+	/* Page migration frees to the PCP lists but we want merging */
+	drain_pages(get_cpu());
+	put_cpu();
+
+	page = get_page_from_freelist(gfp_mask, nodemask,
+			order, zonelist, high_zoneidx,
+			alloc_flags & ~ALLOC_NO_WATERMARKS,
+			preferred_zone, classzone_idx, migratetype);
+
+	if (page) {
+		struct zone *zone = page_zone(page);
+
+		zone->compact_blockskip_flush = false;
+		compaction_defer_reset(zone, order, true);
+		count_vm_event(COMPACTSUCCESS);
+		return page;
+	}
 
-		/* Page migration frees to the PCP lists but we want merging */
-		drain_pages(get_cpu());
-		put_cpu();
-
-		page = get_page_from_freelist(gfp_mask, nodemask,
-				order, zonelist, high_zoneidx,
-				alloc_flags & ~ALLOC_NO_WATERMARKS,
-				preferred_zone, classzone_idx, migratetype);
-
-		if (page) {
-			struct zone *zone = page_zone(page);
-
-			zone->compact_blockskip_flush = false;
-			compaction_defer_reset(zone, order, true);
-			count_vm_event(COMPACTSUCCESS);
-			return page;
-		}
-
-		/*
-		 * last_compact_zone is where try_to_compact_pages thought
-		 * allocation should succeed, so it did not defer compaction.
-		 * But now we know that it didn't succeed, so we do the defer.
-		 */
-		if (last_compact_zone && mode != MIGRATE_ASYNC)
-			defer_compaction(last_compact_zone, order);
-
-		/*
-		 * It's bad if compaction run occurs and fails.
-		 * The most likely reason is that pages exist,
-		 * but not enough to satisfy watermarks.
-		 */
-		count_vm_event(COMPACTFAIL);
+	/*
+	 * last_compact_zone is where try_to_compact_pages thought allocation
+	 * should succeed, so it did not defer compaction. But here we know
+	 * that it didn't succeed, so we do the defer.
+	 */
+	if (last_compact_zone && mode != MIGRATE_ASYNC)
+		defer_compaction(last_compact_zone, order);
+
+	/*
+	 * It's bad if compaction run occurs and fails. The most likely reason
+	 * is that pages exist, but not enough to satisfy watermarks.
+	 */
+	count_vm_event(COMPACTFAIL);
 
-		cond_resched();
-	}
+	cond_resched();
 
 	return NULL;
 }
_

Patches currently in -mm which might be from vbabka@suse.cz are

origin.patch

