From: akpm@linux-foundation.org
Subject: [merged] tracing-page-allocator-add-trace-events-for-anti-fragmentation-falling-back-to-other-migratetypes.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:41:05 -0700
Message-ID: <200909222041.n8MKf5dc006877@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752871AbZIVUmt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:42:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, lwoodman@redhat.com, macli@brc.ubc.ca, mingo@elte.hu, peterz@infradead.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     tracing, page-allocator: add trace events for anti-fragmentation falling back to other migratetypes
has been removed from the -mm tree.  Its filename was
     tracing-page-allocator-add-trace-events-for-anti-fragmentation-falling-back-to-other-migratetypes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tracing, page-allocator: add trace events for anti-fragmentation falling back to other migratetypes
From: Mel Gorman <mel@csn.ul.ie>

Fragmentation avoidance depends on being able to use free pages from lists
of the appropriate migrate type.  In the event this is not possible,
__rmqueue_fallback() selects a different list and in some circumstances
change the migratetype of the pageblock.  Simplistically, the more times
this event occurs, the more likely that fragmentation will be a problem
later for hugepage allocation at least but there are other considerations
such as the order of page being split to satisfy the allocation.

This patch adds a trace event for __rmqueue_fallback() that reports what
page is being used for the fallback, the orders of relevant pages, the
desired migratetype and the migratetype of the lists being used, whether
the pageblock changed type and whether this event is important with
respect to fragmentation avoidance or not.  This information can be used
to help analyse fragmentation avoidance and help decide whether
min_free_kbytes should be increased or not.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Li Ming Chun <macli@brc.ubc.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/kmem.h |   38 ++++++++++++++++++++++++++++++++++
 mm/page_alloc.c             |    4 +++
 2 files changed, 42 insertions(+)

diff -puN include/trace/events/kmem.h~tracing-page-allocator-add-trace-events-for-anti-fragmentation-falling-back-to-other-migratetypes include/trace/events/kmem.h
--- a/include/trace/events/kmem.h~tracing-page-allocator-add-trace-events-for-anti-fragmentation-falling-back-to-other-migratetypes
+++ a/include/trace/events/kmem.h
@@ -299,6 +299,44 @@ TRACE_EVENT(mm_page_alloc,
 		show_gfp_flags(__entry->gfp_flags))
 );
 
+TRACE_EVENT(mm_page_alloc_extfrag,
+
+	TP_PROTO(struct page *page,
+			int alloc_order, int fallback_order,
+			int alloc_migratetype, int fallback_migratetype),
+
+	TP_ARGS(page,
+		alloc_order, fallback_order,
+		alloc_migratetype, fallback_migratetype),
+
+	TP_STRUCT__entry(
+		__field(	struct page *,	page			)
+		__field(	int,		alloc_order		)
+		__field(	int,		fallback_order		)
+		__field(	int,		alloc_migratetype	)
+		__field(	int,		fallback_migratetype	)
+	),
+
+	TP_fast_assign(
+		__entry->page			= page;
+		__entry->alloc_order		= alloc_order;
+		__entry->fallback_order		= fallback_order;
+		__entry->alloc_migratetype	= alloc_migratetype;
+		__entry->fallback_migratetype	= fallback_migratetype;
+	),
+
+	TP_printk("page=%p pfn=%lu alloc_order=%d fallback_order=%d pageblock_order=%d alloc_migratetype=%d fallback_migratetype=%d fragmenting=%d change_ownership=%d",
+		__entry->page,
+		page_to_pfn(__entry->page),
+		__entry->alloc_order,
+		__entry->fallback_order,
+		pageblock_order,
+		__entry->alloc_migratetype,
+		__entry->fallback_migratetype,
+		__entry->fallback_order < pageblock_order,
+		__entry->alloc_migratetype == __entry->fallback_migratetype)
+);
+
 #endif /* _TRACE_KMEM_H */
 
 /* This part must be outside protection */
diff -puN mm/page_alloc.c~tracing-page-allocator-add-trace-events-for-anti-fragmentation-falling-back-to-other-migratetypes mm/page_alloc.c
--- a/mm/page_alloc.c~tracing-page-allocator-add-trace-events-for-anti-fragmentation-falling-back-to-other-migratetypes
+++ a/mm/page_alloc.c
@@ -853,6 +853,10 @@ __rmqueue_fallback(struct zone *zone, in
 							start_migratetype);
 
 			expand(zone, page, order, current_order, area, migratetype);
+
+			trace_mm_page_alloc_extfrag(page, order, current_order,
+				start_migratetype, migratetype);
+
 			return page;
 		}
 	}
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch
add-debugging-aid-for-memory-initialisation-problems.patch

