From: akpm@linux-foundation.org
Subject: [merged] memcg-move-charges-to-root-cgroup-if-use_hierarchy=0.patch removed from -mm tree
Date: Thu, 31 May 2012 12:17:47 -0700
Message-ID: <20120531191747.81BA0A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:56583 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932980Ab2EaTRt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:17:49 -0400
Received: by mail-ee0-f74.google.com with SMTP id t10so76371eei.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:17:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, aneesh.kumar@linux.vnet.ibm.com, fweisbec@gmail.com, glommer@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, tj@kernel.org, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: move charges to root cgroup if use_hierarchy=0
has been removed from the -mm tree.  Its filename was
     memcg-move-charges-to-root-cgroup-if-use_hierarchy=0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: memcg: move charges to root cgroup if use_hierarchy=0

Presently, at removal of cgroup, ->pre_destroy() is called and moves
charges to the parent cgroup.  A major reason for returning -EBUSY from
->pre_destroy() is that the 'moving' hits the parent's resource
limitation.  It happens only when use_hierarchy=0.

Considering use_hierarchy=0, all cgroups should be flat.  So, no one
cannot justify moving charges to parent...parent and children are in flat
configuration, not hierarchical.

This patch modifes the code to move charges to the root cgroup at
rmdir/force_empty if use_hierarchy==0.  This will much simplify rmdir()
and reduce error in ->pre_destroy.

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

 Documentation/cgroups/memory.txt |   13 ++++++-----
 mm/memcontrol.c                  |   34 +++++++++--------------------
 2 files changed, 19 insertions(+), 28 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-move-charges-to-root-cgroup-if-use_hierarchy=0 Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-move-charges-to-root-cgroup-if-use_hierarchy=0
+++ a/Documentation/cgroups/memory.txt
@@ -376,14 +376,15 @@ cgroup might have some charge associated
 tasks have migrated away from it. (because we charge against pages, not
 against tasks.)
 
-Such charges are freed or moved to their parent. At moving, both of RSS
-and CACHES are moved to parent.
-rmdir() may return -EBUSY if freeing/moving fails. See 5.1 also.
+We move the stats to root (if use_hierarchy==0) or parent (if
+use_hierarchy==1), and no change on the charge except uncharging
+from the child.
 
 Charges recorded in swap information is not updated at removal of cgroup.
 Recorded information is discarded and a cgroup which uses swap (swapcache)
 will be charged as a new owner of it.
 
+About use_hierarchy, see Section 6.
 
 5. Misc. interfaces.
 
@@ -396,13 +397,15 @@ will be charged as a new owner of it.
 
   Almost all pages tracked by this memory cgroup will be unmapped and freed.
   Some pages cannot be freed because they are locked or in-use. Such pages are
-  moved to parent and this cgroup will be empty. This may return -EBUSY if
-  VM is too busy to free/move all pages immediately.
+  moved to parent(if use_hierarchy==1) or root (if use_hierarchy==0) and this
+  cgroup will be empty.
 
   Typical use case of this interface is that calling this before rmdir().
   Because rmdir() moves all pages to parent, some out-of-use page caches can be
   moved to the parent. If you want to avoid that, force_empty will be useful.
 
+  About use_hierarchy, see Section 6.
+
 5.2 stat file
 
 memory.stat file includes following statistics
diff -puN mm/memcontrol.c~memcg-move-charges-to-root-cgroup-if-use_hierarchy=0 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-move-charges-to-root-cgroup-if-use_hierarchy=0
+++ a/mm/memcontrol.c
@@ -2678,15 +2678,13 @@ static int mem_cgroup_move_parent(struct
 				  struct mem_cgroup *child,
 				  gfp_t gfp_mask)
 {
-	struct cgroup *cg = child->css.cgroup;
-	struct cgroup *pcg = cg->parent;
 	struct mem_cgroup *parent;
 	unsigned int nr_pages;
 	unsigned long uninitialized_var(flags);
 	int ret;
 
 	/* Is ROOT ? */
-	if (!pcg)
+	if (mem_cgroup_is_root(child))
 		return -EINVAL;
 
 	ret = -EBUSY;
@@ -2697,33 +2695,23 @@ static int mem_cgroup_move_parent(struct
 
 	nr_pages = hpage_nr_pages(page);
 
-	parent = mem_cgroup_from_cont(pcg);
-	if (!parent->use_hierarchy) {
-		ret = __mem_cgroup_try_charge(NULL,
-					gfp_mask, nr_pages, &parent, false);
-		if (ret)
-			goto put_back;
-	}
+	parent = parent_mem_cgroup(child);
+	/*
+	 * If no parent, move charges to root cgroup.
+	 */
+	if (!parent)
+		parent = root_mem_cgroup;
 
 	if (nr_pages > 1)
 		flags = compound_lock_irqsave(page);
 
-	if (parent->use_hierarchy) {
-		ret = mem_cgroup_move_account(page, nr_pages,
-					pc, child, parent, false);
-		if (!ret)
-			__mem_cgroup_cancel_local_charge(child, nr_pages);
-	} else {
-		ret = mem_cgroup_move_account(page, nr_pages,
-					pc, child, parent, true);
-
-		if (ret)
-			__mem_cgroup_cancel_charge(parent, nr_pages);
-	}
+	ret = mem_cgroup_move_account(page, nr_pages,
+				pc, child, parent, false);
+	if (!ret)
+		__mem_cgroup_cancel_local_charge(child, nr_pages);
 
 	if (nr_pages > 1)
 		compound_unlock_irqrestore(page, flags);
-put_back:
 	putback_lru_page(page);
 put:
 	put_page(page);
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

