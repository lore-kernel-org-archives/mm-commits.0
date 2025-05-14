Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC73BE552
	for <mm-commits@vger.kernel.org>; Wed, 14 May 2025 22:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747260186; cv=none; b=DuM+ayqvgSbqCVJrLwvYmwieotiSoTHDWcrFqJWcL+IXnIKio2PT3Elq66mxcJ7708cR79GhWrBfYOuKGlsHPNTDhXT52viB5tZlQMwjKIIKhagvPVu3hhfJk7ZDSjX6lUREyjDZaVwovh5eykG5+hL/dfkWtifkELWPlgWHdmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747260186; c=relaxed/simple;
	bh=ogcEQygwGNNYEpOieJvWdKmL5Y7K5u8a+Nzp/UDnyoE=;
	h=Date:To:From:Subject:Message-Id; b=RDhGCJUGeounDoFn8jB4NaK+4j88On6izQ3n01MGTKL75FHcKATUNyZUODa+CNZLtlugGJLVa2bj5lELQz398icAYXcvlcoC26cZ/A6l3D4TOAbSXiY2EqVG8OfqVGQ9T2LUnUrPGyBvnyKE0C+75QtFXD1GkLl7yCLilg6ttSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t7EqFANd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t7EqFANd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E64C4CEE3;
	Wed, 14 May 2025 22:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747260185;
	bh=ogcEQygwGNNYEpOieJvWdKmL5Y7K5u8a+Nzp/UDnyoE=;
	h=Date:To:From:Subject:From;
	b=t7EqFANdyil0/n0JwNXDVObsGm5oajlnrozotQZfwMwlRh/tSRs4WBZ1C9hsER9TQ
	 4+DzNTmVsO7LhjIcFU+4WPq7ft9YaYYb5yAYfXE5cUpRt18M6beU409w6qk0sKmith
	 98xgclnrWUVAy3bfa+VWguNUiVgCrt7W8O9+hc98=
Date: Wed, 14 May 2025 15:03:04 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,bigeasy@linutronix.de,ast@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-memcg_rstat_updated-re-entrant-safe-against-irqs.patch added to mm-new branch
Message-Id: <20250514220305.11E64C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: memcg_rstat_updated re-entrant safe against irqs
has been added to the -mm mm-new branch.  Its filename is
     memcg-memcg_rstat_updated-re-entrant-safe-against-irqs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-memcg_rstat_updated-re-entrant-safe-against-irqs.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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

Link: https://lkml.kernel.org/r/20250514184158.3471331-1-shakeel.butt@linux.dev
Link: https://lkml.kernel.org/r/20250514184158.3471331-2-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

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
@@ -3691,7 +3697,7 @@ static void mem_cgroup_free(struct mem_c
 
 static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 {
-	struct memcg_vmstats_percpu *statc, *pstatc;
+	struct memcg_vmstats_percpu *statc, __percpu *pstatc_pcpu;
 	struct mem_cgroup *memcg;
 	int node, cpu;
 	int __maybe_unused i;
@@ -3722,9 +3728,9 @@ static struct mem_cgroup *mem_cgroup_all
 
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

memcg-memcg_rstat_updated-re-entrant-safe-against-irqs.patch
memcg-move-preempt-disable-to-callers-of-memcg_rstat_updated.patch
memcg-make-mod_memcg_state-re-entrant-safe-against-irqs.patch
memcg-make-count_memcg_events-re-entrant-safe-against-irqs.patch
memcg-make-__mod_memcg_lruvec_state-re-entrant-safe-against-irqs.patch
memcg-no-stock-lock-for-cpu-hot-unplug.patch
memcg-objcg-stock-trylock-without-irq-disabling.patch

