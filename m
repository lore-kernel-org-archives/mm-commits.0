Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C807723D28C
	for <mm-commits@vger.kernel.org>; Tue, 20 Jan 2026 20:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768941074; cv=none; b=aTVYuLlQi4RzYJNdAg2axmHuh/cf1WXHICycGx1p2FpirFwyHuYvqllxRcvQEb3v05U6scJ2jI/bIyAczZGOYFWSbrYRC2Kvd4/dT4IPGELCcD9Kc91SEYWI/VTCrv/sQAmxkSWXIZMtPlEfklx0aB+BtSZV9SlHyGFVIN1tFCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768941074; c=relaxed/simple;
	bh=JCYxz8kbSUYJbCABfpVttAonZjlxWMP/3usWWlRIDqA=;
	h=Date:To:From:Subject:Message-Id; b=i4BHhiFaZBHmfrdTJWdex1b5Unhg84gGaTtG3vX0Y8CyMQwuKUB47rHIWQzGLCG0PJWFkVFSOcR0RGsrIvL2fLHa45tQVqdpmxf8gtVIOG0rlIJg5IB2BJXPiot8P6I2vy0UfHhh7QoujaxTfnjmJrPWFP0AJW2EMiSou87OG0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o5NPeTXB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o5NPeTXB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345DEC16AAE;
	Tue, 20 Jan 2026 20:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768941074;
	bh=JCYxz8kbSUYJbCABfpVttAonZjlxWMP/3usWWlRIDqA=;
	h=Date:To:From:Subject:From;
	b=o5NPeTXB7Q70LsRS2WeSz6f9ti7QSvT7/wMozpTMHbGkltRmfSAUPwApUXTD0Uhp0
	 l59I2FAMn62ARtuGvqQXzedMbNmcCsKmdS3n4ThDL7GgGmW1ZuJTnTeWJphUR4Ydz0
	 PWiUGlKotFXIRltcsCPDnxCUqGCR9SrNf3GnegJI=
Date: Tue, 20 Jan 2026 12:31:13 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jiayuan.chen@linux.dev,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,axelrasmussen@google.com,jiayuan.chen@shopee.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-add-tracepoint-and-reason-for-kswapd_failures-reset.patch added to mm-unstable branch
Message-Id: <20260120203114.345DEC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: add tracepoint and reason for kswapd_failures reset
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-add-tracepoint-and-reason-for-kswapd_failures-reset.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-add-tracepoint-and-reason-for-kswapd_failures-reset.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Date: Tue, 20 Jan 2026 10:43:49 +0800

Currently, kswapd_failures is reset in multiple places (kswapd, direct
reclaim, PCP freeing, memory-tiers), but there's no way to trace when and
why it was reset, making it difficult to debug memory reclaim issues.

This patch:

1. Introduce kswapd_clear_hopeless() as a wrapper function to
   centralize kswapd_failures reset logic.

2. Introduce kswapd_test_hopeless() to encapsulate hopeless node
   checks, replacing all open-coded kswapd_failures comparisons.

3. Add kswapd_clear_hopeless_reason enum to distinguish reset sources:
   - KSWAPD_CLEAR_HOPELESS_KSWAPD: reset from kswapd context
   - KSWAPD_CLEAR_HOPELESS_DIRECT: reset from direct reclaim
   - KSWAPD_CLEAR_HOPELESS_PCP: reset from PCP page freeing
   - KSWAPD_CLEAR_HOPELESS_OTHER: reset from other paths

4. Add tracepoints for better observability:
   - mm_vmscan_kswapd_clear_hopeless: traces each reset with reason
   - mm_vmscan_kswapd_reclaim_fail: traces each kswapd reclaim failure

Test results:

$ trace-cmd record -e vmscan:mm_vmscan_kswapd_clear_hopeless -e vmscan:mm_vmscan_kswapd_reclaim_fail
$ # generate memory pressure
$ trace-cmd report
cpus=4
 kswapd0-71    [000]    27.216563: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=1
 kswapd0-71    [000]    27.217169: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=2
 kswapd0-71    [000]    27.217764: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=3
 kswapd0-71    [000]    27.218353: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=4
 kswapd0-71    [000]    27.218993: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=5
 kswapd0-71    [000]    27.219744: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=6
 kswapd0-71    [000]    27.220488: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=7
 kswapd0-71    [000]    27.221206: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=8
 kswapd0-71    [000]    27.221806: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=9
 kswapd0-71    [000]    27.222634: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=10
 kswapd0-71    [000]    27.223286: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=11
 kswapd0-71    [000]    27.223894: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=12
 kswapd0-71    [000]    27.224712: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=13
 kswapd0-71    [000]    27.225424: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=14
 kswapd0-71    [000]    27.226082: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=15
 kswapd0-71    [000]    27.226810: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=16
 kswapd1-72    [002]    27.386869: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=1
 kswapd1-72    [002]    27.387435: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=2
 kswapd1-72    [002]    27.388016: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=3
 kswapd1-72    [002]    27.388586: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=4
 kswapd1-72    [002]    27.389155: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=5
 kswapd1-72    [002]    27.389723: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=6
 kswapd1-72    [002]    27.390292: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=7
 kswapd1-72    [002]    27.392364: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=8
 kswapd1-72    [002]    27.392934: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=9
 kswapd1-72    [002]    27.393504: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=10
 kswapd1-72    [002]    27.394073: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=11
 kswapd1-72    [002]    27.394899: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=12
 kswapd1-72    [002]    27.395472: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=13
 kswapd1-72    [002]    27.396055: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=14
 kswapd1-72    [002]    27.396628: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=15
 kswapd1-72    [002]    27.397199: mm_vmscan_kswapd_reclaim_fail: nid=1 failures=16
kworker/u18:0-40    [002]    27.410151: mm_vmscan_kswapd_clear_hopeless: nid=0 reason=DIRECT
 kswapd0-71    [000]    27.439454: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=1
 kswapd0-71    [000]    27.440048: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=2
 kswapd0-71    [000]    27.440634: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=3
 kswapd0-71    [000]    27.441211: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=4
 kswapd0-71    [000]    27.441787: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=5
 kswapd0-71    [000]    27.442363: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=6
 kswapd0-71    [000]    27.443030: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=7
 kswapd0-71    [000]    27.443725: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=8
 kswapd0-71    [000]    27.444315: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=9
 kswapd0-71    [000]    27.444898: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=10
 kswapd0-71    [000]    27.445476: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=11
 kswapd0-71    [000]    27.446053: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=12
 kswapd0-71    [000]    27.446646: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=13
 kswapd0-71    [000]    27.447230: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=14
 kswapd0-71    [000]    27.447812: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=15
 kswapd0-71    [000]    27.448391: mm_vmscan_kswapd_reclaim_fail: nid=0 failures=16
 ann-423   [003]    28.028285: mm_vmscan_kswapd_clear_hopeless: nid=0 reason=PCP

Link: https://lkml.kernel.org/r/20260120024402.387576-3-jiayuan.chen@linux.dev
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h        |   19 +++++++++--
 include/trace/events/vmscan.h |   51 ++++++++++++++++++++++++++++++++
 mm/memory-tiers.c             |    2 -
 mm/page_alloc.c               |    4 +-
 mm/show_mem.c                 |    3 -
 mm/vmscan.c                   |   29 ++++++++++++------
 mm/vmstat.c                   |    2 -
 7 files changed, 91 insertions(+), 19 deletions(-)

--- a/include/linux/mmzone.h~mm-vmscan-add-tracepoint-and-reason-for-kswapd_failures-reset
+++ a/include/linux/mmzone.h
@@ -1534,16 +1534,27 @@ static inline unsigned long pgdat_end_pf
 #include <linux/memory_hotplug.h>
 
 void build_all_zonelists(pg_data_t *pgdat);
-void wakeup_kswapd(struct zone *zone, gfp_t gfp_mask, int order,
-		   enum zone_type highest_zoneidx);
-void kswapd_try_clear_hopeless(struct pglist_data *pgdat,
-			       unsigned int order, int highest_zoneidx);
 bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 			 int highest_zoneidx, unsigned int alloc_flags,
 			 long free_pages);
 bool zone_watermark_ok(struct zone *z, unsigned int order,
 		unsigned long mark, int highest_zoneidx,
 		unsigned int alloc_flags);
+
+enum kswapd_clear_hopeless_reason {
+	KSWAPD_CLEAR_HOPELESS_OTHER = 0,
+	KSWAPD_CLEAR_HOPELESS_KSWAPD,
+	KSWAPD_CLEAR_HOPELESS_DIRECT,
+	KSWAPD_CLEAR_HOPELESS_PCP,
+};
+
+void wakeup_kswapd(struct zone *zone, gfp_t gfp_mask, int order,
+		   enum zone_type highest_zoneidx);
+void kswapd_try_clear_hopeless(struct pglist_data *pgdat,
+			       unsigned int order, int highest_zoneidx);
+void kswapd_clear_hopeless(pg_data_t *pgdat, enum kswapd_clear_hopeless_reason reason);
+bool kswapd_test_hopeless(pg_data_t *pgdat);
+
 /*
  * Memory initialization context, use to differentiate memory added by
  * the platform statically or via memory hotplug interface.
--- a/include/trace/events/vmscan.h~mm-vmscan-add-tracepoint-and-reason-for-kswapd_failures-reset
+++ a/include/trace/events/vmscan.h
@@ -40,6 +40,16 @@
 		{_VMSCAN_THROTTLE_CONGESTED,	"VMSCAN_THROTTLE_CONGESTED"}	\
 		) : "VMSCAN_THROTTLE_NONE"
 
+TRACE_DEFINE_ENUM(KSWAPD_CLEAR_HOPELESS_OTHER);
+TRACE_DEFINE_ENUM(KSWAPD_CLEAR_HOPELESS_KSWAPD);
+TRACE_DEFINE_ENUM(KSWAPD_CLEAR_HOPELESS_DIRECT);
+TRACE_DEFINE_ENUM(KSWAPD_CLEAR_HOPELESS_PCP);
+
+#define kswapd_clear_hopeless_reason_ops		\
+	{KSWAPD_CLEAR_HOPELESS_KSWAPD,	"KSWAPD"},	\
+	{KSWAPD_CLEAR_HOPELESS_DIRECT,	"DIRECT"},	\
+	{KSWAPD_CLEAR_HOPELESS_PCP,	"PCP"},		\
+	{KSWAPD_CLEAR_HOPELESS_OTHER,	"OTHER"}
 
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
+TRACE_EVENT(mm_vmscan_kswapd_clear_hopeless,
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
+		__print_symbolic(__entry->reason, kswapd_clear_hopeless_reason_ops))
+);
 #endif /* _TRACE_VMSCAN_H */
 
 /* This part must be outside protection */
--- a/mm/memory-tiers.c~mm-vmscan-add-tracepoint-and-reason-for-kswapd_failures-reset
+++ a/mm/memory-tiers.c
@@ -955,7 +955,7 @@ static ssize_t demotion_enabled_store(st
 		struct pglist_data *pgdat;
 
 		for_each_online_pgdat(pgdat)
-			atomic_set(&pgdat->kswapd_failures, 0);
+			kswapd_clear_hopeless(pgdat, KSWAPD_CLEAR_HOPELESS_OTHER);
 	}
 
 	return count;
--- a/mm/page_alloc.c~mm-vmscan-add-tracepoint-and-reason-for-kswapd_failures-reset
+++ a/mm/page_alloc.c
@@ -2945,9 +2945,9 @@ static bool free_frozen_page_commit(stru
 		 * 'hopeless node' to stay in that state for a while.  Let
 		 * kswapd work again by resetting kswapd_failures.
 		 */
-		if (atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES &&
+		if (kswapd_test_hopeless(pgdat) &&
 		    next_memory_node(pgdat->node_id) < MAX_NUMNODES)
-			atomic_set(&pgdat->kswapd_failures, 0);
+			kswapd_clear_hopeless(pgdat, KSWAPD_CLEAR_HOPELESS_PCP);
 	}
 	return ret;
 }
--- a/mm/show_mem.c~mm-vmscan-add-tracepoint-and-reason-for-kswapd_failures-reset
+++ a/mm/show_mem.c
@@ -278,8 +278,7 @@ static void show_free_areas(unsigned int
 #endif
 			K(node_page_state(pgdat, NR_PAGETABLE)),
 			K(node_page_state(pgdat, NR_SECONDARY_PAGETABLE)),
-			str_yes_no(atomic_read(&pgdat->kswapd_failures) >=
-				   MAX_RECLAIM_RETRIES),
+			str_yes_no(kswapd_test_hopeless(pgdat)),
 			K(node_page_state(pgdat, NR_BALLOON_PAGES)));
 	}
 
--- a/mm/vmscan.c~mm-vmscan-add-tracepoint-and-reason-for-kswapd_failures-reset
+++ a/mm/vmscan.c
@@ -506,7 +506,7 @@ static bool skip_throttle_noprogress(pg_
 	 * If kswapd is disabled, reschedule if necessary but do not
 	 * throttle as the system is likely near OOM.
 	 */
-	if (atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES)
+	if (kswapd_test_hopeless(pgdat))
 		return true;
 
 	/*
@@ -6436,7 +6436,7 @@ static bool allow_direct_reclaim(pg_data
 	int i;
 	bool wmark_ok;
 
-	if (atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES)
+	if (kswapd_test_hopeless(pgdat))
 		return true;
 
 	for_each_managed_zone_pgdat(zone, pgdat, i, ZONE_NORMAL) {
@@ -6845,7 +6845,7 @@ static bool prepare_kswapd_sleep(pg_data
 		wake_up_all(&pgdat->pfmemalloc_wait);
 
 	/* Hopeless node, leave it to direct reclaim */
-	if (atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES)
+	if (kswapd_test_hopeless(pgdat))
 		return true;
 
 	if (pgdat_balanced(pgdat, order, highest_zoneidx)) {
@@ -7110,8 +7110,11 @@ restart:
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
@@ -7370,7 +7373,7 @@ void wakeup_kswapd(struct zone *zone, gf
 		return;
 
 	/* Hopeless node, leave it to direct reclaim if possible */
-	if (atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES ||
+	if (kswapd_test_hopeless(pgdat) ||
 	    (pgdat_balanced(pgdat, order, highest_zoneidx) &&
 	     !pgdat_watermark_boosted(pgdat, highest_zoneidx))) {
 		/*
@@ -7390,9 +7393,11 @@ void wakeup_kswapd(struct zone *zone, gf
 	wake_up_interruptible(&pgdat->kswapd_wait);
 }
 
-static void kswapd_clear_hopeless(pg_data_t *pgdat)
+void kswapd_clear_hopeless(pg_data_t *pgdat, enum kswapd_clear_hopeless_reason reason)
 {
-	atomic_set(&pgdat->kswapd_failures, 0);
+	/* Only trace actual resets, not redundant zero-to-zero */
+	if (atomic_xchg(&pgdat->kswapd_failures, 0))
+		trace_mm_vmscan_kswapd_clear_hopeless(pgdat->node_id, reason);
 }
 
 /*
@@ -7405,7 +7410,13 @@ void kswapd_try_clear_hopeless(struct pg
 			       unsigned int order, int highest_zoneidx)
 {
 	if (pgdat_balanced(pgdat, order, highest_zoneidx))
-		kswapd_clear_hopeless(pgdat);
+		kswapd_clear_hopeless(pgdat, current_is_kswapd() ?
+			KSWAPD_CLEAR_HOPELESS_KSWAPD : KSWAPD_CLEAR_HOPELESS_DIRECT);
+}
+
+bool kswapd_test_hopeless(pg_data_t *pgdat)
+{
+	return atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES;
 }
 
 #ifdef CONFIG_HIBERNATION
--- a/mm/vmstat.c~mm-vmscan-add-tracepoint-and-reason-for-kswapd_failures-reset
+++ a/mm/vmstat.c
@@ -1840,7 +1840,7 @@ static void zoneinfo_show_print(struct s
 		   "\n  start_pfn:           %lu"
 		   "\n  reserved_highatomic: %lu"
 		   "\n  free_highatomic:     %lu",
-		   atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES,
+		   kswapd_test_hopeless(pgdat),
 		   zone->zone_start_pfn,
 		   zone->nr_reserved_highatomic,
 		   zone->nr_free_highatomic);
_

Patches currently in -mm which might be from jiayuan.chen@shopee.com are

mm-vmscan-mitigate-spurious-kswapd_failures-reset-from-direct-reclaim.patch
mm-vmscan-add-tracepoint-and-reason-for-kswapd_failures-reset.patch

