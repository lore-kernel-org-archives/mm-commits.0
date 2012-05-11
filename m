From: akpm@linux-foundation.org
Subject: + memcg-use-res_counter_uncharge_until-in-move_parent.patch added to -mm tree
Date: Fri, 11 May 2012 14:23:44 -0700
Message-ID: <20120511212345.1DE46A02AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:64958 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946069Ab2EKVXr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 May 2012 17:23:47 -0400
Received: by eeit10 with SMTP id t10so156489eei.1
        for <mm-commits@vger.kernel.org>; Fri, 11 May 2012 14:23:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, aneesh.kumar@linux.vnet.ibm.com, fweisbec@gmail.com, glommer@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, tj@kernel.org, yinghan@google.com


The patch titled
     Subject: memcg: use res_counter_uncharge_until() in move_parent()
has been added to the -mm tree.  Its filename is
     memcg-use-res_counter_uncharge_until-in-move_parent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: memcg: use res_counter_uncharge_until() in move_parent()

By using res_counter_uncharge_until(), we can avoid race and unnecessary
charging.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ying Han <yinghan@google.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   63 ++++++++++++++++++++++++++++++----------------
 1 file changed, 42 insertions(+), 21 deletions(-)

diff -puN mm/memcontrol.c~memcg-use-res_counter_uncharge_until-in-move_parent mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-use-res_counter_uncharge_until-in-move_parent
+++ a/mm/memcontrol.c
@@ -2446,6 +2446,24 @@ static void __mem_cgroup_cancel_charge(s
 }
 
 /*
+ * Cancel chrages in this cgroup....doesn't propagate to parent cgroup.
+ * This is useful when moving usage to parent cgroup.
+ */
+static void __mem_cgroup_cancel_local_charge(struct mem_cgroup *memcg,
+					unsigned int nr_pages)
+{
+	unsigned long bytes = nr_pages * PAGE_SIZE;
+
+	if (mem_cgroup_is_root(memcg))
+		return;
+
+	res_counter_uncharge_until(&memcg->res, memcg->res.parent, bytes);
+	if (do_swap_account)
+		res_counter_uncharge_until(&memcg->memsw,
+						memcg->memsw.parent, bytes);
+}
+
+/*
  * A helper function to get mem_cgroup from ID. must be called under
  * rcu_read_lock(). The caller must check css_is_removed() or some if
  * it's concern. (dropping refcnt from swap can be called against removed
@@ -2711,16 +2729,28 @@ static int mem_cgroup_move_parent(struct
 	nr_pages = hpage_nr_pages(page);
 
 	parent = mem_cgroup_from_cont(pcg);
-	ret = __mem_cgroup_try_charge(NULL, gfp_mask, nr_pages, &parent, false);
-	if (ret)
-		goto put_back;
+	if (!parent->use_hierarchy) {
+		ret = __mem_cgroup_try_charge(NULL,
+					gfp_mask, nr_pages, &parent, false);
+		if (ret)
+			goto put_back;
+	}
 
 	if (nr_pages > 1)
 		flags = compound_lock_irqsave(page);
 
-	ret = mem_cgroup_move_account(page, nr_pages, pc, child, parent, true);
-	if (ret)
-		__mem_cgroup_cancel_charge(parent, nr_pages);
+	if (parent->use_hierarchy) {
+		ret = mem_cgroup_move_account(page, nr_pages,
+					pc, child, parent, false);
+		if (!ret)
+			__mem_cgroup_cancel_local_charge(child, nr_pages);
+	} else {
+		ret = mem_cgroup_move_account(page, nr_pages,
+					pc, child, parent, true);
+
+		if (ret)
+			__mem_cgroup_cancel_charge(parent, nr_pages);
+	}
 
 	if (nr_pages > 1)
 		compound_unlock_irqrestore(page, flags);
@@ -3324,6 +3354,7 @@ int mem_cgroup_move_hugetlb_parent(int i
 	struct cgroup *pcgrp = cgroup->parent;
 	struct mem_cgroup *parent = mem_cgroup_from_cont(pcgrp);
 	struct mem_cgroup *memcg  = mem_cgroup_from_cont(cgroup);
+	struct res_counter *counter;
 
 	if (!get_page_unless_zero(page))
 		goto out;
@@ -3334,28 +3365,18 @@ int mem_cgroup_move_hugetlb_parent(int i
 		goto err_out;
 
 	csize = PAGE_SIZE << compound_order(page);
-	/*
-	 * If we have use_hierarchy set we can never fail here. So instead of
-	 * using res_counter_uncharge use the open-coded variant which just
-	 * uncharge the child res_counter. The parent will retain the charge.
-	 */
-	if (parent->use_hierarchy) {
-		unsigned long flags;
-		struct res_counter *counter;
-
-		counter = &memcg->hugepage[idx];
-		spin_lock_irqsave(&counter->lock, flags);
-		res_counter_uncharge_locked(counter, csize);
-		spin_unlock_irqrestore(&counter->lock, flags);
-	} else {
+	/* If parent->use_hierarchy == 0, we need to charge parent */
+	if (!parent->use_hierarchy) {
 		ret = res_counter_charge(&parent->hugepage[idx],
 					 csize, &fail_res);
 		if (ret) {
 			ret = -EBUSY;
 			goto err_out;
 		}
-		res_counter_uncharge(&memcg->hugepage[idx], csize);
 	}
+	counter = &memcg->hugepage[idx];
+	res_counter_uncharge_until(counter, counter->parent, csize);
+
 	pc->mem_cgroup = parent;
 err_out:
 	unlock_page_cgroup(pc);
_
Subject: Subject: memcg: use res_counter_uncharge_until() in move_parent()

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
linux-next.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlbfs-dont-use-err_ptr-with-vm_fault-values.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
memcg-add-hugetlb-extension.patch
memcg-add-hugetlb-extension-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlb-add-charge-uncharge-calls-for-hugetlb-alloc-free.patch
memcg-track-resource-index-in-cftype-private.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
hugetlbfs-add-a-list-for-tracking-in-use-hugetlb-pages.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration.patch
memcg-add-memory-controller-documentation-for-hugetlb-management.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check.patch
mm-mmapc-find_vma-remove-unnecessary-ifmm-check-fix.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
thp-memcg-split-hugepage-for-memcg-oom-on-cow.patch
mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node.patch
mm-do_migrate_pages-calls-migrate_to_node-even-if-task-is-already-on-a-correct-node-fix.patch
mm-do_migrate_pages-rename-arguments.patch
kernel-cgroup-push-rcu-read-locking-from-css_is_ancestor-to-callsite.patch
mm-memcg-count-pte-references-from-every-member-of-the-reclaimed-hierarchy.patch
mm-thp-drop-page_table_lock-to-uncharge-memcg-pages.patch
documentation-memcg-future-proof-hierarchical-statistics-documentation.patch
mm-page_allocc-remove-pageblock_default_order.patch
memcg-fix-change-behavior-of-shared-anon-at-moving-task.patch
memcg-swap-mem_cgroup_move_swap_account-never-needs-fixup.patch
memcg-swap-use-mem_cgroup_uncharge_swap.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
memcg-mark-more-functions-variables-as-static.patch
memcg-remove-unused-variable.patch
memcg-mark-stat-field-of-mem_cgroup-struct-as-__percpu.patch
memcg-remove-redundant-parentheses.patch
memcg-make-threshold-index-in-the-right-position.patch
memcg-revise-the-position-of-threshold-index-while-unregistering-event.patch
memcg-add-mlock-statistic-in-memorystat.patch
memcg-add-mlock-statistic-in-memorystat-fix.patch
mm-vmscan-store-priority-in-struct-scan_control.patch
mm-add-link-from-struct-lruvec-to-struct-zone.patch
mm-vmscan-push-lruvec-pointer-into-isolate_lru_pages.patch
mm-vmscan-push-zone-pointer-into-shrink_page_list.patch
mm-vmscan-remove-update_isolated_counts.patch
mm-vmscan-push-lruvec-pointer-into-putback_inactive_pages.patch
mm-vmscan-replace-zone_nr_lru_pages-with-get_lruvec_size.patch
mm-vmscan-push-lruvec-pointer-into-inactive_list_is_low.patch
mm-vmscan-push-lruvec-pointer-into-shrink_list.patch
mm-vmscan-push-lruvec-pointer-into-get_scan_count.patch
mm-vmscan-push-lruvec-pointer-into-should_continue_reclaim.patch
mm-vmscan-kill-struct-mem_cgroup_zone.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty.patch
rescounters-add-res_counter_uncharge_until.patch
memcg-use-res_counter_uncharge_until-in-move_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0.patch
memcg-dont-uncharge-in-mem_cgroup_move_account.patch
remove-__must_check-for-res_counter_charge_nofail.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9-fix.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch
c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment.patch
c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment-fix.patch
c-r-prctl-return-efault-instead-of-einval-in-case-if-underlied-vma-is-not-found.patch
c-r-prctl-drop-vma-flags-test-on-pr_set_mm_-stack-data-assignment.patch

