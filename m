From: akpm@linux-foundation.org
Subject: + tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists.patch added to -mm tree
Date: Mon, 10 Aug 2009 15:10:00 -0700
Message-ID: <200908102210.n7AMA0Cp013861@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50026 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753521AbZHJWMb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Aug 2009 18:12:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, lwoodman@redhat.com, macli@brc.ubc.ca, mingo@elte.hu, peterz@infradead.org, riel@redhat.com


The patch titled
     tracing, page-allocator: add trace event for page traffic related to the buddy lists
has been added to the -mm tree.  Its filename is
     tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Li Ming Chun <macli@brc.ubc.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/kmem.h |   51 ++++++++++++++++++++++++++++++++++
 mm/page_alloc.c             |    2 +
 2 files changed, 53 insertions(+)

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
@@ -546,6 +546,7 @@ static void free_pages_bulk(struct zone 
 		page = list_entry(list->prev, struct page, lru);
 		/* have to delete it as __free_one_page list manipulates */
 		list_del(&page->lru);
+		trace_mm_page_pcpu_drain(page, order, page_private(page));
 		__free_one_page(page, zone, order, page_private(page));
 	}
 	spin_unlock(&zone->lock);
@@ -911,6 +912,7 @@ retry_reserve:
 		}
 	}
 
+	trace_mm_page_alloc_zone_locked(page, order, migratetype);
 	return page;
 }
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

memory-hotplug-update-zone-pcp-at-memory-online.patch
memory-hotplug-update-zone-pcp-at-memory-online-fix.patch
memory-hotplug-exclude-isolated-page-from-pco-page-alloc.patch
memory-hotplug-make-pages-from-movable-zone-always-isolatable.patch
memory-hotplug-alloc-page-from-other-node-in-memory-online.patch
memory-hotplug-migrate-swap-cache-page.patch
hugetlb-balance-freeing-of-huge-pages-across-nodes.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages-fix.patch
hugetlb-clean-up-and-update-huge-pages-documentation.patch
hugetlb-restore-interleaving-of-bootmem-huge-pages.patch
mm-clean-up-page_remove_rmap.patch
mm-update-alloc_flags-after-oom-killer-has-been-called.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch
vmscan-kill-unnecessary-page-flag-test.patch
vmscan-kill-unnecessary-prefetch.patch
mm-perform-non-atomic-test-clear-of-pg_mlocked-on-free.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch
page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback.patch
page-allocator-remove-dead-function-free_cold_page.patch
tracing-page-allocator-add-trace-events-for-page-allocation-and-page-freeing.patch
tracing-page-allocator-add-trace-events-for-anti-fragmentation-falling-back-to-other-migratetypes.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists.patch
tracing-page-allocator-add-a-postprocessing-script-for-page-allocator-related-ftrace-events.patch
tracing-documentation-add-a-document-describing-how-to-do-some-performance-analysis-with-tracepoints.patch
tracing-documentation-add-a-document-on-the-kmem-tracepoints.patch
add-debugging-aid-for-memory-initialisation-problems.patch

