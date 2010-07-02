From: akpm@linux-foundation.org
Subject: + vmscan-tracing-add-trace-event-when-a-page-is-written.patch added to -mm tree
Date: Fri, 02 Jul 2010 12:57:24 -0700
Message-ID: <201007021957.o62JvOHj023755@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756777Ab0GBT6W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jul 2010 15:58:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, aarcange@redhat.com, chris.mason@oracle.com, david@fromorbit.com, hannes@cmpxchg.org, hch@infradead.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com, mrubin@google.com, npiggin@suse.de, riel@redhat.com


The patch titled
     vmscan: tracing: add trace event when a page is written
has been added to the -mm tree.  Its filename is
     vmscan-tracing-add-trace-event-when-a-page-is-written.patch

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
Subject: vmscan: tracing: add trace event when a page is written
From: Mel Gorman <mel@csn.ul.ie>

Add a trace event for when page reclaim queues a page for IO and records
whether it is synchronous or asynchronous.  Excessive synchronous IO for a
process can result in noticeable stalls during direct reclaim.  Excessive
IO from page reclaim may indicate that the system is seriously under
provisioned for the amount of dirty pages that exist.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Larry Woodman <lwoodman@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michael Rubin <mrubin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |   23 +++++++++++++++++++++++
 mm/vmscan.c                   |    2 ++
 2 files changed, 25 insertions(+)

diff -puN include/trace/events/vmscan.h~vmscan-tracing-add-trace-event-when-a-page-is-written include/trace/events/vmscan.h
--- a/include/trace/events/vmscan.h~vmscan-tracing-add-trace-event-when-a-page-is-written
+++ a/include/trace/events/vmscan.h
@@ -155,6 +155,29 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 		__entry->nr_lumpy_failed)
 );
 
+TRACE_EVENT(mm_vmscan_writepage,
+
+	TP_PROTO(struct page *page,
+		int sync_io),
+
+	TP_ARGS(page, sync_io),
+
+	TP_STRUCT__entry(
+		__field(struct page *, page)
+		__field(int, sync_io)
+	),
+
+	TP_fast_assign(
+		__entry->page = page;
+		__entry->sync_io = sync_io;
+	),
+
+	TP_printk("page=%p pfn=%lu sync_io=%d",
+		__entry->page,
+		page_to_pfn(__entry->page),
+		__entry->sync_io)
+);
+
 #endif /* _TRACE_VMSCAN_H */
 
 /* This part must be outside protection */
diff -puN mm/vmscan.c~vmscan-tracing-add-trace-event-when-a-page-is-written mm/vmscan.c
--- a/mm/vmscan.c~vmscan-tracing-add-trace-event-when-a-page-is-written
+++ a/mm/vmscan.c
@@ -399,6 +399,8 @@ static pageout_t pageout(struct page *pa
 			/* synchronous write or broken a_ops? */
 			ClearPageReclaim(page);
 		}
+		trace_mm_vmscan_writepage(page,
+			sync_writeback == PAGEOUT_IO_SYNC);
 		inc_zone_page_state(page, NR_VMSCAN_WRITE);
 		return PAGE_SUCCESS;
 	}
_

Patches currently in -mm which might be from mel@csn.ul.ie are

mm-vmscan-fix-mapping-use-after-free.patch
linux-next.patch
hugetlb-call-mmu-notifiers-on-hugepage-cow.patch
mm-rename-anon_vma_lock-to-vma_lock_anon_vma.patch
mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function.patch
mm-track-the-root-oldest-anon_vma.patch
mm-always-lock-the-root-oldest-anon_vma.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root-fix.patch
vmscan-tracing-add-trace-events-for-kswapd-wakeup-sleeping-and-direct-reclaim.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation-checkpatch-fixes.patch
vmscan-tracing-add-trace-event-when-a-page-is-written.patch
vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events.patch
vmscan-kill-prev_priority-completely.patch
vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages.patch
vmscan-set-up-pagevec-as-late-as-possible-in-shrink_inactive_list.patch
vmscan-set-up-pagevec-as-late-as-possible-in-shrink_page_list.patch
vmscan-update-isolated-page-counters-outside-of-main-path-in-shrink_inactive_list.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
add-debugging-aid-for-memory-initialisation-problems.patch

