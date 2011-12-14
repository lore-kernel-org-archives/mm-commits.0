From: akpm@linux-foundation.org
Subject: + memcg-keep-root-group-unchanged-if-creation-fails.patch added to -mm tree
Date: Tue, 13 Dec 2011 16:48:46 -0800
Message-ID: <201112140048.pBE0mkx6029040@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:60095 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756408Ab1LNAsx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Dec 2011 19:48:53 -0500
Received: by eekc1 with SMTP id c1so10385eek.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Dec 2011 16:48:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhillf@gmail.com, aarcange@redhat.com, bsingharora@gmail.com, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: memcg: keep root group unchanged if creation fails
has been added to the -mm tree.  Its filename is
     memcg-keep-root-group-unchanged-if-creation-fails.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-keep-root-group-unchanged-if-creation-fails mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-keep-root-group-unchanged-if-creation-fails
+++ a/mm/memcontrol.c
@@ -4951,9 +4951,9 @@ mem_cgroup_create(struct cgroup_subsys *
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
@@ -4992,7 +4992,6 @@ mem_cgroup_create(struct cgroup_subsys *
 	return &memcg->css;
 free_out:
 	__mem_cgroup_free(memcg);
-	root_mem_cgroup = NULL;
 	return ERR_PTR(error);
 }
 
_
Subject: Subject: memcg: keep root group unchanged if creation fails

Patches currently in -mm which might be from dhillf@gmail.com are

linux-next.patch
memcg-keep-root-group-unchanged-if-creation-fails.patch
hugetlb-detect-race-upon-page-allocation-failure-during-cow.patch
hugetlb-clarify-hugetlb_instantiation_mutex-usage.patch
mm-compaction-push-isolate-search-base-of-compact-control-one-pfn-ahead.patch

