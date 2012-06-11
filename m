From: akpm@linux-foundation.org
Subject: [to-be-updated] memcg-move-charges-to-root-cgroup-if-use_hierarchy=0-in-mem_cgroup_move_hugetlb_parent.patch removed from -mm tree
Date: Mon, 11 Jun 2012 14:10:31 -0700
Message-ID: <20120611211031.81007A0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:49946 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2FKVKc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 17:10:32 -0400
Received: by mail-qc0-f202.google.com with SMTP id p5so124916qcs.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 14:10:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, aneesh.kumar@linux.vnet.ibm.com, fweisbec@gmail.com, glommer@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, tj@kernel.org, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: move charges to root cgroup if use_hierarchy=0 in mem_cgroup_move_hugetlb_parent()
has been removed from the -mm tree.  Its filename was
     memcg-move-charges-to-root-cgroup-if-use_hierarchy=0-in-mem_cgroup_move_hugetlb_parent.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: memcg: move charges to root cgroup if use_hierarchy=0 in mem_cgroup_move_hugetlb_parent()

Presently, at removal of cgroup, ->pre_destroy() is called and moves
charges to the parent cgroup.  A major reason for returning -EBUSY from
->pre_destroy() is that the 'moving' hits the parent's resource
limitation.  It happens only when use_hierarchy=0.

Considering use_hierarchy=0, all cgroups should be flat.  So, no one
cannot justify moving charges to parent...parent and children are in flat
configuration, not hierarchical.

This patch modifes the code to move charges to the root cgroup at
rmdir/force_empty if use_hierarchy==0.  This will much simplify rmdir()
and reduce error in ->pre_destroy.

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

 mm/memcontrol.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN mm/memcontrol.c~memcg-move-charges-to-root-cgroup-if-use_hierarchy=0-in-mem_cgroup_move_hugetlb_parent mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-move-charges-to-root-cgroup-if-use_hierarchy=0-in-mem_cgroup_move_hugetlb_parent
+++ a/mm/memcontrol.c
@@ -3295,9 +3295,8 @@ int mem_cgroup_move_hugetlb_parent(int i
 	struct page_cgroup *pc;
 	int csize,  ret = 0;
 	struct res_counter *fail_res;
-	struct cgroup *pcgrp = cgroup->parent;
-	struct mem_cgroup *parent = mem_cgroup_from_cont(pcgrp);
 	struct mem_cgroup *memcg  = mem_cgroup_from_cont(cgroup);
+	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
 	struct res_counter *counter;
 
 	if (!get_page_unless_zero(page))
@@ -3310,13 +3309,11 @@ int mem_cgroup_move_hugetlb_parent(int i
 
 	csize = PAGE_SIZE << compound_order(page);
 	/* If parent->use_hierarchy == 0, we need to charge parent */
-	if (!parent->use_hierarchy) {
-		ret = res_counter_charge(&parent->hugepage[idx],
-					 csize, &fail_res);
-		if (ret) {
-			ret = -EBUSY;
-			goto err_out;
-		}
+	if (!parent) {
+		parent = root_mem_cgroup;
+		/* root has no limit */
+		res_counter_charge_nofail(&parent->hugepage[idx],
+				 csize, &fail_res);
 	}
 	counter = &memcg->hugepage[idx];
 	res_counter_uncharge_until(counter, counter->parent, csize);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

linux-next.patch
memcg-rename-mem_cgroup_stat_swapout-as-mem_cgroup_stat_swap.patch
memcg-rename-mem_cgroup_charge_type_mapped-as-mem_cgroup_charge_type_anon.patch
memcg-remove-mem_cgroup_charge_type_force.patch

