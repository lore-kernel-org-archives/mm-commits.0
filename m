From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-simplify-detecting-when-the-memoryswap-limit-is-hit.patch
 added to -mm tree
Date: Wed, 24 Sep 2014 12:44:46 -0700
Message-ID: <54231f2e.tB2yH4jqlDlgd6EU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49164 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaIXTov (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Sep 2014 15:44:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, dave@sr71.net, gthelen@google.com, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: simplify detecting when the memory+swap limit is hit
has been added to the -mm tree.  Its filename is
     mm-memcontrol-simplify-detecting-when-the-memoryswap-limit-is-hit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-simplify-detecting-when-the-memoryswap-limit-is-hit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-simplify-detecting-when-the-memoryswap-limit-is-hit.patch

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
Subject: mm: memcontrol: simplify detecting when the memory+swap limit is hit

When attempting to charge pages, we first charge the memory counter and
then the memory+swap counter.  If one of the counters is at its limit, we
enter reclaim, but if it's the memory+swap counter, reclaim shouldn't swap
because that wouldn't change the situation.  However, if the counters have
the same limits, we never get to the memory+swap limit.  To know whether
reclaim should swap or not, there is a state flag that indicates whether
the limits are equal and whether hitting the memory limit implies hitting
the memory+swap limit.

Just try the memory+swap counter first.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Dave Hansen <dave@sr71.net>
Cc: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   47 ++++++++++++----------------------------------
 1 file changed, 13 insertions(+), 34 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-simplify-detecting-when-the-memoryswap-limit-is-hit mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-simplify-detecting-when-the-memoryswap-limit-is-hit
+++ a/mm/memcontrol.c
@@ -315,9 +315,6 @@ struct mem_cgroup {
 	/* OOM-Killer disable */
 	int		oom_kill_disable;
 
-	/* set when res.limit == memsw.limit */
-	bool		memsw_is_minimum;
-
 	/* protect arrays of thresholds */
 	struct mutex thresholds_lock;
 
@@ -1804,8 +1801,6 @@ static unsigned long mem_cgroup_reclaim(
 
 	if (flags & MEM_CGROUP_RECLAIM_NOSWAP)
 		noswap = true;
-	if (!(flags & MEM_CGROUP_RECLAIM_SHRINK) && memcg->memsw_is_minimum)
-		noswap = true;
 
 	for (loop = 0; loop < MEM_CGROUP_MAX_RECLAIM_LOOPS; loop++) {
 		if (loop)
@@ -2543,16 +2538,17 @@ retry:
 		goto done;
 
 	size = batch * PAGE_SIZE;
-	if (!res_counter_charge(&memcg->res, size, &fail_res)) {
-		if (!do_swap_account)
+	if (!do_swap_account ||
+	    !res_counter_charge(&memcg->memsw, size, &fail_res)) {
+		if (!res_counter_charge(&memcg->res, size, &fail_res))
 			goto done_restock;
-		if (!res_counter_charge(&memcg->memsw, size, &fail_res))
-			goto done_restock;
-		res_counter_uncharge(&memcg->res, size);
+		if (do_swap_account)
+			res_counter_uncharge(&memcg->memsw, size);
+		mem_over_limit = mem_cgroup_from_res_counter(fail_res, res);
+	} else {
 		mem_over_limit = mem_cgroup_from_res_counter(fail_res, memsw);
 		flags |= MEM_CGROUP_RECLAIM_NOSWAP;
-	} else
-		mem_over_limit = mem_cgroup_from_res_counter(fail_res, res);
+	}
 
 	if (batch > nr_pages) {
 		batch = nr_pages;
@@ -3615,7 +3611,6 @@ static int mem_cgroup_resize_limit(struc
 				unsigned long long val)
 {
 	int retry_count;
-	u64 memswlimit, memlimit;
 	int ret = 0;
 	int children = mem_cgroup_count_children(memcg);
 	u64 curusage, oldusage;
@@ -3642,24 +3637,16 @@ static int mem_cgroup_resize_limit(struc
 		 * We have to guarantee memcg->res.limit <= memcg->memsw.limit.
 		 */
 		mutex_lock(&set_limit_mutex);
-		memswlimit = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
-		if (memswlimit < val) {
+		if (res_counter_read_u64(&memcg->memsw, RES_LIMIT) < val) {
 			ret = -EINVAL;
 			mutex_unlock(&set_limit_mutex);
 			break;
 		}
 
-		memlimit = res_counter_read_u64(&memcg->res, RES_LIMIT);
-		if (memlimit < val)
+		if (res_counter_read_u64(&memcg->res, RES_LIMIT) < val)
 			enlarge = 1;
 
 		ret = res_counter_set_limit(&memcg->res, val);
-		if (!ret) {
-			if (memswlimit == val)
-				memcg->memsw_is_minimum = true;
-			else
-				memcg->memsw_is_minimum = false;
-		}
 		mutex_unlock(&set_limit_mutex);
 
 		if (!ret)
@@ -3684,7 +3671,7 @@ static int mem_cgroup_resize_memsw_limit
 					unsigned long long val)
 {
 	int retry_count;
-	u64 memlimit, memswlimit, oldusage, curusage;
+	u64 oldusage, curusage;
 	int children = mem_cgroup_count_children(memcg);
 	int ret = -EBUSY;
 	int enlarge = 0;
@@ -3703,22 +3690,14 @@ static int mem_cgroup_resize_memsw_limit
 		 * We have to guarantee memcg->res.limit <= memcg->memsw.limit.
 		 */
 		mutex_lock(&set_limit_mutex);
-		memlimit = res_counter_read_u64(&memcg->res, RES_LIMIT);
-		if (memlimit > val) {
+		if (res_counter_read_u64(&memcg->res, RES_LIMIT) > val) {
 			ret = -EINVAL;
 			mutex_unlock(&set_limit_mutex);
 			break;
 		}
-		memswlimit = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
-		if (memswlimit < val)
+		if (res_counter_read_u64(&memcg->memsw, RES_LIMIT) < val)
 			enlarge = 1;
 		ret = res_counter_set_limit(&memcg->memsw, val);
-		if (!ret) {
-			if (memlimit == val)
-				memcg->memsw_is_minimum = true;
-			else
-				memcg->memsw_is_minimum = false;
-		}
 		mutex_unlock(&set_limit_mutex);
 
 		if (!ret)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page_alloc-fix-zone-allocation-fairness-on-up.patch
mm-remove-misleading-arch_uses_numa_prot_none.patch
mm-page_alloc-determine-migratetype-only-once.patch
mm-remove-noisy-remainder-of-the-scan_unevictable-interface.patch
mm-page_alloc-avoid-wakeup-kswapd-on-the-unintended-node.patch
mm-clean-up-zone-flags.patch
mm-page_alloc-make-paranoid-check-in-move_freepages-a-vm_bug_on.patch
mm-page_alloc-default-node-ordering-on-64-bit-numa-zone-ordering-on-32-bit-v2.patch
memcg-move-memcg_allocfree_cache_params-to-slab_commonc.patch
memcg-dont-call-memcg_update_all_caches-if-new-cache-id-fits.patch
memcg-move-memcg_update_cache_size-to-slab_commonc.patch
mm-memcontrol-do-not-kill-uncharge-batching-in-free_pages_and_swap_cache.patch
mm-memcontrol-simplify-detecting-when-the-memoryswap-limit-is-hit.patch
mm-memcontrol-fix-transparent-huge-page-allocations-under-pressure.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

