Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF41197A8A
	for <mm-commits@vger.kernel.org>; Wed, 16 Apr 2025 21:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744839576; cv=none; b=C+iZp7JWzje7FQ5f+cqhW9aKnBH5E6ezXkupcZkGtEXCHA1odbEexxoDyQQG6KY7n9Hk3E2k0YVRHjK1aIJ6kHQhjGx5ifF5yYusR83wMnSBgDu1kJ7nzcfysDKEUVNQeOopFVxbJdqHJGkN5anGsYzNTFPZ4QpXQJd27eD0wRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744839576; c=relaxed/simple;
	bh=CsngFTkB5TS+gwag39hNqlR1TsxYgOua16e2/ELPKM4=;
	h=Date:To:From:Subject:Message-Id; b=G/dF2HmysHU2fPbVVXhg1HTEyDblGszFVcHuGDiJUp5lBuiiO8mYnoRiCd82iCftRPtYltLoaTxmOJc7s20HTf5klNCuMRemzsAy2xAhU1K1HTui/c0MfcTDOqI6S7vf7ReH9OT6loOe32uhgGZvI7m+hQgBQLWAISbFjr2LwzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JO4dYGsp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JO4dYGsp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B725AC4CEE2;
	Wed, 16 Apr 2025 21:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744839575;
	bh=CsngFTkB5TS+gwag39hNqlR1TsxYgOua16e2/ELPKM4=;
	h=Date:To:From:Subject:From;
	b=JO4dYGspWeR03DeJVm+0c7jY2LLf7HpC5aFRKBjjnZCsb94gGgXH+fsrsIBuE8GNN
	 bUGZQKyu3BMgR6KcaSbiVc/ICjF+VVjos+U5KD4VjuzUqDMPK5mpD28eU3L7WiWfEC
	 J9UpVu6RXTDNUZ5j4tqwNIbB9JyTw+POVM2Q+kL0=
Date: Wed, 16 Apr 2025 14:39:35 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,soheil@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,kuba@kernel.org,hannes@cmpxchg.org,edumazet@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-multi-memcg-percpu-charge-cache.patch added to mm-new branch
Message-Id: <20250416213935.B725AC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: multi-memcg percpu charge cache
has been added to the -mm mm-new branch.  Its filename is
     memcg-multi-memcg-percpu-charge-cache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-multi-memcg-percpu-charge-cache.patch

This patch will later appear in the mm-new branch at
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

Link: https://lkml.kernel.org/r/20250416180229.2902751-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Eric Dumaze <edumazet@google.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  128 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 91 insertions(+), 37 deletions(-)

--- a/mm/memcontrol.c~memcg-multi-memcg-percpu-charge-cache
+++ a/mm/memcontrol.c
@@ -1771,10 +1771,11 @@ void mem_cgroup_print_oom_group(struct m
 	pr_cont(" are going to be killed due to memory.oom.group set\n");
 }
 
+#define NR_MEMCG_STOCK 7
 struct memcg_stock_pcp {
 	local_trylock_t stock_lock;
-	struct mem_cgroup *cached; /* this never be root cgroup */
-	unsigned int nr_pages;
+	uint8_t nr_pages[NR_MEMCG_STOCK];
+	struct mem_cgroup *cached[NR_MEMCG_STOCK];
 
 	struct obj_cgroup *cached_objcg;
 	struct pglist_data *cached_pgdat;
@@ -1811,9 +1812,10 @@ static bool consume_stock(struct mem_cgr
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
@@ -1824,10 +1826,17 @@ static bool consume_stock(struct mem_cgr
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
@@ -1845,21 +1854,30 @@ static void memcg_uncharge(struct mem_cg
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
@@ -1876,7 +1894,7 @@ static void drain_local_stock(struct wor
 
 	stock = this_cpu_ptr(&memcg_stock);
 	drain_obj_stock(stock);
-	drain_stock(stock);
+	drain_stock_fully(stock);
 	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
 
 	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
@@ -1885,35 +1903,81 @@ static void drain_local_stock(struct wor
 static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
 	struct memcg_stock_pcp *stock;
-	unsigned int stock_pages;
+	struct mem_cgroup *cached;
+	uint8_t stock_pages;
 	unsigned long flags;
+	bool evict = true;
+	int i;
 
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
+again:
+		cached = READ_ONCE(stock->cached[i]);
+		if (!cached) {
+			css_get(&memcg->css);
+			WRITE_ONCE(stock->cached[i], memcg);
+		}
+		if (!cached || memcg == READ_ONCE(stock->cached[i])) {
+			stock_pages = READ_ONCE(stock->nr_pages[i]) + nr_pages;
+			WRITE_ONCE(stock->nr_pages[i], stock_pages);
+			if (stock_pages > MEMCG_CHARGE_BATCH)
+				drain_stock(stock, i);
+			evict = false;
+			break;
+		}
 	}
-	stock_pages = READ_ONCE(stock->nr_pages) + nr_pages;
-	WRITE_ONCE(stock->nr_pages, stock_pages);
 
-	if (stock_pages > MEMCG_CHARGE_BATCH)
-		drain_stock(stock);
+	if (evict) {
+		i = get_random_u32_below(NR_MEMCG_STOCK);
+		drain_stock(stock, i);
+		goto again;
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
@@ -1935,17 +1999,7 @@ void drain_all_stock(struct mem_cgroup *
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
@@ -1971,7 +2025,7 @@ static int memcg_hotplug_cpu_dead(unsign
 	drain_obj_stock(stock);
 	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
 
-	drain_stock(stock);
+	drain_stock_fully(stock);
 
 	return 0;
 }
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-vmalloc-simplify-memcg_vmalloc-updates.patch
memcg-vmalloc-simplify-memcg_vmalloc-updates-fix.patch
memcg-remove-root-memcg-check-from-refill_stock.patch
memcg-decouple-drain_obj_stock-from-local-stock.patch
memcg-introduce-memcg_uncharge.patch
memcg-manually-inline-__refill_stock.patch
memcg-no-refilling-stock-from-obj_cgroup_release.patch
memcg-do-obj_cgroup_put-inside-drain_obj_stock.patch
memcg-use-__mod_memcg_state-in-drain_obj_stock.patch
memcg-manually-inline-replace_stock_objcg.patch
memcg-optimize-memcg_rstat_updated.patch
memcg-multi-memcg-percpu-charge-cache.patch

