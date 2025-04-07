Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A4A29A5
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 00:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743987026; cv=none; b=FSY1n9fBqzrGkglYpL62bM7es9Df/ZnuM1e8EH1+tPuftuOZDlkUIQBGV5ebqFdK0NL9xdV+suA0EjbDtcvbZWzSLLDJwgcpMAj3tzmFNc5hdVc0YBlcAn6/roaNo7foczaS37Elml1Q5zHGx346Q2B8x14mLgmGCglkZ5bPVro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743987026; c=relaxed/simple;
	bh=aa0ci38tUTj21iggbmKRIWid0J+N5MHU1Con86xdxCk=;
	h=Date:To:From:Subject:Message-Id; b=T2l+B0Y7Fhq10bPGZXNF3JAtKAfrceqlfzsPG6b4K6riW4th+jfAswM4D/L/wsbI8Tq9boQyxTqiGYffRFrRVAVW4CjfGPqGGh2tJdLdmXiNgGxU/tI8IpVAgEwBQC39A1jdI8fM4RFpeFh6wwYkH2ti/6hFEtSO/eY5D9Kap18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZG+xVP5b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZG+xVP5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89244C4CEE3;
	Mon,  7 Apr 2025 00:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743987025;
	bh=aa0ci38tUTj21iggbmKRIWid0J+N5MHU1Con86xdxCk=;
	h=Date:To:From:Subject:From;
	b=ZG+xVP5bfwiZaFqB+4ysJS1B5i9T9q3us5V1pKxGXtcZdpe4KrkRv+B3io5WXtnqN
	 QynQtR0D+z9jzbfRA4JxpKT2SfThAzH6NckwZ2txGkxWoO/eXDLP2f3Gruygd5THS0
	 YSVpGVRmGXzqCWhKhebLKV7y96JyedJx102gLdvY=
Date: Sun, 06 Apr 2025 17:50:24 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,bigeasy@linutronix.de,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-combine-slab-obj-stock-charging-and-accounting.patch added to mm-new branch
Message-Id: <20250407005025.89244C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: combine slab obj stock charging and accounting
has been added to the -mm mm-new branch.  Its filename is
     memcg-combine-slab-obj-stock-charging-and-accounting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-combine-slab-obj-stock-charging-and-accounting.patch

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
From: Vlastimil Babka <vbabka@suse.cz>
Subject: memcg: combine slab obj stock charging and accounting
Date: Thu, 3 Apr 2025 18:39:12 -0700

When handing slab objects, we use obj_cgroup_[un]charge() for (un)charging
and mod_objcg_state() to account NR_SLAB_[UN]RECLAIMABLE_B.  All these
operations use the percpu stock for performance.  However with the calls
being separate, the stock_lock is taken twice in each case.

By refactoring the code, we can turn mod_objcg_state() into
__account_obj_stock() which is called on a stock that's already locked and
validated.  On the charging side we can call this function from
consume_obj_stock() when it succeeds, and refill_obj_stock() in the
fallback.  We just expand parameters of these functions as necessary.  The
uncharge side from __memcg_slab_free_hook() is just the call to
refill_obj_stock().

Other callers of obj_cgroup_[un]charge() (i.e.  not slab) simply pass the
extra parameters as NULL/zeroes to skip the __account_obj_stock()
operation.

In __memcg_slab_post_alloc_hook() we now charge each object separately,
but that's not a problem as we did call mod_objcg_state() for each object
separately, and most allocations are non-bulk anyway.  This could be
improved by batching all operations until slab_pgdat(slab) changes.

Some preliminary benchmarking with a kfree(kmalloc()) loop of 10M
iterations with/without __GFP_ACCOUNT:

Before the patch:
kmalloc/kfree !memcg:    581390144 cycles
kmalloc/kfree memcg:     783689984 cycles

After the patch:
kmalloc/kfree memcg:     658723808 cycles

More than half of the overhead of __GFP_ACCOUNT relative to
non-accounted case seems eliminated.

Link: https://lkml.kernel.org/r/20250404013913.1663035-9-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   77 +++++++++++++++++++++++++++-------------------
 1 file changed, 46 insertions(+), 31 deletions(-)

--- a/mm/memcontrol.c~memcg-combine-slab-obj-stock-charging-and-accounting
+++ a/mm/memcontrol.c
@@ -2774,25 +2774,17 @@ static void replace_stock_objcg(struct m
 	WRITE_ONCE(stock->cached_objcg, objcg);
 }
 
-static void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
-		     enum node_stat_item idx, int nr)
+static void __account_obj_stock(struct obj_cgroup *objcg,
+				struct memcg_stock_pcp *stock, int nr,
+				struct pglist_data *pgdat, enum node_stat_item idx)
 {
-	struct memcg_stock_pcp *stock;
-	unsigned long flags;
 	int *bytes;
 
-	local_lock_irqsave(&memcg_stock.stock_lock, flags);
-	stock = this_cpu_ptr(&memcg_stock);
-
 	/*
 	 * Save vmstat data in stock and skip vmstat array update unless
-	 * accumulating over a page of vmstat data or when pgdat or idx
-	 * changes.
+	 * accumulating over a page of vmstat data or when pgdat changes.
 	 */
-	if (READ_ONCE(stock->cached_objcg) != objcg) {
-		replace_stock_objcg(stock, objcg);
-		stock->cached_pgdat = pgdat;
-	} else if (stock->cached_pgdat != pgdat) {
+	if (stock->cached_pgdat != pgdat) {
 		/* Flush the existing cached vmstat data */
 		struct pglist_data *oldpg = stock->cached_pgdat;
 
@@ -2829,11 +2821,10 @@ static void mod_objcg_state(struct obj_c
 	}
 	if (nr)
 		__mod_objcg_mlstate(objcg, pgdat, idx, nr);
-
-	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
 }
 
-static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
+static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
+			      struct pglist_data *pgdat, enum node_stat_item idx)
 {
 	struct memcg_stock_pcp *stock;
 	unsigned long flags;
@@ -2845,6 +2836,9 @@ static bool consume_obj_stock(struct obj
 	if (objcg == READ_ONCE(stock->cached_objcg) && stock->nr_bytes >= nr_bytes) {
 		stock->nr_bytes -= nr_bytes;
 		ret = true;
+
+		if (pgdat)
+			__account_obj_stock(objcg, stock, nr_bytes, pgdat, idx);
 	}
 
 	local_unlock_irqrestore(&memcg_stock.stock_lock, flags);
@@ -2929,7 +2923,8 @@ static bool obj_stock_flush_required(str
 }
 
 static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
-			     bool allow_uncharge)
+		bool allow_uncharge, int nr_acct, struct pglist_data *pgdat,
+		enum node_stat_item idx)
 {
 	struct memcg_stock_pcp *stock;
 	unsigned long flags;
@@ -2944,6 +2939,9 @@ static void refill_obj_stock(struct obj_
 	}
 	stock->nr_bytes += nr_bytes;
 
+	if (pgdat)
+		__account_obj_stock(objcg, stock, nr_acct, pgdat, idx);
+
 	if (allow_uncharge && (stock->nr_bytes > PAGE_SIZE)) {
 		nr_pages = stock->nr_bytes >> PAGE_SHIFT;
 		stock->nr_bytes &= (PAGE_SIZE - 1);
@@ -2955,12 +2953,13 @@ static void refill_obj_stock(struct obj_
 		obj_cgroup_uncharge_pages(objcg, nr_pages);
 }
 
-int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size)
+static int obj_cgroup_charge_account(struct obj_cgroup *objcg, gfp_t gfp, size_t size,
+				     struct pglist_data *pgdat, enum node_stat_item idx)
 {
 	unsigned int nr_pages, nr_bytes;
 	int ret;
 
-	if (consume_obj_stock(objcg, size))
+	if (likely(consume_obj_stock(objcg, size, pgdat, idx)))
 		return 0;
 
 	/*
@@ -2993,15 +2992,21 @@ int obj_cgroup_charge(struct obj_cgroup
 		nr_pages += 1;
 
 	ret = obj_cgroup_charge_pages(objcg, gfp, nr_pages);
-	if (!ret && nr_bytes)
-		refill_obj_stock(objcg, PAGE_SIZE - nr_bytes, false);
+	if (!ret && (nr_bytes || pgdat))
+		refill_obj_stock(objcg, nr_bytes ? PAGE_SIZE - nr_bytes : 0,
+					 false, size, pgdat, idx);
 
 	return ret;
 }
 
+int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size)
+{
+	return obj_cgroup_charge_account(objcg, gfp, size, NULL, 0);
+}
+
 void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size)
 {
-	refill_obj_stock(objcg, size, true);
+	refill_obj_stock(objcg, size, true, 0, NULL, 0);
 }
 
 static inline size_t obj_full_size(struct kmem_cache *s)
@@ -3053,23 +3058,32 @@ bool __memcg_slab_post_alloc_hook(struct
 			return false;
 	}
 
-	if (obj_cgroup_charge(objcg, flags, size * obj_full_size(s)))
-		return false;
-
 	for (i = 0; i < size; i++) {
 		slab = virt_to_slab(p[i]);
 
 		if (!slab_obj_exts(slab) &&
 		    alloc_slab_obj_exts(slab, s, flags, false)) {
-			obj_cgroup_uncharge(objcg, obj_full_size(s));
 			continue;
 		}
 
+		/*
+		 * if we fail and size is 1, memcg_alloc_abort_single() will
+		 * just free the object, which is ok as we have not assigned
+		 * objcg to its obj_ext yet
+		 *
+		 * for larger sizes, kmem_cache_free_bulk() will uncharge
+		 * any objects that were already charged and obj_ext assigned
+		 *
+		 * TODO: we could batch this until slab_pgdat(slab) changes
+		 * between iterations, with a more complicated undo
+		 */
+		if (obj_cgroup_charge_account(objcg, flags, obj_full_size(s),
+					slab_pgdat(slab), cache_vmstat_idx(s)))
+			return false;
+
 		off = obj_to_index(s, slab, p[i]);
 		obj_cgroup_get(objcg);
 		slab_obj_exts(slab)[off].objcg = objcg;
-		mod_objcg_state(objcg, slab_pgdat(slab),
-				cache_vmstat_idx(s), obj_full_size(s));
 	}
 
 	return true;
@@ -3078,6 +3092,8 @@ bool __memcg_slab_post_alloc_hook(struct
 void __memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab,
 			    void **p, int objects, struct slabobj_ext *obj_exts)
 {
+	size_t obj_size = obj_full_size(s);
+
 	for (int i = 0; i < objects; i++) {
 		struct obj_cgroup *objcg;
 		unsigned int off;
@@ -3088,9 +3104,8 @@ void __memcg_slab_free_hook(struct kmem_
 			continue;
 
 		obj_exts[off].objcg = NULL;
-		obj_cgroup_uncharge(objcg, obj_full_size(s));
-		mod_objcg_state(objcg, slab_pgdat(slab), cache_vmstat_idx(s),
-				-obj_full_size(s));
+		refill_obj_stock(objcg, obj_size, true, -obj_size,
+				 slab_pgdat(slab), cache_vmstat_idx(s));
 		obj_cgroup_put(objcg);
 	}
 }
_

Patches currently in -mm which might be from vbabka@suse.cz are

memcg-combine-slab-obj-stock-charging-and-accounting.patch

