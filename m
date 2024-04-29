Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757A285C41
	for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2024 17:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714411152; cv=none; b=BuizYY/P1lp3bcs9uwW4CJ9esLUkQvIrZgdaG+kGBmLjXwrhUIEQo+kWS9Nj/UnDjP7fk5b5BPxq+2BGVD1ivWop4UWlqO76LHQQ4ZSbCYG7lJ4Hnb2D0YFGag9k5lSScG9SuZH3KFThHmErF82BF+75XeZwb93JyyuWvv2eWJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714411152; c=relaxed/simple;
	bh=fbjXS/YoD7TZmuSNSry+omncLtrBH/1KxSB8LBUbJdY=;
	h=Date:To:From:Subject:Message-Id; b=VuJmPqA2MsMBTLG6QalzzX82W7S2RFBrwhafNTJDU8H96JetTWD3vkgktaaPDUrXKJn++s/6vaU0BthZjq5SEQG61PCm8S7TFY9kygWYOxMtQMNIkQ34JK0VNlgvuk90iiHO32AYU1+wDfTG6q7sbk+M9do9xvfXVn4vCBtx1b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dOEGYoYW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dOEGYoYW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC2DC113CD;
	Mon, 29 Apr 2024 17:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714411152;
	bh=fbjXS/YoD7TZmuSNSry+omncLtrBH/1KxSB8LBUbJdY=;
	h=Date:To:From:Subject:From;
	b=dOEGYoYWTMgKTSAWdJJsGy5liVVFYvH/MMnVNMtZFt9/yTPvVqcpa6cAB79Hvm6N8
	 tQkJ7ppdcniWbWqZgwMPMzaZbZ2NDT7KPzJtF/AQ1l8ADA2Y9tSE9buwMAH6JUKgOa
	 v3Uy9mEmokuc4rdPFUMgzUguPTJXBxQpqujTh5Go=
Date: Mon, 29 Apr 2024 10:19:10 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-dynamically-allocate-lruvec_stats.patch added to mm-unstable branch
Message-Id: <20240429171911.BBC2DC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: dynamically allocate lruvec_stats
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-dynamically-allocate-lruvec_stats.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-dynamically-allocate-lruvec_stats.patch

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: dynamically allocate lruvec_stats
Date: Fri, 26 Apr 2024 17:37:28 -0700

To decouple the dependency of lruvec_stats on NR_VM_NODE_STAT_ITEMS, we
need to dynamically allocate lruvec_stats in the mem_cgroup_per_node
structure.  Also move the definition of lruvec_stats_percpu and
lruvec_stats and related functions to the memcontrol.c to facilitate later
patches.  No functional changes in the patch.

Link: https://lkml.kernel.org/r/20240427003733.3898961-3-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   62 ++----------------------
 mm/memcontrol.c            |   87 ++++++++++++++++++++++++++++++-----
 2 files changed, 81 insertions(+), 68 deletions(-)

--- a/include/linux/memcontrol.h~memcg-dynamically-allocate-lruvec_stats
+++ a/include/linux/memcontrol.h
@@ -83,6 +83,8 @@ enum mem_cgroup_events_target {
 
 struct memcg_vmstats_percpu;
 struct memcg_vmstats;
+struct lruvec_stats_percpu;
+struct lruvec_stats;
 
 struct mem_cgroup_reclaim_iter {
 	struct mem_cgroup *position;
@@ -90,25 +92,6 @@ struct mem_cgroup_reclaim_iter {
 	unsigned int generation;
 };
 
-struct lruvec_stats_percpu {
-	/* Local (CPU and cgroup) state */
-	long state[NR_VM_NODE_STAT_ITEMS];
-
-	/* Delta calculation for lockless upward propagation */
-	long state_prev[NR_VM_NODE_STAT_ITEMS];
-};
-
-struct lruvec_stats {
-	/* Aggregated (CPU and subtree) state */
-	long state[NR_VM_NODE_STAT_ITEMS];
-
-	/* Non-hierarchical (CPU aggregated) state */
-	long state_local[NR_VM_NODE_STAT_ITEMS];
-
-	/* Pending child counts during tree propagation */
-	long state_pending[NR_VM_NODE_STAT_ITEMS];
-};
-
 /*
  * per-node information in memory controller.
  */
@@ -116,7 +99,7 @@ struct mem_cgroup_per_node {
 	struct lruvec		lruvec;
 
 	struct lruvec_stats_percpu __percpu	*lruvec_stats_percpu;
-	struct lruvec_stats			lruvec_stats;
+	struct lruvec_stats			*lruvec_stats;
 
 	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
 
@@ -1037,42 +1020,9 @@ static inline void mod_memcg_page_state(
 }
 
 unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx);
-
-static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
-					      enum node_stat_item idx)
-{
-	struct mem_cgroup_per_node *pn;
-	long x;
-
-	if (mem_cgroup_disabled())
-		return node_page_state(lruvec_pgdat(lruvec), idx);
-
-	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	x = READ_ONCE(pn->lruvec_stats.state[idx]);
-#ifdef CONFIG_SMP
-	if (x < 0)
-		x = 0;
-#endif
-	return x;
-}
-
-static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
-						    enum node_stat_item idx)
-{
-	struct mem_cgroup_per_node *pn;
-	long x = 0;
-
-	if (mem_cgroup_disabled())
-		return node_page_state(lruvec_pgdat(lruvec), idx);
-
-	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	x = READ_ONCE(pn->lruvec_stats.state_local[idx]);
-#ifdef CONFIG_SMP
-	if (x < 0)
-		x = 0;
-#endif
-	return x;
-}
+unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx);
+unsigned long lruvec_page_state_local(struct lruvec *lruvec,
+				      enum node_stat_item idx);
 
 void mem_cgroup_flush_stats(struct mem_cgroup *memcg);
 void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg);
--- a/mm/memcontrol.c~memcg-dynamically-allocate-lruvec_stats
+++ a/mm/memcontrol.c
@@ -575,6 +575,60 @@ mem_cgroup_largest_soft_limit_node(struc
 	return mz;
 }
 
+struct lruvec_stats_percpu {
+	/* Local (CPU and cgroup) state */
+	long state[NR_VM_NODE_STAT_ITEMS];
+
+	/* Delta calculation for lockless upward propagation */
+	long state_prev[NR_VM_NODE_STAT_ITEMS];
+};
+
+struct lruvec_stats {
+	/* Aggregated (CPU and subtree) state */
+	long state[NR_VM_NODE_STAT_ITEMS];
+
+	/* Non-hierarchical (CPU aggregated) state */
+	long state_local[NR_VM_NODE_STAT_ITEMS];
+
+	/* Pending child counts during tree propagation */
+	long state_pending[NR_VM_NODE_STAT_ITEMS];
+};
+
+unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx)
+{
+	struct mem_cgroup_per_node *pn;
+	long x;
+
+	if (mem_cgroup_disabled())
+		return node_page_state(lruvec_pgdat(lruvec), idx);
+
+	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	x = READ_ONCE(pn->lruvec_stats->state[idx]);
+#ifdef CONFIG_SMP
+	if (x < 0)
+		x = 0;
+#endif
+	return x;
+}
+
+unsigned long lruvec_page_state_local(struct lruvec *lruvec,
+				      enum node_stat_item idx)
+{
+	struct mem_cgroup_per_node *pn;
+	long x = 0;
+
+	if (mem_cgroup_disabled())
+		return node_page_state(lruvec_pgdat(lruvec), idx);
+
+	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	x = READ_ONCE(pn->lruvec_stats->state_local[idx]);
+#ifdef CONFIG_SMP
+	if (x < 0)
+		x = 0;
+#endif
+	return x;
+}
+
 /* Subset of vm_event_item to report for memcg event stats */
 static const unsigned int memcg_vm_event_stat[] = {
 	PGPGIN,
@@ -5487,18 +5541,25 @@ static int alloc_mem_cgroup_per_node_inf
 	if (!pn)
 		return 1;
 
+	pn->lruvec_stats = kzalloc_node(sizeof(struct lruvec_stats), GFP_KERNEL,
+					node);
+	if (!pn->lruvec_stats)
+		goto fail;
+
 	pn->lruvec_stats_percpu = alloc_percpu_gfp(struct lruvec_stats_percpu,
 						   GFP_KERNEL_ACCOUNT);
-	if (!pn->lruvec_stats_percpu) {
-		kfree(pn);
-		return 1;
-	}
+	if (!pn->lruvec_stats_percpu)
+		goto fail;
 
 	lruvec_init(&pn->lruvec);
 	pn->memcg = memcg;
 
 	memcg->nodeinfo[node] = pn;
 	return 0;
+fail:
+	kfree(pn->lruvec_stats);
+	kfree(pn);
+	return 1;
 }
 
 static void free_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
@@ -5509,6 +5570,7 @@ static void free_mem_cgroup_per_node_inf
 		return;
 
 	free_percpu(pn->lruvec_stats_percpu);
+	kfree(pn->lruvec_stats);
 	kfree(pn);
 }
 
@@ -5861,18 +5923,19 @@ static void mem_cgroup_css_rstat_flush(s
 
 	for_each_node_state(nid, N_MEMORY) {
 		struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
-		struct mem_cgroup_per_node *ppn = NULL;
+		struct lruvec_stats *lstats = pn->lruvec_stats;
+		struct lruvec_stats *plstats = NULL;
 		struct lruvec_stats_percpu *lstatc;
 
 		if (parent)
-			ppn = parent->nodeinfo[nid];
+			plstats = parent->nodeinfo[nid]->lruvec_stats;
 
 		lstatc = per_cpu_ptr(pn->lruvec_stats_percpu, cpu);
 
 		for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
-			delta = pn->lruvec_stats.state_pending[i];
+			delta = lstats->state_pending[i];
 			if (delta)
-				pn->lruvec_stats.state_pending[i] = 0;
+				lstats->state_pending[i] = 0;
 
 			delta_cpu = 0;
 			v = READ_ONCE(lstatc->state[i]);
@@ -5883,12 +5946,12 @@ static void mem_cgroup_css_rstat_flush(s
 			}
 
 			if (delta_cpu)
-				pn->lruvec_stats.state_local[i] += delta_cpu;
+				lstats->state_local[i] += delta_cpu;
 
 			if (delta) {
-				pn->lruvec_stats.state[i] += delta;
-				if (ppn)
-					ppn->lruvec_stats.state_pending[i] += delta;
+				lstats->state[i] += delta;
+				if (plstats)
+					plstats->state_pending[i] += delta;
 			}
 		}
 	}
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-simple-cleanup-of-stats-update-functions.patch
memcg-reduce-memory-size-of-mem_cgroup_events_index.patch
memcg-dynamically-allocate-lruvec_stats.patch
memcg-reduce-memory-for-the-lruvec-and-memcg-stats.patch
memcg-cleanup-__mod_memcg_lruvec_state.patch
memcg-pr_warn_once-for-unexpected-events-and-stats.patch
memcg-use-proper-type-for-mod_memcg_state.patch
mm-cleanup-workingset_nodes-in-workingset.patch

