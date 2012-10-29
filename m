From: akpm@linux-foundation.org
Subject: + memcg-split-mem_cgroup_force_empty-into-reclaiming-and-reparenting-parts.patch added to -mm tree
Date: Mon, 29 Oct 2012 15:04:20 -0700
Message-ID: <20121029220421.B7D8920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:64403 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab2J2WEZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 18:04:25 -0400
Received: by mail-bk0-f74.google.com with SMTP id q16so347985bkw.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Oct 2012 15:04:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, bsingharora@gmail.com, glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com, tj@kernel.org


The patch titled
     Subject: memcg: split mem_cgroup_force_empty() into reclaiming and reparenting parts
has been added to the -mm tree.  Its filename is
     memcg-split-mem_cgroup_force_empty-into-reclaiming-and-reparenting-parts.patch

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
Subject: memcg: split mem_cgroup_force_empty() into reclaiming and reparenting parts

mem_cgroup_force_empty() did two separate things depending on free_all
parameter from the very beginning.  It either reclaimed as many pages as
possible and moved the rest to the parent or just moved charges to the
parent.  The first variant is used as memory.force_empty callback while
the later is used from the mem_cgroup_pre_destroy().

The whole games around gotos are far from being nice and there is no
reason to keep those two functions inside one. Let's split them and
also move the responsibility for css reference counting to their callers
to make to code easier.

This patch doesn't make any functional changes.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Glauber Costa <glommer@parallels.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   72 ++++++++++++++++++++++++++--------------------
 1 file changed, 42 insertions(+), 30 deletions(-)

diff -puN mm/memcontrol.c~memcg-split-mem_cgroup_force_empty-into-reclaiming-and-reparenting-parts mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-split-mem_cgroup_force_empty-into-reclaiming-and-reparenting-parts
+++ a/mm/memcontrol.c
@@ -3733,27 +3733,21 @@ static bool mem_cgroup_force_empty_list(
 }
 
 /*
- * make mem_cgroup's charge to be 0 if there is no task.
+ * make mem_cgroup's charge to be 0 if there is no task by moving
+ * all the charges and pages to the parent.
  * This enables deleting this mem_cgroup.
+ *
+ * Caller is responsible for holding css reference on the memcg.
  */
-static int mem_cgroup_force_empty(struct mem_cgroup *memcg, bool free_all)
+static int mem_cgroup_reparent_charges(struct mem_cgroup *memcg)
 {
-	int ret;
-	int node, zid, shrink;
-	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
 	struct cgroup *cgrp = memcg->css.cgroup;
+	int node, zid;
+	int ret;
 
-	css_get(&memcg->css);
-
-	shrink = 0;
-	/* should free all ? */
-	if (free_all)
-		goto try_to_free;
-move_account:
 	do {
-		ret = -EBUSY;
 		if (cgroup_task_count(cgrp) || !list_empty(&cgrp->children))
-			goto out;
+			return -EBUSY;
 		/* This is for making all *used* pages to be on LRU. */
 		lru_add_drain_all();
 		drain_all_stock_sync(memcg);
@@ -3777,27 +3771,34 @@ move_account:
 		cond_resched();
 	/* "ret" should also be checked to ensure all lists are empty. */
 	} while (res_counter_read_u64(&memcg->res, RES_USAGE) > 0 || ret);
-out:
-	css_put(&memcg->css);
+
 	return ret;
+}
+
+/*
+ * Reclaims as many pages from the given memcg as possible and moves
+ * the rest to the parent.
+ *
+ * Caller is responsible for holding css reference for memcg.
+ */
+static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
+{
+	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
+	struct cgroup *cgrp = memcg->css.cgroup;
 
-try_to_free:
 	/* returns EBUSY if there is a task or if we come here twice. */
-	if (cgroup_task_count(cgrp) || !list_empty(&cgrp->children) || shrink) {
-		ret = -EBUSY;
-		goto out;
-	}
+	if (cgroup_task_count(cgrp) || !list_empty(&cgrp->children))
+		return -EBUSY;
+
 	/* we call try-to-free pages for make this cgroup empty */
 	lru_add_drain_all();
 	/* try to free all pages in this cgroup */
-	shrink = 1;
 	while (nr_retries && res_counter_read_u64(&memcg->res, RES_USAGE) > 0) {
 		int progress;
 
-		if (signal_pending(current)) {
-			ret = -EINTR;
-			goto out;
-		}
+		if (signal_pending(current))
+			return -EINTR;
+
 		progress = try_to_free_mem_cgroup_pages(memcg, GFP_KERNEL,
 						false);
 		if (!progress) {
@@ -3808,13 +3809,19 @@ try_to_free:
 
 	}
 	lru_add_drain();
-	/* try move_account...there may be some *locked* pages. */
-	goto move_account;
+	return mem_cgroup_reparent_charges(memcg);
 }
 
 static int mem_cgroup_force_empty_write(struct cgroup *cont, unsigned int event)
 {
-	return mem_cgroup_force_empty(mem_cgroup_from_cont(cont), true);
+	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
+	int ret;
+
+	css_get(&memcg->css);
+	ret = mem_cgroup_force_empty(memcg);
+	css_put(&memcg->css);
+
+	return ret;
 }
 
 
@@ -5004,8 +5011,13 @@ free_out:
 static int mem_cgroup_pre_destroy(struct cgroup *cont)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
+	int ret;
 
-	return mem_cgroup_force_empty(memcg, false);
+	css_get(&memcg->css);
+	ret = mem_cgroup_reparent_charges(memcg);
+	css_put(&memcg->css);
+
+	return ret;
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

