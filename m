Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EE66C43219
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:40:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbiCVVmN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236084AbiCVVmL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:42:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBF65EDF1
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:40:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39E8760A14
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:40:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F20C340EC;
        Tue, 22 Mar 2022 21:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985235;
        bh=wEoN/k78XEvkbwHgSqao8XtfxZJ8qaNf4Q6EBOU2kIA=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=uo5UAA1lGrv9HabqTsBb1fKOm1Hn/swOX7QHEdSoVhTSDka88Oq8WM+3xfhnx1k5/
         eR4pG+PFnzzHWeoq1ay0yqW++Jyok2dPH+cMOGmKii44zRjXlpnbASf5795rPa7eEH
         Jhnp+xk3+7gB+vu1kcIpNd0irqXordB5Qm89hY3Y=
Date:   Tue, 22 Mar 2022 14:40:35 -0700
To:     vdavydov.dev@gmail.com, tglx@linutronix.de, shakeelb@google.com,
        peterz@infradead.org, oliver.sang@intel.com, mkoutny@suse.com,
        mhocko@kernel.org, longman@redhat.com, hannes@cmpxchg.org,
        guro@fb.com, bigeasy@linutronix.de, mhocko@suse.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 041/227] mm/memcg: revert ("mm/memcg: optimize user context object stock access")
Message-Id: <20220322214035.90F20C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Michal Hocko <mhocko@suse.com>
Subject: mm/memcg: revert ("mm/memcg: optimize user context object stock access")

Patch series "mm/memcg: Address PREEMPT_RT problems instead of disabling it", v5.

This series aims to address the memcg related problem on PREEMPT_RT.

I tested them on CONFIG_PREEMPT and CONFIG_PREEMPT_RT with the
tools/testing/selftests/cgroup/* tests and I haven't observed any
regressions (other than the lockdep report that is already there).


This patch (of 6):

The optimisation is based on a micro benchmark where local_irq_save() is
more expensive than a preempt_disable().  There is no evidence that it is
visible in a real-world workload and there are CPUs where the opposite is
true (local_irq_save() is cheaper than preempt_disable()).

Based on micro benchmarks, the optimisation makes sense on PREEMPT_NONE
where preempt_disable() is optimized away.  There is no improvement with
PREEMPT_DYNAMIC since the preemption counter is always available.

The optimization makes also the PREEMPT_RT integration more complicated
since most of the assumption are not true on PREEMPT_RT.

Revert the optimisation since it complicates the PREEMPT_RT integration
and the improvement is hardly visible.

[bigeasy@linutronix.de: patch body around Michal's diff]
Link: https://lkml.kernel.org/r/20220226204144.1008339-1-bigeasy@linutronix.de
Link: https://lore.kernel.org/all/YgOGkXXCrD%2F1k+p4@dhcp22.suse.cz
Link: https://lkml.kernel.org/r/YdX+INO9gQje6d0S@linutronix.de
Link: https://lkml.kernel.org/r/20220226204144.1008339-2-bigeasy@linutronix.de
Signed-off-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Waiman Long <longman@redhat.com>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   94 +++++++++++++---------------------------------
 1 file changed, 27 insertions(+), 67 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-revert-mm-memcg-optimize-user-context-object-stock-access
+++ a/mm/memcontrol.c
@@ -2078,23 +2078,17 @@ void unlock_page_memcg(struct page *page
 	folio_memcg_unlock(page_folio(page));
 }
 
-struct obj_stock {
+struct memcg_stock_pcp {
+	struct mem_cgroup *cached; /* this never be root cgroup */
+	unsigned int nr_pages;
+
 #ifdef CONFIG_MEMCG_KMEM
 	struct obj_cgroup *cached_objcg;
 	struct pglist_data *cached_pgdat;
 	unsigned int nr_bytes;
 	int nr_slab_reclaimable_b;
 	int nr_slab_unreclaimable_b;
-#else
-	int dummy[0];
 #endif
-};
-
-struct memcg_stock_pcp {
-	struct mem_cgroup *cached; /* this never be root cgroup */
-	unsigned int nr_pages;
-	struct obj_stock task_obj;
-	struct obj_stock irq_obj;
 
 	struct work_struct work;
 	unsigned long flags;
@@ -2104,13 +2098,13 @@ static DEFINE_PER_CPU(struct memcg_stock
 static DEFINE_MUTEX(percpu_charge_mutex);
 
 #ifdef CONFIG_MEMCG_KMEM
-static void drain_obj_stock(struct obj_stock *stock);
+static void drain_obj_stock(struct memcg_stock_pcp *stock);
 static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
 				     struct mem_cgroup *root_memcg);
 static void memcg_account_kmem(struct mem_cgroup *memcg, int nr_pages);
 
 #else
-static inline void drain_obj_stock(struct obj_stock *stock)
+static inline void drain_obj_stock(struct memcg_stock_pcp *stock)
 {
 }
 static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
@@ -2190,9 +2184,7 @@ static void drain_local_stock(struct wor
 	local_irq_save(flags);
 
 	stock = this_cpu_ptr(&memcg_stock);
-	drain_obj_stock(&stock->irq_obj);
-	if (in_task())
-		drain_obj_stock(&stock->task_obj);
+	drain_obj_stock(stock);
 	drain_stock(stock);
 	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
 
@@ -2768,41 +2760,6 @@ retry:
 #define OBJCGS_CLEAR_MASK	(__GFP_DMA | __GFP_RECLAIMABLE | __GFP_ACCOUNT)
 
 /*
- * Most kmem_cache_alloc() calls are from user context. The irq disable/enable
- * sequence used in this case to access content from object stock is slow.
- * To optimize for user context access, there are now two object stocks for
- * task context and interrupt context access respectively.
- *
- * The task context object stock can be accessed by disabling preemption only
- * which is cheap in non-preempt kernel. The interrupt context object stock
- * can only be accessed after disabling interrupt. User context code can
- * access interrupt object stock, but not vice versa.
- */
-static inline struct obj_stock *get_obj_stock(unsigned long *pflags)
-{
-	struct memcg_stock_pcp *stock;
-
-	if (likely(in_task())) {
-		*pflags = 0UL;
-		preempt_disable();
-		stock = this_cpu_ptr(&memcg_stock);
-		return &stock->task_obj;
-	}
-
-	local_irq_save(*pflags);
-	stock = this_cpu_ptr(&memcg_stock);
-	return &stock->irq_obj;
-}
-
-static inline void put_obj_stock(unsigned long flags)
-{
-	if (likely(in_task()))
-		preempt_enable();
-	else
-		local_irq_restore(flags);
-}
-
-/*
  * mod_objcg_mlstate() may be called with irq enabled, so
  * mod_memcg_lruvec_state() should be used.
  */
@@ -3082,10 +3039,13 @@ void __memcg_kmem_uncharge_page(struct p
 void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
 		     enum node_stat_item idx, int nr)
 {
+	struct memcg_stock_pcp *stock;
 	unsigned long flags;
-	struct obj_stock *stock = get_obj_stock(&flags);
 	int *bytes;
 
+	local_irq_save(flags);
+	stock = this_cpu_ptr(&memcg_stock);
+
 	/*
 	 * Save vmstat data in stock and skip vmstat array update unless
 	 * accumulating over a page of vmstat data or when pgdat or idx
@@ -3136,26 +3096,29 @@ void mod_objcg_state(struct obj_cgroup *
 	if (nr)
 		mod_objcg_mlstate(objcg, pgdat, idx, nr);
 
-	put_obj_stock(flags);
+	local_irq_restore(flags);
 }
 
 static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
 {
+	struct memcg_stock_pcp *stock;
 	unsigned long flags;
-	struct obj_stock *stock = get_obj_stock(&flags);
 	bool ret = false;
 
+	local_irq_save(flags);
+
+	stock = this_cpu_ptr(&memcg_stock);
 	if (objcg == stock->cached_objcg && stock->nr_bytes >= nr_bytes) {
 		stock->nr_bytes -= nr_bytes;
 		ret = true;
 	}
 
-	put_obj_stock(flags);
+	local_irq_restore(flags);
 
 	return ret;
 }
 
-static void drain_obj_stock(struct obj_stock *stock)
+static void drain_obj_stock(struct memcg_stock_pcp *stock)
 {
 	struct obj_cgroup *old = stock->cached_objcg;
 
@@ -3211,13 +3174,8 @@ static bool obj_stock_flush_required(str
 {
 	struct mem_cgroup *memcg;
 
-	if (in_task() && stock->task_obj.cached_objcg) {
-		memcg = obj_cgroup_memcg(stock->task_obj.cached_objcg);
-		if (memcg && mem_cgroup_is_descendant(memcg, root_memcg))
-			return true;
-	}
-	if (stock->irq_obj.cached_objcg) {
-		memcg = obj_cgroup_memcg(stock->irq_obj.cached_objcg);
+	if (stock->cached_objcg) {
+		memcg = obj_cgroup_memcg(stock->cached_objcg);
 		if (memcg && mem_cgroup_is_descendant(memcg, root_memcg))
 			return true;
 	}
@@ -3228,10 +3186,13 @@ static bool obj_stock_flush_required(str
 static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
 			     bool allow_uncharge)
 {
+	struct memcg_stock_pcp *stock;
 	unsigned long flags;
-	struct obj_stock *stock = get_obj_stock(&flags);
 	unsigned int nr_pages = 0;
 
+	local_irq_save(flags);
+
+	stock = this_cpu_ptr(&memcg_stock);
 	if (stock->cached_objcg != objcg) { /* reset if necessary */
 		drain_obj_stock(stock);
 		obj_cgroup_get(objcg);
@@ -3247,7 +3208,7 @@ static void refill_obj_stock(struct obj_
 		stock->nr_bytes &= (PAGE_SIZE - 1);
 	}
 
-	put_obj_stock(flags);
+	local_irq_restore(flags);
 
 	if (nr_pages)
 		obj_cgroup_uncharge_pages(objcg, nr_pages);
@@ -6826,7 +6787,6 @@ static void uncharge_folio(struct folio
 	long nr_pages;
 	struct mem_cgroup *memcg;
 	struct obj_cgroup *objcg;
-	bool use_objcg = folio_memcg_kmem(folio);
 
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 
@@ -6835,7 +6795,7 @@ static void uncharge_folio(struct folio
 	 * folio memcg or objcg at this point, we have fully
 	 * exclusive access to the folio.
 	 */
-	if (use_objcg) {
+	if (folio_memcg_kmem(folio)) {
 		objcg = __folio_objcg(folio);
 		/*
 		 * This get matches the put at the end of the function and
@@ -6863,7 +6823,7 @@ static void uncharge_folio(struct folio
 
 	nr_pages = folio_nr_pages(folio);
 
-	if (use_objcg) {
+	if (folio_memcg_kmem(folio)) {
 		ug->nr_memory += nr_pages;
 		ug->nr_kmem += nr_pages;
 
_
