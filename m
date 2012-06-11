From: akpm@linux-foundation.org
Subject: [to-be-updated] memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2.patch removed from -mm tree
Date: Mon, 11 Jun 2012 14:10:25 -0700
Message-ID: <20120611211025.57DE8A0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:61970 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2FKVK3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 17:10:29 -0400
Received: by were53 with SMTP id e53so251354wer.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 14:10:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, aneesh.kumar@linux.vnet.ibm.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2
has been removed from the -mm tree.  Its filename was
     memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2

- clean up.

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2 mm/hugetlb.c
--- a/mm/hugetlb.c~memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2
+++ a/mm/hugetlb.c
@@ -1922,8 +1922,8 @@ int hugetlb_force_memcg_empty(struct cgr
 	int ret = 0, idx = 0;
 
 	do {
-		if (cgroup_task_count(cgroup)
-			|| !list_empty(&cgroup->children)) {
+		if (cgroup_task_count(cgroup) ||
+		    !list_empty(&cgroup->children)){
 			ret = -EBUSY;
 			goto out;
 		}
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

linux-next.patch
memcg-rename-mem_cgroup_stat_swapout-as-mem_cgroup_stat_swap.patch
memcg-rename-mem_cgroup_charge_type_mapped-as-mem_cgroup_charge_type_anon.patch
memcg-remove-mem_cgroup_charge_type_force.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch
memcg-use-res_counter_uncharge_until-in-mem_cgroup_move_hugetlb_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0-in-mem_cgroup_move_hugetlb_parent.patch

