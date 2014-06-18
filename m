From: akpm@linux-foundation.org
Subject: + mm-memcontrol-fold-mem_cgroup_do_charge.patch added to -mm tree
Date: Wed, 18 Jun 2014 16:54:45 -0700
Message-ID: <53a226c5.CRhVIrr69LqP7vY9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43302 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521AbaFRXyq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jun 2014 19:54:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vdavydov@parallels.com, tj@kernel.org, mhocko@suse.cz, hughd@google.com, hannes@cmpxchg.org


The patch titled
     Subject: mm: memcontrol: fold mem_cgroup_do_charge()
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fold-mem_cgroup_do_charge.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fold-mem_cgroup_do_charge.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fold-mem_cgroup_do_charge.patch

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
Subject: mm: memcontrol: fold mem_cgroup_do_charge()

These patches rework memcg charge lifetime to integrate more naturally
with the lifetime of user pages.  This drastically simplifies the code and
reduces charging and uncharging overhead.  The most expensive part of
charging and uncharging is the page_cgroup bit spinlock, which is removed
entirely after this series.

Here are the top-10 profile entries of a stress test that reads a 128G
sparse file on a freshly booted box, without even a dedicated cgroup (i.e.
 executing in the root memcg).  Before:

    15.36%              cat  [kernel.kallsyms]   [k] copy_user_generic_string                  
    13.31%              cat  [kernel.kallsyms]   [k] memset                                    
    11.48%              cat  [kernel.kallsyms]   [k] do_mpage_readpage                         
     4.23%              cat  [kernel.kallsyms]   [k] get_page_from_freelist                    
     2.38%              cat  [kernel.kallsyms]   [k] put_page                                  
     2.32%              cat  [kernel.kallsyms]   [k] __mem_cgroup_commit_charge                
     2.18%          kswapd0  [kernel.kallsyms]   [k] __mem_cgroup_uncharge_common              
     1.92%          kswapd0  [kernel.kallsyms]   [k] shrink_page_list                          
     1.86%              cat  [kernel.kallsyms]   [k] __radix_tree_lookup                       
     1.62%              cat  [kernel.kallsyms]   [k] __pagevec_lru_add_fn                      

After:

    15.67%           cat  [kernel.kallsyms]   [k] copy_user_generic_string                  
    13.48%           cat  [kernel.kallsyms]   [k] memset                                    
    11.42%           cat  [kernel.kallsyms]   [k] do_mpage_readpage                         
     3.98%           cat  [kernel.kallsyms]   [k] get_page_from_freelist                    
     2.46%           cat  [kernel.kallsyms]   [k] put_page                                  
     2.13%       kswapd0  [kernel.kallsyms]   [k] shrink_page_list                          
     1.88%           cat  [kernel.kallsyms]   [k] __radix_tree_lookup                       
     1.67%           cat  [kernel.kallsyms]   [k] __pagevec_lru_add_fn                      
     1.39%       kswapd0  [kernel.kallsyms]   [k] free_pcppages_bulk                        
     1.30%           cat  [kernel.kallsyms]   [k] kfree                                     

As you can see, the memcg footprint has shrunk quite a bit.

   text    data     bss     dec     hex filename
  37970    9892     400   48262    bc86 mm/memcontrol.o.old
  35239    9892     400   45531    b1db mm/memcontrol.o



This patch (of 13):

This function was split out because mem_cgroup_try_charge() got too big. 
But having essentially one sequence of operations arbitrarily split in
half is not good for reworking the code.  Fold it back in.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  168 +++++++++++++++++-----------------------------
 1 file changed, 65 insertions(+), 103 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-fold-mem_cgroup_do_charge mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-fold-mem_cgroup_do_charge
+++ a/mm/memcontrol.c
@@ -2551,80 +2551,6 @@ static int memcg_cpu_hotplug_callback(st
 	return NOTIFY_OK;
 }
 
-
-/* See mem_cgroup_try_charge() for details */
-enum {
-	CHARGE_OK,		/* success */
-	CHARGE_RETRY,		/* need to retry but retry is not bad */
-	CHARGE_NOMEM,		/* we can't do more. return -ENOMEM */
-	CHARGE_WOULDBLOCK,	/* GFP_WAIT wasn't set and no enough res. */
-};
-
-static int mem_cgroup_do_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
-				unsigned int nr_pages, unsigned int min_pages,
-				bool invoke_oom)
-{
-	unsigned long csize = nr_pages * PAGE_SIZE;
-	struct mem_cgroup *mem_over_limit;
-	struct res_counter *fail_res;
-	unsigned long flags = 0;
-	int ret;
-
-	ret = res_counter_charge(&memcg->res, csize, &fail_res);
-
-	if (likely(!ret)) {
-		if (!do_swap_account)
-			return CHARGE_OK;
-		ret = res_counter_charge(&memcg->memsw, csize, &fail_res);
-		if (likely(!ret))
-			return CHARGE_OK;
-
-		res_counter_uncharge(&memcg->res, csize);
-		mem_over_limit = mem_cgroup_from_res_counter(fail_res, memsw);
-		flags |= MEM_CGROUP_RECLAIM_NOSWAP;
-	} else
-		mem_over_limit = mem_cgroup_from_res_counter(fail_res, res);
-	/*
-	 * Never reclaim on behalf of optional batching, retry with a
-	 * single page instead.
-	 */
-	if (nr_pages > min_pages)
-		return CHARGE_RETRY;
-
-	if (!(gfp_mask & __GFP_WAIT))
-		return CHARGE_WOULDBLOCK;
-
-	if (gfp_mask & __GFP_NORETRY)
-		return CHARGE_NOMEM;
-
-	ret = mem_cgroup_reclaim(mem_over_limit, gfp_mask, flags);
-	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
-		return CHARGE_RETRY;
-	/*
-	 * Even though the limit is exceeded at this point, reclaim
-	 * may have been able to free some pages.  Retry the charge
-	 * before killing the task.
-	 *
-	 * Only for regular pages, though: huge pages are rather
-	 * unlikely to succeed so close to the limit, and we fall back
-	 * to regular pages anyway in case of failure.
-	 */
-	if (nr_pages <= (1 << PAGE_ALLOC_COSTLY_ORDER) && ret)
-		return CHARGE_RETRY;
-
-	/*
-	 * At task move, charge accounts can be doubly counted. So, it's
-	 * better to wait until the end of task_move if something is going on.
-	 */
-	if (mem_cgroup_wait_acct_move(mem_over_limit))
-		return CHARGE_RETRY;
-
-	if (invoke_oom)
-		mem_cgroup_oom(mem_over_limit, gfp_mask, get_order(csize));
-
-	return CHARGE_NOMEM;
-}
-
 /**
  * mem_cgroup_try_charge - try charging a memcg
  * @memcg: memcg to charge
@@ -2641,7 +2567,11 @@ static int mem_cgroup_try_charge(struct
 {
 	unsigned int batch = max(CHARGE_BATCH, nr_pages);
 	int nr_oom_retries = MEM_CGROUP_RECLAIM_RETRIES;
-	int ret;
+	struct mem_cgroup *mem_over_limit;
+	struct res_counter *fail_res;
+	unsigned long nr_reclaimed;
+	unsigned long flags = 0;
+	unsigned long long size;
 
 	if (mem_cgroup_is_root(memcg))
 		goto done;
@@ -2661,44 +2591,76 @@ static int mem_cgroup_try_charge(struct
 
 	if (gfp_mask & __GFP_NOFAIL)
 		oom = false;
-again:
+retry:
 	if (consume_stock(memcg, nr_pages))
 		goto done;
 
-	do {
-		bool invoke_oom = oom && !nr_oom_retries;
+	size = batch * PAGE_SIZE;
+	if (!res_counter_charge(&memcg->res, size, &fail_res)) {
+		if (!do_swap_account)
+			goto done_restock;
+		if (!res_counter_charge(&memcg->memsw, size, &fail_res))
+			goto done_restock;
+		res_counter_uncharge(&memcg->res, size);
+		mem_over_limit = mem_cgroup_from_res_counter(fail_res, memsw);
+		flags |= MEM_CGROUP_RECLAIM_NOSWAP;
+	} else
+		mem_over_limit = mem_cgroup_from_res_counter(fail_res, res);
 
-		/* If killed, bypass charge */
-		if (fatal_signal_pending(current))
-			goto bypass;
-
-		ret = mem_cgroup_do_charge(memcg, gfp_mask, batch,
-					   nr_pages, invoke_oom);
-		switch (ret) {
-		case CHARGE_OK:
-			break;
-		case CHARGE_RETRY: /* not in OOM situation but retry */
-			batch = nr_pages;
-			goto again;
-		case CHARGE_WOULDBLOCK: /* !__GFP_WAIT */
-			goto nomem;
-		case CHARGE_NOMEM: /* OOM routine works */
-			if (!oom || invoke_oom)
-				goto nomem;
-			nr_oom_retries--;
-			break;
-		}
-	} while (ret != CHARGE_OK);
+	if (batch > nr_pages) {
+		batch = nr_pages;
+		goto retry;
+	}
 
-	if (batch > nr_pages)
-		refill_stock(memcg, batch - nr_pages);
-done:
-	return 0;
+	if (!(gfp_mask & __GFP_WAIT))
+		goto nomem;
+
+	if (gfp_mask & __GFP_NORETRY)
+		goto nomem;
+
+	nr_reclaimed = mem_cgroup_reclaim(mem_over_limit, gfp_mask, flags);
+
+	if (mem_cgroup_margin(mem_over_limit) >= batch)
+		goto retry;
+	/*
+	 * Even though the limit is exceeded at this point, reclaim
+	 * may have been able to free some pages.  Retry the charge
+	 * before killing the task.
+	 *
+	 * Only for regular pages, though: huge pages are rather
+	 * unlikely to succeed so close to the limit, and we fall back
+	 * to regular pages anyway in case of failure.
+	 */
+	if (nr_reclaimed && batch <= (1 << PAGE_ALLOC_COSTLY_ORDER))
+		goto retry;
+	/*
+	 * At task move, charge accounts can be doubly counted. So, it's
+	 * better to wait until the end of task_move if something is going on.
+	 */
+	if (mem_cgroup_wait_acct_move(mem_over_limit))
+		goto retry;
+
+	if (fatal_signal_pending(current))
+		goto bypass;
+
+	if (!oom)
+		goto nomem;
+
+	if (nr_oom_retries--)
+		goto retry;
+
+	mem_cgroup_oom(mem_over_limit, gfp_mask, get_order(batch));
 nomem:
 	if (!(gfp_mask & __GFP_NOFAIL))
 		return -ENOMEM;
 bypass:
 	return -EINTR;
+
+done_restock:
+	if (batch > nr_pages)
+		refill_stock(memcg, batch - nr_pages);
+done:
+	return 0;
 }
 
 /**
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

