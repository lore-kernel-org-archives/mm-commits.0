From: akpm@linux-foundation.org
Subject: + vmscan-tracing-add-trace-events-for-kswapd-wakeup-sleeping-and-direct-reclaim.patch added to -mm tree
Date: Fri, 02 Jul 2010 12:52:45 -0700
Message-ID: <201007021952.o62JqkQE023640@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757432Ab0GBTxo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jul 2010 15:53:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, aarcange@redhat.com, chris.mason@oracle.com, david@fromorbit.com, hannes@cmpxchg.org, hch@infradead.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com, mrubin@google.com, npiggin@suse.de, riel@redhat.com


The patch titled
     vmscan: tracing: add trace events for kswapd wakeup, sleeping and direct reclaim
has been added to the -mm tree.  Its filename is
     vmscan-tracing-add-trace-events-for-kswapd-wakeup-sleeping-and-direct-reclaim.patch

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
Subject: vmscan: tracing: add trace events for kswapd wakeup, sleeping and direct reclaim
From: Mel Gorman <mel@csn.ul.ie>

Add two trace events for kswapd waking up and going asleep for the
purposes of tracking kswapd activity and two trace events for direct
reclaim beginning and ending.  The information can be used to work out how
much time a process or the system is spending on the reclamation of pages
and in the case of direct reclaim, how many pages were reclaimed for that
process.  High frequency triggering of these events could point to memory
pressure problems.

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

 include/trace/events/gfpflags.h |   37 +++++++++
 include/trace/events/kmem.h     |   38 ---------
 include/trace/events/vmscan.h   |  115 ++++++++++++++++++++++++++++++
 mm/vmscan.c                     |   24 +++++-
 4 files changed, 173 insertions(+), 41 deletions(-)

diff -puN /dev/null include/trace/events/gfpflags.h
--- /dev/null
+++ a/include/trace/events/gfpflags.h
@@ -0,0 +1,37 @@
+/*
+ * The order of these masks is important. Matching masks will be seen
+ * first and the left over flags will end up showing by themselves.
+ *
+ * For example, if we have GFP_KERNEL before GFP_USER we wil get:
+ *
+ *  GFP_KERNEL|GFP_HARDWALL
+ *
+ * Thus most bits set go first.
+ */
+#define show_gfp_flags(flags)						\
+	(flags) ? __print_flags(flags, "|",				\
+	{(unsigned long)GFP_HIGHUSER_MOVABLE,	"GFP_HIGHUSER_MOVABLE"}, \
+	{(unsigned long)GFP_HIGHUSER,		"GFP_HIGHUSER"},	\
+	{(unsigned long)GFP_USER,		"GFP_USER"},		\
+	{(unsigned long)GFP_TEMPORARY,		"GFP_TEMPORARY"},	\
+	{(unsigned long)GFP_KERNEL,		"GFP_KERNEL"},		\
+	{(unsigned long)GFP_NOFS,		"GFP_NOFS"},		\
+	{(unsigned long)GFP_ATOMIC,		"GFP_ATOMIC"},		\
+	{(unsigned long)GFP_NOIO,		"GFP_NOIO"},		\
+	{(unsigned long)__GFP_HIGH,		"GFP_HIGH"},		\
+	{(unsigned long)__GFP_WAIT,		"GFP_WAIT"},		\
+	{(unsigned long)__GFP_IO,		"GFP_IO"},		\
+	{(unsigned long)__GFP_COLD,		"GFP_COLD"},		\
+	{(unsigned long)__GFP_NOWARN,		"GFP_NOWARN"},		\
+	{(unsigned long)__GFP_REPEAT,		"GFP_REPEAT"},		\
+	{(unsigned long)__GFP_NOFAIL,		"GFP_NOFAIL"},		\
+	{(unsigned long)__GFP_NORETRY,		"GFP_NORETRY"},		\
+	{(unsigned long)__GFP_COMP,		"GFP_COMP"},		\
+	{(unsigned long)__GFP_ZERO,		"GFP_ZERO"},		\
+	{(unsigned long)__GFP_NOMEMALLOC,	"GFP_NOMEMALLOC"},	\
+	{(unsigned long)__GFP_HARDWALL,		"GFP_HARDWALL"},	\
+	{(unsigned long)__GFP_THISNODE,		"GFP_THISNODE"},	\
+	{(unsigned long)__GFP_RECLAIMABLE,	"GFP_RECLAIMABLE"},	\
+	{(unsigned long)__GFP_MOVABLE,		"GFP_MOVABLE"}		\
+	) : "GFP_NOWAIT"
+
diff -puN include/trace/events/kmem.h~vmscan-tracing-add-trace-events-for-kswapd-wakeup-sleeping-and-direct-reclaim include/trace/events/kmem.h
--- a/include/trace/events/kmem.h~vmscan-tracing-add-trace-events-for-kswapd-wakeup-sleeping-and-direct-reclaim
+++ a/include/trace/events/kmem.h
@@ -6,43 +6,7 @@
 
 #include <linux/types.h>
 #include <linux/tracepoint.h>
-
-/*
- * The order of these masks is important. Matching masks will be seen
- * first and the left over flags will end up showing by themselves.
- *
- * For example, if we have GFP_KERNEL before GFP_USER we wil get:
- *
- *  GFP_KERNEL|GFP_HARDWALL
- *
- * Thus most bits set go first.
- */
-#define show_gfp_flags(flags)						\
-	(flags) ? __print_flags(flags, "|",				\
-	{(unsigned long)GFP_HIGHUSER_MOVABLE,	"GFP_HIGHUSER_MOVABLE"}, \
-	{(unsigned long)GFP_HIGHUSER,		"GFP_HIGHUSER"},	\
-	{(unsigned long)GFP_USER,		"GFP_USER"},		\
-	{(unsigned long)GFP_TEMPORARY,		"GFP_TEMPORARY"},	\
-	{(unsigned long)GFP_KERNEL,		"GFP_KERNEL"},		\
-	{(unsigned long)GFP_NOFS,		"GFP_NOFS"},		\
-	{(unsigned long)GFP_ATOMIC,		"GFP_ATOMIC"},		\
-	{(unsigned long)GFP_NOIO,		"GFP_NOIO"},		\
-	{(unsigned long)__GFP_HIGH,		"GFP_HIGH"},		\
-	{(unsigned long)__GFP_WAIT,		"GFP_WAIT"},		\
-	{(unsigned long)__GFP_IO,		"GFP_IO"},		\
-	{(unsigned long)__GFP_COLD,		"GFP_COLD"},		\
-	{(unsigned long)__GFP_NOWARN,		"GFP_NOWARN"},		\
-	{(unsigned long)__GFP_REPEAT,		"GFP_REPEAT"},		\
-	{(unsigned long)__GFP_NOFAIL,		"GFP_NOFAIL"},		\
-	{(unsigned long)__GFP_NORETRY,		"GFP_NORETRY"},		\
-	{(unsigned long)__GFP_COMP,		"GFP_COMP"},		\
-	{(unsigned long)__GFP_ZERO,		"GFP_ZERO"},		\
-	{(unsigned long)__GFP_NOMEMALLOC,	"GFP_NOMEMALLOC"},	\
-	{(unsigned long)__GFP_HARDWALL,		"GFP_HARDWALL"},	\
-	{(unsigned long)__GFP_THISNODE,		"GFP_THISNODE"},	\
-	{(unsigned long)__GFP_RECLAIMABLE,	"GFP_RECLAIMABLE"},	\
-	{(unsigned long)__GFP_MOVABLE,		"GFP_MOVABLE"}		\
-	) : "GFP_NOWAIT"
+#include "gfpflags.h"
 
 DECLARE_EVENT_CLASS(kmem_alloc,
 
diff -puN /dev/null include/trace/events/vmscan.h
--- /dev/null
+++ a/include/trace/events/vmscan.h
@@ -0,0 +1,115 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM vmscan
+
+#if !defined(_TRACE_VMSCAN_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_VMSCAN_H
+
+#include <linux/types.h>
+#include <linux/tracepoint.h>
+#include "gfpflags.h"
+
+TRACE_EVENT(mm_vmscan_kswapd_sleep,
+
+	TP_PROTO(int nid),
+
+	TP_ARGS(nid),
+
+	TP_STRUCT__entry(
+		__field(	int,	nid	)
+	),
+
+	TP_fast_assign(
+		__entry->nid	= nid;
+	),
+
+	TP_printk("nid=%d", __entry->nid)
+);
+
+TRACE_EVENT(mm_vmscan_kswapd_wake,
+
+	TP_PROTO(int nid, int order),
+
+	TP_ARGS(nid, order),
+
+	TP_STRUCT__entry(
+		__field(	int,	nid	)
+		__field(	int,	order	)
+	),
+
+	TP_fast_assign(
+		__entry->nid	= nid;
+		__entry->order	= order;
+	),
+
+	TP_printk("nid=%d order=%d", __entry->nid, __entry->order)
+);
+
+TRACE_EVENT(mm_vmscan_wakeup_kswapd,
+
+	TP_PROTO(int nid, int zid, int order),
+
+	TP_ARGS(nid, zid, order),
+
+	TP_STRUCT__entry(
+		__field(	int,		nid	)
+		__field(	int,		zid	)
+		__field(	int,		order	)
+	),
+
+	TP_fast_assign(
+		__entry->nid		= nid;
+		__entry->zid		= zid;
+		__entry->order		= order;
+	),
+
+	TP_printk("nid=%d zid=%d order=%d",
+		__entry->nid,
+		__entry->zid,
+		__entry->order)
+);
+
+TRACE_EVENT(mm_vmscan_direct_reclaim_begin,
+
+	TP_PROTO(int order, int may_writepage, gfp_t gfp_flags),
+
+	TP_ARGS(order, may_writepage, gfp_flags),
+
+	TP_STRUCT__entry(
+		__field(	int,	order		)
+		__field(	int,	may_writepage	)
+		__field(	gfp_t,	gfp_flags	)
+	),
+
+	TP_fast_assign(
+		__entry->order		= order;
+		__entry->may_writepage	= may_writepage;
+		__entry->gfp_flags	= gfp_flags;
+	),
+
+	TP_printk("order=%d may_writepage=%d gfp_flags=%s",
+		__entry->order,
+		__entry->may_writepage,
+		show_gfp_flags(__entry->gfp_flags))
+);
+
+TRACE_EVENT(mm_vmscan_direct_reclaim_end,
+
+	TP_PROTO(unsigned long nr_reclaimed),
+
+	TP_ARGS(nr_reclaimed),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	nr_reclaimed	)
+	),
+
+	TP_fast_assign(
+		__entry->nr_reclaimed	= nr_reclaimed;
+	),
+
+	TP_printk("nr_reclaimed=%lu", __entry->nr_reclaimed)
+);
+
+#endif /* _TRACE_VMSCAN_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff -puN mm/vmscan.c~vmscan-tracing-add-trace-events-for-kswapd-wakeup-sleeping-and-direct-reclaim mm/vmscan.c
--- a/mm/vmscan.c~vmscan-tracing-add-trace-events-for-kswapd-wakeup-sleeping-and-direct-reclaim
+++ a/mm/vmscan.c
@@ -48,6 +48,9 @@
 
 #include "internal.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/vmscan.h>
+
 struct scan_control {
 	/* Incremented by the number of inactive pages that were scanned */
 	unsigned long nr_scanned;
@@ -1881,6 +1884,7 @@ out:
 unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 				gfp_t gfp_mask, nodemask_t *nodemask)
 {
+	unsigned long nr_reclaimed;
 	struct scan_control sc = {
 		.gfp_mask = gfp_mask,
 		.may_writepage = !laptop_mode,
@@ -1893,7 +1897,15 @@ unsigned long try_to_free_pages(struct z
 		.nodemask = nodemask,
 	};
 
-	return do_try_to_free_pages(zonelist, &sc);
+	trace_mm_vmscan_direct_reclaim_begin(order,
+				sc.may_writepage,
+				gfp_mask);
+
+	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
+
+	trace_mm_vmscan_direct_reclaim_end(nr_reclaimed);
+
+	return nr_reclaimed;
 }
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
@@ -2292,9 +2304,10 @@ static int kswapd(void *p)
 				 * premature sleep. If not, then go fully
 				 * to sleep until explicitly woken up
 				 */
-				if (!sleeping_prematurely(pgdat, order, remaining))
+				if (!sleeping_prematurely(pgdat, order, remaining)) {
+					trace_mm_vmscan_kswapd_sleep(pgdat->node_id);
 					schedule();
-				else {
+				} else {
 					if (remaining)
 						count_vm_event(KSWAPD_LOW_WMARK_HIT_QUICKLY);
 					else
@@ -2314,8 +2327,10 @@ static int kswapd(void *p)
 		 * We can speed up thawing tasks if we don't call balance_pgdat
 		 * after returning from the refrigerator
 		 */
-		if (!ret)
+		if (!ret) {
+			trace_mm_vmscan_kswapd_wake(pgdat->node_id, order);
 			balance_pgdat(pgdat, order);
+		}
 	}
 	return 0;
 }
@@ -2335,6 +2350,7 @@ void wakeup_kswapd(struct zone *zone, in
 		return;
 	if (pgdat->kswapd_max_order < order)
 		pgdat->kswapd_max_order = order;
+	trace_mm_vmscan_wakeup_kswapd(pgdat->node_id, zone_idx(zone), order);
 	if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
 		return;
 	if (!waitqueue_active(&pgdat->kswapd_wait))
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

