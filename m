Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48E147A7C
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 18:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f0nS0HZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF5FC433C7;
	Wed, 20 Dec 2023 18:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703095990;
	bh=J3OUYQ4xNHdgcgzw1l/CyrGTZIY7bRp34eGKvs9f8T0=;
	h=Date:To:From:Subject:From;
	b=f0nS0HZDvKlDOqR2eUWLeqPGuN5OOrorOi8WdUNpfAyNSwlmHbIgrOVyszV9tL1QW
	 DpsQV7ESbDOZ4K4c396mlEZx8ppa36Ep98E7zKN70Pn4hfTjFCYfEY+IIay72FzCkC
	 xML9pYdrSFc2ANozR2Npa+M4QCOW58FY3zLmTxg0=
Date: Wed, 20 Dec 2023 10:13:09 -0800
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,cuibixuan@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmscan-add-new-event-to-trace-shrink-lru.patch removed from -mm tree
Message-Id: <20231220181310.4FF5FC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmscan: add new event to trace shrink lru
has been removed from the -mm tree.  Its filename was
     mm-vmscan-add-new-event-to-trace-shrink-lru.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Bixuan Cui <cuibixuan@vivo.com>
Subject: mm: vmscan: add new event to trace shrink lru
Date: Tue, 19 Dec 2023 17:21:23 -0800

Add a new event to calculate the
shrink_inactive_list()/shrink_active_list() execution time.

Example of output:
         kswapd0-103     [007] .....  1098.353020: mm_vmscan_lru_shrink_active_start: nid=0
         kswapd0-103     [007] .....  1098.353040: mm_vmscan_lru_shrink_active_end: nid=0 nr_taken=32 nr_active=0 nr_deactivated=32 nr_referenced=0 priority=6 flags=RECLAIM_WB_FILE|RECLAIM_WB_ASYNC
         kswapd0-103     [007] .....  1098.353040: mm_vmscan_lru_shrink_inactive_start: nid=0
         kswapd0-103     [007] .....  1098.353094: mm_vmscan_lru_shrink_inactive_end: nid=0 nr_scanned=32 nr_reclaimed=0 nr_dirty=0 nr_writeback=0 nr_congested=0 nr_immediate=0 nr_activate_anon=0 nr_activate_file=0 nr_ref_keep=32 nr_unmap_fail=0 priority=6 flags=RECLAIM_WB_ANON|RECLAIM_WB_ASYNC
         kswapd0-103     [007] .....  1098.353094: mm_vmscan_lru_shrink_inactive_start: nid=0
         kswapd0-103     [007] .....  1098.353162: mm_vmscan_lru_shrink_inactive_end: nid=0 nr_scanned=32 nr_reclaimed=21 nr_dirty=0 nr_writeback=0 nr_congested=0 nr_immediate=0 nr_activate_anon=0 nr_activate_file=0 nr_ref_keep=11 nr_unmap_fail=0 priority=6 flags=RECLAIM_WB_FILE|RECLAIM_WB_ASYNC

Link: https://lkml.kernel.org/r/20231220012123.2787-3-cuibixuan@vivo.com
Signed-off-by: Bixuan Cui <cuibixuan@vivo.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |   38 ++++++++++++++++++++++++++++++--
 mm/vmscan.c                   |   11 ++++++---
 2 files changed, 44 insertions(+), 5 deletions(-)

--- a/include/trace/events/vmscan.h~mm-vmscan-add-new-event-to-trace-shrink-lru
+++ a/include/trace/events/vmscan.h
@@ -395,7 +395,24 @@ TRACE_EVENT(mm_vmscan_write_folio,
 		show_reclaim_flags(__entry->reclaim_flags))
 );
 
-TRACE_EVENT(mm_vmscan_lru_shrink_inactive,
+TRACE_EVENT(mm_vmscan_lru_shrink_inactive_start,
+
+	TP_PROTO(int nid),
+
+	TP_ARGS(nid),
+
+	TP_STRUCT__entry(
+		__field(int, nid)
+	),
+
+	TP_fast_assign(
+		__entry->nid = nid;
+	),
+
+	TP_printk("nid=%d", __entry->nid)
+);
+
+TRACE_EVENT(mm_vmscan_lru_shrink_inactive_end,
 
 	TP_PROTO(int nid,
 		unsigned long nr_scanned, unsigned long nr_reclaimed,
@@ -446,7 +463,24 @@ TRACE_EVENT(mm_vmscan_lru_shrink_inactiv
 		show_reclaim_flags(__entry->reclaim_flags))
 );
 
-TRACE_EVENT(mm_vmscan_lru_shrink_active,
+TRACE_EVENT(mm_vmscan_lru_shrink_active_start,
+
+	TP_PROTO(int nid),
+
+	TP_ARGS(nid),
+
+	TP_STRUCT__entry(
+		__field(int, nid)
+	),
+
+	TP_fast_assign(
+		__entry->nid = nid;
+	),
+
+	TP_printk("nid=%d", __entry->nid)
+);
+
+TRACE_EVENT(mm_vmscan_lru_shrink_active_end,
 
 	TP_PROTO(int nid, unsigned long nr_taken,
 		unsigned long nr_active, unsigned long nr_deactivated,
--- a/mm/vmscan.c~mm-vmscan-add-new-event-to-trace-shrink-lru
+++ a/mm/vmscan.c
@@ -1882,6 +1882,8 @@ static unsigned long shrink_inactive_lis
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	bool stalled = false;
 
+	trace_mm_vmscan_lru_shrink_inactive_start(pgdat->node_id);
+
 	while (unlikely(too_many_isolated(pgdat, file, sc))) {
 		if (stalled)
 			return 0;
@@ -1966,7 +1968,7 @@ static unsigned long shrink_inactive_lis
 	if (file)
 		sc->nr.file_taken += nr_taken;
 
-	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
+	trace_mm_vmscan_lru_shrink_inactive_end(pgdat->node_id,
 			nr_scanned, nr_reclaimed, &stat, sc->priority, file);
 	return nr_reclaimed;
 }
@@ -2004,6 +2006,8 @@ static void shrink_active_list(unsigned
 	int file = is_file_lru(lru);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
+	trace_mm_vmscan_lru_shrink_active_start(pgdat->node_id);
+
 	lru_add_drain();
 
 	spin_lock_irq(&lruvec->lru_lock);
@@ -2083,7 +2087,7 @@ static void shrink_active_list(unsigned
 		lru_note_cost(lruvec, file, 0, nr_rotated);
 	mem_cgroup_uncharge_list(&l_active);
 	free_unref_page_list(&l_active);
-	trace_mm_vmscan_lru_shrink_active(pgdat->node_id, nr_taken, nr_activate,
+	trace_mm_vmscan_lru_shrink_active_end(pgdat->node_id, nr_taken, nr_activate,
 			nr_deactivate, nr_rotated, sc->priority, file);
 }
 
@@ -4500,9 +4504,10 @@ static int evict_folios(struct lruvec *l
 	if (list_empty(&list))
 		return scanned;
 retry:
+	trace_mm_vmscan_lru_shrink_inactive_start(pgdat->node_id);
 	reclaimed = shrink_folio_list(&list, pgdat, sc, &stat, false);
 	sc->nr_reclaimed += reclaimed;
-	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
+	trace_mm_vmscan_lru_shrink_inactive_end(pgdat->node_id,
 			scanned, reclaimed, &stat, sc->priority,
 			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
_

Patches currently in -mm which might be from cuibixuan@vivo.com are


