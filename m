From: akpm@linux-foundation.org
Subject: + vmscan-tracing-add-trace-events-for-lru-page-isolation.patch added to -mm tree
Date: Fri, 02 Jul 2010 12:55:52 -0700
Message-ID: <201007021955.o62JtqU2023711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756231Ab0GBT4s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jul 2010 15:56:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, aarcange@redhat.com, chris.mason@oracle.com, david@fromorbit.com, hannes@cmpxchg.org, hch@infradead.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com, mrubin@google.com, npiggin@suse.de, riel@redhat.com


The patch titled
     vmscan: tracing: add trace events for LRU page isolation
has been added to the -mm tree.  Its filename is
     vmscan-tracing-add-trace-events-for-lru-page-isolation.patch

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
Subject: vmscan: tracing: add trace events for LRU page isolation
From: Mel Gorman <mel@csn.ul.ie>

Add an event for when pages are isolated en-masse from the LRU lists. 
This event augments the information available on LRU traffic and can be
used to evaluate lumpy reclaim.

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

 include/trace/events/vmscan.h |   46 ++++++++++++++++++++++++++++++++
 mm/vmscan.c                   |   14 +++++++++
 2 files changed, 60 insertions(+)

diff -puN include/trace/events/vmscan.h~vmscan-tracing-add-trace-events-for-lru-page-isolation include/trace/events/vmscan.h
--- a/include/trace/events/vmscan.h~vmscan-tracing-add-trace-events-for-lru-page-isolation
+++ a/include/trace/events/vmscan.h
@@ -109,6 +109,52 @@ TRACE_EVENT(mm_vmscan_direct_reclaim_end
 	TP_printk("nr_reclaimed=%lu", __entry->nr_reclaimed)
 );
 
+TRACE_EVENT(mm_vmscan_lru_isolate,
+
+	TP_PROTO(int order,
+		unsigned long nr_requested,
+		unsigned long nr_scanned,
+		unsigned long nr_taken,
+		unsigned long nr_lumpy_taken,
+		unsigned long nr_lumpy_dirty,
+		unsigned long nr_lumpy_failed,
+		int isolate_mode),
+
+	TP_ARGS(order, nr_requested, nr_scanned, nr_taken, nr_lumpy_taken, nr_lumpy_dirty, nr_lumpy_failed, isolate_mode),
+
+	TP_STRUCT__entry(
+		__field(int, order)
+		__field(unsigned long, nr_requested)
+		__field(unsigned long, nr_scanned)
+		__field(unsigned long, nr_taken)
+		__field(unsigned long, nr_lumpy_taken)
+		__field(unsigned long, nr_lumpy_dirty)
+		__field(unsigned long, nr_lumpy_failed)
+		__field(int, isolate_mode)
+	),
+
+	TP_fast_assign(
+		__entry->order = order;
+		__entry->nr_requested = nr_requested;
+		__entry->nr_scanned = nr_scanned;
+		__entry->nr_taken = nr_taken;
+		__entry->nr_lumpy_taken = nr_lumpy_taken;
+		__entry->nr_lumpy_dirty = nr_lumpy_dirty;
+		__entry->nr_lumpy_failed = nr_lumpy_failed;
+		__entry->isolate_mode = isolate_mode;
+	),
+
+	TP_printk("isolate_mode=%d order=%d nr_requested=%lu nr_scanned=%lu nr_taken=%lu contig_taken=%lu contig_dirty=%lu contig_failed=%lu",
+		__entry->isolate_mode,
+		__entry->order,
+		__entry->nr_requested,
+		__entry->nr_scanned,
+		__entry->nr_taken,
+		__entry->nr_lumpy_taken,
+		__entry->nr_lumpy_dirty,
+		__entry->nr_lumpy_failed)
+);
+
 #endif /* _TRACE_VMSCAN_H */
 
 /* This part must be outside protection */
diff -puN mm/vmscan.c~vmscan-tracing-add-trace-events-for-lru-page-isolation mm/vmscan.c
--- a/mm/vmscan.c~vmscan-tracing-add-trace-events-for-lru-page-isolation
+++ a/mm/vmscan.c
@@ -917,6 +917,7 @@ static unsigned long isolate_lru_pages(u
 		unsigned long *scanned, int order, int mode, int file)
 {
 	unsigned long nr_taken = 0;
+	unsigned long nr_lumpy_taken = 0, nr_lumpy_dirty = 0, nr_lumpy_failed = 0;
 	unsigned long scan;
 
 	for (scan = 0; scan < nr_to_scan && !list_empty(src); scan++) {
@@ -994,12 +995,25 @@ static unsigned long isolate_lru_pages(u
 				list_move(&cursor_page->lru, dst);
 				mem_cgroup_del_lru(cursor_page);
 				nr_taken++;
+				nr_lumpy_taken++;
+				if (PageDirty(cursor_page))
+					nr_lumpy_dirty++;
 				scan++;
+			} else {
+				if (mode == ISOLATE_BOTH &&
+						page_count(cursor_page))
+					nr_lumpy_failed++;
 			}
 		}
 	}
 
 	*scanned = scan;
+
+	trace_mm_vmscan_lru_isolate(order,
+			nr_to_scan, scan,
+			nr_taken,
+			nr_lumpy_taken, nr_lumpy_dirty, nr_lumpy_failed,
+			mode);
 	return nr_taken;
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

