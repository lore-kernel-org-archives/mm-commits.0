From: akpm@linux-foundation.org
Subject: [merged] memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:26:59 -0800
Message-ID: <201111072026.pA7KQxws004192@wpaz29.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:47279 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab1KGU1u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:27:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: imammedo@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: do not expose uninitialized mem_cgroup_per_node to world
has been removed from the -mm tree.  Its filename was
     memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Igor Mammedov <imammedo@redhat.com>
Subject: memcg: do not expose uninitialized mem_cgroup_per_node to world

If somebody is touching data too early, it might be easier to diagnose a
problem when dereferencing NULL at mem->info.nodeinfo[node] than trying to
understand why mem_cgroup_per_zone is [un|partly]initialized.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world
+++ a/mm/memcontrol.c
@@ -4742,7 +4742,6 @@ static int alloc_mem_cgroup_per_zone_inf
 	if (!pn)
 		return 1;
 
-	memcg->info.nodeinfo[node] = pn;
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 		mz = &pn->zoneinfo[zone];
 		for_each_lru(l)
@@ -4751,6 +4750,7 @@ static int alloc_mem_cgroup_per_zone_inf
 		mz->on_tree = false;
 		mz->mem = memcg;
 	}
+	memcg->info.nodeinfo[node] = pn;
 	return 0;
 }
 
_

Patches currently in -mm which might be from imammedo@redhat.com are

origin.patch

