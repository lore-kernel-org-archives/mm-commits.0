Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7155C2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011139; cv=none; b=ascFI9hW1JE1jB959JgQgaT385ynqDJswg9lftSYDGX2jej+l6xVTeG+wzkncXFXWD/r1TVe9pkb0N0PpwE+5na5s/Yv078FbpPesQwqUivomFmXYNuGkSfWJUW+F3/EWTulrphRSLnVOIDsxCXNZpgVLs5r+Nn0jF0Df/ktrFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011139; c=relaxed/simple;
	bh=Wx8bUbWlMriA+iPvpPsA+5+e5l7OpXjJPEktupJACnM=;
	h=Date:To:From:Subject:Message-Id; b=bDsUnK+qkRvbEjlPrbXxdF1BsC07bBcb88KhVlUHWrNpXLxJuGjKEp+efOrFx699MxpTDqEoT/CZLqP6a62nOwfe1EWwq8FltHXm4AMtcIp//o1Nr7+k6rM57Kph21378JISU+LRmPvV1BgDE9kDPS3QwIESUTBRhQeUjJRn9C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=owqmxXgB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="owqmxXgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2F0C4CEE4;
	Mon, 12 May 2025 00:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011139;
	bh=Wx8bUbWlMriA+iPvpPsA+5+e5l7OpXjJPEktupJACnM=;
	h=Date:To:From:Subject:From;
	b=owqmxXgBYhgLRbZsE/zz+OEkEHJeSQ6/EkFSqgy+Y9HZTNl5BbMuYy2n3TpR3Uhyv
	 ZlfYJVbt8B6fAwI/M/rEwGLP/m8uauZ2u7Ju0Tpx403DlM9uBTILhRYVRrpM+qhGk/
	 GAQ4yfZ5wGKVYV/19QXPCuaineyl0ow7TyZNoy7k=
Date: Sun, 11 May 2025 17:52:19 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,soheil@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,kuba@kernel.org,hughd@google.com,hannes@cmpxchg.org,edumazet@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-multi-memcg-percpu-charge-cache.patch removed from -mm tree
Message-Id: <20250512005219.AD2F0C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: multi-memcg percpu charge cache
has been removed from the -mm tree.  Its filename was
     memcg-multi-memcg-percpu-charge-cache.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: multi-memcg percpu charge cache
Date: Wed, 16 Apr 2025 11:02:29 -0700

Memory cgroup accounting is expensive and to reduce the cost, the kernel
maintains per-cpu charge cache for a single memcg.  So, if a charge
request comes for a different memcg, the kernel will flush the old memcg's
charge cache and then charge the newer memcg a fixed amount (64 pages),
subtracts the charge request amount and stores the remaining in the
per-cpu charge cache for the newer memcg.

This mechanism is based on the assumption that the kernel, for locality,
keep a process on a CPU for long period of time and most of the charge
requests from that process will be served by that CPU's local charge
cache.

However this assumption breaks down for incoming network traffic in a
multi-tenant machine.  We are in the process of running multiple workloads
on a single machine and if such workloads are network heavy, we are seeing
very high network memory accounting cost.  We have observed multiple CPUs
spending almost 100% of their time in net_rx_action and almost all of that
time is spent in memcg accounting of the network traffic.

More precisely, net_rx_action is serving packets from multiple workloads
and is observing/serving mix of packets of these workloads.  The memcg
switch of per-cpu cache is very expensive and we are observing a lot of
memcg switches on the machine.  Almost all the time is being spent on
charging new memcg and flushing older memcg cache.  So, definitely we need
per-cpu cache that support multiple memcgs for this scenario.

This patch implements a simple (and dumb) multiple memcg percpu charge
cache.  Actually we started with more sophisticated LRU based approach but
the dumb one was always better than the sophisticated one by 1% to 3%, so
going with the simple approach.

Some of the design choices are:

1. Fit all caches memcgs in a single cacheline.
2. The cache array can be mix of empty slots or memcg charged slots, so
   the kernel has to traverse the full array.
3. The cache drain from the reclaim will drain all cached memcgs to keep
   things simple.

To evaluate the impact of this optimization, on a 72 CPUs machine, we ran
the following workload where each netperf client runs in a different
cgroup.  The next-20250415 kernel is used as base.

 $ netserver -6
 $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K

number of clients | Without patch | With patch
  6               | 42584.1 Mbps  | 48603.4 Mbps (14.13% improvement)
  12              | 30617.1 Mbps  | 47919.7 Mbps (56.51% improvement)
  18              | 25305.2 Mbps  | 45497.3 Mbps (79.79% improvement)
  24              | 20104.1 Mbps  | 37907.7 Mbps (88.55% improvement)
  30              | 14702.4 Mbps  | 30746.5 Mbps (109.12% improvement)
  36              | 10801.5 Mbps  | 26476.3 Mbps (145.11% improvement)

The results show drastic improvement for network intensive workloads.

[shakeel.butt@linux.dev: add BUILD_BUG_ON() for MEMCG_CHARGE_BATCH]
  Link: https://lkml.kernel.org/r/rlsgeosg3j7v5nihhbxxxbv3xfy4ejvigihj7lkkbt3n6imyne@2apxx2jm2e57
[shakeel.butt@linux.dev: simplify refill_stock]
  Link: https://lkml.kernel.org/r/as5cdsm4lraxupg3t6onep2ixql72za25hvd4x334dsoyo4apr@zyzl4vkuevuv
[hughd@google.com: it's better to stock nr_pages than the uninitialized stock_pages]
  Link: https://lkml.kernel.org/r/d542d18f-1caa-6fea-e2c3-3555c87bcf64@google.com
[shakeel.butt@linux.dev: add comment per Michal and use DEFINE_PER_CPU_ALIGNED instead of DEFINE_PER_CPU per Vlastimil]
  Link: https://lkml.kernel.org/r/dieeei3squ2gcnqxdjayvxbvzldr266rhnvtl3vjzsqevxkevf@ckui5vjzl2qg
Link: https://lkml.kernel.org/r/20250416180229.2902751-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Eric Dumaze <edumazet@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  144 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 106 insertions(+), 38 deletions(-)

--- a/mm/memcontrol.c~memcg-multi-memcg-percpu-charge-cache
+++ a/mm/memcontrol.c
@@ -1769,10 +1769,15 @@ void mem_cgroup_print_oom_group(struct m
 	pr_cont(" are going to be killed due to memory.oom.group set\n");
 }
 
+/*
+ * The value of NR_MEMCG_STOCK is selected to keep the cached memcgs and their
+ * nr_pages in a single cacheline. This may change in future.
+ */
+#define NR_MEMCG_STOCK 7
 struct memcg_stock_pcp {
 	local_trylock_t stock_lock;
-	struct mem_cgroup *cached; /* this never be root cgroup */
-	unsigned int nr_pages;
+	uint8_t nr_pages[NR_MEMCG_STOCK];
+	struct mem_cgroup *cached[NR_MEMCG_STOCK];
 
 	struct obj_cgroup *cached_objcg;
 	struct pglist_data *cached_pgdat;
@@ -1784,7 +1789,7 @@ struct memcg_stock_pcp {
 	unsigned long flags;
 #define FLUSHING_CACHED_CHARGE	0
 };
-static DEFINE_PER_CPU(struct memcg_stock_pcp, memcg_stock) = {
+static DEFINE_PER_CPU_ALIGNED(struct memcg_stock_pcp, memcg_stock) = {
 	.stock_lock = INIT_LOCAL_TRYLOCK(stock_lock),
 };
 static DEFINE_MUTEX(percpu_charge_mutex);
@@ -1809,9 +1814,10 @@ static bool consume_stock(struct mem_cgr
 			  gfp_t gfp_mask)
 {
 	struct memcg_stock_pcp *stock;
-	unsigned int stock_pages;
+	uint8_t stock_pages;
 	unsigned long flags;
 	bool ret = false;
+	int i;
 
 	if (nr_pages > MEMCG_CHARGE_BATCH)
 		return ret;
@@ -1822,10 +1828,17 @@ static bool consume_stock(struct mem_cgr
 		return ret;
 
 	stock = this_cpu_ptr(&memcg_stock);
-	stock_pages = READ_ONCE(stock->nr_pages);
-	if (memcg == READ_ONCE(stock->cached) && stock_pages >= nr_pages) {
-		WRITE_ONCE(stock->nr_pages, stock_pages - nr_pages);
-		ret = true;
+
+	for (i = 0; i < NR_MEMCG_STOCK; ++i) {
+		if (memcg != READ_ONCE(stock->cached[i]))
+			continue;
+
+		stock_pages = READ_ONCE(stock->nr_pages[i]);
+		if (stock_pages >= nr_pages) {
+			WRITE_ONCE(stock->nr_pages[i], stock_pages - nr_pages);
+			ret = true;
+		}
+		break;
 	}
 
 	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
@@ -1843,21 +1856,30 @@ static void memcg_uncharge(struct mem_cg
 /*
  * Returns stocks cached in percpu and reset cached information.
  */
-static void drain_stock(struct memcg_stock_pcp *stock)
+static void drain_stock(struct memcg_stock_pcp *stock, int i)
 {
-	unsigned int stock_pages = READ_ONCE(stock->nr_pages);
-	struct mem_cgroup *old = READ_ONCE(stock->cached);
+	struct mem_cgroup *old = READ_ONCE(stock->cached[i]);
+	uint8_t stock_pages;
 
 	if (!old)
 		return;
 
+	stock_pages = READ_ONCE(stock->nr_pages[i]);
 	if (stock_pages) {
 		memcg_uncharge(old, stock_pages);
-		WRITE_ONCE(stock->nr_pages, 0);
+		WRITE_ONCE(stock->nr_pages[i], 0);
 	}
 
 	css_put(&old->css);
-	WRITE_ONCE(stock->cached, NULL);
+	WRITE_ONCE(stock->cached[i], NULL);
+}
+
+static void drain_stock_fully(struct memcg_stock_pcp *stock)
+{
+	int i;
+
+	for (i = 0; i < NR_MEMCG_STOCK; ++i)
+		drain_stock(stock, i);
 }
 
 static void drain_local_stock(struct work_struct *dummy)
@@ -1874,7 +1896,7 @@ static void drain_local_stock(struct wor
 
 	stock = this_cpu_ptr(&memcg_stock);
 	drain_obj_stock(stock);
-	drain_stock(stock);
+	drain_stock_fully(stock);
 	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
 
 	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
@@ -1883,35 +1905,91 @@ static void drain_local_stock(struct wor
 static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
 	struct memcg_stock_pcp *stock;
-	unsigned int stock_pages;
+	struct mem_cgroup *cached;
+	uint8_t stock_pages;
 	unsigned long flags;
+	bool success = false;
+	int empty_slot = -1;
+	int i;
+
+	/*
+	 * For now limit MEMCG_CHARGE_BATCH to 127 and less. In future if we
+	 * decide to increase it more than 127 then we will need more careful
+	 * handling of nr_pages[] in struct memcg_stock_pcp.
+	 */
+	BUILD_BUG_ON(MEMCG_CHARGE_BATCH > S8_MAX);
 
 	VM_WARN_ON_ONCE(mem_cgroup_is_root(memcg));
 
-	if (!local_trylock_irqsave(&memcg_stock.stock_lock, flags)) {
+	if (nr_pages > MEMCG_CHARGE_BATCH ||
+	    !local_trylock_irqsave(&memcg_stock.stock_lock, flags)) {
 		/*
-		 * In case of unlikely failure to lock percpu stock_lock
-		 * uncharge memcg directly.
+		 * In case of larger than batch refill or unlikely failure to
+		 * lock the percpu stock_lock, uncharge memcg directly.
 		 */
 		memcg_uncharge(memcg, nr_pages);
 		return;
 	}
 
 	stock = this_cpu_ptr(&memcg_stock);
-	if (READ_ONCE(stock->cached) != memcg) { /* reset if necessary */
-		drain_stock(stock);
-		css_get(&memcg->css);
-		WRITE_ONCE(stock->cached, memcg);
+	for (i = 0; i < NR_MEMCG_STOCK; ++i) {
+		cached = READ_ONCE(stock->cached[i]);
+		if (!cached && empty_slot == -1)
+			empty_slot = i;
+		if (memcg == READ_ONCE(stock->cached[i])) {
+			stock_pages = READ_ONCE(stock->nr_pages[i]) + nr_pages;
+			WRITE_ONCE(stock->nr_pages[i], stock_pages);
+			if (stock_pages > MEMCG_CHARGE_BATCH)
+				drain_stock(stock, i);
+			success = true;
+			break;
+		}
 	}
-	stock_pages = READ_ONCE(stock->nr_pages) + nr_pages;
-	WRITE_ONCE(stock->nr_pages, stock_pages);
 
-	if (stock_pages > MEMCG_CHARGE_BATCH)
-		drain_stock(stock);
+	if (!success) {
+		i = empty_slot;
+		if (i == -1) {
+			i = get_random_u32_below(NR_MEMCG_STOCK);
+			drain_stock(stock, i);
+		}
+		css_get(&memcg->css);
+		WRITE_ONCE(stock->cached[i], memcg);
+		WRITE_ONCE(stock->nr_pages[i], nr_pages);
+	}
 
 	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
 }
 
+static bool is_drain_needed(struct memcg_stock_pcp *stock,
+			    struct mem_cgroup *root_memcg)
+{
+	struct mem_cgroup *memcg;
+	bool flush = false;
+	int i;
+
+	rcu_read_lock();
+
+	if (obj_stock_flush_required(stock, root_memcg)) {
+		flush = true;
+		goto out;
+	}
+
+	for (i = 0; i < NR_MEMCG_STOCK; ++i) {
+		memcg = READ_ONCE(stock->cached[i]);
+		if (!memcg)
+			continue;
+
+		if (READ_ONCE(stock->nr_pages[i]) &&
+		    mem_cgroup_is_descendant(memcg, root_memcg)) {
+			flush = true;
+			break;
+		}
+	}
+out:
+	rcu_read_unlock();
+	return flush;
+}
+
 /*
  * Drains all per-CPU charge caches for given root_memcg resp. subtree
  * of the hierarchy under it.
@@ -1933,17 +2011,7 @@ void drain_all_stock(struct mem_cgroup *
 	curcpu = smp_processor_id();
 	for_each_online_cpu(cpu) {
 		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
-		struct mem_cgroup *memcg;
-		bool flush = false;
-
-		rcu_read_lock();
-		memcg = READ_ONCE(stock->cached);
-		if (memcg && READ_ONCE(stock->nr_pages) &&
-		    mem_cgroup_is_descendant(memcg, root_memcg))
-			flush = true;
-		else if (obj_stock_flush_required(stock, root_memcg))
-			flush = true;
-		rcu_read_unlock();
+		bool flush = is_drain_needed(stock, root_memcg);
 
 		if (flush &&
 		    !test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags)) {
@@ -1969,7 +2037,7 @@ static int memcg_hotplug_cpu_dead(unsign
 	drain_obj_stock(stock);
 	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
 
-	drain_stock(stock);
+	drain_stock_fully(stock);
 
 	return 0;
 }
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-introduce-non-blocking-limit-setting-option.patch
memcg-introduce-non-blocking-limit-setting-option-v3.patch
memcg-simplify-consume_stock.patch
memcg-separate-local_trylock-for-memcg-and-obj.patch
memcg-completely-decouple-memcg-and-obj-stocks.patch
memcg-no-irq-disable-for-memcg-stock-lock.patch

