From: akpm@linux-foundation.org
Subject: + mm-page_alloc-remove-unnecessary-parameter-from-__rmqueue.patch added to -mm tree
Date: Wed, 02 Dec 2015 14:46:55 -0800
Message-ID: <565f74df.0QYzPi4MspScYVbv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37926 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757077AbbLBWq4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2015 17:46:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: remove unnecessary parameter from __rmqueue
has been added to the -mm tree.  Its filename is
     mm-page_alloc-remove-unnecessary-parameter-from-__rmqueue.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-remove-unnecessary-parameter-from-__rmqueue.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-remove-unnecessary-parameter-from-__rmqueue.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc.c: remove unnecessary parameter from __rmqueue

Commit 0aaa29a56e4f ("mm, page_alloc: reserve pageblocks for high-order
atomic allocations on demand") added an unnecessary and unused parameter
to __rmqueue.  It was a parameter that was used in an earlier version of
the patch and then left behind.  This patch cleans it up.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
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

mm-page_alloc-remove-unnecessary-parameter-from-__rmqueue.patch

