From: akpm@linux-foundation.org
Subject: + mm-memcontrol-remove-synchroneous-stock-draining-code.patch
 added to -mm tree
Date: Tue, 14 Oct 2014 13:14:08 -0700
Message-ID: <543d8410.tnnAByHhkWcuDQrH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45348 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437AbaJNUOI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 16:14:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, rientjes@google.com, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: remove synchronous stock draining code
has been added to the -mm tree.  Its filename is
     mm-memcontrol-remove-synchroneous-stock-draining-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-remove-synchroneous-stock-draining-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-remove-synchroneous-stock-draining-code.patch

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
Subject: mm: memcontrol: remove synchronous stock draining code

With charge reparenting, the last synchronous stock drainer left.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
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
@@ -2285,13 +2283,15 @@ static void refill_stock(struct mem_cgro
 
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
@@ -2312,41 +2312,7 @@ static void drain_all_stock(struct mem_c
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
 
@@ -2455,7 +2421,7 @@ retry:
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
cgroup-kmemleak-add-kmemleak_free-for-cgroup-deallocations.patch
mm-memcontrol-lockless-page-counters.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-hugetlb_cgroup-convert-to-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting.patch
mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch
mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch
mm-memcontrol-remove-synchroneous-stock-draining-code.patch
debugging-keep-track-of-page-owners.patch

