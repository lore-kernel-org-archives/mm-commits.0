Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540DC1991CD
	for <mm-commits@vger.kernel.org>; Mon, 19 May 2025 22:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747693765; cv=none; b=jTptwNeJd9yu0vA530VFBLkLB0HAw90P7TXGF/CxWdn5PcrO+RUZV+iqDIsIpO1vwIG3VE4QC1uAd0iK+PddwHZb/6Bm7tPouAkwh5sVWyz/MPC6hi2fMeO3/EdRnyLJZC4cM8NyHOakQO6nYpQS+onpB+CrHwKNHSlInyz52X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747693765; c=relaxed/simple;
	bh=04mQ1yTjWdB9dr3WXjMqKn6sM6zqudHqYLtaCpJ7f7g=;
	h=Date:To:From:Subject:Message-Id; b=hCV7VsGS5lga666HUQZzMXZbAT/HVAjoAl9PSPFa5YS+A2gaz87lqie/okWkRLKE0vAq33y4QqLi6E4i0vcLG9pNTgbGVVgQtfWL4LSOBaOBdPpXtsyUWem9W4BTfBHyeSt6dZ7A2nMczbPo+9vjRHj20tOlRxYyyZnlKwpRglk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f+w20Pei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f+w20Pei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45AFC4CEE4;
	Mon, 19 May 2025 22:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747693764;
	bh=04mQ1yTjWdB9dr3WXjMqKn6sM6zqudHqYLtaCpJ7f7g=;
	h=Date:To:From:Subject:From;
	b=f+w20PeidmqB8YE1CB4dGyyII8C5nl1xU91HM04kEcmo0FPgcGzgogtDhIFTnytqA
	 SBR9o0OqNrRHcyI44Yo/9EI2pyujlosuXnPPcKR2HP1g3mjpvWlTffy5oMBIYRRDYQ
	 6xKzeuxlvCz+K3GUKuqD8EfA4OB2kJQFYU8PqvHA=
Date: Mon, 19 May 2025 15:29:24 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tj@kernel.org,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mhocko@kernel.org,mathieu.desnoyers@efficios.com,hannes@cmpxchg.org,bigeasy@linutronix.de,ast@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-nmi-safe-memcg-stats-for-specific-archs.patch added to mm-new branch
Message-Id: <20250519222924.B45AFC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: nmi safe memcg stats for specific archs
has been added to the -mm mm-new branch.  Its filename is
     memcg-nmi-safe-memcg-stats-for-specific-archs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-nmi-safe-memcg-stats-for-specific-archs.patch

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
@@ -3968,6 +3968,53 @@ static void mem_cgroup_stat_aggregate(st
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
@@ -3976,6 +4023,8 @@ static void mem_cgroup_css_rstat_flush(s
 	struct aggregate_control ac;
 	int nid;
 
+	flush_nmi_stats(memcg, parent, cpu);
+
 	statc = per_cpu_ptr(memcg->vmstats_percpu, cpu);
 
 	ac = (struct aggregate_control) {
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-memcg_rstat_updated-re-entrant-safe-against-irqs.patch
memcg-move-preempt-disable-to-callers-of-memcg_rstat_updated.patch
memcg-make-mod_memcg_state-re-entrant-safe-against-irqs.patch
memcg-make-count_memcg_events-re-entrant-safe-against-irqs.patch
memcg-make-__mod_memcg_lruvec_state-re-entrant-safe-against-irqs.patch
memcg-no-stock-lock-for-cpu-hot-unplug.patch
memcg-objcg-stock-trylock-without-irq-disabling.patch
memcg-disable-kmem-charging-in-nmi-for-unsupported-arch.patch
memcg-nmi-safe-memcg-stats-for-specific-archs.patch
memcg-add-nmi-safe-update-for-memcg_kmem.patch
memcg-nmi-safe-slab-stats-updates.patch
memcg-make-memcg_rstat_updated-nmi-safe.patch

