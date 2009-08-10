From: akpm@linux-foundation.org
Subject: + tracing-page-allocator-add-trace-events-for-anti-fragmentation-falling-back-to-other-migratetypes.patch added to -mm tree
Date: Mon, 10 Aug 2009 15:09:57 -0700
Message-ID: <200908102209.n7AM9vZB013840@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753675AbZHJWML (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Aug 2009 18:12:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, lwoodman@redhat.com, macli@brc.ubc.ca, mingo@elte.hu, peterz@infradead.org, riel@redhat.com


The patch titled
     tracing, page-allocator: add trace events for anti-fragmentation falling back to other migratetypes
has been added to the -mm tree.  Its filename is
     tracing-page-allocator-add-trace-events-for-anti-fragmentation-falling-back-to-other-migratetypes.patch

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
@@ -874,6 +874,10 @@ __rmqueue_fallback(struct zone *zone, in
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

