Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AEF19CC0A
	for <mm-commits@vger.kernel.org>; Tue,  6 May 2025 23:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746573502; cv=none; b=YVxOylCz1EtRSBjBIyiOTCD5vtgJy2XfLQ9glL7NLB4SSU1qsV8wMtFZq4Psq91SO+jwf0AVCsN9tj+w9Vfn0lqKAICLrkr8WI+MrvJuPWb3xLH6yQnzJVR8o8CNd9m/Jy5Pal69bQdHx8T8bGC32dbodiWdAa5z025mkKqEeN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746573502; c=relaxed/simple;
	bh=GtJMnXGqQ0FFhj19wn4N/PeMMkvVP4P05AejlDvTdTQ=;
	h=Date:To:From:Subject:Message-Id; b=i4+GAW+egMOiowWxA9G2ceACWH18vCbyDeNxcWLKvQvN04J5J0Hl4lOQs+T+T0DR/v8I0dSLqOGSTe3Fw7vegVYPjs8HvjWMUya8fxxp7C7MhpMmuhXvRYY0NGW7gWLZI5G4GIzl2Lt25YB5eQk765gFSgCtkv1oBGsEnCvJn0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EHeHbaVc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EHeHbaVc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD45AC4CEEE;
	Tue,  6 May 2025 23:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746573501;
	bh=GtJMnXGqQ0FFhj19wn4N/PeMMkvVP4P05AejlDvTdTQ=;
	h=Date:To:From:Subject:From;
	b=EHeHbaVcSkc6OrNSB6UIqllu8Cp4pUf5rOLIHMGa9wksT773HrdvjNPvb7we7a1CJ
	 eq7oJckS1YiGAhezocQcQEOt/IeHhHwSPTK65wq3C2RiDnU5FBDTybhjqKSlsN9GmU
	 +Oj9UbneDFDetVORSJ2oP18gTRGxtuzgr8heWzJQ=
Date: Tue, 06 May 2025 16:18:21 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,kuba@kernel.org,hannes@cmpxchg.org,edumazet@google.com,bigeasy@linutronix.de,ast@kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-separate-local_trylock-for-memcg-and-obj.patch added to mm-new branch
Message-Id: <20250506231821.BD45AC4CEEE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: separate local_trylock for memcg and obj
has been added to the -mm mm-new branch.  Its filename is
     memcg-separate-local_trylock-for-memcg-and-obj.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-separate-local_trylock-for-memcg-and-obj.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: memcg: separate local_trylock for memcg and obj
Date: Tue, 6 May 2025 15:55:31 -0700

The per-cpu stock_lock protects cached memcg and cached objcg and their
respective fields.  However there is no dependency between these fields
and it is better to have fine grained separate locks for cached memcg and
cached objcg.  This decoupling of locks allows us to make the memcg charge
cache and objcg charge cache to be nmi safe independently.

At the moment, memcg charge cache is already nmi safe and this decoupling
will allow to make memcg charge cache work without disabling irqs.

Link: https://lkml.kernel.org/r/20250506225533.2580386-3-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Eric Dumaze <edumazet@google.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   49 ++++++++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 23 deletions(-)

--- a/mm/memcontrol.c~memcg-separate-local_trylock-for-memcg-and-obj
+++ a/mm/memcontrol.c
@@ -1804,13 +1804,14 @@ void mem_cgroup_print_oom_group(struct m
  */
 #define NR_MEMCG_STOCK 7
 struct memcg_stock_pcp {
-	local_trylock_t stock_lock;
+	local_trylock_t memcg_lock;
 	uint8_t nr_pages[NR_MEMCG_STOCK];
 	struct mem_cgroup *cached[NR_MEMCG_STOCK];
 
+	local_trylock_t obj_lock;
+	unsigned int nr_bytes;
 	struct obj_cgroup *cached_objcg;
 	struct pglist_data *cached_pgdat;
-	unsigned int nr_bytes;
 	int nr_slab_reclaimable_b;
 	int nr_slab_unreclaimable_b;
 
@@ -1819,7 +1820,8 @@ struct memcg_stock_pcp {
 #define FLUSHING_CACHED_CHARGE	0
 };
 static DEFINE_PER_CPU_ALIGNED(struct memcg_stock_pcp, memcg_stock) = {
-	.stock_lock = INIT_LOCAL_TRYLOCK(stock_lock),
+	.memcg_lock = INIT_LOCAL_TRYLOCK(memcg_lock),
+	.obj_lock = INIT_LOCAL_TRYLOCK(obj_lock),
 };
 static DEFINE_MUTEX(percpu_charge_mutex);
 
@@ -1847,7 +1849,7 @@ static bool consume_stock(struct mem_cgr
 	int i;
 
 	if (nr_pages > MEMCG_CHARGE_BATCH ||
-	    !local_trylock_irqsave(&memcg_stock.stock_lock, flags))
+	    !local_trylock_irqsave(&memcg_stock.memcg_lock, flags))
 		return ret;
 
 	stock = this_cpu_ptr(&memcg_stock);
@@ -1864,7 +1866,7 @@ static bool consume_stock(struct mem_cgr
 		break;
 	}
 
-	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
+	local_unlock_irqrestore(&memcg_stock.memcg_lock, flags);
 
 	return ret;
 }
@@ -1910,19 +1912,19 @@ static void drain_local_stock(struct wor
 	struct memcg_stock_pcp *stock;
 	unsigned long flags;
 
-	/*
-	 * The only protection from cpu hotplug (memcg_hotplug_cpu_dead) vs.
-	 * drain_stock races is that we always operate on local CPU stock
-	 * here with IRQ disabled
-	 */
-	local_lock_irqsave(&memcg_stock.stock_lock, flags);
+	if (WARN_ONCE(!in_task(), "drain in non-task context"))
+		return;
 
+	local_lock_irqsave(&memcg_stock.obj_lock, flags);
 	stock = this_cpu_ptr(&memcg_stock);
 	drain_obj_stock(stock);
+	local_unlock_irqrestore(&memcg_stock.obj_lock, flags);
+
+	local_lock_irqsave(&memcg_stock.memcg_lock, flags);
+	stock = this_cpu_ptr(&memcg_stock);
 	drain_stock_fully(stock);
 	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
-
-	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
+	local_unlock_irqrestore(&memcg_stock.memcg_lock, flags);
 }
 
 static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
@@ -1945,10 +1947,10 @@ static void refill_stock(struct mem_cgro
 	VM_WARN_ON_ONCE(mem_cgroup_is_root(memcg));
 
 	if (nr_pages > MEMCG_CHARGE_BATCH ||
-	    !local_trylock_irqsave(&memcg_stock.stock_lock, flags)) {
+	    !local_trylock_irqsave(&memcg_stock.memcg_lock, flags)) {
 		/*
 		 * In case of larger than batch refill or unlikely failure to
-		 * lock the percpu stock_lock, uncharge memcg directly.
+		 * lock the percpu memcg_lock, uncharge memcg directly.
 		 */
 		memcg_uncharge(memcg, nr_pages);
 		return;
@@ -1980,7 +1982,7 @@ static void refill_stock(struct mem_cgro
 		WRITE_ONCE(stock->nr_pages[i], nr_pages);
 	}
 
-	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
+	local_unlock_irqrestore(&memcg_stock.memcg_lock, flags);
 }
 
 static bool is_drain_needed(struct memcg_stock_pcp *stock,
@@ -2055,11 +2057,12 @@ static int memcg_hotplug_cpu_dead(unsign
 
 	stock = &per_cpu(memcg_stock, cpu);
 
-	/* drain_obj_stock requires stock_lock */
-	local_lock_irqsave(&memcg_stock.stock_lock, flags);
+	/* drain_obj_stock requires obj_lock */
+	local_lock_irqsave(&memcg_stock.obj_lock, flags);
 	drain_obj_stock(stock);
-	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
+	local_unlock_irqrestore(&memcg_stock.obj_lock, flags);
 
+	/* no need for the local lock */
 	drain_stock_fully(stock);
 
 	return 0;
@@ -2912,7 +2915,7 @@ static bool consume_obj_stock(struct obj
 	unsigned long flags;
 	bool ret = false;
 
-	local_lock_irqsave(&memcg_stock.stock_lock, flags);
+	local_lock_irqsave(&memcg_stock.obj_lock, flags);
 
 	stock = this_cpu_ptr(&memcg_stock);
 	if (objcg == READ_ONCE(stock->cached_objcg) && stock->nr_bytes >= nr_bytes) {
@@ -2923,7 +2926,7 @@ static bool consume_obj_stock(struct obj
 			__account_obj_stock(objcg, stock, nr_bytes, pgdat, idx);
 	}
 
-	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
+	local_unlock_irqrestore(&memcg_stock.obj_lock, flags);
 
 	return ret;
 }
@@ -3012,7 +3015,7 @@ static void refill_obj_stock(struct obj_
 	unsigned long flags;
 	unsigned int nr_pages = 0;
 
-	local_lock_irqsave(&memcg_stock.stock_lock, flags);
+	local_lock_irqsave(&memcg_stock.obj_lock, flags);
 
 	stock = this_cpu_ptr(&memcg_stock);
 	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
@@ -3034,7 +3037,7 @@ static void refill_obj_stock(struct obj_
 		stock->nr_bytes &= (PAGE_SIZE - 1);
 	}
 
-	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
+	local_unlock_irqrestore(&memcg_stock.obj_lock, flags);
 
 	if (nr_pages)
 		obj_cgroup_uncharge_pages(objcg, nr_pages);
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
memcg-multi-memcg-percpu-charge-cache-fix.patch
memcg-multi-memcg-percpu-charge-cache-fix-2.patch
memcg-multi-memcg-percpu-charge-cache-fix-4.patch
memcg-introduce-non-blocking-limit-setting-option.patch
memcg-simplify-consume_stock.patch
memcg-separate-local_trylock-for-memcg-and-obj.patch
memcg-completely-decouple-memcg-and-obj-stocks.patch
memcg-no-irq-disable-for-memcg-stock-lock.patch

