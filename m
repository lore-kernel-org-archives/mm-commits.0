From: akpm@linux-foundation.org
Subject: [folded] memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge.patch removed from -mm tree
Date: Thu, 12 Jan 2012 16:54:12 -0800
Message-ID: <20120113005413.248CE5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:52340 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280Ab2AMAyP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2012 19:54:15 -0500
Received: by wgbdt14 with SMTP id dt14so80307wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2012 16:54:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, mszeredi@suse.cz, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: return -EINTR at bypassing try_charge()
has been removed from the -mm tree.  Its filename was
     memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge.patch

This patch was dropped because it was folded into memcg-simplify-lru-handling-by-new-rule.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: memcg: return -EINTR at bypassing try_charge()

This patch is a fix for memcg-simplify-lru-handling-by-new-rule.patch
When running testprogram and stop it by Ctrl-C, add_lru/del_lru
will find pc->mem_cgroup is NULL and get panic. The reason
is bypass code in try_charge().

At try_charge(), it checks the thread is fatal or not as..
fatal_signal_pending() or TIF_MEMDIE. In this case, __try_charge()
returns 0(success) with setting *ptr as NULL.

Now, lruvec are deteremined by pc->mem_cgroup. So, it's better
to reset pc->mem_cgroup as root_mem_cgroup. This patch does
following change in try_charge()
  1. return -EINTR at bypassing.
  2. set *ptr = root_mem_cgroup at bypassing.

By this change, in page fault / radix-tree-insert path,
the page will be charged against root_mem_cgroup and the thread's
operations will go ahead without trouble. In other path,
migration or move_account etc..., -EINTR will stop the operation.
(may need some cleanup later..)

After this change, pc->mem_cgroup will have valid pointer if
the page is used.

Changelog: v2 -> v3
 - handle !mm case in another way.
 - removed redundant commments
 - fixed move_parent bug of uninitialized pointer
Changelog: v1 -> v2
 - returns -EINTR at bypassing.
 - change error code handling at callers.
 - changed the name of patch.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   45 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 34 insertions(+), 11 deletions(-)

diff -puN mm/memcontrol.c~memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge
+++ a/mm/memcontrol.c
@@ -2184,6 +2184,24 @@ static int mem_cgroup_do_charge(struct m
 }
 
 /*
+ * __mem_cgroup_try_charge() does
+ * 1. detect memcg to be charged against from passed *mm and *ptr,
+ * 2. update res_counter
+ * 3. call memory reclaim if necessary.
+ *
+ * In some special case, if the task is fatal, fatal_signal_pending() or
+ * TIF_MEMDIE, this functoion returns -EINTR with filling *ptr as
+ * root_mem_cgroup. There are 2 reasons for this. 1st is that
+ * fatal threads should quit as soon as possible without any hazards.
+ * 2nd is that all page should have valid pc->mem_cgroup if it will be
+ * used. If mm is NULL and the caller doesn't pass valid memcg pointer,
+ * that's treated as charge to root_mem_cgroup.
+ *
+ * So, try_charge will return
+ *  0       ...  at success. filling *ptr with a valid memcg pointer.
+ *  -ENOMEM ...  charge failure because of resource limits.
+ *  -EINTR  ...  if thread is fatal. *ptr is filled with root_mem_cgroup.
+ *
  * Unlike exported interface, "oom" parameter is added. if oom==true,
  * oom-killer can be invoked.
  */
@@ -2214,7 +2232,7 @@ static int __mem_cgroup_try_charge(struc
 	 * set, if so charge the init_mm (happens for pagecache usage).
 	 */
 	if (!*ptr && !mm)
-		goto bypass;
+		*ptr = root_mem_cgroup;
 again:
 	if (*ptr) { /* css should be a valid one */
 		memcg = *ptr;
@@ -2315,8 +2333,8 @@ nomem:
 	*ptr = NULL;
 	return -ENOMEM;
 bypass:
-	*ptr = NULL;
-	return 0;
+	*ptr = root_mem_cgroup;
+	return -EINTR;
 }
 
 /*
@@ -2582,7 +2600,7 @@ static int mem_cgroup_move_parent(struct
 
 	parent = mem_cgroup_from_cont(pcg);
 	ret = __mem_cgroup_try_charge(NULL, gfp_mask, nr_pages, &parent, false);
-	if (ret || !parent)
+	if (ret)
 		goto put_back;
 
 	if (nr_pages > 1)
@@ -2629,9 +2647,8 @@ static int mem_cgroup_charge_common(stru
 
 	pc = lookup_page_cgroup(page);
 	ret = __mem_cgroup_try_charge(mm, gfp_mask, nr_pages, &memcg, oom);
-	if (ret || !memcg)
+	if (ret == -ENOMEM)
 		return ret;
-
 	__mem_cgroup_commit_charge(memcg, page, nr_pages, pc, ctype);
 	return 0;
 }
@@ -2742,11 +2759,16 @@ int mem_cgroup_try_charge_swapin(struct 
 	*memcgp = memcg;
 	ret = __mem_cgroup_try_charge(NULL, mask, 1, memcgp, true);
 	css_put(&memcg->css);
+	if (ret == -EINTR)
+		ret = 0;
 	return ret;
 charge_cur_mm:
 	if (unlikely(!mm))
 		mm = &init_mm;
-	return __mem_cgroup_try_charge(mm, mask, 1, memcgp, true);
+	ret = __mem_cgroup_try_charge(mm, mask, 1, memcgp, true);
+	if (ret == -EINTR)
+		ret = 0;
+	return ret;
 }
 
 static void
@@ -3206,7 +3228,7 @@ int mem_cgroup_prepare_migration(struct 
 	*memcgp = memcg;
 	ret = __mem_cgroup_try_charge(NULL, gfp_mask, 1, memcgp, false);
 	css_put(&memcg->css);/* drop extra refcnt */
-	if (ret || *memcgp == NULL) {
+	if (ret) {
 		if (PageAnon(page)) {
 			lock_page_cgroup(pc);
 			ClearPageCgroupMigration(pc);
@@ -3216,6 +3238,7 @@ int mem_cgroup_prepare_migration(struct 
 			 */
 			mem_cgroup_uncharge_page(page);
 		}
+		/* we'll need to revisit this error code (we have -EINTR) */
 		return -ENOMEM;
 	}
 	/*
@@ -3635,7 +3658,7 @@ static int mem_cgroup_force_empty_list(s
 		pc = lookup_page_cgroup(page);
 
 		ret = mem_cgroup_move_parent(page, pc, memcg, GFP_KERNEL);
-		if (ret == -ENOMEM)
+		if (ret == -ENOMEM || ret == -EINTR)
 			break;
 
 		if (ret == -EBUSY || ret == -EINVAL) {
@@ -5026,9 +5049,9 @@ one_by_one:
 		}
 		ret = __mem_cgroup_try_charge(NULL,
 					GFP_KERNEL, 1, &memcg, false);
-		if (ret || !memcg)
+		if (ret)
 			/* mem_cgroup_clear_mc() will do uncharge later */
-			return -ENOMEM;
+			return ret;
 		mc.precharge++;
 	}
 	return ret;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue.patch
mm-memcg-consolidate-hierarchy-iteration-primitives.patch
mm-vmscan-distinguish-global-reclaim-from-global-lru-scanning.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
mm-memcg-per-priority-per-zone-hierarchy-scan-generations.patch
mm-move-memcg-hierarchy-reclaim-to-generic-reclaim-code.patch
mm-memcg-remove-optimization-of-keeping-the-root_mem_cgroup-lru-lists-empty.patch
mm-vmscan-convert-global-reclaim-to-per-memcg-lru-lists.patch
mm-collect-lru-list-heads-into-struct-lruvec.patch
mm-make-per-memcg-lru-lists-exclusive.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch
mm-memcg-shorten-preempt-disabled-section-around-event-checks.patch
documentation-cgroups-memorytxt-fix-typo.patch
memcg-fix-pgpgin-pgpgout-documentation.patch
mm-oom_kill-remove-memcg-argument-from-oom_kill_task.patch
mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg.patch
mm-memcg-clean-up-fault-accounting.patch
mm-memcg-lookup_page_cgroup-almost-never-returns-null.patch
mm-page_cgroup-check-page_cgroup-arrays-in-lookup_page_cgroup-only-when-necessary.patch
mm-memcg-remove-unneeded-checks-from-newpage_charge.patch
mm-memcg-remove-unneeded-checks-from-uncharge_page.patch
page_cgroup-add-helper-function-to-get-swap_cgroup.patch
memcg-clean-up-soft_limit_tree-if-allocation-fails.patch
oom-memcg-fix-exclusion-of-memcg-threads-after-they-have-detached-their-mm.patch
memcg-simplify-page-cache-charging.patch
memcg-simplify-corner-case-handling-of-lru.patch
memcg-clear-pc-mem_cgorup-if-necessary.patch
memcg-simplify-lru-handling-by-new-rule.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix-null-mem_cgroup_try_charge.patch
memcg-cleanup-for_each_node_state.patch
page_alloc-break-early-in-check_for_regular_memory.patch
page_cgroup-drop-multi-config_memory_hotplug.patch
vmscan-trace-add-file-info-to-trace_mm_vmscan_lru_isolate.patch
memcg-fix-split_huge_page_refcounts.patch
memcg-fix-mem_cgroup_print_bad_page.patch
mm-take-pagevecs-off-reclaim-stack.patch
c-r-introduce-checkpoint_restore-symbol.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch

