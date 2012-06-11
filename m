From: akpm@linux-foundation.org
Subject: [to-be-updated] memcg-use-res_counter_uncharge_until-in-mem_cgroup_move_hugetlb_parent.patch removed from -mm tree
Date: Mon, 11 Jun 2012 14:10:29 -0700
Message-ID: <20120611211029.70BD8A0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:46917 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2FKVKa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 17:10:30 -0400
Received: by mail-vb0-f74.google.com with SMTP id l22so412460vbn.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 14:10:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, aneesh.kumar@linux.vnet.ibm.com, fweisbec@gmail.com, glommer@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, tj@kernel.org, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: use res_counter_uncharge_until() in mem_cgroup_move_hugetlb_parent()
has been removed from the -mm tree.  Its filename was
     memcg-use-res_counter_uncharge_until-in-mem_cgroup_move_hugetlb_parent.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: memcg: use res_counter_uncharge_until() in mem_cgroup_move_hugetlb_parent()

By using res_counter_uncharge_until(), we can avoid race and unnecessary
charging.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ying Han <yinghan@google.com>
Cc: Glauber Costa <glommer@parallels.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff -puN mm/memcontrol.c~memcg-use-res_counter_uncharge_until-in-mem_cgroup_move_hugetlb_parent mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-use-res_counter_uncharge_until-in-mem_cgroup_move_hugetlb_parent
+++ a/mm/memcontrol.c
@@ -3298,6 +3298,7 @@ int mem_cgroup_move_hugetlb_parent(int i
 	struct cgroup *pcgrp = cgroup->parent;
 	struct mem_cgroup *parent = mem_cgroup_from_cont(pcgrp);
 	struct mem_cgroup *memcg  = mem_cgroup_from_cont(cgroup);
+	struct res_counter *counter;
 
 	if (!get_page_unless_zero(page))
 		goto out;
@@ -3308,28 +3309,18 @@ int mem_cgroup_move_hugetlb_parent(int i
 		goto err_out;
 
 	csize = PAGE_SIZE << compound_order(page);
-	/*
-	 * If we have use_hierarchy set we can never fail here. So instead of
-	 * using res_counter_uncharge use the open-coded variant which just
-	 * uncharge the child res_counter. The parent will retain the charge.
-	 */
-	if (parent->use_hierarchy) {
-		unsigned long flags;
-		struct res_counter *counter;
-
-		counter = &memcg->hugepage[idx];
-		spin_lock_irqsave(&counter->lock, flags);
-		res_counter_uncharge_locked(counter, csize);
-		spin_unlock_irqrestore(&counter->lock, flags);
-	} else {
+	/* If parent->use_hierarchy == 0, we need to charge parent */
+	if (!parent->use_hierarchy) {
 		ret = res_counter_charge(&parent->hugepage[idx],
 					 csize, &fail_res);
 		if (ret) {
 			ret = -EBUSY;
 			goto err_out;
 		}
-		res_counter_uncharge(&memcg->hugepage[idx], csize);
 	}
+	counter = &memcg->hugepage[idx];
+	res_counter_uncharge_until(counter, counter->parent, csize);
+
 	pc->mem_cgroup = parent;
 err_out:
 	unlock_page_cgroup(pc);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

linux-next.patch
memcg-rename-mem_cgroup_stat_swapout-as-mem_cgroup_stat_swap.patch
memcg-rename-mem_cgroup_charge_type_mapped-as-mem_cgroup_charge_type_anon.patch
memcg-remove-mem_cgroup_charge_type_force.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0-in-mem_cgroup_move_hugetlb_parent.patch

