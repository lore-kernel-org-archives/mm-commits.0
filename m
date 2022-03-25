Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E8A2C43217
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:30:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241498AbiCYBcP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344355AbiCYBb7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:31:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F26C3CFDD
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:30:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DF366191D
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63266C340EE;
        Fri, 25 Mar 2022 01:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171825;
        bh=Dv6QworYriqcCuBPOKdTG1DrQ5s9FUKD1gbi1AdTSTc=;
        h=Date:To:From:Subject:From;
        b=FLNErQjmj60ukf4wMY0U2PL4M79mmVkixA2bEdlBFiJeHXjU+HcFNBvrqI+DytvFH
         pLSXO4HVsJwR8XySji7gO+mBQztCjzTjUx1b1YrHzA1onlL0plAgS9nm/C54wWeC1j
         UbJ/Js4OxgG6kH6kzbdTMm6ErOs9OOe0D+S6U+ts=
Date:   Thu, 24 Mar 2022 18:30:24 -0700
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        tglx@linutronix.de, shakeelb@google.com, roman.gushchin@linux.dev,
        peterz@infradead.org, oliver.sang@intel.com, mkoutny@suse.com,
        mhocko@suse.com, longman@redhat.com, hannes@cmpxchg.org,
        bigeasy@linutronix.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-memcg-protect-memcg_stock-with-a-local_lock_t.patch removed from -mm tree
Message-Id: <20220325013025.63266C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: protect memcg_stock with a local_lock_t
has been removed from the -mm tree.  Its filename was
     mm-memcg-protect-memcg_stock-with-a-local_lock_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm/memcg: protect memcg_stock with a local_lock_t

The members of the per-CPU structure memcg_stock_pcp are protected by
disabling interrupts.  This is not working on PREEMPT_RT because it
creates atomic context in which actions are performed which require
preemptible context.  One example is obj_cgroup_release().

The IRQ-disable sections can be replaced with local_lock_t which preserves
the explicit disabling of interrupts while keeps the code preemptible on
PREEMPT_RT.

drain_obj_stock() drops a reference on obj_cgroup which leads to an
invocat= ion of obj_cgroup_release() if it is the last object.  This in
turn leads to recursive locking of the local_lock_t.  To avoid this,
obj_cgroup_release() = is invoked outside of the locked section.

obj_cgroup_uncharge_pages() can be invoked with the local_lock_t acquired
a= nd without it.  This will lead later to a recursion in refill_stock(). 
To avoid the locking recursion provide obj_cgroup_uncharge_pages_locked()
which uses the locked version of refill_stock().

- Replace disabling interrupts for memcg_stock with a local_lock_t.

- Let drain_obj_stock() return the old struct obj_cgroup which is passed
  to obj_cgroup_put() outside of the locked section.

- Provide obj_cgroup_uncharge_pages_locked() which uses the locked
  version of refill_stock() to avoid recursive locking in
  drain_obj_stock().

Link: https://lkml.kernel.org/r/20220209014709.GA26885@xsang-OptiPlex-9020
Link: https://lkml.kernel.org/r/20220226204144.1008339-6-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reported-by: kernel test robot <oliver.sang@intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   59 +++++++++++++++++++++++++++++-----------------
 1 file changed, 38 insertions(+), 21 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-protect-memcg_stock-with-a-local_lock_t
+++ a/mm/memcontrol.c
@@ -2135,6 +2135,7 @@ void unlock_page_memcg(struct page *page
 }
 
 struct memcg_stock_pcp {
+	local_lock_t stock_lock;
 	struct mem_cgroup *cached; /* this never be root cgroup */
 	unsigned int nr_pages;
 
@@ -2150,18 +2151,21 @@ struct memcg_stock_pcp {
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
@@ -2193,7 +2197,7 @@ static bool consume_stock(struct mem_cgr
 	if (nr_pages > MEMCG_CHARGE_BATCH)
 		return ret;
 
-	local_irq_save(flags);
+	local_lock_irqsave(&memcg_stock.stock_lock, flags);
 
 	stock = this_cpu_ptr(&memcg_stock);
 	if (memcg == stock->cached && stock->nr_pages >= nr_pages) {
@@ -2201,7 +2205,7 @@ static bool consume_stock(struct mem_cgr
 		ret = true;
 	}
 
-	local_irq_restore(flags);
+	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
 
 	return ret;
 }
@@ -2230,6 +2234,7 @@ static void drain_stock(struct memcg_sto
 static void drain_local_stock(struct work_struct *dummy)
 {
 	struct memcg_stock_pcp *stock;
+	struct obj_cgroup *old = NULL;
 	unsigned long flags;
 
 	/*
@@ -2237,14 +2242,16 @@ static void drain_local_stock(struct wor
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
@@ -2271,9 +2278,9 @@ static void refill_stock(struct mem_cgro
 {
 	unsigned long flags;
 
-	local_irq_save(flags);
+	local_lock_irqsave(&memcg_stock.stock_lock, flags);
 	__refill_stock(memcg, nr_pages);
-	local_irq_restore(flags);
+	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
 }
 
 /*
@@ -3100,10 +3107,11 @@ void mod_objcg_state(struct obj_cgroup *
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
@@ -3112,7 +3120,7 @@ void mod_objcg_state(struct obj_cgroup *
 	 * changes.
 	 */
 	if (stock->cached_objcg != objcg) {
-		drain_obj_stock(stock);
+		old = drain_obj_stock(stock);
 		obj_cgroup_get(objcg);
 		stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
 				? atomic_xchg(&objcg->nr_charged_bytes, 0) : 0;
@@ -3156,7 +3164,9 @@ void mod_objcg_state(struct obj_cgroup *
 	if (nr)
 		mod_objcg_mlstate(objcg, pgdat, idx, nr);
 
-	local_irq_restore(flags);
+	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
+	if (old)
+		obj_cgroup_put(old);
 }
 
 static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
@@ -3165,7 +3175,7 @@ static bool consume_obj_stock(struct obj
 	unsigned long flags;
 	bool ret = false;
 
-	local_irq_save(flags);
+	local_lock_irqsave(&memcg_stock.stock_lock, flags);
 
 	stock = this_cpu_ptr(&memcg_stock);
 	if (objcg == stock->cached_objcg && stock->nr_bytes >= nr_bytes) {
@@ -3173,17 +3183,17 @@ static bool consume_obj_stock(struct obj
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
@@ -3233,8 +3243,12 @@ static void drain_obj_stock(struct memcg
 		stock->cached_pgdat = NULL;
 	}
 
-	obj_cgroup_put(old);
 	stock->cached_objcg = NULL;
+	/*
+	 * The `old' objects needs to be released by the caller via
+	 * obj_cgroup_put() outside of memcg_stock_pcp::stock_lock.
+	 */
+	return old;
 }
 
 static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
@@ -3255,14 +3269,15 @@ static void refill_obj_stock(struct obj_
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
@@ -3276,7 +3291,9 @@ static void refill_obj_stock(struct obj_
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


