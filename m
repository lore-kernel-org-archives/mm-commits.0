From: akpm@linux-foundation.org
Subject: [merged] memcg-keep-root-group-unchanged-if-creation-fails.patch removed from -mm tree
Date: Wed, 28 Dec 2011 14:04:32 -0800
Message-ID: <20111228220433.5398D5C0076@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:51712 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab1L1WEg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Dec 2011 17:04:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhillf@gmail.com, aarcange@redhat.com, bsingharora@gmail.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: keep root group unchanged if creation fails
has been removed from the -mm tree.  Its filename was
     memcg-keep-root-group-unchanged-if-creation-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hillf Danton <dhillf@gmail.com>
Subject: memcg: keep root group unchanged if creation fails

If the request is to create non-root group and we fail to meet it, we
should leave the root unchanged.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-keep-root-group-unchanged-if-creation-fails mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-keep-root-group-unchanged-if-creation-fails
+++ a/mm/memcontrol.c
@@ -4907,9 +4907,9 @@ mem_cgroup_create(struct cgroup_subsys *
 		int cpu;
 		enable_swap_cgroup();
 		parent = NULL;
-		root_mem_cgroup = memcg;
 		if (mem_cgroup_soft_limit_tree_init())
 			goto free_out;
+		root_mem_cgroup = memcg;
 		for_each_possible_cpu(cpu) {
 			struct memcg_stock_pcp *stock =
 						&per_cpu(memcg_stock, cpu);
@@ -4948,7 +4948,6 @@ mem_cgroup_create(struct cgroup_subsys *
 	return &memcg->css;
 free_out:
 	__mem_cgroup_free(memcg);
-	root_mem_cgroup = NULL;
 	return ERR_PTR(error);
 }
 
_

Patches currently in -mm which might be from dhillf@gmail.com are

mm-hugetlb-fix-non-atomic-enqueue-of-huge-page.patch
linux-next.patch
hugetlb-detect-race-upon-page-allocation-failure-during-cow.patch
hugetlb-clarify-hugetlb_instantiation_mutex-usage.patch
mm-compaction-push-isolate-search-base-of-compact-control-one-pfn-ahead.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma-fix.patch
mm-hugetlb-avoid-bogus-counter-of-surplus-huge-page.patch

