Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9604422F15E
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846661; cv=none; b=YRxC7Hdu7vgRNSQY02TK3okRh+BrrliaoDX2OQAJIRwRMMAhwwTG4EsbG+5M94jb1xsWWANCiNnLYEiRd+yCwNpmdNKTIla6V25J+LC20B64Ukc9bFUjOpid+A3L1DcC8d3CWfg/6XJt/t5rf32t3lBwAej0zUtXtL1KvUmjxSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846661; c=relaxed/simple;
	bh=tZt7gytAeEPiS93Wr0qTYnpO3KBM/vTATEbGVq4Texg=;
	h=Date:To:From:Subject:Message-Id; b=FdUFqv0PAz/RwpBeGdLIyAKl0f56MOkrfAJAiqG7AXi/w0BzpWduQmMZA0PJYZg8hs3ap3B1s2lclskB/Zh4frt/BYxKJhmEH/IOMdfmhICx2fHyQlqAXmuZ9G/nxtNqK+AhLtl0jjg8PcLzw0Xvdaf8XJtHOfsU5am0W0jStxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QvuOEUn/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QvuOEUn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABD7C4CEE4;
	Wed, 21 May 2025 16:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846661;
	bh=tZt7gytAeEPiS93Wr0qTYnpO3KBM/vTATEbGVq4Texg=;
	h=Date:To:From:Subject:From;
	b=QvuOEUn/cNZTiZFuwdOFt3ICzdVrv7pQnylcn0Dd5N81z17JZ3xBvVIHu9ZEcdsmg
	 1OJbbFJJ63Ui5beuMKCikBLcnq+aHI9fL1RIkIwyieGjlT4X2Wez7ElEpBgRNCH6nR
	 fBDF91k1U57RjJfRhhXGVvymF/oTvDssd+A5UmbU=
Date: Wed, 21 May 2025 09:57:40 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,bigeasy@linutronix.de,ast@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-memcg_rstat_updated-re-entrant-safe-against-irqs.patch removed from -mm tree
Message-Id: <20250521165741.5ABD7C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: memcg_rstat_updated re-entrant safe against irqs
has been removed from the -mm tree.  Its filename was
     memcg-memcg_rstat_updated-re-entrant-safe-against-irqs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: memcg_rstat_updated re-entrant safe against irqs
Date: Wed, 14 May 2025 11:41:52 -0700

Patch series "memcg: make memcg stats irq safe", v2.

This series converts memcg stats to be irq safe i.e.  memcg stats can be
updated in any context (task, softirq or hardirq) without disabling the
irqs.  This is still not nmi-safe on all architectures but after this
series converting memcg charging and stats nmi-safe will be easier.


This patch (of 7):

memcg_rstat_updated() is used to track the memcg stats updates for
optimizing the flushes.  At the moment, it is not re-entrant safe and the
callers disabled irqs before calling.  However to achieve the goal of
updating memcg stats without irqs, memcg_rstat_updated() needs to be
re-entrant safe against irqs.

This patch makes memcg_rstat_updated() re-entrant safe using this_cpu_*
ops.  On archs with CONFIG_ARCH_HAS_NMI_SAFE_THIS_CPU_OPS, this patch is
also making memcg_rstat_updated() nmi safe.

[lorenzo.stoakes@oracle.com: fix build]
  Link: https://lkml.kernel.org/r/22f69e6e-7908-4e92-96ca-5c70d535c439@lucifer.local
Link: https://lkml.kernel.org/r/20250514184158.3471331-1-shakeel.butt@linux.dev
Link: https://lkml.kernel.org/r/20250514184158.3471331-2-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Alexei Starovoitov <ast@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

--- a/mm/memcontrol.c~memcg-memcg_rstat_updated-re-entrant-safe-against-irqs
+++ a/mm/memcontrol.c
@@ -505,8 +505,8 @@ struct memcg_vmstats_percpu {
 	unsigned int			stats_updates;
 
 	/* Cached pointers for fast iteration in memcg_rstat_updated() */
-	struct memcg_vmstats_percpu	*parent;
-	struct memcg_vmstats		*vmstats;
+	struct memcg_vmstats_percpu __percpu	*parent_pcpu;
+	struct memcg_vmstats			*vmstats;
 
 	/* The above should fit a single cacheline for memcg_rstat_updated() */
 
@@ -588,16 +588,21 @@ static bool memcg_vmstats_needs_flush(st
 
 static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
 {
+	struct memcg_vmstats_percpu __percpu *statc_pcpu;
 	struct memcg_vmstats_percpu *statc;
-	int cpu = smp_processor_id();
+	int cpu;
 	unsigned int stats_updates;
 
 	if (!val)
 		return;
 
+	/* Don't assume callers have preemption disabled. */
+	cpu = get_cpu();
+
 	cgroup_rstat_updated(memcg->css.cgroup, cpu);
-	statc = this_cpu_ptr(memcg->vmstats_percpu);
-	for (; statc; statc = statc->parent) {
+	statc_pcpu = memcg->vmstats_percpu;
+	for (; statc_pcpu; statc_pcpu = statc->parent_pcpu) {
+		statc = this_cpu_ptr(statc_pcpu);
 		/*
 		 * If @memcg is already flushable then all its ancestors are
 		 * flushable as well and also there is no need to increase
@@ -606,14 +611,15 @@ static inline void memcg_rstat_updated(s
 		if (memcg_vmstats_needs_flush(statc->vmstats))
 			break;
 
-		stats_updates = READ_ONCE(statc->stats_updates) + abs(val);
-		WRITE_ONCE(statc->stats_updates, stats_updates);
+		stats_updates = this_cpu_add_return(statc_pcpu->stats_updates,
+						    abs(val));
 		if (stats_updates < MEMCG_CHARGE_BATCH)
 			continue;
 
+		stats_updates = this_cpu_xchg(statc_pcpu->stats_updates, 0);
 		atomic64_add(stats_updates, &statc->vmstats->stats_updates);
-		WRITE_ONCE(statc->stats_updates, 0);
 	}
+	put_cpu();
 }
 
 static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force)
@@ -3691,7 +3697,8 @@ static void mem_cgroup_free(struct mem_c
 
 static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 {
-	struct memcg_vmstats_percpu *statc, *pstatc;
+	struct memcg_vmstats_percpu *statc;
+	struct memcg_vmstats_percpu __percpu *pstatc_pcpu;
 	struct mem_cgroup *memcg;
 	int node, cpu;
 	int __maybe_unused i;
@@ -3722,9 +3729,9 @@ static struct mem_cgroup *mem_cgroup_all
 
 	for_each_possible_cpu(cpu) {
 		if (parent)
-			pstatc = per_cpu_ptr(parent->vmstats_percpu, cpu);
+			pstatc_pcpu = parent->vmstats_percpu;
 		statc = per_cpu_ptr(memcg->vmstats_percpu, cpu);
-		statc->parent = parent ? pstatc : NULL;
+		statc->parent_pcpu = parent ? pstatc_pcpu : NULL;
 		statc->vmstats = memcg->vmstats;
 	}
 
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-disable-kmem-charging-in-nmi-for-unsupported-arch.patch
memcg-nmi-safe-memcg-stats-for-specific-archs.patch
memcg-add-nmi-safe-update-for-memcg_kmem.patch
memcg-nmi-safe-slab-stats-updates.patch
memcg-make-memcg_rstat_updated-nmi-safe.patch

