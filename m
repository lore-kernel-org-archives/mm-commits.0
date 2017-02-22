From: akpm@linux-foundation.org
Subject: [patch 045/142] oom, trace: add oom detection tracepoints
Date: Wed, 22 Feb 2017 15:42:00 -0800
Message-ID: <58ae21c8.oLbNyTja8Oc0OouQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48020 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934263AbdBVXmP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:42:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, hannes@cmpxchg.org, rientjes@google.com, vbabka@suse.cz

From: Michal Hocko <mhocko@suse.com>
Subject: oom, trace: add oom detection tracepoints

should_reclaim_retry is the central decision point for declaring the OOM. 
It might be really useful to expose data used for this decision making
when debugging an unexpected oom situations.

Say we have an OOM report:
[   52.264001] mem_eater invoked oom-killer: gfp_mask=0x24280ca(GFP_HIGHUSER_MOVABLE|__GFP_ZERO), nodemask=0, order=0, oom_score_adj=0
[   52.267549] CPU: 3 PID: 3148 Comm: mem_eater Tainted: G        W       4.8.0-oomtrace3-00006-gb21338b386d2 #1024

Now we can check the tracepoint data to see how we have ended up in this
situation:
       mem_eater-3148  [003] ....    52.432801: reclaim_retry_zone: node=0 zone=DMA32 order=0 reclaimable=51 available=11134 min_wmark=11084 no_progress_loops=1 wmark_check=1
       mem_eater-3148  [003] ....    52.433269: reclaim_retry_zone: node=0 zone=DMA32 order=0 reclaimable=51 available=11103 min_wmark=11084 no_progress_loops=1 wmark_check=1
       mem_eater-3148  [003] ....    52.433712: reclaim_retry_zone: node=0 zone=DMA32 order=0 reclaimable=51 available=11100 min_wmark=11084 no_progress_loops=2 wmark_check=1
       mem_eater-3148  [003] ....    52.434067: reclaim_retry_zone: node=0 zone=DMA32 order=0 reclaimable=51 available=11097 min_wmark=11084 no_progress_loops=3 wmark_check=1
       mem_eater-3148  [003] ....    52.434414: reclaim_retry_zone: node=0 zone=DMA32 order=0 reclaimable=51 available=11094 min_wmark=11084 no_progress_loops=4 wmark_check=1
       mem_eater-3148  [003] ....    52.434761: reclaim_retry_zone: node=0 zone=DMA32 order=0 reclaimable=51 available=11091 min_wmark=11084 no_progress_loops=5 wmark_check=1
       mem_eater-3148  [003] ....    52.435108: reclaim_retry_zone: node=0 zone=DMA32 order=0 reclaimable=51 available=11087 min_wmark=11084 no_progress_loops=6 wmark_check=1
       mem_eater-3148  [003] ....    52.435478: reclaim_retry_zone: node=0 zone=DMA32 order=0 reclaimable=51 available=11084 min_wmark=11084 no_progress_loops=7 wmark_check=0
       mem_eater-3148  [003] ....    52.435478: reclaim_retry_zone: node=0 zone=DMA order=0 reclaimable=0 available=1126 min_wmark=179 no_progress_loops=7 wmark_check=0

The above shows that we can quickly deduce that the reclaim stopped making
any progress (see no_progress_loops increased in each round) and while
there were still some 51 reclaimable pages they couldn't be dropped for
some reason (vmscan trace points would tell us more about that part). 
available will represent reclaimable + free_pages scaled down per
no_progress_loops factor.  This is essentially an optimistic estimate of
how much memory we would have when reclaiming everything.  This can be
compared to min_wmark to get a rought idea but the wmark_check tells the
result of the watermark check which is more precise (includes lowmem
reserves, considers the order etc.).  As we can see no zone is eligible in
the end and that is why we have triggered the oom in this situation.

Please note that higher order requests might fail on the wmark_check even
when there is much more memory available than min_wmark - e.g.  when the
memory is fragmented.  A follow up tracepoint will help to debug those
situations.

Link: http://lkml.kernel.org/r/20161220130135.15719-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/oom.h |   42 +++++++++++++++++++++++++++++++++++
 mm/page_alloc.c            |   10 ++++++--
 2 files changed, 50 insertions(+), 2 deletions(-)

diff -puN include/trace/events/oom.h~oom-trace-add-oom-detection-tracepoints include/trace/events/oom.h
--- a/include/trace/events/oom.h~oom-trace-add-oom-detection-tracepoints
+++ a/include/trace/events/oom.h
@@ -4,6 +4,7 @@
 #if !defined(_TRACE_OOM_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_OOM_H
 #include <linux/tracepoint.h>
+#include <trace/events/mmflags.h>
 
 TRACE_EVENT(oom_score_adj_update,
 
@@ -27,6 +28,47 @@ TRACE_EVENT(oom_score_adj_update,
 		__entry->pid, __entry->comm, __entry->oom_score_adj)
 );
 
+TRACE_EVENT(reclaim_retry_zone,
+
+	TP_PROTO(struct zoneref *zoneref,
+		int order,
+		unsigned long reclaimable,
+		unsigned long available,
+		unsigned long min_wmark,
+		int no_progress_loops,
+		bool wmark_check),
+
+	TP_ARGS(zoneref, order, reclaimable, available, min_wmark, no_progress_loops, wmark_check),
+
+	TP_STRUCT__entry(
+		__field(	int, node)
+		__field(	int, zone_idx)
+		__field(	int,	order)
+		__field(	unsigned long,	reclaimable)
+		__field(	unsigned long,	available)
+		__field(	unsigned long,	min_wmark)
+		__field(	int,	no_progress_loops)
+		__field(	bool,	wmark_check)
+	),
+
+	TP_fast_assign(
+		__entry->node = zone_to_nid(zoneref->zone);
+		__entry->zone_idx = zoneref->zone_idx;
+		__entry->order = order;
+		__entry->reclaimable = reclaimable;
+		__entry->available = available;
+		__entry->min_wmark = min_wmark;
+		__entry->no_progress_loops = no_progress_loops;
+		__entry->wmark_check = wmark_check;
+	),
+
+	TP_printk("node=%d zone=%-8s order=%d reclaimable=%lu available=%lu min_wmark=%lu no_progress_loops=%d wmark_check=%d",
+			__entry->node, __print_symbolic(__entry->zone_idx, ZONE_TYPE),
+			__entry->order,
+			__entry->reclaimable, __entry->available, __entry->min_wmark,
+			__entry->no_progress_loops,
+			__entry->wmark_check)
+);
 #endif
 
 /* This part must be outside protection */
diff -puN mm/page_alloc.c~oom-trace-add-oom-detection-tracepoints mm/page_alloc.c
--- a/mm/page_alloc.c~oom-trace-add-oom-detection-tracepoints
+++ a/mm/page_alloc.c
@@ -55,6 +55,7 @@
 #include <linux/kmemleak.h>
 #include <linux/compaction.h>
 #include <trace/events/kmem.h>
+#include <trace/events/oom.h>
 #include <linux/prefetch.h>
 #include <linux/mm_inline.h>
 #include <linux/migrate.h>
@@ -3468,6 +3469,8 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 					ac->nodemask) {
 		unsigned long available;
 		unsigned long reclaimable;
+		unsigned long min_wmark = min_wmark_pages(zone);
+		bool wmark;
 
 		available = reclaimable = zone_reclaimable_pages(zone);
 		available -= DIV_ROUND_UP((*no_progress_loops) * available,
@@ -3478,8 +3481,11 @@ should_reclaim_retry(gfp_t gfp_mask, uns
 		 * Would the allocation succeed if we reclaimed the whole
 		 * available?
 		 */
-		if (__zone_watermark_ok(zone, order, min_wmark_pages(zone),
-				ac_classzone_idx(ac), alloc_flags, available)) {
+		wmark = __zone_watermark_ok(zone, order, min_wmark,
+				ac_classzone_idx(ac), alloc_flags, available);
+		trace_reclaim_retry_zone(z, order, reclaimable,
+				available, min_wmark, *no_progress_loops, wmark);
+		if (wmark) {
 			/*
 			 * If we didn't make any progress and have a lot of
 			 * dirty + writeback pages then we should wait for
_
