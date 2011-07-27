From: akpm@linux-foundation.org
Subject: [merged] memcg-get-rid-of-percpu_charge_mutex-lock.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:28:22 -0700
Message-ID: <201107271927.p6RJR9LW003187@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751974Ab1G0T1P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:27:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg: get rid of percpu_charge_mutex lock
has been removed from the -mm tree.  Its filename was
     memcg-get-rid-of-percpu_charge_mutex-lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: get rid of percpu_charge_mutex lock
From: Michal Hocko <mhocko@suse.cz>

percpu_charge_mutex protects from multiple simultaneous per-cpu charge
caches draining because we might end up having too many work items.  At
least this was the case until 26fe6168 (memcg: fix percpu cached charge
draining frequency) when we introduced a more targeted draining for async
mode.

Now that also sync draining is targeted we can safely remove mutex because
we will not send more work than the current number of CPUs. 
FLUSHING_CACHED_CHARGE protects from sending the same work multiple times
and stock->nr_pages == 0 protects from pointless sending a work if there
is obviously nothing to be done.  This is of course racy but we can live
with it as the race window is really small (we would have to see
FLUSHING_CACHED_CHARGE cleared while nr_pages would be still non-zero).

The only remaining place where we can race is synchronous mode when we
rely on FLUSHING_CACHED_CHARGE test which might have been set by other
drainer on the same group but we should wait in that case as well.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff -puN mm/memcontrol.c~memcg-get-rid-of-percpu_charge_mutex-lock mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-get-rid-of-percpu_charge_mutex-lock
+++ a/mm/memcontrol.c
@@ -2092,7 +2092,6 @@ struct memcg_stock_pcp {
 #define FLUSHING_CACHED_CHARGE	(0)
 };
 static DEFINE_PER_CPU(struct memcg_stock_pcp, memcg_stock);
-static DEFINE_MUTEX(percpu_charge_mutex);
 
 /*
  * Try to consume stocked charge on this cpu. If success, one page is consumed
@@ -2199,7 +2198,8 @@ static void drain_all_stock(struct mem_c
 
 	for_each_online_cpu(cpu) {
 		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
-		if (test_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
+		if (mem_cgroup_same_or_subtree(root_mem, stock->cached) &&
+				test_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
 			flush_work(&stock->work);
 	}
 out:
@@ -2214,22 +2214,14 @@ out:
  */
 static void drain_all_stock_async(struct mem_cgroup *root_mem)
 {
-	/*
-	 * If someone calls draining, avoid adding more kworker runs.
-	 */
-	if (!mutex_trylock(&percpu_charge_mutex))
-		return;
 	drain_all_stock(root_mem, false);
-	mutex_unlock(&percpu_charge_mutex);
 }
 
 /* This is a synchronous drain interface. */
 static void drain_all_stock_sync(struct mem_cgroup *root_mem)
 {
 	/* called when force_empty is called */
-	mutex_lock(&percpu_charge_mutex);
 	drain_all_stock(root_mem, true);
-	mutex_unlock(&percpu_charge_mutex);
 }
 
 /*
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch

