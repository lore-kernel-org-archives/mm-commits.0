From: akpm@linux-foundation.org
Subject: + vmscan-tracing-add-trace-event-when-a-page-is-written-update-trace-event-to-track-if-page-reclaim-io-is-for-anon-or-file-pages.patch added to -mm tree
Date: Fri, 30 Jul 2010 14:48:21 -0700
Message-ID: <201007302148.o6ULmL8J002430@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47482 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752841Ab0G3Vtq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jul 2010 17:49:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, aarcange@redhat.com, chris.mason@oracle.com, david@fromorbit.com, hannes@cmpxchg.org, hch@infradead.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com, mrubin@google.com, npiggin@suse.de, riel@redhat.com


The patch titled
     vmscan: tracing: update trace event to track if page reclaim IO is for anon or file pages
has been added to the -mm tree.  Its filename is
     vmscan-tracing-add-trace-event-when-a-page-is-written-update-trace-event-to-track-if-page-reclaim-io-is-for-anon-or-file-pages.patch

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
Subject: vmscan: tracing: update trace event to track if page reclaim IO is for anon or file pages
From: Mel Gorman <mel@csn.ul.ie>

It is useful to distinguish between IO for anon and file pages.  This
patch updates vmscan-tracing-add-trace-event-when-a-page-is-written.patch
to include that information.  The patches can be merged together.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Larry Woodman <lwoodman@redhat.com>
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

 include/trace/events/vmscan.h |   30 ++++++++++++++++++++++++------
 mm/vmscan.c                   |    2 +-
 2 files changed, 25 insertions(+), 7 deletions(-)

diff -puN include/trace/events/vmscan.h~vmscan-tracing-add-trace-event-when-a-page-is-written-update-trace-event-to-track-if-page-reclaim-io-is-for-anon-or-file-pages include/trace/events/vmscan.h
--- a/include/trace/events/vmscan.h~vmscan-tracing-add-trace-event-when-a-page-is-written-update-trace-event-to-track-if-page-reclaim-io-is-for-anon-or-file-pages
+++ a/include/trace/events/vmscan.h
@@ -8,6 +8,24 @@
 #include <linux/tracepoint.h>
 #include "gfpflags.h"
 
+#define RECLAIM_WB_ANON		0x0001u
+#define RECLAIM_WB_FILE		0x0002u
+#define RECLAIM_WB_SYNC		0x0004u
+#define RECLAIM_WB_ASYNC	0x0008u
+
+#define show_reclaim_flags(flags)				\
+	(flags) ? __print_flags(flags, "|",			\
+		{RECLAIM_WB_ANON,	"RECLAIM_WB_ANON"},	\
+		{RECLAIM_WB_FILE,	"RECLAIM_WB_FILE"},	\
+		{RECLAIM_WB_SYNC,	"RECLAIM_WB_SYNC"},	\
+		{RECLAIM_WB_ASYNC,	"RECLAIM_WB_ASYNC"}	\
+		) : "RECLAIM_WB_NONE"
+
+#define trace_reclaim_flags(page, sync) ( \
+	(page_is_file_cache(page) ? RECLAIM_WB_FILE : RECLAIM_WB_ANON) | \
+	(sync == PAGEOUT_IO_SYNC ? RECLAIM_WB_SYNC : RECLAIM_WB_ASYNC)   \
+	)
+
 TRACE_EVENT(mm_vmscan_kswapd_sleep,
 
 	TP_PROTO(int nid),
@@ -158,24 +176,24 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 TRACE_EVENT(mm_vmscan_writepage,
 
 	TP_PROTO(struct page *page,
-		int sync_io),
+		int reclaim_flags),
 
-	TP_ARGS(page, sync_io),
+	TP_ARGS(page, reclaim_flags),
 
 	TP_STRUCT__entry(
 		__field(struct page *, page)
-		__field(int, sync_io)
+		__field(int, reclaim_flags)
 	),
 
 	TP_fast_assign(
 		__entry->page = page;
-		__entry->sync_io = sync_io;
+		__entry->reclaim_flags = reclaim_flags;
 	),
 
-	TP_printk("page=%p pfn=%lu sync_io=%d",
+	TP_printk("page=%p pfn=%lu flags=%s",
 		__entry->page,
 		page_to_pfn(__entry->page),
-		__entry->sync_io)
+		show_reclaim_flags(__entry->reclaim_flags))
 );
 
 #endif /* _TRACE_VMSCAN_H */
diff -puN mm/vmscan.c~vmscan-tracing-add-trace-event-when-a-page-is-written-update-trace-event-to-track-if-page-reclaim-io-is-for-anon-or-file-pages mm/vmscan.c
--- a/mm/vmscan.c~vmscan-tracing-add-trace-event-when-a-page-is-written-update-trace-event-to-track-if-page-reclaim-io-is-for-anon-or-file-pages
+++ a/mm/vmscan.c
@@ -402,7 +402,7 @@ static pageout_t pageout(struct page *pa
 			ClearPageReclaim(page);
 		}
 		trace_mm_vmscan_writepage(page,
-			sync_writeback == PAGEOUT_IO_SYNC);
+			trace_reclaim_flags(page, sync_writeback));
 		inc_zone_page_state(page, NR_VMSCAN_WRITE);
 		return PAGE_SUCCESS;
 	}
_

Patches currently in -mm which might be from mel@csn.ul.ie are

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
vmscan-tracing-add-trace-event-when-a-page-is-written-update-trace-event-to-track-if-page-reclaim-io-is-for-anon-or-file-pages.patch
vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events.patch
vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events-update-post-processing-script-to-distinguish-between-anon-and-file-io-from-page-reclaim.patch
vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events-correct-units-in-post-processing-script.patch
vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
vmscan-kick-flusher-threads-to-clean-pages-when-reclaim-is-encountering-dirty-pages.patch
vmscan-kill-prev_priority-completely.patch
vmscan-simplify-shrink_inactive_list.patch
vmscan-simplify-shrink_inactive_list-checkpatch-fixes.patch
vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages.patch
vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages-checkpatch-fixes.patch
vmscan-set-up-pagevec-as-late-as-possible-in-shrink_inactive_list.patch
vmscan-set-up-pagevec-as-late-as-possible-in-shrink_page_list.patch
vmscan-update-isolated-page-counters-outside-of-main-path-in-shrink_inactive_list.patch
vmscan-avoid-subtraction-of-unsigned-types.patch
vmscan-convert-direct-reclaim-tracepoint-to-define_trace.patch
memcg-vmscan-add-memcg-reclaim-tracepoint.patch
vmscan-convert-mm_vmscan_lru_isolate-to-define_event.patch
memcg-add-mm_vmscan_memcg_isolate-tracepoint.patch
memcg-scnr_to_reclaim-should-be-initialized.patch
memcg-kill-unnecessary-initialization-in-mem_cgroup_shrink_node_zone.patch
memcg-mem_cgroup_shrink_node_zone-doesnt-need-scnodemask.patch
memcg-remove-nid-and-zid-argument-from-mem_cgroup_soft_limit_reclaim.patch
memcg-convert-to-use-zone_to_nid-from-bare-zone-zone_pgdat-node_id.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
add-debugging-aid-for-memory-initialisation-problems.patch

