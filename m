From: akpm@linux-foundation.org
Subject: + memcg-fix-percpu-cached-charge-draining-frequency-v6.patch added to -mm tree
Date: Tue, 14 Jun 2011 19:06:37 -0700
Message-ID: <201106150206.p5F26U6X001423@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36762 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753508Ab1FOCGi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jun 2011 22:06:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg-fix-percpu-cached-charge-draining-frequency-v6
has been added to the -mm tree.  Its filename is
     memcg-fix-percpu-cached-charge-draining-frequency-v6.patch

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
Subject: memcg-fix-percpu-cached-charge-draining-frequency-v6
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

  - removed unnecessary rcu_read_lock()
  - removed a fix for softlimit case (move to another independent patch)
  - make mutex static.
  - applied comment updates from Andrew Morton.

Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-percpu-cached-charge-draining-frequency-v6 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-percpu-cached-charge-draining-frequency-v6
+++ a/mm/memcontrol.c
@@ -1670,7 +1670,7 @@ static int mem_cgroup_hierarchical_recla
 		victim = mem_cgroup_select_victim(root_mem);
 		if (victim == root_mem) {
 			loop++;
-			if (!check_soft && loop >= 1)
+			if (loop >= 1)
 				drain_all_stock_async(root_mem);
 			if (loop >= 2) {
 				/*
@@ -2021,7 +2021,6 @@ static void drain_all_stock_async(struct
 		return;
 	/* Notify other cpus that system-wide "drain" is running */
 	get_online_cpus();
-
 	/*
 	 * Get a hint for avoiding draining charges on the current cpu,
 	 * which must be exhausted by our charging.  It is not required that
@@ -2043,12 +2042,8 @@ static void drain_all_stock_async(struct
 			if (!root_mem->use_hierarchy)
 				continue;
 			/* check whether "mem" is under tree of "root_mem" */
-			rcu_read_lock();
-			if (!css_is_ancestor(&mem->css, &root_mem->css)) {
-				rcu_read_unlock();
+			if (!css_is_ancestor(&mem->css, &root_mem->css))
 				continue;
-			}
-			rcu_read_unlock();
 		}
 		if (!test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
 			schedule_work_on(cpu, &stock->work);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

vmscanmemcg-memcg-aware-swap-token.patch
vmscanmemcg-memcg-aware-swap-token-fix.patch
vmscan-implement-swap-token-trace.patch
vmscan-implement-swap-token-priority-aging.patch
memcg-add-documentation-for-the-memorynumastat-api.patch
memcg-add-documentation-for-the-memorynumastat-api-fix.patch
mm-increase-reclaim_distance-to-30.patch
mm-fix-wrong-kunmap_atomic-pointer.patch
mm-memory_hotplugc-fix-building-of-node-hotplug-zonelist.patch
mm-memorynuma_stat-fix-file-permission.patch
memcg-fix-init_page_cgroup-nid-with-sparsemem.patch
memcg-fix-init_page_cgroup-nid-with-sparsemem-fix.patch
memcg-clear-mm-owner-when-last-possible-owner-leaves.patch
memcg-clear-mm-owner-when-last-possible-owner-leaves-fix.patch
memcg-fix-wrong-check-of-noswap-with-softlimit.patch
memcg-fix-percpu-cached-charge-draining-frequency.patch
memcg-fix-percpu-cached-charge-draining-frequency-v6.patch
memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch

