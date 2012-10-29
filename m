From: akpm@linux-foundation.org
Subject: + memcg-make-mem_cgroup_reparent_charges-non-failing.patch added to -mm tree
Date: Mon, 29 Oct 2012 15:04:37 -0700
Message-ID: <20121029220438.83CAA5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:64403 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761330Ab2J2WEl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 18:04:41 -0400
Received: by mail-bk0-f74.google.com with SMTP id q16so347985bkw.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Oct 2012 15:04:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, bsingharora@gmail.com, glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com, tj@kernel.org


The patch titled
     Subject: memcg: make mem_cgroup_reparent_charges() non-failing
has been added to the -mm tree.  Its filename is
     memcg-make-mem_cgroup_reparent_charges-non-failing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: make mem_cgroup_reparent_charges() non-failing

Now that pre_destroy() callbacks are called from the context where neither
any task can attach the group nor any children group can be added there is
no other way to fail from mem_cgroup_pre_destroy().

mem_cgroup_pre_destroy() doesn't have to take a reference to memcg's css
because all css' are marked dead already.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Reviewed-by: Glauber Costa <glommer@parallels.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff -puN mm/memcontrol.c~memcg-make-mem_cgroup_reparent_charges-non-failing mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-make-mem_cgroup_reparent_charges-non-failing
+++ a/mm/memcontrol.c
@@ -3757,14 +3757,12 @@ static void mem_cgroup_force_empty_list(
  *
  * Caller is responsible for holding css reference on the memcg.
  */
-static int mem_cgroup_reparent_charges(struct mem_cgroup *memcg)
+static void mem_cgroup_reparent_charges(struct mem_cgroup *memcg)
 {
 	struct cgroup *cgrp = memcg->css.cgroup;
 	int node, zid;
 
 	do {
-		if (cgroup_task_count(cgrp) || !list_empty(&cgrp->children))
-			return -EBUSY;
 		/* This is for making all *used* pages to be on LRU. */
 		lru_add_drain_all();
 		drain_all_stock_sync(memcg);
@@ -3790,8 +3788,6 @@ static int mem_cgroup_reparent_charges(s
 		 * charge before adding to the LRU.
 		 */
 	} while (res_counter_read_u64(&memcg->res, RES_USAGE) > 0);
-
-	return 0;
 }
 
 /*
@@ -3828,7 +3824,9 @@ static int mem_cgroup_force_empty(struct
 
 	}
 	lru_add_drain();
-	return mem_cgroup_reparent_charges(memcg);
+	mem_cgroup_reparent_charges(memcg);
+
+	return 0;
 }
 
 static int mem_cgroup_force_empty_write(struct cgroup *cont, unsigned int event)
@@ -5032,13 +5030,9 @@ free_out:
 static int mem_cgroup_pre_destroy(struct cgroup *cont)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
-	int ret;
 
-	css_get(&memcg->css);
-	ret = mem_cgroup_reparent_charges(memcg);
-	css_put(&memcg->css);
-
-	return ret;
+	mem_cgroup_reparent_charges(memcg);
+	return 0;
 }
 
 static void mem_cgroup_destroy(struct cgroup *cont)
_

Patches currently in -mm which might be from mhocko@suse.cz are

thp-clean-up-__collapse_huge_page_isolate.patch
thp-clean-up-__collapse_huge_page_isolate-v2.patch
mm-introduce-mm_find_pmd.patch
mm-introduce-mm_find_pmd-fix.patch
thp-introduce-hugepage_vma_check.patch
thp-cleanup-introduce-mk_huge_pmd.patch
memory-hotplug-allocate-zones-pcp-before-onlining-pages-fix.patch
memcg-split-mem_cgroup_force_empty-into-reclaiming-and-reparenting-parts.patch
memcg-root_cgroup-cannot-reach-mem_cgroup_move_parent.patch
memcg-simplify-mem_cgroup_force_empty_list-error-handling.patch
cgroups-forbid-pre_destroy-callback-to-fail.patch
memcg-make-mem_cgroup_reparent_charges-non-failing.patch
hugetlb-do-not-fail-in-hugetlb_cgroup_pre_destroy.patch
drop_caches-add-some-documentation-and-info-messsge.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
mm-memblock-reduce-overhead-in-binary-search.patch

