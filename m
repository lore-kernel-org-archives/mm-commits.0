Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66723E716D
	for <mm-commits@vger.kernel.org>; Sat, 28 Feb 2026 19:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772305708; cv=none; b=Yb6fv9HRhY1iPkfa85SnKkw0oQjtN5Qjk4v4tvhNv10kgdFgHZkdYkjDwY/ci1aFFUmLQdLK4YQgM7LTOpd0G6jQp96IjZlF2ulv//Rs2NOV7gxMw64Gqc4rKdOwmI6F8ZH5wchA1gKBUNoztIEd26KTh2MG0KWP8HAfQIK+/aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772305708; c=relaxed/simple;
	bh=vhcfrt76TYnFDreHHsUWvFT5RQnBgncW7CKQMs8jFS4=;
	h=Date:To:From:Subject:Message-Id; b=O7DLtcjXtFAU/RZFE7ae/oF0R7XlD9rtifurWjye0+3AVIWy8QmbWSRBcpHJK476OARnjXxsjH65YB3VGyDkkjE82teM4bRSX7YqvFYIVK5jIzUlzoIMwH/N+c10FcrlzXUCM2OOp34YkDujm2kC+g9TaGJI969hnXF0HVg+qfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XHyrJvw8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XHyrJvw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFE4C116D0;
	Sat, 28 Feb 2026 19:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772305708;
	bh=vhcfrt76TYnFDreHHsUWvFT5RQnBgncW7CKQMs8jFS4=;
	h=Date:To:From:Subject:From;
	b=XHyrJvw8aJ6G6wnqO2uQsZeqJmi1WfN1u9CkyWg91ipfz99I8zDBS4t3mHa1/diaZ
	 U92Q5KcdmSyXt0+6z7nGJzAX1L/z26IwYAl5bzptsfL5th9N2xxl6Rwfq+YfJYoQ00
	 0bbJ4YaFcOVupgFA6vlh8z89s9gp+qDf35oY87jQ=
Date: Sat, 28 Feb 2026 11:08:27 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,yosry@kernel.org,weixugc@google.com,usamaarif642@gmail.com,tj@kernel.org,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,lorenzo.stoakes@oracle.com,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,chenridong@huawei.com,chengming.zhou@linux.dev,bhe@redhat.com,axelrasmussen@google.com,apais@linux.microsoft.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-prepare-for-reparenting-non-hierarchical-stats-update.patch added to mm-new branch
Message-Id: <20260228190828.2CFE4C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memcontrol-prepare-for-reparenting-non-hierarchical-stats-update
has been added to the -mm mm-new branch.  Its filename is
     mm-memcontrol-prepare-for-reparenting-non-hierarchical-stats-update.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-prepare-for-reparenting-non-hierarchical-stats-update.patch

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm-memcontrol-prepare-for-reparenting-non-hierarchical-stats-update
Date: Sat, 28 Feb 2026 15:25:56 +0800

Link: https://lkml.kernel.org/r/20260228072556.31793-1-qi.zheng@linux.dev
Co-developed-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Allen Pais <apais@linux.microsoft.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chen Ridong <chenridong@huawei.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Imran Khan <imran.f.khan@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kamalesh Babulal <kamalesh.babulal@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    1 
 mm/memcontrol-v1.h         |    1 
 mm/memcontrol.c            |   89 ++++++++++++++++++++++++++---------
 3 files changed, 68 insertions(+), 23 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-prepare-for-reparenting-non-hierarchical-stats-update
+++ a/include/linux/memcontrol.h
@@ -956,7 +956,6 @@ static inline void mod_memcg_page_state(
 
 unsigned long memcg_events(struct mem_cgroup *memcg, int event);
 unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx);
-
 unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
 bool memcg_stat_item_valid(int idx);
 bool memcg_vm_event_item_valid(enum vm_event_item idx);
--- a/mm/memcontrol.c~mm-memcontrol-prepare-for-reparenting-non-hierarchical-stats-update
+++ a/mm/memcontrol.c
@@ -234,11 +234,19 @@ static inline void reparent_state_local(
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return;
 
+	/*
+	 * Reparent stats exposed non-hierarchically. Flush @memcg's stats first
+	 * to read its stats accurately , and conservatively flush @parent's
+	 * stats after reparenting to avoid hiding a potentially large stat
+	 * update (e.g. from callers of mem_cgroup_flush_stats_ratelimited()).
+	 */
 	__mem_cgroup_flush_stats(memcg, true);
 
 	/* The following counts are all non-hierarchical and need to be reparented. */
 	reparent_memcg1_state_local(memcg, parent);
 	reparent_memcg1_lruvec_state_local(memcg, parent);
+
+	__mem_cgroup_flush_stats(parent, true);
 }
 #else
 static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
@@ -442,7 +450,7 @@ struct lruvec_stats {
 	long state[NR_MEMCG_NODE_STAT_ITEMS];
 
 	/* Non-hierarchical (CPU aggregated) state */
-	atomic_long_t state_local[NR_MEMCG_NODE_STAT_ITEMS];
+	long state_local[NR_MEMCG_NODE_STAT_ITEMS];
 
 	/* Pending child counts during tree propagation */
 	long state_pending[NR_MEMCG_NODE_STAT_ITEMS];
@@ -485,7 +493,7 @@ unsigned long lruvec_page_state_local(st
 		return 0;
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	x = atomic_long_read(&(pn->lruvec_stats->state_local[i]));
+	x = READ_ONCE(pn->lruvec_stats->state_local[i]);
 #ifdef CONFIG_SMP
 	if (x < 0)
 		x = 0;
@@ -494,6 +502,9 @@ unsigned long lruvec_page_state_local(st
 }
 
 #ifdef CONFIG_MEMCG_V1
+static void __mod_memcg_lruvec_state(struct lruvec *lruvec,
+				     enum node_stat_item idx, int val);
+
 void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
 				       struct mem_cgroup *parent, int idx)
 {
@@ -506,12 +517,10 @@ void reparent_memcg_lruvec_state_local(s
 	for_each_node(nid) {
 		struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 		struct lruvec *parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
-		struct mem_cgroup_per_node *parent_pn;
 		unsigned long value = lruvec_page_state_local(child_lruvec, idx);
 
-		parent_pn = container_of(parent_lruvec, struct mem_cgroup_per_node, lruvec);
-
-		atomic_long_add(value, &(parent_pn->lruvec_stats->state_local[i]));
+		__mod_memcg_lruvec_state(child_lruvec, idx, -value);
+		__mod_memcg_lruvec_state(parent_lruvec, idx, value);
 	}
 }
 #endif
@@ -598,7 +607,7 @@ struct memcg_vmstats {
 	unsigned long		events[NR_MEMCG_EVENTS];
 
 	/* Non-hierarchical (CPU aggregated) page state & events */
-	atomic_long_t		state_local[MEMCG_VMSTAT_SIZE];
+	long			state_local[MEMCG_VMSTAT_SIZE];
 	unsigned long		events_local[NR_MEMCG_EVENTS];
 
 	/* Pending child counts during tree propagation */
@@ -835,7 +844,7 @@ unsigned long memcg_page_state_local(str
 	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return 0;
 
-	x = atomic_long_read(&(memcg->vmstats->state_local[i]));
+	x = READ_ONCE(memcg->vmstats->state_local[i]);
 #ifdef CONFIG_SMP
 	if (x < 0)
 		x = 0;
@@ -843,6 +852,51 @@ unsigned long memcg_page_state_local(str
 	return x;
 }
 
+static void __mod_memcg_state(struct mem_cgroup *memcg,
+			      enum memcg_stat_item idx, int val)
+{
+	int i = memcg_stats_index(idx);
+	int cpu;
+
+	if (mem_cgroup_disabled())
+		return;
+
+	cpu = get_cpu();
+
+	this_cpu_add(memcg->vmstats_percpu->state[i], val);
+	val = memcg_state_val_in_pages(idx, val);
+	memcg_rstat_updated(memcg, val, cpu);
+	trace_mod_memcg_state(memcg, idx, val);
+
+	put_cpu();
+}
+
+static void __mod_memcg_lruvec_state(struct lruvec *lruvec,
+				     enum node_stat_item idx, int val)
+{
+	struct mem_cgroup_per_node *pn;
+	struct mem_cgroup *memcg;
+	int i = memcg_stats_index(idx);
+	int cpu;
+
+	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	memcg = pn->memcg;
+
+	cpu = get_cpu();
+
+	/* Update memcg */
+	this_cpu_add(memcg->vmstats_percpu->state[i], val);
+
+	/* Update lruvec */
+	this_cpu_add(pn->lruvec_stats_percpu->state[i], val);
+
+	val = memcg_state_val_in_pages(idx, val);
+	memcg_rstat_updated(memcg, val, cpu);
+	trace_mod_memcg_lruvec_state(memcg, idx, val);
+
+	put_cpu();
+}
+
 void reparent_memcg_state_local(struct mem_cgroup *memcg,
 				struct mem_cgroup *parent, int idx)
 {
@@ -852,7 +906,8 @@ void reparent_memcg_state_local(struct m
 	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return;
 
-	atomic_long_add(value, &(parent->vmstats->state_local[i]));
+	__mod_memcg_state(memcg, idx, -value);
+	__mod_memcg_state(parent, idx, value);
 }
 #endif
 
@@ -4174,8 +4229,6 @@ struct aggregate_control {
 	long *aggregate;
 	/* pointer to the non-hierarchichal (CPU aggregated) counters */
 	long *local;
-	/* pointer to the atomic non-hierarchichal (CPU aggregated) counters */
-	atomic_long_t *alocal;
 	/* pointer to the pending child counters during tree propagation */
 	long *pending;
 	/* pointer to the parent's pending counters, could be NULL */
@@ -4213,12 +4266,8 @@ static void mem_cgroup_stat_aggregate(st
 		}
 
 		/* Aggregate counts on this level and propagate upwards */
-		if (delta_cpu) {
-			if (ac->local)
-				ac->local[i] += delta_cpu;
-			else if (ac->alocal)
-				atomic_long_add(delta_cpu, &(ac->alocal[i]));
-		}
+		if (delta_cpu)
+			ac->local[i] += delta_cpu;
 
 		if (delta) {
 			ac->aggregate[i] += delta;
@@ -4289,8 +4338,7 @@ static void mem_cgroup_css_rstat_flush(s
 
 	ac = (struct aggregate_control) {
 		.aggregate = memcg->vmstats->state,
-		.local = NULL,
-		.alocal = memcg->vmstats->state_local,
+		.local = memcg->vmstats->state_local,
 		.pending = memcg->vmstats->state_pending,
 		.ppending = parent ? parent->vmstats->state_pending : NULL,
 		.cstat = statc->state,
@@ -4323,8 +4371,7 @@ static void mem_cgroup_css_rstat_flush(s
 
 		ac = (struct aggregate_control) {
 			.aggregate = lstats->state,
-			.local = NULL,
-			.alocal = lstats->state_local,
+			.local = lstats->state_local,
 			.pending = lstats->state_pending,
 			.ppending = plstats ? plstats->state_pending : NULL,
 			.cstat = lstatc->state,
--- a/mm/memcontrol-v1.h~mm-memcontrol-prepare-for-reparenting-non-hierarchical-stats-update
+++ a/mm/memcontrol-v1.h
@@ -45,7 +45,6 @@ static inline bool do_memsw_account(void
 
 unsigned long memcg_events_local(struct mem_cgroup *memcg, int event);
 unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx);
-void mod_memcg_page_state_local(struct mem_cgroup *memcg, int idx, unsigned long val);
 unsigned long memcg_page_state_local_output(struct mem_cgroup *memcg, int item);
 bool memcg1_alloc_events(struct mem_cgroup *memcg);
 void memcg1_free_events(struct mem_cgroup *memcg);
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-vmscan-prepare-for-the-refactoring-the-move_folios_to_lru.patch
mm-thp-prevent-memory-cgroup-release-in-folio_split_queue_lock_irqsave.patch
mm-zswap-prevent-memory-cgroup-release-in-zswap_compress.patch
mm-do-not-open-code-lruvec-lock.patch
mm-vmscan-prepare-for-reparenting-traditional-lru-folios.patch
mm-vmscan-prepare-for-reparenting-mglru-folios.patch
mm-memcontrol-refactor-memcg_reparent_objcgs.patch
mm-workingset-use-lruvec_lru_size-to-get-the-number-of-lru-pages.patch
mm-memcontrol-prepare-for-reparenting-non-hierarchical-stats.patch
mm-memcontrol-prepare-for-reparenting-non-hierarchical-stats-update.patch
mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type.patch

