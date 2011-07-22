From: akpm@linux-foundation.org
Subject: + memcg-do-not-try-to-drain-per-cpu-caches-without-pages.patch added to -mm tree
Date: Fri, 22 Jul 2011 14:35:49 -0700
Message-ID: <201107222135.p6MLZnO6013726@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932306Ab1GVVgC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jul 2011 17:36:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memcg: do not try to drain per-cpu caches without pages
has been added to the -mm tree.  Its filename is
     memcg-do-not-try-to-drain-per-cpu-caches-without-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -2077,11 +2077,8 @@ static void drain_all_stock_async(struct
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
@@ -2090,8 +2087,12 @@ static void drain_all_stock_async(struct
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

linux-next.patch
mm-remove-the-leftovers-of-noswapaccount.patch
mm-thp-minor-lock-simplification-in-__khugepaged_exit.patch
mm-preallocate-page-before-lock_page-at-filemap-cow.patch
um-clean-up-vm-flagsh.patch
memcg-export-memory-cgroups-swappiness-with-mem_cgroup_swappiness.patch
memcg-consolidates-memory-cgroup-lru-stat-functions.patch
memcg-consolidates-memory-cgroup-lru-stat-functions-fix.patch
memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch
memcg-make-oom_lock-0-and-1-based-rather-than-counter.patch
memcg-change-memcg_oom_mutex-to-spinlock.patch
memcg-do-not-try-to-drain-per-cpu-caches-without-pages.patch
memcg-unify-sync-and-async-per-cpu-charge-cache-draining.patch
memcg-add-mem_cgroup_same_or_subtree-helper.patch
memcg-get-rid-of-percpu_charge_mutex-lock.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
fs-execc-use-build_bug_on-for-vm_stack_flags-vm_stack_incomplete_setup.patch

