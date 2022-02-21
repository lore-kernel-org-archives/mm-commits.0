Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0CFDC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 21 Feb 2022 19:26:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbiBUT1P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 14:27:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233044AbiBUT1E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 14:27:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B5121E14
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 11:26:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A387260AF9
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 19:26:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA21C340E9;
        Mon, 21 Feb 2022 19:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645471600;
        bh=6IFWK9ANzsbZfCQihIrVohF/Hur5BDxj5yko9jJHp0c=;
        h=Date:To:From:Subject:From;
        b=dlCaRzgH2ucvCrW+4BUuzmoPcBxDqU5h8SKm4sAmBm12zErAj8xFZMSqOsGXif08h
         9oayUuBtZanejXfKrVVoevKQH9rKOQgGroT7VIZ+zjqy+BNs2WZClzrmcAs4yrK44f
         VkJBl0/y9j3WIBn/cvcTHjePuCOCzhc2qI2TKQbs=
Date:   Mon, 21 Feb 2022 11:26:39 -0800
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        tglx@linutronix.de, shakeelb@google.com, peterz@infradead.org,
        oliver.sang@intel.com, mkoutny@suse.com, mhocko@suse.com,
        mhocko@kernel.org, longman@redhat.com, hannes@cmpxchg.org,
        guro@fb.com, bigeasy@linutronix.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-protect-per-cpu-counter-by-disabling-preemption-on-preempt_rt-where-needed.patch added to -mm tree
Message-Id: <20220221192640.0CA21C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: protect per-CPU counter by disabling preemption on PREEMPT_RT where needed.
has been added to the -mm tree.  Its filename is
     mm-memcg-protect-per-cpu-counter-by-disabling-preemption-on-preempt_rt-where-needed.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-protect-per-cpu-counter-by-disabling-preemption-on-preempt_rt-where-needed.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-protect-per-cpu-counter-by-disabling-preemption-on-preempt_rt-where-needed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm/memcg: protect per-CPU counter by disabling preemption on PREEMPT_RT where needed.

The per-CPU counter are modified with the non-atomic modifier.  The
consistency is ensured by disabling interrupts for the update.  On non
PREEMPT_RT configuration this works because acquiring a spinlock_t typed
lock with the _irq() suffix disables interrupts.  On PREEMPT_RT
configurations the RMW operation can be interrupted.

Another problem is that mem_cgroup_swapout() expects to be invoked with
disabled interrupts because the caller has to acquire a spinlock_t which
is acquired with disabled interrupts.  Since spinlock_t never disables
interrupts on PREEMPT_RT the interrupts are never disabled at this point.

The code is never called from in_irq() context on PREEMPT_RT therefore
disabling preemption during the update is sufficient on PREEMPT_RT.  The
sections which explicitly disable interrupts can remain on PREEMPT_RT
because the sections remain short and they don't involve sleeping locks
(memcg_check_events() is doing nothing on PREEMPT_RT).

Disable preemption during update of the per-CPU variables which do not
explicitly disable interrupts.

Link: https://lkml.kernel.org/r/20220221182540.380526-4-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   49 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-protect-per-cpu-counter-by-disabling-preemption-on-preempt_rt-where-needed
+++ a/mm/memcontrol.c
@@ -629,6 +629,35 @@ static DEFINE_SPINLOCK(stats_flush_lock)
 static DEFINE_PER_CPU(unsigned int, stats_updates);
 static atomic_t stats_flush_threshold = ATOMIC_INIT(0);
 
+/*
+ * Accessors to ensure that preemption is disabled on PREEMPT_RT because it can
+ * not rely on this as part of an acquired spinlock_t lock. These functions are
+ * never used in hardirq context on PREEMPT_RT and therefore disabling preemtion
+ * is sufficient.
+ */
+static void memcg_stats_lock(void)
+{
+#ifdef CONFIG_PREEMPT_RT
+      preempt_disable();
+#else
+      VM_BUG_ON(!irqs_disabled());
+#endif
+}
+
+static void __memcg_stats_lock(void)
+{
+#ifdef CONFIG_PREEMPT_RT
+      preempt_disable();
+#endif
+}
+
+static void memcg_stats_unlock(void)
+{
+#ifdef CONFIG_PREEMPT_RT
+      preempt_enable();
+#endif
+}
+
 static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
 {
 	unsigned int x;
@@ -705,6 +734,20 @@ void __mod_memcg_lruvec_state(struct lru
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
 	memcg = pn->memcg;
 
+	/*
+	 * The caller from rmap relay on disabled preemption becase they never
+	 * update their counter from in-interrupt context. For these two
+	 * counters we check that the update is never performed from an
+	 * interrupt context while other caller need to have disabled interrupt.
+	 */
+	__memcg_stats_lock();
+	if (IS_ENABLED(CONFIG_DEBUG_VM)) {
+		if (idx == NR_ANON_MAPPED || idx == NR_FILE_MAPPED)
+			WARN_ON_ONCE(!in_task());
+		else
+			WARN_ON_ONCE(!irqs_disabled());
+	}
+
 	/* Update memcg */
 	__this_cpu_add(memcg->vmstats_percpu->state[idx], val);
 
@@ -712,6 +755,7 @@ void __mod_memcg_lruvec_state(struct lru
 	__this_cpu_add(pn->lruvec_stats_percpu->state[idx], val);
 
 	memcg_rstat_updated(memcg, val);
+	memcg_stats_unlock();
 }
 
 /**
@@ -794,8 +838,10 @@ void __count_memcg_events(struct mem_cgr
 	if (mem_cgroup_disabled())
 		return;
 
+	memcg_stats_lock();
 	__this_cpu_add(memcg->vmstats_percpu->events[idx], count);
 	memcg_rstat_updated(memcg, count);
+	memcg_stats_unlock();
 }
 
 static unsigned long memcg_events(struct mem_cgroup *memcg, int event)
@@ -7154,8 +7200,9 @@ void mem_cgroup_swapout(struct page *pag
 	 * important here to have the interrupts disabled because it is the
 	 * only synchronisation we have for updating the per-CPU variables.
 	 */
-	VM_BUG_ON(!irqs_disabled());
+	memcg_stats_lock();
 	mem_cgroup_charge_statistics(memcg, -nr_entries);
+	memcg_stats_unlock();
 	memcg_check_events(memcg, page_to_nid(page));
 
 	css_put(&memcg->css);
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

mm-memcg-disable-threshold-event-handlers-on-preempt_rt.patch
mm-memcg-protect-per-cpu-counter-by-disabling-preemption-on-preempt_rt-where-needed.patch
mm-memcg-protect-memcg_stock-with-a-local_lock_t.patch
mm-memcg-disable-migration-instead-of-preemption-in-drain_all_stock.patch

