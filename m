Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69F65C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:57:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FBAE610E5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:57:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235947AbhICU6b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:58:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:57268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350361AbhICU60 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:58:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DA6F60E9B;
        Fri,  3 Sep 2021 20:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702645;
        bh=7e4IFu6vl/UzCAS4/CGyU9eU2xGVhDc+5OvBgPflD5w=;
        h=Date:From:To:Subject:From;
        b=ICLccjDZ4dUpQC/WkEyri6yiZnthJ+YajPLAgRVcgM6d/a3HI87g6xHRM7TI9uZ/R
         LJhlMkd14QsA/XN2MwVnsSXv8GYEW+vZYCL3Sv0+orsiazJOG/5nlsTF1w8ZR9937Z
         mjtSUCuUlMQHQNQIndbJ0YdBBC/Xl9KGNcb8lMJo=
Date:   Fri, 03 Sep 2021 13:57:25 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, hdanton@sina.com,
        mhocko@kernel.org, mkoutny@suse.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, songmuchun@bytedance.com, tj@kernel.org,
        ying.huang@intel.com
Subject:  [merged] memcg-switch-lruvec-stats-to-rstat.patch removed
 from -mm tree
Message-ID: <20210903205725.f-NZlUNaH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: switch lruvec stats to rstat
has been removed from the -mm tree.  Its filename was
     memcg-switch-lruvec-stats-to-rstat.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Shakeel Butt <shakeelb@google.com>
Subject: memcg: switch lruvec stats to rstat

The commit 2d146aa3aa84 ("mm: memcontrol: switch to rstat") switched memcg
stats to rstat infrastructure but skipped the conversion of the lruvec
stats as such stats are read in the performance critical code paths and
flushing stats may have impacted the performances of the applications.=20
This patch converts the lruvec stats to rstat and later patches add
mechanisms to keep the performance impact to minimum.

The rstat conversion comes with the price i.e.  memory cost.  Effectively
this patch reverts the savings done by the commit f3344adf38bd ("mm:
memcontrol: optimize per-lruvec stats counter memory usage").  However
this cost is justified due to negative impact of the inaccurate lruvec
stats on many heuristics.  One such case is reported in [1].

The memory reclaim code is filled with plethora of heuristics and many of
those heuristics reads the lruvec stats.  So, inaccurate stats can make
such heuristics ineffective.  [1] reports the impact of inaccurate lruvec
stats on the "cache trim mode" heuristic.  Inaccurate lruvec stats can
impact the deactivation and aging anon heuristics as well.

[1] https://lore.kernel.org/linux-mm/20210311004449.1170308-1-ying.huang@in=
tel.com/

Link: https://lkml.kernel.org/r/20210716212137.1391164-1-shakeelb@google.com
Link: https://lkml.kernel.org/r/20210714013948.270662-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Michal Koutn=C3=BD <mkoutny@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   42 ++++++------
 mm/memcontrol.c            |  114 +++++++++++------------------------
 2 files changed, 58 insertions(+), 98 deletions(-)

--- a/include/linux/memcontrol.h~memcg-switch-lruvec-stats-to-rstat
+++ a/include/linux/memcontrol.h
@@ -105,14 +105,6 @@ struct mem_cgroup_reclaim_iter {
 	unsigned int generation;
 };
=20
-struct lruvec_stat {
-	long count[NR_VM_NODE_STAT_ITEMS];
-};
-
-struct batched_lruvec_stat {
-	s32 count[NR_VM_NODE_STAT_ITEMS];
-};
-
 /*
  * Bitmap and deferred work of shrinker::id corresponding to memcg-aware
  * shrinkers, which have elements charged to this memcg.
@@ -123,24 +115,30 @@ struct shrinker_info {
 	unsigned long *map;
 };
=20
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
+	/* Pending child counts during tree propagation */
+	long state_pending[NR_VM_NODE_STAT_ITEMS];
+};
+
 /*
  * per-node information in memory controller.
  */
 struct mem_cgroup_per_node {
 	struct lruvec		lruvec;
=20
-	/*
-	 * Legacy local VM stats. This should be struct lruvec_stat and
-	 * cannot be optimized to struct batched_lruvec_stat. Because
-	 * the threshold of the lruvec_stat_cpu can be as big as
-	 * MEMCG_CHARGE_BATCH * PAGE_SIZE. It can fit into s32. But this
-	 * filed has no upper limit.
-	 */
-	struct lruvec_stat __percpu *lruvec_stat_local;
-
-	/* Subtree VM stats (batched updates) */
-	struct batched_lruvec_stat __percpu *lruvec_stat_cpu;
-	atomic_long_t		lruvec_stat[NR_VM_NODE_STAT_ITEMS];
+	struct lruvec_stats_percpu __percpu	*lruvec_stats_percpu;
+	struct lruvec_stats			lruvec_stats;
=20
 	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
=20
@@ -997,7 +995,7 @@ static inline unsigned long lruvec_page_
 		return node_page_state(lruvec_pgdat(lruvec), idx);
=20
 	pn =3D container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	x =3D atomic_long_read(&pn->lruvec_stat[idx]);
+	x =3D READ_ONCE(pn->lruvec_stats.state[idx]);
 #ifdef CONFIG_SMP
 	if (x < 0)
 		x =3D 0;
@@ -1017,7 +1015,7 @@ static inline unsigned long lruvec_page_
=20
 	pn =3D container_of(lruvec, struct mem_cgroup_per_node, lruvec);
 	for_each_possible_cpu(cpu)
-		x +=3D per_cpu(pn->lruvec_stat_local->count[idx], cpu);
+		x +=3D per_cpu(pn->lruvec_stats_percpu->state[idx], cpu);
 #ifdef CONFIG_SMP
 	if (x < 0)
 		x =3D 0;
--- a/mm/memcontrol.c~memcg-switch-lruvec-stats-to-rstat
+++ a/mm/memcontrol.c
@@ -660,23 +660,11 @@ static unsigned long memcg_page_state_lo
 	return x;
 }
=20
-static struct mem_cgroup_per_node *
-parent_nodeinfo(struct mem_cgroup_per_node *pn, int nid)
-{
-	struct mem_cgroup *parent;
-
-	parent =3D parent_mem_cgroup(pn->memcg);
-	if (!parent)
-		return NULL;
-	return parent->nodeinfo[nid];
-}
-
 void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item i=
dx,
 			      int val)
 {
 	struct mem_cgroup_per_node *pn;
 	struct mem_cgroup *memcg;
-	long x, threshold =3D MEMCG_CHARGE_BATCH;
=20
 	pn =3D container_of(lruvec, struct mem_cgroup_per_node, lruvec);
 	memcg =3D pn->memcg;
@@ -685,21 +673,7 @@ void __mod_memcg_lruvec_state(struct lru
 	__mod_memcg_state(memcg, idx, val);
=20
 	/* Update lruvec */
-	__this_cpu_add(pn->lruvec_stat_local->count[idx], val);
-
-	if (vmstat_item_in_bytes(idx))
-		threshold <<=3D PAGE_SHIFT;
-
-	x =3D val + __this_cpu_read(pn->lruvec_stat_cpu->count[idx]);
-	if (unlikely(abs(x) > threshold)) {
-		pg_data_t *pgdat =3D lruvec_pgdat(lruvec);
-		struct mem_cgroup_per_node *pi;
-
-		for (pi =3D pn; pi; pi =3D parent_nodeinfo(pi, pgdat->node_id))
-			atomic_long_add(x, &pi->lruvec_stat[idx]);
-		x =3D 0;
-	}
-	__this_cpu_write(pn->lruvec_stat_cpu->count[idx], x);
+	__this_cpu_add(pn->lruvec_stats_percpu->state[idx], val);
 }
=20
 /**
@@ -2278,40 +2252,13 @@ static void drain_all_stock(struct mem_c
 	mutex_unlock(&percpu_charge_mutex);
 }
=20
-static void memcg_flush_lruvec_page_state(struct mem_cgroup *memcg, int cp=
u)
-{
-	int nid;
-
-	for_each_node(nid) {
-		struct mem_cgroup_per_node *pn =3D memcg->nodeinfo[nid];
-		unsigned long stat[NR_VM_NODE_STAT_ITEMS];
-		struct batched_lruvec_stat *lstatc;
-		int i;
-
-		lstatc =3D per_cpu_ptr(pn->lruvec_stat_cpu, cpu);
-		for (i =3D 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
-			stat[i] =3D lstatc->count[i];
-			lstatc->count[i] =3D 0;
-		}
-
-		do {
-			for (i =3D 0; i < NR_VM_NODE_STAT_ITEMS; i++)
-				atomic_long_add(stat[i], &pn->lruvec_stat[i]);
-		} while ((pn =3D parent_nodeinfo(pn, nid)));
-	}
-}
-
 static int memcg_hotplug_cpu_dead(unsigned int cpu)
 {
 	struct memcg_stock_pcp *stock;
-	struct mem_cgroup *memcg;
=20
 	stock =3D &per_cpu(memcg_stock, cpu);
 	drain_stock(stock);
=20
-	for_each_mem_cgroup(memcg)
-		memcg_flush_lruvec_page_state(memcg, cpu);
-
 	return 0;
 }
=20
@@ -5118,17 +5065,9 @@ static int alloc_mem_cgroup_per_node_inf
 	if (!pn)
 		return 1;
=20
-	pn->lruvec_stat_local =3D alloc_percpu_gfp(struct lruvec_stat,
-						 GFP_KERNEL_ACCOUNT);
-	if (!pn->lruvec_stat_local) {
-		kfree(pn);
-		return 1;
-	}
-
-	pn->lruvec_stat_cpu =3D alloc_percpu_gfp(struct batched_lruvec_stat,
-					       GFP_KERNEL_ACCOUNT);
-	if (!pn->lruvec_stat_cpu) {
-		free_percpu(pn->lruvec_stat_local);
+	pn->lruvec_stats_percpu =3D alloc_percpu_gfp(struct lruvec_stats_percpu,
+						   GFP_KERNEL_ACCOUNT);
+	if (!pn->lruvec_stats_percpu) {
 		kfree(pn);
 		return 1;
 	}
@@ -5149,8 +5088,7 @@ static void free_mem_cgroup_per_node_inf
 	if (!pn)
 		return;
=20
-	free_percpu(pn->lruvec_stat_cpu);
-	free_percpu(pn->lruvec_stat_local);
+	free_percpu(pn->lruvec_stats_percpu);
 	kfree(pn);
 }
=20
@@ -5166,15 +5104,7 @@ static void __mem_cgroup_free(struct mem
=20
 static void mem_cgroup_free(struct mem_cgroup *memcg)
 {
-	int cpu;
-
 	memcg_wb_domain_exit(memcg);
-	/*
-	 * Flush percpu lruvec stats to guarantee the value
-	 * correctness on parent's and all ancestor levels.
-	 */
-	for_each_online_cpu(cpu)
-		memcg_flush_lruvec_page_state(memcg, cpu);
 	__mem_cgroup_free(memcg);
 }
=20
@@ -5407,7 +5337,7 @@ static void mem_cgroup_css_rstat_flush(s
 	struct mem_cgroup *parent =3D parent_mem_cgroup(memcg);
 	struct memcg_vmstats_percpu *statc;
 	long delta, v;
-	int i;
+	int i, nid;
=20
 	statc =3D per_cpu_ptr(memcg->vmstats_percpu, cpu);
=20
@@ -5455,6 +5385,36 @@ static void mem_cgroup_css_rstat_flush(s
 		if (parent)
 			parent->vmstats.events_pending[i] +=3D delta;
 	}
+
+	for_each_node_state(nid, N_MEMORY) {
+		struct mem_cgroup_per_node *pn =3D memcg->nodeinfo[nid];
+		struct mem_cgroup_per_node *ppn =3D NULL;
+		struct lruvec_stats_percpu *lstatc;
+
+		if (parent)
+			ppn =3D parent->nodeinfo[nid];
+
+		lstatc =3D per_cpu_ptr(pn->lruvec_stats_percpu, cpu);
+
+		for (i =3D 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
+			delta =3D pn->lruvec_stats.state_pending[i];
+			if (delta)
+				pn->lruvec_stats.state_pending[i] =3D 0;
+
+			v =3D READ_ONCE(lstatc->state[i]);
+			if (v !=3D lstatc->state_prev[i]) {
+				delta +=3D v - lstatc->state_prev[i];
+				lstatc->state_prev[i] =3D v;
+			}
+
+			if (!delta)
+				continue;
+
+			pn->lruvec_stats.state[i] +=3D delta;
+			if (ppn)
+				ppn->lruvec_stats.state_pending[i] +=3D delta;
+		}
+	}
 }
=20
 #ifdef CONFIG_MMU
@@ -6388,6 +6348,8 @@ static int memory_numa_stat_show(struct
 	int i;
 	struct mem_cgroup *memcg =3D mem_cgroup_from_seq(m);
=20
+	cgroup_rstat_flush(memcg->css.cgroup);
+
 	for (i =3D 0; i < ARRAY_SIZE(memory_stats); i++) {
 		int nid;
=20
_

Patches currently in -mm which might be from shakeelb@google.com are


