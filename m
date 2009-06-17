From: akpm@linux-foundation.org
Subject: [merged] page-allocator-do-not-sanity-check-order-in-the-fast-path.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:33:34 -0700
Message-ID: <200906171833.n5HIXY3r032105@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755734AbZFQSeX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:34:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, Lee.Schermerhorn@hp.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, dave@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au, penberg@cs.h


The patch titled
     page allocator: do not sanity check order in the fast path
has been removed from the -mm tree.  Its filename was
     page-allocator-do-not-sanity-check-order-in-the-fast-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page allocator: do not sanity check order in the fast path
From: Mel Gorman <mel@csn.ul.ie>

No user of the allocator API should be passing in an order >= MAX_ORDER
but we check for it on each and every allocation.  Delete this check and
make it a VM_BUG_ON check further down the call path.

[akpm@linux-foundation.org: s/VM_BUG_ON/WARN_ON_ONCE/]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    6 ------
 mm/page_alloc.c     |    3 +++
 2 files changed, 3 insertions(+), 6 deletions(-)

diff -puN include/linux/gfp.h~page-allocator-do-not-sanity-check-order-in-the-fast-path include/linux/gfp.h
--- a/include/linux/gfp.h~page-allocator-do-not-sanity-check-order-in-the-fast-path
+++ a/include/linux/gfp.h
@@ -185,9 +185,6 @@ __alloc_pages(gfp_t gfp_mask, unsigned i
 static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
 						unsigned int order)
 {
-	if (unlikely(order >= MAX_ORDER))
-		return NULL;
-
 	/* Unknown node is current node */
 	if (nid < 0)
 		nid = numa_node_id();
@@ -201,9 +198,6 @@ extern struct page *alloc_pages_current(
 static inline struct page *
 alloc_pages(gfp_t gfp_mask, unsigned int order)
 {
-	if (unlikely(order >= MAX_ORDER))
-		return NULL;
-
 	return alloc_pages_current(gfp_mask, order);
 }
 extern struct page *alloc_page_vma(gfp_t gfp_mask,
diff -puN mm/page_alloc.c~page-allocator-do-not-sanity-check-order-in-the-fast-path mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-do-not-sanity-check-order-in-the-fast-path
+++ a/mm/page_alloc.c
@@ -1401,6 +1401,9 @@ get_page_from_freelist(gfp_t gfp_mask, n
 
 	classzone_idx = zone_idx(preferred_zone);
 
+	if (WARN_ON_ONCE(order >= MAX_ORDER))
+		return NULL;
+
 zonelist_scan:
 	/*
 	 * Scan zonelist, looking for a zone with enough free.
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
linux-next.patch
page_alloc-oops-when-setting-percpu_pagelist_fraction.patch
memcg-fix-lru-rotation-in-isolate_pages.patch
add-debugging-aid-for-memory-initialisation-problems.patch

