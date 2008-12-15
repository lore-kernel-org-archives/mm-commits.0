From: akpm@linux-foundation.org
Subject: + memcg-fix-swap-accounting-leak-v3.patch added to -mm tree
Date: Mon, 15 Dec 2008 15:31:26 -0800
Message-ID: <200812152331.mBFNVRRV007689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35911 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752397AbYLOXcF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Dec 2008 18:32:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, hugh@veritas.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: fix swap accounting leak
has been added to the -mm tree.  Its filename is
     memcg-fix-swap-accounting-leak-v3.patch

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
Subject: memcg: fix swap accounting leak
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Fix swapin charge operation of memcg.

Now, memcg has hooks to swap-out operation and checks SwapCache is really
unused or not.  That check depends on contents of struct page.  I.e.  If
PageAnon(page) && page_mapped(page), the page is recoginized as
still-in-use.

Now, reuse_swap_page() calles delete_from_swap_cache() before establishment
of any rmap. Then, in followinig sequence

	(Page fault with WRITE)
	try_charge() (charge += PAGESIZE)
	commit_charge() (Check page_cgroup is used or not..)
	reuse_swap_page()
		-> delete_from_swapcache()
			-> mem_cgroup_uncharge_swapcache() (charge -= PAGESIZE)
	......
New charge is uncharged soon....
To avoid this,  move commit_charge() after page_mapcount() goes up to 1.
By this,

	try_charge()		(usage += PAGESIZE)
	reuse_swap_page()	(may usage -= PAGESIZE if PCG_USED is set)
	commit_charge()		(If page_cgroup is not marked as PCG_USED,
				 add new charge.)
Accounting will be correct.

Changelog (v2) -> (v3)
  - fixed invalid charge to swp_entry==0.
  - updated documentation.
Changelog (v1) -> (v2)
  - fixed comment.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com> 
Tested-by: Balbir Singh <balbir@linux.vnet.ibm.com> 
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/controllers/memcg_test.txt |   41 ++++++++++++++++++---
 mm/memcontrol.c                          |    7 ++-
 mm/memory.c                              |   11 +++--
 3 files changed, 46 insertions(+), 13 deletions(-)

diff -puN Documentation/controllers/memcg_test.txt~memcg-fix-swap-accounting-leak-v3 Documentation/controllers/memcg_test.txt
--- a/Documentation/controllers/memcg_test.txt~memcg-fix-swap-accounting-leak-v3
+++ a/Documentation/controllers/memcg_test.txt
@@ -1,6 +1,6 @@
 Memory Resource Controller(Memcg)  Implementation Memo.
-Last Updated: 2008/12/10
-Base Kernel Version: based on 2.6.28-rc7-mm.
+Last Updated: 2008/12/15
+Base Kernel Version: based on 2.6.28-rc8-mm.
 
 Because VM is getting complex (one of reasons is memcg...), memcg's behavior
 is complex. This is a document for memcg's internal behavior.
@@ -111,9 +111,40 @@ Under below explanation, we assume CONFI
 	(b) If the SwapCache has been mapped by processes, it has been
 	    charged already.
 
-	In case (a), we charge it. In case (b), we don't charge it.
-	(But racy state between (a) and (b) exists. We do check it.)
-	At charging, a charge recorded in swap_cgroup is moved to page_cgroup.
+	This swap-in is one of the most complicated work. In do_swap_page(),
+	following events occur when pte is unchanged.
+
+	(1) the page (SwapCache) is looked up.
+	(2) lock_page()
+	(3) try_charge_swapin()
+	(4) reuse_swap_page() (may call delete_swap_cache())
+	(5) commit_charge_swapin()
+	(6) swap_free().
+
+	Considering following situation for example.
+
+	(A) The page has not been charged before (2) and reuse_swap_page()
+	    doesn't call delete_from_swap_cache().
+	(B) The page has not been charged before (2) and reuse_swap_page()
+	    calls delete_from_swap_cache().
+	(C) The page has been charged before (2) and reuse_swap_page() doesn't
+	    call delete_from_swap_cache().
+	(D) The page has been charged before (2) and reuse_swap_page() calls
+	    delete_from_swap_cache().
+
+	    memory.usage/memsw.usage changes to this page/swp_entry will be
+	 Case          (A)      (B)       (C)     (D)
+         Event
+       Before (2)     0/ 1     0/ 1      1/ 1    1/ 1
+          ===========================================
+          (3)        +1/+1    +1/+1     +1/+1   +1/+1
+          (4)          -       0/ 0       -     -1/ 0
+          (5)         0/ 1     0/-1     -1/-1    0/ 0
+          (6)          -        -         -      0/-1
+          ===========================================
+       Result         1/ 1     1/1       1/ 1    1/ 1
+
+       In any cases, charges to this page should be 1/ 1.
 
 	4.2 Swap-out.
 	At swap-out, typical state transition is below.
diff -puN mm/memcontrol.c~memcg-fix-swap-accounting-leak-v3 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-swap-accounting-leak-v3
+++ a/mm/memcontrol.c
@@ -1139,10 +1139,11 @@ void mem_cgroup_commit_charge_swapin(str
 	/*
 	 * Now swap is on-memory. This means this page may be
 	 * counted both as mem and swap....double count.
-	 * Fix it by uncharging from memsw. This SwapCache is stable
-	 * because we're still under lock_page().
+	 * Fix it by uncharging from memsw. Basically, this SwapCache is stable
+	 * under lock_page(). But in do_swap_page()::memory.c, reuse_swap_page()
+	 * may call delete_from_swap_cache() before reach here.
 	 */
-	if (do_swap_account) {
+	if (do_swap_account && PageSwapCache(page)) {
 		swp_entry_t ent = {.val = page_private(page)};
 		struct mem_cgroup *memcg;
 		memcg = swap_cgroup_record(ent, NULL);
diff -puN mm/memory.c~memcg-fix-swap-accounting-leak-v3 mm/memory.c
--- a/mm/memory.c~memcg-fix-swap-accounting-leak-v3
+++ a/mm/memory.c
@@ -2428,22 +2428,23 @@ static int do_swap_page(struct mm_struct
 	 * while the page is counted on swap but not yet in mapcount i.e.
 	 * before page_add_anon_rmap() and swap_free(); try_to_free_swap()
 	 * must be called after the swap_free(), or it will never succeed.
-	 * And mem_cgroup_commit_charge_swapin(), which uses the swp_entry
-	 * in page->private, must be called before reuse_swap_page(),
-	 * which may delete_from_swap_cache().
+	 * Because delete_from_swap_page() may be called by reuse_swap_page(),
+	 * mem_cgroup_commit_charge_swapin() may not be able to find swp_entry
+	 * in page->private. In this case, a record in swap_cgroup  is silently
+	 * discarded at swap_free().
 	 */
 
-	mem_cgroup_commit_charge_swapin(page, ptr);
 	inc_mm_counter(mm, anon_rss);
 	pte = mk_pte(page, vma->vm_page_prot);
 	if (write_access && reuse_swap_page(page)) {
 		pte = maybe_mkwrite(pte_mkdirty(pte), vma);
 		write_access = 0;
 	}
-
 	flush_icache_page(vma, page);
 	set_pte_at(mm, address, page_table, pte);
 	page_add_anon_rmap(page, vma, address);
+	/* It's better to call commit-charge after rmap is established */
+	mem_cgroup_commit_charge_swapin(page, ptr);
 
 	swap_free(entry);
 	if (vm_swap_full() || (vma->vm_flags & VM_LOCKED) || PageMlocked(page))
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

clocksource-pass-clocksource-to-read-callback-fix.patch
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
memcg-explain-details-and-test-document.patch
memcg-explain-details-and-test-document-fix.patch
memcg-dont-trigger-oom-at-page-migration.patch
memcg-remove-mem_cgroup_try_charge.patch
memcg-avoid-dead-lock-caused-by-race-between-oom-and-cpuset_attach.patch
memcg-change-try_to_free_pages-to-hierarchical_reclaim.patch
memcg-fix-swap-accounting-leak-v3.patch
cpuset-rcu_read_lock-to-protect-task_cs.patch

