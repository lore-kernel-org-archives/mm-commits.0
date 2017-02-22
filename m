From: akpm@linux-foundation.org
Subject: [patch 096/142] mm, vmscan: add mm_vmscan_inactive_list_is_low
 tracepoint
Date: Wed, 22 Feb 2017 15:44:33 -0800
Message-ID: <58ae2261.a1dUj1j41uiEuFA3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49076 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933134AbdBVXoe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:44:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, hillf.zj@alibaba-inc.com, mgorman@suse.de, vbabka@suse.cz

From: Michal Hocko <mhocko@suse.com>
Subject: mm, vmscan: add mm_vmscan_inactive_list_is_low tracepoint

Currently we have tracepoints for both active and inactive LRU lists
reclaim but we do not have any which would tell us why we we decided to
age the active list.  Without that it is quite hard to diagnose
active/inactive lists balancing.  Add mm_vmscan_inactive_list_is_low
tracepoint to tell us this information.

Link: http://lkml.kernel.org/r/20170104101942.4860-8-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |   40 ++++++++++++++++++++++++++++++++
 mm/vmscan.c                   |   23 +++++++++++-------
 2 files changed, 54 insertions(+), 9 deletions(-)

diff -puN include/trace/events/vmscan.h~mm-vmscan-add-mm_vmscan_inactive_list_is_low-tracepoint include/trace/events/vmscan.h
--- a/include/trace/events/vmscan.h~mm-vmscan-add-mm_vmscan_inactive_list_is_low-tracepoint
+++ a/include/trace/events/vmscan.h
@@ -15,6 +15,7 @@
 #define RECLAIM_WB_MIXED	0x0010u
 #define RECLAIM_WB_SYNC		0x0004u /* Unused, all reclaim async */
 #define RECLAIM_WB_ASYNC	0x0008u
+#define RECLAIM_WB_LRU		(RECLAIM_WB_ANON|RECLAIM_WB_FILE)
 
 #define show_reclaim_flags(flags)				\
 	(flags) ? __print_flags(flags, "|",			\
@@ -426,6 +427,45 @@ TRACE_EVENT(mm_vmscan_lru_shrink_active,
 		show_reclaim_flags(__entry->reclaim_flags))
 );
 
+TRACE_EVENT(mm_vmscan_inactive_list_is_low,
+
+	TP_PROTO(int nid, int reclaim_idx,
+		unsigned long total_inactive, unsigned long inactive,
+		unsigned long total_active, unsigned long active,
+		unsigned long ratio, int file),
+
+	TP_ARGS(nid, reclaim_idx, total_inactive, inactive, total_active, active, ratio, file),
+
+	TP_STRUCT__entry(
+		__field(int, nid)
+		__field(int, reclaim_idx)
+		__field(unsigned long, total_inactive)
+		__field(unsigned long, inactive)
+		__field(unsigned long, total_active)
+		__field(unsigned long, active)
+		__field(unsigned long, ratio)
+		__field(int, reclaim_flags)
+	),
+
+	TP_fast_assign(
+		__entry->nid = nid;
+		__entry->reclaim_idx = reclaim_idx;
+		__entry->total_inactive = total_inactive;
+		__entry->inactive = inactive;
+		__entry->total_active = total_active;
+		__entry->active = active;
+		__entry->ratio = ratio;
+		__entry->reclaim_flags = trace_shrink_flags(file) & RECLAIM_WB_LRU;
+	),
+
+	TP_printk("nid=%d reclaim_idx=%d total_inactive=%ld inactive=%ld total_active=%ld active=%ld ratio=%ld flags=%s",
+		__entry->nid,
+		__entry->reclaim_idx,
+		__entry->total_inactive, __entry->inactive,
+		__entry->total_active, __entry->active,
+		__entry->ratio,
+		show_reclaim_flags(__entry->reclaim_flags))
+);
 #endif /* _TRACE_VMSCAN_H */
 
 /* This part must be outside protection */
diff -puN mm/vmscan.c~mm-vmscan-add-mm_vmscan_inactive_list_is_low-tracepoint mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-add-mm_vmscan_inactive_list_is_low-tracepoint
+++ a/mm/vmscan.c
@@ -2048,11 +2048,11 @@ static void shrink_active_list(unsigned
  *   10TB     320        32GB
  */
 static bool inactive_list_is_low(struct lruvec *lruvec, bool file,
-						struct scan_control *sc)
+						struct scan_control *sc, bool trace)
 {
 	unsigned long inactive_ratio;
-	unsigned long inactive;
-	unsigned long active;
+	unsigned long total_inactive, inactive;
+	unsigned long total_active, active;
 	unsigned long gb;
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	int zid;
@@ -2064,8 +2064,8 @@ static bool inactive_list_is_low(struct
 	if (!file && !total_swap_pages)
 		return false;
 
-	inactive = lruvec_lru_size(lruvec, file * LRU_FILE);
-	active = lruvec_lru_size(lruvec, file * LRU_FILE + LRU_ACTIVE);
+	total_inactive = inactive = lruvec_lru_size(lruvec, file * LRU_FILE);
+	total_active = active = lruvec_lru_size(lruvec, file * LRU_FILE + LRU_ACTIVE);
 
 	/*
 	 * For zone-constrained allocations, it is necessary to check if
@@ -2092,6 +2092,11 @@ static bool inactive_list_is_low(struct
 	else
 		inactive_ratio = 1;
 
+	if (trace)
+		trace_mm_vmscan_inactive_list_is_low(pgdat->node_id,
+				sc->reclaim_idx,
+				total_inactive, inactive,
+				total_active, active, inactive_ratio, file);
 	return inactive * inactive_ratio < active;
 }
 
@@ -2099,7 +2104,7 @@ static unsigned long shrink_list(enum lr
 				 struct lruvec *lruvec, struct scan_control *sc)
 {
 	if (is_active_lru(lru)) {
-		if (inactive_list_is_low(lruvec, is_file_lru(lru), sc))
+		if (inactive_list_is_low(lruvec, is_file_lru(lru), sc, true))
 			shrink_active_list(nr_to_scan, lruvec, sc, lru);
 		return 0;
 	}
@@ -2230,7 +2235,7 @@ static void get_scan_count(struct lruvec
 	 * lruvec even if it has plenty of old anonymous pages unless the
 	 * system is under heavy pressure.
 	 */
-	if (!inactive_list_is_low(lruvec, true, sc) &&
+	if (!inactive_list_is_low(lruvec, true, sc, false) &&
 	    lruvec_lru_size(lruvec, LRU_INACTIVE_FILE) >> sc->priority) {
 		scan_balance = SCAN_FILE;
 		goto out;
@@ -2455,7 +2460,7 @@ static void shrink_node_memcg(struct pgl
 	 * Even if we did not try to evict anon pages at all, we want to
 	 * rebalance the anon lru active/inactive ratio.
 	 */
-	if (inactive_list_is_low(lruvec, false, sc))
+	if (inactive_list_is_low(lruvec, false, sc, true))
 		shrink_active_list(SWAP_CLUSTER_MAX, lruvec,
 				   sc, LRU_ACTIVE_ANON);
 }
@@ -3105,7 +3110,7 @@ static void age_active_anon(struct pglis
 	do {
 		struct lruvec *lruvec = mem_cgroup_lruvec(pgdat, memcg);
 
-		if (inactive_list_is_low(lruvec, false, sc))
+		if (inactive_list_is_low(lruvec, false, sc, true))
 			shrink_active_list(SWAP_CLUSTER_MAX, lruvec,
 					   sc, LRU_ACTIVE_ANON);
 
_
