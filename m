Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F4329A5
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 00:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743987022; cv=none; b=egHAR55C6B+2HVpoIBJYS4tGVBT0dReU8sx9vod6mcn9RdZk/r9obSG3IzfY0NRmW3S040uAzgRy1dO/Os4LlD2WRJwTaXVOi6Bq0TWvwRhQsqqO4B96I08GjF9UAUJp3jzmiMFO2NYsObvcqX/jVEoCAfWq1fA2T/fPTJ0im5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743987022; c=relaxed/simple;
	bh=HCEV5B/Y2R9DG5rtq8s7wniYIoT/TIyli7Q6FTYW8eI=;
	h=Date:To:From:Subject:Message-Id; b=CkWZbX6Em5WIG2j6/AGtrNxFSGlS42SST6GMXuqqw92Jddj9o3GPlyiZERReFim/syc6UWr0NKI9q+YqE5Tsw5Tft69vZBWG7tpmmxLDT3ix6dOLoxeUMncNoj9brlAolidywJbPE/DqGk6zZgA5sPBCGOEHQmlrNugwNU6ZhBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rC6LBbcd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rC6LBbcd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574C7C4CEE3;
	Mon,  7 Apr 2025 00:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743987021;
	bh=HCEV5B/Y2R9DG5rtq8s7wniYIoT/TIyli7Q6FTYW8eI=;
	h=Date:To:From:Subject:From;
	b=rC6LBbcdT6ABNMxpwiiRCedRIPNjunjsjLCl5vD7sG4USpTe0ZDDeFG74m180uHqY
	 X3c0gSvWSkRHHlEAWPW32Zoftw11k/eD4xoauiOGWJ8Izrb46dQMyZyEsEI6HSE5dO
	 brgFEhny7ISpxsRQDoIko7JOmkImrT1VXQtFG3IE=
Date: Sun, 06 Apr 2025 17:50:20 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,bigeasy@linutronix.de,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-do-obj_cgroup_put-inside-drain_obj_stock.patch added to mm-new branch
Message-Id: <20250407005021.574C7C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: do obj_cgroup_put inside drain_obj_stock
has been added to the -mm mm-new branch.  Its filename is
     memcg-do-obj_cgroup_put-inside-drain_obj_stock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-do-obj_cgroup_put-inside-drain_obj_stock.patch

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
Subject: memcg: do obj_cgroup_put inside drain_obj_stock
Date: Thu, 3 Apr 2025 18:39:10 -0700

Previously we could not call obj_cgroup_put() inside the local lock
because on the put on the last reference, the release function
obj_cgroup_release() may try to re-acquire the local lock.  However that
chain has been broken.  Now simply do obj_cgroup_put() inside
drain_obj_stock() instead of returning the old objcg.

Link: https://lkml.kernel.org/r/20250404013913.1663035-7-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   37 +++++++++++--------------------------
 1 file changed, 11 insertions(+), 26 deletions(-)

--- a/mm/memcontrol.c~memcg-do-obj_cgroup_put-inside-drain_obj_stock
+++ a/mm/memcontrol.c
@@ -1785,7 +1785,7 @@ static DEFINE_PER_CPU(struct memcg_stock
 };
 static DEFINE_MUTEX(percpu_charge_mutex);
 
-static struct obj_cgroup *drain_obj_stock(struct memcg_stock_pcp *stock);
+static void drain_obj_stock(struct memcg_stock_pcp *stock);
 static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
 				     struct mem_cgroup *root_memcg);
 
@@ -1859,7 +1859,6 @@ static void drain_stock(struct memcg_sto
 static void drain_local_stock(struct work_struct *dummy)
 {
 	struct memcg_stock_pcp *stock;
-	struct obj_cgroup *old = NULL;
 	unsigned long flags;
 
 	/*
@@ -1870,12 +1869,11 @@ static void drain_local_stock(struct wor
 	local_lock_irqsave(&memcg_stock.stock_lock, flags);
 
 	stock = this_cpu_ptr(&memcg_stock);
-	old = drain_obj_stock(stock);
+	drain_obj_stock(stock);
 	drain_stock(stock);
 	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
 
 	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
-	obj_cgroup_put(old);
 }
 
 static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
@@ -1958,18 +1956,16 @@ void drain_all_stock(struct mem_cgroup *
 static int memcg_hotplug_cpu_dead(unsigned int cpu)
 {
 	struct memcg_stock_pcp *stock;
-	struct obj_cgroup *old;
 	unsigned long flags;
 
 	stock = &per_cpu(memcg_stock, cpu);
 
 	/* drain_obj_stock requires stock_lock */
 	local_lock_irqsave(&memcg_stock.stock_lock, flags);
-	old = drain_obj_stock(stock);
+	drain_obj_stock(stock);
 	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
 
 	drain_stock(stock);
-	obj_cgroup_put(old);
 
 	return 0;
 }
@@ -2766,24 +2762,20 @@ void __memcg_kmem_uncharge_page(struct p
 }
 
 /* Replace the stock objcg with objcg, return the old objcg */
-static struct obj_cgroup *replace_stock_objcg(struct memcg_stock_pcp *stock,
-					     struct obj_cgroup *objcg)
+static void replace_stock_objcg(struct memcg_stock_pcp *stock,
+				struct obj_cgroup *objcg)
 {
-	struct obj_cgroup *old = NULL;
-
-	old = drain_obj_stock(stock);
+	drain_obj_stock(stock);
 	obj_cgroup_get(objcg);
 	stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
 			? atomic_xchg(&objcg->nr_charged_bytes, 0) : 0;
 	WRITE_ONCE(stock->cached_objcg, objcg);
-	return old;
 }
 
 static void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
 		     enum node_stat_item idx, int nr)
 {
 	struct memcg_stock_pcp *stock;
-	struct obj_cgroup *old = NULL;
 	unsigned long flags;
 	int *bytes;
 
@@ -2796,7 +2788,7 @@ static void mod_objcg_state(struct obj_c
 	 * changes.
 	 */
 	if (READ_ONCE(stock->cached_objcg) != objcg) {
-		old = replace_stock_objcg(stock, objcg);
+		replace_stock_objcg(stock, objcg);
 		stock->cached_pgdat = pgdat;
 	} else if (stock->cached_pgdat != pgdat) {
 		/* Flush the existing cached vmstat data */
@@ -2837,7 +2829,6 @@ static void mod_objcg_state(struct obj_c
 		__mod_objcg_mlstate(objcg, pgdat, idx, nr);
 
 	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
-	obj_cgroup_put(old);
 }
 
 static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
@@ -2859,12 +2850,12 @@ static bool consume_obj_stock(struct obj
 	return ret;
 }
 
-static struct obj_cgroup *drain_obj_stock(struct memcg_stock_pcp *stock)
+static void drain_obj_stock(struct memcg_stock_pcp *stock)
 {
 	struct obj_cgroup *old = READ_ONCE(stock->cached_objcg);
 
 	if (!old)
-		return NULL;
+		return;
 
 	if (stock->nr_bytes) {
 		unsigned int nr_pages = stock->nr_bytes >> PAGE_SHIFT;
@@ -2917,11 +2908,7 @@ static struct obj_cgroup *drain_obj_stoc
 	}
 
 	WRITE_ONCE(stock->cached_objcg, NULL);
-	/*
-	 * The `old' objects needs to be released by the caller via
-	 * obj_cgroup_put() outside of memcg_stock_pcp::stock_lock.
-	 */
-	return old;
+	obj_cgroup_put(old);
 }
 
 static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
@@ -2943,7 +2930,6 @@ static void refill_obj_stock(struct obj_
 			     bool allow_uncharge)
 {
 	struct memcg_stock_pcp *stock;
-	struct obj_cgroup *old = NULL;
 	unsigned long flags;
 	unsigned int nr_pages = 0;
 
@@ -2951,7 +2937,7 @@ static void refill_obj_stock(struct obj_
 
 	stock = this_cpu_ptr(&memcg_stock);
 	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
-		old = replace_stock_objcg(stock, objcg);
+		replace_stock_objcg(stock, objcg);
 		allow_uncharge = true;	/* Allow uncharge when objcg changes */
 	}
 	stock->nr_bytes += nr_bytes;
@@ -2962,7 +2948,6 @@ static void refill_obj_stock(struct obj_
 	}
 
 	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
-	obj_cgroup_put(old);
 
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

