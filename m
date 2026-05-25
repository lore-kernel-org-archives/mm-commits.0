Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C053AA50B
	for <mm-commits@vger.kernel.org>; Mon, 25 May 2026 20:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779741148; cv=none; b=GVdVlHN/on6I4hFiSiF7y9dKp6/fMxzwi2VpuD0NZLvDMt3EecdUBmVDuJvboEc/WuVpagqSru6XsvF6lDujoj044j7NrNdgnp4cDQm7eNaHCWo+gsVDGMZAo7ToRp9AnthRIb5CTsM/COg3XV1hi7uc/WSW4IWyiEx5hVUG+6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779741148; c=relaxed/simple;
	bh=wX3hd7PhOuPuwNggAHOgmmMkGIepkjOhclnt4Ml8QoE=;
	h=Date:To:From:Subject:Message-Id; b=UGgUFCstGkw8rjZe1sLOPxj/VD3SWu25vJ98fY2rdqH1gh5gaE5B1jzdWs9zWX6h1UUaiYsfO+KdWHvmFj4HNrnQTYpn9guF1AHw1BnfnnPzoX/woQqpNrHLcCO6uy6Cn4dblcewF8huQo4ONf46V8u6GeMEZB7qL+zObdxt38Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JqO6+TYK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JqO6+TYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0901F000E9;
	Mon, 25 May 2026 20:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779741146;
	bh=6RhYR9W66YVpSvgJWOPOQNpCwUhLFNdpOyJQ8OB42TM=;
	h=Date:To:From:Subject;
	b=JqO6+TYK6zLHzF4fesYkhwVKLb2KGltmYldc75DZkGDCYjicZM7neGm8E/w1PRS0j
	 lIycfLZzHBBiGwfL+R1sYFiQBrd8GN841m1q0dcMJVzOkApkpZGEDocaF7QuWuT3iX
	 39NxsDNHQ64fC5wjGwuWbHxzkgHz4Z+cbzm7T+7w=
Date: Mon, 25 May 2026 13:32:26 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] memcg-multi-objcg-charge-support.patch removed from -mm tree
Message-Id: <20260525203226.AE0901F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: multi objcg charge support
has been removed from the -mm tree.  Its filename was
     memcg-multi-objcg-charge-support.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: multi objcg charge support
Date: Thu, 21 May 2026 18:19:08 -0700

Commit 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg
per-node type") split a memcg's single obj_cgroup into one per NUMA node
so that reparenting LRU folios can take per-node lru locks.  As a side
effect, the per-CPU obj_stock_pcp -- which caches exactly one cached_objcg
-- thrashes on workloads where threads of the same memcg run on different
NUMA nodes.  The kernel test robot reported a 67.7% regression on
stress-ng.switch.ops_per_sec from this pattern.

Mirror the multi-slot pattern already used by memcg_stock_pcp: turn
nr_bytes and cached_objcg into NR_OBJ_STOCK-element arrays, scan all slots
on consume/refill/account, prefer empty slots when inserting, and evict a
random slot only when full.  With multiple slots a CPU can hold the
per-node objcg variants of one memcg plus a few siblings without ever
forcing a drain.

A single int8_t index records which slot the cached slab stats belong to;
the stats are flushed on slot or pgdat change.  With NR_OBJ_STOCK = 5 the
layout (verified with pahole) is:

  offset 0  : lock(1) + index(1) + node_id(2) + slab stats(4) = 8B
  offset 8  : nr_bytes[5]                                     = 10B
  offset 18 : padding                                         = 6B
  offset 24 : cached[5]                                       = 40B
  offset 64 : (line 2) work_struct + flags (cold)

so consume_obj_stock, refill_obj_stock and the slab account path each
touch exactly one 64-byte cache line on non-debug 64-bit builds.

Link: https://lore.kernel.org/20260522011908.1669332-5-shakeel.butt@linux.dev
Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202605121641.b6a60cb0-lkp@intel.com
Tested-by: kernel test robot <oliver.sang@intel.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Harry Yoo (Oracle) <harry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  188 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 136 insertions(+), 52 deletions(-)

--- a/mm/memcontrol.c~memcg-multi-objcg-charge-support
+++ a/mm/memcontrol.c
@@ -150,14 +150,14 @@ static void obj_cgroup_release(struct pe
 	 * However, it can be PAGE_SIZE or (x * PAGE_SIZE).
 	 *
 	 * The following sequence can lead to it:
-	 * 1) CPU0: objcg == stock->cached_objcg
+	 * 1) CPU0: objcg cached in one of stock->cached[i]
 	 * 2) CPU1: we do a small allocation (e.g. 92 bytes),
 	 *          PAGE_SIZE bytes are charged
 	 * 3) CPU1: a process from another memcg is allocating something,
 	 *          the stock if flushed,
 	 *          objcg->nr_charged_bytes = PAGE_SIZE - 92
 	 * 5) CPU0: we do release this object,
-	 *          92 bytes are added to stock->nr_bytes
+	 *          92 bytes are added to stock->nr_bytes[i]
 	 * 6) CPU0: stock is flushed,
 	 *          92 bytes are added to objcg->nr_charged_bytes
 	 *
@@ -2018,25 +2018,40 @@ static DEFINE_PER_CPU_ALIGNED(struct mem
 	.lock = INIT_LOCAL_TRYLOCK(lock),
 };
 
+/*
+ * NR_OBJ_STOCK is sized so the entire hot path of obj_stock_pcp
+ * (lock, accounting metadata, nr_bytes[] and cached[]) fits within a
+ * single 64-byte cache line on non-debug 64-bit builds. With 5 slots:
+ *   lock(1) + index(1) + node_id(2) + slab stats(4) + nr_bytes(10)
+ *   + pad(6) + cached(40) == 64 bytes.
+ * A CPU can thus consume/refill/account against five different objcgs
+ * (typically per-node variants of the same memcg) while incurring at
+ * most one cache miss on the stock.
+ */
+#define NR_OBJ_STOCK 5
 struct obj_stock_pcp {
 	local_trylock_t lock;
-	struct obj_cgroup *cached_objcg;
-	uint16_t nr_bytes;
+	int8_t index;
 	int16_t node_id;
 	int16_t nr_slab_reclaimable_b;
 	int16_t nr_slab_unreclaimable_b;
+	uint16_t nr_bytes[NR_OBJ_STOCK];
+	struct obj_cgroup *cached[NR_OBJ_STOCK];
 
 	struct work_struct work;
 	unsigned long flags;
+	uint8_t drain_idx;
 };
 
 static DEFINE_PER_CPU_ALIGNED(struct obj_stock_pcp, obj_stock) = {
 	.lock = INIT_LOCAL_TRYLOCK(lock),
+	.index = -1,
 	.node_id = NUMA_NO_NODE,
 };
 
 static DEFINE_MUTEX(percpu_charge_mutex);
 
+static void drain_obj_stock_slot(struct obj_stock_pcp *stock, int i);
 static void drain_obj_stock(struct obj_stock_pcp *stock);
 static bool obj_stock_flush_required(struct obj_stock_pcp *stock,
 				     struct mem_cgroup *root_memcg);
@@ -3156,12 +3171,13 @@ static void unlock_stock(struct obj_stoc
 		local_unlock(&obj_stock.lock);
 }
 
-/* Call after __refill_obj_stock() to ensure stock->cached_objg == objcg */
+/* Call after __refill_obj_stock() so a slot for objcg exists in the stock */
 static void __account_obj_stock(struct obj_cgroup *objcg,
 				struct obj_stock_pcp *stock, int nr,
 				struct pglist_data *pgdat, enum node_stat_item idx)
 {
 	int16_t *bytes;
+	int i;
 
 	/*
 	 * Though at the moment MAX_NUMNODES <= 1024 in all archs but let's make
@@ -3170,29 +3186,39 @@ static void __account_obj_stock(struct o
 	 */
 	BUILD_BUG_ON(MAX_NUMNODES >= S16_MAX);
 
-	if (!stock || READ_ONCE(stock->cached_objcg) != objcg)
+	if (!stock)
+		goto direct;
+
+	for (i = 0; i < NR_OBJ_STOCK; ++i) {
+		if (READ_ONCE(stock->cached[i]) == objcg)
+			break;
+	}
+	if (i == NR_OBJ_STOCK)
 		goto direct;
 
 	/*
 	 * Save vmstat data in stock and skip vmstat array update unless
-	 * accumulating over a page of vmstat data or when pgdat changes.
+	 * accumulating over a page of vmstat data or when the objcg slot or
+	 * pgdat the stats belong to changes.
 	 */
-	if (stock->node_id == NUMA_NO_NODE) {
+	if (stock->index < 0) {
+		stock->index = i;
 		stock->node_id = pgdat->node_id;
-	} else if (stock->node_id != pgdat->node_id) {
-		/* Flush the existing cached vmstat data */
+	} else if (stock->index != i || stock->node_id != pgdat->node_id) {
+		struct obj_cgroup *old = READ_ONCE(stock->cached[stock->index]);
 		struct pglist_data *oldpg = NODE_DATA(stock->node_id);
 
 		if (stock->nr_slab_reclaimable_b) {
-			mod_objcg_mlstate(objcg, oldpg, NR_SLAB_RECLAIMABLE_B,
+			mod_objcg_mlstate(old, oldpg, NR_SLAB_RECLAIMABLE_B,
 					  stock->nr_slab_reclaimable_b);
 			stock->nr_slab_reclaimable_b = 0;
 		}
 		if (stock->nr_slab_unreclaimable_b) {
-			mod_objcg_mlstate(objcg, oldpg, NR_SLAB_UNRECLAIMABLE_B,
+			mod_objcg_mlstate(old, oldpg, NR_SLAB_UNRECLAIMABLE_B,
 					  stock->nr_slab_unreclaimable_b);
 			stock->nr_slab_unreclaimable_b = 0;
 		}
+		stock->index = i;
 		stock->node_id = pgdat->node_id;
 	}
 
@@ -3233,10 +3259,16 @@ static bool __consume_obj_stock(struct o
 				struct obj_stock_pcp *stock,
 				unsigned int nr_bytes)
 {
-	if (objcg == READ_ONCE(stock->cached_objcg) &&
-	    stock->nr_bytes >= nr_bytes) {
-		stock->nr_bytes -= nr_bytes;
-		return true;
+	int i;
+
+	for (i = 0; i < NR_OBJ_STOCK; ++i) {
+		if (READ_ONCE(stock->cached[i]) != objcg)
+			continue;
+		if (stock->nr_bytes[i] >= nr_bytes) {
+			stock->nr_bytes[i] -= nr_bytes;
+			return true;
+		}
+		return false;
 	}
 
 	return false;
@@ -3257,16 +3289,42 @@ static bool consume_obj_stock(struct obj
 	return ret;
 }
 
-static void drain_obj_stock(struct obj_stock_pcp *stock)
+/* Flush the cached slab stats (if any) back to their owning objcg/pgdat. */
+static void drain_obj_stock_stats(struct obj_stock_pcp *stock)
 {
-	struct obj_cgroup *old = READ_ONCE(stock->cached_objcg);
+	struct obj_cgroup *old;
+	struct pglist_data *oldpg;
+
+	if (stock->index < 0)
+		return;
+
+	old = READ_ONCE(stock->cached[stock->index]);
+	oldpg = NODE_DATA(stock->node_id);
+
+	if (stock->nr_slab_reclaimable_b) {
+		mod_objcg_mlstate(old, oldpg, NR_SLAB_RECLAIMABLE_B,
+				  stock->nr_slab_reclaimable_b);
+		stock->nr_slab_reclaimable_b = 0;
+	}
+	if (stock->nr_slab_unreclaimable_b) {
+		mod_objcg_mlstate(old, oldpg, NR_SLAB_UNRECLAIMABLE_B,
+				  stock->nr_slab_unreclaimable_b);
+		stock->nr_slab_unreclaimable_b = 0;
+	}
+	stock->index = -1;
+	stock->node_id = NUMA_NO_NODE;
+}
+
+static void drain_obj_stock_slot(struct obj_stock_pcp *stock, int i)
+{
+	struct obj_cgroup *old = READ_ONCE(stock->cached[i]);
 
 	if (!old)
 		return;
 
-	if (stock->nr_bytes) {
-		unsigned int nr_pages = stock->nr_bytes >> PAGE_SHIFT;
-		unsigned int nr_bytes = stock->nr_bytes & (PAGE_SIZE - 1);
+	if (stock->nr_bytes[i]) {
+		unsigned int nr_pages = stock->nr_bytes[i] >> PAGE_SHIFT;
+		unsigned int nr_bytes = stock->nr_bytes[i] & (PAGE_SIZE - 1);
 
 		if (nr_pages) {
 			struct mem_cgroup *memcg;
@@ -3292,46 +3350,43 @@ static void drain_obj_stock(struct obj_s
 		 * so it might be changed in the future.
 		 */
 		atomic_add(nr_bytes, &old->nr_charged_bytes);
-		stock->nr_bytes = 0;
+		stock->nr_bytes[i] = 0;
 	}
 
-	/*
-	 * Flush the vmstat data in current stock
-	 */
-	if (stock->nr_slab_reclaimable_b || stock->nr_slab_unreclaimable_b) {
-		struct pglist_data *oldpg = NODE_DATA(stock->node_id);
+	/* Flush vmstat data when its owning slot is being drained. */
+	if (stock->index == i)
+		drain_obj_stock_stats(stock);
 
-		if (stock->nr_slab_reclaimable_b) {
-			mod_objcg_mlstate(old, oldpg,
-					  NR_SLAB_RECLAIMABLE_B,
-					  stock->nr_slab_reclaimable_b);
-			stock->nr_slab_reclaimable_b = 0;
-		}
-		if (stock->nr_slab_unreclaimable_b) {
-			mod_objcg_mlstate(old, oldpg,
-					  NR_SLAB_UNRECLAIMABLE_B,
-					  stock->nr_slab_unreclaimable_b);
-			stock->nr_slab_unreclaimable_b = 0;
-		}
-		stock->node_id = NUMA_NO_NODE;
-	}
-
-	WRITE_ONCE(stock->cached_objcg, NULL);
+	WRITE_ONCE(stock->cached[i], NULL);
 	obj_cgroup_put(old);
 }
 
+static void drain_obj_stock(struct obj_stock_pcp *stock)
+{
+	int i;
+
+	for (i = 0; i < NR_OBJ_STOCK; ++i)
+		drain_obj_stock_slot(stock, i);
+}
+
 static bool obj_stock_flush_required(struct obj_stock_pcp *stock,
 				     struct mem_cgroup *root_memcg)
 {
-	struct obj_cgroup *objcg = READ_ONCE(stock->cached_objcg);
+	struct obj_cgroup *objcg;
 	struct mem_cgroup *memcg;
 	bool flush = false;
+	int i;
 
 	rcu_read_lock();
-	if (objcg) {
+	for (i = 0; i < NR_OBJ_STOCK; ++i) {
+		objcg = READ_ONCE(stock->cached[i]);
+		if (!objcg)
+			continue;
 		memcg = obj_cgroup_memcg(objcg);
-		if (memcg && mem_cgroup_is_descendant(memcg, root_memcg))
+		if (memcg && mem_cgroup_is_descendant(memcg, root_memcg)) {
 			flush = true;
+			break;
+		}
 	}
 	rcu_read_unlock();
 
@@ -3345,6 +3400,7 @@ static void __refill_obj_stock(struct ob
 {
 	unsigned int nr_pages = 0;
 	unsigned int stock_nr_bytes;
+	int i, slot = -1, empty_slot = -1;
 
 	if (!stock) {
 		nr_pages = nr_bytes >> PAGE_SHIFT;
@@ -3353,19 +3409,47 @@ static void __refill_obj_stock(struct ob
 		goto out;
 	}
 
-	stock_nr_bytes = stock->nr_bytes;
-	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
-		drain_obj_stock(stock);
+	for (i = 0; i < NR_OBJ_STOCK; ++i) {
+		struct obj_cgroup *cached = READ_ONCE(stock->cached[i]);
+
+		if (!cached) {
+			if (empty_slot == -1)
+				empty_slot = i;
+			continue;
+		}
+		if (cached == objcg) {
+			slot = i;
+			break;
+		}
+	}
+
+	if (slot == -1) {
+		slot = empty_slot;
+		if (slot == -1) {
+			slot = stock->drain_idx++;
+			if (stock->drain_idx == NR_OBJ_STOCK)
+				stock->drain_idx = 0;
+			drain_obj_stock_slot(stock, slot);
+		}
 		obj_cgroup_get(objcg);
+		/*
+		 * Keep the xchg result in the unsigned int local; storing
+		 * it directly into stock->nr_bytes[slot] (uint16_t) would
+		 * silently truncate values >= U16_MAX and bypass the flush
+		 * guard below, leaking page-counter charges.
+		 */
 		stock_nr_bytes = atomic_read(&objcg->nr_charged_bytes)
 				? atomic_xchg(&objcg->nr_charged_bytes, 0) : 0;
-		WRITE_ONCE(stock->cached_objcg, objcg);
+		WRITE_ONCE(stock->cached[slot], objcg);
 
 		allow_uncharge = true;	/* Allow uncharge when objcg changes */
+	} else {
+		stock_nr_bytes = stock->nr_bytes[slot];
 	}
+
 	stock_nr_bytes += nr_bytes;
 
-	/* Since stock->nr_bytes is uint16_t, don't refill >= U16_MAX */
+	/* nr_bytes[] is uint16_t; flush if we would refill >= U16_MAX. */
 	if ((allow_uncharge && (stock_nr_bytes > PAGE_SIZE)) ||
 	    stock_nr_bytes > U16_MAX) {
 		nr_pages = stock_nr_bytes >> PAGE_SHIFT;
@@ -3387,7 +3471,7 @@ static void __refill_obj_stock(struct ob
 			stock_nr_bytes = kept;
 		}
 	}
-	stock->nr_bytes = stock_nr_bytes;
+	stock->nr_bytes[slot] = stock_nr_bytes;
 
 out:
 	if (nr_pages)
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-use-round-robin-victim-selection-in-refill_stock.patch

