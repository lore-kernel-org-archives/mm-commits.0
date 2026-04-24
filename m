Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A3235AC35
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 10:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777025270; cv=none; b=L7lkQi39BY2B5I0/Q98HDT4JRYzmyRarDh4cgbQO7PnftfSMm1h9Vy4SYJMFdEGTmnfhjtImsTHdMzHd+ZKqduq9sxRJRIPmq0wK8OfL6uvKQCiAhoL1YetHnnOPM7Hl/immph3TBZL29wmT+W5VHgsESOLY2uU1WZaUDTE/hno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777025270; c=relaxed/simple;
	bh=8yIKx+DpUlMEXrETL1SxO8MKLs2L9zijZFLqUGhPBbU=;
	h=Date:To:From:Subject:Message-Id; b=Fa5fYrXIMgO9UYUitgLvl/Vwqqe+fMOWACzsVP6Wucczla+hCCVp2o/B5ECX2r0p70UYET5vrqB6kOjTuvPG/ovXncpV0VnkQ8yTZSGXimTiwg0plZcrvdodkWOaH3o8MGdx1tJNkyb8myHIe9oEZ2quMfPUSO6bRgOB980C0Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IDj8eufA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IDj8eufA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B70DC19425;
	Fri, 24 Apr 2026 10:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777025270;
	bh=8yIKx+DpUlMEXrETL1SxO8MKLs2L9zijZFLqUGhPBbU=;
	h=Date:To:From:Subject:From;
	b=IDj8eufAvaeDBx/8WiqjvbT3Xw3wr8MVl2ZwIbh6jCEN40qiIoSY+XrnhjquAgkfm
	 6M9Yi5HavlWobDrzwftgymqE1puFu05KjIkZjk99Q7+UKbktYIlziwyrZqlxM13lcs
	 ATxfPdt0o9VnA2uM0+n/mCRw56xjXUAmAjcMh75g=
Date: Fri, 24 Apr 2026 03:07:49 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,rostedt@goodmis.org,mhocko@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,b.suvonov@sjtu.edu.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-add-balance_pgdat-begin-end-tracepoints.patch added to mm-new branch
Message-Id: <20260424100750.3B70DC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: add balance_pgdat begin/end tracepoints
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-add-balance_pgdat-begin-end-tracepoints.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-add-balance_pgdat-begin-end-tracepoints.patch

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

mm-vmscan-add-balance_pgdat-begin-end-tracepoints.patch

