From: akpm@linux-foundation.org
Subject: [merged]
 mm-change-mm_vmscan_lru_shrink_inactive-proto-types.patch removed from -mm
 tree
Date: Fri, 15 Jan 2016 14:32:48 -0800
Message-ID: <56997390.l6dmDAv6WxScGXgQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59262 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbcAOWct (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:32:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yalin.wang2010@gmail.com, rostedt@goodmis.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: change mm_vmscan_lru_shrink_inactive() proto types
has been removed from the -mm tree.  Its filename was
     mm-change-mm_vmscan_lru_shrink_inactive-proto-types.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: yalin wang <yalin.wang2010@gmail.com>
Subject: mm: change mm_vmscan_lru_shrink_inactive() proto types

Move node_id zone_idx shrink flags into trace function, so thay we don't
need caculate these args if the trace is disabled, and will make this
function have less arguments.

Signed-off-by: yalin wang <yalin.wang2010@gmail.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |   14 +++++++-------
 mm/vmscan.c                   |    7 ++-----
 2 files changed, 9 insertions(+), 12 deletions(-)

diff -puN include/trace/events/vmscan.h~mm-change-mm_vmscan_lru_shrink_inactive-proto-types include/trace/events/vmscan.h
--- a/include/trace/events/vmscan.h~mm-change-mm_vmscan_lru_shrink_inactive-proto-types
+++ a/include/trace/events/vmscan.h
@@ -352,11 +352,11 @@ TRACE_EVENT(mm_vmscan_writepage,
 
 TRACE_EVENT(mm_vmscan_lru_shrink_inactive,
 
-	TP_PROTO(int nid, int zid,
-			unsigned long nr_scanned, unsigned long nr_reclaimed,
-			int priority, int reclaim_flags),
+	TP_PROTO(struct zone *zone,
+		unsigned long nr_scanned, unsigned long nr_reclaimed,
+		int priority, int file),
 
-	TP_ARGS(nid, zid, nr_scanned, nr_reclaimed, priority, reclaim_flags),
+	TP_ARGS(zone, nr_scanned, nr_reclaimed, priority, file),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
@@ -368,12 +368,12 @@ TRACE_EVENT(mm_vmscan_lru_shrink_inactiv
 	),
 
 	TP_fast_assign(
-		__entry->nid = nid;
-		__entry->zid = zid;
+		__entry->nid = zone_to_nid(zone);
+		__entry->zid = zone_idx(zone);
 		__entry->nr_scanned = nr_scanned;
 		__entry->nr_reclaimed = nr_reclaimed;
 		__entry->priority = priority;
-		__entry->reclaim_flags = reclaim_flags;
+		__entry->reclaim_flags = trace_shrink_flags(file);
 	),
 
 	TP_printk("nid=%d zid=%d nr_scanned=%ld nr_reclaimed=%ld priority=%d flags=%s",
diff -puN mm/vmscan.c~mm-change-mm_vmscan_lru_shrink_inactive-proto-types mm/vmscan.c
--- a/mm/vmscan.c~mm-change-mm_vmscan_lru_shrink_inactive-proto-types
+++ a/mm/vmscan.c
@@ -1691,11 +1691,8 @@ shrink_inactive_list(unsigned long nr_to
 	    current_may_throttle())
 		wait_iff_congested(zone, BLK_RW_ASYNC, HZ/10);
 
-	trace_mm_vmscan_lru_shrink_inactive(zone->zone_pgdat->node_id,
-		zone_idx(zone),
-		nr_scanned, nr_reclaimed,
-		sc->priority,
-		trace_shrink_flags(file));
+	trace_mm_vmscan_lru_shrink_inactive(zone, nr_scanned, nr_reclaimed,
+			sc->priority, file);
 	return nr_reclaimed;
 }
 
_

Patches currently in -mm which might be from yalin.wang2010@gmail.com are

mm-fix-kernel-crash-in-khugepaged-thread.patch

