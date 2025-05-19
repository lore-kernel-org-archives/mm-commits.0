Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F9A21CC48
	for <mm-commits@vger.kernel.org>; Mon, 19 May 2025 22:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747693772; cv=none; b=tREAclMtn5jYdu0JOuczo6QPllfP7xYXED2q4xquPbgO6kyuhif9eAdV0W18+rotAbgAE34gOerzFMZQQJfJ6GxRJ8sru7gnb4veCfwYS5D77OOHMLQcwpWOkeggTWl4pr4cZT5pjOryvllSI+AaBDVU29tJKJtPdW9Cj7Oh52k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747693772; c=relaxed/simple;
	bh=Lk/7OabTcRtb7OPg2z7J3z9oTCnP29EUnY6R/3tEDYI=;
	h=Date:To:From:Subject:Message-Id; b=cCWJU8s/91aMVckpkoJ4HZuIoeHrslTehjRvrZlpWKTcAi+cxoSh/4ySP8kVq86FKSDW0MvSM+I6wirjS+EPV898c50FNxUtXwLISM8uKb0O3fQuuEtAtOqKqtlU15fpUtnYqRdMNMrsDUqG9+iq9HRaXIASG9tWhTN+KHgteO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JAmjPRAH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JAmjPRAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD39AC4CEE4;
	Mon, 19 May 2025 22:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747693771;
	bh=Lk/7OabTcRtb7OPg2z7J3z9oTCnP29EUnY6R/3tEDYI=;
	h=Date:To:From:Subject:From;
	b=JAmjPRAHXg9gPG85yIBOuIqD9ATtLZDyzVCGaXOKgObBYrZsnaxmQyn0js0ME2AX4
	 us5JHnJ8BcHh5hMWgPTDud8HbQ3ypycr+04CbsZxqvI/jeO0OL/HbhO0elzWVBMbBX
	 nNPnsbzklJEPvo7RH5hqzbM1+EDy4Np+I/Lymceo=
Date: Mon, 19 May 2025 15:29:31 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tj@kernel.org,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mhocko@kernel.org,mathieu.desnoyers@efficios.com,hannes@cmpxchg.org,bigeasy@linutronix.de,ast@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-make-memcg_rstat_updated-nmi-safe.patch added to mm-new branch
Message-Id: <20250519222931.CD39AC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: make memcg_rstat_updated nmi safe
has been added to the -mm mm-new branch.  Its filename is
     memcg-make-memcg_rstat_updated-nmi-safe.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-make-memcg_rstat_updated-nmi-safe.patch

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
Subject: memcg: make memcg_rstat_updated nmi safe
Date: Sun, 18 May 2025 23:31:42 -0700

Currently kernel maintains memory related stats updates per-cgroup to
optimize stats flushing.  The stats_updates is defined as atomic64_t which
is not nmi-safe on some archs.  Actually we don't really need 64bit atomic
as the max value stats_updates can get should be less than nr_cpus *
MEMCG_CHARGE_BATCH.  A normal atomic_t should suffice.

Also the function cgroup_rstat_updated() is still not nmi-safe but there
is parallel effort to make it nmi-safe, so until then let's ignore it in
the nmi context.

Link: https://lkml.kernel.org/r/20250519063142.111219-6-shakeel.butt@linux.dev
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

 mm/memcontrol.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/mm/memcontrol.c~memcg-make-memcg_rstat_updated-nmi-safe
+++ a/mm/memcontrol.c
@@ -533,7 +533,7 @@ struct memcg_vmstats {
 	unsigned long		events_pending[NR_MEMCG_EVENTS];
 
 	/* Stats updates since the last flush */
-	atomic64_t		stats_updates;
+	atomic_t		stats_updates;
 };
 
 /*
@@ -559,7 +559,7 @@ static u64 flush_last_time;
 
 static bool memcg_vmstats_needs_flush(struct memcg_vmstats *vmstats)
 {
-	return atomic64_read(&vmstats->stats_updates) >
+	return atomic_read(&vmstats->stats_updates) >
 		MEMCG_CHARGE_BATCH * num_online_cpus();
 }
 
@@ -573,7 +573,9 @@ static inline void memcg_rstat_updated(s
 	if (!val)
 		return;
 
-	cgroup_rstat_updated(memcg->css.cgroup, cpu);
+	/* TODO: add to cgroup update tree once it is nmi-safe. */
+	if (!in_nmi())
+		cgroup_rstat_updated(memcg->css.cgroup, cpu);
 	statc_pcpu = memcg->vmstats_percpu;
 	for (; statc_pcpu; statc_pcpu = statc->parent_pcpu) {
 		statc = this_cpu_ptr(statc_pcpu);
@@ -591,7 +593,7 @@ static inline void memcg_rstat_updated(s
 			continue;
 
 		stats_updates = this_cpu_xchg(statc_pcpu->stats_updates, 0);
-		atomic64_add(stats_updates, &statc->vmstats->stats_updates);
+		atomic_add(stats_updates, &statc->vmstats->stats_updates);
 	}
 }
 
@@ -599,7 +601,7 @@ static void __mem_cgroup_flush_stats(str
 {
 	bool needs_flush = memcg_vmstats_needs_flush(memcg->vmstats);
 
-	trace_memcg_flush_stats(memcg, atomic64_read(&memcg->vmstats->stats_updates),
+	trace_memcg_flush_stats(memcg, atomic_read(&memcg->vmstats->stats_updates),
 		force, needs_flush);
 
 	if (!force && !needs_flush)
@@ -4121,8 +4123,8 @@ static void mem_cgroup_css_rstat_flush(s
 	}
 	WRITE_ONCE(statc->stats_updates, 0);
 	/* We are in a per-cpu loop here, only do the atomic write once */
-	if (atomic64_read(&memcg->vmstats->stats_updates))
-		atomic64_set(&memcg->vmstats->stats_updates, 0);
+	if (atomic_read(&memcg->vmstats->stats_updates))
+		atomic_set(&memcg->vmstats->stats_updates, 0);
 }
 
 static void mem_cgroup_fork(struct task_struct *task)
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

