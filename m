Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 796F0C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiJCVLl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiJCVJe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:09:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08F7193C9
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 623C0B811BF
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C8AC433C1;
        Mon,  3 Oct 2022 21:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831200;
        bh=7F2n5/ecMfjmuNEjPqTJRDyqbh3jT6fRAKx01ew8LSs=;
        h=Date:To:From:Subject:From;
        b=NoRSeu4UFENN/08K9mGJrFGMe387zmeE1f1hRI2Jq/9XtzoAn/Kv3K1Ano3W3Bf8o
         FoE8eZRz34xr/t5PvBr7xqW/P/3dK84/oMw8u1ZUgZIuaR9xctgaYIxbrzE8u3Hr2R
         PLH2WoI9SqBkGjcd5LIYu6K6qCReH3Qpz6ieOLWA=
Date:   Mon, 03 Oct 2022 14:06:39 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        roman.gushchin@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        shakeelb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-extract-memcg_vmstats-from-struct-mem_cgroup.patch removed from -mm tree
Message-Id: <20221003210640.15C8AC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memcg: extract memcg_vmstats from struct mem_cgroup
has been removed from the -mm tree.  Its filename was
     memcg-extract-memcg_vmstats-from-struct-mem_cgroup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
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


