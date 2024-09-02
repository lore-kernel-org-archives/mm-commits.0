Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC01042A9F
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247847; cv=none; b=M7GzfJOBUEB02KBvnMjNuG/WTdtTGCntl+A83Y1QPRVVWeN5qNsWLArJKk5ye8r64JX2FtAaLL3G4fi+A1SruYfysAediPcKWfjKrlSThItUOMWvFOhzp5yd/BB27NGdN3yupQG4XxOb7RR2iMdp/SzwpAxAF0xaoFDy3p8skzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247847; c=relaxed/simple;
	bh=Hmd3WTwF171MwkVb9v+JobwaH3hqkv7kFOW0hT+5tAs=;
	h=Date:To:From:Subject:Message-Id; b=ts5MfLMTl25sBnp1ubZQtOZEWvC+JESJxWQ+utQxY64oJKEUg1g519fIAPWR3iiQSHW1rnILa19c8PmDs9EkLMNkSh7F6QvhqSU9jNuFTyXiV2w8ogvFZEDPhIU7Y0pezfUPb62/0sr1K+5mM0szL7xFUklR3OH+SzkgMSA9uKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VPkQ5jIO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VPkQ5jIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24E8C4CEC2;
	Mon,  2 Sep 2024 03:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247847;
	bh=Hmd3WTwF171MwkVb9v+JobwaH3hqkv7kFOW0hT+5tAs=;
	h=Date:To:From:Subject:From;
	b=VPkQ5jIOb/nMffGGPS2DcNuJ9ZUZM1CG3BuxbZ6u4uyyvYvWWikOHFx4lJEVfOuT+
	 H2bLxEaKdYJi81E4GAzwki9P627BfmKRZZopdLMWUcTOQ+8MLnNONVA2O7PTIu7dKz
	 FiYq/RuvrdSzoojBzLpjPEcPlW0A2ahZ/Q36y5PE=
Date: Sun, 01 Sep 2024 20:30:47 -0700
To: mm-commits@vger.kernel.org,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-move-v1-only-percpu-stats-in-separate-struct.patch removed from -mm tree
Message-Id: <20240902033047.A24E8C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: move v1 only percpu stats in separate struct
has been removed from the -mm tree.  Its filename was
     memcg-move-v1-only-percpu-stats-in-separate-struct.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: move v1 only percpu stats in separate struct
Date: Wed, 14 Aug 2024 22:04:47 -0700

Patch series "memcg: further decouple v1 code from v2".

Some of the v1 code is still in v2 code base due to v1 fields in the
struct memcg_vmstats_percpu.  This field decouples those fileds from v2
struct and move all the related code into v1 only code base.


This patch (of 7):

At the moment struct memcg_vmstats_percpu contains two v1 only fields
which consumes memory even when CONFIG_MEMCG_V1 is not enabled.  In
addition there are v1 only functions accessing them and are in the main
memcontrol source file and can not be moved to v1 only source file due to
these fields.  Let's move these fields into their own struct.  Later
patches will move the functions accessing them to v1 source file and only
allocate these fields when CONFIG_MEMCG_V1 is enabled.

Link: https://lkml.kernel.org/r/20240815050453.1298138-1-shakeel.butt@linux.dev
Link: https://lkml.kernel.org/r/20240815050453.1298138-2-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 ++
 mm/memcontrol-v1.h         |   19 +++++++++++++++++++
 mm/memcontrol.c            |   18 +++++++++---------
 3 files changed, 30 insertions(+), 9 deletions(-)

--- a/include/linux/memcontrol.h~memcg-move-v1-only-percpu-stats-in-separate-struct
+++ a/include/linux/memcontrol.h
@@ -70,6 +70,7 @@ struct mem_cgroup_id {
 };
 
 struct memcg_vmstats_percpu;
+struct memcg1_events_percpu;
 struct memcg_vmstats;
 struct lruvec_stats_percpu;
 struct lruvec_stats;
@@ -254,6 +255,7 @@ struct mem_cgroup {
 	struct list_head objcg_list;
 
 	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
+	struct memcg1_events_percpu __percpu *events_percpu;
 
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct list_head cgwb_list;
--- a/mm/memcontrol.c~memcg-move-v1-only-percpu-stats-in-separate-struct
+++ a/mm/memcontrol.c
@@ -477,10 +477,6 @@ struct memcg_vmstats_percpu {
 	/* Delta calculation for lockless upward propagation */
 	long			state_prev[MEMCG_VMSTAT_SIZE];
 	unsigned long		events_prev[NR_MEMCG_EVENTS];
-
-	/* Cgroup1: threshold notifications & softlimit tree updates */
-	unsigned long		nr_page_events;
-	unsigned long		targets[MEM_CGROUP_NTARGETS];
 } ____cacheline_aligned;
 
 struct memcg_vmstats {
@@ -857,7 +853,7 @@ void mem_cgroup_charge_statistics(struct
 		nr_pages = -nr_pages; /* for event */
 	}
 
-	__this_cpu_add(memcg->vmstats_percpu->nr_page_events, nr_pages);
+	__this_cpu_add(memcg->events_percpu->nr_page_events, nr_pages);
 }
 
 bool mem_cgroup_event_ratelimit(struct mem_cgroup *memcg,
@@ -865,8 +861,8 @@ bool mem_cgroup_event_ratelimit(struct m
 {
 	unsigned long val, next;
 
-	val = __this_cpu_read(memcg->vmstats_percpu->nr_page_events);
-	next = __this_cpu_read(memcg->vmstats_percpu->targets[target]);
+	val = __this_cpu_read(memcg->events_percpu->nr_page_events);
+	next = __this_cpu_read(memcg->events_percpu->targets[target]);
 	/* from time_after() in jiffies.h */
 	if ((long)(next - val) < 0) {
 		switch (target) {
@@ -879,7 +875,7 @@ bool mem_cgroup_event_ratelimit(struct m
 		default:
 			break;
 		}
-		__this_cpu_write(memcg->vmstats_percpu->targets[target], next);
+		__this_cpu_write(memcg->events_percpu->targets[target], next);
 		return true;
 	}
 	return false;
@@ -3477,6 +3473,7 @@ static void __mem_cgroup_free(struct mem
 
 	for_each_node(node)
 		free_mem_cgroup_per_node_info(memcg, node);
+	memcg1_free_events(memcg);
 	kfree(memcg->vmstats);
 	free_percpu(memcg->vmstats_percpu);
 	kfree(memcg);
@@ -3517,6 +3514,9 @@ static struct mem_cgroup *mem_cgroup_all
 	if (!memcg->vmstats_percpu)
 		goto fail;
 
+	if (!memcg1_alloc_events(memcg))
+		goto fail;
+
 	for_each_possible_cpu(cpu) {
 		if (parent)
 			pstatc = per_cpu_ptr(parent->vmstats_percpu, cpu);
@@ -4631,7 +4631,7 @@ static void uncharge_batch(const struct
 
 	local_irq_save(flags);
 	__count_memcg_events(ug->memcg, PGPGOUT, ug->pgpgout);
-	__this_cpu_add(ug->memcg->vmstats_percpu->nr_page_events, ug->nr_memory);
+	__this_cpu_add(ug->memcg->events_percpu->nr_page_events, ug->nr_memory);
 	memcg1_check_events(ug->memcg, ug->nid);
 	local_irq_restore(flags);
 
--- a/mm/memcontrol-v1.h~memcg-move-v1-only-percpu-stats-in-separate-struct
+++ a/mm/memcontrol-v1.h
@@ -56,6 +56,12 @@ enum mem_cgroup_events_target {
 	MEM_CGROUP_NTARGETS,
 };
 
+/* Cgroup1: threshold notifications & softlimit tree updates */
+struct memcg1_events_percpu {
+	unsigned long nr_page_events;
+	unsigned long targets[MEM_CGROUP_NTARGETS];
+};
+
 bool mem_cgroup_event_ratelimit(struct mem_cgroup *memcg,
 				enum mem_cgroup_events_target target);
 unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap);
@@ -69,6 +75,19 @@ unsigned long memcg_page_state_output(st
 unsigned long memcg_page_state_local_output(struct mem_cgroup *memcg, int item);
 int memory_stat_show(struct seq_file *m, void *v);
 
+static inline bool memcg1_alloc_events(struct mem_cgroup *memcg)
+{
+	memcg->events_percpu = alloc_percpu_gfp(struct memcg1_events_percpu,
+						GFP_KERNEL_ACCOUNT);
+	return !!memcg->events_percpu;
+}
+
+static inline void memcg1_free_events(struct mem_cgroup *memcg)
+{
+	if (memcg->events_percpu)
+		free_percpu(memcg->events_percpu);
+}
+
 /* Cgroup v1-specific declarations */
 #ifdef CONFIG_MEMCG_V1
 void memcg1_memcg_init(struct mem_cgroup *memcg);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


