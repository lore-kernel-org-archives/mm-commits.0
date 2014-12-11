From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-remove-synchroneous-stock-draining-code.patch removed from
 -mm tree
Date: Thu, 11 Dec 2014 10:56:06 -0800
Message-ID: <5489e8c6.eicE83VCxijLJkkK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45098 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758582AbaLKS4H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:56:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, rientjes@google.com, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: remove synchronous stock draining code
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-remove-synchroneous-stock-draining-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: remove synchronous stock draining code

With charge reparenting, the last synchronous stock drainer left.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   46 ++++++----------------------------------------
 1 file changed, 6 insertions(+), 40 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-remove-synchroneous-stock-draining-code mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-remove-synchroneous-stock-draining-code
+++ a/mm/memcontrol.c
@@ -634,8 +634,6 @@ static void disarm_static_keys(struct me
 	disarm_kmem_keys(memcg);
 }
 
-static void drain_all_stock_async(struct mem_cgroup *memcg);
-
 static struct mem_cgroup_per_zone *
 mem_cgroup_zone_zoneinfo(struct mem_cgroup *memcg, struct zone *zone)
 {
@@ -2302,13 +2300,15 @@ static void refill_stock(struct mem_cgro
 
 /*
  * Drains all per-CPU charge caches for given root_memcg resp. subtree
- * of the hierarchy under it. sync flag says whether we should block
- * until the work is done.
+ * of the hierarchy under it.
  */
-static void drain_all_stock(struct mem_cgroup *root_memcg, bool sync)
+static void drain_all_stock(struct mem_cgroup *root_memcg)
 {
 	int cpu, curcpu;
 
+	/* If someone's already draining, avoid adding running more workers. */
+	if (!mutex_trylock(&percpu_charge_mutex))
+		return;
 	/* Notify other cpus that system-wide "drain" is running */
 	get_online_cpus();
 	curcpu = get_cpu();
@@ -2329,41 +2329,7 @@ static void drain_all_stock(struct mem_c
 		}
 	}
 	put_cpu();
-
-	if (!sync)
-		goto out;
-
-	for_each_online_cpu(cpu) {
-		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
-		if (test_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
-			flush_work(&stock->work);
-	}
-out:
 	put_online_cpus();
-}
-
-/*
- * Tries to drain stocked charges in other cpus. This function is asynchronous
- * and just put a work per cpu for draining localy on each cpu. Caller can
- * expects some charges will be back later but cannot wait for it.
- */
-static void drain_all_stock_async(struct mem_cgroup *root_memcg)
-{
-	/*
-	 * If someone calls draining, avoid adding more kworker runs.
-	 */
-	if (!mutex_trylock(&percpu_charge_mutex))
-		return;
-	drain_all_stock(root_memcg, false);
-	mutex_unlock(&percpu_charge_mutex);
-}
-
-/* This is a synchronous drain interface. */
-static void drain_all_stock_sync(struct mem_cgroup *root_memcg)
-{
-	/* called when force_empty is called */
-	mutex_lock(&percpu_charge_mutex);
-	drain_all_stock(root_memcg, true);
 	mutex_unlock(&percpu_charge_mutex);
 }
 
@@ -2472,7 +2438,7 @@ retry:
 		goto retry;
 
 	if (!drained) {
-		drain_all_stock_async(mem_over_limit);
+		drain_all_stock(mem_over_limit);
 		drained = true;
 		goto retry;
 	}
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
memcg-__mem_cgroup_free-remove-stale-disarm_static_keys-comment.patch
memcg-dont-check-mm-in-__memcg_kmem_get_cachenewpage_charge.patch
memcg-do-not-abuse-memcg_kmem_skip_account.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-mincore-add-hwpoison-page-handle.patch
memcg-zap-kmem_account_flags.patch
memcg-only-check-memcg_kmem_skip_account-in-__memcg_kmem_get_cache.patch
memcg-turn-memcg_kmem_skip_account-into-a-bit-field.patch
mm-move-swp_entry_t-definition-to-include-linux-mm_typesh.patch
mm-gfp-escalatedly-define-gfp_highuser-and-gfp_highuser_movable.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging-fix.patch
mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable-fix.patch
mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation.patch
stacktrace-introduce-snprint_stack_trace-for-buffer-output.patch
mm-page_owner-keep-track-of-page-owners.patch
mm-page_owner-correct-owner-information-for-early-allocated-pages.patch
documentation-add-new-page_owner-document.patch
mm-vmscan-invoke-slab-shrinkers-from-shrink_zone.patch
mm-vmscan-invoke-slab-shrinkers-from-shrink_zone-fix.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
mm-memcontrol-fix-defined-but-not-used-compiler-warning.patch
memcg-fix-possible-use-after-free-in-memcg_kmem_get_cache.patch
mm-memcontrolc-cleaning-up-function-that-are-not-used-anywhere.patch

