Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D758415E88
	for <mm-commits@vger.kernel.org>; Thu, 15 Aug 2024 22:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723762052; cv=none; b=nuW52xnDia5od6yz8MIfYNs5p/afonIhFlUUAdnEM8Ae9tgbLaReXB5+rzd1ke9hd/5/J26f/5IaQjTed88s5JH0aiTqwsz21JvuDvN6eJBlsfzLYu9KzoxRozjdDHxgjuUUjctQg2sB63BmLDknXcCqLYi+iwyH+Z1AVWWVbsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723762052; c=relaxed/simple;
	bh=c32WYVx7iuV+9C8juhOysbh0hs2CHDNi4u9asOEqpaM=;
	h=Date:To:From:Subject:Message-Id; b=FcXNI9c8wIu7rtNdDJDeEB4kmCRpXAuYoW4GDz/fl01LZSeTo8pO/Y5pSjfcWenWxRJLy3lTrBvUKfvt9mbYPUWdmQ6cRZURbwRtAomphUJwafwH8ss1HzO4gp7LJkVaSSsOwJjmmcozajAjG3q1GvTTqLnLzrvFRvK3Mp8bXkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=euoulL3g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="euoulL3g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DA8C32786;
	Thu, 15 Aug 2024 22:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723762052;
	bh=c32WYVx7iuV+9C8juhOysbh0hs2CHDNi4u9asOEqpaM=;
	h=Date:To:From:Subject:From;
	b=euoulL3giVtOoG7e8U+J/aCpMA28cf8mmGMd++GHvdI+TIw1njbkh4c5z12KJWi69
	 ErVdBDM1xKXTKVBb35JB867eB5tZL2ur/qx0GYpBhP/6PDrRAnPS+FdC05GnFMm93n
	 GxyFllkpGmJ3Hs7hzruDY5uqflMWfNp+uMXcc3cA=
Date: Thu, 15 Aug 2024 15:47:31 -0700
To: mm-commits@vger.kernel.org,tjmercier@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-move-v1-only-percpu-stats-in-separate-struct.patch added to mm-unstable branch
Message-Id: <20240815224732.93DA8C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: move v1 only percpu stats in separate struct
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-move-v1-only-percpu-stats-in-separate-struct.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-move-v1-only-percpu-stats-in-separate-struct.patch

This patch will later appear in the mm-unstable branch at
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
@@ -488,10 +488,6 @@ struct memcg_vmstats_percpu {
 	/* Delta calculation for lockless upward propagation */
 	long			state_prev[MEMCG_VMSTAT_SIZE];
 	unsigned long		events_prev[NR_MEMCG_EVENTS];
-
-	/* Cgroup1: threshold notifications & softlimit tree updates */
-	unsigned long		nr_page_events;
-	unsigned long		targets[MEM_CGROUP_NTARGETS];
 } ____cacheline_aligned;
 
 struct memcg_vmstats {
@@ -868,7 +864,7 @@ void mem_cgroup_charge_statistics(struct
 		nr_pages = -nr_pages; /* for event */
 	}
 
-	__this_cpu_add(memcg->vmstats_percpu->nr_page_events, nr_pages);
+	__this_cpu_add(memcg->events_percpu->nr_page_events, nr_pages);
 }
 
 bool mem_cgroup_event_ratelimit(struct mem_cgroup *memcg,
@@ -876,8 +872,8 @@ bool mem_cgroup_event_ratelimit(struct m
 {
 	unsigned long val, next;
 
-	val = __this_cpu_read(memcg->vmstats_percpu->nr_page_events);
-	next = __this_cpu_read(memcg->vmstats_percpu->targets[target]);
+	val = __this_cpu_read(memcg->events_percpu->nr_page_events);
+	next = __this_cpu_read(memcg->events_percpu->targets[target]);
 	/* from time_after() in jiffies.h */
 	if ((long)(next - val) < 0) {
 		switch (target) {
@@ -890,7 +886,7 @@ bool mem_cgroup_event_ratelimit(struct m
 		default:
 			break;
 		}
-		__this_cpu_write(memcg->vmstats_percpu->targets[target], next);
+		__this_cpu_write(memcg->events_percpu->targets[target], next);
 		return true;
 	}
 	return false;
@@ -3523,6 +3519,7 @@ static void __mem_cgroup_free(struct mem
 
 	for_each_node(node)
 		free_mem_cgroup_per_node_info(memcg, node);
+	memcg1_free_events(memcg);
 	kfree(memcg->vmstats);
 	free_percpu(memcg->vmstats_percpu);
 	kfree(memcg);
@@ -3563,6 +3560,9 @@ static struct mem_cgroup *mem_cgroup_all
 	if (!memcg->vmstats_percpu)
 		goto fail;
 
+	if (!memcg1_alloc_events(memcg))
+		goto fail;
+
 	for_each_possible_cpu(cpu) {
 		if (parent)
 			pstatc = per_cpu_ptr(parent->vmstats_percpu, cpu);
@@ -4678,7 +4678,7 @@ static void uncharge_batch(const struct
 
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

memcg-increase-the-valid-index-range-for-memcg-stats.patch
memcg-replace-memcg-id-idr-with-xarray.patch
memcg-replace-memcg-id-idr-with-xarray-v2.patch
memcg-use-ratelimited-stats-flush-in-the-reclaim.patch
memcg-move-v1-only-percpu-stats-in-separate-struct.patch
memcg-move-mem_cgroup_event_ratelimit-to-v1-code.patch
memcg-move-mem_cgroup_charge_statistics-to-v1-code.patch
memcg-move-v1-events-and-statistics-code-to-v1-file.patch
memcg-make-v1-only-functions-static.patch
memcg-allocate-v1-event-percpu-only-on-v1-deployment.patch
memcg-make-pgpgin-and-pgpgout-v1-only.patch

