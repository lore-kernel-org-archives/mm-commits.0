Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F0C36215C
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388604; cv=none; b=PplceEfw6RPBPxkWCAQH8vIejbs9AQiu3mv1MSG2xR6n8m2dQeYdCOLZR+cfEdmzpb2aQM58AhTiSSQBVb+386Ot2yUbM6OdKLKQGXPz1e5homykGgK4fmAvvzer3c5qQu41P7G1I4smPZpiN4XRV0TKiLpstZWQ5bEgVzyRYLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388604; c=relaxed/simple;
	bh=8s8IQLvfBGkA90AohW1hDzDJ0IOtxcTnCrgAzaJZckg=;
	h=Date:To:From:Subject:Message-Id; b=gu5DCyvW5FOTFsNgu8ePLwcmsUNSNP2ykfnFb/RkFZhyDBDZOumoXpl1/otINGMmCIPxDLR3uj7F7daQkVSCXRmUvpNXo4ld2PBTx0Ydh5+gs9M+nTDiyZOhmscKkKRQjfiwBymG892ivgm8mlrAjgTBxbtHX/uKh7AKIZOU3Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oBD3pvmL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oBD3pvmL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87B4C19424;
	Tue, 24 Mar 2026 21:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388603;
	bh=8s8IQLvfBGkA90AohW1hDzDJ0IOtxcTnCrgAzaJZckg=;
	h=Date:To:From:Subject:From;
	b=oBD3pvmLbeZ/1ShOg77K+m71/T/+1zj5d5DqiC3pnN0duWrWjPqCn/N6swJYGQ7R4
	 JIb6HMsLLn/AI9zdS3Neij0HzcE0P7kJXdGVYHA7X80kEJaNdPLvHDDpVSb6zUCSBl
	 xX4t2c295KC2lP+yMQJmi/rFo8A0baww7i2vHfpI=
Date: Tue, 24 Mar 2026 14:43:23 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,rostedt@goodmis.org,mhocko@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@kernel.org,axelrasmussen@google.com,tballasi@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-add-pids-to-vmscan-tracepoints.patch removed from -mm tree
Message-Id: <20260324214323.C87B4C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmscan: add PIDs to vmscan tracepoints
has been removed from the -mm tree.  Its filename was
     mm-vmscan-add-pids-to-vmscan-tracepoints.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


