Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5FD1D7E4B
	for <mm-commits@vger.kernel.org>; Sat, 26 Oct 2024 23:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729984366; cv=none; b=b2dgXgKE39+T2tq8l9QXZ7HI03eKzV3/I86q5r0JeXNkrXMEXvyfKBOocRkKMoqTW/AEcyaG3RBh9FM67GxJS1ijR4zGk3m/2CePhLI51QrQvswRGVidsdb5fSvLguDgYeoU2wqVVWUFhEM/YE1+feLoRagicxpGbiYdzOwb97w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729984366; c=relaxed/simple;
	bh=OGT0dQwIKDLwAVriuR8wWQO099Y6/RzYBY6yo3cq9qY=;
	h=Date:To:From:Subject:Message-Id; b=vCJK6wyDdb8XxMlpphJ1bKVWlBSKgfDL01nG353DJdZxvub78+fIBke7DQrbBU8zvBv+GUwXj5poBnT9bAHB/YOc5B5AQa1qLuR9e3FJw61q0N2xBH3fojyZSkiKzPkGsfdtqLd31FYndUUSUfRgqydIqfh6dlffGk3ZMI8ZSv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QjkPxm+n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QjkPxm+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72FAC4CEC6;
	Sat, 26 Oct 2024 23:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729984365;
	bh=OGT0dQwIKDLwAVriuR8wWQO099Y6/RzYBY6yo3cq9qY=;
	h=Date:To:From:Subject:From;
	b=QjkPxm+nHPqgzdgIgUw2k5RvtwLSdbQNpO6Y/Q3sQFWd+YIbgu7I1aEvz6W5O1Rsn
	 YrYRC2FgLecAoBo19It1H2MRjYnG9kFS7xgFi3r1FYFd/UBar1Gri3ZTUpt5hwhxPP
	 7MPZ8c41Yx5dJgm33F1UcqADubyO5HUWVdIS1P4U=
Date: Sat, 26 Oct 2024 16:12:45 -0700
To: mm-commits@vger.kernel.org,xiujianfeng@huawei.com,wangweiyang2@huawei.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,xiujianfeng@huaweicloud.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-factor-out-mem_cgroup_stat_aggregate.patch added to mm-unstable branch
Message-Id: <20241026231245.B72FAC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: factor out mem_cgroup_stat_aggregate()
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-factor-out-mem_cgroup_stat_aggregate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-factor-out-mem_cgroup_stat_aggregate.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Xiu Jianfeng <xiujianfeng@huaweicloud.com>
Subject: memcg: factor out mem_cgroup_stat_aggregate()
Date: Sat, 26 Oct 2024 09:34:07 +0000


Currently mem_cgroup_css_rstat_flush() is used to flush the per-CPU
statistics from a specified CPU into the global statistics of the
memcg. It processes three kinds of data in three for loops using exactly
the same method. Therefore, the for loop can be factored out and may
make the code more clean.

Link: https://lkml.kernel.org/r/20241026093407.310955-1-xiujianfeng@huaweicloud.com
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wang Weiyang <wangweiyang2@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  131 ++++++++++++++++++++++++----------------------
 1 file changed, 71 insertions(+), 60 deletions(-)

--- a/mm/memcontrol.c~memcg-factor-out-mem_cgroup_stat_aggregate
+++ a/mm/memcontrol.c
@@ -3728,68 +3728,90 @@ static void mem_cgroup_css_reset(struct
 	memcg_wb_domain_size_changed(memcg);
 }
 
-static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
+struct aggregate_control {
+	/* pointer to the aggregated (CPU and subtree aggregated) counters */
+	long *aggregate;
+	/* pointer to the non-hierarchichal (CPU aggregated) counters */
+	long *local;
+	/* pointer to the pending child counters during tree propagation */
+	long *pending;
+	/* pointer to the parent's pending counters, could be NULL */
+	long *ppending;
+	/* pointer to the percpu counters to be aggregated */
+	long *cstat;
+	/* pointer to the percpu counters of the last aggregation*/
+	long *cstat_prev;
+	/* size of the above counters */
+	int size;
+};
+
+static void mem_cgroup_stat_aggregate(struct aggregate_control *ac)
 {
-	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
-	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
-	struct memcg_vmstats_percpu *statc;
+	int i;
 	long delta, delta_cpu, v;
-	int i, nid;
-
-	statc = per_cpu_ptr(memcg->vmstats_percpu, cpu);
 
-	for (i = 0; i < MEMCG_VMSTAT_SIZE; i++) {
+	for (i = 0; i < ac->size; i++) {
 		/*
 		 * Collect the aggregated propagation counts of groups
 		 * below us. We're in a per-cpu loop here and this is
 		 * a global counter, so the first cycle will get them.
 		 */
-		delta = memcg->vmstats->state_pending[i];
+		delta = ac->pending[i];
 		if (delta)
-			memcg->vmstats->state_pending[i] = 0;
+			ac->pending[i] = 0;
 
 		/* Add CPU changes on this level since the last flush */
 		delta_cpu = 0;
-		v = READ_ONCE(statc->state[i]);
-		if (v != statc->state_prev[i]) {
-			delta_cpu = v - statc->state_prev[i];
+		v = READ_ONCE(ac->cstat[i]);
+		if (v != ac->cstat_prev[i]) {
+			delta_cpu = v - ac->cstat_prev[i];
 			delta += delta_cpu;
-			statc->state_prev[i] = v;
+			ac->cstat_prev[i] = v;
 		}
 
 		/* Aggregate counts on this level and propagate upwards */
 		if (delta_cpu)
-			memcg->vmstats->state_local[i] += delta_cpu;
+			ac->local[i] += delta_cpu;
 
 		if (delta) {
-			memcg->vmstats->state[i] += delta;
-			if (parent)
-				parent->vmstats->state_pending[i] += delta;
+			ac->aggregate[i] += delta;
+			if (ac->ppending)
+				ac->ppending[i] += delta;
 		}
 	}
+}
 
-	for (i = 0; i < NR_MEMCG_EVENTS; i++) {
-		delta = memcg->vmstats->events_pending[i];
-		if (delta)
-			memcg->vmstats->events_pending[i] = 0;
-
-		delta_cpu = 0;
-		v = READ_ONCE(statc->events[i]);
-		if (v != statc->events_prev[i]) {
-			delta_cpu = v - statc->events_prev[i];
-			delta += delta_cpu;
-			statc->events_prev[i] = v;
-		}
+static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
+	struct memcg_vmstats_percpu *statc;
+	struct aggregate_control ac;
+	int nid;
 
-		if (delta_cpu)
-			memcg->vmstats->events_local[i] += delta_cpu;
+	statc = per_cpu_ptr(memcg->vmstats_percpu, cpu);
 
-		if (delta) {
-			memcg->vmstats->events[i] += delta;
-			if (parent)
-				parent->vmstats->events_pending[i] += delta;
-		}
-	}
+	ac = (struct aggregate_control) {
+		.aggregate = memcg->vmstats->state,
+		.local = memcg->vmstats->state_local,
+		.pending = memcg->vmstats->state_pending,
+		.ppending = parent ? parent->vmstats->state_pending : NULL,
+		.cstat = statc->state,
+		.cstat_prev = statc->state_prev,
+		.size = MEMCG_VMSTAT_SIZE,
+	};
+	mem_cgroup_stat_aggregate(&ac);
+
+	ac = (struct aggregate_control) {
+		.aggregate = memcg->vmstats->events,
+		.local = memcg->vmstats->events_local,
+		.pending = memcg->vmstats->events_pending,
+		.ppending = parent ? parent->vmstats->events_pending : NULL,
+		.cstat = statc->events,
+		.cstat_prev = statc->events_prev,
+		.size = NR_MEMCG_EVENTS,
+	};
+	mem_cgroup_stat_aggregate(&ac);
 
 	for_each_node_state(nid, N_MEMORY) {
 		struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
@@ -3802,28 +3824,17 @@ static void mem_cgroup_css_rstat_flush(s
 
 		lstatc = per_cpu_ptr(pn->lruvec_stats_percpu, cpu);
 
-		for (i = 0; i < NR_MEMCG_NODE_STAT_ITEMS; i++) {
-			delta = lstats->state_pending[i];
-			if (delta)
-				lstats->state_pending[i] = 0;
-
-			delta_cpu = 0;
-			v = READ_ONCE(lstatc->state[i]);
-			if (v != lstatc->state_prev[i]) {
-				delta_cpu = v - lstatc->state_prev[i];
-				delta += delta_cpu;
-				lstatc->state_prev[i] = v;
-			}
-
-			if (delta_cpu)
-				lstats->state_local[i] += delta_cpu;
-
-			if (delta) {
-				lstats->state[i] += delta;
-				if (plstats)
-					plstats->state_pending[i] += delta;
-			}
-		}
+		ac = (struct aggregate_control) {
+			.aggregate = lstats->state,
+			.local = lstats->state_local,
+			.pending = lstats->state_pending,
+			.ppending = plstats ? plstats->state_pending : NULL,
+			.cstat = lstatc->state,
+			.cstat_prev = lstatc->state_prev,
+			.size = NR_MEMCG_NODE_STAT_ITEMS,
+		};
+		mem_cgroup_stat_aggregate(&ac);
+
 	}
 	WRITE_ONCE(statc->stats_updates, 0);
 	/* We are in a per-cpu loop here, only do the atomic write once */
_

Patches currently in -mm which might be from xiujianfeng@huaweicloud.com are

memcg-factor-out-mem_cgroup_stat_aggregate.patch

