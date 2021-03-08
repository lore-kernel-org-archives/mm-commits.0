Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47A15C43381
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 23:09:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23F2B60C3D
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 23:09:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhCHXI5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Mar 2021 18:08:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:34300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231140AbhCHXIb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Mar 2021 18:08:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD8816529C;
        Mon,  8 Mar 2021 23:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615244911;
        bh=Ivh10E9pn01q5Rg/ZwVEQ2PGJNHrsklrCrpf+NjhYTo=;
        h=Date:From:To:Subject:From;
        b=z6qgQWWAG3tDfzdTsPKn6s5WJDZG+Lj3gha09wRYNBoBhanofMLDbpbLNoKHcrFEC
         ekiNew+IojwgrnnSVfGrkCWTGQcLBqJJ4A04fnSA4/ZuhiAshfFJ0UuVAL1Yp9+zl/
         DdFJeBVFnyLZF1gctOR11xrQ/AEDvf57m9yspvxE=
Date:   Mon, 08 Mar 2021 15:08:30 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com, mkoutny@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org
Subject:  + mm-memcontrol-switch-to-rstat.patch added to -mm tree
Message-ID: <20210308230830.DlU9FdQ9E%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: switch to rstat
has been added to the -mm tree.  Its filename is
     mm-memcontrol-switch-to-rstat.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-switch-to-rstat=
.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-switch-to-rstat=
.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: switch to rstat

Replace the memory controller's custom hierarchical stats code with the
generic rstat infrastructure provided by the cgroup core.

The current implementation does batched upward propagation from the write
side (i.e.  as stats change).  The per-cpu batches introduce an error,
which is multiplied by the number of subgroups in a tree.  In systems with
many CPUs and sizable cgroup trees, the error can be large enough to
confuse users (e.g.  32 batch pages * 32 CPUs * 32 subgroups results in an
error of up to 128M per stat item).  This can entirely swallow allocation
bursts inside a workload that the user is expecting to see reflected in
the statistics.

In the past, we've done read-side aggregation, where a memory.stat read
would have to walk the entire subtree and add up per-cpu counts.  This
became problematic with lazily-freed cgroups: we could have large subtrees
where most cgroups were entirely idle.  Hence the switch to change-driven
upward propagation.  Unfortunately, it needed to trade accuracy for speed
due to the write side being so hot.

Rstat combines the best of both worlds: from the write side, it cheaply
maintains a queue of cgroups that have pending changes, so that the read
side can do selective tree aggregation.  This way the reported stats will
always be precise and recent as can be, while the aggregation can skip
over potentially large numbers of idle cgroups.

The way rstat works is that it implements a tree for tracking cgroups with
pending local changes, as well as a flush function that walks the tree
upwards.  The controller then drives this by 1) telling rstat when a local
cgroup stat changes (e.g.  mod_memcg_state) and 2) when a flush is
required to get uptodate hierarchy stats for a given subtree (e.g.  when
memory.stat is read).  The controller also provides a flush callback that
is called during the rstat flush walk for each cgroup and aggregates its
local per-cpu counters and propagates them upwards.

This adds a second vmstats to struct mem_cgroup (MEMCG_NR_STAT +
NR_VM_EVENT_ITEMS) to track pending subtree deltas during upward
aggregation.  It removes 3 words from the per-cpu data.  It eliminates
memcg_exact_page_state(), since memcg_page_state() is now exact.

Link: https://lkml.kernel.org/r/20210209163304.77088-7-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Michal Koutn=C3=BD <mkoutny@suse.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   67 ++++++----
 mm/memcontrol.c            |  223 ++++++++++++++---------------------
 2 files changed, 132 insertions(+), 158 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-switch-to-rstat
+++ a/include/linux/memcontrol.h
@@ -76,10 +76,27 @@ enum mem_cgroup_events_target {
 };
=20
 struct memcg_vmstats_percpu {
-	long stat[MEMCG_NR_STAT];
-	unsigned long events[NR_VM_EVENT_ITEMS];
-	unsigned long nr_page_events;
-	unsigned long targets[MEM_CGROUP_NTARGETS];
+	/* Local (CPU and cgroup) page state & events */
+	long			state[MEMCG_NR_STAT];
+	unsigned long		events[NR_VM_EVENT_ITEMS];
+
+	/* Delta calculation for lockless upward propagation */
+	long			state_prev[MEMCG_NR_STAT];
+	unsigned long		events_prev[NR_VM_EVENT_ITEMS];
+
+	/* Cgroup1: threshold notifications & softlimit tree updates */
+	unsigned long		nr_page_events;
+	unsigned long		targets[MEM_CGROUP_NTARGETS];
+};
+
+struct memcg_vmstats {
+	/* Aggregated (CPU and subtree) page state & events */
+	long			state[MEMCG_NR_STAT];
+	unsigned long		events[NR_VM_EVENT_ITEMS];
+
+	/* Pending child counts during tree propagation */
+	long			state_pending[MEMCG_NR_STAT];
+	unsigned long		events_pending[NR_VM_EVENT_ITEMS];
 };
=20
 struct mem_cgroup_reclaim_iter {
@@ -287,8 +304,8 @@ struct mem_cgroup {
=20
 	MEMCG_PADDING(_pad1_);
=20
-	atomic_long_t		vmstats[MEMCG_NR_STAT];
-	atomic_long_t		vmevents[NR_VM_EVENT_ITEMS];
+	/* memory.stat */
+	struct memcg_vmstats	vmstats;
=20
 	/* memory.events */
 	atomic_long_t		memory_events[MEMCG_NR_MEMORY_EVENTS];
@@ -315,10 +332,6 @@ struct mem_cgroup {
 	atomic_t		moving_account;
 	struct task_struct	*move_lock_task;
=20
-	/* Legacy local VM stats and events */
-	struct memcg_vmstats_percpu __percpu *vmstats_local;
-
-	/* Subtree VM stats and events (batched updates) */
 	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
=20
 #ifdef CONFIG_CGROUP_WRITEBACK
@@ -942,10 +955,6 @@ static inline void mod_memcg_lruvec_stat
 	local_irq_restore(flags);
 }
=20
-unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
-						gfp_t gfp_mask,
-						unsigned long *total_scanned);
-
 void __count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
 			  unsigned long count);
=20
@@ -1026,6 +1035,10 @@ static inline void memcg_memory_event_mm
=20
 void split_page_memcg(struct page *head, unsigned int nr);
=20
+unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
+						gfp_t gfp_mask,
+						unsigned long *total_scanned);
+
 #else /* CONFIG_MEMCG */
=20
 #define MEM_CGROUP_ID_SHIFT	0
@@ -1144,6 +1157,10 @@ static inline bool lruvec_holds_page_lru
 	return lruvec =3D=3D &pgdat->__lruvec;
 }
=20
+static inline void lruvec_memcg_debug(struct lruvec *lruvec, struct page *=
page)
+{
+}
+
 static inline struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memc=
g)
 {
 	return NULL;
@@ -1347,18 +1364,6 @@ static inline void mod_lruvec_kmem_state
 	mod_node_page_state(page_pgdat(page), idx, val);
 }
=20
-static inline
-unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
-					    gfp_t gfp_mask,
-					    unsigned long *total_scanned)
-{
-	return 0;
-}
-
-static inline void split_page_memcg(struct page *head, unsigned int nr)
-{
-}
-
 static inline void count_memcg_events(struct mem_cgroup *memcg,
 				      enum vm_event_item idx,
 				      unsigned long count)
@@ -1381,9 +1386,17 @@ void count_memcg_event_mm(struct mm_stru
 {
 }
=20
-static inline void lruvec_memcg_debug(struct lruvec *lruvec, struct page *=
page)
+static inline void split_page_memcg(struct page *head)
 {
 }
+
+static inline
+unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
+					    gfp_t gfp_mask,
+					    unsigned long *total_scanned)
+{
+	return 0;
+}
 #endif /* CONFIG_MEMCG */
=20
 static inline void __inc_lruvec_kmem_state(void *p, enum node_stat_item id=
x)
--- a/mm/memcontrol.c~mm-memcontrol-switch-to-rstat
+++ a/mm/memcontrol.c
@@ -757,6 +757,11 @@ mem_cgroup_largest_soft_limit_node(struc
 	return mz;
 }
=20
+static void memcg_flush_vmstats(struct mem_cgroup *memcg)
+{
+	cgroup_rstat_flush(memcg->css.cgroup);
+}
+
 /**
  * __mod_memcg_state - update cgroup memory statistics
  * @memcg: the memory cgroup
@@ -765,37 +770,17 @@ mem_cgroup_largest_soft_limit_node(struc
  */
 void __mod_memcg_state(struct mem_cgroup *memcg, int idx, int val)
 {
-	long x, threshold =3D MEMCG_CHARGE_BATCH;
-
 	if (mem_cgroup_disabled())
 		return;
=20
-	if (memcg_stat_item_in_bytes(idx))
-		threshold <<=3D PAGE_SHIFT;
-
-	x =3D val + __this_cpu_read(memcg->vmstats_percpu->stat[idx]);
-	if (unlikely(abs(x) > threshold)) {
-		struct mem_cgroup *mi;
-
-		/*
-		 * Batch local counters to keep them in sync with
-		 * the hierarchical ones.
-		 */
-		__this_cpu_add(memcg->vmstats_local->stat[idx], x);
-		for (mi =3D memcg; mi; mi =3D parent_mem_cgroup(mi))
-			atomic_long_add(x, &mi->vmstats[idx]);
-		x =3D 0;
-	}
-	__this_cpu_write(memcg->vmstats_percpu->stat[idx], x);
+	__this_cpu_add(memcg->vmstats_percpu->state[idx], val);
+	cgroup_rstat_updated(memcg->css.cgroup, smp_processor_id());
 }
=20
-/*
- * idx can be of type enum memcg_stat_item or node_stat_item.
- * Keep in sync with memcg_exact_page_state().
- */
+/* idx can be of type enum memcg_stat_item or node_stat_item. */
 static unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
 {
-	long x =3D atomic_long_read(&memcg->vmstats[idx]);
+	long x =3D READ_ONCE(memcg->vmstats.state[idx]);
 #ifdef CONFIG_SMP
 	if (x < 0)
 		x =3D 0;
@@ -803,17 +788,14 @@ static unsigned long memcg_page_state(st
 	return x;
 }
=20
-/*
- * idx can be of type enum memcg_stat_item or node_stat_item.
- * Keep in sync with memcg_exact_page_state().
- */
+/* idx can be of type enum memcg_stat_item or node_stat_item. */
 static unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int =
idx)
 {
 	long x =3D 0;
 	int cpu;
=20
 	for_each_possible_cpu(cpu)
-		x +=3D per_cpu(memcg->vmstats_local->stat[idx], cpu);
+		x +=3D per_cpu(memcg->vmstats_percpu->state[idx], cpu);
 #ifdef CONFIG_SMP
 	if (x < 0)
 		x =3D 0;
@@ -936,30 +918,16 @@ void __mod_lruvec_kmem_state(void *p, en
 void __count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
 			  unsigned long count)
 {
-	unsigned long x;
-
 	if (mem_cgroup_disabled())
 		return;
=20
-	x =3D count + __this_cpu_read(memcg->vmstats_percpu->events[idx]);
-	if (unlikely(x > MEMCG_CHARGE_BATCH)) {
-		struct mem_cgroup *mi;
-
-		/*
-		 * Batch local counters to keep them in sync with
-		 * the hierarchical ones.
-		 */
-		__this_cpu_add(memcg->vmstats_local->events[idx], x);
-		for (mi =3D memcg; mi; mi =3D parent_mem_cgroup(mi))
-			atomic_long_add(x, &mi->vmevents[idx]);
-		x =3D 0;
-	}
-	__this_cpu_write(memcg->vmstats_percpu->events[idx], x);
+	__this_cpu_add(memcg->vmstats_percpu->events[idx], count);
+	cgroup_rstat_updated(memcg->css.cgroup, smp_processor_id());
 }
=20
 static unsigned long memcg_events(struct mem_cgroup *memcg, int event)
 {
-	return atomic_long_read(&memcg->vmevents[event]);
+	return READ_ONCE(memcg->vmstats.events[event]);
 }
=20
 static unsigned long memcg_events_local(struct mem_cgroup *memcg, int even=
t)
@@ -968,7 +936,7 @@ static unsigned long memcg_events_local(
 	int cpu;
=20
 	for_each_possible_cpu(cpu)
-		x +=3D per_cpu(memcg->vmstats_local->events[event], cpu);
+		x +=3D per_cpu(memcg->vmstats_percpu->events[event], cpu);
 	return x;
 }
=20
@@ -1604,6 +1572,7 @@ static char *memory_stat_format(struct m
 	 *
 	 * Current memory state:
 	 */
+	memcg_flush_vmstats(memcg);
=20
 	for (i =3D 0; i < ARRAY_SIZE(memory_stats); i++) {
 		u64 size;
@@ -2409,22 +2378,11 @@ static int memcg_hotplug_cpu_dead(unsign
 	drain_stock(stock);
=20
 	for_each_mem_cgroup(memcg) {
-		struct memcg_vmstats_percpu *statc;
 		int i;
=20
-		statc =3D per_cpu_ptr(memcg->vmstats_percpu, cpu);
-
-		for (i =3D 0; i < MEMCG_NR_STAT; i++) {
+		for (i =3D 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
 			int nid;
=20
-			if (statc->stat[i]) {
-				mod_memcg_state(memcg, i, statc->stat[i]);
-				statc->stat[i] =3D 0;
-			}
-
-			if (i >=3D NR_VM_NODE_STAT_ITEMS)
-				continue;
-
 			for_each_node(nid) {
 				struct batched_lruvec_stat *lstatc;
 				struct mem_cgroup_per_node *pn;
@@ -2443,13 +2401,6 @@ static int memcg_hotplug_cpu_dead(unsign
 				}
 			}
 		}
-
-		for (i =3D 0; i < NR_VM_EVENT_ITEMS; i++) {
-			if (statc->events[i]) {
-				count_memcg_events(memcg, i, statc->events[i]);
-				statc->events[i] =3D 0;
-			}
-		}
 	}
=20
 	return 0;
@@ -3572,6 +3523,7 @@ static unsigned long mem_cgroup_usage(st
 	unsigned long val;
=20
 	if (mem_cgroup_is_root(memcg)) {
+		memcg_flush_vmstats(memcg);
 		val =3D memcg_page_state(memcg, NR_FILE_PAGES) +
 			memcg_page_state(memcg, NR_ANON_MAPPED);
 		if (swap)
@@ -3636,26 +3588,15 @@ static u64 mem_cgroup_read_u64(struct cg
 	}
 }
=20
-static void memcg_flush_percpu_vmstats(struct mem_cgroup *memcg)
+static void memcg_flush_lruvec_page_state(struct mem_cgroup *memcg)
 {
-	unsigned long stat[MEMCG_NR_STAT] =3D {0};
-	struct mem_cgroup *mi;
-	int node, cpu, i;
-
-	for_each_online_cpu(cpu)
-		for (i =3D 0; i < MEMCG_NR_STAT; i++)
-			stat[i] +=3D per_cpu(memcg->vmstats_percpu->stat[i], cpu);
-
-	for (mi =3D memcg; mi; mi =3D parent_mem_cgroup(mi))
-		for (i =3D 0; i < MEMCG_NR_STAT; i++)
-			atomic_long_add(stat[i], &mi->vmstats[i]);
+	int node;
=20
 	for_each_node(node) {
 		struct mem_cgroup_per_node *pn =3D memcg->nodeinfo[node];
+		unsigned long stat[NR_VM_NODE_STAT_ITEMS] =3D { 0 };
 		struct mem_cgroup_per_node *pi;
-
-		for (i =3D 0; i < NR_VM_NODE_STAT_ITEMS; i++)
-			stat[i] =3D 0;
+		int cpu, i;
=20
 		for_each_online_cpu(cpu)
 			for (i =3D 0; i < NR_VM_NODE_STAT_ITEMS; i++)
@@ -3668,25 +3609,6 @@ static void memcg_flush_percpu_vmstats(s
 	}
 }
=20
-static void memcg_flush_percpu_vmevents(struct mem_cgroup *memcg)
-{
-	unsigned long events[NR_VM_EVENT_ITEMS];
-	struct mem_cgroup *mi;
-	int cpu, i;
-
-	for (i =3D 0; i < NR_VM_EVENT_ITEMS; i++)
-		events[i] =3D 0;
-
-	for_each_online_cpu(cpu)
-		for (i =3D 0; i < NR_VM_EVENT_ITEMS; i++)
-			events[i] +=3D per_cpu(memcg->vmstats_percpu->events[i],
-					     cpu);
-
-	for (mi =3D memcg; mi; mi =3D parent_mem_cgroup(mi))
-		for (i =3D 0; i < NR_VM_EVENT_ITEMS; i++)
-			atomic_long_add(events[i], &mi->vmevents[i]);
-}
-
 #ifdef CONFIG_MEMCG_KMEM
 static int memcg_online_kmem(struct mem_cgroup *memcg)
 {
@@ -4003,6 +3925,8 @@ static int memcg_numa_stat_show(struct s
 	int nid;
 	struct mem_cgroup *memcg =3D mem_cgroup_from_seq(m);
=20
+	memcg_flush_vmstats(memcg);
+
 	for (stat =3D stats; stat < stats + ARRAY_SIZE(stats); stat++) {
 		seq_printf(m, "%s=3D%lu", stat->name,
 			   mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
@@ -4073,6 +3997,8 @@ static int memcg_stat_show(struct seq_fi
=20
 	BUILD_BUG_ON(ARRAY_SIZE(memcg1_stat_names) !=3D ARRAY_SIZE(memcg1_stats));
=20
+	memcg_flush_vmstats(memcg);
+
 	for (i =3D 0; i < ARRAY_SIZE(memcg1_stats); i++) {
 		unsigned long nr;
=20
@@ -4549,22 +4475,6 @@ struct wb_domain *mem_cgroup_wb_domain(s
 	return &memcg->cgwb_domain;
 }
=20
-/*
- * idx can be of type enum memcg_stat_item or node_stat_item.
- * Keep in sync with memcg_exact_page().
- */
-static unsigned long memcg_exact_page_state(struct mem_cgroup *memcg, int =
idx)
-{
-	long x =3D atomic_long_read(&memcg->vmstats[idx]);
-	int cpu;
-
-	for_each_online_cpu(cpu)
-		x +=3D per_cpu_ptr(memcg->vmstats_percpu, cpu)->stat[idx];
-	if (x < 0)
-		x =3D 0;
-	return x;
-}
-
 /**
  * mem_cgroup_wb_stats - retrieve writeback related stats from its memcg
  * @wb: bdi_writeback in question
@@ -4590,13 +4500,14 @@ void mem_cgroup_wb_stats(struct bdi_writ
 	struct mem_cgroup *memcg =3D mem_cgroup_from_css(wb->memcg_css);
 	struct mem_cgroup *parent;
=20
-	*pdirty =3D memcg_exact_page_state(memcg, NR_FILE_DIRTY);
+	memcg_flush_vmstats(memcg);
=20
-	*pwriteback =3D memcg_exact_page_state(memcg, NR_WRITEBACK);
-	*pfilepages =3D memcg_exact_page_state(memcg, NR_INACTIVE_FILE) +
-			memcg_exact_page_state(memcg, NR_ACTIVE_FILE);
-	*pheadroom =3D PAGE_COUNTER_MAX;
+	*pdirty =3D memcg_page_state(memcg, NR_FILE_DIRTY);
+	*pwriteback =3D memcg_page_state(memcg, NR_WRITEBACK);
+	*pfilepages =3D memcg_page_state(memcg, NR_INACTIVE_FILE) +
+			memcg_page_state(memcg, NR_ACTIVE_FILE);
=20
+	*pheadroom =3D PAGE_COUNTER_MAX;
 	while ((parent =3D parent_mem_cgroup(memcg))) {
 		unsigned long ceiling =3D min(READ_ONCE(memcg->memory.max),
 					    READ_ONCE(memcg->memory.high));
@@ -5228,7 +5139,6 @@ static void __mem_cgroup_free(struct mem
 	for_each_node(node)
 		free_mem_cgroup_per_node_info(memcg, node);
 	free_percpu(memcg->vmstats_percpu);
-	free_percpu(memcg->vmstats_local);
 	kfree(memcg);
 }
=20
@@ -5236,11 +5146,10 @@ static void mem_cgroup_free(struct mem_c
 {
 	memcg_wb_domain_exit(memcg);
 	/*
-	 * Flush percpu vmstats and vmevents to guarantee the value correctness
-	 * on parent's and all ancestor levels.
+	 * Flush percpu lruvec stats to guarantee the value
+	 * correctness on parent's and all ancestor levels.
 	 */
-	memcg_flush_percpu_vmstats(memcg);
-	memcg_flush_percpu_vmevents(memcg);
+	memcg_flush_lruvec_page_state(memcg);
 	__mem_cgroup_free(memcg);
 }
=20
@@ -5267,11 +5176,6 @@ static struct mem_cgroup *mem_cgroup_all
 		goto fail;
 	}
=20
-	memcg->vmstats_local =3D alloc_percpu_gfp(struct memcg_vmstats_percpu,
-						GFP_KERNEL_ACCOUNT);
-	if (!memcg->vmstats_local)
-		goto fail;
-
 	memcg->vmstats_percpu =3D alloc_percpu_gfp(struct memcg_vmstats_percpu,
 						 GFP_KERNEL_ACCOUNT);
 	if (!memcg->vmstats_percpu)
@@ -5471,6 +5375,62 @@ static void mem_cgroup_css_reset(struct
 	memcg_wb_domain_size_changed(memcg);
 }
=20
+static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, in=
t cpu)
+{
+	struct mem_cgroup *memcg =3D mem_cgroup_from_css(css);
+	struct mem_cgroup *parent =3D parent_mem_cgroup(memcg);
+	struct memcg_vmstats_percpu *statc;
+	long delta, v;
+	int i;
+
+	statc =3D per_cpu_ptr(memcg->vmstats_percpu, cpu);
+
+	for (i =3D 0; i < MEMCG_NR_STAT; i++) {
+		/*
+		 * Collect the aggregated propagation counts of groups
+		 * below us. We're in a per-cpu loop here and this is
+		 * a global counter, so the first cycle will get them.
+		 */
+		delta =3D memcg->vmstats.state_pending[i];
+		if (delta)
+			memcg->vmstats.state_pending[i] =3D 0;
+
+		/* Add CPU changes on this level since the last flush */
+		v =3D READ_ONCE(statc->state[i]);
+		if (v !=3D statc->state_prev[i]) {
+			delta +=3D v - statc->state_prev[i];
+			statc->state_prev[i] =3D v;
+		}
+
+		if (!delta)
+			continue;
+
+		/* Aggregate counts on this level and propagate upwards */
+		memcg->vmstats.state[i] +=3D delta;
+		if (parent)
+			parent->vmstats.state_pending[i] +=3D delta;
+	}
+
+	for (i =3D 0; i < NR_VM_EVENT_ITEMS; i++) {
+		delta =3D memcg->vmstats.events_pending[i];
+		if (delta)
+			memcg->vmstats.events_pending[i] =3D 0;
+
+		v =3D READ_ONCE(statc->events[i]);
+		if (v !=3D statc->events_prev[i]) {
+			delta +=3D v - statc->events_prev[i];
+			statc->events_prev[i] =3D v;
+		}
+
+		if (!delta)
+			continue;
+
+		memcg->vmstats.events[i] +=3D delta;
+		if (parent)
+			parent->vmstats.events_pending[i] +=3D delta;
+	}
+}
+
 #ifdef CONFIG_MMU
 /* Handlers for move charge at task migration. */
 static int mem_cgroup_do_precharge(unsigned long count)
@@ -6524,6 +6484,7 @@ struct cgroup_subsys memory_cgrp_subsys
 	.css_released =3D mem_cgroup_css_released,
 	.css_free =3D mem_cgroup_css_free,
 	.css_reset =3D mem_cgroup_css_reset,
+	.css_rstat_flush =3D mem_cgroup_css_rstat_flush,
 	.can_attach =3D mem_cgroup_can_attach,
 	.cancel_attach =3D mem_cgroup_cancel_attach,
 	.post_attach =3D mem_cgroup_move_task,
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page-writeback-simplify-memcg-handling-in-test_clear_page_writeback.patch
mm-memcontrol-fix-cpuhotplug-statistics-flushing.patch
mm-memcontrol-kill-mem_cgroup_nodeinfo.patch
mm-memcontrol-privatize-memcg_page_state-query-functions.patch
cgroup-rstat-support-cgroup1.patch
cgroup-rstat-punt-root-level-optimization-to-individual-controllers.patch
mm-memcontrol-switch-to-rstat.patch
mm-memcontrol-consolidate-lruvec-stat-flushing.patch
kselftests-cgroup-update-kmem-test-for-new-vmstat-implementation.patch

