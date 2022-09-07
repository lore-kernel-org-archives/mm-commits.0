Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1244C54EE9
	for <mm-commits@archiver.kernel.org>; Wed,  7 Sep 2022 22:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiIGWv5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Sep 2022 18:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiIGWvZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Sep 2022 18:51:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB899B3B0C
        for <mm-commits@vger.kernel.org>; Wed,  7 Sep 2022 15:51:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 485466189F
        for <mm-commits@vger.kernel.org>; Wed,  7 Sep 2022 22:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ADD2C433D6;
        Wed,  7 Sep 2022 22:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662591082;
        bh=TX5rHdJ5l1CqwihA2g+dCmi/Zby+0ZYNxm+YIh5/Ics=;
        h=Date:To:From:Subject:From;
        b=K67my5MbUUD84nzlquiv73EVNXJ+DBpajSyTKZ3wqboV1TxZnU1HF2yL/NIGpG46H
         fdpcekvjQvzrb2UMnWjaHUNptbDdWFyzF1KawA7+1PZdE4JYL/OYNxUiTHJ6geIwyF
         cAvYwF7YVu3JHsYGlHdhcqqvf0cBdSz8DA2EMzwU=
Date:   Wed, 07 Sep 2022 15:51:22 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        roman.gushchin@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        shakeelb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-reduce-size-of-memcg-vmstats-structures.patch added to mm-unstable branch
Message-Id: <20220907225122.9ADD2C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: reduce size of memcg vmstats structures
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-reduce-size-of-memcg-vmstats-structures.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-reduce-size-of-memcg-vmstats-structures.patch

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
Subject: memcg: reduce size of memcg vmstats structures
Date: Wed, 7 Sep 2022 04:35:37 +0000

The struct memcg_vmstats and struct memcg_vmstats_percpu contains two
arrays each for events of size NR_VM_EVENT_ITEMS which can be as large as
110.  However the memcg v1 only uses 4 of those while memcg v2 uses 15. 
The union of both is 17.  On a 64 bit system, we are wasting approximately
((110 - 17) * 8 * 2) * (nr_cpus + 1) bytes which is significant on large
machines.

This patch reduces the size of the given structures by adding one
indirection and only stores array of events which are actually used by the
memcg code.  With this patch, the size of memcg_vmstats has reduced from
2544 bytes to 1056 bytes while the size of memcg_vmstats_percpu has
reduced from 2568 bytes to 1080 bytes.

Link: https://lkml.kernel.org/r/20220907043537.3457014-4-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   52 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 43 insertions(+), 9 deletions(-)

--- a/mm/memcontrol.c~memcg-reduce-size-of-memcg-vmstats-structures
+++ a/mm/memcontrol.c
@@ -671,6 +671,8 @@ static void flush_memcg_stats_dwork(stru
 
 /* Subset of vm_event_item to report for memcg event stats */
 static const unsigned int memcg_vm_event_stat[] = {
+	PGPGIN,
+	PGPGOUT,
 	PGSCAN_KSWAPD,
 	PGSCAN_DIRECT,
 	PGSTEAL_KSWAPD,
@@ -692,14 +694,30 @@ static const unsigned int memcg_vm_event
 #endif
 };
 
+#define NR_MEMCG_EVENTS ARRAY_SIZE(memcg_vm_event_stat)
+static int mem_cgroup_events_index[NR_VM_EVENT_ITEMS] __read_mostly;
+
+static void init_memcg_events(void)
+{
+	int i;
+
+	for (i = 0; i < NR_MEMCG_EVENTS; ++i)
+		mem_cgroup_events_index[memcg_vm_event_stat[i]] = i + 1;
+}
+
+static inline int memcg_events_index(enum vm_event_item idx)
+{
+	return mem_cgroup_events_index[idx] - 1;
+}
+
 struct memcg_vmstats_percpu {
 	/* Local (CPU and cgroup) page state & events */
 	long			state[MEMCG_NR_STAT];
-	unsigned long		events[NR_VM_EVENT_ITEMS];
+	unsigned long		events[NR_MEMCG_EVENTS];
 
 	/* Delta calculation for lockless upward propagation */
 	long			state_prev[MEMCG_NR_STAT];
-	unsigned long		events_prev[NR_VM_EVENT_ITEMS];
+	unsigned long		events_prev[NR_MEMCG_EVENTS];
 
 	/* Cgroup1: threshold notifications & softlimit tree updates */
 	unsigned long		nr_page_events;
@@ -709,11 +727,11 @@ struct memcg_vmstats_percpu {
 struct memcg_vmstats {
 	/* Aggregated (CPU and subtree) page state & events */
 	long			state[MEMCG_NR_STAT];
-	unsigned long		events[NR_VM_EVENT_ITEMS];
+	unsigned long		events[NR_MEMCG_EVENTS];
 
 	/* Pending child counts during tree propagation */
 	long			state_pending[MEMCG_NR_STAT];
-	unsigned long		events_pending[NR_VM_EVENT_ITEMS];
+	unsigned long		events_pending[NR_MEMCG_EVENTS];
 };
 
 unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
@@ -873,24 +891,34 @@ void __mod_lruvec_kmem_state(void *p, en
 void __count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
 			  unsigned long count)
 {
-	if (mem_cgroup_disabled())
+	int index = memcg_events_index(idx);
+
+	if (mem_cgroup_disabled() || index < 0)
 		return;
 
 	memcg_stats_lock();
-	__this_cpu_add(memcg->vmstats_percpu->events[idx], count);
+	__this_cpu_add(memcg->vmstats_percpu->events[index], count);
 	memcg_rstat_updated(memcg, count);
 	memcg_stats_unlock();
 }
 
 static unsigned long memcg_events(struct mem_cgroup *memcg, int event)
 {
-	return READ_ONCE(memcg->vmstats->events[event]);
+	int index = memcg_events_index(event);
+
+	if (index < 0)
+		return 0;
+	return READ_ONCE(memcg->vmstats->events[index]);
 }
 
 static unsigned long memcg_events_local(struct mem_cgroup *memcg, int event)
 {
 	long x = 0;
 	int cpu;
+	int index = memcg_events_index(event);
+
+	if (index < 0)
+		return 0;
 
 	for_each_possible_cpu(cpu)
 		x += per_cpu(memcg->vmstats_percpu->events[event], cpu);
@@ -1564,10 +1592,15 @@ static void memory_stat_format(struct me
 		       memcg_events(memcg, PGSTEAL_KSWAPD) +
 		       memcg_events(memcg, PGSTEAL_DIRECT));
 
-	for (i = 0; i < ARRAY_SIZE(memcg_vm_event_stat); i++)
+	for (i = 0; i < ARRAY_SIZE(memcg_vm_event_stat); i++) {
+		if (memcg_vm_event_stat[i] == PGPGIN ||
+		    memcg_vm_event_stat[i] == PGPGOUT)
+			continue;
+
 		seq_buf_printf(&s, "%s %lu\n",
 			       vm_event_name(memcg_vm_event_stat[i]),
 			       memcg_events(memcg, memcg_vm_event_stat[i]));
+	}
 
 	/* The above should easily fit into one page */
 	WARN_ON_ONCE(seq_buf_has_overflowed(&s));
@@ -5309,6 +5342,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 		page_counter_init(&memcg->kmem, &parent->kmem);
 		page_counter_init(&memcg->tcpmem, &parent->tcpmem);
 	} else {
+		init_memcg_events();
 		page_counter_init(&memcg->memory, NULL);
 		page_counter_init(&memcg->swap, NULL);
 		page_counter_init(&memcg->kmem, NULL);
@@ -5477,7 +5511,7 @@ static void mem_cgroup_css_rstat_flush(s
 			parent->vmstats->state_pending[i] += delta;
 	}
 
-	for (i = 0; i < NR_VM_EVENT_ITEMS; i++) {
+	for (i = 0; i < NR_MEMCG_EVENTS; i++) {
 		delta = memcg->vmstats->events_pending[i];
 		if (delta)
 			memcg->vmstats->events_pending[i] = 0;
_

Patches currently in -mm which might be from shakeelb@google.com are

mm-page_counter-remove-unneeded-atomic-ops-for-low-min.patch
mm-page_counter-rearrange-struct-page_counter-fields.patch
memcg-increase-memcg_charge_batch-to-64.patch
mm-deduplicate-cacheline-padding-code.patch
memcg-extract-memcg_vmstats-from-struct-mem_cgroup.patch
memcg-rearrange-code.patch
memcg-reduce-size-of-memcg-vmstats-structures.patch

