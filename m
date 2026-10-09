Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF93D3FE375
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525422; cv=none; b=nZxGu0fiiTqYaFPHxsEgKw97RhGXYoVsGF6Ufn+fZkd3QG+IktLG0UzhdyR8LI3mnJYLTQRieXFEdba9jTPFwqrEyzKEmtcskscy/rhLY7ElMfISBKxCtcXQabUJLG0HIZqtSRu0nvyQ1pDA+DhxHfQrzsqmaJtWAnf75yrhjmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525422; c=relaxed/simple;
	bh=OV8+IdAq/q0CStu52DRKW0Ke7Khs5aKl/8gf5y4eYQg=;
	h=Date:To:From:Subject:Message-Id; b=gKzch1UQOtWiictOfTyuBLRTSWjoYajBE3FwDj53gepYejFqfv3gpY2BOJRf3q7lHBUn2WonepZMeFc7P/e7Mxh0fwixNEs6jP7HLSpwyPczL+1/L1T+er1KPmhPhiE7UZcUPUvjL59KzCkxP6oGxKGjHfPSLx9sh6ilgH2gRuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MLW8UM6l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MLW8UM6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6273A1F000FF;
	Fri,  9 Oct 2026 05:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525420;
	bh=RsaJ3unAp8OO3qErOh1NydqO6Iuos9faQnoRWdmwDns=;
	h=Date:To:From:Subject;
	b=MLW8UM6lQwbViBgpkuHLAmqctngjRc6d8KseEzXjKEHzq44vztszbw9IjQk7O0obK
	 8leSu69FSQPLbZTFw0wJIE1TWU6kTCpnvex52OnXCsAFCfJymm9DBd12NTQloC6SLF
	 VKk/u3d6e4ZB/6SeYA+Mr2ebS9uJ0hu3GYj7Y6Yc=
Date: Thu, 08 Oct 2026 22:57:00 -0700
To: mm-commits@vger.kernel.org,yosry@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,joannelkoong@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-skip-non-hierarchical-memcg-wide-stats-when-v1-is-unavailable.patch removed from -mm tree
Message-Id: <20261009055700.6273A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memcontrol: skip non-hierarchical memcg-wide stats when v1 is unavailable
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-skip-non-hierarchical-memcg-wide-stats-when-v1-is-unavailable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joanne Koong <joannelkoong@gmail.com>
Subject: mm/memcontrol: skip non-hierarchical memcg-wide stats when v1 is unavailable
Date: Thu, 3 Sep 2026 14:56:16 -0700

memcg_vmstats keeps a non-hierarchical copy of every memcg-wide stat item
and event alongside the hierarchical one.  The only readers however are
the legacy memory.stat and memory.numa_stat, and reparenting on offline. 
All of them live under CONFIG_MEMCG_V1, and their accessors
(memcg_page_state_local() and memcg_events_local()) are already compiled
out with it.  This means on a CONFIG_MEMCG_V1=n kernel, memcg_vmstats's
non-hierarchical arrays are written to on every rstat flush, despite their
values never being read / accessed.

The same holds when the kernel does support v1 but the controller has been
blocked from v1 hierarchies with the boot param cgroup_no_v1={memory,all}.
A v1 mount is refused in that case, so the legacy memory.stat can never
exist and the arrays are just as unread / unaccessed.

Compile out the non-hierarchical memcg-wide arrays if CONFIG_MEMCG_V1 is
not set.  If it is set but cgroup_no_v1= has blocked the controller, skip
updates on the arrays.

This makes flushes cheaper.  mem_cgroup_stat_aggregate() can now skip the
read-modify-write of ac->local[i].  Nothing else accesses state_local or
events_local, so those cachelines were getting pulled in solely for the
writes and they are separate from the ones the loop is already walking.

On an 80-cpu x86_64 machine with 500 cgroups each running a workload that
dirties anon, file, dirty/writeback, slab, kmem, mlock, and reclaim
counters, timing mem_cgroup_css_rstat_flush() in-kernel in TSC ticks per
flush showed roughly

                         before   after    delta
memcg-wide aggregation   1231     1180     -4.1%
overall flush function   2452     2397     -2.2%

These numbers are from taking the median of 70 samples, one per 20s window
on each kernel.  The 95% intervals observed on the two deltas are [-5.41%,
-1.76%] and [-4.53%, -0.14%].  The values above include the timing
overhead itself, so only the delta is meaningful here.

Counting the items that actually changed, a median of 1.5 of the 77
memcg-wide items (57 state + 20 events) had a non-zero per-cpu delta at
each flush, which means the benchmarks above are with one or two fewer
cachelines pulled in per flush.  The count is low because the benchmark
reads memory.stat in a loop to keep the flush rate up.  For cases where
flushes are triggered only by the 2s periodic worker, more changes will
have accumulated between flushes, so more cachelines are skipped and the
per-flush saving should be larger.

Link: https://lore.kernel.org/20260903215616.1456239-1-joannelkoong@gmail.com
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Yosry Ahmed <yosry@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
---

 include/linux/cgroup.h          |    3 +
 kernel/cgroup/cgroup-internal.h |    1 
 mm/memcontrol.c                 |   48 +++++++++++++++++++++++++-----
 3 files changed, 44 insertions(+), 8 deletions(-)

--- a/include/linux/cgroup.h~mm-memcontrol-skip-non-hierarchical-memcg-wide-stats-when-v1-is-unavailable
+++ a/include/linux/cgroup.h
@@ -154,6 +154,9 @@ struct cgroup *cgroup_get_from_path(cons
 struct cgroup *cgroup_get_from_fd(int fd);
 struct cgroup *cgroup_v1v2_get_from_fd(int fd);
 
+/* Was this controller blocked from v1 hierarchies by cgroup_no_v1= ? */
+bool cgroup1_ssid_disabled(int ssid);
+
 int cgroup_attach_task_all(struct task_struct *from, struct task_struct *);
 int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from);
 
--- a/kernel/cgroup/cgroup-internal.h~mm-memcontrol-skip-non-hierarchical-memcg-wide-stats-when-v1-is-unavailable
+++ a/kernel/cgroup/cgroup-internal.h
@@ -285,7 +285,6 @@ extern struct kernfs_syscall_ops cgroup1
 extern const struct fs_parameter_spec cgroup1_fs_parameters[];
 
 int proc_cgroupstats_show(struct seq_file *m, void *v);
-bool cgroup1_ssid_disabled(int ssid);
 void cgroup1_pidlist_destroy_all(struct cgroup *cgrp);
 void cgroup1_release_agent(struct work_struct *work);
 void cgroup1_check_for_release(struct cgroup *cgrp);
--- a/mm/memcontrol.c~mm-memcontrol-skip-non-hierarchical-memcg-wide-stats-when-v1-is-unavailable
+++ a/mm/memcontrol.c
@@ -676,9 +676,11 @@ struct memcg_vmstats {
 	long			state[MEMCG_VMSTAT_SIZE];
 	unsigned long		events[NR_MEMCG_EVENTS];
 
+#ifdef CONFIG_MEMCG_V1
 	/* Non-hierarchical (CPU aggregated) page state & events */
 	long			state_local[MEMCG_VMSTAT_SIZE];
 	unsigned long		events_local[NR_MEMCG_EVENTS];
+#endif
 
 	/* Pending child counts during tree propagation */
 	long			state_pending[MEMCG_VMSTAT_SIZE];
@@ -689,6 +691,31 @@ struct memcg_vmstats {
 };
 
 /*
+ * The non-hierarchical memcg-wide counters are read back only by the legacy
+ * memory.stat and memory.numa_stat, and by reparenting on offline, all of which
+ * are v1-only. If the kernel is built without CONFIG_MEMCG_V1, or if the boot
+ * param cgroup_no_v1= has blocked the memory controller from v1 hierarchies,
+ * then nothing reads them and writers can skip the updates.
+ */
+static long *memcg_state_local_array(struct mem_cgroup *memcg)
+{
+#ifdef CONFIG_MEMCG_V1
+	if (!cgroup1_ssid_disabled(memory_cgrp_id))
+		return memcg->vmstats->state_local;
+#endif
+	return NULL;
+}
+
+static unsigned long *memcg_events_local_array(struct mem_cgroup *memcg)
+{
+#ifdef CONFIG_MEMCG_V1
+	if (!cgroup1_ssid_disabled(memory_cgrp_id))
+		return memcg->vmstats->events_local;
+#endif
+	return NULL;
+}
+
+/*
  * memcg and lruvec stats flushing
  *
  * Many codepaths leading to stats update or read are performance sensitive and
@@ -4469,7 +4496,10 @@ static void mem_cgroup_css_reset(struct
 struct aggregate_control {
 	/* pointer to the aggregated (CPU and subtree aggregated) counters */
 	long *aggregate;
-	/* pointer to the non-hierarchichal (CPU aggregated) counters */
+	/*
+	 * pointer to the non-hierarchical (CPU aggregated) counters or NULL to
+	 * skip updating them (see memcg_state_local_array())
+	 */
 	long *local;
 	/* pointer to the pending child counters during tree propagation */
 	long *pending;
@@ -4508,7 +4538,7 @@ static void mem_cgroup_stat_aggregate(st
 		}
 
 		/* Aggregate counts on this level and propagate upwards */
-		if (delta_cpu)
+		if (delta_cpu && ac->local)
 			ac->local[i] += delta_cpu;
 
 		if (delta) {
@@ -4522,6 +4552,7 @@ static void mem_cgroup_stat_aggregate(st
 #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
 static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 {
+	long *state_local = memcg_state_local_array(memcg);
 	int nid;
 
 	if (atomic_read(&memcg->kmem_stat)) {
@@ -4529,7 +4560,8 @@ static void flush_nmi_stats(struct mem_c
 		int index = memcg_stats_index(MEMCG_KMEM);
 
 		memcg->vmstats->state[index] += kmem;
-		memcg->vmstats->state_local[index] += kmem;
+		if (state_local)
+			state_local[index] += kmem;
 		if (parent)
 			parent->vmstats->state_pending[index] += kmem;
 	}
@@ -4551,7 +4583,8 @@ static void flush_nmi_stats(struct mem_c
 			if (plstats)
 				plstats->state_pending[index] += slab;
 			memcg->vmstats->state[index] += slab;
-			memcg->vmstats->state_local[index] += slab;
+			if (state_local)
+				state_local[index] += slab;
 			if (parent)
 				parent->vmstats->state_pending[index] += slab;
 		}
@@ -4564,7 +4597,8 @@ static void flush_nmi_stats(struct mem_c
 			if (plstats)
 				plstats->state_pending[index] += slab;
 			memcg->vmstats->state[index] += slab;
-			memcg->vmstats->state_local[index] += slab;
+			if (state_local)
+				state_local[index] += slab;
 			if (parent)
 				parent->vmstats->state_pending[index] += slab;
 		}
@@ -4589,7 +4623,7 @@ static void mem_cgroup_css_rstat_flush(s
 
 	ac = (struct aggregate_control) {
 		.aggregate = memcg->vmstats->state,
-		.local = memcg->vmstats->state_local,
+		.local = memcg_state_local_array(memcg),
 		.pending = memcg->vmstats->state_pending,
 		.ppending = parent ? parent->vmstats->state_pending : NULL,
 		.cstat = statc->state,
@@ -4600,7 +4634,7 @@ static void mem_cgroup_css_rstat_flush(s
 
 	ac = (struct aggregate_control) {
 		.aggregate = memcg->vmstats->events,
-		.local = memcg->vmstats->events_local,
+		.local = memcg_events_local_array(memcg),
 		.pending = memcg->vmstats->events_pending,
 		.ppending = parent ? parent->vmstats->events_pending : NULL,
 		.cstat = statc->events,
_

Patches currently in -mm which might be from joannelkoong@gmail.com are


