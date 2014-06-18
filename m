From: akpm@linux-foundation.org
Subject: + mm-memcontrol-simplify-move-precharge-function.patch added to
 -mm tree
Date: Wed, 18 Jun 2014 16:54:51 -0700
Message-ID: <53a226cb.u+AJi2ptURSK5Gqh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43336 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756837AbaFRXyw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jun 2014 19:54:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vdavydov@parallels.com, tj@kernel.org, mhocko@suse.cz, hughd@google.com, hannes@cmpxchg.org


The patch titled
     Subject: mm: memcontrol: simplify move precharge function
has been added to the -mm tree.  Its filename is
     mm-memcontrol-simplify-move-precharge-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-simplify-move-precharge-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-simplify-move-precharge-function.patch

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
Subject: mm: memcontrol: simplify move precharge function

The move precharge function does some baroque things: it tries raw
res_counter charging of the entire amount first, and then falls back to a
loop of one-by-one charges, with checks for pending signals and
cond_resched() batching.

Just use mem_cgroup_try_charge() without __GFP_WAIT for the first bulk
charge attempt.  In the one-by-one loop, remove the signal check (this is
already checked in try_charge), and simply call cond_resched() after every
charge - it's not that expensive.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   48 ++++++++++++++--------------------------------
 1 file changed, 15 insertions(+), 33 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-simplify-move-precharge-function mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-simplify-move-precharge-function
+++ a/mm/memcontrol.c
@@ -6410,56 +6410,38 @@ static void mem_cgroup_css_free(struct c
 
 #ifdef CONFIG_MMU
 /* Handlers for move charge at task migration. */
-#define PRECHARGE_COUNT_AT_ONCE	256
 static int mem_cgroup_do_precharge(unsigned long count)
 {
 	int ret = 0;
-	int batch_count = PRECHARGE_COUNT_AT_ONCE;
-	struct mem_cgroup *memcg = mc.to;
 
-	if (mem_cgroup_is_root(memcg)) {
+	if (mem_cgroup_is_root(mc.to)) {
 		mc.precharge += count;
 		/* we don't need css_get for root */
 		return ret;
 	}
-	/* try to charge at once */
-	if (count > 1) {
-		struct res_counter *dummy;
-		/*
-		 * "memcg" cannot be under rmdir() because we've already checked
-		 * by cgroup_lock_live_cgroup() that it is not removed and we
-		 * are still under the same cgroup_mutex. So we can postpone
-		 * css_get().
-		 */
-		if (res_counter_charge(&memcg->res, PAGE_SIZE * count, &dummy))
-			goto one_by_one;
-		if (do_swap_account && res_counter_charge(&memcg->memsw,
-						PAGE_SIZE * count, &dummy)) {
-			res_counter_uncharge(&memcg->res, PAGE_SIZE * count);
-			goto one_by_one;
-		}
+
+	/* Try a single bulk charge without reclaim first */
+	ret = mem_cgroup_try_charge(mc.to, GFP_KERNEL & ~__GFP_WAIT, count);
+	if (!ret) {
 		mc.precharge += count;
 		return ret;
 	}
-one_by_one:
-	/* fall back to one by one charge */
+
+	/* Try charges one by one with reclaim */
 	while (count--) {
-		if (signal_pending(current)) {
-			ret = -EINTR;
-			break;
-		}
-		if (!batch_count--) {
-			batch_count = PRECHARGE_COUNT_AT_ONCE;
-			cond_resched();
-		}
-		ret = mem_cgroup_try_charge(memcg,
+		ret = mem_cgroup_try_charge(mc.to,
 					    GFP_KERNEL & ~__GFP_NORETRY, 1);
+		/*
+		 * In case of failure, any residual charges against
+		 * mc.to will be dropped by mem_cgroup_clear_mc()
+		 * later on.
+		 */
 		if (ret)
-			/* mem_cgroup_clear_mc() will do uncharge later */
 			return ret;
 		mc.precharge++;
+		cond_resched();
 	}
-	return ret;
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

