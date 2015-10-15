From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand-fix-2.patch added to -mm tree
Date: Thu, 15 Oct 2015 13:37:51 -0700
Message-ID: <56200e9f.fT3wUDeERgGiEyVk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58869 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbbJOUhw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Oct 2015 16:37:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yalin.wang2010@gmail.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: reserve pageblocks for high-order atomic allocations on demand -fix
has been added to the -mm tree.  Its filename is
     mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: yalin wang <yalin.wang2010@gmail.com>
Subject: mm, page_alloc: reserve pageblocks for high-order atomic allocations on demand -fix

There is a redundant check and a memory leak introduced by a patch in
mmotm.  This patch removes an unlikely(order) check as we are sure order
is not zero at the time.  It also checks if a page is already allocated to
avoid a memory leak.

This is a fix to the mmotm patch
mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand.patch

Signed-off-by: yalin wang <yalin.wang2010@gmail.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand-fix-2 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-reserve-pageblocks-for-high-order-atomic-allocations-on-demand-fix-2
+++ a/mm/page_alloc.c
@@ -2212,13 +2212,13 @@ struct page *buffered_rmqueue(struct zon
 		spin_lock_irqsave(&zone->lock, flags);
 
 		page = NULL;
-		if (unlikely(order) && (alloc_flags & ALLOC_HARDER)) {
+		if (alloc_flags & ALLOC_HARDER) {
 			page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
 			if (page)
 				trace_mm_page_alloc_zone_locked(page, order, migratetype);
 		}
