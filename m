From: akpm@linux-foundation.org
Subject: [merged] memcg-do-not-try-to-drain-per-cpu-caches-without-pages.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:28:16 -0700
Message-ID: <201107271927.p6RJR25N003170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754247Ab1G0T1I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:27:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg: do not try to drain per-cpu caches without pages
has been removed from the -mm tree.  Its filename was
     memcg-do-not-try-to-drain-per-cpu-caches-without-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: do not try to drain per-cpu caches without pages
From: Michal Hocko <mhocko@suse.cz>

drain_all_stock_async tries to optimize a work to be done on the work
queue by excluding any work for the current CPU because it assumes that
the context we are called from already tried to charge from that cache and
it's failed so it must be empty already.

While the assumption is correct we can optimize it even more by checking
the current number of pages in the cache.  This will also reduce a work on
other CPUs with an empty stock.

For the current CPU we can simply call drain_local_stock rather than
deferring it to the work queue.

[kamezawa.hiroyu@jp.fujitsu.com: use drain_local_stock for current CPU optimization]
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~memcg-do-not-try-to-drain-per-cpu-caches-without-pages mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-do-not-try-to-drain-per-cpu-caches-without-pages
+++ a/mm/memcontrol.c
@@ -2180,11 +2180,8 @@ static void drain_all_stock_async(struct
 		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
 		struct mem_cgroup *mem;
 
-		if (cpu == curcpu)
-			continue;
-
 		mem = stock->cached;
-		if (!mem)
+		if (!mem || !stock->nr_pages)
 			continue;
 		if (mem != root_mem) {
 			if (!root_mem->use_hierarchy)
@@ -2193,8 +2190,12 @@ static void drain_all_stock_async(struct
 			if (!css_is_ancestor(&mem->css, &root_mem->css))
 				continue;
 		}
-		if (!test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
-			schedule_work_on(cpu, &stock->work);
+		if (!test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags)) {
+			if (cpu == curcpu)
+				drain_local_stock(&stock->work);
+			else
+				schedule_work_on(cpu, &stock->work);
+		}
 	}
  	put_online_cpus();
 	mutex_unlock(&percpu_charge_mutex);
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch

