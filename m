Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0202DCBE1
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756824; cv=none; b=MzZFUQLaD+E09ISijda/uWt9rfBNIuknyd+ZXJWbqX7h1f/2icUkOI88C0ff2XiG8HNRQXFXiVaoxii9CFAFc8u+C/QObH55xH2xngjAW1lo209cxcfhcQxDBU7YDpf880CebMwrD7nbTohoA2VIRtO2RejdUBOSWkQ6zJE4z7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756824; c=relaxed/simple;
	bh=zfLEubFEjjEbIE1PCaoFhUH3Z5oR6rfbbdhtsxbj5hA=;
	h=Date:To:From:Subject:Message-Id; b=h8JWtPUQ7en9mQb+FfoePW0Mp0eW+BGOPGkkkt7uAV9MFmQgPLYnnCMonjwbx4kqPiOo3Ahx4EmHPo+xUcrbeczyPRNvi1/QsG1SpZGcIi4BzbdznT0xbj94ydzOSh1CrNBZ+Q9bq9dT3WmESVO37R38M0hXq1jEY7TLBKlg0uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R3uV+GnN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R3uV+GnN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B8CC4CEED;
	Sun,  1 Jun 2025 05:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756824;
	bh=zfLEubFEjjEbIE1PCaoFhUH3Z5oR6rfbbdhtsxbj5hA=;
	h=Date:To:From:Subject:From;
	b=R3uV+GnN2EnwRRxBZwMoBonH8ReemLHdCqh71lgyb1oWflsTCcLaCBMDwBbsDQqsI
	 K6vCCaRj6eWD9bW0FaYhLxQbVL8GYgtt1F+egO8V9ND19DFNEyqbX5wLf3GORN6DJz
	 0WhQBtgnHG9N35zrZBBmdmf95v7Msl6dJRUEzMpM=
Date: Sat, 31 May 2025 22:47:03 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tj@kernel.org,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mhocko@kernel.org,mathieu.desnoyers@efficios.com,hannes@cmpxchg.org,bigeasy@linutronix.de,ast@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-nmi-safe-memcg-stats-for-specific-archs.patch removed from -mm tree
Message-Id: <20250601054704.37B8CC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: nmi safe memcg stats for specific archs
has been removed from the -mm tree.  Its filename was
     memcg-nmi-safe-memcg-stats-for-specific-archs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: nmi safe memcg stats for specific archs
Date: Sun, 18 May 2025 23:31:39 -0700

There are archs which have NMI but does not support this_cpu_* ops safely
in the nmi context but they support safe atomic ops in nmi context.  For
such archs, let's add infra to use atomic ops for the memcg stats which
can be updated in nmi.

At the moment, the memcg stats which get updated in the objcg charging
path are MEMCG_KMEM, NR_SLAB_RECLAIMABLE_B & NR_SLAB_UNRECLAIMABLE_B. 
Rather than adding support for all memcg stats to be nmi safe, let's just
add infra to make these three stats nmi safe which this patch is doing.

Link: https://lkml.kernel.org/r/20250519063142.111219-3-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   10 +++++++
 init/Kconfig               |    7 +++++
 mm/memcontrol.c            |   49 +++++++++++++++++++++++++++++++++++
 3 files changed, 66 insertions(+)

--- a/include/linux/memcontrol.h~memcg-nmi-safe-memcg-stats-for-specific-archs
+++ a/include/linux/memcontrol.h
@@ -113,6 +113,12 @@ struct mem_cgroup_per_node {
 	CACHELINE_PADDING(_pad2_);
 	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
 	struct mem_cgroup_reclaim_iter	iter;
+
+#ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
+	/* slab stats for nmi context */
+	atomic_t		slab_reclaimable;
+	atomic_t		slab_unreclaimable;
+#endif
 };
 
 struct mem_cgroup_threshold {
@@ -236,6 +242,10 @@ struct mem_cgroup {
 	atomic_long_t		memory_events[MEMCG_NR_MEMORY_EVENTS];
 	atomic_long_t		memory_events_local[MEMCG_NR_MEMORY_EVENTS];
 
+#ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
+	/* MEMCG_KMEM for nmi context */
+	atomic_t		kmem_stat;
+#endif
 	/*
 	 * Hint of reclaim pressure for socket memroy management. Note
 	 * that this indicator should NOT be used in legacy cgroup mode
--- a/init/Kconfig~memcg-nmi-safe-memcg-stats-for-specific-archs
+++ a/init/Kconfig
@@ -1013,6 +1013,13 @@ config MEMCG_NMI_UNSAFE
 	depends on !ARCH_HAS_NMI_SAFE_THIS_CPU_OPS && !ARCH_HAVE_NMI_SAFE_CMPXCHG
 	default y
 
+config MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
+	bool
+	depends on MEMCG
+	depends on HAVE_NMI
+	depends on !ARCH_HAS_NMI_SAFE_THIS_CPU_OPS && ARCH_HAVE_NMI_SAFE_CMPXCHG
+	default y
+
 config MEMCG_V1
 	bool "Legacy cgroup v1 memory controller"
 	depends on MEMCG
--- a/mm/memcontrol.c~memcg-nmi-safe-memcg-stats-for-specific-archs
+++ a/mm/memcontrol.c
@@ -3966,6 +3966,53 @@ static void mem_cgroup_stat_aggregate(st
 	}
 }
 
+#ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
+static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent,
+			    int cpu)
+{
+	int nid;
+
+	if (atomic_read(&memcg->kmem_stat)) {
+		int kmem = atomic_xchg(&memcg->kmem_stat, 0);
+		int index = memcg_stats_index(MEMCG_KMEM);
+
+		memcg->vmstats->state[index] += kmem;
+		if (parent)
+			parent->vmstats->state_pending[index] += kmem;
+	}
+
+	for_each_node_state(nid, N_MEMORY) {
+		struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
+		struct lruvec_stats *lstats = pn->lruvec_stats;
+		struct lruvec_stats *plstats = NULL;
+
+		if (parent)
+			plstats = parent->nodeinfo[nid]->lruvec_stats;
+
+		if (atomic_read(&pn->slab_reclaimable)) {
+			int slab = atomic_xchg(&pn->slab_reclaimable, 0);
+			int index = memcg_stats_index(NR_SLAB_RECLAIMABLE_B);
+
+			lstats->state[index] += slab;
+			if (plstats)
+				plstats->state_pending[index] += slab;
+		}
+		if (atomic_read(&pn->slab_unreclaimable)) {
+			int slab = atomic_xchg(&pn->slab_unreclaimable, 0);
+			int index = memcg_stats_index(NR_SLAB_UNRECLAIMABLE_B);
+
+			lstats->state[index] += slab;
+			if (plstats)
+				plstats->state_pending[index] += slab;
+		}
+	}
+}
+#else
+static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent,
+			    int cpu)
+{}
+#endif
+
 static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
@@ -3974,6 +4021,8 @@ static void mem_cgroup_css_rstat_flush(s
 	struct aggregate_control ac;
 	int nid;
 
+	flush_nmi_stats(memcg, parent, cpu);
+
 	statc = per_cpu_ptr(memcg->vmstats_percpu, cpu);
 
 	ac = (struct aggregate_control) {
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


