From: akpm@linux-foundation.org
Subject: [merged] tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:41:08 -0700
Message-ID: <200909222041.n8MKf8W9006974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752927AbZIVUmt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:42:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com, macli@brc.ubc.ca, mingo@elte.hu, peterz@infradead.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     tracing, page-allocator: add trace event for page traffic related to the buddy lists
has been removed from the -mm tree.  Its filename was
     tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tracing, page-allocator: add trace event for page traffic related to the buddy lists
From: Mel Gorman <mel@csn.ul.ie>

The page allocation trace event reports that a page was successfully
allocated but it does not specify where it came from.  When analysing
performance, it can be important to distinguish between pages coming from
the per-cpu allocator and pages coming from the buddy lists as the latter
requires the zone lock to the taken and more data structures to be
examined.

This patch adds a trace event for __rmqueue reporting when a page is being
allocated from the buddy lists.  It distinguishes between being called to
refill the per-cpu lists or whether it is a high-order allocation. 
Similarly, this patch adds an event to catch when the PCP lists are being
drained a little and pages are going back to the buddy lists.

This is trickier to draw conclusions from but high activity on those
events could explain why there were a large number of cache misses on a
page-allocator-intensive workload.  The coalescing and splitting of
buddies involves a lot of writing of page metadata and cache line bounces
not to mention the acquisition of an interrupt-safe lock necessary to
enter this path.

[akpm@linux-foundation.org: fix build]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Li Ming Chun <macli@brc.ubc.ca>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/kmem.h |   51 ++++++++++++++++++++++++++++++++++
 mm/page_alloc.c             |    3 ++
 2 files changed, 54 insertions(+)

diff -puN include/trace/events/kmem.h~tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists include/trace/events/kmem.h
--- a/include/trace/events/kmem.h~tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists
+++ a/include/trace/events/kmem.h
@@ -299,6 +299,57 @@ TRACE_EVENT(mm_page_alloc,
 		show_gfp_flags(__entry->gfp_flags))
 );
 
+TRACE_EVENT(mm_page_alloc_zone_locked,
+
+	TP_PROTO(struct page *page, unsigned int order, int migratetype),
+
+	TP_ARGS(page, order, migratetype),
+
+	TP_STRUCT__entry(
+		__field(	struct page *,	page		)
+		__field(	unsigned int,	order		)
+		__field(	int,		migratetype	)
+	),
+
+	TP_fast_assign(
+		__entry->page		= page;
+		__entry->order		= order;
+		__entry->migratetype	= migratetype;
+	),
+
+	TP_printk("page=%p pfn=%lu order=%u migratetype=%d percpu_refill=%d",
+		__entry->page,
+		page_to_pfn(__entry->page),
+		__entry->order,
+		__entry->migratetype,
+		__entry->order == 0)
+);
+
+TRACE_EVENT(mm_page_pcpu_drain,
+
+	TP_PROTO(struct page *page, int order, int migratetype),
+
+	TP_ARGS(page, order, migratetype),
+
+	TP_STRUCT__entry(
+		__field(	struct page *,	page		)
+		__field(	int,		order		)
+		__field(	int,		migratetype	)
+	),
+
+	TP_fast_assign(
+		__entry->page		= page;
+		__entry->order		= order;
+		__entry->migratetype	= migratetype;
+	),
+
+	TP_printk("page=%p pfn=%lu order=%d migratetype=%d",
+		__entry->page,
+		page_to_pfn(__entry->page),
+		__entry->order,
+		__entry->migratetype)
+);
+
 TRACE_EVENT(mm_page_alloc_extfrag,
 
 	TP_PROTO(struct page *page,
diff -puN mm/page_alloc.c~tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists mm/page_alloc.c
--- a/mm/page_alloc.c~tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists
+++ a/mm/page_alloc.c
@@ -48,6 +48,7 @@
 #include <linux/page_cgroup.h>
 #include <linux/debugobjects.h>
 #include <linux/kmemleak.h>
+#include <trace/events/kmem.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -535,6 +536,7 @@ static void free_pages_bulk(struct zone 
 		page = list_entry(list->prev, struct page, lru);
 		/* have to delete it as __free_one_page list manipulates */
 		list_del(&page->lru);
+		trace_mm_page_pcpu_drain(page, order, page_private(page));
 		__free_one_page(page, zone, order, page_private(page));
 	}
 	spin_unlock(&zone->lock);
@@ -890,6 +892,7 @@ retry_reserve:
 		}
 	}
 
+	trace_mm_page_alloc_zone_locked(page, order, migratetype);
 	return page;
 }
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch
add-debugging-aid-for-memory-initialisation-problems.patch

