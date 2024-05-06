Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61CD38F94
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957151; cv=none; b=gF1i84LQCf41hcumj9Y0sIUA3fTQoduYrjRZbMuFbmVUkocYkm3UITkwYHkFyxszaZBUiRqMVeNDidU63U6O4kTEKVq/QNDMXVOIcRYWhzJkmWpiBCWXmM9LQv8VFWVm+zGrmThkLLcIxwG2WL4dqIv2JQ3Oq1pyMHA8LFH5M44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957151; c=relaxed/simple;
	bh=8tSchw+K5gZdetGv+57JKxVmgoWIRtuKEdppFEYcf5w=;
	h=Date:To:From:Subject:Message-Id; b=t/GNJLCPR5hBbtjbCQr3VvyDus4DDmFJXuIf7fsM6/Yd3oZOXIzrFRiAWolzuNwAI2JYAa8Qf8+YMk7M+sUCvf0nRL9NpU30vVMSppLznsaxAEF6me4CYltdMaodLooYq4LvpM/rrOSV5J6OdtoSWYfSGIgIcY5QL0fzBpftCy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LXer7FKf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LXer7FKf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE42C113CC;
	Mon,  6 May 2024 00:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957151;
	bh=8tSchw+K5gZdetGv+57JKxVmgoWIRtuKEdppFEYcf5w=;
	h=Date:To:From:Subject:From;
	b=LXer7FKfdoqcZ2yxhqHutv1qMQXwORO22GtosWKaqOizon+48PpzM71V2Mi2PlVA3
	 ZKV6rSEgTniiFAMwH5sqT8712t530Xe/aZGoqZxQc51kjEALwuapVfy9OFfAib9g+Q
	 +JixSfsvtXAfUJFU7wp58PNmVoEp1l0fUhh7enhI=
Date: Sun, 05 May 2024 17:59:11 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-reduce-memory-for-the-lruvec-and-memcg-stats.patch removed from -mm tree
Message-Id: <20240506005911.ABE42C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: reduce memory for the lruvec and memcg stats
has been removed from the -mm tree.  Its filename was
     memcg-reduce-memory-for-the-lruvec-and-memcg-stats.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: reduce memory for the lruvec and memcg stats
Date: Wed, 1 May 2024 10:26:13 -0700

At the moment, the amount of memory allocated for stats related structs in
the mem_cgroup corresponds to the size of enum node_stat_item.  However
not all fields in enum node_stat_item have corresponding memcg stats.  So,
let's use indirection mechanism similar to the one used for memcg vmstats
management.

For a given x86_64 config, the size of stats with and without patch is:

structs size in bytes         w/o     with

struct lruvec_stats           1128     648
struct lruvec_stats_percpu     752     432
struct memcg_vmstats          1832    1352
struct memcg_vmstats_percpu   1280     960

The memory savings are further compounded by the fact that these structs
are allocated for each cpu and for each node.  To be precise, for each
memcg the memory saved would be:

Memory saved = ((21 * 3 * NR_NODES) + (21 * 2 * NR_NODES * NR_CPUS) +
	       (21 * 3) + (21 * 2 * NR_CPUS)) * sizeof(long)

Where 21 is the number of fields eliminated.

Link: https://lkml.kernel.org/r/20240501172617.678560-5-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: T.J. Mercier <tjmercier@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  134 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 114 insertions(+), 20 deletions(-)

--- a/mm/memcontrol.c~memcg-reduce-memory-for-the-lruvec-and-memcg-stats
+++ a/mm/memcontrol.c
@@ -575,35 +575,106 @@ mem_cgroup_largest_soft_limit_node(struc
 	return mz;
 }
 
+/* Subset of node_stat_item for memcg stats */
+static const unsigned int memcg_node_stat_items[] = {
+	NR_INACTIVE_ANON,
+	NR_ACTIVE_ANON,
+	NR_INACTIVE_FILE,
+	NR_ACTIVE_FILE,
+	NR_UNEVICTABLE,
+	NR_SLAB_RECLAIMABLE_B,
+	NR_SLAB_UNRECLAIMABLE_B,
+	WORKINGSET_REFAULT_ANON,
+	WORKINGSET_REFAULT_FILE,
+	WORKINGSET_ACTIVATE_ANON,
+	WORKINGSET_ACTIVATE_FILE,
+	WORKINGSET_RESTORE_ANON,
+	WORKINGSET_RESTORE_FILE,
+	WORKINGSET_NODERECLAIM,
+	NR_ANON_MAPPED,
+	NR_FILE_MAPPED,
+	NR_FILE_PAGES,
+	NR_FILE_DIRTY,
+	NR_WRITEBACK,
+	NR_SHMEM,
+	NR_SHMEM_THPS,
+	NR_FILE_THPS,
+	NR_ANON_THPS,
+	NR_KERNEL_STACK_KB,
+	NR_PAGETABLE,
+	NR_SECONDARY_PAGETABLE,
+#ifdef CONFIG_SWAP
+	NR_SWAPCACHE,
+#endif
+};
+
+static const unsigned int memcg_stat_items[] = {
+	MEMCG_SWAP,
+	MEMCG_SOCK,
+	MEMCG_PERCPU_B,
+	MEMCG_VMALLOC,
+	MEMCG_KMEM,
+	MEMCG_ZSWAP_B,
+	MEMCG_ZSWAPPED,
+};
+
+#define NR_MEMCG_NODE_STAT_ITEMS ARRAY_SIZE(memcg_node_stat_items)
+#define MEMCG_VMSTAT_SIZE (NR_MEMCG_NODE_STAT_ITEMS + \
+			   ARRAY_SIZE(memcg_stat_items))
+static int8_t mem_cgroup_stats_index[MEMCG_NR_STAT] __read_mostly;
+
+static void init_memcg_stats(void)
+{
+	int8_t i, j = 0;
+
+	BUILD_BUG_ON(MEMCG_NR_STAT >= S8_MAX);
+
+	for (i = 0; i < NR_MEMCG_NODE_STAT_ITEMS; ++i)
+		mem_cgroup_stats_index[memcg_node_stat_items[i]] = ++j;
+
+	for (i = 0; i < ARRAY_SIZE(memcg_stat_items); ++i)
+		mem_cgroup_stats_index[memcg_stat_items[i]] = ++j;
+}
+
+static inline int memcg_stats_index(int idx)
+{
+	return mem_cgroup_stats_index[idx] - 1;
+}
+
 struct lruvec_stats_percpu {
 	/* Local (CPU and cgroup) state */
-	long state[NR_VM_NODE_STAT_ITEMS];
+	long state[NR_MEMCG_NODE_STAT_ITEMS];
 
 	/* Delta calculation for lockless upward propagation */
-	long state_prev[NR_VM_NODE_STAT_ITEMS];
+	long state_prev[NR_MEMCG_NODE_STAT_ITEMS];
 };
 
 struct lruvec_stats {
 	/* Aggregated (CPU and subtree) state */
-	long state[NR_VM_NODE_STAT_ITEMS];
+	long state[NR_MEMCG_NODE_STAT_ITEMS];
 
 	/* Non-hierarchical (CPU aggregated) state */
-	long state_local[NR_VM_NODE_STAT_ITEMS];
+	long state_local[NR_MEMCG_NODE_STAT_ITEMS];
 
 	/* Pending child counts during tree propagation */
-	long state_pending[NR_VM_NODE_STAT_ITEMS];
+	long state_pending[NR_MEMCG_NODE_STAT_ITEMS];
 };
 
 unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx)
 {
 	struct mem_cgroup_per_node *pn;
 	long x;
+	int i;
 
 	if (mem_cgroup_disabled())
 		return node_page_state(lruvec_pgdat(lruvec), idx);
 
+	i = memcg_stats_index(idx);
+	if (i < 0)
+		return 0;
+
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	x = READ_ONCE(pn->lruvec_stats->state[idx]);
+	x = READ_ONCE(pn->lruvec_stats->state[i]);
 #ifdef CONFIG_SMP
 	if (x < 0)
 		x = 0;
@@ -616,12 +687,17 @@ unsigned long lruvec_page_state_local(st
 {
 	struct mem_cgroup_per_node *pn;
 	long x = 0;
+	int i;
 
 	if (mem_cgroup_disabled())
 		return node_page_state(lruvec_pgdat(lruvec), idx);
 
+	i = memcg_stats_index(idx);
+	if (i < 0)
+		return 0;
+
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	x = READ_ONCE(pn->lruvec_stats->state_local[idx]);
+	x = READ_ONCE(pn->lruvec_stats->state_local[i]);
 #ifdef CONFIG_SMP
 	if (x < 0)
 		x = 0;
@@ -688,11 +764,11 @@ struct memcg_vmstats_percpu {
 	/* The above should fit a single cacheline for memcg_rstat_updated() */
 
 	/* Local (CPU and cgroup) page state & events */
-	long			state[MEMCG_NR_STAT];
+	long			state[MEMCG_VMSTAT_SIZE];
 	unsigned long		events[NR_MEMCG_EVENTS];
 
 	/* Delta calculation for lockless upward propagation */
-	long			state_prev[MEMCG_NR_STAT];
+	long			state_prev[MEMCG_VMSTAT_SIZE];
 	unsigned long		events_prev[NR_MEMCG_EVENTS];
 
 	/* Cgroup1: threshold notifications & softlimit tree updates */
@@ -702,15 +778,15 @@ struct memcg_vmstats_percpu {
 
 struct memcg_vmstats {
 	/* Aggregated (CPU and subtree) page state & events */
-	long			state[MEMCG_NR_STAT];
+	long			state[MEMCG_VMSTAT_SIZE];
 	unsigned long		events[NR_MEMCG_EVENTS];
 
 	/* Non-hierarchical (CPU aggregated) page state & events */
-	long			state_local[MEMCG_NR_STAT];
+	long			state_local[MEMCG_VMSTAT_SIZE];
 	unsigned long		events_local[NR_MEMCG_EVENTS];
 
 	/* Pending child counts during tree propagation */
-	long			state_pending[MEMCG_NR_STAT];
+	long			state_pending[MEMCG_VMSTAT_SIZE];
 	unsigned long		events_pending[NR_MEMCG_EVENTS];
 
 	/* Stats updates since the last flush */
@@ -843,7 +919,13 @@ static void flush_memcg_stats_dwork(stru
 
 unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
 {
-	long x = READ_ONCE(memcg->vmstats->state[idx]);
+	long x;
+	int i = memcg_stats_index(idx);
+
+	if (i < 0)
+		return 0;
+
+	x = READ_ONCE(memcg->vmstats->state[i]);
 #ifdef CONFIG_SMP
 	if (x < 0)
 		x = 0;
@@ -875,18 +957,25 @@ static int memcg_state_val_in_pages(int
  */
 void __mod_memcg_state(struct mem_cgroup *memcg, int idx, int val)
 {
-	if (mem_cgroup_disabled())
+	int i = memcg_stats_index(idx);
+
+	if (mem_cgroup_disabled() || i < 0)
 		return;
 
-	__this_cpu_add(memcg->vmstats_percpu->state[idx], val);
+	__this_cpu_add(memcg->vmstats_percpu->state[i], val);
 	memcg_rstat_updated(memcg, memcg_state_val_in_pages(idx, val));
 }
 
 /* idx can be of type enum memcg_stat_item or node_stat_item. */
 static unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx)
 {
-	long x = READ_ONCE(memcg->vmstats->state_local[idx]);
+	long x;
+	int i = memcg_stats_index(idx);
+
+	if (i < 0)
+		return 0;
 
+	x = READ_ONCE(memcg->vmstats->state_local[i]);
 #ifdef CONFIG_SMP
 	if (x < 0)
 		x = 0;
@@ -900,6 +989,10 @@ static void __mod_memcg_lruvec_state(str
 {
 	struct mem_cgroup_per_node *pn;
 	struct mem_cgroup *memcg;
+	int i = memcg_stats_index(idx);
+
+	if (i < 0)
+		return;
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
 	memcg = pn->memcg;
@@ -926,10 +1019,10 @@ static void __mod_memcg_lruvec_state(str
 	}
 
 	/* Update memcg */
-	__this_cpu_add(memcg->vmstats_percpu->state[idx], val);
+	__this_cpu_add(memcg->vmstats_percpu->state[i], val);
 
 	/* Update lruvec */
-	__this_cpu_add(pn->lruvec_stats_percpu->state[idx], val);
+	__this_cpu_add(pn->lruvec_stats_percpu->state[i], val);
 
 	memcg_rstat_updated(memcg, memcg_state_val_in_pages(idx, val));
 	memcg_stats_unlock();
@@ -5697,6 +5790,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 		page_counter_init(&memcg->kmem, &parent->kmem);
 		page_counter_init(&memcg->tcpmem, &parent->tcpmem);
 	} else {
+		init_memcg_stats();
 		init_memcg_events();
 		page_counter_init(&memcg->memory, NULL);
 		page_counter_init(&memcg->swap, NULL);
@@ -5868,7 +5962,7 @@ static void mem_cgroup_css_rstat_flush(s
 
 	statc = per_cpu_ptr(memcg->vmstats_percpu, cpu);
 
-	for (i = 0; i < MEMCG_NR_STAT; i++) {
+	for (i = 0; i < MEMCG_VMSTAT_SIZE; i++) {
 		/*
 		 * Collect the aggregated propagation counts of groups
 		 * below us. We're in a per-cpu loop here and this is
@@ -5932,7 +6026,7 @@ static void mem_cgroup_css_rstat_flush(s
 
 		lstatc = per_cpu_ptr(pn->lruvec_stats_percpu, cpu);
 
-		for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
+		for (i = 0; i < NR_MEMCG_NODE_STAT_ITEMS; i++) {
 			delta = lstats->state_pending[i];
 			if (delta)
 				lstats->state_pending[i] = 0;
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


