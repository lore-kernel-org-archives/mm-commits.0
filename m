From: akpm@linux-foundation.org
Subject: + mm-memcontrol-use-root_mem_cgroup-res_counter.patch added to
 -mm tree
Date: Wed, 18 Jun 2014 16:54:53 -0700
Message-ID: <53a226cd.Yq9NEl9Uvl1HYPI8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43348 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530AbaFRXyy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jun 2014 19:54:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vdavydov@parallels.com, tj@kernel.org, mhocko@suse.com, hughd@google.com, hannes@cmpxchg.org


The patch titled
     Subject: mm: memcontrol: use root_mem_cgroup res_counter
has been added to the -mm tree.  Its filename is
     mm-memcontrol-use-root_mem_cgroup-res_counter.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-use-root_mem_cgroup-res_counter.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-use-root_mem_cgroup-res_counter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: use root_mem_cgroup res_counter

Due to an old optimization to keep expensive res_counter changes at a
minimum, the root_mem_cgroup res_counter is never charged; there is no
limit at that level anyway, and any statistics can be generated on demand
by summing up the counters of all other cgroups.

However, with per-cpu charge caches, res_counter operations do not even
show up in profiles anymore, so this optimization is no longer necessary.

Remove it to simplify the code.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  152 +++++++++++++---------------------------------
 1 file changed, 44 insertions(+), 108 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-use-root_mem_cgroup-res_counter mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-use-root_mem_cgroup-res_counter
+++ a/mm/memcontrol.c
@@ -2570,9 +2570,8 @@ static int mem_cgroup_try_charge(struct
 	unsigned long nr_reclaimed;
 	unsigned long flags = 0;
 	unsigned long long size;
+	int ret = 0;
 
-	if (mem_cgroup_is_root(memcg))
-		goto done;
 retry:
 	if (consume_stock(memcg, nr_pages))
 		goto done;
@@ -2650,13 +2649,15 @@ nomem:
 	if (!(gfp_mask & __GFP_NOFAIL))
 		return -ENOMEM;
 bypass:
-	return -EINTR;
+	memcg = root_mem_cgroup;
+	ret = -EINTR;
+	goto retry;
 
 done_restock:
 	if (batch > nr_pages)
 		refill_stock(memcg, batch - nr_pages);
 done:
-	return 0;
+	return ret;
 }
 
 /**
@@ -2695,13 +2696,11 @@ static struct mem_cgroup *mem_cgroup_try
 static void __mem_cgroup_cancel_charge(struct mem_cgroup *memcg,
 				       unsigned int nr_pages)
 {
-	if (!mem_cgroup_is_root(memcg)) {
-		unsigned long bytes = nr_pages * PAGE_SIZE;
+	unsigned long bytes = nr_pages * PAGE_SIZE;
 
-		res_counter_uncharge(&memcg->res, bytes);
-		if (do_swap_account)
-			res_counter_uncharge(&memcg->memsw, bytes);
-	}
+	res_counter_uncharge(&memcg->res, bytes);
+	if (do_swap_account)
+		res_counter_uncharge(&memcg->memsw, bytes);
 }
 
 /*
@@ -2713,9 +2712,6 @@ static void __mem_cgroup_cancel_local_ch
 {
 	unsigned long bytes = nr_pages * PAGE_SIZE;
 
-	if (mem_cgroup_is_root(memcg))
-		return;
-
 	res_counter_uncharge_until(&memcg->res, memcg->res.parent, bytes);
 	if (do_swap_account)
 		res_counter_uncharge_until(&memcg->memsw,
@@ -3994,7 +3990,7 @@ __mem_cgroup_uncharge_common(struct page
 	 * replacement page, so leave it alone when phasing out the
 	 * page that is unused after the migration.
 	 */
-	if (!end_migration && !mem_cgroup_is_root(memcg))
+	if (!end_migration)
 		mem_cgroup_do_uncharge(memcg, nr_pages, ctype);
 
 	return memcg;
@@ -4127,8 +4123,7 @@ void mem_cgroup_uncharge_swap(swp_entry_
 		 * We uncharge this because swap is freed.  This memcg can
 		 * be obsolete one. We avoid calling css_tryget_online().
 		 */
-		if (!mem_cgroup_is_root(memcg))
-			res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
+		res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
 		mem_cgroup_swap_statistics(memcg, false);
 		css_put(&memcg->css);
 	}
@@ -4818,78 +4813,24 @@ out:
 	return retval;
 }
 
-
-static unsigned long mem_cgroup_recursive_stat(struct mem_cgroup *memcg,
-					       enum mem_cgroup_stat_index idx)
-{
-	struct mem_cgroup *iter;
-	long val = 0;
-
-	/* Per-cpu values can be negative, use a signed accumulator */
-	for_each_mem_cgroup_tree(iter, memcg)
-		val += mem_cgroup_read_stat(iter, idx);
-
-	if (val < 0) /* race ? */
-		val = 0;
-	return val;
-}
-
-static inline u64 mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
-{
-	u64 val;
-
-	if (!mem_cgroup_is_root(memcg)) {
-		if (!swap)
-			return res_counter_read_u64(&memcg->res, RES_USAGE);
-		else
-			return res_counter_read_u64(&memcg->memsw, RES_USAGE);
-	}
-
-	/*
-	 * Transparent hugepages are still accounted for in MEM_CGROUP_STAT_RSS
-	 * as well as in MEM_CGROUP_STAT_RSS_HUGE.
-	 */
-	val = mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_CACHE);
-	val += mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_RSS);
-
-	if (swap)
-		val += mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_SWAP);
-
-	return val << PAGE_SHIFT;
-}
-
 static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
-				   struct cftype *cft)
+			       struct cftype *cft)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
-	u64 val;
-	int name;
-	enum res_type type;
-
-	type = MEMFILE_TYPE(cft->private);
-	name = MEMFILE_ATTR(cft->private);
+	enum res_type type = MEMFILE_TYPE(cft->private);
+	int name = MEMFILE_ATTR(cft->private);
 
 	switch (type) {
 	case _MEM:
-		if (name == RES_USAGE)
-			val = mem_cgroup_usage(memcg, false);
-		else
-			val = res_counter_read_u64(&memcg->res, name);
-		break;
+		return res_counter_read_u64(&memcg->res, name);
 	case _MEMSWAP:
-		if (name == RES_USAGE)
-			val = mem_cgroup_usage(memcg, true);
-		else
-			val = res_counter_read_u64(&memcg->memsw, name);
-		break;
+		return res_counter_read_u64(&memcg->memsw, name);
 	case _KMEM:
-		val = res_counter_read_u64(&memcg->kmem, name);
+		return res_counter_read_u64(&memcg->kmem, name);
 		break;
 	default:
 		BUG();
 	}
-
-	return val;
 }
 
 #ifdef CONFIG_MEMCG_KMEM
@@ -5351,7 +5292,10 @@ static void __mem_cgroup_threshold(struc
 	if (!t)
 		goto unlock;
 
-	usage = mem_cgroup_usage(memcg, swap);
+	if (!swap)
+		usage = res_counter_read_u64(&memcg->res, RES_USAGE);
+	else
+		usage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
 
 	/*
 	 * current_threshold points to threshold just below or equal to usage.
@@ -5443,15 +5387,15 @@ static int __mem_cgroup_usage_register_e
 
 	mutex_lock(&memcg->thresholds_lock);
 
-	if (type == _MEM)
+	if (type == _MEM) {
 		thresholds = &memcg->thresholds;
-	else if (type == _MEMSWAP)
+		usage = res_counter_read_u64(&memcg->res, RES_USAGE);
+	} else if (type == _MEMSWAP) {
 		thresholds = &memcg->memsw_thresholds;
-	else
+		usage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
+	} else
 		BUG();
 
-	usage = mem_cgroup_usage(memcg, type == _MEMSWAP);
-
 	/* Check if a threshold crossed before adding a new one */
 	if (thresholds->primary)
 		__mem_cgroup_threshold(memcg, type == _MEMSWAP);
@@ -5531,18 +5475,19 @@ static void __mem_cgroup_usage_unregiste
 	int i, j, size;
 
 	mutex_lock(&memcg->thresholds_lock);
-	if (type == _MEM)
+
+	if (type == _MEM) {
 		thresholds = &memcg->thresholds;
-	else if (type == _MEMSWAP)
+		usage = res_counter_read_u64(&memcg->res, RES_USAGE);
+	} else if (type == _MEMSWAP) {
 		thresholds = &memcg->memsw_thresholds;
-	else
+		usage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
+	} else
 		BUG();
 
 	if (!thresholds->primary)
 		goto unlock;
 
-	usage = mem_cgroup_usage(memcg, type == _MEMSWAP);
-
 	/* Check if a threshold crossed before removing */
 	__mem_cgroup_threshold(memcg, type == _MEMSWAP);
 
@@ -6297,9 +6242,9 @@ mem_cgroup_css_online(struct cgroup_subs
 		 * core guarantees its existence.
 		 */
 	} else {
-		res_counter_init(&memcg->res, NULL);
-		res_counter_init(&memcg->memsw, NULL);
-		res_counter_init(&memcg->kmem, NULL);
+		res_counter_init(&memcg->res, &root_mem_cgroup->res);
+		res_counter_init(&memcg->memsw, &root_mem_cgroup->memsw);
+		res_counter_init(&memcg->kmem, &root_mem_cgroup->kmem);
 		/*
 		 * Deeper hierachy with use_hierarchy == false doesn't make
 		 * much sense so let cgroup subsystem know about this
@@ -6412,13 +6357,7 @@ static void mem_cgroup_css_free(struct c
 /* Handlers for move charge at task migration. */
 static int mem_cgroup_do_precharge(unsigned long count)
 {
-	int ret = 0;
-
-	if (mem_cgroup_is_root(mc.to)) {
-		mc.precharge += count;
-		/* we don't need css_get for root */
-		return ret;
-	}
+	int ret;
 
 	/* Try a single bulk charge without reclaim first */
 	ret = mem_cgroup_try_charge(mc.to, GFP_KERNEL & ~__GFP_WAIT, count);
@@ -6725,21 +6664,18 @@ static void __mem_cgroup_clear_mc(void)
 	/* we must fixup refcnts and charges */
 	if (mc.moved_swap) {
 		/* uncharge swap account from the old cgroup */
-		if (!mem_cgroup_is_root(mc.from))
-			res_counter_uncharge(&mc.from->memsw,
-						PAGE_SIZE * mc.moved_swap);
+		res_counter_uncharge(&mc.from->memsw,
+				     PAGE_SIZE * mc.moved_swap);
 
 		for (i = 0; i < mc.moved_swap; i++)
 			css_put(&mc.from->css);
 
-		if (!mem_cgroup_is_root(mc.to)) {
-			/*
-			 * we charged both to->res and to->memsw, so we should
-			 * uncharge to->res.
-			 */
-			res_counter_uncharge(&mc.to->res,
-						PAGE_SIZE * mc.moved_swap);
-		}
+		/*
+		 * we charged both to->res and to->memsw, so we should
+		 * uncharge to->res.
+		 */
+		res_counter_uncharge(&mc.to->res,
+				     PAGE_SIZE * mc.moved_swap);
 		/* we've already done css_get(mc.to) */
 		mc.moved_swap = 0;
 	}
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
mm-memcontrol-fold-mem_cgroup_do_charge.patch
mm-memcontrol-rearrange-charging-fast-path.patch
mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry.patch
mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch
mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch
mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch
mm-memcontrol-simplify-move-precharge-function.patch
mm-memcontrol-catch-root-bypass-in-move-precharge.patch
mm-memcontrol-use-root_mem_cgroup-res_counter.patch
mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused.patch
mm-memcontrol-do-not-acquire-page_cgroup-lock-for-kmem-pages.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-uncharge-api.patch
memcg-deprecate-memoryforce_empty-knob.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch

