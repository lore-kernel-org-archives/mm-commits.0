From: akpm@linux-foundation.org
Subject: [to-be-updated] memcg-fix-error-code-in-hugetlb_force_memcg_empty.patch removed from -mm tree
Date: Mon, 11 Jun 2012 14:10:23 -0700
Message-ID: <20120611211023.85EE4A0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:54380 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab2FKVKY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 17:10:24 -0400
Received: by mail-qa0-f74.google.com with SMTP id g24so382695qab.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 14:10:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, aneesh.kumar@linux.vnet.ibm.com, fweisbec@gmail.com, glommer@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, tj@kernel.org, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: fix error code in hugetlb_force_memcg_empty()
has been removed from the -mm tree.  Its filename was
     memcg-fix-error-code-in-hugetlb_force_memcg_empty.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: memcg: fix error code in hugetlb_force_memcg_empty()

The force_empty interface allows us to make the memcg empty only when the
cgroup doesn't include any tasks.

	# echo 0 > /cgroup/xxxx/memory.force_empty

If the cgroup isn't empty, force_empty does nothing and returns -EBUSY. 
But the hugetlb implementation has an inconsitency with this and returns 0
and do nothing.  Fix it to return -EBUSY.

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ying Han <yinghan@google.com>
Cc: Glauber Costa <glommer@parallels.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~memcg-fix-error-code-in-hugetlb_force_memcg_empty mm/hugetlb.c
--- a/mm/hugetlb.c~memcg-fix-error-code-in-hugetlb_force_memcg_empty
+++ a/mm/hugetlb.c
@@ -1922,8 +1922,11 @@ int hugetlb_force_memcg_empty(struct cgr
 	int ret = 0, idx = 0;
 
 	do {
-		if (cgroup_task_count(cgroup) || !list_empty(&cgroup->children))
+		if (cgroup_task_count(cgroup)
+			|| !list_empty(&cgroup->children)) {
+			ret = -EBUSY;
 			goto out;
+		}
 		/*
 		 * If the task doing the cgroup_rmdir got a signal
 		 * we don't really need to loop till the hugetlb resource
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

linux-next.patch
memcg-rename-mem_cgroup_stat_swapout-as-mem_cgroup_stat_swap.patch
memcg-rename-mem_cgroup_charge_type_mapped-as-mem_cgroup_charge_type_anon.patch
memcg-remove-mem_cgroup_charge_type_force.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch
memcg-use-res_counter_uncharge_until-in-mem_cgroup_move_hugetlb_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0-in-mem_cgroup_move_hugetlb_parent.patch

