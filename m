From: akpm@linux-foundation.org
Subject: + memcg-fix-shmems-swap-accounting.patch added to -mm tree
Date: Mon, 22 Dec 2008 15:38:05 -0800
Message-ID: <200812222338.mBMNc50J002451@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753952AbYLVXjA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Dec 2008 18:39:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, hugh@veritas.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: fix shmem's swap accounting
has been added to the -mm tree.  Its filename is
     memcg-fix-shmems-swap-accounting.patch

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
Subject: memcg: fix shmem's swap accounting
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, you can see following even when swap accounting is enabled.

 1. Create Group 01, and 02.
 2. allocate a "file" on tmpfs by a task under 01.
 3. swap out the "file" (by memory pressure)
 4. Read "file" from a task in group 02.
 5. the charge of "file" is moved to group 02.

This is not ideal behavior. This is because SwapCache which was loaded
by read-ahead is not taken into account..

This is a patch to fix shmem's swapcache behavior.
  - remove mem_cgroup_cache_charge_swapin().
  - Add SwapCache handler routine to mem_cgroup_cache_charge().
    By this, shmem's file cache is charged at add_to_page_cache()
    with GFP_NOWAIT.
  - pass the page of swapcache to shrink_mem_cgroup.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 +
 include/linux/swap.h       |    8 --
 mm/memcontrol.c            |  134 +++++++++++++++--------------------
 mm/shmem.c                 |   30 +++----
 4 files changed, 76 insertions(+), 102 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-fix-shmems-swap-accounting include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-fix-shmems-swap-accounting
+++ a/include/linux/memcontrol.h
@@ -56,7 +56,8 @@ extern void mem_cgroup_move_lists(struct
 				  enum lru_list from, enum lru_list to);
 extern void mem_cgroup_uncharge_page(struct page *page);
 extern void mem_cgroup_uncharge_cache_page(struct page *page);
-extern int mem_cgroup_shrink_usage(struct mm_struct *mm, gfp_t gfp_mask);
+extern int mem_cgroup_shrink_usage(struct page *page,
+			struct mm_struct *mm, gfp_t gfp_mask);
 
 extern unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
 					struct list_head *dst,
@@ -155,7 +156,8 @@ static inline void mem_cgroup_uncharge_c
 {
 }
 
-static inline int mem_cgroup_shrink_usage(struct mm_struct *mm, gfp_t gfp_mask)
+static inline int mem_cgroup_shrink_usage(struct page *page,
+			struct mm_struct *mm, gfp_t gfp_mask)
 {
 	return 0;
 }
diff -puN include/linux/swap.h~memcg-fix-shmems-swap-accounting include/linux/swap.h
--- a/include/linux/swap.h~memcg-fix-shmems-swap-accounting
+++ a/include/linux/swap.h
@@ -338,16 +338,8 @@ static inline void disable_swap_token(vo
 }
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
-extern int mem_cgroup_cache_charge_swapin(struct page *page,
-				struct mm_struct *mm, gfp_t mask, bool locked);
 extern void mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent);
 #else
-static inline
-int mem_cgroup_cache_charge_swapin(struct page *page,
-				struct mm_struct *mm, gfp_t mask, bool locked)
-{
-	return 0;
-}
 static inline void
 mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent)
 {
diff -puN mm/memcontrol.c~memcg-fix-shmems-swap-accounting mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-shmems-swap-accounting
+++ a/mm/memcontrol.c
@@ -888,6 +888,23 @@ nomem:
 	return -ENOMEM;
 }
 
+static struct mem_cgroup *try_get_mem_cgroup_from_swapcache(struct page *page)
+{
+	struct mem_cgroup *mem;
+	swp_entry_t ent;
+
+	if (!PageSwapCache(page))
+		return NULL;
+
+	ent.val = page_private(page);
+	mem = lookup_swap_cgroup(ent);
+	if (!mem)
+		return NULL;
+	if (!css_tryget(&mem->css))
+		return NULL;
+	return mem;
+}
+
 /*
  * commit a charge got by __mem_cgroup_try_charge() and makes page_cgroup to be
  * USED state. If already USED, uncharge and return.
@@ -1079,6 +1096,9 @@ int mem_cgroup_newpage_charge(struct pag
 int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask)
 {
+	struct mem_cgroup *mem = NULL;
+	int ret;
+
 	if (mem_cgroup_disabled())
 		return 0;
 	if (PageCompound(page))
@@ -1091,6 +1111,8 @@ int mem_cgroup_cache_charge(struct page 
 	 * For GFP_NOWAIT case, the page may be pre-charged before calling
 	 * add_to_page_cache(). (See shmem.c) check it here and avoid to call
 	 * charge twice. (It works but has to pay a bit larger cost.)
+	 * And when the page is SwapCache, it should take swap information
+	 * into account. This is under lock_page() now.
 	 */
 	if (!(gfp_mask & __GFP_WAIT)) {
 		struct page_cgroup *pc;
@@ -1107,15 +1129,40 @@ int mem_cgroup_cache_charge(struct page 
 		unlock_page_cgroup(pc);
 	}
 
-	if (unlikely(!mm))
+	if (do_swap_account && PageSwapCache(page)) {
+		mem = try_get_mem_cgroup_from_swapcache(page);
+		if (mem)
+			mm = NULL;
+		  else
+			mem = NULL;
+		/* SwapCache may be still linked to LRU now. */
+		mem_cgroup_lru_del_before_commit_swapcache(page);
+	}
+
+	if (unlikely(!mm && !mem))
 		mm = &init_mm;
 
 	if (page_is_file_cache(page))
 		return mem_cgroup_charge_common(page, mm, gfp_mask,
 				MEM_CGROUP_CHARGE_TYPE_CACHE, NULL);
-	else
-		return mem_cgroup_charge_common(page, mm, gfp_mask,
-				MEM_CGROUP_CHARGE_TYPE_SHMEM, NULL);
+
+	ret = mem_cgroup_charge_common(page, mm, gfp_mask,
+				MEM_CGROUP_CHARGE_TYPE_SHMEM, mem);
+	if (mem)
+		css_put(&mem->css);
+	if (PageSwapCache(page))
+		mem_cgroup_lru_add_after_commit_swapcache(page);
+
+	if (do_swap_account && !ret && PageSwapCache(page)) {
+		swp_entry_t ent = {.val = page_private(page)};
+		/* avoid double counting */
+		mem = swap_cgroup_record(ent, NULL);
+		if (mem) {
+			res_counter_uncharge(&mem->memsw, PAGE_SIZE);
+			mem_cgroup_put(mem);
+		}
+	}
+	return ret;
 }
 
 /*
@@ -1129,7 +1176,6 @@ int mem_cgroup_try_charge_swapin(struct 
 				 gfp_t mask, struct mem_cgroup **ptr)
 {
 	struct mem_cgroup *mem;
-	swp_entry_t     ent;
 	int ret;
 
 	if (mem_cgroup_disabled())
@@ -1137,7 +1183,6 @@ int mem_cgroup_try_charge_swapin(struct 
 
 	if (!do_swap_account)
 		goto charge_cur_mm;
-
 	/*
 	 * A racing thread's fault, or swapoff, may have already updated
 	 * the pte, and even removed page from swap cache: return success
@@ -1145,14 +1190,9 @@ int mem_cgroup_try_charge_swapin(struct 
 	 */
 	if (!PageSwapCache(page))
 		return 0;
-
-	ent.val = page_private(page);
-
-	mem = lookup_swap_cgroup(ent);
+	mem = try_get_mem_cgroup_from_swapcache(page);
 	if (!mem)
 		goto charge_cur_mm;
-	if (!css_tryget(&mem->css))
-		goto charge_cur_mm;
 	*ptr = mem;
 	ret = __mem_cgroup_try_charge(NULL, mask, ptr, true);
 	/* drop extra refcnt from tryget */
@@ -1164,62 +1204,6 @@ charge_cur_mm:
 	return __mem_cgroup_try_charge(mm, mask, ptr, true);
 }
 
-#ifdef CONFIG_SWAP
-
-int mem_cgroup_cache_charge_swapin(struct page *page,
-			struct mm_struct *mm, gfp_t mask, bool locked)
-{
-	int ret = 0;
-
-	if (mem_cgroup_disabled())
-		return 0;
-	if (unlikely(!mm))
-		mm = &init_mm;
-	if (!locked)
-		lock_page(page);
-	/*
-	 * If not locked, the page can be dropped from SwapCache until
-	 * we reach here.
-	 */
-	if (PageSwapCache(page)) {
-		struct mem_cgroup *mem = NULL;
-		swp_entry_t ent;
-
-		ent.val = page_private(page);
-		if (do_swap_account) {
-			mem = lookup_swap_cgroup(ent);
-			if (mem) {
-				if (css_tryget(&mem->css))
-					mm = NULL; /* charge to recorded */
-				else
-					mem = NULL; /* charge to current */
-			}
-		}
-		/* SwapCache may be still linked to LRU now. */
-		mem_cgroup_lru_del_before_commit_swapcache(page);
-		ret = mem_cgroup_charge_common(page, mm, mask,
-				MEM_CGROUP_CHARGE_TYPE_SHMEM, mem);
-		mem_cgroup_lru_add_after_commit_swapcache(page);
-		/* drop extra refcnt from tryget */
-		if (mem)
-			css_put(&mem->css);
-
-		if (!ret && do_swap_account) {
-			/* avoid double counting */
-			mem = swap_cgroup_record(ent, NULL);
-			if (mem) {
-				res_counter_uncharge(&mem->memsw, PAGE_SIZE);
-				mem_cgroup_put(mem);
-			}
-		}
-	}
-	if (!locked)
-		unlock_page(page);
-
-	return ret;
-}
-#endif
-
 void mem_cgroup_commit_charge_swapin(struct page *page, struct mem_cgroup *ptr)
 {
 	struct page_cgroup *pc;
@@ -1481,18 +1465,20 @@ void mem_cgroup_end_migration(struct mem
  * This is typically used for page reclaiming for shmem for reducing side
  * effect of page allocation from shmem, which is used by some mem_cgroup.
  */
-int mem_cgroup_shrink_usage(struct mm_struct *mm, gfp_t gfp_mask)
+int mem_cgroup_shrink_usage(struct page *page,
+			    struct mm_struct *mm,
+			    gfp_t gfp_mask)
 {
-	struct mem_cgroup *mem;
+	struct mem_cgroup *mem = NULL;
 	int progress = 0;
 	int retry = MEM_CGROUP_RECLAIM_RETRIES;
 
 	if (mem_cgroup_disabled())
 		return 0;
-	if (!mm)
-		return 0;
-
-	mem = try_get_mem_cgroup_from_mm(mm);
+	if (page)
+		mem = try_get_mem_cgroup_from_swapcache(page);
+	if (!mem && mm)
+		mem = try_get_mem_cgroup_from_mm(mm);
 	if (unlikely(!mem))
 		return 0;
 
diff -puN mm/shmem.c~memcg-fix-shmems-swap-accounting mm/shmem.c
--- a/mm/shmem.c~memcg-fix-shmems-swap-accounting
+++ a/mm/shmem.c
@@ -929,11 +929,11 @@ found:
 	if (!inode)
 		goto out;
 	/*
-	 * Charge page using GFP_HIGHUSER_MOVABLE while we can wait.
-	 * charged back to the user(not to caller) when swap account is used.
+	 * Charge page using GFP_KERNEL while we can wait.
+	 * Charged back to the user(not to caller) when swap account is used.
+	 * add_to_page_cache() will be called with GFP_NOWAIT.
 	 */
-	error = mem_cgroup_cache_charge_swapin(page, current->mm, GFP_KERNEL,
-					true);
+	error = mem_cgroup_cache_charge(page, current->mm, GFP_KERNEL);
 	if (error)
 		goto out;
 	error = radix_tree_preload(GFP_KERNEL);
@@ -1270,16 +1270,6 @@ repeat:
 				goto repeat;
 			}
 			wait_on_page_locked(swappage);
-			/*
-			 * We want to avoid charge at add_to_page_cache().
-			 * charge against this swap cache here.
-			 */
-			if (mem_cgroup_cache_charge_swapin(swappage,
-				current->mm, gfp & GFP_RECLAIM_MASK, false)) {
-				page_cache_release(swappage);
-				error = -ENOMEM;
-				goto failed;
-			}
 			page_cache_release(swappage);
 			goto repeat;
 		}
@@ -1334,15 +1324,19 @@ repeat:
 		} else {
 			shmem_swp_unmap(entry);
 			spin_unlock(&info->lock);
-			unlock_page(swappage);
-			page_cache_release(swappage);
 			if (error == -ENOMEM) {
 				/* allow reclaim from this memory cgroup */
-				error = mem_cgroup_shrink_usage(current->mm,
+				error = mem_cgroup_shrink_usage(swappage,
+								current->mm,
 								gfp);
-				if (error)
+				if (error) {
+					unlock_page(swappage);
+					page_cache_release(swappage);
 					goto failed;
+				}
 			}
+			unlock_page(swappage);
+			page_cache_release(swappage);
 			goto repeat;
 		}
 	} else if (sgp == SGP_READ && !filepage) {
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

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
mm-remove-config_out_of_line_pfn_to_page.patch
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
cgroups-add-inactive-subsystems-to-rootnodesubsys_list-fix.patch
cgroups-introduce-link_css_set-to-remove-duplicate-code.patch
cgroups-introduce-link_css_set-to-remove-duplicate-code-fix.patch
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
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-fix-calclation-of-active_ratio.patch
memcg-fix-calclation-of-active_ratio-build-error-fix.patch
memcg-show-real-limit-under-hierarchy-mode.patch
memcg-explain-details-and-test-document.patch
memcg-explain-details-and-test-document-fix.patch
memcg-dont-trigger-oom-at-page-migration.patch
memcg-remove-mem_cgroup_try_charge.patch
memcg-avoid-dead-lock-caused-by-race-between-oom-and-cpuset_attach.patch
memcg-change-try_to_free_pages-to-hierarchical_reclaim.patch
memcg-fix-swap-accounting-leak-v3.patch
memcg-fix-swap-accounting-leak-doc-fix.patch
memcg-fix-double-free-and-make-refcnt-sane.patch
memcg-use-css_tryget-in-memcg.patch
memcg-use-css_tryget-in-memcg-fix.patch
memcg-fix-lru-accounting-for-swapcache-v2.patch
memcg-fix-shmems-swap-accounting.patch
cgroups-add-a-per-subsystem-hierarchy_mutex.patch
cgroups-use-hierarchy_mutex-in-memory-controller.patch
cgroups-add-css_tryget.patch
cpuset-rcu_read_lock-to-protect-task_cs.patch

