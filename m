From: akpm@linux-foundation.org
Subject: + mm-page_alloc-simplify-list-handling-in-rmqueue_bulk.patch
 added to -mm tree
Date: Thu, 19 Oct 2017 12:26:02 -0700
Message-ID: <59e8fc4a.SJ38+LU+ZgUPHA1j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42370 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752106AbdJST0E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Oct 2017 15:26:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, ak@linux.intel.com, dave.hansen@intel.com, david@fromorbit.com, hannes@cmpxchg.org, jack@suse.cz, mgorman@techsingularity.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: simplify list handling in rmqueue_bulk()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-simplify-list-handling-in-rmqueue_bulk.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-simplify-list-handling-in-rmqueue_bulk.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-simplify-list-handling-in-rmqueue_bulk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -2330,16 +2330,16 @@ static int rmqueue_bulk(struct zone *zon
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

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-simplify-list-handling-in-rmqueue_bulk.patch

