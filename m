From: akpm@linux-foundation.org
Subject: [merged] mm-memcontrol-simplify-move-precharge-function.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:04:31 -0700
Message-ID: <53e3dbcf./5G/vuPvAd0K4N+f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:52857 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105AbaHGUEc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:04:32 -0400
Received: by mail-yh0-f73.google.com with SMTP id f73so609936yha.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:04:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: simplify move precharge function
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-simplify-move-precharge-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -6385,56 +6385,38 @@ static void mem_cgroup_css_reset(struct
 
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

origin.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-use-page-lists-for-uncharge-batching.patch
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
page-cgroup-trivial-cleanup.patch
page-cgroup-get-rid-of-nr_pcg_flags.patch
memcg-remove-lookup_cgroup_page-prototype.patch
mm-memcontrol-avoid-charge-statistics-churn-during-page-migration.patch
nilfs2-integrate-sysfs-support-into-driver-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

