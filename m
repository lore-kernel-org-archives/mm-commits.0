Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E537C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:11:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F030461C7B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:11:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbhGFTOC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:14:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:48430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230071AbhGFTOC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:14:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C19261C6D;
        Tue,  6 Jul 2021 19:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598683;
        bh=sdB0GvasH/U7Fgn9lZ0incssMKpuR+NtK+Dc2GeEur8=;
        h=Date:From:To:Subject:From;
        b=Jcg7AgQGp9pU3dkm8ToIGlJMgEJV7cCrj0srrRHGA3law8ECxsdzd7Y1gE/PyT7Vk
         yCInK2nhBacnc3IdPVAudt3l43cRQBDwaAbW9wYyrrnouJUmsF0kPigC9dLAW45Len
         hfB84OBHId5cFXBu8OE31obkwiiaK5bfzlRJ2Ipg=
Date:   Tue, 06 Jul 2021 12:11:22 -0700
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, chris@chrisdown.name, cl@linux.com,
        guro@fb.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com,
        laoar.shao@gmail.com, longman@redhat.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, msys.mizuma@gmail.com,
        penberg@kernel.org, richard.weiyang@gmail.com, rientjes@google.com,
        shakeelb@google.com, songmuchun@bytedance.com, tj@kernel.org,
        vbabka@suse.cz, vdavydov.dev@gmail.com, willy@infradead.org,
        zhengjun.xing@linux.intel.com
Subject:  [merged]
 mm-memcg-optimize-user-context-object-stock-access.patch removed from -mm
 tree
Message-ID: <20210706191122.tmY2cILRR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: optimize user context object stock access
has been removed from the -mm tree.  Its filename was
     mm-memcg-optimize-user-context-object-stock-access.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm/memcg: optimize user context object stock access

Most kmem_cache_alloc() calls are from user context.  With instrumentation
enabled, the measured amount of kmem_cache_alloc() calls from non-task
context was about 0.01% of the total.

The irq disable/enable sequence used in this case to access content from
object stock is slow.  To optimize for user context access, there are now
two sets of object stocks (in the new obj_stock structure) for task
context and interrupt context access respectively.

The task context object stock can be accessed after disabling preemption
which is cheap in non-preempt kernel.  The interrupt context object stock
can only be accessed after disabling interrupt.  User context code can
access interrupt object stock, but not vice versa.

The downside of this change is that there are more data stored in local
object stocks and not reflected in the charge counter and the vmstat
arrays.  However, this is a small price to pay for better performance.

[longman@redhat.com: fix potential uninitialized variable warning]
  Link: https://lkml.kernel.org/r/20210526193602.8742-1-longman@redhat.com
[akpm@linux-foundation.org: coding style fixes]
Link: https://lkml.kernel.org/r/20210506150007.16288-5-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Roman Gushchin <guro@fb.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Masayoshi Mizuma <msys.mizuma@gmail.com>
Cc: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  100 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 72 insertions(+), 28 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-optimize-user-context-object-stock-access
+++ a/mm/memcontrol.c
@@ -782,6 +782,10 @@ void __mod_lruvec_kmem_state(void *p, en
 	rcu_read_unlock();
 }
 
+/*
+ * mod_objcg_mlstate() may be called with irq enabled, so
+ * mod_memcg_lruvec_state() should be used.
+ */
 static inline void mod_objcg_mlstate(struct obj_cgroup *objcg,
 				     struct pglist_data *pgdat,
 				     enum node_stat_item idx, int nr)
@@ -792,7 +796,7 @@ static inline void mod_objcg_mlstate(str
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
-	__mod_memcg_lruvec_state(lruvec, idx, nr);
+	mod_memcg_lruvec_state(lruvec, idx, nr);
 	rcu_read_unlock();
 }
 
@@ -2054,17 +2058,23 @@ void unlock_page_memcg(struct page *page
 }
 EXPORT_SYMBOL(unlock_page_memcg);
 
-struct memcg_stock_pcp {
-	struct mem_cgroup *cached; /* this never be root cgroup */
-	unsigned int nr_pages;
-
+struct obj_stock {
 #ifdef CONFIG_MEMCG_KMEM
 	struct obj_cgroup *cached_objcg;
 	struct pglist_data *cached_pgdat;
 	unsigned int nr_bytes;
 	int nr_slab_reclaimable_b;
 	int nr_slab_unreclaimable_b;
+#else
+	int dummy[0];
 #endif
+};
+
+struct memcg_stock_pcp {
+	struct mem_cgroup *cached; /* this never be root cgroup */
+	unsigned int nr_pages;
+	struct obj_stock task_obj;
+	struct obj_stock irq_obj;
 
 	struct work_struct work;
 	unsigned long flags;
@@ -2074,12 +2084,12 @@ static DEFINE_PER_CPU(struct memcg_stock
 static DEFINE_MUTEX(percpu_charge_mutex);
 
 #ifdef CONFIG_MEMCG_KMEM
-static void drain_obj_stock(struct memcg_stock_pcp *stock);
+static void drain_obj_stock(struct obj_stock *stock);
 static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
 				     struct mem_cgroup *root_memcg);
 
 #else
-static inline void drain_obj_stock(struct memcg_stock_pcp *stock)
+static inline void drain_obj_stock(struct obj_stock *stock)
 {
 }
 static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
@@ -2089,6 +2099,41 @@ static bool obj_stock_flush_required(str
 }
 #endif
 
+/*
+ * Most kmem_cache_alloc() calls are from user context. The irq disable/enable
+ * sequence used in this case to access content from object stock is slow.
+ * To optimize for user context access, there are now two object stocks for
+ * task context and interrupt context access respectively.
+ *
+ * The task context object stock can be accessed by disabling preemption only
+ * which is cheap in non-preempt kernel. The interrupt context object stock
+ * can only be accessed after disabling interrupt. User context code can
+ * access interrupt object stock, but not vice versa.
+ */
+static inline struct obj_stock *get_obj_stock(unsigned long *pflags)
+{
+	struct memcg_stock_pcp *stock;
+
+	if (likely(in_task())) {
+		*pflags = 0UL;
+		preempt_disable();
+		stock = this_cpu_ptr(&memcg_stock);
+		return &stock->task_obj;
+	}
+
+	local_irq_save(*pflags);
+	stock = this_cpu_ptr(&memcg_stock);
+	return &stock->irq_obj;
+}
+
+static inline void put_obj_stock(unsigned long flags)
+{
+	if (likely(in_task()))
+		preempt_enable();
+	else
+		local_irq_restore(flags);
+}
+
 /**
  * consume_stock: Try to consume stocked charge on this cpu.
  * @memcg: memcg to consume from.
@@ -2155,7 +2200,9 @@ static void drain_local_stock(struct wor
 	local_irq_save(flags);
 
 	stock = this_cpu_ptr(&memcg_stock);
-	drain_obj_stock(stock);
+	drain_obj_stock(&stock->irq_obj);
+	if (in_task())
+		drain_obj_stock(&stock->task_obj);
 	drain_stock(stock);
 	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
 
@@ -3015,13 +3062,10 @@ void __memcg_kmem_uncharge_page(struct p
 void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
 		     enum node_stat_item idx, int nr)
 {
-	struct memcg_stock_pcp *stock;
 	unsigned long flags;
+	struct obj_stock *stock = get_obj_stock(&flags);
 	int *bytes;
 
-	local_irq_save(flags);
-	stock = this_cpu_ptr(&memcg_stock);
-
 	/*
 	 * Save vmstat data in stock and skip vmstat array update unless
 	 * accumulating over a page of vmstat data or when pgdat or idx
@@ -3070,29 +3114,26 @@ void mod_objcg_state(struct obj_cgroup *
 	if (nr)
 		mod_objcg_mlstate(objcg, pgdat, idx, nr);
 
-	local_irq_restore(flags);
+	put_obj_stock(flags);
 }
 
 static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
 {
-	struct memcg_stock_pcp *stock;
 	unsigned long flags;
+	struct obj_stock *stock = get_obj_stock(&flags);
 	bool ret = false;
 
-	local_irq_save(flags);
-
-	stock = this_cpu_ptr(&memcg_stock);
 	if (objcg == stock->cached_objcg && stock->nr_bytes >= nr_bytes) {
 		stock->nr_bytes -= nr_bytes;
 		ret = true;
 	}
 
-	local_irq_restore(flags);
+	put_obj_stock(flags);
 
 	return ret;
 }
 
-static void drain_obj_stock(struct memcg_stock_pcp *stock)
+static void drain_obj_stock(struct obj_stock *stock)
 {
 	struct obj_cgroup *old = stock->cached_objcg;
 
@@ -3148,8 +3189,13 @@ static bool obj_stock_flush_required(str
 {
 	struct mem_cgroup *memcg;
 
-	if (stock->cached_objcg) {
-		memcg = obj_cgroup_memcg(stock->cached_objcg);
+	if (in_task() && stock->task_obj.cached_objcg) {
+		memcg = obj_cgroup_memcg(stock->task_obj.cached_objcg);
+		if (memcg && mem_cgroup_is_descendant(memcg, root_memcg))
+			return true;
+	}
+	if (stock->irq_obj.cached_objcg) {
+		memcg = obj_cgroup_memcg(stock->irq_obj.cached_objcg);
 		if (memcg && mem_cgroup_is_descendant(memcg, root_memcg))
 			return true;
 	}
@@ -3160,13 +3206,10 @@ static bool obj_stock_flush_required(str
 static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
 			     bool allow_uncharge)
 {
-	struct memcg_stock_pcp *stock;
 	unsigned long flags;
+	struct obj_stock *stock = get_obj_stock(&flags);
 	unsigned int nr_pages = 0;
 
-	local_irq_save(flags);
-
-	stock = this_cpu_ptr(&memcg_stock);
 	if (stock->cached_objcg != objcg) { /* reset if necessary */
 		drain_obj_stock(stock);
 		obj_cgroup_get(objcg);
@@ -3182,7 +3225,7 @@ static void refill_obj_stock(struct obj_
 		stock->nr_bytes &= (PAGE_SIZE - 1);
 	}
 
-	local_irq_restore(flags);
+	put_obj_stock(flags);
 
 	if (nr_pages)
 		obj_cgroup_uncharge_pages(objcg, nr_pages);
@@ -6790,6 +6833,7 @@ static void uncharge_page(struct page *p
 	unsigned long nr_pages;
 	struct mem_cgroup *memcg;
 	struct obj_cgroup *objcg;
+	bool use_objcg = PageMemcgKmem(page);
 
 	VM_BUG_ON_PAGE(PageLRU(page), page);
 
@@ -6798,7 +6842,7 @@ static void uncharge_page(struct page *p
 	 * page memcg or objcg at this point, we have fully
 	 * exclusive access to the page.
 	 */
-	if (PageMemcgKmem(page)) {
+	if (use_objcg) {
 		objcg = __page_objcg(page);
 		/*
 		 * This get matches the put at the end of the function and
@@ -6826,7 +6870,7 @@ static void uncharge_page(struct page *p
 
 	nr_pages = compound_nr(page);
 
-	if (PageMemcgKmem(page)) {
+	if (use_objcg) {
 		ug->nr_memory += nr_pages;
 		ug->nr_kmem += nr_pages;
 
_

Patches currently in -mm which might be from longman@redhat.com are


