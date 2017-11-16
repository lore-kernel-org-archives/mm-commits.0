From: akpm@linux-foundation.org
Subject: [patch 111/131] mm, page_alloc: simplify list handling in
 rmqueue_bulk()
Date: Wed, 15 Nov 2017 17:38:07 -0800
Message-ID: <20171116013807.7bd7G53zg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40422 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932320AbdKPBiI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:38:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, akpm@linux-foundation.org, dave.hansen@intel.com, david@fromorbit.com, hannes@cmpxchg.org, jack@suse.cz, mgorman@techsingularity.net, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, vbabka@suse.cz

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: simplify list handling in rmqueue_bulk()

rmqueue_bulk() fills an empty pcplist with pages from the free list.  It
tries to preserve increasing order by pfn to the caller, because it leads
to better performance with some I/O controllers, as explained in
e084b2d95e48 ("page-allocator: preserve PFN ordering when __GFP_COLD is
set").

To preserve the order, it's sufficient to add pages to the tail of the
list as they are retrieved.  The current code instead adds to the head of
the list, but then updates the list head pointer to the last added page,
in each step.  This does result in the same order, but is needlessly
confusing and potentially wasteful, with no apparent benefit.  This patch
simplifies the code and adjusts comment accordingly.

Link: http://lkml.kernel.org/r/f6505442-98a9-12e4-b2cd-0fa83874c159@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-simplify-list-handling-in-rmqueue_bulk mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-simplify-list-handling-in-rmqueue_bulk
+++ a/mm/page_alloc.c
@@ -2350,16 +2350,16 @@ static int rmqueue_bulk(struct zone *zon
 			continue;
 
 		/*
-		 * Split buddy pages returned by expand() are received here
-		 * in physical page order. The page is added to the callers and
-		 * list and the list head then moves forward. From the callers
-		 * perspective, the linked list is ordered by page number in
-		 * some conditions. This is useful for IO devices that can
-		 * merge IO requests if the physical pages are ordered
-		 * properly.
+		 * Split buddy pages returned by expand() are received here in
+		 * physical page order. The page is added to the tail of
+		 * caller's list. From the callers perspective, the linked list
+		 * is ordered by page number under some conditions. This is
+		 * useful for IO devices that can forward direction from the
+		 * head, thus also in the physical page order. This is useful
+		 * for IO devices that can merge IO requests if the physical
+		 * pages are ordered properly.
 		 */
-		list_add(&page->lru, list);
-		list = &page->lru;
+		list_add_tail(&page->lru, list);
 		alloced++;
 		if (is_migrate_cma(get_pcppage_migratetype(page)))
 			__mod_zone_page_state(zone, NR_FREE_CMA_PAGES,
_
