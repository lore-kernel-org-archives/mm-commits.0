From: akpm@linux-foundation.org
Subject: [to-be-updated] memcg-make-mem_cgroup_reparent_charges-non-failing.patch removed from -mm tree
Date: Tue, 30 Oct 2012 13:48:02 -0700
Message-ID: <20121030204802.EEAE61E0049@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:61714 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322Ab2J3UsE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Oct 2012 16:48:04 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so80263ggm.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Oct 2012 13:48:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, bsingharora@gmail.com, glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: make mem_cgroup_reparent_charges() non-failing
has been removed from the -mm tree.  Its filename was
     memcg-make-mem_cgroup_reparent_charges-non-failing.patch

This patch was dropped because an updated version will be merged

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
