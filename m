Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89811F875A
	for <mm-commits@vger.kernel.org>; Wed, 14 May 2025 05:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747202331; cv=none; b=gM5OYgOvVXBUhoU/rr65fUWL+3C72CPc1pPdYpISmiqo8rkOeEoeH9i5HD7fquUUa9uO909Y+RCnypnIlBpXtv1CGJ/+aQx6yxIcUEshMRIyOLUCgrqlaTSEbUbQbbQ6biMWR1vjCPLlzfdiMrxVYYpbJRjR0LB90DXHgm76b0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747202331; c=relaxed/simple;
	bh=0mU/H8+cSlXyNVyuoKlz3cvVmfZac0dr2udJNjF9iQM=;
	h=Date:To:From:Subject:Message-Id; b=U9Jlp4Bn5sMp2u6qlkXraWrcy/4hkBrdDCZVYdFGdMG8L+PS7XjIr3aRIFy/YWiMbGQSTTcva3GyIULl4GAe89K3Ovu7ptecni3j7vNnP764E2+jWCIAMNguPPSUUpVkhWgRi80rwkXxxuww2s65B/io9wksL+EaynzyaRIqyzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C1wn1DLB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C1wn1DLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB47C4CEE9;
	Wed, 14 May 2025 05:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747202331;
	bh=0mU/H8+cSlXyNVyuoKlz3cvVmfZac0dr2udJNjF9iQM=;
	h=Date:To:From:Subject:From;
	b=C1wn1DLBiD1EUMcYbHYC/KLVA1ZCjXUXUZNJoTayKqrD6ozoDscB90/RNIw1f8FZC
	 tHvuDn+zQsbKQf9MF5bh0NtkmMCQBj/5SauZXNqVppQNYQdj9U/+24k+5xkaXu/DDm
	 fbbnrW5+yqlzQRI1FHA8h3rMKPfrBiw1eIgkfssA=
Date: Tue, 13 May 2025 22:58:51 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,bigeasy@linutronix.de,ast@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-make-mod_memcg_state-re-entrant-safe-against-irqs.patch added to mm-new branch
Message-Id: <20250514055851.9CB47C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: make mod_memcg_state re-entrant safe against irqs
has been added to the -mm mm-new branch.  Its filename is
     memcg-make-mod_memcg_state-re-entrant-safe-against-irqs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-make-mod_memcg_state-re-entrant-safe-against-irqs.patch

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
Subject: memcg: make mod_memcg_state re-entrant safe against irqs
Date: Tue, 13 May 2025 22:08:09 -0700

Let's make mod_memcg_state re-entrant safe against irqs.  The only thing
needed is to convert the usage of __this_cpu_add() to this_cpu_add().  In
addition, with re-entrant safety, there is no need to disable irqs.

mod_memcg_state() is not safe against nmi, so let's add warning if someone
tries to call it in nmi context.

Link: https://lkml.kernel.org/r/20250514050813.2526843-4-shakeel.butt@linux.dev
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

 include/linux/memcontrol.h |   20 ++------------------
 mm/memcontrol.c            |    8 ++++----
 2 files changed, 6 insertions(+), 22 deletions(-)

--- a/include/linux/memcontrol.h~memcg-make-mod_memcg_state-re-entrant-safe-against-irqs
+++ a/include/linux/memcontrol.h
@@ -903,19 +903,9 @@ struct mem_cgroup *mem_cgroup_get_oom_gr
 					    struct mem_cgroup *oom_domain);
 void mem_cgroup_print_oom_group(struct mem_cgroup *memcg);
 
-void __mod_memcg_state(struct mem_cgroup *memcg, enum memcg_stat_item idx,
-		       int val);
-
 /* idx can be of type enum memcg_stat_item or node_stat_item */
-static inline void mod_memcg_state(struct mem_cgroup *memcg,
-				   enum memcg_stat_item idx, int val)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__mod_memcg_state(memcg, idx, val);
-	local_irq_restore(flags);
-}
+void mod_memcg_state(struct mem_cgroup *memcg,
+		     enum memcg_stat_item idx, int val);
 
 static inline void mod_memcg_page_state(struct page *page,
 					enum memcg_stat_item idx, int val)
@@ -1375,12 +1365,6 @@ static inline void mem_cgroup_print_oom_
 {
 }
 
-static inline void __mod_memcg_state(struct mem_cgroup *memcg,
-				     enum memcg_stat_item idx,
-				     int nr)
-{
-}
-
 static inline void mod_memcg_state(struct mem_cgroup *memcg,
 				   enum memcg_stat_item idx,
 				   int nr)
--- a/mm/memcontrol.c~memcg-make-mod_memcg_state-re-entrant-safe-against-irqs
+++ a/mm/memcontrol.c
@@ -681,12 +681,12 @@ static int memcg_state_val_in_pages(int
 }
 
 /**
- * __mod_memcg_state - update cgroup memory statistics
+ * mod_memcg_state - update cgroup memory statistics
  * @memcg: the memory cgroup
  * @idx: the stat item - can be enum memcg_stat_item or enum node_stat_item
  * @val: delta to add to the counter, can be negative
  */
-void __mod_memcg_state(struct mem_cgroup *memcg, enum memcg_stat_item idx,
+void mod_memcg_state(struct mem_cgroup *memcg, enum memcg_stat_item idx,
 		       int val)
 {
 	int i = memcg_stats_index(idx);
@@ -700,7 +700,7 @@ void __mod_memcg_state(struct mem_cgroup
 
 	cpu = get_cpu();
 
-	__this_cpu_add(memcg->vmstats_percpu->state[i], val);
+	this_cpu_add(memcg->vmstats_percpu->state[i], val);
 	val = memcg_state_val_in_pages(idx, val);
 	memcg_rstat_updated(memcg, val, cpu);
 	trace_mod_memcg_state(memcg, idx, val);
@@ -2920,7 +2920,7 @@ static void drain_obj_stock(struct obj_s
 
 			memcg = get_mem_cgroup_from_objcg(old);
 
-			__mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
+			mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
 			memcg1_account_kmem(memcg, -nr_pages);
 			if (!mem_cgroup_is_root(memcg))
 				memcg_uncharge(memcg, nr_pages);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-memcg_rstat_updated-re-entrant-safe-against-irqs.patch
memcg-move-preempt-disable-to-callers-of-memcg_rstat_updated.patch
memcg-make-mod_memcg_state-re-entrant-safe-against-irqs.patch
memcg-make-count_memcg_events-re-entrant-safe-against-irqs.patch
memcg-make-__mod_memcg_lruvec_state-re-entrant-safe-against-irqs.patch
memcg-no-stock-lock-for-cpu-hot-unplug.patch
memcg-objcg-stock-trylock-without-irq-disabling.patch

