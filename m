Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1EA21C16D
	for <mm-commits@vger.kernel.org>; Wed, 14 May 2025 22:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747260186; cv=none; b=WqGy2HFDiuWFDtyeiBUp1SprsmYNNzFOvqg9tsLbhRQ2mqk8oJWq+0BXVa9cWil4BGjl7n+CsWroMBgWy1UMQik5sP3Xmdl90ArpVGIkMJ5atqaBSdZRflRw6/vV0qVcvQsIuDcJCHTdsnh6x5+71gMUy8a7Yz7KoXbZrPPzrvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747260186; c=relaxed/simple;
	bh=iju6OhhXcXraDhUFj2MHB6OY0uTlkLEPwcqguCgn2Lw=;
	h=Date:To:From:Subject:Message-Id; b=MCSFqbi1iC/2q/kWuRgobn7/L3fwnPjLukyXaVI8lSVNF90Es+640iBhI8WwJeUjULSF8PhKvQJ6NCJvdZIY2lu5Avl0eNpjCe2ReuLfPr7/pYt/1TCrhbs4IibXyVAfuno0QDN6Az/VbfGmelLbbAt9qmKgiDupRA4+gkyAmQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fDvga+Bq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fDvga+Bq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478F8C4CEE3;
	Wed, 14 May 2025 22:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747260186;
	bh=iju6OhhXcXraDhUFj2MHB6OY0uTlkLEPwcqguCgn2Lw=;
	h=Date:To:From:Subject:From;
	b=fDvga+BqQpwpqbwbfy0ssERhZ2M0q3sAnif7XHfYMPFhsMmu0yF4S0OMWJCH5G6lx
	 XMwd+QiH0yHiV8hQPQ7MAiW3qlyXyOUgfgr5C8zq+ICvFviIoAeZG+Sb9tnH7sWDAQ
	 GbjXls3J71Vh3m2N8HaQIySJHR44k9EGJbp3/QQg=
Date: Wed, 14 May 2025 15:03:05 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,bigeasy@linutronix.de,ast@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-move-preempt-disable-to-callers-of-memcg_rstat_updated.patch added to mm-new branch
Message-Id: <20250514220306.478F8C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: move preempt disable to callers of memcg_rstat_updated
has been added to the -mm mm-new branch.  Its filename is
     memcg-move-preempt-disable-to-callers-of-memcg_rstat_updated.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-move-preempt-disable-to-callers-of-memcg_rstat_updated.patch

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
Subject: memcg: move preempt disable to callers of memcg_rstat_updated
Date: Wed, 14 May 2025 11:41:53 -0700

Let's move the explicit preempt disable code to the callers of
memcg_rstat_updated and also remove the memcg_stats_lock and related
functions which ensures the callers of stats update functions have
disabled preemption because now the stats update functions are explicitly
disabling preemption.

Link: https://lkml.kernel.org/r/20250514184158.3471331-3-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   74 +++++++++++-----------------------------------
 1 file changed, 19 insertions(+), 55 deletions(-)

--- a/mm/memcontrol.c~memcg-move-preempt-disable-to-callers-of-memcg_rstat_updated
+++ a/mm/memcontrol.c
@@ -557,48 +557,22 @@ static u64 flush_last_time;
 
 #define FLUSH_TIME (2UL*HZ)
 
-/*
- * Accessors to ensure that preemption is disabled on PREEMPT_RT because it can
- * not rely on this as part of an acquired spinlock_t lock. These functions are
- * never used in hardirq context on PREEMPT_RT and therefore disabling preemtion
- * is sufficient.
- */
-static void memcg_stats_lock(void)
-{
-	preempt_disable_nested();
-	VM_WARN_ON_IRQS_ENABLED();
-}
-
-static void __memcg_stats_lock(void)
-{
-	preempt_disable_nested();
-}
-
-static void memcg_stats_unlock(void)
-{
-	preempt_enable_nested();
-}
-
-
 static bool memcg_vmstats_needs_flush(struct memcg_vmstats *vmstats)
 {
 	return atomic64_read(&vmstats->stats_updates) >
 		MEMCG_CHARGE_BATCH * num_online_cpus();
 }
 
-static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
+static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val,
+				       int cpu)
 {
 	struct memcg_vmstats_percpu __percpu *statc_pcpu;
 	struct memcg_vmstats_percpu *statc;
-	int cpu;
 	unsigned int stats_updates;
 
 	if (!val)
 		return;
 
-	/* Don't assume callers have preemption disabled. */
-	cpu = get_cpu();
-
 	cgroup_rstat_updated(memcg->css.cgroup, cpu);
 	statc_pcpu = memcg->vmstats_percpu;
 	for (; statc_pcpu; statc_pcpu = statc->parent_pcpu) {
@@ -619,7 +593,6 @@ static inline void memcg_rstat_updated(s
 		stats_updates = this_cpu_xchg(statc_pcpu->stats_updates, 0);
 		atomic64_add(stats_updates, &statc->vmstats->stats_updates);
 	}
-	put_cpu();
 }
 
 static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force)
@@ -717,6 +690,7 @@ void __mod_memcg_state(struct mem_cgroup
 		       int val)
 {
 	int i = memcg_stats_index(idx);
+	int cpu;
 
 	if (mem_cgroup_disabled())
 		return;
@@ -724,12 +698,14 @@ void __mod_memcg_state(struct mem_cgroup
 	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return;
 
-	memcg_stats_lock();
+	cpu = get_cpu();
+
 	__this_cpu_add(memcg->vmstats_percpu->state[i], val);
 	val = memcg_state_val_in_pages(idx, val);
-	memcg_rstat_updated(memcg, val);
+	memcg_rstat_updated(memcg, val, cpu);
 	trace_mod_memcg_state(memcg, idx, val);
-	memcg_stats_unlock();
+
+	put_cpu();
 }
 
 #ifdef CONFIG_MEMCG_V1
@@ -758,6 +734,7 @@ static void __mod_memcg_lruvec_state(str
 	struct mem_cgroup_per_node *pn;
 	struct mem_cgroup *memcg;
 	int i = memcg_stats_index(idx);
+	int cpu;
 
 	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return;
@@ -765,24 +742,7 @@ static void __mod_memcg_lruvec_state(str
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
 	memcg = pn->memcg;
 
-	/*
-	 * The caller from rmap relies on disabled preemption because they never
-	 * update their counter from in-interrupt context. For these two
-	 * counters we check that the update is never performed from an
-	 * interrupt context while other caller need to have disabled interrupt.
-	 */
-	__memcg_stats_lock();
-	if (IS_ENABLED(CONFIG_DEBUG_VM)) {
-		switch (idx) {
-		case NR_ANON_MAPPED:
-		case NR_FILE_MAPPED:
-		case NR_ANON_THPS:
-			WARN_ON_ONCE(!in_task());
-			break;
-		default:
-			VM_WARN_ON_IRQS_ENABLED();
-		}
-	}
+	cpu = get_cpu();
 
 	/* Update memcg */
 	__this_cpu_add(memcg->vmstats_percpu->state[i], val);
@@ -791,9 +751,10 @@ static void __mod_memcg_lruvec_state(str
 	__this_cpu_add(pn->lruvec_stats_percpu->state[i], val);
 
 	val = memcg_state_val_in_pages(idx, val);
-	memcg_rstat_updated(memcg, val);
+	memcg_rstat_updated(memcg, val, cpu);
 	trace_mod_memcg_lruvec_state(memcg, idx, val);
-	memcg_stats_unlock();
+
+	put_cpu();
 }
 
 /**
@@ -873,6 +834,7 @@ void __count_memcg_events(struct mem_cgr
 			  unsigned long count)
 {
 	int i = memcg_events_index(idx);
+	int cpu;
 
 	if (mem_cgroup_disabled())
 		return;
@@ -880,11 +842,13 @@ void __count_memcg_events(struct mem_cgr
 	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return;
 
-	memcg_stats_lock();
+	cpu = get_cpu();
+
 	__this_cpu_add(memcg->vmstats_percpu->events[i], count);
-	memcg_rstat_updated(memcg, count);
+	memcg_rstat_updated(memcg, count, cpu);
 	trace_count_memcg_events(memcg, idx, count);
-	memcg_stats_unlock();
+
+	put_cpu();
 }
 
 unsigned long memcg_events(struct mem_cgroup *memcg, int event)
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-memcg_rstat_updated-re-entrant-safe-against-irqs.patch
memcg-move-preempt-disable-to-callers-of-memcg_rstat_updated.patch
memcg-make-mod_memcg_state-re-entrant-safe-against-irqs.patch
memcg-make-count_memcg_events-re-entrant-safe-against-irqs.patch
memcg-make-__mod_memcg_lruvec_state-re-entrant-safe-against-irqs.patch
memcg-no-stock-lock-for-cpu-hot-unplug.patch
memcg-objcg-stock-trylock-without-irq-disabling.patch

