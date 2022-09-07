Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88FF8C38145
	for <mm-commits@archiver.kernel.org>; Wed,  7 Sep 2022 22:52:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiIGWv6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Sep 2022 18:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiIGWvZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Sep 2022 18:51:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC26B2761
        for <mm-commits@vger.kernel.org>; Wed,  7 Sep 2022 15:51:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D8D3B81F56
        for <mm-commits@vger.kernel.org>; Wed,  7 Sep 2022 22:51:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58D3C433C1;
        Wed,  7 Sep 2022 22:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662591078;
        bh=DKJM9YaRvI2loERlkUfym1GJfLep/Exlr3P0K8E98PE=;
        h=Date:To:From:Subject:From;
        b=XG50hOs74JqAiizcygdQ8ZrnuyK2z1kTaWFsI/IOvNOH5yMYrA74dJjdJfj6x2OqR
         TK1P8l4ojjI6gK/qz52pL2SA2EdpB3+8XbKSR5en4t1x5+KsbciqnNEVAUARaZGDpn
         3q+diEyIzO6u4wCNANMQLNma92KYcn4vCJxfuNNQ=
Date:   Wed, 07 Sep 2022 15:51:18 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        roman.gushchin@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        shakeelb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-extract-memcg_vmstats-from-struct-mem_cgroup.patch added to mm-unstable branch
Message-Id: <20220907225118.D58D3C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: extract memcg_vmstats from struct mem_cgroup
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-extract-memcg_vmstats-from-struct-mem_cgroup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-extract-memcg_vmstats-from-struct-mem_cgroup.patch

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
From: Shakeel Butt <shakeelb@google.com>
Subject: memcg: extract memcg_vmstats from struct mem_cgroup
Date: Wed, 7 Sep 2022 04:35:35 +0000

Patch series "memcg: reduce memory overhead of memory cgroups".

Currently a lot of memory is wasted to maintain the vmevents for memory
cgroups as we have multiple arrays of size NR_VM_EVENT_ITEMS which can be
as large as 110.  However memcg code uses small portion of those entries. 
This patch series eliminate this overhead by removing the unneeded vmevent
entries from memory cgroup data structures.


This patch (of 3):

This is a preparatory patch to reduce the memory overhead of memory
cgroup. The struct memcg_vmstats is the largest object embedded into the
struct mem_cgroup. This patch extracts struct memcg_vmstats from struct
mem_cgroup to ease the following patches in reducing the size of struct
memcg_vmstats.

Link: https://lkml.kernel.org/r/20220907043537.3457014-1-shakeelb@google.com
Link: https://lkml.kernel.org/r/20220907043537.3457014-2-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   37 ++--------------------
 mm/memcontrol.c            |   57 +++++++++++++++++++++++++++++------
 2 files changed, 52 insertions(+), 42 deletions(-)

--- a/include/linux/memcontrol.h~memcg-extract-memcg_vmstats-from-struct-mem_cgroup
+++ a/include/linux/memcontrol.h
@@ -80,29 +80,8 @@ enum mem_cgroup_events_target {
 	MEM_CGROUP_NTARGETS,
 };
 
-struct memcg_vmstats_percpu {
-	/* Local (CPU and cgroup) page state & events */
-	long			state[MEMCG_NR_STAT];
-	unsigned long		events[NR_VM_EVENT_ITEMS];
-
-	/* Delta calculation for lockless upward propagation */
-	long			state_prev[MEMCG_NR_STAT];
-	unsigned long		events_prev[NR_VM_EVENT_ITEMS];
-
-	/* Cgroup1: threshold notifications & softlimit tree updates */
-	unsigned long		nr_page_events;
-	unsigned long		targets[MEM_CGROUP_NTARGETS];
-};
-
-struct memcg_vmstats {
-	/* Aggregated (CPU and subtree) page state & events */
-	long			state[MEMCG_NR_STAT];
-	unsigned long		events[NR_VM_EVENT_ITEMS];
-
-	/* Pending child counts during tree propagation */
-	long			state_pending[MEMCG_NR_STAT];
-	unsigned long		events_pending[NR_VM_EVENT_ITEMS];
-};
+struct memcg_vmstats_percpu;
+struct memcg_vmstats;
 
 struct mem_cgroup_reclaim_iter {
 	struct mem_cgroup *position;
@@ -298,7 +277,7 @@ struct mem_cgroup {
 	CACHELINE_PADDING(_pad1_);
 
 	/* memory.stat */
-	struct memcg_vmstats	vmstats;
+	struct memcg_vmstats	*vmstats;
 
 	/* memory.events */
 	atomic_long_t		memory_events[MEMCG_NR_MEMORY_EVENTS];
@@ -1001,15 +980,7 @@ static inline void mod_memcg_page_state(
 	rcu_read_unlock();
 }
 
-static inline unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
-{
-	long x = READ_ONCE(memcg->vmstats.state[idx]);
-#ifdef CONFIG_SMP
-	if (x < 0)
-		x = 0;
-#endif
-	return x;
-}
+unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx);
 
 static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
 					      enum node_stat_item idx)
--- a/mm/memcontrol.c~memcg-extract-memcg_vmstats-from-struct-mem_cgroup
+++ a/mm/memcontrol.c
@@ -669,6 +669,40 @@ static void flush_memcg_stats_dwork(stru
 	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, FLUSH_TIME);
 }
 
+struct memcg_vmstats_percpu {
+	/* Local (CPU and cgroup) page state & events */
+	long			state[MEMCG_NR_STAT];
+	unsigned long		events[NR_VM_EVENT_ITEMS];
+
+	/* Delta calculation for lockless upward propagation */
+	long			state_prev[MEMCG_NR_STAT];
+	unsigned long		events_prev[NR_VM_EVENT_ITEMS];
+
+	/* Cgroup1: threshold notifications & softlimit tree updates */
+	unsigned long		nr_page_events;
+	unsigned long		targets[MEM_CGROUP_NTARGETS];
+};
+
+struct memcg_vmstats {
+	/* Aggregated (CPU and subtree) page state & events */
+	long			state[MEMCG_NR_STAT];
+	unsigned long		events[NR_VM_EVENT_ITEMS];
+
+	/* Pending child counts during tree propagation */
+	long			state_pending[MEMCG_NR_STAT];
+	unsigned long		events_pending[NR_VM_EVENT_ITEMS];
+};
+
+unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
+{
+	long x = READ_ONCE(memcg->vmstats->state[idx]);
+#ifdef CONFIG_SMP
+	if (x < 0)
+		x = 0;
+#endif
+	return x;
+}
+
 /**
  * __mod_memcg_state - update cgroup memory statistics
  * @memcg: the memory cgroup
@@ -827,7 +861,7 @@ void __count_memcg_events(struct mem_cgr
 
 static unsigned long memcg_events(struct mem_cgroup *memcg, int event)
 {
-	return READ_ONCE(memcg->vmstats.events[event]);
+	return READ_ONCE(memcg->vmstats->events[event]);
 }
 
 static unsigned long memcg_events_local(struct mem_cgroup *memcg, int event)
@@ -5170,6 +5204,7 @@ static void __mem_cgroup_free(struct mem
 
 	for_each_node(node)
 		free_mem_cgroup_per_node_info(memcg, node);
+	kfree(memcg->vmstats);
 	free_percpu(memcg->vmstats_percpu);
 	kfree(memcg);
 }
@@ -5199,6 +5234,10 @@ static struct mem_cgroup *mem_cgroup_all
 		goto fail;
 	}
 
+	memcg->vmstats = kzalloc(sizeof(struct memcg_vmstats), GFP_KERNEL);
+	if (!memcg->vmstats)
+		goto fail;
+
 	memcg->vmstats_percpu = alloc_percpu_gfp(struct memcg_vmstats_percpu,
 						 GFP_KERNEL_ACCOUNT);
 	if (!memcg->vmstats_percpu)
@@ -5418,9 +5457,9 @@ static void mem_cgroup_css_rstat_flush(s
 		 * below us. We're in a per-cpu loop here and this is
 		 * a global counter, so the first cycle will get them.
 		 */
-		delta = memcg->vmstats.state_pending[i];
+		delta = memcg->vmstats->state_pending[i];
 		if (delta)
-			memcg->vmstats.state_pending[i] = 0;
+			memcg->vmstats->state_pending[i] = 0;
 
 		/* Add CPU changes on this level since the last flush */
 		v = READ_ONCE(statc->state[i]);
@@ -5433,15 +5472,15 @@ static void mem_cgroup_css_rstat_flush(s
 			continue;
 
 		/* Aggregate counts on this level and propagate upwards */
-		memcg->vmstats.state[i] += delta;
+		memcg->vmstats->state[i] += delta;
 		if (parent)
-			parent->vmstats.state_pending[i] += delta;
+			parent->vmstats->state_pending[i] += delta;
 	}
 
 	for (i = 0; i < NR_VM_EVENT_ITEMS; i++) {
-		delta = memcg->vmstats.events_pending[i];
+		delta = memcg->vmstats->events_pending[i];
 		if (delta)
-			memcg->vmstats.events_pending[i] = 0;
+			memcg->vmstats->events_pending[i] = 0;
 
 		v = READ_ONCE(statc->events[i]);
 		if (v != statc->events_prev[i]) {
@@ -5452,9 +5491,9 @@ static void mem_cgroup_css_rstat_flush(s
 		if (!delta)
 			continue;
 
-		memcg->vmstats.events[i] += delta;
+		memcg->vmstats->events[i] += delta;
 		if (parent)
-			parent->vmstats.events_pending[i] += delta;
+			parent->vmstats->events_pending[i] += delta;
 	}
 
 	for_each_node_state(nid, N_MEMORY) {
_

Patches currently in -mm which might be from shakeelb@google.com are

mm-page_counter-remove-unneeded-atomic-ops-for-low-min.patch
mm-page_counter-rearrange-struct-page_counter-fields.patch
memcg-increase-memcg_charge_batch-to-64.patch
mm-deduplicate-cacheline-padding-code.patch
memcg-extract-memcg_vmstats-from-struct-mem_cgroup.patch
memcg-rearrange-code.patch
memcg-reduce-size-of-memcg-vmstats-structures.patch

