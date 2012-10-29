From: akpm@linux-foundation.org
Subject: + memcg-simplify-mem_cgroup_force_empty_list-error-handling.patch added to -mm tree
Date: Mon, 29 Oct 2012 15:04:30 -0700
Message-ID: <20121029220430.72DEC1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:46385 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761392Ab2J2WEb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 18:04:31 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so702938ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Oct 2012 15:04:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, bsingharora@gmail.com, glommer@parallels.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com, tj@kernel.org


The patch titled
     Subject: memcg: simplify mem_cgroup_force_empty_list() error handling
has been added to the -mm tree.  Its filename is
     memcg-simplify-mem_cgroup_force_empty_list-error-handling.patch

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
Subject: memcg: simplify mem_cgroup_force_empty_list() error handling

mem_cgroup_force_empty_list() currently tries to remove all pages from the
given LRU.  To avoid temporary failures (EBUSY returned by
mem_cgroup_move_parent()) it uses a margin to the current LRU pages and
returns the true if there are still some pages left on the list.

If we consider that mem_cgroup_move_parent() fails only when it is racing
with somebody else removing (uncharging) the page or when the page is
migrated then it is obvious that all those failures are only temporary and
so we can safely retry later.

Let's get rid of the safety margin and make the loop really wait for the
empty LRU.  The caller should still make sure that all charges have been
removed from the res_counter because mem_cgroup_replace_page_cache might
add a page to the LRU after the list_empty check (it doesn't touch
res_counter though).

This catches most of the cases except for shmem which might call
mem_cgroup_replace_page_cache with a page which is not charged and on the
LRU yet but this was the case also without this patch.  In order to fix
this we need a guarantee that try_get_mem_cgroup_from_page falls back to
the current mm's cgroup so it needs css_tryget to fail.  This will be
fixed up in a later patch because it needs a help from cgroup core
(pre_destroy has to be called after css is cleared).

Although mem_cgroup_pre_destroy() can still fail (if a new task or a new
sub-group appears) there is no reason to retry pre_destroy callback from
the cgroup core.  This means that __DEPRECATED_clear_css_refs has lost its
meaning and it can be removed.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Glauber Costa <glommer@parallels.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   76 +++++++++++++++++++++++++++++-----------------
 1 file changed, 48 insertions(+), 28 deletions(-)

diff -puN mm/memcontrol.c~memcg-simplify-mem_cgroup_force_empty_list-error-handling mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-simplify-mem_cgroup_force_empty_list-error-handling
+++ a/mm/memcontrol.c
@@ -2696,10 +2696,27 @@ out:
 	return ret;
 }
 
-/*
- * move charges to its parent.
+/**
+ * mem_cgroup_move_parent - moves page to the parent group
+ * @page: the page to move
+ * @pc: page_cgroup of the page
+ * @child: page's cgroup
+ *
+ * move charges to its parent or the root cgroup if the group has no
+ * parent (aka use_hierarchy==0).
+ * Although this might fail (get_page_unless_zero, isolate_lru_page or
+ * mem_cgroup_move_account fails) the failure is always temporary and
+ * it signals a race with a page removal/uncharge or migration. In the
+ * first case the page is on the way out and it will vanish from the LRU
+ * on the next attempt and the call should be retried later.
+ * Isolation from the LRU fails only if page has been isolated from
+ * the LRU since we looked at it and that usually means either global
+ * reclaim or migration going on. The page will either get back to the
+ * LRU or vanish.
+ * Finaly mem_cgroup_move_account fails only if the page got uncharged
+ * (!PageCgroupUsed) or moved to a different group. The page will
+ * disappear in the next attempt.
  */
-
 static int mem_cgroup_move_parent(struct page *page,
 				  struct page_cgroup *pc,
 				  struct mem_cgroup *child)
@@ -2726,8 +2743,10 @@ static int mem_cgroup_move_parent(struct
 	if (!parent)
 		parent = root_mem_cgroup;
 
-	if (nr_pages > 1)
+	if (nr_pages > 1) {
+		VM_BUG_ON(!PageTransHuge(page));
 		flags = compound_lock_irqsave(page);
+	}
 
 	ret = mem_cgroup_move_account(page, nr_pages,
 				pc, child, parent);
@@ -3677,17 +3696,22 @@ unsigned long mem_cgroup_soft_limit_recl
 	return nr_reclaimed;
 }
 
-/*
+/**
+ * mem_cgroup_force_empty_list - clears LRU of a group
+ * @memcg: group to clear
+ * @node: NUMA node
+ * @zid: zone id
+ * @lru: lru to to clear
+ *
  * Traverse a specified page_cgroup list and try to drop them all.  This doesn't
- * reclaim the pages page themselves - it just removes the page_cgroups.
- * Returns true if some page_cgroups were not freed, indicating that the caller
- * must retry this operation.
+ * reclaim the pages page themselves - pages are moved to the parent (or root)
+ * group.
  */
-static bool mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
+static void mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
 				int node, int zid, enum lru_list lru)
 {
 	struct mem_cgroup_per_zone *mz;
-	unsigned long flags, loop;
+	unsigned long flags;
 	struct list_head *list;
 	struct page *busy;
 	struct zone *zone;
@@ -3696,11 +3720,8 @@ static bool mem_cgroup_force_empty_list(
 	mz = mem_cgroup_zoneinfo(memcg, node, zid);
 	list = &mz->lruvec.lists[lru];
 
-	loop = mz->lru_size[lru];
-	/* give some margin against EBUSY etc...*/
-	loop += 256;
 	busy = NULL;
-	while (loop--) {
+	do {
 		struct page_cgroup *pc;
 		struct page *page;
 
@@ -3726,8 +3747,7 @@ static bool mem_cgroup_force_empty_list(
 			cond_resched();
 		} else
 			busy = NULL;
-	}
-	return !list_empty(list);
+	} while (!list_empty(list));
 }
 
 /*
@@ -3741,7 +3761,6 @@ static int mem_cgroup_reparent_charges(s
 {
 	struct cgroup *cgrp = memcg->css.cgroup;
 	int node, zid;
-	int ret;
 
 	do {
 		if (cgroup_task_count(cgrp) || !list_empty(&cgrp->children))
@@ -3749,28 +3768,30 @@ static int mem_cgroup_reparent_charges(s
 		/* This is for making all *used* pages to be on LRU. */
 		lru_add_drain_all();
 		drain_all_stock_sync(memcg);
-		ret = 0;
 		mem_cgroup_start_move(memcg);
 		for_each_node_state(node, N_HIGH_MEMORY) {
-			for (zid = 0; !ret && zid < MAX_NR_ZONES; zid++) {
+			for (zid = 0; zid < MAX_NR_ZONES; zid++) {
 				enum lru_list lru;
 				for_each_lru(lru) {
-					ret = mem_cgroup_force_empty_list(memcg,
+					mem_cgroup_force_empty_list(memcg,
 							node, zid, lru);
-					if (ret)
-						break;
 				}
 			}
-			if (ret)
-				break;
 		}
 		mem_cgroup_end_move(memcg);
 		memcg_oom_recover(memcg);
 		cond_resched();
-	/* "ret" should also be checked to ensure all lists are empty. */
-	} while (res_counter_read_u64(&memcg->res, RES_USAGE) > 0 || ret);
 
-	return ret;
+		/*
+		 * This is a safety check because mem_cgroup_force_empty_list
+		 * could have raced with mem_cgroup_replace_page_cache callers
+		 * so the lru seemed empty but the page could have been added
+		 * right after the check. RES_USAGE should be safe as we always
+		 * charge before adding to the LRU.
+		 */
+	} while (res_counter_read_u64(&memcg->res, RES_USAGE) > 0);
+
+	return 0;
 }
 
 /*
@@ -5619,7 +5640,6 @@ struct cgroup_subsys mem_cgroup_subsys =
 	.base_cftypes = mem_cgroup_files,
 	.early_init = 0,
 	.use_id = 1,
-	.__DEPRECATED_clear_css_refs = true,
 };
 
 #ifdef CONFIG_MEMCG_SWAP
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

