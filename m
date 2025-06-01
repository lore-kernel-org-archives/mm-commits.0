Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F5E1411DE
	for <mm-commits@vger.kernel.org>; Sun,  1 Jun 2025 05:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748756830; cv=none; b=Tl3J7qdKbhYy4suW7ucY7UI+XZW/rhAM6a/RMM/pkdaoykT+1vPFNbhpx8xI6ybia61EspUCg6MWJflnAkHIV7Zq89/nu3NrPUqu1CfW7xDEaqeZARBPK2DEOjJrWib1GuHSGf5115/oCt02JYB8UGMiIxMS6j0kkIpQxiu+8iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748756830; c=relaxed/simple;
	bh=LFb4z++wg6kkVvuv5jwv/JuM28BWyeE213hxQpX8JgI=;
	h=Date:To:From:Subject:Message-Id; b=NlbkEOMM1IUgKnEMiuBvNwmgFaJEAjhoyV7YjnLDr2/8cmkQRW88V4xw8NlWNu8cExr9I1BOBXCJSz/wzZ8cm9ru8ORpOuK6NQ86hKtwW5XKQ+hwv7jtaX/8rOFKR74Y5/K2EVhsUFioHWjKsKe0U2n9DzjjrgbnDc1XGEVTJAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1D+efPJA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1D+efPJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA06C4CEED;
	Sun,  1 Jun 2025 05:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748756829;
	bh=LFb4z++wg6kkVvuv5jwv/JuM28BWyeE213hxQpX8JgI=;
	h=Date:To:From:Subject:From;
	b=1D+efPJA6jWbbdbVAnh5/iRHPKI4mfPTFeI/tAoCifc8LhBgYWKFy1YzhRkQxSMlW
	 hNp5jp3e4yfYwyD1Nr3ke4hJXK/dbge8pL6yP7mJvjos+tFddu1yCQJej+msD+IJ+k
	 qHnOUNjbXIUSky9aHnWEJ+EQV5C5n6Gn88glWs4U=
Date: Sat, 31 May 2025 22:47:09 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tj@kernel.org,roman.gushchin@linux.dev,peterz@infradead.org,muchun.song@linux.dev,mhocko@kernel.org,mathieu.desnoyers@efficios.com,hannes@cmpxchg.org,bigeasy@linutronix.de,ast@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-make-memcg_rstat_updated-nmi-safe.patch removed from -mm tree
Message-Id: <20250601054709.DAA06C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: make memcg_rstat_updated nmi safe
has been removed from the -mm tree.  Its filename was
     memcg-make-memcg_rstat_updated-nmi-safe.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -531,7 +531,7 @@ struct memcg_vmstats {
 	unsigned long		events_pending[NR_MEMCG_EVENTS];
 
 	/* Stats updates since the last flush */
-	atomic64_t		stats_updates;
+	atomic_t		stats_updates;
 };
 
 /*
@@ -557,7 +557,7 @@ static u64 flush_last_time;
 
 static bool memcg_vmstats_needs_flush(struct memcg_vmstats *vmstats)
 {
-	return atomic64_read(&vmstats->stats_updates) >
+	return atomic_read(&vmstats->stats_updates) >
 		MEMCG_CHARGE_BATCH * num_online_cpus();
 }
 
@@ -571,7 +571,9 @@ static inline void memcg_rstat_updated(s
 	if (!val)
 		return;
 
-	cgroup_rstat_updated(memcg->css.cgroup, cpu);
+	/* TODO: add to cgroup update tree once it is nmi-safe. */
+	if (!in_nmi())
+		cgroup_rstat_updated(memcg->css.cgroup, cpu);
 	statc_pcpu = memcg->vmstats_percpu;
 	for (; statc_pcpu; statc_pcpu = statc->parent_pcpu) {
 		statc = this_cpu_ptr(statc_pcpu);
@@ -589,7 +591,7 @@ static inline void memcg_rstat_updated(s
 			continue;
 
 		stats_updates = this_cpu_xchg(statc_pcpu->stats_updates, 0);
-		atomic64_add(stats_updates, &statc->vmstats->stats_updates);
+		atomic_add(stats_updates, &statc->vmstats->stats_updates);
 	}
 }
 
@@ -597,7 +599,7 @@ static void __mem_cgroup_flush_stats(str
 {
 	bool needs_flush = memcg_vmstats_needs_flush(memcg->vmstats);
 
-	trace_memcg_flush_stats(memcg, atomic64_read(&memcg->vmstats->stats_updates),
+	trace_memcg_flush_stats(memcg, atomic_read(&memcg->vmstats->stats_updates),
 		force, needs_flush);
 
 	if (!force && !needs_flush)
@@ -4119,8 +4121,8 @@ static void mem_cgroup_css_rstat_flush(s
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


