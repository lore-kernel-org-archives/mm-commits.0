From: akpm@linux-foundation.org
Subject: + tracing-page-allocator-add-trace-events-for-page-allocation-and-page-freeing.patch added to -mm tree
Date: Mon, 10 Aug 2009 15:09:53 -0700
Message-ID: <200908102209.n7AM9r7f013772@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754037AbZHJWMN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Aug 2009 18:12:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, lwoodman@redhat.com, macli@brc.ubc.ca, mingo@elte.hu, peterz@infradead.org, riel@redhat.com


The patch titled
     tracing, page-allocator: add trace events for page allocation and page freeing
has been added to the -mm tree.  Its filename is
     tracing-page-allocator-add-trace-events-for-page-allocation-and-page-freeing.patch

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
Subject: tracing, page-allocator: add trace events for page allocation and page freeing
From: Mel Gorman <mel@csn.ul.ie>

This patch adds trace events for the allocation and freeing of pages,
including the freeing of pagevecs.  Using the events, it will be known
what struct page and pfns are being allocated and freed and what the call
site was in many cases.

The page alloc tracepoints be used as an indicator as to whether the
workload was heavily dependant on the page allocator or not.  You can make
a guess based on vmstat but you can't get a per-process breakdown. 
Depending on the call path, the call_site for page allocation may be
__get_free_pages() instead of a useful callsite.  Instead of passing down
a return address similar to slab debugging, the user should enable the
stacktrace and seg-addr options to get a proper stack trace.

The pagevec free tracepoint has a different usecase.  It can be used to
get a idea of how many pages are being dumped off the LRU and whether it
is kswapd doing the work or a process doing direct reclaim.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Li Ming Chun <macli@brc.ubc.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/kmem.h |   74 ++++++++++++++++++++++++++++++++++
 mm/page_alloc.c             |    7 ++-
 2 files changed, 80 insertions(+), 1 deletion(-)

diff -puN include/trace/events/kmem.h~tracing-page-allocator-add-trace-events-for-page-allocation-and-page-freeing include/trace/events/kmem.h
--- a/include/trace/events/kmem.h~tracing-page-allocator-add-trace-events-for-page-allocation-and-page-freeing
+++ a/include/trace/events/kmem.h
@@ -225,6 +225,80 @@ TRACE_EVENT(kmem_cache_free,
 
 	TP_printk("call_site=%lx ptr=%p", __entry->call_site, __entry->ptr)
 );
+
+TRACE_EVENT(mm_page_free_direct,
+
+	TP_PROTO(struct page *page, unsigned int order),
+
+	TP_ARGS(page, order),
+
+	TP_STRUCT__entry(
+		__field(	struct page *,	page		)
+		__field(	unsigned int,	order		)
+	),
+
+	TP_fast_assign(
+		__entry->page		= page;
+		__entry->order		= order;
+	),
+
+	TP_printk("page=%p pfn=%lu order=%d",
+			__entry->page,
+			page_to_pfn(__entry->page),
+			__entry->order)
+);
+
+TRACE_EVENT(mm_pagevec_free,
+
+	TP_PROTO(struct page *page, int cold),
+
+	TP_ARGS(page, cold),
+
+	TP_STRUCT__entry(
+		__field(	struct page *,	page		)
+		__field(	int,		cold		)
+	),
+
+	TP_fast_assign(
+		__entry->page		= page;
+		__entry->cold		= cold;
+	),
+
+	TP_printk("page=%p pfn=%lu order=0 cold=%d",
+			__entry->page,
+			page_to_pfn(__entry->page),
+			__entry->cold)
+);
+
+TRACE_EVENT(mm_page_alloc,
+
+	TP_PROTO(struct page *page, unsigned int order,
+			gfp_t gfp_flags, int migratetype),
+
+	TP_ARGS(page, order, gfp_flags, migratetype),
+
+	TP_STRUCT__entry(
+		__field(	struct page *,	page		)
+		__field(	unsigned int,	order		)
+		__field(	gfp_t,		gfp_flags	)
+		__field(	int,		migratetype	)
+	),
+
+	TP_fast_assign(
+		__entry->page		= page;
+		__entry->order		= order;
+		__entry->gfp_flags	= gfp_flags;
+		__entry->migratetype	= migratetype;
+	),
+
+	TP_printk("page=%p pfn=%lu order=%d migratetype=%d gfp_flags=%s",
+		__entry->page,
+		page_to_pfn(__entry->page),
+		__entry->order,
+		__entry->migratetype,
+		show_gfp_flags(__entry->gfp_flags))
+);
+
 #endif /* _TRACE_KMEM_H */
 
 /* This part must be outside protection */
diff -puN mm/page_alloc.c~tracing-page-allocator-add-trace-events-for-page-allocation-and-page-freeing mm/page_alloc.c
--- a/mm/page_alloc.c~tracing-page-allocator-add-trace-events-for-page-allocation-and-page-freeing
+++ a/mm/page_alloc.c
@@ -1097,6 +1097,7 @@ static void free_hot_cold_page(struct pa
 
 void free_hot_page(struct page *page)
 {
+	trace_mm_page_free_direct(page, 0);
 	free_hot_cold_page(page, 0);
 }
 	
@@ -1941,6 +1942,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 				zonelist, high_zoneidx, nodemask,
 				preferred_zone, migratetype);
 
+	trace_mm_page_alloc(page, order, gfp_mask, migratetype);
 	return page;
 }
 EXPORT_SYMBOL(__alloc_pages_nodemask);
@@ -1975,13 +1977,16 @@ void __pagevec_free(struct pagevec *pvec
 {
 	int i = pagevec_count(pvec);
 
-	while (--i >= 0)
+	while (--i >= 0) {
+		trace_mm_pagevec_free(pvec->pages[i], pvec->cold);
 		free_hot_cold_page(pvec->pages[i], pvec->cold);
+	}
 }
 
 void __free_pages(struct page *page, unsigned int order)
 {
 	if (put_page_testzero(page)) {
+		trace_mm_page_free_direct(page, order);
 		if (order == 0)
 			free_hot_page(page);
 		else
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

