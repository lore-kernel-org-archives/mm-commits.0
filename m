Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DE931A7F7
	for <mm-commits@vger.kernel.org>; Thu, 15 Jan 2026 23:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768520379; cv=none; b=jAaBRefNnrh2rXzE1mR3Bi/AfR7VhA2s9gyeNflUrSfXK5MULXKkKgwsvqxThfsFfdpQV9Y1yx8xbxXdubd+hKH2/Wx/97lvR8/hJXGGw6zjJB590uK3wPQJ5IPfNJdlLENeAu9yypW8dXMCX3ro8TK3OyM53NDZUTJzudKJxEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768520379; c=relaxed/simple;
	bh=NknLNuJTkiWoT3qFbvFFL3oYixgE2NoDa3NBqUAUOvI=;
	h=Date:To:From:Subject:Message-Id; b=PKjzWU03WvBmVUay7LCm2ydXjg9Rb7Yhhd3TXQiD/76s9fwGrefZblJtmPcFIZenELzcbUtoyrFHVPU0jL5oXLJDYDz/J7SAB/sZw4iWhmO3t4Bixqn6mY20qt+og8U5YW7GrfoiyDcsdFXGjXn6UEkQGTEvtNCEXto26jGV/B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iwGclKfv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iwGclKfv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E36FC116D0;
	Thu, 15 Jan 2026 23:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768520379;
	bh=NknLNuJTkiWoT3qFbvFFL3oYixgE2NoDa3NBqUAUOvI=;
	h=Date:To:From:Subject:From;
	b=iwGclKfvuANpH78u3m2nkfhOZ+dCnDjnXqnVsdg4AFeZPsxLcKrY0fPzgpQ6Nbihu
	 d68fmUtyFeQ3OWrWkkx/AVaAzsfLBuYfJyRFQLGc7d46sWHfrrJdI2wincXe22Y6K8
	 ySX3d2wt5iuCOJgBCGqW6oN+ugDhmW6yeQHdhCe8=
Date: Thu, 15 Jan 2026 15:39:38 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jiayuan.chen@linux.dev,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,axelrasmussen@google.com,jiayuan.chen@shopee.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-add-tracepoint-and-reason-for-kswapd_failures-reset.patch added to mm-new branch
Message-Id: <20260115233939.6E36FC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: add tracepoint and reason for kswapd_failures reset
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-add-tracepoint-and-reason-for-kswapd_failures-reset.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-add-tracepoint-and-reason-for-kswapd_failures-reset.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Jiayuan Chen <jiayuan.chen@shopee.com>
Subject: mm/vmscan: add tracepoint and reason for kswapd_failures reset
Date: Wed, 14 Jan 2026 15:40:36 +0800

Currently, kswapd_failures is reset in multiple places (kswapd, direct
reclaim, PCP freeing, memory-tiers), but there's no way to trace when and
why it was reset, making it difficult to debug memory reclaim issues.

This patch:

1. Introduce pgdat_reset_kswapd_failures() as a wrapper function to
   centralize kswapd_failures reset logic.

2. Add reset_kswapd_failures_reason enum to distinguish reset sources:
   - RESET_KSWAPD_FAILURES_KSWAPD: reset from kswapd context
   - RESET_KSWAPD_FAILURES_DIRECT: reset from direct reclaim
   - RESET_KSWAPD_FAILURES_PCP: reset from PCP page freeing
   - RESET_KSWAPD_FAILURES_OTHER: reset from other paths

3. Add tracepoints for better observability:
   - mm_vmscan_reset_kswapd_failures: traces each reset with reason
   - mm_vmscan_kswapd_reclaim_fail: traces each kswapd reclaim failure

Test results:

$ trace-cmd record -e vmscan:mm_vmscan_reset_kswapd_failures -e vmscan:mm_vmscan_kswapd_reclaim_fail
$ # generate memory pressure
$ trace-cmd report
cpus=4
kswapd1-73  [002]  24.863112: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=1
kswapd1-73  [002]  24.863472: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=2
kswapd1-73  [002]  24.863813: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=3
kswapd1-73  [002]  24.864141: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=4
kswapd1-73  [002]  24.864462: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=5
kswapd1-73  [002]  24.864779: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=6
kswapd1-73  [002]  24.865103: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=7
kswapd1-73  [002]  24.865421: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=8
kswapd1-73  [002]  24.865737: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=9
kswapd1-73  [002]  24.866070: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=10
kswapd1-73  [002]  24.866385: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=11
kswapd1-73  [002]  24.866701: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=12
kswapd1-73  [002]  24.867016: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=13
kswapd1-73  [002]  24.867333: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=14
kswapd1-73  [002]  24.867649: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=15
kswapd1-73  [002]  24.867965: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=16
kswapd0-72  [001]  25.020464: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=1
kswapd0-72  [001]  25.021054: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=2
kswapd0-72  [001]  25.021628: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=3
kswapd0-72  [001]  25.022217: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=4
kswapd0-72  [001]  25.022790: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=5
kswapd0-72  [001]  25.023366: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=6
kswapd0-72  [001]  25.023937: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=7
kswapd0-72  [001]  25.024511: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=8
kswapd0-72  [001]  25.025092: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=9
kswapd0-72  [001]  25.025665: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=10
kswapd0-72  [001]  25.026249: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=11
kswapd0-72  [001]  25.026824: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=12
kswapd0-72  [001]  25.027398: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=13
kswapd0-72  [001]  25.027976: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=14
kswapd0-72  [001]  25.028554: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=15
kswapd0-72  [001]  25.029140: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=16
ann-416     [002]  25.577925: mm_vmscan_reset_kswapd_failures: nid=0 reason=PCP
dd-417      [002]  35.111721: mm_vmscan_reset_kswapd_failures: nid=1 reason=DIRECT

Link: https://lkml.kernel.org/r/20260114074049.229935-3-jiayuan.chen@linux.dev
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h        |    9 +++++
 include/trace/events/vmscan.h |   51 ++++++++++++++++++++++++++++++++
 mm/memory-tiers.c             |    2 -
 mm/page_alloc.c               |    2 -
 mm/vmscan.c                   |   16 ++++++----
 5 files changed, 73 insertions(+), 7 deletions(-)

--- a/include/linux/mmzone.h~mm-vmscan-add-tracepoint-and-reason-for-kswapd_failures-reset
+++ a/include/linux/mmzone.h
@@ -1551,6 +1551,15 @@ static inline unsigned long pgdat_end_pf
 	return pgdat->node_start_pfn + pgdat->node_spanned_pages;
 }
 
+enum reset_kswapd_failures_reason {
+	RESET_KSWAPD_FAILURES_OTHER = 0,
+	RESET_KSWAPD_FAILURES_KSWAPD,
+	RESET_KSWAPD_FAILURES_DIRECT,
+	RESET_KSWAPD_FAILURES_PCP,
+};
+
+void pgdat_reset_kswapd_failures(pg_data_t *pgdat, enum reset_kswapd_failures_reason reason);
+
 #include <linux/memory_hotplug.h>
 
 void build_all_zonelists(pg_data_t *pgdat);
--- a/include/trace/events/vmscan.h~mm-vmscan-add-tracepoint-and-reason-for-kswapd_failures-reset
+++ a/include/trace/events/vmscan.h
@@ -40,6 +40,16 @@
 		{_VMSCAN_THROTTLE_CONGESTED,	"VMSCAN_THROTTLE_CONGESTED"}	\
 		) : "VMSCAN_THROTTLE_NONE"
 
+TRACE_DEFINE_ENUM(RESET_KSWAPD_FAILURES_OTHER);
+TRACE_DEFINE_ENUM(RESET_KSWAPD_FAILURES_KSWAPD);
+TRACE_DEFINE_ENUM(RESET_KSWAPD_FAILURES_DIRECT);
+TRACE_DEFINE_ENUM(RESET_KSWAPD_FAILURES_PCP);
+
+#define reset_kswapd_src				\
+	{RESET_KSWAPD_FAILURES_KSWAPD,	"KSWAPD"},	\
+	{RESET_KSWAPD_FAILURES_DIRECT,	"DIRECT"},	\
+	{RESET_KSWAPD_FAILURES_PCP,	"PCP"},		\
+	{RESET_KSWAPD_FAILURES_OTHER,	"OTHER"}
 
 #define trace_reclaim_flags(file) ( \
 	(file ? RECLAIM_WB_FILE : RECLAIM_WB_ANON) | \
@@ -535,6 +545,47 @@ TRACE_EVENT(mm_vmscan_throttled,
 		__entry->usec_delayed,
 		show_throttle_flags(__entry->reason))
 );
+
+TRACE_EVENT(mm_vmscan_kswapd_reclaim_fail,
+
+	TP_PROTO(int nid, int failures),
+
+	TP_ARGS(nid, failures),
+
+	TP_STRUCT__entry(
+		__field(int, nid)
+		__field(int, failures)
+	),
+
+	TP_fast_assign(
+		__entry->nid = nid;
+		__entry->failures = failures;
+	),
+
+	TP_printk("nid=%d failures=%d",
+		__entry->nid, __entry->failures)
+);
+
+TRACE_EVENT(mm_vmscan_reset_kswapd_failures,
+
+	TP_PROTO(int nid, int reason),
+
+	TP_ARGS(nid, reason),
+
+	TP_STRUCT__entry(
+		__field(int, nid)
+		__field(int, reason)
+	),
+
+	TP_fast_assign(
+		__entry->nid = nid;
+		__entry->reason = reason;
+	),
+
+	TP_printk("nid=%d reason=%s",
+		__entry->nid,
+		__print_symbolic(__entry->reason, reset_kswapd_src))
+);
 #endif /* _TRACE_VMSCAN_H */
 
 /* This part must be outside protection */
--- a/mm/memory-tiers.c~mm-vmscan-add-tracepoint-and-reason-for-kswapd_failures-reset
+++ a/mm/memory-tiers.c
@@ -958,7 +958,7 @@ static ssize_t demotion_enabled_store(st
 		struct pglist_data *pgdat;
 
 		for_each_online_pgdat(pgdat)
-			atomic_set(&pgdat->kswapd_failures, 0);
+			pgdat_reset_kswapd_failures(pgdat, RESET_KSWAPD_FAILURES_OTHER);
 	}
 
 	return count;
--- a/mm/page_alloc.c~mm-vmscan-add-tracepoint-and-reason-for-kswapd_failures-reset
+++ a/mm/page_alloc.c
@@ -2950,7 +2950,7 @@ static bool free_frozen_page_commit(stru
 		 */
 		if (atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES &&
 		    next_memory_node(pgdat->node_id) < MAX_NUMNODES)
-			atomic_set(&pgdat->kswapd_failures, 0);
+			pgdat_reset_kswapd_failures(pgdat, RESET_KSWAPD_FAILURES_PCP);
 	}
 	return ret;
 }
--- a/mm/vmscan.c~mm-vmscan-add-tracepoint-and-reason-for-kswapd_failures-reset
+++ a/mm/vmscan.c
@@ -2650,9 +2650,11 @@ static bool can_age_anon_pages(struct lr
 			  lruvec_memcg(lruvec));
 }
 
-static void pgdat_reset_kswapd_failures(pg_data_t *pgdat)
+void pgdat_reset_kswapd_failures(pg_data_t *pgdat, enum reset_kswapd_failures_reason reason)
 {
-	atomic_set(&pgdat->kswapd_failures, 0);
+	/* Only trace actual resets, not redundant zero-to-zero */
+	if (atomic_xchg(&pgdat->kswapd_failures, 0))
+		trace_mm_vmscan_reset_kswapd_failures(pgdat->node_id, reason);
 }
 
 /*
@@ -2666,7 +2668,8 @@ static inline void pgdat_try_reset_kswap
 						   struct scan_control *sc)
 {
 	if (pgdat_balanced(pgdat, sc->order, sc->reclaim_idx))
-		pgdat_reset_kswapd_failures(pgdat);
+		pgdat_reset_kswapd_failures(pgdat, current_is_kswapd() ?
+			RESET_KSWAPD_FAILURES_KSWAPD : RESET_KSWAPD_FAILURES_DIRECT);
 }
 
 #ifdef CONFIG_LRU_GEN
@@ -7286,8 +7289,11 @@ restart:
 	 * watermark_high at this point. We need to avoid increasing the
 	 * failure count to prevent the kswapd thread from stopping.
 	 */
-	if (!sc.nr_reclaimed && !boosted)
-		atomic_inc(&pgdat->kswapd_failures);
+	if (!sc.nr_reclaimed && !boosted) {
+		int fail_cnt = atomic_inc_return(&pgdat->kswapd_failures);
+		/* kswapd context, low overhead to trace every failure */
+		trace_mm_vmscan_kswapd_reclaim_fail(pgdat->node_id, fail_cnt);
+	}
 
 out:
 	clear_reclaim_active(pgdat, highest_zoneidx);
_

Patches currently in -mm which might be from jiayuan.chen@shopee.com are

mm-vmscan-mitigate-spurious-kswapd_failures-reset-from-direct-reclaim.patch
mm-vmscan-add-tracepoint-and-reason-for-kswapd_failures-reset.patch

