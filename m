Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1001F099A
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119356; cv=none; b=ElsIoD3aHvK3CBJlsgsZxyxAlyw2FVMS+LqepnB4CdnwdeGnAFHaMUqXMbP/1ppb/bvC88fwHTO1dlEPkU0/gt8Rq6J+kQAlj4+KZAW+Zpm0zRZGicjTpQNSWmPhCsLpQynGPTZWIPfJE9I1xU+3AnxXxQiS0nF8OHtZt24VIwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119356; c=relaxed/simple;
	bh=oAX5k+VuuafgKU7tn+01YYZ/do8RqdQkYtjSxCWkQ1s=;
	h=Date:To:From:Subject:Message-Id; b=kCDmbfOnwXMU9Mxi9GS5tV3ryVZA1Gf59LLYGmUXQl8LA/S1Av3VnahLLIYhaz65FyVbSc4qhcZW9v7Mzl49fy5B0r0pnlCaR3s7/VlZb4DPjYMU596vVXxB3iYR4WMx7wdfRgyOVLOmKFdv/zT9ilpbikKIKBjw5j1RsR90QUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SnlZOC9+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SnlZOC9+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71335C4CEED;
	Tue, 13 May 2025 06:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119356;
	bh=oAX5k+VuuafgKU7tn+01YYZ/do8RqdQkYtjSxCWkQ1s=;
	h=Date:To:From:Subject:From;
	b=SnlZOC9+jdFa1/EDj0i+hY+6AbRt4yR1oemqvS4/dTO+xFx63nMJZ4/QA/EVRnNCr
	 Yy4uhbTcXCqZEc6pc/ipt1K7W6DTd156Er7Yv41lW0Jf8CUSv5IQvyMJk4NLXC5/Ng
	 JQegxBfkgCKyTUgcBZFzYPMxHm1+w7XRVlchm1sQ=
Date: Mon, 12 May 2025 23:55:55 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,kuba@kernel.org,hannes@cmpxchg.org,edumazet@google.com,bigeasy@linutronix.de,ast@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-completely-decouple-memcg-and-obj-stocks.patch removed from -mm tree
Message-Id: <20250513065556.71335C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: completely decouple memcg and obj stocks
has been removed from the -mm tree.  Its filename was
     memcg-completely-decouple-memcg-and-obj-stocks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: completely decouple memcg and obj stocks
Date: Tue, 6 May 2025 15:55:32 -0700

Let's completely decouple the memcg and obj per-cpu stocks.  This will
enable us to make memcg per-cpu stocks to used without disabling irqs. 
Also it will enable us to make obj stocks nmi safe independently which is
required to make kmalloc/slab safe for allocations from nmi context.

Link: https://lkml.kernel.org/r/20250506225533.2580386-4-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Eric Dumaze <edumazet@google.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  149 ++++++++++++++++++++++++++++------------------
 1 file changed, 92 insertions(+), 57 deletions(-)

--- a/mm/memcontrol.c~memcg-completely-decouple-memcg-and-obj-stocks
+++ a/mm/memcontrol.c
@@ -1803,12 +1803,22 @@ void mem_cgroup_print_oom_group(struct m
  * nr_pages in a single cacheline. This may change in future.
  */
 #define NR_MEMCG_STOCK 7
+#define FLUSHING_CACHED_CHARGE	0
 struct memcg_stock_pcp {
-	local_trylock_t memcg_lock;
+	local_trylock_t lock;
 	uint8_t nr_pages[NR_MEMCG_STOCK];
 	struct mem_cgroup *cached[NR_MEMCG_STOCK];
 
-	local_trylock_t obj_lock;
+	struct work_struct work;
+	unsigned long flags;
+};
+
+static DEFINE_PER_CPU_ALIGNED(struct memcg_stock_pcp, memcg_stock) = {
+	.lock = INIT_LOCAL_TRYLOCK(lock),
+};
+
+struct obj_stock_pcp {
+	local_trylock_t lock;
 	unsigned int nr_bytes;
 	struct obj_cgroup *cached_objcg;
 	struct pglist_data *cached_pgdat;
@@ -1817,16 +1827,16 @@ struct memcg_stock_pcp {
 
 	struct work_struct work;
 	unsigned long flags;
-#define FLUSHING_CACHED_CHARGE	0
 };
-static DEFINE_PER_CPU_ALIGNED(struct memcg_stock_pcp, memcg_stock) = {
-	.memcg_lock = INIT_LOCAL_TRYLOCK(memcg_lock),
-	.obj_lock = INIT_LOCAL_TRYLOCK(obj_lock),
+
+static DEFINE_PER_CPU_ALIGNED(struct obj_stock_pcp, obj_stock) = {
+	.lock = INIT_LOCAL_TRYLOCK(lock),
 };
+
 static DEFINE_MUTEX(percpu_charge_mutex);
 
-static void drain_obj_stock(struct memcg_stock_pcp *stock);
-static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
+static void drain_obj_stock(struct obj_stock_pcp *stock);
+static bool obj_stock_flush_required(struct obj_stock_pcp *stock,
 				     struct mem_cgroup *root_memcg);
 
 /**
@@ -1849,7 +1859,7 @@ static bool consume_stock(struct mem_cgr
 	int i;
 
 	if (nr_pages > MEMCG_CHARGE_BATCH ||
-	    !local_trylock_irqsave(&memcg_stock.memcg_lock, flags))
+	    !local_trylock_irqsave(&memcg_stock.lock, flags))
 		return ret;
 
 	stock = this_cpu_ptr(&memcg_stock);
@@ -1866,7 +1876,7 @@ static bool consume_stock(struct mem_cgr
 		break;
 	}
 
-	local_unlock_irqrestore(&memcg_stock.memcg_lock, flags);
+	local_unlock_irqrestore(&memcg_stock.lock, flags);
 
 	return ret;
 }
@@ -1907,7 +1917,7 @@ static void drain_stock_fully(struct mem
 		drain_stock(stock, i);
 }
 
-static void drain_local_stock(struct work_struct *dummy)
+static void drain_local_memcg_stock(struct work_struct *dummy)
 {
 	struct memcg_stock_pcp *stock;
 	unsigned long flags;
@@ -1915,16 +1925,30 @@ static void drain_local_stock(struct wor
 	if (WARN_ONCE(!in_task(), "drain in non-task context"))
 		return;
 
-	local_lock_irqsave(&memcg_stock.obj_lock, flags);
-	stock = this_cpu_ptr(&memcg_stock);
-	drain_obj_stock(stock);
-	local_unlock_irqrestore(&memcg_stock.obj_lock, flags);
+	local_lock_irqsave(&memcg_stock.lock, flags);
 
-	local_lock_irqsave(&memcg_stock.memcg_lock, flags);
 	stock = this_cpu_ptr(&memcg_stock);
 	drain_stock_fully(stock);
 	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
-	local_unlock_irqrestore(&memcg_stock.memcg_lock, flags);
+
+	local_unlock_irqrestore(&memcg_stock.lock, flags);
+}
+
+static void drain_local_obj_stock(struct work_struct *dummy)
+{
+	struct obj_stock_pcp *stock;
+	unsigned long flags;
+
+	if (WARN_ONCE(!in_task(), "drain in non-task context"))
+		return;
+
+	local_lock_irqsave(&obj_stock.lock, flags);
+
+	stock = this_cpu_ptr(&obj_stock);
+	drain_obj_stock(stock);
+	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
+
+	local_unlock_irqrestore(&obj_stock.lock, flags);
 }
 
 static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
@@ -1947,10 +1971,10 @@ static void refill_stock(struct mem_cgro
 	VM_WARN_ON_ONCE(mem_cgroup_is_root(memcg));
 
 	if (nr_pages > MEMCG_CHARGE_BATCH ||
-	    !local_trylock_irqsave(&memcg_stock.memcg_lock, flags)) {
+	    !local_trylock_irqsave(&memcg_stock.lock, flags)) {
 		/*
 		 * In case of larger than batch refill or unlikely failure to
-		 * lock the percpu memcg_lock, uncharge memcg directly.
+		 * lock the percpu memcg_stock.lock, uncharge memcg directly.
 		 */
 		memcg_uncharge(memcg, nr_pages);
 		return;
@@ -1982,23 +2006,17 @@ static void refill_stock(struct mem_cgro
 		WRITE_ONCE(stock->nr_pages[i], nr_pages);
 	}
 
-	local_unlock_irqrestore(&memcg_stock.memcg_lock, flags);
+	local_unlock_irqrestore(&memcg_stock.lock, flags);
 }
 
-static bool is_drain_needed(struct memcg_stock_pcp *stock,
-			    struct mem_cgroup *root_memcg)
+static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
+				  struct mem_cgroup *root_memcg)
 {
 	struct mem_cgroup *memcg;
 	bool flush = false;
 	int i;
 
 	rcu_read_lock();
-
-	if (obj_stock_flush_required(stock, root_memcg)) {
-		flush = true;
-		goto out;
-	}
-
 	for (i = 0; i < NR_MEMCG_STOCK; ++i) {
 		memcg = READ_ONCE(stock->cached[i]);
 		if (!memcg)
@@ -2010,7 +2028,6 @@ static bool is_drain_needed(struct memcg
 			break;
 		}
 	}
-out:
 	rcu_read_unlock();
 	return flush;
 }
@@ -2035,15 +2052,27 @@ void drain_all_stock(struct mem_cgroup *
 	migrate_disable();
 	curcpu = smp_processor_id();
 	for_each_online_cpu(cpu) {
-		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
-		bool flush = is_drain_needed(stock, root_memcg);
+		struct memcg_stock_pcp *memcg_st = &per_cpu(memcg_stock, cpu);
+		struct obj_stock_pcp *obj_st = &per_cpu(obj_stock, cpu);
 
-		if (flush &&
-		    !test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags)) {
+		if (!test_bit(FLUSHING_CACHED_CHARGE, &memcg_st->flags) &&
+		    is_memcg_drain_needed(memcg_st, root_memcg) &&
+		    !test_and_set_bit(FLUSHING_CACHED_CHARGE,
+				      &memcg_st->flags)) {
 			if (cpu == curcpu)
-				drain_local_stock(&stock->work);
+				drain_local_memcg_stock(&memcg_st->work);
 			else if (!cpu_is_isolated(cpu))
-				schedule_work_on(cpu, &stock->work);
+				schedule_work_on(cpu, &memcg_st->work);
+		}
+
+		if (!test_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags) &&
+		    obj_stock_flush_required(obj_st, root_memcg) &&
+		    !test_and_set_bit(FLUSHING_CACHED_CHARGE,
+				      &obj_st->flags)) {
+			if (cpu == curcpu)
+				drain_local_obj_stock(&obj_st->work);
+			else if (!cpu_is_isolated(cpu))
+				schedule_work_on(cpu, &obj_st->work);
 		}
 	}
 	migrate_enable();
@@ -2052,18 +2081,18 @@ void drain_all_stock(struct mem_cgroup *
 
 static int memcg_hotplug_cpu_dead(unsigned int cpu)
 {
-	struct memcg_stock_pcp *stock;
+	struct obj_stock_pcp *obj_st;
 	unsigned long flags;
 
-	stock = &per_cpu(memcg_stock, cpu);
+	obj_st = &per_cpu(obj_stock, cpu);
 
-	/* drain_obj_stock requires obj_lock */
-	local_lock_irqsave(&memcg_stock.obj_lock, flags);
-	drain_obj_stock(stock);
-	local_unlock_irqrestore(&memcg_stock.obj_lock, flags);
+	/* drain_obj_stock requires objstock.lock */
+	local_lock_irqsave(&obj_stock.lock, flags);
+	drain_obj_stock(obj_st);
+	local_unlock_irqrestore(&obj_stock.lock, flags);
 
 	/* no need for the local lock */
-	drain_stock_fully(stock);
+	drain_stock_fully(&per_cpu(memcg_stock, cpu));
 
 	return 0;
 }
@@ -2860,7 +2889,7 @@ void __memcg_kmem_uncharge_page(struct p
 }
 
 static void __account_obj_stock(struct obj_cgroup *objcg,
-				struct memcg_stock_pcp *stock, int nr,
+				struct obj_stock_pcp *stock, int nr,
 				struct pglist_data *pgdat, enum node_stat_item idx)
 {
 	int *bytes;
@@ -2911,13 +2940,13 @@ static void __account_obj_stock(struct o
 static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
 			      struct pglist_data *pgdat, enum node_stat_item idx)
 {
-	struct memcg_stock_pcp *stock;
+	struct obj_stock_pcp *stock;
 	unsigned long flags;
 	bool ret = false;
 
-	local_lock_irqsave(&memcg_stock.obj_lock, flags);
+	local_lock_irqsave(&obj_stock.lock, flags);
 
-	stock = this_cpu_ptr(&memcg_stock);
+	stock = this_cpu_ptr(&obj_stock);
 	if (objcg == READ_ONCE(stock->cached_objcg) && stock->nr_bytes >= nr_bytes) {
 		stock->nr_bytes -= nr_bytes;
 		ret = true;
@@ -2926,12 +2955,12 @@ static bool consume_obj_stock(struct obj
 			__account_obj_stock(objcg, stock, nr_bytes, pgdat, idx);
 	}
 
-	local_unlock_irqrestore(&memcg_stock.obj_lock, flags);
+	local_unlock_irqrestore(&obj_stock.lock, flags);
 
 	return ret;
 }
 
-static void drain_obj_stock(struct memcg_stock_pcp *stock)
+static void drain_obj_stock(struct obj_stock_pcp *stock)
 {
 	struct obj_cgroup *old = READ_ONCE(stock->cached_objcg);
 
@@ -2992,32 +3021,35 @@ static void drain_obj_stock(struct memcg
 	obj_cgroup_put(old);
 }
 
-static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
+static bool obj_stock_flush_required(struct obj_stock_pcp *stock,
 				     struct mem_cgroup *root_memcg)
 {
 	struct obj_cgroup *objcg = READ_ONCE(stock->cached_objcg);
 	struct mem_cgroup *memcg;
+	bool flush = false;
 
+	rcu_read_lock();
 	if (objcg) {
 		memcg = obj_cgroup_memcg(objcg);
 		if (memcg && mem_cgroup_is_descendant(memcg, root_memcg))
-			return true;
+			flush = true;
 	}
+	rcu_read_unlock();
 
-	return false;
+	return flush;
 }
 
 static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
 		bool allow_uncharge, int nr_acct, struct pglist_data *pgdat,
 		enum node_stat_item idx)
 {
-	struct memcg_stock_pcp *stock;
+	struct obj_stock_pcp *stock;
 	unsigned long flags;
 	unsigned int nr_pages = 0;
 
-	local_lock_irqsave(&memcg_stock.obj_lock, flags);
+	local_lock_irqsave(&obj_stock.lock, flags);
 
-	stock = this_cpu_ptr(&memcg_stock);
+	stock = this_cpu_ptr(&obj_stock);
 	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
 		drain_obj_stock(stock);
 		obj_cgroup_get(objcg);
@@ -3037,7 +3069,7 @@ static void refill_obj_stock(struct obj_
 		stock->nr_bytes &= (PAGE_SIZE - 1);
 	}
 
-	local_unlock_irqrestore(&memcg_stock.obj_lock, flags);
+	local_unlock_irqrestore(&obj_stock.lock, flags);
 
 	if (nr_pages)
 		obj_cgroup_uncharge_pages(objcg, nr_pages);
@@ -5156,9 +5188,12 @@ int __init mem_cgroup_init(void)
 	cpuhp_setup_state_nocalls(CPUHP_MM_MEMCQ_DEAD, "mm/memctrl:dead", NULL,
 				  memcg_hotplug_cpu_dead);
 
-	for_each_possible_cpu(cpu)
+	for_each_possible_cpu(cpu) {
 		INIT_WORK(&per_cpu_ptr(&memcg_stock, cpu)->work,
-			  drain_local_stock);
+			  drain_local_memcg_stock);
+		INIT_WORK(&per_cpu_ptr(&obj_stock, cpu)->work,
+			  drain_local_obj_stock);
+	}
 
 	memcg_size = struct_size_t(struct mem_cgroup, nodeinfo, nr_node_ids);
 	memcg_cachep = kmem_cache_create("mem_cgroup", memcg_size, 0,
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


