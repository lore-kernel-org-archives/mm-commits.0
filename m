From: akpm@linux-foundation.org
Subject: [merged]
 mm-get-rid-of-unnecessary-overhead-of-trace_mm_page_alloc_extfrag.patch
 removed from -mm tree
Date: Wed, 13 Nov 2013 12:39:18 -0800
Message-ID: <5283e376.tebRnkVyESaTSw1Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42781 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab3KMUjT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:39:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de, kosaki.motohiro@jp.fujitsu.com

Subject: [merged] mm-get-rid-of-unnecessary-overhead-of-trace_mm_page_alloc_extfrag.patch removed from -mm tree
To: kosaki.motohiro@jp.fujitsu.com,mgorman@suse.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:39:18 -0800


The patch titled
     Subject: mm: get rid of unnecessary overhead of trace_mm_page_alloc_extfrag()
has been removed from the -mm tree.  Its filename was
     mm-get-rid-of-unnecessary-overhead-of-trace_mm_page_alloc_extfrag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: mm: get rid of unnecessary overhead of trace_mm_page_alloc_extfrag()

In general, every tracepoint should be zero overhead if it is disabled. 
However, trace_mm_page_alloc_extfrag() is one of exception.  It evaluate
"new_type == start_migratetype" even if tracepoint is disabled.

However, the code can be moved into tracepoint's TP_fast_assign() and
TP_fast_assign exist exactly such purpose.  This patch does it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/kmem.h |   10 ++++------
 mm/page_alloc.c             |    5 ++---
 2 files changed, 6 insertions(+), 9 deletions(-)

diff -puN include/trace/events/kmem.h~mm-get-rid-of-unnecessary-overhead-of-trace_mm_page_alloc_extfrag include/trace/events/kmem.h
--- a/include/trace/events/kmem.h~mm-get-rid-of-unnecessary-overhead-of-trace_mm_page_alloc_extfrag
+++ a/include/trace/events/kmem.h
@@ -267,14 +267,12 @@ DEFINE_EVENT_PRINT(mm_page, mm_page_pcpu
 TRACE_EVENT(mm_page_alloc_extfrag,
 
 	TP_PROTO(struct page *page,
-			int alloc_order, int fallback_order,
-			int alloc_migratetype, int fallback_migratetype,
-			int change_ownership),
+		int alloc_order, int fallback_order,
+		int alloc_migratetype, int fallback_migratetype, int new_migratetype),
 
 	TP_ARGS(page,
 		alloc_order, fallback_order,
-		alloc_migratetype, fallback_migratetype,
-		change_ownership),
+		alloc_migratetype, fallback_migratetype, new_migratetype),
 
 	TP_STRUCT__entry(
 		__field(	struct page *,	page			)
@@ -291,7 +289,7 @@ TRACE_EVENT(mm_page_alloc_extfrag,
 		__entry->fallback_order		= fallback_order;
 		__entry->alloc_migratetype	= alloc_migratetype;
 		__entry->fallback_migratetype	= fallback_migratetype;
-		__entry->change_ownership	= change_ownership;
+		__entry->change_ownership	= (new_migratetype == alloc_migratetype);
 	),
 
 	TP_printk("page=%p pfn=%lu alloc_order=%d fallback_order=%d pageblock_order=%d alloc_migratetype=%d fallback_migratetype=%d fragmenting=%d change_ownership=%d",
diff -puN mm/page_alloc.c~mm-get-rid-of-unnecessary-overhead-of-trace_mm_page_alloc_extfrag mm/page_alloc.c
--- a/mm/page_alloc.c~mm-get-rid-of-unnecessary-overhead-of-trace_mm_page_alloc_extfrag
+++ a/mm/page_alloc.c
@@ -1103,9 +1103,8 @@ __rmqueue_fallback(struct zone *zone, in
 			       is_migrate_cma(migratetype)
 			     ? migratetype : start_migratetype);
 
-			trace_mm_page_alloc_extfrag(page, order,
-				current_order, start_migratetype, migratetype,
-				new_type == start_migratetype);
+			trace_mm_page_alloc_extfrag(page, order, current_order,
+				start_migratetype, migratetype, new_type);
 
 			return page;
 		}
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch

