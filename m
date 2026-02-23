Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597382F12CF
	for <mm-commits@vger.kernel.org>; Mon, 23 Feb 2026 18:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771871591; cv=none; b=ty5PPJeeRjSgFm4vRKp24oKGgAZDaFC/Y0K0ZEQpR/irPiUplsprhnKqLLbahq7noFSz4NmOipOfNWNZdkrTGwvNNdSJ5dF/2iIqGJFN4EYZAoWivlojWGEeHXhRjBj8V4o/BM6N/LfYKakxZpyU73QMfb3PPvimtQTIil32tmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771871591; c=relaxed/simple;
	bh=EpA1kJBOO4wTQLylSjcrxXrDEeM3Cu1g4SFak2m4y0g=;
	h=Date:To:From:Subject:Message-Id; b=AYZ2f6KIDxb7M+/NC2WKcYV3YV3Vl15JhV5vLwmBL3seZKrIAVbQwyMbuleWm58LW0gjTHwicYMCWvWy8Yx9JS1jmD6f/1UGjq6XzNQJYu+95XU4ybUSmZhdu3DecIFghJeRtWIwgddeghsu8c95JmL7ecsVGRKHWoPhbMBcZFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E3FexLBy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E3FexLBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BFAC116C6;
	Mon, 23 Feb 2026 18:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771871591;
	bh=EpA1kJBOO4wTQLylSjcrxXrDEeM3Cu1g4SFak2m4y0g=;
	h=Date:To:From:Subject:From;
	b=E3FexLByFgUJUzSJbG1VHoqJroDs7aJIk71fInmSieyilrF3wlj+Xq83EO+rFz5Ky
	 UwLBmZTb/+j27uzDZ7T466UiGR8Hl8w5wjzB1FLyKgKnF5VowncBEvP/gGHEbsfHkm
	 9vRuZMHhNmmHmLz2bENoCVIng+wHECzN1O3rCyf4=
Date: Mon, 23 Feb 2026 10:33:10 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,rostedt@goodmis.org,mhocko@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@kernel.org,axelrasmussen@google.com,tballasi@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-add-pids-to-vmscan-tracepoints.patch added to mm-new branch
Message-Id: <20260223183310.E7BFAC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: add PIDs to vmscan tracepoints
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-add-pids-to-vmscan-tracepoints.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-add-pids-to-vmscan-tracepoints.patch

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
From: Thomas Ballasi <tballasi@linux.microsoft.com>
Subject: mm: vmscan: add PIDs to vmscan tracepoints
Date: Mon, 23 Feb 2026 09:15:44 -0800

The changes aims at adding additionnal tracepoints variables to help
debuggers attribute them to specific processes.

The PID field uses in_task() to reliably detect when we're in process
context and can safely access current->pid.  When not in process context
(such as in interrupt or in an asynchronous RCU context), the field is set
to -1 as a sentinel value.

Link: https://lkml.kernel.org/r/20260223171544.4750-4-tballasi@linux.microsoft.com
Signed-off-by: Thomas Ballasi <tballasi@linux.microsoft.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |   34 +++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

--- a/include/trace/events/vmscan.h~mm-vmscan-add-pids-to-vmscan-tracepoints
+++ a/include/trace/events/vmscan.h
@@ -132,18 +132,22 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_rec
 		__field(	unsigned long,	gfp_flags	)
 		__field(	u64,	memcg_id	)
 		__field(	int,	order		)
+		__field(	int,	pid		)
 	),
 
 	TP_fast_assign(
 		__entry->gfp_flags	= (__force unsigned long)gfp_flags;
 		__entry->order		= order;
+		__entry->pid		= current->pid;
 		__entry->memcg_id	= mem_cgroup_id(memcg);
 	),
 
-	TP_printk("order=%d gfp_flags=%s memcg_id=%llu",
+	TP_printk("order=%d gfp_flags=%s pid=%d memcg_id=%llu %s",
 		__entry->order,
 		show_gfp_flags(__entry->gfp_flags),
-		__entry->memcg_id)
+		__entry->pid,
+		__entry->memcg_id,
+		__event_in_irq() ? "(in-irq)" : "")
 );
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_direct_reclaim_begin,
@@ -178,16 +182,20 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_rec
 	TP_STRUCT__entry(
 		__field(	unsigned long,	nr_reclaimed	)
 		__field(	u64,	memcg_id	)
+		__field(	int,	pid		)
 	),
 
 	TP_fast_assign(
 		__entry->nr_reclaimed	= nr_reclaimed;
 		__entry->memcg_id	= mem_cgroup_id(memcg);
+		__entry->pid		= current->pid;
 	),
 
-	TP_printk("nr_reclaimed=%lu memcg_id=%llu",
+	TP_printk("nr_reclaimed=%lu pid=%d memcg_id=%llu %s",
 		__entry->nr_reclaimed,
-		__entry->memcg_id)
+		__entry->pid,
+		__entry->memcg_id,
+		__event_in_irq() ? "(in-irq)" : "")
 );
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_direct_reclaim_end,
@@ -230,9 +238,10 @@ TRACE_EVENT(mm_shrink_slab_start,
 		__field(unsigned long, cache_items)
 		__field(unsigned long long, delta)
 		__field(unsigned long, total_scan)
+		__field(u64, memcg_id)
 		__field(int, priority)
 		__field(int, nid)
-		__field(u64, memcg_id)
+		__field(int, pid)
 	),
 
 	TP_fast_assign(
@@ -246,19 +255,22 @@ TRACE_EVENT(mm_shrink_slab_start,
 		__entry->priority = priority;
 		__entry->nid = sc->nid;
 		__entry->memcg_id = mem_cgroup_id(memcg);
+		__entry->pid = current->pid;
 	),
 
-	TP_printk("%pS %p: nid: %d memcg_id: %llu objects to shrink %ld gfp_flags %s cache items %ld delta %lld total_scan %ld priority %d",
+	TP_printk("%pS %p: nid: %d pid: %d memcg_id: %llu objects to shrink %ld gfp_flags %s cache items %ld delta %lld total_scan %ld priority %d %s",
 		__entry->shrink,
 		__entry->shr,
 		__entry->nid,
+		__entry->pid,
 		__entry->memcg_id,
 		__entry->nr_objects_to_shrink,
 		show_gfp_flags(__entry->gfp_flags),
 		__entry->cache_items,
 		__entry->delta,
 		__entry->total_scan,
-		__entry->priority)
+		__entry->priority,
+		__event_in_irq() ? "(in-irq)" : "")
 );
 
 TRACE_EVENT(mm_shrink_slab_end,
@@ -276,6 +288,7 @@ TRACE_EVENT(mm_shrink_slab_end,
 		__field(long, total_scan)
 		__field(int, nid)
 		__field(int, retval)
+		__field(int, pid)
 		__field(u64, memcg_id)
 	),
 
@@ -287,18 +300,21 @@ TRACE_EVENT(mm_shrink_slab_end,
 		__entry->total_scan = total_scan;
 		__entry->nid = nid;
 		__entry->retval = shrinker_retval;
+		__entry->pid = current->pid;
 		__entry->memcg_id = mem_cgroup_id(memcg);
 	),
 
-	TP_printk("%pS %p: nid: %d memcg_id: %llu unused scan count %ld new scan count %ld total_scan %ld last shrinker return val %d",
+	TP_printk("%pS %p: nid: %d pid: %d memcg_id: %llu unused scan count %ld new scan count %ld total_scan %ld last shrinker return val %d %s",
 		__entry->shrink,
 		__entry->shr,
 		__entry->nid,
+		__entry->pid,
 		__entry->memcg_id,
 		__entry->unused_scan,
 		__entry->new_scan,
 		__entry->total_scan,
-		__entry->retval)
+		__entry->retval,
+		__event_in_irq() ? "(in-irq)" : "")
 );
 
 TRACE_EVENT(mm_vmscan_lru_isolate,
_

Patches currently in -mm which might be from tballasi@linux.microsoft.com are

mm-vmscan-add-cgroup-ids-to-vmscan-tracepoints.patch
mm-vmscan-add-pids-to-vmscan-tracepoints.patch

