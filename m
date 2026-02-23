Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1970E366838
	for <mm-commits@vger.kernel.org>; Mon, 23 Feb 2026 18:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771871588; cv=none; b=hdAi8+XsfCo4qg7Ls7Pe+NgqjrawNQ0C7qhxMz3x/PPSD9zQiKU1+p0gRAZiK4Ja3eT4PMNaG1tLm9gXEzci4dNBxLQEE3bWtn2KlHzHN/kPkQfOvs/zv/KbvpRvPBA7425l7r9gawdUg4k8wfSH6sgwR3kgU1sPykdcGboOs5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771871588; c=relaxed/simple;
	bh=3PfRAGTq3BRoh91PNwoxcx2HvewLDPCNuOzqo77+HNY=;
	h=Date:To:From:Subject:Message-Id; b=I9HrEVwwbqMXEiWWxrKzJpxL2YrXg5GxjPG4bb9AxIL37DsP9ONh27DFoQRLLbFk56KCUU1S4AK8Ry5oOg3eM2Op5EZ7+zWHPwMbPjYxjYQmir23atCTLnhDQxXcVX0lerslDGAL3ptAs35rCTd8o9rIDm8eQWxBIQ4E02xnj+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KTYlSTo9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KTYlSTo9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F124C116D0;
	Mon, 23 Feb 2026 18:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771871587;
	bh=3PfRAGTq3BRoh91PNwoxcx2HvewLDPCNuOzqo77+HNY=;
	h=Date:To:From:Subject:From;
	b=KTYlSTo9SyI3ndN4QrDYLrMcN1NKEa15gLxFidM3NZb9k7vRDAyWjBr/A4UejCEek
	 aVcI5ulftIAZwtF0yCNajBk/25eL2UHTVaZu9xWr6jRviTwXCQYM7oprl9N/c3PnuN
	 wj8DbskMgFAC7Pux30nX04t871W8KA7cHiOUvNpg=
Date: Mon, 23 Feb 2026 10:33:07 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,rostedt@goodmis.org,mhocko@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@kernel.org,axelrasmussen@google.com,tballasi@linux.microsoft.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-add-cgroup-ids-to-vmscan-tracepoints.patch added to mm-new branch
Message-Id: <20260223183307.9F124C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: add cgroup IDs to vmscan tracepoints
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-add-cgroup-ids-to-vmscan-tracepoints.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-add-cgroup-ids-to-vmscan-tracepoints.patch

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
Subject: mm: vmscan: add cgroup IDs to vmscan tracepoints
Date: Mon, 23 Feb 2026 09:15:43 -0800

Memory reclaim events are currently difficult to attribute to specific
cgroups, making debugging memory pressure issues challenging.  This patch
adds memory cgroup ID (memcg_id) to key vmscan tracepoints to enable
better correlation and analysis.

For operations not associated with a specific cgroup, the field is
defaulted to 0.

Link: https://lkml.kernel.org/r/20260223171544.4750-3-tballasi@linux.microsoft.com
Signed-off-by: Thomas Ballasi <tballasi@linux.microsoft.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/vmscan.h |   83 ++++++++++++++++++--------------
 mm/shrinker.c                 |    6 +-
 mm/vmscan.c                   |   17 +++---
 3 files changed, 61 insertions(+), 45 deletions(-)

--- a/include/trace/events/vmscan.h~mm-vmscan-add-cgroup-ids-to-vmscan-tracepoints
+++ a/include/trace/events/vmscan.h
@@ -124,85 +124,92 @@ TRACE_EVENT(mm_vmscan_wakeup_kswapd,
 
 DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_begin_template,
 
-	TP_PROTO(int order, gfp_t gfp_flags),
+	TP_PROTO(gfp_t gfp_flags, int order, struct mem_cgroup *memcg),
 
-	TP_ARGS(order, gfp_flags),
+	TP_ARGS(gfp_flags, order, memcg),
 
 	TP_STRUCT__entry(
-		__field(	int,	order		)
 		__field(	unsigned long,	gfp_flags	)
+		__field(	u64,	memcg_id	)
+		__field(	int,	order		)
 	),
 
 	TP_fast_assign(
-		__entry->order		= order;
 		__entry->gfp_flags	= (__force unsigned long)gfp_flags;
+		__entry->order		= order;
+		__entry->memcg_id	= mem_cgroup_id(memcg);
 	),
 
-	TP_printk("order=%d gfp_flags=%s",
+	TP_printk("order=%d gfp_flags=%s memcg_id=%llu",
 		__entry->order,
-		show_gfp_flags(__entry->gfp_flags))
+		show_gfp_flags(__entry->gfp_flags),
+		__entry->memcg_id)
 );
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_direct_reclaim_begin,
 
-	TP_PROTO(int order, gfp_t gfp_flags),
+	TP_PROTO(gfp_t gfp_flags, int order, struct mem_cgroup *memcg),
 
-	TP_ARGS(order, gfp_flags)
+	TP_ARGS(gfp_flags, order, memcg)
 );
 
 #ifdef CONFIG_MEMCG
 DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_reclaim_begin,
 
-	TP_PROTO(int order, gfp_t gfp_flags),
+	TP_PROTO(gfp_t gfp_flags, int order, struct mem_cgroup *memcg),
 
-	TP_ARGS(order, gfp_flags)
+	TP_ARGS(gfp_flags, order, memcg)
 );
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_softlimit_reclaim_begin,
 
-	TP_PROTO(int order, gfp_t gfp_flags),
+	TP_PROTO(gfp_t gfp_flags, int order, struct mem_cgroup *memcg),
 
-	TP_ARGS(order, gfp_flags)
+	TP_ARGS(gfp_flags, order, memcg)
 );
 #endif /* CONFIG_MEMCG */
 
 DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_end_template,
 
-	TP_PROTO(unsigned long nr_reclaimed),
+	TP_PROTO(unsigned long nr_reclaimed, struct mem_cgroup *memcg),
 
-	TP_ARGS(nr_reclaimed),
+	TP_ARGS(nr_reclaimed, memcg),
 
 	TP_STRUCT__entry(
 		__field(	unsigned long,	nr_reclaimed	)
+		__field(	u64,	memcg_id	)
 	),
 
 	TP_fast_assign(
 		__entry->nr_reclaimed	= nr_reclaimed;
+		__entry->memcg_id	= mem_cgroup_id(memcg);
 	),
 
-	TP_printk("nr_reclaimed=%lu", __entry->nr_reclaimed)
+	TP_printk("nr_reclaimed=%lu memcg_id=%llu",
+		__entry->nr_reclaimed,
+		__entry->memcg_id)
 );
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_direct_reclaim_end,
 
-	TP_PROTO(unsigned long nr_reclaimed),
+	TP_PROTO(unsigned long nr_reclaimed, struct mem_cgroup *memcg),
 
-	TP_ARGS(nr_reclaimed)
+	TP_ARGS(nr_reclaimed, memcg)
 );
 
 #ifdef CONFIG_MEMCG
 DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_memcg_reclaim_end,
 
-	TP_PROTO(unsigned long nr_reclaimed),
+	TP_PROTO(unsigned long nr_reclaimed, struct mem_cgroup *memcg),
 
-	TP_ARGS(nr_reclaimed)
+	TP_ARGS(nr_reclaimed, memcg)
 );
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_memcg_softlimit_reclaim_end,
 
-	TP_PROTO(unsigned long nr_reclaimed),
+	TP_PROTO(unsigned long nr_reclaimed, struct mem_cgroup *memcg),
 
-	TP_ARGS(nr_reclaimed)
+	TP_ARGS(nr_reclaimed, memcg)
 );
 #endif /* CONFIG_MEMCG */
 
@@ -210,39 +217,42 @@ TRACE_EVENT(mm_shrink_slab_start,
 	TP_PROTO(struct shrinker *shr, struct shrink_control *sc,
 		long nr_objects_to_shrink, unsigned long cache_items,
 		unsigned long long delta, unsigned long total_scan,
-		int priority),
+		int priority, struct mem_cgroup *memcg),
 
 	TP_ARGS(shr, sc, nr_objects_to_shrink, cache_items, delta, total_scan,
-		priority),
+		priority, memcg),
 
 	TP_STRUCT__entry(
 		__field(struct shrinker *, shr)
 		__field(void *, shrink)
-		__field(int, nid)
 		__field(long, nr_objects_to_shrink)
 		__field(unsigned long, gfp_flags)
 		__field(unsigned long, cache_items)
 		__field(unsigned long long, delta)
 		__field(unsigned long, total_scan)
 		__field(int, priority)
+		__field(int, nid)
+		__field(u64, memcg_id)
 	),
 
 	TP_fast_assign(
 		__entry->shr = shr;
 		__entry->shrink = shr->scan_objects;
-		__entry->nid = sc->nid;
 		__entry->nr_objects_to_shrink = nr_objects_to_shrink;
 		__entry->gfp_flags = (__force unsigned long)sc->gfp_mask;
 		__entry->cache_items = cache_items;
 		__entry->delta = delta;
 		__entry->total_scan = total_scan;
 		__entry->priority = priority;
+		__entry->nid = sc->nid;
+		__entry->memcg_id = mem_cgroup_id(memcg);
 	),
 
-	TP_printk("%pS %p: nid: %d objects to shrink %ld gfp_flags %s cache items %ld delta %lld total_scan %ld priority %d",
+	TP_printk("%pS %p: nid: %d memcg_id: %llu objects to shrink %ld gfp_flags %s cache items %ld delta %lld total_scan %ld priority %d",
 		__entry->shrink,
 		__entry->shr,
 		__entry->nid,
+		__entry->memcg_id,
 		__entry->nr_objects_to_shrink,
 		show_gfp_flags(__entry->gfp_flags),
 		__entry->cache_items,
@@ -253,35 +263,38 @@ TRACE_EVENT(mm_shrink_slab_start,
 
 TRACE_EVENT(mm_shrink_slab_end,
 	TP_PROTO(struct shrinker *shr, int nid, int shrinker_retval,
-		long unused_scan_cnt, long new_scan_cnt, long total_scan),
+		long unused_scan_cnt, long new_scan_cnt, long total_scan, struct mem_cgroup *memcg),
 
 	TP_ARGS(shr, nid, shrinker_retval, unused_scan_cnt, new_scan_cnt,
-		total_scan),
+		total_scan, memcg),
 
 	TP_STRUCT__entry(
 		__field(struct shrinker *, shr)
-		__field(int, nid)
 		__field(void *, shrink)
 		__field(long, unused_scan)
 		__field(long, new_scan)
-		__field(int, retval)
 		__field(long, total_scan)
+		__field(int, nid)
+		__field(int, retval)
+		__field(u64, memcg_id)
 	),
 
 	TP_fast_assign(
 		__entry->shr = shr;
-		__entry->nid = nid;
 		__entry->shrink = shr->scan_objects;
 		__entry->unused_scan = unused_scan_cnt;
 		__entry->new_scan = new_scan_cnt;
-		__entry->retval = shrinker_retval;
 		__entry->total_scan = total_scan;
+		__entry->nid = nid;
+		__entry->retval = shrinker_retval;
+		__entry->memcg_id = mem_cgroup_id(memcg);
 	),
 
-	TP_printk("%pS %p: nid: %d unused scan count %ld new scan count %ld total_scan %ld last shrinker return val %d",
+	TP_printk("%pS %p: nid: %d memcg_id: %llu unused scan count %ld new scan count %ld total_scan %ld last shrinker return val %d",
 		__entry->shrink,
 		__entry->shr,
 		__entry->nid,
+		__entry->memcg_id,
 		__entry->unused_scan,
 		__entry->new_scan,
 		__entry->total_scan,
@@ -514,9 +527,9 @@ TRACE_EVENT(mm_vmscan_node_reclaim_begin
 
 DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_node_reclaim_end,
 
-	TP_PROTO(unsigned long nr_reclaimed),
+	TP_PROTO(unsigned long nr_reclaimed, struct mem_cgroup *memcg),
 
-	TP_ARGS(nr_reclaimed)
+	TP_ARGS(nr_reclaimed, memcg)
 );
 
 TRACE_EVENT(mm_vmscan_throttled,
--- a/mm/shrinker.c~mm-vmscan-add-cgroup-ids-to-vmscan-tracepoints
+++ a/mm/shrinker.c
@@ -410,7 +410,8 @@ static unsigned long do_shrink_slab(stru
 	total_scan = min(total_scan, (2 * freeable));
 
 	trace_mm_shrink_slab_start(shrinker, shrinkctl, nr,
-				   freeable, delta, total_scan, priority);
+				   freeable, delta, total_scan, priority,
+				   shrinkctl->memcg);
 
 	/*
 	 * Normally, we should not scan less than batch_size objects in one
@@ -461,7 +462,8 @@ static unsigned long do_shrink_slab(stru
 	 */
 	new_nr = add_nr_deferred(next_deferred, shrinker, shrinkctl);
 
-	trace_mm_shrink_slab_end(shrinker, shrinkctl->nid, freed, nr, new_nr, total_scan);
+	trace_mm_shrink_slab_end(shrinker, shrinkctl->nid, freed, nr, new_nr, total_scan,
+				 shrinkctl->memcg);
 	return freed;
 }
 
--- a/mm/vmscan.c~mm-vmscan-add-cgroup-ids-to-vmscan-tracepoints
+++ a/mm/vmscan.c
@@ -6578,11 +6578,11 @@ unsigned long try_to_free_pages(struct z
 		return 1;
 
 	set_task_reclaim_state(current, &sc.reclaim_state);
-	trace_mm_vmscan_direct_reclaim_begin(order, sc.gfp_mask);
+	trace_mm_vmscan_direct_reclaim_begin(sc.gfp_mask, order, 0);
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
 
-	trace_mm_vmscan_direct_reclaim_end(nr_reclaimed);
+	trace_mm_vmscan_direct_reclaim_end(nr_reclaimed, 0);
 	set_task_reclaim_state(current, NULL);
 
 	return nr_reclaimed;
@@ -6611,8 +6611,9 @@ unsigned long mem_cgroup_shrink_node(str
 	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
 			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
 
-	trace_mm_vmscan_memcg_softlimit_reclaim_begin(sc.order,
-						      sc.gfp_mask);
+	trace_mm_vmscan_memcg_softlimit_reclaim_begin(sc.gfp_mask,
+						      sc.order,
+						      memcg);
 
 	/*
 	 * NOTE: Although we can get the priority field, using it
@@ -6623,7 +6624,7 @@ unsigned long mem_cgroup_shrink_node(str
 	 */
 	shrink_lruvec(lruvec, &sc);
 
-	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed);
+	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed, memcg);
 
 	*nr_scanned = sc.nr_scanned;
 
@@ -6659,13 +6660,13 @@ unsigned long try_to_free_mem_cgroup_pag
 	struct zonelist *zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
 
 	set_task_reclaim_state(current, &sc.reclaim_state);
-	trace_mm_vmscan_memcg_reclaim_begin(0, sc.gfp_mask);
+	trace_mm_vmscan_memcg_reclaim_begin(sc.gfp_mask, 0, memcg);
 	noreclaim_flag = memalloc_noreclaim_save();
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
 
 	memalloc_noreclaim_restore(noreclaim_flag);
-	trace_mm_vmscan_memcg_reclaim_end(nr_reclaimed);
+	trace_mm_vmscan_memcg_reclaim_end(nr_reclaimed, memcg);
 	set_task_reclaim_state(current, NULL);
 
 	return nr_reclaimed;
@@ -7639,7 +7640,7 @@ static unsigned long __node_reclaim(stru
 	delayacct_freepages_end();
 	psi_memstall_leave(&pflags);
 
-	trace_mm_vmscan_node_reclaim_end(sc->nr_reclaimed);
+	trace_mm_vmscan_node_reclaim_end(sc->nr_reclaimed, 0);
 
 	return sc->nr_reclaimed;
 }
_

Patches currently in -mm which might be from tballasi@linux.microsoft.com are

mm-vmscan-add-cgroup-ids-to-vmscan-tracepoints.patch
mm-vmscan-add-pids-to-vmscan-tracepoints.patch

