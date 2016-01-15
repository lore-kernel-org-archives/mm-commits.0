From: akpm@linux-foundation.org
Subject: [merged] mm-get-rid-of-__alloc_pages_high_priority.patch removed
 from -mm tree
Date: Fri, 15 Jan 2016 14:32:58 -0800
Message-ID: <5699739a.fwPc/pTCObZezJET%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59287 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbcAOWc7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:32:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, mgorman@suse.de, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: get rid of __alloc_pages_high_priority()
has been removed from the -mm tree.  Its filename was
     mm-get-rid-of-__alloc_pages_high_priority.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm/page_alloc.c: get rid of __alloc_pages_high_priority()

__alloc_pages_high_priority doesn't do anything special other than it
calls get_page_from_freelist and loops around GFP_NOFAIL allocation until
it succeeds.  It would be better if the first part was done in
__alloc_pages_slowpath where we modify the zonelist because this would be
easier to read and understand.  Opencoding the function into its only
caller allows to simplify it a bit as well.

This patch doesn't introduce any functional changes.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   38 ++++++++++----------------------------
 1 file changed, 10 insertions(+), 28 deletions(-)

diff -puN mm/page_alloc.c~mm-get-rid-of-__alloc_pages_high_priority mm/page_alloc.c
--- a/mm/page_alloc.c~mm-get-rid-of-__alloc_pages_high_priority
+++ a/mm/page_alloc.c
@@ -2876,28 +2876,6 @@ retry:
 	return page;
 }
 
-/*
- * This is called in the allocator slow-path if the allocation request is of
- * sufficient urgency to ignore watermarks and take other desperate measures
- */
-static inline struct page *
-__alloc_pages_high_priority(gfp_t gfp_mask, unsigned int order,
-				const struct alloc_context *ac)
-{
-	struct page *page;
-
-	do {
-		page = get_page_from_freelist(gfp_mask, order,
-						ALLOC_NO_WATERMARKS, ac);
-
-		if (!page && gfp_mask & __GFP_NOFAIL)
-			wait_iff_congested(ac->preferred_zone, BLK_RW_ASYNC,
-									HZ/50);
-	} while (!page && (gfp_mask & __GFP_NOFAIL));
-
-	return page;
-}
-
 static void wake_all_kswapds(unsigned int order, const struct alloc_context *ac)
 {
 	struct zoneref *z;
@@ -3042,12 +3020,16 @@ retry:
 		 * allocations are system rather than user orientated
 		 */
 		ac->zonelist = node_zonelist(numa_node_id(), gfp_mask);
-
-		page = __alloc_pages_high_priority(gfp_mask, order, ac);
-
-		if (page) {
-			goto got_pg;
-		}
+		do {
+			page = get_page_from_freelist(gfp_mask, order,
+						      ALLOC_NO_WATERMARKS, ac);
+			if (page)
+				goto got_pg;
+
+			if (gfp_mask & __GFP_NOFAIL)
+				wait_iff_congested(ac->preferred_zone,
+						   BLK_RW_ASYNC, HZ/50);
+		} while (gfp_mask & __GFP_NOFAIL);
 	}
 
 	/* Caller is not willing to reclaim, we can't balance anything */
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch
mm-oom-introduce-oom-reaper.patch
mm-oom-introduce-oom-reaper-v4.patch
oom-reaper-handle-anonymous-mlocked-pages.patch
oom-clear-tif_memdie-after-oom_reaper-managed-to-unmap-the-address-space.patch

