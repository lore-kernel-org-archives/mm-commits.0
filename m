Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3456836E493
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027567; cv=none; b=dgYL230R7Ex+Yj13IIQk2NR2O46o3vwg5ylxjblbRMSylYzSfd18sT0q6eZCZ1PG6rs+kuXJ4+xYrhYMEUNP3J0ecCk5kzqByPjujBoVJ5n5Hgg3am1TRG7bIPhozabc9xoztcajLqsSIJRt6Oz2XBgF3GRsU/MS+SAzNLhkFY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027567; c=relaxed/simple;
	bh=nEn3eZ0S6iC9SpVovay8v2Slx8+yuPnUyAJyFO4IELE=;
	h=Date:To:From:Subject:Message-Id; b=HAC/yEZrfSfEN/3ENk4pOLjzrTq+XCJ3epopCcceaTM95ucKDWv3u+jSAJ75nvP18qbemq2dBMRliSjIYJdYnbgP1zcIdw2LReTBf00aV5kUmbKdRcWp/JMoHqt/ClZTu02hgN0tH2p0O+MGYW6ax89pSk/IYElycD3BZtOIfIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NRfc/4Sw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NRfc/4Sw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D81C1F00899;
	Fri, 29 May 2026 04:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027564;
	bh=oexRd5cKg9nlqvxs7c5RYHCfHh/7+GOfAySw5WhB688=;
	h=Date:To:From:Subject;
	b=NRfc/4SwLhIbhYq3iqeMWof9d5b3vH2igauLdZr/KVENTwjF32t2Bojy/e3SusPKi
	 59wmDCtHo9OQbGOjWR/f/j4hNM2VJ9dbgfp9XBpKrGxx7nujvKfNXm5xdwP7yTSlyC
	 4ifxuSeJHtKEn2yjtGUw6Gi0dByU7F3YB56WJpWY=
Date: Thu, 28 May 2026 21:06:03 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,rostedt@goodmis.org,mhocko@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,b.suvonov@sjtu.edu.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-add-balance_pgdat-begin-end-tracepoints.patch removed from -mm tree
Message-Id: <20260529040604.5D81C1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: add balance_pgdat begin/end tracepoints
has been removed from the -mm tree.  Its filename was
     mm-vmscan-add-balance_pgdat-begin-end-tracepoints.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bunyod Suvonov <b.suvonov@sjtu.edu.cn>
Subject: mm/vmscan: add balance_pgdat begin/end tracepoints
Date: Thu, 23 Apr 2026 18:37:53 +0800

Vmscan has six main reclaim entry points: try_to_free_pages() for
direct reclaim, try_to_free_mem_cgroup_pages() for memcg reclaim,
mem_cgroup_shrink_node() for memcg soft limit reclaim, node_reclaim()
for node reclaim, shrink_all_memory() for hibernation reclaim, and
balance_pgdat() for kswapd reclaim.

All of them, except for shrink_all_memory() and balance_pgdat(),
already have begin/end tracepoints.  This makes it harder to trace
which reclaim path is responsible for memory reclaim activity, because
kswapd reclaim cannot be identified as cleanly as other reclaim entry
points, even though it is the main background reclaim path under memory
pressure.  There may be no need to trace shrink_all_memory() as it is
primarily used during hibernation.  So this patch adds the missing
tracepoint pair for balance_pgdat().

The begin tracepoint records the node id, requested reclaim order, and
the requested classzone bound (highest_zoneidx).  The end tracepoint
records the node id, the reclaim order that balance_pgdat() finished
with, the requested classzone bound, and nr_reclaimed.  Together, they
show the requested reclaim order and classzone bound, whether reclaim
fell back to a lower order, and how much reclaim work was done.

The end tracepoint also records highest_zoneidx even though it does not
change within a balance_pgdat() invocation.  This keeps the end event
self-contained, so users can analyze reclaim results directly from end
events without depending on begin/end correlation, which is less
convenient when tracing is filtered or records are dropped.  It also
makes it straightforward to relate nr_reclaimed and the final reclaim
order to the requested classzone bound.

Link: https://lore.kernel.org/20260424031418.174597-1-b.suvonov@sjtu.edu.cn
Link: https://lore.kernel.org/20260423103753.546582-1-b.suvonov@sjtu.edu.cn
Signed-off-by: Bunyod Suvonov <b.suvonov@sjtu.edu.cn>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |   52 ++++++++++++++++++++++++++++++++
 mm/vmscan.c                   |    5 +++
 2 files changed, 57 insertions(+)

--- a/include/trace/events/vmscan.h~mm-vmscan-add-balance_pgdat-begin-end-tracepoints
+++ a/include/trace/events/vmscan.h
@@ -96,6 +96,58 @@ TRACE_EVENT(mm_vmscan_kswapd_wake,
 		__entry->order)
 );
 
+TRACE_EVENT(mm_vmscan_balance_pgdat_begin,
+
+	TP_PROTO(int nid, int order, int highest_zoneidx),
+
+	TP_ARGS(nid, order, highest_zoneidx),
+
+	TP_STRUCT__entry(
+		__field(int, nid)
+		__field(int, order)
+		__field(int, highest_zoneidx)
+	),
+
+	TP_fast_assign(
+		__entry->nid = nid;
+		__entry->order = order;
+		__entry->highest_zoneidx = highest_zoneidx;
+	),
+
+	TP_printk("nid=%d order=%d highest_zoneidx=%-8s",
+		__entry->nid,
+		__entry->order,
+		__print_symbolic(__entry->highest_zoneidx, ZONE_TYPE))
+);
+
+TRACE_EVENT(mm_vmscan_balance_pgdat_end,
+
+	TP_PROTO(int nid, int order, int highest_zoneidx,
+		 unsigned long nr_reclaimed),
+
+	TP_ARGS(nid, order, highest_zoneidx, nr_reclaimed),
+
+	TP_STRUCT__entry(
+		__field(int, nid)
+		__field(int, order)
+		__field(int, highest_zoneidx)
+		__field(unsigned long, nr_reclaimed)
+	),
+
+	TP_fast_assign(
+		__entry->nid = nid;
+		__entry->order = order;
+		__entry->highest_zoneidx = highest_zoneidx;
+		__entry->nr_reclaimed = nr_reclaimed;
+	),
+
+	TP_printk("nid=%d order=%d highest_zoneidx=%-8s nr_reclaimed=%lu",
+		__entry->nid,
+		__entry->order,
+		__print_symbolic(__entry->highest_zoneidx, ZONE_TYPE),
+		__entry->nr_reclaimed)
+);
+
 TRACE_EVENT(mm_vmscan_wakeup_kswapd,
 
 	TP_PROTO(int nid, int zid, int order, gfp_t gfp_flags),
--- a/mm/vmscan.c~mm-vmscan-add-balance_pgdat-begin-end-tracepoints
+++ a/mm/vmscan.c
@@ -7121,6 +7121,8 @@ static int balance_pgdat(pg_data_t *pgda
 		.may_unmap = 1,
 	};
 
+	trace_mm_vmscan_balance_pgdat_begin(pgdat->node_id, order,
+					    highest_zoneidx);
 	set_task_reclaim_state(current, &sc.reclaim_state);
 	psi_memstall_enter(&pflags);
 	__fs_reclaim_acquire(_THIS_IP_);
@@ -7314,6 +7316,9 @@ out:
 	psi_memstall_leave(&pflags);
 	set_task_reclaim_state(current, NULL);
 
+	trace_mm_vmscan_balance_pgdat_end(pgdat->node_id, sc.order,
+					  highest_zoneidx, sc.nr_reclaimed);
+
 	/*
 	 * Return the order kswapd stopped reclaiming at as
 	 * prepare_kswapd_sleep() takes it into account. If another caller
_

Patches currently in -mm which might be from b.suvonov@sjtu.edu.cn are


