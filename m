From: akpm@linux-foundation.org
Subject: + memcg-revert-gfp-mask-fix.patch added to -mm tree
Date: Tue, 02 Dec 2008 21:56:58 -0800
Message-ID: <200812030556.mB35uwjl028763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37382 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754007AbYLCF5T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 00:57:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, hugh@veritas.com, kosaki.motohiro@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: revert gfp mask fix
has been added to the -mm tree.  Its filename is
     memcg-revert-gfp-mask-fix.patch

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
Subject: memcg: revert gfp mask fix
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

My patch, memcg-fix-gfp_mask-of-callers-of-charge.patch changed gfp_mask
of callers of charge to be GFP_HIGHUSER_MOVABLE for showing what will
happen at memory reclaim.

But in recent discussion, it's NACKed because it sounds ugly.

This patch is for reverting it and add some clean up to gfp_mask of
callers of charge.  No behavior change but need review before generating
HUNK in deep queue.

This patch also adds explanation to meaning of gfp_mask passed to charge
functions in memcontrol.h.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   10 ++++++++++
 mm/filemap.c               |    2 +-
 mm/memcontrol.c            |   10 +++++-----
 mm/memory.c                |   10 ++++------
 mm/shmem.c                 |    8 ++++----
 mm/swapfile.c              |    3 +--
 6 files changed, 25 insertions(+), 18 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-revert-gfp-mask-fix include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-revert-gfp-mask-fix
+++ a/include/linux/memcontrol.h
@@ -26,6 +26,16 @@ struct page;
 struct mm_struct;
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
+/*
+ * All "charge" functions with gfp_mask should use GFP_KERNEL or
+ * (gfp_mask & GFP_RECLAIM_MASK). In current implementatin, memcg doesn't
+ * alloc memory but reclaims memory from all available zones. So, "where I want
+ * memory from" bits of gfp_mask has no meaning. So any bits of that field is
+ * available but adding a rule is better. charge functions' gfp_mask should
+ * be set to GFP_KERNEL or gfp_mask & GFP_RECLAIM_MASK for avoiding ambiguous
+ * codes.
+ * (Of course, if memcg does memory allocation in future, GFP_KERNEL is sane.)
+ */
 
 extern int mem_cgroup_newpage_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask);
diff -puN mm/filemap.c~memcg-revert-gfp-mask-fix mm/filemap.c
--- a/mm/filemap.c~memcg-revert-gfp-mask-fix
+++ a/mm/filemap.c
@@ -460,7 +460,7 @@ int add_to_page_cache_locked(struct page
 	VM_BUG_ON(!PageLocked(page));
 
 	error = mem_cgroup_cache_charge(page, current->mm,
-					gfp_mask & ~__GFP_HIGHMEM);
+					gfp_mask & GFP_RECLAIM_MASK);
 	if (error)
 		goto out;
 
diff -puN mm/memcontrol.c~memcg-revert-gfp-mask-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-revert-gfp-mask-fix
+++ a/mm/memcontrol.c
@@ -1248,7 +1248,7 @@ int mem_cgroup_prepare_migration(struct 
 	unlock_page_cgroup(pc);
 
 	if (mem) {
-		ret = mem_cgroup_try_charge(NULL, GFP_HIGHUSER_MOVABLE, &mem);
+		ret = mem_cgroup_try_charge(NULL, GFP_KERNEL, &mem);
 		css_put(&mem->css);
 	}
 	*ptr = mem;
@@ -1378,7 +1378,7 @@ static int mem_cgroup_resize_limit(struc
 			break;
 
 		progress = try_to_free_mem_cgroup_pages(memcg,
-				GFP_HIGHUSER_MOVABLE, false);
+				GFP_KERNEL, false);
   		if (!progress)			retry_count--;
 	}
 	return ret;
@@ -1418,7 +1418,7 @@ int mem_cgroup_resize_memsw_limit(struct
 			break;
 
 		oldusage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
-		try_to_free_mem_cgroup_pages(memcg, GFP_HIGHUSER_MOVABLE, true);
+		try_to_free_mem_cgroup_pages(memcg, GFP_KERNEL, true);
 		curusage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
 		if (curusage >= oldusage)
 			retry_count--;
@@ -1464,7 +1464,7 @@ static int mem_cgroup_force_empty_list(s
 		}
 		spin_unlock_irqrestore(&zone->lru_lock, flags);
 
-		ret = mem_cgroup_move_parent(pc, mem, GFP_HIGHUSER_MOVABLE);
+		ret = mem_cgroup_move_parent(pc, mem, GFP_KERNEL);
 		if (ret == -ENOMEM)
 			break;
 
@@ -1550,7 +1550,7 @@ try_to_free:
 			goto out;
 		}
 		progress = try_to_free_mem_cgroup_pages(mem,
-						  GFP_HIGHUSER_MOVABLE, false);
+						  GFP_KERNEL, false);
 		if (!progress) {
 			nr_retries--;
 			/* maybe some writeback is necessary */
diff -puN mm/memory.c~memcg-revert-gfp-mask-fix mm/memory.c
--- a/mm/memory.c~memcg-revert-gfp-mask-fix
+++ a/mm/memory.c
@@ -1967,7 +1967,7 @@ gotten:
 	cow_user_page(new_page, old_page, address, vma);
 	__SetPageUptodate(new_page);
 
-	if (mem_cgroup_newpage_charge(new_page, mm, GFP_HIGHUSER_MOVABLE))
+	if (mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))
 		goto oom_free_new;
 
 	/*
@@ -2398,8 +2398,7 @@ static int do_swap_page(struct mm_struct
 	lock_page(page);
 	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
 
-	if (mem_cgroup_try_charge_swapin(mm, page,
-				GFP_HIGHUSER_MOVABLE, &ptr) == -ENOMEM) {
+	if (mem_cgroup_try_charge_swapin(mm, page, GFP_KERNEL, &ptr)) {
 		ret = VM_FAULT_OOM;
 		unlock_page(page);
 		goto out;
@@ -2491,7 +2490,7 @@ static int do_anonymous_page(struct mm_s
 		goto oom;
 	__SetPageUptodate(page);
 
-	if (mem_cgroup_newpage_charge(page, mm, GFP_HIGHUSER_MOVABLE))
+	if (mem_cgroup_newpage_charge(page, mm, GFP_KERNEL))
 		goto oom_free_page;
 
 	entry = mk_pte(page, vma->vm_page_prot);
@@ -2582,8 +2581,7 @@ static int __do_fault(struct mm_struct *
 				ret = VM_FAULT_OOM;
 				goto out;
 			}
-			if (mem_cgroup_newpage_charge(page,
-						mm, GFP_HIGHUSER_MOVABLE)) {
+			if (mem_cgroup_newpage_charge(page, mm, GFP_KERNEL)) {
 				ret = VM_FAULT_OOM;
 				page_cache_release(page);
 				goto out;
diff -puN mm/shmem.c~memcg-revert-gfp-mask-fix mm/shmem.c
--- a/mm/shmem.c~memcg-revert-gfp-mask-fix
+++ a/mm/shmem.c
@@ -924,8 +924,8 @@ found:
 	 * Charge page using GFP_HIGHUSER_MOVABLE while we can wait.
 	 * charged back to the user(not to caller) when swap account is used.
 	 */
-	error = mem_cgroup_cache_charge_swapin(page,
-			current->mm, GFP_HIGHUSER_MOVABLE, true);
+	error = mem_cgroup_cache_charge_swapin(page, current->mm, GFP_KERNEL,
+					true);
 	if (error)
 		goto out;
 	error = radix_tree_preload(GFP_KERNEL);
@@ -1267,7 +1267,7 @@ repeat:
 			 * charge against this swap cache here.
 			 */
 			if (mem_cgroup_cache_charge_swapin(swappage,
-						current->mm, gfp, false)) {
+				current->mm, gfp & GFP_RECLAIM_MASK, false)) {
 				page_cache_release(swappage);
 				error = -ENOMEM;
 				goto failed;
@@ -1385,7 +1385,7 @@ repeat:
 
 			/* Precharge page while we can wait, compensate after */
 			error = mem_cgroup_cache_charge(filepage, current->mm,
-					GFP_HIGHUSER_MOVABLE);
+					GFP_KERNEL);
 			if (error) {
 				page_cache_release(filepage);
 				shmem_unacct_blocks(info->flags, 1);
diff -puN mm/swapfile.c~memcg-revert-gfp-mask-fix mm/swapfile.c
--- a/mm/swapfile.c~memcg-revert-gfp-mask-fix
+++ a/mm/swapfile.c
@@ -698,8 +698,7 @@ static int unuse_pte(struct vm_area_stru
 	pte_t *pte;
 	int ret = 1;
 
-	if (mem_cgroup_try_charge_swapin(vma->vm_mm, page,
-					GFP_HIGHUSER_MOVABLE, &ptr))
+	if (mem_cgroup_try_charge_swapin(vma->vm_mm, page, GFP_KERNEL, &ptr))
 		ret = -ENOMEM;
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

vmscan-evict-streaming-io-first.patch
mm-gup-persist-for-write-permission.patch
mm-wp-lock-page-before-deciding-cow.patch
mm-reuse_swap_page-replaces-can_share_swap_page.patch
mm-try_to_free_swap-replaces-remove_exclusive_swap_page.patch
mm-try_to_unuse-check-removing-right-swap.patch
mm-remove-try_to_munlock-from-vmscan.patch
mm-remove-gfp_mask-from-add_to_swap.patch
mm-add-add_to_swap-stub.patch
mm-optimize-get_scan_ratio-for-no-swap.patch
memcg-reclaim-shouldnt-change-zone-recent_rotated-statistics.patch
swapfile-swapon-needs-larger-size-type.patch
swapfile-remove-swp_active-mask.patch
swapfile-remove-surplus-whitespace.patch
swapfile-remove-v0-swap-space-message.patch
swapfile-rearrange-scan-and-swap_info.patch
swapfile-swapon-use-discard-trim.patch
swapfile-swap-allocation-use-discard.patch
swapfile-swapon-randomize-if-nonrot.patch
swapfile-swap-allocation-cycle-if-nonrot.patch
swapfile-change-discard-pgoff_t-to-sector_t.patch
swapfile-change-discard-pgoff_t-to-sector_t-fix.patch
swapfile-let-others-seed-random.patch
cgroups-make-cgroup-config-a-submenu.patch
cgroups-documentation-updates.patch
cgroups-remove-some-redundant-null-checks.patch
ns_cgroup-remove-unused-spinlock.patch
memcg-fix-a-typo-in-kconfig.patch
cgroups-add-lock-for-child-cgroups-in-cgroup_post_fork.patch
cgroups-fix-cgroup_iter_next-bug.patch
cgroups-dont-put-struct-cgroupfs_root-protected-by-rcu.patch
cgroups-use-task_lock-for-access-tsk-cgroups-safe-in-cgroup_clone.patch
cgroups-call-find_css_set-safely-in-cgroup_attach_task.patch
cgroups-remove-rcu_read_lock-in-cgroupstats_build.patch
cgroups-make-root_list-contains-active-hierarchies-only.patch
cgroups-add-inactive-subsystems-to-rootnodesubsys_list.patch
cgroups-introduce-link_css_set-to-remove-duplicate-code.patch
devcgroup-use-list_for_each_entry_rcu.patch
memcg-introduce-charge-commit-cancel-style-of-functions.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-fix-gfp_mask-of-callers-of-charge.patch
memcg-simple-migration-handling.patch
memcg-do-not-recalculate-section-unnecessarily-in-init_section_page_cgroup.patch
memcg-move-all-acccounts-to-parent-at-rmdir.patch
memcg-reduce-size-of-mem_cgroup-by-using-nr_cpu_ids.patch
memcg-new-force_empty-to-free-pages-under-group.patch
memcg-new-force_empty-to-free-pages-under-group-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-memswap-controller-kconfig.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
memcg-synchronized-lru.patch
memcg-add-mem_cgroup_disabled.patch
memcg-add-mem_cgroup_disabled-fix.patch
memory-cgroup-hierarchy-documentation-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-fix-for-hierarchical-reclaim.patch
memory-cgroup-hierarchy-feature-selector-v4.patch
memory-cgroup-hierarchy-feature-selector-v4-fix.patch
memcontrol-rcu_read_lock-to-protect-mm_match_cgroup.patch
memcg-avoid-unnecessary-system-wide-oom-killer.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
memcg-fix-reclaim-result-checks.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-explain-details-and-test-document.patch
cpuset-rcu_read_lock-to-protect-task_cs.patch

