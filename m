From: akpm@linux-foundation.org
Subject: [merged] page-allocator-sanity-check-order-in-the-page-allocator-slow-path.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:34:34 -0700
Message-ID: <200906171834.n5HIYYiX000615@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760171AbZFQSey (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:34:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, dave@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     page allocator: sanity check order in the page allocator slow path
has been removed from the -mm tree.  Its filename was
     page-allocator-sanity-check-order-in-the-page-allocator-slow-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page allocator: sanity check order in the page allocator slow path
From: Mel Gorman <mel@csn.ul.ie>

Callers may speculatively call different allocators in order of preference
trying to allocate a buffer of a given size.  The order needed to allocate
this may be larger than what the page allocator can normally handle. 
While the allocator mostly does the right thing, it should not direct
reclaim or wakeup kswapd with a bogus order.  This patch sanity checks the
order in the slow path and returns NULL if it is too large.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~page-allocator-sanity-check-order-in-the-page-allocator-slow-path mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-sanity-check-order-in-the-page-allocator-slow-path
+++ a/mm/page_alloc.c
@@ -1446,9 +1446,6 @@ get_page_from_freelist(gfp_t gfp_mask, n
 	int zlc_active = 0;		/* set if using zonelist_cache */
 	int did_zlc_setup = 0;		/* just call zlc_setup() one time */
 
-	if (WARN_ON_ONCE(order >= MAX_ORDER))
-		return NULL;
-
 	classzone_idx = zone_idx(preferred_zone);
 zonelist_scan:
 	/*
@@ -1707,6 +1704,15 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	struct task_struct *p = current;
 
 	/*
+	 * In the slowpath, we sanity check order to avoid ever trying to
+	 * reclaim >= MAX_ORDER areas which will never succeed. Callers may
+	 * be using allocators in order of preference for an area that is
+	 * too large.
+	 */
+	if (WARN_ON_ONCE(order >= MAX_ORDER))
+		return NULL;
+
+	/*
 	 * GFP_THISNODE (meaning __GFP_THISNODE, __GFP_NORETRY and
 	 * __GFP_NOWARN set) should not cause reclaim since the subsystem
 	 * (f.e. slab) using GFP_THISNODE may choose to trigger reclaim
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
linux-next.patch
page_alloc-oops-when-setting-percpu_pagelist_fraction.patch
memcg-fix-lru-rotation-in-isolate_pages.patch
add-debugging-aid-for-memory-initialisation-problems.patch

