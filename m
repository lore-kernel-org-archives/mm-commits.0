Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939D42F8E82
	for <mm-commits@vger.kernel.org>; Fri,  8 May 2026 23:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778283938; cv=none; b=s7W4OaNN0M2v/r3owlj/L5wJgJOpQm9+YaAupC2sjMJtJBhzmMhmCKWPneyQzFMAZYOYouMl84aHpCoeQXjqJw2seivFDXUvoc7SidM4AWITU/ZXUBY7hic8c3PD/NTWVuGuqM0ChZPDtT812DE10O7lZnLWjj/PQYHZrp0UBgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778283938; c=relaxed/simple;
	bh=3ZbX9CGnHm64R9xgj+3lOWwHROQtQ9m0wn+8xLQd7M4=;
	h=Date:To:From:Subject:Message-Id; b=OHsBWqkBRKup2mbmWmKMlOQbx5QfQezpKEGDF4PoTfm2yRs9puNzbpTfn2lWraVdQUNgZ0VIpF9MCZe7JMIHBnW8r+UNin+mf7pS8mV5XZtifJHAGhKoWMC+aqhps+0C3i71v6ynH6MgfQjW8etMN/dj6v+X911jjFPEwmJPXX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EmKDqdGi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EmKDqdGi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B64BC2BCB0;
	Fri,  8 May 2026 23:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778283938;
	bh=3ZbX9CGnHm64R9xgj+3lOWwHROQtQ9m0wn+8xLQd7M4=;
	h=Date:To:From:Subject:From;
	b=EmKDqdGibCQut+E69OLbcl5zwt8mDrrkAsra8X2s9L9rJlqEDUDHtBpiVD6nBF4Cb
	 DEk2ciFdZ3Tlcr+y5UQJmt157LS3iFyPKHMxo7//6slltPMs29sIfcvJGox2+S5cuW
	 chFqjBP3+TGIxnot2fV5Mm9c6dkdaoGGsBpKnFks=
Date: Fri, 08 May 2026 16:45:37 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,willy@infradead.org,weixugc@google.com,shakeel.butt@linux.dev,rostedt@goodmis.org,qiwu.chen@transsion.com,mhocko@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,qiwuchen55@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-rework-lru_shrink-and-write_folio-tracepoints.patch added to mm-new branch
Message-Id: <20260508234538.1B64BC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: rework lru_shrink and write_folio tracepoints
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-rework-lru_shrink-and-write_folio-tracepoints.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-rework-lru_shrink-and-write_folio-tracepoints.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "qiwu.chen" <qiwuchen55@gmail.com>
Subject: mm: vmscan: rework lru_shrink and write_folio tracepoints
Date: Wed, 6 May 2026 16:36:52 +0800

Currently, reclaim_flags always contains RECLAIM_WB_ASYNC in lru_shrink
tracepoints since commit 41ac1999c3e35 ("mm: vmscan: do not stall on
writeback during memory compaction"), which is useless for debugging
memory pressure issues.  Other RECLAIM_WB_* flags are not used anywhere
else, so they can be directly removed.

This patch reworks the lru_shrink and write_folio tracepoints for better
correlation and analysis:

 - traces each folio lru type instead of reclaim_flags.
 - traces each lru_shrink with reason.
 - remove the printing of the unnecessary PFN for mm_vmscan_write_folio.

Link: https://lore.kernel.org/20260506083652.100160-1-qiwu.chen@transsion.com
Fixes: 41ac1999c3e35 ("mm: vmscan: do not stall on writeback during memory compaction")
Signed-off-by: qiwu.chen <qiwu.chen@transsion.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: chenqiwu <qiwu.chen@transsion.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |   71 +++++++++++++-------------------
 mm/vmscan.c                   |    9 ++--
 2 files changed, 35 insertions(+), 45 deletions(-)

--- a/include/trace/events/vmscan.h~mm-vmscan-rework-lru_shrink-and-write_folio-tracepoints
+++ a/include/trace/events/vmscan.h
@@ -11,22 +11,6 @@
 #include <linux/memcontrol.h>
 #include <trace/events/mmflags.h>
 
-#define RECLAIM_WB_ANON		0x0001u
-#define RECLAIM_WB_FILE		0x0002u
-#define RECLAIM_WB_MIXED	0x0010u
-#define RECLAIM_WB_SYNC		0x0004u /* Unused, all reclaim async */
-#define RECLAIM_WB_ASYNC	0x0008u
-#define RECLAIM_WB_LRU		(RECLAIM_WB_ANON|RECLAIM_WB_FILE)
-
-#define show_reclaim_flags(flags)				\
-	(flags) ? __print_flags(flags, "|",			\
-		{RECLAIM_WB_ANON,	"RECLAIM_WB_ANON"},	\
-		{RECLAIM_WB_FILE,	"RECLAIM_WB_FILE"},	\
-		{RECLAIM_WB_MIXED,	"RECLAIM_WB_MIXED"},	\
-		{RECLAIM_WB_SYNC,	"RECLAIM_WB_SYNC"},	\
-		{RECLAIM_WB_ASYNC,	"RECLAIM_WB_ASYNC"}	\
-		) : "RECLAIM_WB_NONE"
-
 #define _VMSCAN_THROTTLE_WRITEBACK	(1 << VMSCAN_THROTTLE_WRITEBACK)
 #define _VMSCAN_THROTTLE_ISOLATED	(1 << VMSCAN_THROTTLE_ISOLATED)
 #define _VMSCAN_THROTTLE_NOPROGRESS	(1 << VMSCAN_THROTTLE_NOPROGRESS)
@@ -51,10 +35,11 @@ TRACE_DEFINE_ENUM(KSWAPD_CLEAR_HOPELESS_
 	{KSWAPD_CLEAR_HOPELESS_PCP,	"PCP"},		\
 	{KSWAPD_CLEAR_HOPELESS_OTHER,	"OTHER"}
 
-#define trace_reclaim_flags(file) ( \
-	(file ? RECLAIM_WB_FILE : RECLAIM_WB_ANON) | \
-	(RECLAIM_WB_ASYNC) \
-	)
+#define trace_reclaim_reason_ops		\
+	{PGSTEAL_KSWAPD,	"KSWAPD"},	\
+	{PGSTEAL_DIRECT,	"DIRECT"},	\
+	{PGSTEAL_KHUGEPAGED,	"KHUGEPAGED"}, \
+	{PGSTEAL_PROACTIVE,	"PROACTIVE"}
 
 TRACE_EVENT(mm_vmscan_kswapd_sleep,
 
@@ -413,20 +398,18 @@ TRACE_EVENT(mm_vmscan_write_folio,
 	TP_ARGS(folio),
 
 	TP_STRUCT__entry(
-		__field(unsigned long, pfn)
-		__field(int, reclaim_flags)
+		__field(unsigned long, folio)
+		__field(int, lru)
 	),
 
 	TP_fast_assign(
-		__entry->pfn = folio_pfn(folio);
-		__entry->reclaim_flags = trace_reclaim_flags(
-						folio_is_file_lru(folio));
+		__entry->folio = folio;
+		__entry->lru = folio_lru_list(folio);
 	),
 
-	TP_printk("page=%p pfn=0x%lx flags=%s",
-		pfn_to_page(__entry->pfn),
-		__entry->pfn,
-		show_reclaim_flags(__entry->reclaim_flags))
+	TP_printk("folio=%p lru=%s",
+		__entry->folio,
+		__print_symbolic(__entry->lru, LRU_NAMES))
 );
 
 TRACE_EVENT(mm_vmscan_reclaim_pages,
@@ -478,9 +461,9 @@ TRACE_EVENT(mm_vmscan_lru_shrink_inactiv
 
 	TP_PROTO(int nid,
 		unsigned long nr_scanned, unsigned long nr_reclaimed,
-		struct reclaim_stat *stat, int priority, int file),
+		struct reclaim_stat *stat, int priority, int lru, int reason),
 
-	TP_ARGS(nid, nr_scanned, nr_reclaimed, stat, priority, file),
+	TP_ARGS(nid, nr_scanned, nr_reclaimed, stat, priority, lru, reason),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
@@ -495,7 +478,8 @@ TRACE_EVENT(mm_vmscan_lru_shrink_inactiv
 		__field(unsigned long, nr_ref_keep)
 		__field(unsigned long, nr_unmap_fail)
 		__field(int, priority)
-		__field(int, reclaim_flags)
+		__field(int, lru)
+		__field(int, reason)
 	),
 
 	TP_fast_assign(
@@ -511,10 +495,11 @@ TRACE_EVENT(mm_vmscan_lru_shrink_inactiv
 		__entry->nr_ref_keep = stat->nr_ref_keep;
 		__entry->nr_unmap_fail = stat->nr_unmap_fail;
 		__entry->priority = priority;
-		__entry->reclaim_flags = trace_reclaim_flags(file);
+		__entry->lru = lru;
+		__entry->reason = reason;
 	),
 
-	TP_printk("nid=%d nr_scanned=%ld nr_reclaimed=%ld nr_dirty=%ld nr_writeback=%ld nr_congested=%ld nr_immediate=%ld nr_activate_anon=%d nr_activate_file=%d nr_ref_keep=%ld nr_unmap_fail=%ld priority=%d flags=%s",
+	TP_printk("nid=%d nr_scanned=%ld nr_reclaimed=%ld nr_dirty=%ld nr_writeback=%ld nr_congested=%ld nr_immediate=%ld nr_activate_anon=%d nr_activate_file=%d nr_ref_keep=%ld nr_unmap_fail=%ld priority=%d lru=%s reason=%s",
 		__entry->nid,
 		__entry->nr_scanned, __entry->nr_reclaimed,
 		__entry->nr_dirty, __entry->nr_writeback,
@@ -522,16 +507,17 @@ TRACE_EVENT(mm_vmscan_lru_shrink_inactiv
 		__entry->nr_activate0, __entry->nr_activate1,
 		__entry->nr_ref_keep, __entry->nr_unmap_fail,
 		__entry->priority,
-		show_reclaim_flags(__entry->reclaim_flags))
+		__print_symbolic(__entry->lru, LRU_NAMES),
+		__print_symbolic(__entry->reason, trace_reclaim_reason_ops))
 );
 
 TRACE_EVENT(mm_vmscan_lru_shrink_active,
 
 	TP_PROTO(int nid, unsigned long nr_taken,
 		unsigned long nr_active, unsigned long nr_deactivated,
-		unsigned long nr_referenced, int priority, int file),
+		unsigned long nr_referenced, int priority, int lru, int reason),
 
-	TP_ARGS(nid, nr_taken, nr_active, nr_deactivated, nr_referenced, priority, file),
+	TP_ARGS(nid, nr_taken, nr_active, nr_deactivated, nr_referenced, priority, lru, reason),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
@@ -540,7 +526,8 @@ TRACE_EVENT(mm_vmscan_lru_shrink_active,
 		__field(unsigned long, nr_deactivated)
 		__field(unsigned long, nr_referenced)
 		__field(int, priority)
-		__field(int, reclaim_flags)
+		__field(int, lru)
+		__field(int, reason)
 	),
 
 	TP_fast_assign(
@@ -550,15 +537,17 @@ TRACE_EVENT(mm_vmscan_lru_shrink_active,
 		__entry->nr_deactivated = nr_deactivated;
 		__entry->nr_referenced = nr_referenced;
 		__entry->priority = priority;
-		__entry->reclaim_flags = trace_reclaim_flags(file);
+		__entry->lru = lru;
+		__entry->reason = reason;
 	),
 
-	TP_printk("nid=%d nr_taken=%ld nr_active=%ld nr_deactivated=%ld nr_referenced=%ld priority=%d flags=%s",
+	TP_printk("nid=%d nr_taken=%ld nr_active=%ld nr_deactivated=%ld nr_referenced=%ld priority=%d lru=%s reason=%s",
 		__entry->nid,
 		__entry->nr_taken,
 		__entry->nr_active, __entry->nr_deactivated, __entry->nr_referenced,
 		__entry->priority,
-		show_reclaim_flags(__entry->reclaim_flags))
+		__print_symbolic(__entry->lru, LRU_NAMES),
+		__print_symbolic(__entry->reason, trace_reclaim_reason_ops))
 );
 
 TRACE_EVENT(mm_vmscan_node_reclaim_begin,
--- a/mm/vmscan.c~mm-vmscan-rework-lru_shrink-and-write_folio-tracepoints
+++ a/mm/vmscan.c
@@ -2045,7 +2045,7 @@ static unsigned long shrink_inactive_lis
 					nr_scanned - nr_reclaimed);
 	handle_reclaim_writeback(nr_taken, pgdat, sc, &stat);
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
-			nr_scanned, nr_reclaimed, &stat, sc->priority, file);
+			nr_scanned, nr_reclaimed, &stat, sc->priority, lru, item);
 	return nr_reclaimed;
 }
 
@@ -2152,7 +2152,8 @@ static void shrink_active_list(unsigned
 	lruvec_lock_irq(lruvec);
 	lru_note_cost_unlock_irq(lruvec, file, 0, nr_rotated);
 	trace_mm_vmscan_lru_shrink_active(pgdat->node_id, nr_taken, nr_activate,
-			nr_deactivate, nr_rotated, sc->priority, file);
+			nr_deactivate, nr_rotated, sc->priority, lru,
+			PGSTEAL_KSWAPD + reclaimer_offset(sc));
 }
 
 static unsigned int reclaim_folio_list(struct list_head *folio_list,
@@ -4838,9 +4839,10 @@ retry:
 	/* Retry pass is only meant for clean folios without new isolation */
 	if (isolated)
 		handle_reclaim_writeback(isolated, pgdat, sc, &stat);
+	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
 			type_scanned, reclaimed, &stat, sc->priority,
-			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
+			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON, item);
 
 	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
 		DEFINE_MIN_SEQ(lruvec);
@@ -4876,7 +4878,6 @@ retry:
 	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
 					stat.nr_demoted);
 
-	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
 	mod_lruvec_state(lruvec, item, reclaimed);
 	mod_lruvec_state(lruvec, PGSTEAL_ANON + type, reclaimed);
 
_

Patches currently in -mm which might be from qiwuchen55@gmail.com are

mm-vmscan-rework-lru_shrink-and-write_folio-tracepoints.patch

