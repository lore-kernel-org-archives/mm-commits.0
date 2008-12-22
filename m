From: akpm@linux-foundation.org
Subject: + memcg-fix-lru-accounting-for-swapcache-v2.patch added to -mm tree
Date: Mon, 22 Dec 2008 15:36:18 -0800
Message-ID: <200812222336.mBMNaI2P001116@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37501 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754543AbYLVXhD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Dec 2008 18:37:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: fix LRU accounting for SwapCache
has been added to the -mm tree.  Its filename is
     memcg-fix-lru-accounting-for-swapcache-v2.patch

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
Subject: memcg: fix LRU accounting for SwapCache
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, a page can be deleted from SwapCache while do_swap_page(). 
memcg-fix-swap-accounting-leak-v3.patch handles that, but, LRU handling is
still broken.  (above behavior broke assumption of memcg-synchronized-lru
patch.)

This patch is a fix for LRU handling (especially for per-zone counters).
At charging SwapCache,
 - Remove page_cgroup from LRU if it's not used.
 - Add page cgroup to LRU if it's not linked to.

Reported-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   59 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 50 insertions(+), 9 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-lru-accounting-for-swapcache-v2 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-lru-accounting-for-swapcache-v2
+++ a/mm/memcontrol.c
@@ -331,8 +331,12 @@ void mem_cgroup_del_lru_list(struct page
 		return;
 	pc = lookup_page_cgroup(page);
 	/* can happen while we handle swapcache. */
-	if (list_empty(&pc->lru))
+	if (list_empty(&pc->lru) || !pc->mem_cgroup)
 		return;
+	/*
+	 * We don't check PCG_USED bit. It's cleared when the "page" is finally
+	 * removed from global LRU.
+	 */
 	mz = page_cgroup_zoneinfo(pc);
 	mem = pc->mem_cgroup;
 	MEM_CGROUP_ZSTAT(mz, lru) -= 1;
@@ -379,16 +383,44 @@ void mem_cgroup_add_lru_list(struct page
 	MEM_CGROUP_ZSTAT(mz, lru) += 1;
 	list_add(&pc->lru, &mz->lists[lru]);
 }
+
 /*
- * To add swapcache into LRU. Be careful to all this function.
- * zone->lru_lock shouldn't be held and irq must not be disabled.
+ * At handling SwapCache, pc->mem_cgroup may be changed while it's linked to
+ * lru because the page may.be reused after it's fully uncharged (because of
+ * SwapCache behavior).To handle that, unlink page_cgroup from LRU when charge
+ * it again. This function is only used to charge SwapCache. It's done under
+ * lock_page and expected that zone->lru_lock is never held.
  */
-static void mem_cgroup_lru_fixup(struct page *page)
+static void mem_cgroup_lru_del_before_commit_swapcache(struct page *page)
+{
+	unsigned long flags;
+	struct zone *zone = page_zone(page);
+	struct page_cgroup *pc = lookup_page_cgroup(page);
+
+	spin_lock_irqsave(&zone->lru_lock, flags);
+	/*
+	 * Forget old LRU when this page_cgroup is *not* used. This Used bit
+	 * is guarded by lock_page() because the page is SwapCache.
+	 */
+	if (!PageCgroupUsed(pc))
+		mem_cgroup_del_lru_list(page, page_lru(page));
+	spin_unlock_irqrestore(&zone->lru_lock, flags);
+}
+
+static void mem_cgroup_lru_add_after_commit_swapcache(struct page *page)
 {
-	if (!isolate_lru_page(page))
-		putback_lru_page(page);
+	unsigned long flags;
+	struct zone *zone = page_zone(page);
+	struct page_cgroup *pc = lookup_page_cgroup(page);
+
+	spin_lock_irqsave(&zone->lru_lock, flags);
+	/* link when the page is linked to LRU but page_cgroup isn't */
+	if (PageLRU(page) && list_empty(&pc->lru))
+		mem_cgroup_add_lru_list(page, page_lru(page));
+	spin_unlock_irqrestore(&zone->lru_lock, flags);
 }
 
+
 void mem_cgroup_move_lists(struct page *page,
 			   enum lru_list from, enum lru_list to)
 {
@@ -1163,8 +1195,11 @@ int mem_cgroup_cache_charge_swapin(struc
 					mem = NULL; /* charge to current */
 			}
 		}
+		/* SwapCache may be still linked to LRU now. */
+		mem_cgroup_lru_del_before_commit_swapcache(page);
 		ret = mem_cgroup_charge_common(page, mm, mask,
 				MEM_CGROUP_CHARGE_TYPE_SHMEM, mem);
+		mem_cgroup_lru_add_after_commit_swapcache(page);
 		/* drop extra refcnt from tryget */
 		if (mem)
 			css_put(&mem->css);
@@ -1180,8 +1215,6 @@ int mem_cgroup_cache_charge_swapin(struc
 	}
 	if (!locked)
 		unlock_page(page);
-	/* add this page(page_cgroup) to the LRU we want. */
-	mem_cgroup_lru_fixup(page);
 
 	return ret;
 }
@@ -1196,7 +1229,9 @@ void mem_cgroup_commit_charge_swapin(str
 	if (!ptr)
 		return;
 	pc = lookup_page_cgroup(page);
+	mem_cgroup_lru_del_before_commit_swapcache(page);
 	__mem_cgroup_commit_charge(ptr, pc, MEM_CGROUP_CHARGE_TYPE_MAPPED);
+	mem_cgroup_lru_add_after_commit_swapcache(page);
 	/*
 	 * Now swap is on-memory. This means this page may be
 	 * counted both as mem and swap....double count.
@@ -1215,7 +1250,7 @@ void mem_cgroup_commit_charge_swapin(str
 
 	}
 	/* add this page(page_cgroup) to the LRU we want. */
-	mem_cgroup_lru_fixup(page);
+
 }
 
 void mem_cgroup_cancel_charge_swapin(struct mem_cgroup *mem)
@@ -1283,6 +1318,12 @@ __mem_cgroup_uncharge_common(struct page
 
 	mem_cgroup_charge_statistics(mem, pc, false);
 	ClearPageCgroupUsed(pc);
+	/*
+	 * pc->mem_cgroup is not cleared here. It will be accessed when it's
+	 * freed from LRU. This is safe because uncharged page is expected not
+	 * to be reused (freed soon). Exception is SwapCache, it's handled by
+	 * special functions.
+	 */
 
 	mz = page_cgroup_zoneinfo(pc);
 	unlock_page_cgroup(pc);
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
cgroups-add-a-per-subsystem-hierarchy_mutex.patch
cgroups-use-hierarchy_mutex-in-memory-controller.patch
cgroups-add-css_tryget.patch
cpuset-rcu_read_lock-to-protect-task_cs.patch

