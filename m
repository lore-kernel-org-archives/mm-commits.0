From: akpm@linux-foundation.org
Subject: [merged] memcg-dont-uncharge-in-mem_cgroup_move_account.patch removed from -mm tree
Date: Thu, 31 May 2012 12:17:49 -0700
Message-ID: <20120531191749.7421EA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:32901 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932980Ab2EaTRv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:17:51 -0400
Received: by wibhn6 with SMTP id hn6so77030wib.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:17:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, aneesh.kumar@linux.vnet.ibm.com, fweisbec@gmail.com, glommer@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, tj@kernel.org, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: don't uncharge in mem_cgroup_move_account()
has been removed from the -mm tree.  Its filename was
     memcg-dont-uncharge-in-mem_cgroup_move_account.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: memcg: don't uncharge in mem_cgroup_move_account()

Now, all callers pass 'false' for 'bool uncharge' so remove this argument.

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

 mm/memcontrol.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff -puN mm/memcontrol.c~memcg-dont-uncharge-in-mem_cgroup_move_account mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-dont-uncharge-in-mem_cgroup_move_account
+++ a/mm/memcontrol.c
@@ -2592,23 +2592,19 @@ void mem_cgroup_split_huge_fixup(struct 
  * @pc:	page_cgroup of the page.
  * @from: mem_cgroup which the page is moved from.
  * @to:	mem_cgroup which the page is moved to. @from != @to.
- * @uncharge: whether we should call uncharge and css_put against @from.
  *
  * The caller must confirm following.
  * - page is not on LRU (isolate_page() is useful.)
  * - compound_lock is held when nr_pages > 1
  *
- * This function doesn't do "charge" nor css_get to new cgroup. It should be
- * done by a caller(__mem_cgroup_try_charge would be useful). If @uncharge is
- * true, this function does "uncharge" from old cgroup, but it doesn't if
- * @uncharge is false, so a caller should do "uncharge".
+ * This function doesn't do "charge" to new cgroup and doesn't do "uncharge"
+ * from old cgroup.
  */
 static int mem_cgroup_move_account(struct page *page,
 				   unsigned int nr_pages,
 				   struct page_cgroup *pc,
 				   struct mem_cgroup *from,
-				   struct mem_cgroup *to,
-				   bool uncharge)
+				   struct mem_cgroup *to)
 {
 	unsigned long flags;
 	int ret;
@@ -2642,9 +2638,6 @@ static int mem_cgroup_move_account(struc
 		preempt_enable();
 	}
 	mem_cgroup_charge_statistics(from, anon, -nr_pages);
-	if (uncharge)
-		/* This is not "cancel", but cancel_charge does all we need. */
-		__mem_cgroup_cancel_charge(from, nr_pages);
 
 	/* caller should have done css_get */
 	pc->mem_cgroup = to;
@@ -2706,7 +2699,7 @@ static int mem_cgroup_move_parent(struct
 		flags = compound_lock_irqsave(page);
 
 	ret = mem_cgroup_move_account(page, nr_pages,
-				pc, child, parent, false);
+				pc, child, parent);
 	if (!ret)
 		__mem_cgroup_cancel_local_charge(child, nr_pages);
 
@@ -5474,8 +5467,7 @@ static int mem_cgroup_move_charge_pte_ra
 			if (!isolate_lru_page(page)) {
 				pc = lookup_page_cgroup(page);
 				if (!mem_cgroup_move_account(page, HPAGE_PMD_NR,
-							     pc, mc.from, mc.to,
-							     false)) {
+							pc, mc.from, mc.to)) {
 					mc.precharge -= HPAGE_PMD_NR;
 					mc.moved_charge += HPAGE_PMD_NR;
 				}
@@ -5505,7 +5497,7 @@ retry:
 				goto put;
 			pc = lookup_page_cgroup(page);
 			if (!mem_cgroup_move_account(page, 1, pc,
-						     mc.from, mc.to, false)) {
+						     mc.from, mc.to)) {
 				mc.precharge--;
 				/* we uncharge from mc.from later. */
 				mc.moved_charge++;
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

