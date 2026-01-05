Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D89A310645
	for <mm-commits@vger.kernel.org>; Mon,  5 Jan 2026 21:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767649306; cv=none; b=Ej35M1JKdjNgqfWCvezTB7RldGQJp7jGE5vzB6ybuP9c12EgauRO9lpoRI4m9N8eSY3UUFKSEn3dYPR1uRuDZHOfaM7kGvtgQTpqF6ml88Ashm1gYNDKaYubYamK0IP2OeUtew2OzVLcRSu9ZF7lnSWB3I2BBM6HrblufpZQypY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767649306; c=relaxed/simple;
	bh=QcfsXG6/4Ih+/b+UQwbK1riOtXOd71m2qU2HJNHhTig=;
	h=Date:To:From:Subject:Message-Id; b=fUVnK9ZqlNJcSt/4mQeyPr1S+46NLEP0WAmx60gT92PnHFYd9ZKB0JLzIuzDUyIeZcsV7qTNvrC7+vZgavOx/Y6Ez/bmCjOZBPiuh4Lgb2adb6ZzZBQav2834AwWAmpFQGQtBkK16WZ/TRRA8WqVujk2RAZBbpR1Ii5oH/95e8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k+2WSI74; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k+2WSI74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC4BC116D0;
	Mon,  5 Jan 2026 21:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767649306;
	bh=QcfsXG6/4Ih+/b+UQwbK1riOtXOd71m2qU2HJNHhTig=;
	h=Date:To:From:Subject:From;
	b=k+2WSI74lu/1baGFMMq5EHuf4qzg5wN32jJlOBJ1wr/5EWhxm6F4Q0OkgamD2Bve3
	 byMYvM+hCWHgBGL/hKCwDoBiIWkWbDmYGKl41C4HjI3OUyevLMv7kShxAMtAKpAZaE
	 +YJfSJTXQbllFen5mlOe7InIxYa87MPlZJY7An78=
Date: Mon, 05 Jan 2026 13:41:45 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,rostedt@goodmis.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@kernel.org,david@fromorbit.com,axelrasmussen@google.com,tballasi@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-add-pids-to-vmscan-tracepoints.patch added to mm-new branch
Message-Id: <20260105214146.1FC4BC116D0@smtp.kernel.org>
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
Date: Mon, 5 Jan 2026 08:04:23 -0800

The changes aim at adding additional tracepoints variables to help
debuggers attribute them to specific processes.

The PID field uses in_task() to reliably detect when we're in process
context and can safely access current->pid.  When not in process context
(such as in interrupt or in an asynchronous RCU context), the field is set
to -1 as a sentinel value.

Link: https://lkml.kernel.org/r/20260105160423.23708-3-tballasi@linux.microsoft.com
Signed-off-by: Thomas Ballasi <tballasi@linux.microsoft.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |   33 +++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

--- a/include/trace/events/vmscan.h~mm-vmscan-add-pids-to-vmscan-tracepoints
+++ a/include/trace/events/vmscan.h
@@ -121,19 +121,23 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_rec
 	TP_STRUCT__entry(
 		__field(	unsigned long,	gfp_flags	)
 		__field(	int,	order		)
+		__field(	int,	pid		)
 		__field(	unsigned short,	memcg_id	)
 	),
 
 	TP_fast_assign(
 		__entry->gfp_flags	= (__force unsigned long)gfp_flags;
 		__entry->order		= order;
+		__entry->pid		= current->pid;
 		__entry->memcg_id	= memcg_id;
 	),
 
-	TP_printk("order=%d gfp_flags=%s memcg_id=%u",
+	TP_printk("order=%d gfp_flags=%s pid=%d memcg_id=%u %s",
 		__entry->order,
 		show_gfp_flags(__entry->gfp_flags),
-		__entry->memcg_id)
+		__entry->pid,
+		__entry->memcg_id,
++		__event_in_irq() ? "(in-irq)" : "")
 );
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_direct_reclaim_begin,
@@ -167,17 +171,21 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_rec
 
 	TP_STRUCT__entry(
 		__field(	unsigned long,	nr_reclaimed	)
+		__field(	int,	pid		)
 		__field(	unsigned short,	memcg_id	)
 	),
 
 	TP_fast_assign(
 		__entry->nr_reclaimed	= nr_reclaimed;
+		__entry->pid		= current->pid;
 		__entry->memcg_id	= memcg_id;
 	),
 
-	TP_printk("nr_reclaimed=%lu memcg_id=%u",
+	TP_printk("nr_reclaimed=%lu pid=%d memcg_id=%u %s",
 		__entry->nr_reclaimed,
-		__entry->memcg_id)
+		__entry->pid,
+		__entry->memcg_id,
+		__event_in_irq() ? "(in-irq)" : "")
 );
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_direct_reclaim_end,
@@ -222,6 +230,7 @@ TRACE_EVENT(mm_shrink_slab_start,
 		__field(unsigned long, total_scan)
 		__field(int, priority)
 		__field(int, nid)
+		__field(int, pid)
 		__field(unsigned short, memcg_id)
 	),
 
@@ -235,20 +244,23 @@ TRACE_EVENT(mm_shrink_slab_start,
 		__entry->total_scan = total_scan;
 		__entry->priority = priority;
 		__entry->nid = sc->nid;
+		__entry->pid = current->pid;
 		__entry->memcg_id = sc->memcg ? cgroup_id(sc->memcg->css.cgroup) : 0;
 	),
 
-	TP_printk("%pS %p: nid: %d memcg_id: %u objects to shrink %ld gfp_flags %s cache items %ld delta %lld total_scan %ld priority %d",
+	TP_printk("%pS %p: nid: %d pid: %d memcg_id: %u objects to shrink %ld gfp_flags %s cache items %ld delta %lld total_scan %ld priority %d %s",
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
++		__event_in_irq() ? "(in-irq)" : "")
 );
 
 TRACE_EVENT(mm_shrink_slab_end,
@@ -266,29 +278,32 @@ TRACE_EVENT(mm_shrink_slab_end,
 		__field(long, total_scan)
 		__field(int, nid)
 		__field(int, retval)
+		__field(int, pid)
 		__field(unsigned short, memcg_id)
 	),
 
 	TP_fast_assign(
 		__entry->shr = shr;
-		__entry->shrink = shr->scan_objects;
 		__entry->unused_scan = unused_scan_cnt;
 		__entry->new_scan = new_scan_cnt;
 		__entry->total_scan = total_scan;
 		__entry->nid = sc->nid;
 		__entry->retval = shrinker_retval;
+		__entry->pid = current->pid;
 		__entry->memcg_id = cgroup_id(sc->memcg->css.cgroup);
 	),
 
-	TP_printk("%pS %p: nid: %d memcg_id: %u unused scan count %ld new scan count %ld total_scan %ld last shrinker return val %d",
+	TP_printk("%pS %p: nid: %d pid: %d memcg_id: %u unused scan count %ld new scan count %ld total_scan %ld last shrinker return val %d %s",
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
++		__event_in_irq() ? "(in-irq)" : "")
 );
 
 TRACE_EVENT(mm_vmscan_lru_isolate,
_

Patches currently in -mm which might be from tballasi@linux.microsoft.com are

mm-vmscan-add-cgroup-ids-to-vmscan-tracepoints.patch
mm-vmscan-add-pids-to-vmscan-tracepoints.patch

