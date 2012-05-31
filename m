From: akpm@linux-foundation.org
Subject: [merged] memcg-use-res_counter_uncharge_until-in-move_parent.patch removed from -mm tree
Date: Thu, 31 May 2012 12:17:45 -0700
Message-ID: <20120531191745.73580A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:56583 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932980Ab2EaTRr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:17:47 -0400
Received: by eeit10 with SMTP id t10so76371eei.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:17:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, aneesh.kumar@linux.vnet.ibm.com, fweisbec@gmail.com, glommer@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, tj@kernel.org, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: use res_counter_uncharge_until() in move_parent()
has been removed from the -mm tree.  Its filename was
     memcg-use-res_counter_uncharge_until-in-move_parent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
Reviewed-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   42 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~memcg-use-res_counter_uncharge_until-in-move_parent mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-use-res_counter_uncharge_until-in-move_parent
+++ a/mm/memcontrol.c
@@ -2423,6 +2423,24 @@ static void __mem_cgroup_cancel_charge(s
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
@@ -2680,16 +2698,28 @@ static int mem_cgroup_move_parent(struct
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
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
linux-next.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlbfs-dont-use-err_ptr-with-vm_fault-values.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-simplify-migrate_huge_page-fix.patch
memcg-add-hugetlb-extension.patch
memcg-add-hugetlb-extension-fix.patch
memcg-add-hugetlb-extension-fix-fix.patch
hugetlb-add-charge-uncharge-calls-for-hugetlb-alloc-free.patch
memcg-track-resource-index-in-cftype-private.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-add-failcnt-support-for-hugetlb-extension.patch
hugetlbfs-add-a-list-for-tracking-in-use-hugetlb-pages.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration.patch
memcg-add-memory-controller-documentation-for-hugetlb-management.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch
memcg-use-res_counter_uncharge_until-in-mem_cgroup_move_hugetlb_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0-in-mem_cgroup_move_hugetlb_parent.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9-fix.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch
c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment.patch
c-r-prctl-simplify-pr_set_mm-on-mm-code-data-assignment-fix.patch
c-r-prctl-return-efault-instead-of-einval-in-case-if-underlied-vma-is-not-found.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-add-minimal-address-test-to-pr_set_mm.patch
c-r-prctl-drop-vma-flags-test-on-pr_set_mm_-stack-data-assignment.patch

