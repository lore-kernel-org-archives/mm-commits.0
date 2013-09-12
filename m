From: akpm@linux-foundation.org
Subject: [merged]
 mm-fix-the-value-of-fallback_migratetype-in-alloc_extfrag-tracepoint.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:42:49 -0700
Message-ID: <52321939.GS+zxIibZKG3lte4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58043 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab3ILTmu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:42:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, minchan@kernel.org, mel@csn.ul.ie, cody@linux.vnet.ibm.com, srivatsa.bhat@linux.vnet.ibm.com

Subject: [merged] mm-fix-the-value-of-fallback_migratetype-in-alloc_extfrag-tracepoint.patch removed from -mm tree
To: srivatsa.bhat@linux.vnet.ibm.com,cody@linux.vnet.ibm.com,mel@csn.ul.ie,minchan@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:42:49 -0700


The patch titled
     Subject: mm/page_alloc.c: fix the value of fallback_migratetype in alloc_extfrag tracepoint()
has been removed from the -mm tree.  Its filename was
     mm-fix-the-value-of-fallback_migratetype-in-alloc_extfrag-tracepoint.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: mm/page_alloc.c: fix the value of fallback_migratetype in alloc_extfrag tracepoint()

In the current code, the value of fallback_migratetype that is printed
using the mm_page_alloc_extfrag tracepoint, is the value of the
migratetype *after* it has been set to the preferred migratetype (if the
ownership was changed).  Obviously that wouldn't have been the original
intent.  (We already have a separate 'change_ownership' field to tell
whether the ownership of the pageblock was changed from the
fallback_migratetype to the preferred type.)

The intent of the fallback_migratetype field is to show the migratetype
from which we borrowed pages in order to satisfy the allocation request. 
So fix the code to print that value correctly.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/kmem.h |   10 +++++++---
 mm/page_alloc.c             |    5 +++--
 2 files changed, 10 insertions(+), 5 deletions(-)

diff -puN include/trace/events/kmem.h~mm-fix-the-value-of-fallback_migratetype-in-alloc_extfrag-tracepoint include/trace/events/kmem.h
--- a/include/trace/events/kmem.h~mm-fix-the-value-of-fallback_migratetype-in-alloc_extfrag-tracepoint
+++ a/include/trace/events/kmem.h
@@ -268,11 +268,13 @@ TRACE_EVENT(mm_page_alloc_extfrag,
 
 	TP_PROTO(struct page *page,
 			int alloc_order, int fallback_order,
-			int alloc_migratetype, int fallback_migratetype),
+			int alloc_migratetype, int fallback_migratetype,
+			int change_ownership),
 
 	TP_ARGS(page,
 		alloc_order, fallback_order,
-		alloc_migratetype, fallback_migratetype),
+		alloc_migratetype, fallback_migratetype,
+		change_ownership),
 
 	TP_STRUCT__entry(
 		__field(	struct page *,	page			)
@@ -280,6 +282,7 @@ TRACE_EVENT(mm_page_alloc_extfrag,
 		__field(	int,		fallback_order		)
 		__field(	int,		alloc_migratetype	)
 		__field(	int,		fallback_migratetype	)
+		__field(	int,		change_ownership	)
 	),
 
 	TP_fast_assign(
@@ -288,6 +291,7 @@ TRACE_EVENT(mm_page_alloc_extfrag,
 		__entry->fallback_order		= fallback_order;
 		__entry->alloc_migratetype	= alloc_migratetype;
 		__entry->fallback_migratetype	= fallback_migratetype;
+		__entry->change_ownership	= change_ownership;
 	),
 
 	TP_printk("page=%p pfn=%lu alloc_order=%d fallback_order=%d pageblock_order=%d alloc_migratetype=%d fallback_migratetype=%d fragmenting=%d change_ownership=%d",
@@ -299,7 +303,7 @@ TRACE_EVENT(mm_page_alloc_extfrag,
 		__entry->alloc_migratetype,
 		__entry->fallback_migratetype,
 		__entry->fallback_order < pageblock_order,
-		__entry->alloc_migratetype == __entry->fallback_migratetype)
+		__entry->change_ownership)
 );
 
 #endif /* _TRACE_KMEM_H */
diff -puN mm/page_alloc.c~mm-fix-the-value-of-fallback_migratetype-in-alloc_extfrag-tracepoint mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-the-value-of-fallback_migratetype-in-alloc_extfrag-tracepoint
+++ a/mm/page_alloc.c
@@ -1101,8 +1101,9 @@ __rmqueue_fallback(struct zone *zone, in
 			       is_migrate_cma(migratetype)
 			     ? migratetype : start_migratetype);
 
-			trace_mm_page_alloc_extfrag(page, order, current_order,
-				start_migratetype, new_type);
+			trace_mm_page_alloc_extfrag(page, order,
+				current_order, start_migratetype, migratetype,
+				new_type == start_migratetype);
 
 			return page;
 		}
_

Patches currently in -mm which might be from srivatsa.bhat@linux.vnet.ibm.com are

origin.patch

