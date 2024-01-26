Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3417475
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 02:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706235433; cv=none; b=KQz3lBc7LMLb6modZmxsyZ7IPPj6CUJR4ccPpDg1/Zza27BWiq/MiFka8x3zgDTSv4ywRCyYGOVQgZSGWgLLzEMftbPSEpUacBU4K+yghw2plaIKWoFYtB330NtcYwCvGRTmauJoLV3lwm1/ygFoEgA7dwHNKpzPBX8eeUuJlMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706235433; c=relaxed/simple;
	bh=WOoC+ruoGVnhBjI3Zqsiz/v6W9IKSzeuBeWaJJmzAnE=;
	h=Date:To:From:Subject:Message-Id; b=ZRUy8+Fvk9mmzYrSa6eIm4ddysNBwpcHOotkE5GKUr7RKnbCMqmpH2Scpqhmle7KS5GvhzyNOf1Rxm30oz02d3ecnAThQN99s7IGa/FBhofICHDhmhHjgJGL7Cz8dwPilT4/TrZ4ly9B6WE5cpGLe8MKeZQb34LSXg+M+j265vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v7MB3/HP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v7MB3/HP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F67CC433F1;
	Fri, 26 Jan 2024 02:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706235432;
	bh=WOoC+ruoGVnhBjI3Zqsiz/v6W9IKSzeuBeWaJJmzAnE=;
	h=Date:To:From:Subject:From;
	b=v7MB3/HPSG02BrphioB/Vii1Ff3MDmNNGSi9fpuUdTSdiaR7zUq0xOqz0vM9tP9aM
	 tYE45MZ6Fc3v6Rjpqqrx2RYEPusr6+N++SB2uTjQEfPw00y/2ExvS4C0hJvv9wPF3U
	 EMlaGq2/zP450mUPC9hCyfTox6xZ6ZDRiWHrTPHo=
Date: Thu, 25 Jan 2024 18:17:08 -0800
To: mm-commits@vger.kernel.org,shakeelb@google.com,roman.gushchin@linux.dev,oliver.sang@intel.com,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-optimize-parent-iteration-in-memcg_rstat_updated.patch added to mm-hotfixes-unstable branch
Message-Id: <20240126021711.8F67CC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: optimize parent iteration in memcg_rstat_updated()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memcg-optimize-parent-iteration-in-memcg_rstat_updated.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-optimize-parent-iteration-in-memcg_rstat_updated.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: memcg: optimize parent iteration in memcg_rstat_updated()
Date: Wed, 24 Jan 2024 10:00:22 +0000

In memcg_rstat_updated(), we iterate the memcg being updated and its
parents to update memcg->vmstats_percpu->stats_updates in the fast path
(i.e. no atomic updates). According to my math, this is 3 memory loads
(and potentially 3 cache misses) per memcg:
- Load the address of memcg->vmstats_percpu.
- Load vmstats_percpu->stats_updates (based on some percpu calculation).
- Load the address of the parent memcg.

Avoid most of the cache misses by caching a pointer from each struct
memcg_vmstats_percpu to its parent on the corresponding CPU. In this
case, for the first memcg we have 2 memory loads (same as above):
- Load the address of memcg->vmstats_percpu.
- Load vmstats_percpu->stats_updates (based on some percpu calculation).

Then for each additional memcg, we need a single load to get the
parent's stats_updates directly. This reduces the number of loads from
O(3N) to O(2+N) -- where N is the number of memcgs we need to iterate.

Additionally, stash a pointer to memcg->vmstats in each struct
memcg_vmstats_percpu such that we can access the atomic counter that all
CPUs fold into, memcg->vmstats->stats_updates.
memcg_should_flush_stats() is changed to memcg_vmstats_needs_flush() to
accept a struct memcg_vmstats pointer accordingly.

In struct memcg_vmstats_percpu, make sure both pointers together with
stats_updates live on the same cacheline. Finally, update
mem_cgroup_alloc() to take in a parent pointer and initialize the new
cache pointers on each CPU. The percpu loop in mem_cgroup_alloc() may
look concerning, but there are multiple similar loops in the cgroup
creation path (e.g. cgroup_rstat_init()), most of which are hidden
within alloc_percpu().

According to Oliver's testing [1], this fixes multiple 30-38%
regressions in vm-scalability, will-it-scale-tlb_flush2, and
will-it-scale-fallocate1. This comes at a cost of 2 more pointers per
CPU (<2KB on a machine with 128 CPUs).

[1] https://lore.kernel.org/lkml/ZbDJsfsZt2ITyo61@xsang-OptiPlex-9020/

Link: https://lkml.kernel.org/r/20240124100023.660032-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Fixes: 8d59d2214c23 ("mm: memcg: make stats flushing threshold per-memcg")
Tested-by: kernel test robot <oliver.sang@intel.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202401221624.cb53a8ca-oliver.sang@intel.com
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   49 ++++++++++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 17 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-optimize-parent-iteration-in-memcg_rstat_updated
+++ a/mm/memcontrol.c
@@ -633,8 +633,15 @@ struct memcg_vmstats_percpu {
 	unsigned long		nr_page_events;
 	unsigned long		targets[MEM_CGROUP_NTARGETS];
 
+	/* Fit members below in a single cacheline for memcg_rstat_updated() */
+	CACHELINE_PADDING(_pad1_);
+
 	/* Stats updates since the last flush */
 	unsigned int		stats_updates;
+
+	/* Cached pointers for fast iteration in memcg_rstat_updated() */
+	struct memcg_vmstats_percpu	*parent;
+	struct memcg_vmstats		*vmstats;
 };
 
 struct memcg_vmstats {
@@ -698,36 +705,35 @@ static void memcg_stats_unlock(void)
 }
 
 
-static bool memcg_should_flush_stats(struct mem_cgroup *memcg)
+static bool memcg_vmstats_needs_flush(struct memcg_vmstats *vmstats)
 {
-	return atomic64_read(&memcg->vmstats->stats_updates) >
+	return atomic64_read(&vmstats->stats_updates) >
 		MEMCG_CHARGE_BATCH * num_online_cpus();
 }
 
 static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
 {
+	struct memcg_vmstats_percpu *statc;
 	int cpu = smp_processor_id();
-	unsigned int x;
 
 	if (!val)
 		return;
 
 	cgroup_rstat_updated(memcg->css.cgroup, cpu);
-
-	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
-		x = __this_cpu_add_return(memcg->vmstats_percpu->stats_updates,
-					  abs(val));
-
-		if (x < MEMCG_CHARGE_BATCH)
+	statc = this_cpu_ptr(memcg->vmstats_percpu);
+	for (; statc; statc = statc->parent) {
+		statc->stats_updates += abs(val);
+		if (statc->stats_updates < MEMCG_CHARGE_BATCH)
 			continue;
 
 		/*
 		 * If @memcg is already flush-able, increasing stats_updates is
 		 * redundant. Avoid the overhead of the atomic update.
 		 */
-		if (!memcg_should_flush_stats(memcg))
-			atomic64_add(x, &memcg->vmstats->stats_updates);
-		__this_cpu_write(memcg->vmstats_percpu->stats_updates, 0);
+		if (!memcg_vmstats_needs_flush(statc->vmstats))
+			atomic64_add(statc->stats_updates,
+				     &statc->vmstats->stats_updates);
+		statc->stats_updates = 0;
 	}
 }
 
@@ -756,7 +762,7 @@ void mem_cgroup_flush_stats(struct mem_c
 	if (!memcg)
 		memcg = root_mem_cgroup;
 
-	if (memcg_should_flush_stats(memcg))
+	if (memcg_vmstats_needs_flush(memcg->vmstats))
 		do_flush_stats(memcg);
 }
 
@@ -770,7 +776,7 @@ void mem_cgroup_flush_stats_ratelimited(
 static void flush_memcg_stats_dwork(struct work_struct *w)
 {
 	/*
-	 * Deliberately ignore memcg_should_flush_stats() here so that flushing
+	 * Deliberately ignore memcg_vmstats_needs_flush() here so that flushing
 	 * in latency-sensitive paths is as cheap as possible.
 	 */
 	do_flush_stats(root_mem_cgroup);
@@ -5477,10 +5483,11 @@ static void mem_cgroup_free(struct mem_c
 	__mem_cgroup_free(memcg);
 }
 
-static struct mem_cgroup *mem_cgroup_alloc(void)
+static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 {
+	struct memcg_vmstats_percpu *statc, *pstatc;
 	struct mem_cgroup *memcg;
-	int node;
+	int node, cpu;
 	int __maybe_unused i;
 	long error = -ENOMEM;
 
@@ -5504,6 +5511,14 @@ static struct mem_cgroup *mem_cgroup_all
 	if (!memcg->vmstats_percpu)
 		goto fail;
 
+	for_each_possible_cpu(cpu) {
+		if (parent)
+			pstatc = per_cpu_ptr(parent->vmstats_percpu, cpu);
+		statc = per_cpu_ptr(memcg->vmstats_percpu, cpu);
+		statc->parent = parent ? pstatc : NULL;
+		statc->vmstats = memcg->vmstats;
+	}
+
 	for_each_node(node)
 		if (alloc_mem_cgroup_per_node_info(memcg, node))
 			goto fail;
@@ -5549,7 +5564,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 	struct mem_cgroup *memcg, *old_memcg;
 
 	old_memcg = set_active_memcg(parent);
-	memcg = mem_cgroup_alloc();
+	memcg = mem_cgroup_alloc(parent);
 	set_active_memcg(old_memcg);
 	if (IS_ERR(memcg))
 		return ERR_CAST(memcg);
_

Patches currently in -mm which might be from yosryahmed@google.com are

maintainers-supplement-of-zswap-maintainers-update.patch
mm-memcg-optimize-parent-iteration-in-memcg_rstat_updated.patch
mm-swap-enforce-updating-inuse_pages-at-the-end-of-swap_range_free.patch
mm-zswap-remove-unnecessary-trees-cleanups-in-zswap_swapoff.patch
mm-zswap-remove-unused-tree-argument-in-zswap_entry_put.patch

