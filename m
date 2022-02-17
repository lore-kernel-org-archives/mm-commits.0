Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A64DC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 17 Feb 2022 21:13:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233836AbiBQVOI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Feb 2022 16:14:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239920AbiBQVOA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Feb 2022 16:14:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A769E34660
        for <mm-commits@vger.kernel.org>; Thu, 17 Feb 2022 13:13:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 541E4B82515
        for <mm-commits@vger.kernel.org>; Thu, 17 Feb 2022 21:13:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06BECC340E8;
        Thu, 17 Feb 2022 21:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645132422;
        bh=Sg6eQxXI2r1FjuluB4dg+TE7nAOv9KZ4E3FsItGdd80=;
        h=Date:To:From:Subject:From;
        b=f8+R6BWV+f6pW3mj9+8HnYJvoy1oVu7FWhfgdl9A+Hsu/NKH2dSM9yDptuRWu1IqX
         s+NqmqO6Zg7HRM/NeS+CmE6yIDmlyNBddspe1ps1vR1IQr/JnEmGg9x5DZpZZdb5L+
         b/WCR9PWL6BZH3TPanNrlGbBkK1fDl13rB5heaf4=
Date:   Thu, 17 Feb 2022 13:13:41 -0800
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        tglx@linutronix.de, shakeelb@google.com, peterz@infradead.org,
        oliver.sang@intel.com, mkoutny@suse.com, mhocko@suse.com,
        mhocko@kernel.org, longman@redhat.com, hannes@cmpxchg.org,
        guro@fb.com, bigeasy@linutronix.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-protect-memcg_stock-with-a-local_lock_t.patch added to -mm tree
Message-Id: <20220217211342.06BECC340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: Protect memcg_stock with a local_lock_t
has been added to the -mm tree.  Its filename is
     mm-memcg-protect-memcg_stock-with-a-local_lock_t.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-protect-memcg_stock-with-a-local_lock_t.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-protect-memcg_stock-with-a-local_lock_t.patch

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
Subject: mm/memcg: Protect memcg_stock with a local_lock_t

The members of the per-CPU structure memcg_stock_pcp are protected by
disabling interrupts. This is not working on PREEMPT_RT because it
creates atomic context in which actions are performed which require
preemptible context. One example is obj_cgroup_release().

The IRQ-disable sections can be replaced with local_lock_t which
preserves the explicit disabling of interrupts while keeps the code
preemptible on PREEMPT_RT.

drain_all_stock() disables preemption via get_cpu() and then invokes
drain_local_stock() if it is the local CPU to avoid scheduling a worker (wh=
ich
invokes the same function). Disabling preemption here is problematic due to=
 the
sleeping locks in drain_local_stock().
This can be avoided by always scheduling a worker, even for the local
CPU. Using cpus_read_lock() to stabilize the cpu_online_mask is not
needed since the worker operates always on the CPU-local data structure.
Should a CPU go offline then a two worker would perform the work and no
harm is done. Using cpus_read_lock() leads to a possible deadlock.

drain_obj_stock() drops a reference on obj_cgroup which leads to an invocat=
ion
of obj_cgroup_release() if it is the last object. This in turn leads to
recursive locking of the local_lock_t. To avoid this, obj_cgroup_release() =
is
invoked outside of the locked section.

obj_cgroup_uncharge_pages() can be invoked with the local_lock_t acquired a=
nd
without it. This will lead later to a recursion in refill_stock(). To
avoid the locking recursion provide obj_cgroup_uncharge_pages_locked()
which uses the locked version of refill_stock().

- Replace disabling interrupts for memcg_stock with a local_lock_t.

- Schedule a worker even for the local CPU instead of invoking it
  directly (in drain_all_stock()).

- Let drain_obj_stock() return the old struct obj_cgroup which is passed
  to obj_cgroup_put() outside of the locked section.

- Provide obj_cgroup_uncharge_pages_locked() which uses the locked
  version of refill_stock() to avoid recursive locking in
  drain_obj_stock().

Link: https://lkml.kernel.org/r/20220209014709.GA26885@xsang-OptiPlex-9020
Link: https://lkml.kernel.org/r/20220217094802.3644569-6-bigeasy@linutronix.de
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   67 +++++++++++++++++++++++++---------------------
 1 file changed, 37 insertions(+), 30 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-protect-memcg_stock-with-a-local_lock_t
+++ a/mm/memcontrol.c
@@ -2108,6 +2108,7 @@ void unlock_page_memcg(struct page *page
 }
 
 struct memcg_stock_pcp {
+	local_lock_t stock_lock;
 	struct mem_cgroup *cached; /* this never be root cgroup */
 	unsigned int nr_pages;
 
@@ -2123,18 +2124,21 @@ struct memcg_stock_pcp {
 	unsigned long flags;
 #define FLUSHING_CACHED_CHARGE	0
 };
-static DEFINE_PER_CPU(struct memcg_stock_pcp, memcg_stock);
+static DEFINE_PER_CPU(struct memcg_stock_pcp, memcg_stock) = {
+	.stock_lock = INIT_LOCAL_LOCK(stock_lock),
+};
 static DEFINE_MUTEX(percpu_charge_mutex);
 
 #ifdef CONFIG_MEMCG_KMEM
-static void drain_obj_stock(struct memcg_stock_pcp *stock);
+static struct obj_cgroup *drain_obj_stock(struct memcg_stock_pcp *stock);
 static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
 				     struct mem_cgroup *root_memcg);
 static void memcg_account_kmem(struct mem_cgroup *memcg, int nr_pages);
 
 #else
-static inline void drain_obj_stock(struct memcg_stock_pcp *stock)
+static inline struct obj_cgroup *drain_obj_stock(struct memcg_stock_pcp *stock)
 {
+	return NULL;
 }
 static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
 				     struct mem_cgroup *root_memcg)
@@ -2166,7 +2170,7 @@ static bool consume_stock(struct mem_cgr
 	if (nr_pages > MEMCG_CHARGE_BATCH)
 		return ret;
 
-	local_irq_save(flags);
+	local_lock_irqsave(&memcg_stock.stock_lock, flags);
 
 	stock = this_cpu_ptr(&memcg_stock);
 	if (memcg == stock->cached && stock->nr_pages >= nr_pages) {
@@ -2174,7 +2178,7 @@ static bool consume_stock(struct mem_cgr
 		ret = true;
 	}
 
-	local_irq_restore(flags);
+	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
 
 	return ret;
 }
@@ -2203,6 +2207,7 @@ static void drain_stock(struct memcg_sto
 static void drain_local_stock(struct work_struct *dummy)
 {
 	struct memcg_stock_pcp *stock;
+	struct obj_cgroup *old = NULL;
 	unsigned long flags;
 
 	/*
@@ -2210,14 +2215,16 @@ static void drain_local_stock(struct wor
 	 * drain_stock races is that we always operate on local CPU stock
 	 * here with IRQ disabled
 	 */
-	local_irq_save(flags);
+	local_lock_irqsave(&memcg_stock.stock_lock, flags);
 
 	stock = this_cpu_ptr(&memcg_stock);
-	drain_obj_stock(stock);
+	old = drain_obj_stock(stock);
 	drain_stock(stock);
 	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
 
-	local_irq_restore(flags);
+	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
+	if (old)
+		obj_cgroup_put(old);
 }
 
 /*
@@ -2244,9 +2251,9 @@ static void refill_stock(struct mem_cgro
 {
 	unsigned long flags;
 
-	local_irq_save(flags);
+	local_lock_irqsave(&memcg_stock.stock_lock, flags);
 	__refill_stock(memcg, nr_pages);
-	local_irq_restore(flags);
+	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
 }
 
 /*
@@ -2255,7 +2262,7 @@ static void refill_stock(struct mem_cgro
  */
 static void drain_all_stock(struct mem_cgroup *root_memcg)
 {
-	int cpu, curcpu;
+	int cpu;
 
 	/* If someone's already draining, avoid adding running more workers. */
 	if (!mutex_trylock(&percpu_charge_mutex))
@@ -2266,7 +2273,6 @@ static void drain_all_stock(struct mem_c
 	 * as well as workers from this path always operate on the local
 	 * per-cpu data. CPU up doesn't touch memcg_stock at all.
 	 */
-	curcpu = get_cpu();
 	for_each_online_cpu(cpu) {
 		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
 		struct mem_cgroup *memcg;
@@ -2282,14 +2288,9 @@ static void drain_all_stock(struct mem_c
 		rcu_read_unlock();
 
 		if (flush &&
-		    !test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags)) {
-			if (cpu == curcpu)
-				drain_local_stock(&stock->work);
-			else
-				schedule_work_on(cpu, &stock->work);
-		}
+		    !test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
+			schedule_work_on(cpu, &stock->work);
 	}
-	put_cpu();
 	mutex_unlock(&percpu_charge_mutex);
 }
 
@@ -3073,10 +3074,11 @@ void mod_objcg_state(struct obj_cgroup *
 		     enum node_stat_item idx, int nr)
 {
 	struct memcg_stock_pcp *stock;
+	struct obj_cgroup *old = NULL;
 	unsigned long flags;
 	int *bytes;
 
-	local_irq_save(flags);
+	local_lock_irqsave(&memcg_stock.stock_lock, flags);
 	stock = this_cpu_ptr(&memcg_stock);
 
 	/*
@@ -3085,7 +3087,7 @@ void mod_objcg_state(struct obj_cgroup *
 	 * changes.
 	 */
 	if (stock->cached_objcg != objcg) {
-		drain_obj_stock(stock);
+		old = drain_obj_stock(stock);
 		obj_cgroup_get(objcg);
 		stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
 				? atomic_xchg(&objcg->nr_charged_bytes, 0) : 0;
@@ -3129,7 +3131,9 @@ void mod_objcg_state(struct obj_cgroup *
 	if (nr)
 		mod_objcg_mlstate(objcg, pgdat, idx, nr);
 
-	local_irq_restore(flags);
+	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
+	if (old)
+		obj_cgroup_put(old);
 }
 
 static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
@@ -3138,7 +3142,7 @@ static bool consume_obj_stock(struct obj
 	unsigned long flags;
 	bool ret = false;
 
-	local_irq_save(flags);
+	local_lock_irqsave(&memcg_stock.stock_lock, flags);
 
 	stock = this_cpu_ptr(&memcg_stock);
 	if (objcg == stock->cached_objcg && stock->nr_bytes >= nr_bytes) {
@@ -3146,17 +3150,17 @@ static bool consume_obj_stock(struct obj
 		ret = true;
 	}
 
-	local_irq_restore(flags);
+	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
 
 	return ret;
 }
 
-static void drain_obj_stock(struct memcg_stock_pcp *stock)
+static struct obj_cgroup *drain_obj_stock(struct memcg_stock_pcp *stock)
 {
 	struct obj_cgroup *old = stock->cached_objcg;
 
 	if (!old)
-		return;
+		return NULL;
 
 	if (stock->nr_bytes) {
 		unsigned int nr_pages = stock->nr_bytes >> PAGE_SHIFT;
@@ -3206,8 +3210,8 @@ static void drain_obj_stock(struct memcg
 		stock->cached_pgdat = NULL;
 	}
 
-	obj_cgroup_put(old);
 	stock->cached_objcg = NULL;
+	return old;
 }
 
 static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
@@ -3228,14 +3232,15 @@ static void refill_obj_stock(struct obj_
 			     bool allow_uncharge)
 {
 	struct memcg_stock_pcp *stock;
+	struct obj_cgroup *old = NULL;
 	unsigned long flags;
 	unsigned int nr_pages = 0;
 
-	local_irq_save(flags);
+	local_lock_irqsave(&memcg_stock.stock_lock, flags);
 
 	stock = this_cpu_ptr(&memcg_stock);
 	if (stock->cached_objcg != objcg) { /* reset if necessary */
-		drain_obj_stock(stock);
+		old = drain_obj_stock(stock);
 		obj_cgroup_get(objcg);
 		stock->cached_objcg = objcg;
 		stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
@@ -3249,7 +3254,9 @@ static void refill_obj_stock(struct obj_
 		stock->nr_bytes &= (PAGE_SIZE - 1);
 	}
 
-	local_irq_restore(flags);
+	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
+	if (old)
+		obj_cgroup_put(old);
 
 	if (nr_pages)
 		obj_cgroup_uncharge_pages(objcg, nr_pages);
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

mm-memcg-disable-threshold-event-handlers-on-preempt_rt.patch
mm-memcg-protect-per-cpu-counter-by-disabling-preemption-on-preempt_rt-where-needed.patch
mm-memcg-protect-memcg_stock-with-a-local_lock_t.patch

