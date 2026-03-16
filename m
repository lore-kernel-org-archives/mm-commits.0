Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4A733291F
	for <mm-commits@vger.kernel.org>; Mon, 16 Mar 2026 16:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773679628; cv=none; b=YEClgf253yTN1wvrXFtDk61k763XUZ0ka7R8n9ad7bWPFrwYmPsIgm2h+gRoBwLXq4kR9EnFy3hQUlsFw0eVaCPbuI9ayCL0SscQi+Z31jW3PcFuapibRuXUSp1l2abm3IwFOzJa9T+yMacJnTBWSPhOdLjVCN1LwsL91LUSEeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773679628; c=relaxed/simple;
	bh=RFKA6sxHBJnU1WyrUKjN0BAeI0crB2lo7rLgBcB4/zw=;
	h=Date:To:From:Subject:Message-Id; b=VvqiZv56B4dPS3bCtyvcXBLek51oHzxOG8DElMq8ceCEBmnx/kVxOvavFLx7MzXeMkq0WuxrlL+h0n1mcA/wJ5GW3lErfX61qDKo6yiNOMrQYbXmGHBdhJM615Neo33XRkXccXBa8I20AwPTS/JHO2N9ZK1I5U84oOX8i6gfwJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s2jL0oex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s2jL0oex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272C3C19421;
	Mon, 16 Mar 2026 16:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773679628;
	bh=RFKA6sxHBJnU1WyrUKjN0BAeI0crB2lo7rLgBcB4/zw=;
	h=Date:To:From:Subject:From;
	b=s2jL0oexegUuOGIPeS3IOfSqGRsgKVxQCZXzYTvkFVhMJjEXYxAxoHWPw03TMyT6S
	 sROekSwLCq8GyY6EXdhRCYNBi19gOf+RQbkL3CO/ojoTlsI0syfpgxFxClS3QBsONK
	 ytxzwMeavsLwEUzG+b7dFAXAy/plFd8Fm5QEGq5g=
Date: Mon, 16 Mar 2026 09:47:07 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,rostedt@goodmis.org,mhocko@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@kernel.org,axelrasmussen@google.com,tballasi@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-add-pids-to-vmscan-tracepoints.patch added to mm-unstable branch
Message-Id: <20260316164708.272C3C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: add PIDs to vmscan tracepoints
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-add-pids-to-vmscan-tracepoints.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-add-pids-to-vmscan-tracepoints.patch

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
From: Thomas Ballasi <tballasi@linux.microsoft.com>
Subject: mm: vmscan: add PIDs to vmscan tracepoints
Date: Mon, 16 Mar 2026 09:09:08 -0700

The changes aims at adding additionnal tracepoints variables to help
debuggers attribute them to specific processes.

Link: https://lkml.kernel.org/r/20260316160908.42727-4-tballasi@linux.microsoft.com
Signed-off-by: Thomas Ballasi <tballasi@linux.microsoft.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

--- a/include/trace/events/vmscan.h~mm-vmscan-add-pids-to-vmscan-tracepoints
+++ a/include/trace/events/vmscan.h
@@ -140,10 +140,12 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_rec
 		__entry->memcg_id	= mem_cgroup_id(memcg);
 	),
 
-	TP_printk("order=%d gfp_flags=%s memcg_id=%llu",
+	TP_printk("order=%d gfp_flags=%s pid=%d memcg_id=%llu %s",
 		__entry->order,
 		show_gfp_flags(__entry->gfp_flags),
-		__entry->memcg_id)
+		__entry->ent.pid,
+		__entry->memcg_id,
+		__event_in_irq() ? "(in-irq)" : "")
 );
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_direct_reclaim_begin,
@@ -185,9 +187,11 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_rec
 		__entry->memcg_id	= mem_cgroup_id(memcg);
 	),
 
-	TP_printk("nr_reclaimed=%lu memcg_id=%llu",
+	TP_printk("nr_reclaimed=%lu pid=%d memcg_id=%llu %s",
 		__entry->nr_reclaimed,
-		__entry->memcg_id)
+		__entry->ent.pid,
+		__entry->memcg_id,
+		__event_in_irq() ? "(in-irq)" : "")
 );
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_direct_reclaim_end,
@@ -248,17 +252,19 @@ TRACE_EVENT(mm_shrink_slab_start,
 		__entry->memcg_id = mem_cgroup_id(memcg);
 	),
 
-	TP_printk("%pS %p: nid: %d memcg_id: %llu objects to shrink %ld gfp_flags %s cache items %ld delta %lld total_scan %ld priority %d",
+	TP_printk("%pS %p: nid: %d pid: %d memcg_id: %llu objects to shrink %ld gfp_flags %s cache items %ld delta %lld total_scan %ld priority %d %s",
 		__entry->shrink,
 		__entry->shr,
 		__entry->nid,
+		__entry->ent.pid,
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
@@ -290,15 +296,17 @@ TRACE_EVENT(mm_shrink_slab_end,
 		__entry->memcg_id = mem_cgroup_id(memcg);
 	),
 
-	TP_printk("%pS %p: nid: %d memcg_id: %llu unused scan count %ld new scan count %ld total_scan %ld last shrinker return val %d",
+	TP_printk("%pS %p: nid: %d pid: %d memcg_id: %llu unused scan count %ld new scan count %ld total_scan %ld last shrinker return val %d %s",
 		__entry->shrink,
 		__entry->shr,
 		__entry->nid,
+		__entry->ent.pid,
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

