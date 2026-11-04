Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793818475;
	b=tRyy3BnBWP0dkHu+YKrj1PmFWFGmY5b7TpnM9Ot9K0TYQqXQ1oAn7gLtz4B1CBwXf2eZ
	 JDcJHFm7i9KqLcjRGl3KYrpixH9E2n2grw+5EKkSaaYFuYnVlGjUQPtPMByfKFOCmamkr
	 eCsZJTZed3tMF0Y2tbShN4nQIbQk0gkonsRawBJNl7tmXIfi8BwkEeOKj18ko/xiECwfY
	 RSg3MuwFsGtMVQY0tx8OFtsYb90DsGL4smx3tvW5IjHVuwaMD2HR1XLpJ6Iq9+9MyfTUn
	 HjBuOezohh7ZDlbHsGkb3cmpirSRUXczHe7wqxYYiYxEZHv3OHDQjgNl/HS2JBKZhXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793818475;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=FK7zAIY7UNrVs4KL6a8RlxWhNF1ZUHjZDR3QQNjkUVw=;
	b=faJmhGGMroh6M2GIQ3WcJDtLVJ+aGzJXQtkgRbHTAHygdq3wnTooMO3FtZZ3ZSDDLUy8
	 TXwqiXB4ppkl173SCNUI/jJEPXZpeSg4WnMHsr69cIsV4NgoMoGchCyAjb5NVKB39oqck
	 im2W2moGywKIF/aLMkjbjy4oFnWt6otkX8C7ejA1B5PV+RPUgQKNAB1ISdc2db5UvvXSL
	 VSW2F2Xm+/G3jT2vo4PghaF4vfs4EPfkcJMC/LGcC/Rnj8yp0NvNKiMR1Zj+jjXoOqmD6
	 K90Kvge+KEWLe/jtEAa6VgJZRSVhr/wZqkupaYajlqWVanlbSnpH0Moi2L4g2P2CCaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=A3w7ycst;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7756082BD7
	for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2026 18:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=A3w7ycst
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA891F00A24;
	Wed,  4 Nov 2026 18:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793818475;
	bh=FK7zAIY7UNrVs4KL6a8RlxWhNF1ZUHjZDR3QQNjkUVw=;
	h=Date:To:From:Subject;
	b=A3w7ycstoiAJhQVI+8nEbK32JbBudtBNN6ynAGdxrm224q7ivfe1k1xImWRit3nbP
	 Vj3yj9bMtIWW+r7W0KJTcWzPj3J+waLSAtzntCYW6VP12cQaZwm09Y1JkuH7LI7P+k
	 Ts3cAKRA3xVULq5J3OB4ONYgkEOOqk82X81xfLjA=
Date: Wed, 04 Nov 2026 10:54:34 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,
	shakeel.butt@linux.dev,rostedt@goodmis.org,roman.gushchin@linux.dev,
	ridong.chen@linux.dev,qi.zheng@linux.dev,muchun.song@linux.dev,
	mhocko@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,
	ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,
	david@fromorbit.com,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,
	baohua@kernel.org,axelrasmussen@google.com,chenridong@xiaomi.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-pass-scan_control-to-the-vmscan-tracepoints.patch added to mm-new branch
Message-Id: <20261104185435.0FA891F00A24@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/vmscan: pass scan_control to the vmscan tracepoints
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-pass-scan_control-to-the-vmscan-tracepoints.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-pass-scan_control-to-the-vmscan-tracepoints.patch

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
From: Ridong Chen <chenridong@xiaomi.com>
Subject: mm/vmscan: pass scan_control to the vmscan tracepoints
Date: Wed, 04 Nov 2026 21:08:14 +0800

Several vmscan tracepoints spell out reclaim state as individual
arguments, all of which the caller already holds in struct scan_control.
Now that the struct is visible from the trace header, pass sc directly
and pick the fields out in TP_fast_assign instead of spelling them out
at every callsite:

- mm_vmscan_direct_reclaim_begin, mm_vmscan_memcg_reclaim_begin and
  mm_vmscan_node_reclaim_begin: gfp_mask and order.

- mm_vmscan_lru_isolate, mm_vmscan_lru_shrink_inactive and
  mm_vmscan_lru_shrink_active: reclaim_idx, order and priority.

- mm_vmscan_reclaim_pages: nr_scanned. nr_reclaimed stays a separate
  argument: it is the return value of shrink_folio_list(), which does
  not update sc->nr_reclaimed.

- mm_vmscan_balance_pgdat_end: order and nr_reclaimed. highest_zoneidx
  stays a separate argument: it is a balance_pgdat() parameter, and
  sc.reclaim_idx may differ from it by the time the end event fires.

No functional change. The tracefs event format (TP_STRUCT__entry and
TP_printk) is unchanged, so tracefs-based consumers are unaffected.
BPF programs attached via raw_tp/tp_btf see the new TP_PROTO and need
to be adjusted; tracepoints are not a stable ABI (see
Documentation/bpf/bpf_design_QA.rst).

Link: https://lore.kernel.org/20261104130817.849089-5-ridong.chen@linux.dev
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Ridong Chen <ridong.chen@linux.dev>
---

 mm/trace_vmscan.h |   74 +++++++++++++++++++++-----------------------
 mm/vmscan.c       |   26 +++++++--------
 2 files changed, 48 insertions(+), 52 deletions(-)

--- a/mm/trace_vmscan.h~mm-vmscan-pass-scan_control-to-the-vmscan-tracepoints
+++ a/mm/trace_vmscan.h
@@ -124,10 +124,9 @@ TRACE_EVENT(mm_vmscan_balance_pgdat_begi
 
 TRACE_EVENT(mm_vmscan_balance_pgdat_end,
 
-	TP_PROTO(int nid, int order, int highest_zoneidx,
-		 unsigned long nr_reclaimed),
+	TP_PROTO(int nid, struct scan_control *sc, int highest_zoneidx),
 
-	TP_ARGS(nid, order, highest_zoneidx, nr_reclaimed),
+	TP_ARGS(nid, sc, highest_zoneidx),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
@@ -138,9 +137,9 @@ TRACE_EVENT(mm_vmscan_balance_pgdat_end,
 
 	TP_fast_assign(
 		__entry->nid = nid;
-		__entry->order = order;
+		__entry->order = sc->order;
 		__entry->highest_zoneidx = highest_zoneidx;
-		__entry->nr_reclaimed = nr_reclaimed;
+		__entry->nr_reclaimed = sc->nr_reclaimed;
 	),
 
 	TP_printk("nid=%d order=%d highest_zoneidx=%-8s nr_reclaimed=%lu",
@@ -178,9 +177,9 @@ TRACE_EVENT(mm_vmscan_wakeup_kswapd,
 
 DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
 
-	TP_PROTO(gfp_t gfp_flags, int order, struct mem_cgroup *memcg),
+	TP_PROTO(struct scan_control *sc, struct mem_cgroup *memcg),
 
-	TP_ARGS(gfp_flags, order, memcg),
+	TP_ARGS(sc, memcg),
 
 	TP_STRUCT__entry(
 		__field(	unsigned long,	gfp_flags	)
@@ -189,8 +188,8 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_rec
 	),
 
 	TP_fast_assign(
-		__entry->gfp_flags	= (__force unsigned long)gfp_flags;
-		__entry->order		= order;
+		__entry->gfp_flags	= (__force unsigned long)sc->gfp_mask;
+		__entry->order		= sc->order;
 		__entry->memcg_id	= mem_cgroup_id(memcg);
 	),
 
@@ -204,17 +203,17 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_rec
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_direct_reclaim_begin,
 
-	TP_PROTO(gfp_t gfp_flags, int order, struct mem_cgroup *memcg),
+	TP_PROTO(struct scan_control *sc, struct mem_cgroup *memcg),
 
-	TP_ARGS(gfp_flags, order, memcg)
+	TP_ARGS(sc, memcg)
 );
 
 #ifdef CONFIG_MEMCG
 DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_reclaim_begin,
 
-	TP_PROTO(gfp_t gfp_flags, int order, struct mem_cgroup *memcg),
+	TP_PROTO(struct scan_control *sc, struct mem_cgroup *memcg),
 
-	TP_ARGS(gfp_flags, order, memcg)
+	TP_ARGS(sc, memcg)
 );
 #endif /* CONFIG_MEMCG */
 
@@ -350,15 +349,14 @@ TRACE_EVENT(mm_shrink_slab_end,
 );
 
 TRACE_EVENT(mm_vmscan_lru_isolate,
-	TP_PROTO(int highest_zoneidx,
-		int order,
-		unsigned long nr_requested,
-		unsigned long nr_scanned,
-		unsigned long nr_skipped,
-		unsigned long nr_taken,
-		int lru),
+	TP_PROTO(struct scan_control *sc,
+		 unsigned long nr_requested,
+		 unsigned long nr_scanned,
+		 unsigned long nr_skipped,
+		 unsigned long nr_taken,
+		 int lru),
 
-	TP_ARGS(highest_zoneidx, order, nr_requested, nr_scanned, nr_skipped, nr_taken, lru),
+	TP_ARGS(sc, nr_requested, nr_scanned, nr_skipped, nr_taken, lru),
 
 	TP_STRUCT__entry(
 		__field(int, highest_zoneidx)
@@ -371,8 +369,8 @@ TRACE_EVENT(mm_vmscan_lru_isolate,
 	),
 
 	TP_fast_assign(
-		__entry->highest_zoneidx = highest_zoneidx;
-		__entry->order = order;
+		__entry->highest_zoneidx = sc->reclaim_idx;
+		__entry->order = sc->order;
 		__entry->nr_requested = nr_requested;
 		__entry->nr_scanned = nr_scanned;
 		__entry->nr_skipped = nr_skipped;
@@ -419,11 +417,11 @@ TRACE_EVENT(mm_vmscan_write_folio,
 
 TRACE_EVENT(mm_vmscan_reclaim_pages,
 
-	TP_PROTO(int nid,
-		unsigned long nr_scanned, unsigned long nr_reclaimed,
-		struct reclaim_stat *stat),
+	TP_PROTO(int nid, struct scan_control *sc,
+		 unsigned long nr_reclaimed,
+		 struct reclaim_stat *stat),
 
-	TP_ARGS(nid, nr_scanned, nr_reclaimed, stat),
+	TP_ARGS(nid, sc, nr_reclaimed, stat),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
@@ -441,7 +439,7 @@ TRACE_EVENT(mm_vmscan_reclaim_pages,
 
 	TP_fast_assign(
 		__entry->nid = nid;
-		__entry->nr_scanned = nr_scanned;
+		__entry->nr_scanned = sc->nr_scanned;
 		__entry->nr_reclaimed = nr_reclaimed;
 		__entry->nr_dirty = stat->nr_dirty;
 		__entry->nr_writeback = stat->nr_writeback;
@@ -466,9 +464,9 @@ TRACE_EVENT(mm_vmscan_lru_shrink_inactiv
 
 	TP_PROTO(int nid,
 		unsigned long nr_scanned, unsigned long nr_reclaimed,
-		struct reclaim_stat *stat, int priority, int file),
+		struct reclaim_stat *stat, struct scan_control *sc, int file),
 
-	TP_ARGS(nid, nr_scanned, nr_reclaimed, stat, priority, file),
+	TP_ARGS(nid, nr_scanned, nr_reclaimed, stat, sc, file),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
@@ -498,7 +496,7 @@ TRACE_EVENT(mm_vmscan_lru_shrink_inactiv
 		__entry->nr_activate1 = stat->nr_activate[1];
 		__entry->nr_ref_keep = stat->nr_ref_keep;
 		__entry->nr_unmap_fail = stat->nr_unmap_fail;
-		__entry->priority = priority;
+		__entry->priority = sc->priority;
 		__entry->reclaim_flags = trace_reclaim_flags(file);
 	),
 
@@ -517,9 +515,9 @@ TRACE_EVENT(mm_vmscan_lru_shrink_active,
 
 	TP_PROTO(int nid, unsigned long nr_taken,
 		unsigned long nr_active, unsigned long nr_deactivated,
-		unsigned long nr_referenced, int priority, int file),
+		unsigned long nr_referenced, struct scan_control *sc, int file),
 
-	TP_ARGS(nid, nr_taken, nr_active, nr_deactivated, nr_referenced, priority, file),
+	TP_ARGS(nid, nr_taken, nr_active, nr_deactivated, nr_referenced, sc, file),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
@@ -537,7 +535,7 @@ TRACE_EVENT(mm_vmscan_lru_shrink_active,
 		__entry->nr_active = nr_active;
 		__entry->nr_deactivated = nr_deactivated;
 		__entry->nr_referenced = nr_referenced;
-		__entry->priority = priority;
+		__entry->priority = sc->priority;
 		__entry->reclaim_flags = trace_reclaim_flags(file);
 	),
 
@@ -551,9 +549,9 @@ TRACE_EVENT(mm_vmscan_lru_shrink_active,
 
 TRACE_EVENT(mm_vmscan_node_reclaim_begin,
 
-	TP_PROTO(int nid, int order, gfp_t gfp_flags),
+	TP_PROTO(int nid, struct scan_control *sc),
 
-	TP_ARGS(nid, order, gfp_flags),
+	TP_ARGS(nid, sc),
 
 	TP_STRUCT__entry(
 		__field(int, nid)
@@ -563,8 +561,8 @@ TRACE_EVENT(mm_vmscan_node_reclaim_begin
 
 	TP_fast_assign(
 		__entry->nid = nid;
-		__entry->order = order;
-		__entry->gfp_flags = (__force unsigned long)gfp_flags;
+		__entry->order = sc->order;
+		__entry->gfp_flags = (__force unsigned long)sc->gfp_mask;
 	),
 
 	TP_printk("nid=%d order=%d gfp_flags=%s",
--- a/mm/vmscan.c~mm-vmscan-pass-scan_control-to-the-vmscan-tracepoints
+++ a/mm/vmscan.c
@@ -1765,7 +1765,7 @@ move:
 		}
 	}
 	*nr_scanned = total_scan;
-	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
+	trace_mm_vmscan_lru_isolate(sc, nr_to_scan,
 				    total_scan, skipped, nr_taken, lru);
 	update_lru_sizes(lruvec, lru, nr_zone_taken);
 	return nr_taken;
@@ -2055,7 +2055,7 @@ static unsigned long shrink_inactive_lis
 
 	handle_reclaim_writeback(nr_taken, pgdat, sc, &stat);
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
-			nr_scanned, nr_reclaimed, &stat, sc->priority, file);
+			nr_scanned, nr_reclaimed, &stat, sc, file);
 	return nr_reclaimed;
 }
 
@@ -2162,7 +2162,7 @@ static void shrink_active_list(unsigned
 		mod_lruvec_state(lruvec, PGROTATE_ANON + file, nr_rotated);
 
 	trace_mm_vmscan_lru_shrink_active(pgdat->node_id, nr_taken, nr_activate,
-			nr_deactivate, nr_rotated, sc->priority, file);
+			nr_deactivate, nr_rotated, sc, file);
 }
 
 static unsigned int reclaim_folio_list(struct list_head *folio_list,
@@ -2185,7 +2185,7 @@ static unsigned int reclaim_folio_list(s
 		list_del(&folio->lru);
 		folio_putback_lru(folio);
 	}
-	trace_mm_vmscan_reclaim_pages(pgdat->node_id, sc.nr_scanned, nr_reclaimed, &stat);
+	trace_mm_vmscan_reclaim_pages(pgdat->node_id, &sc, nr_reclaimed, &stat);
 
 	return nr_reclaimed;
 }
@@ -4799,9 +4799,9 @@ static int scan_folios(unsigned long nr_
 	mod_lruvec_state(lruvec, item, isolated);
 	mod_lruvec_state(lruvec, PGREFILL, sorted);
 	mod_lruvec_state(lruvec, PGSCAN_ANON + type, isolated);
-	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
-				scanned, skipped, isolated,
-				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
+	trace_mm_vmscan_lru_isolate(sc, nr_to_scan,
+				    scanned, skipped, isolated,
+				    type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
 	*isolatedp = isolated;
 	return scanned;
@@ -4943,7 +4943,7 @@ retry:
 	if (isolated)
 		handle_reclaim_writeback(isolated, pgdat, sc, &stat);
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
-			type_scanned, reclaimed, &stat, sc->priority,
+			type_scanned, reclaimed, &stat, sc,
 			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
 	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
@@ -6835,7 +6835,7 @@ unsigned long try_to_free_pages(struct z
 		return 1;
 
 	set_task_reclaim_state(current, &sc.reclaim_state);
-	trace_mm_vmscan_direct_reclaim_begin(sc.gfp_mask, order, NULL);
+	trace_mm_vmscan_direct_reclaim_begin(&sc, NULL);
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
 
@@ -6876,7 +6876,7 @@ unsigned long try_to_free_mem_cgroup_pag
 	struct zonelist *zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
 
 	set_task_reclaim_state(current, &sc.reclaim_state);
-	trace_mm_vmscan_memcg_reclaim_begin(sc.gfp_mask, 0, memcg);
+	trace_mm_vmscan_memcg_reclaim_begin(&sc, memcg);
 	noreclaim_flag = memalloc_noreclaim_save();
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
@@ -7353,8 +7353,7 @@ out:
 	psi_memstall_leave(&pflags);
 	set_task_reclaim_state(current, NULL);
 
-	trace_mm_vmscan_balance_pgdat_end(pgdat->node_id, sc.order,
-					  highest_zoneidx, sc.nr_reclaimed);
+	trace_mm_vmscan_balance_pgdat_end(pgdat->node_id, &sc, highest_zoneidx);
 
 	/*
 	 * Return the order kswapd stopped reclaiming at as
@@ -7832,8 +7831,7 @@ static unsigned long __node_reclaim(stru
 	unsigned int noreclaim_flag;
 	unsigned long pflags;
 
-	trace_mm_vmscan_node_reclaim_begin(pgdat->node_id, sc->order,
-					   sc->gfp_mask);
+	trace_mm_vmscan_node_reclaim_begin(pgdat->node_id, sc);
 
 	cond_resched();
 	if (!sc->proactive)
_

Patches currently in -mm which might be from chenridong@xiaomi.com are

mm-migrate-move-nr_file_thps-on-cross-node-migration.patch
mm-migrate-move-nr_kernel_file_pages-on-cross-node-migration.patch
mm-memcontrol-drop-unused-vmscan-tracepoint-include.patch
mm-vmscan-move-vmscan-tracepoints-to-a-local-header.patch
mm-vmscan-move-struct-scan_control-to-a-dedicated-header.patch
mm-vmscan-pass-scan_control-to-the-vmscan-tracepoints.patch
mm-mglru-add-tracepoint-for-scan_folios.patch
mm-mglru-add-lruvec_gen_size-helper.patch
mm-mglru-add-tracepoint-for-aging.patch

