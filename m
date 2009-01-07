From: akpm@linux-foundation.org
Subject: - memcg-memswap-controller-core-swapcache-fixes.patch removed from -mm tree
Date: Wed, 07 Jan 2009 15:11:56 -0800
Message-ID: <200901072311.n07NBuw2029789@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754968AbZAGXMl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 18:12:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     memcg: memswap controller core swapcache fixes
has been removed from the -mm tree.  Its filename was
     memcg-memswap-controller-core-swapcache-fixes.patch

This patch was dropped because it was folded into memcg-memswap-controller-core.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: memswap controller core swapcache fixes
From: Hugh Dickins <hugh@veritas.com>

Two SwapCache bug fixes to mmotm's memcg-memswap-controller-core.patch:

One bug is independent of my current changes: there is no guarantee that
the page passed to mem_cgroup_try_charge_swapin() is still in SwapCache.

The other bug is a consequence of my changes, but the fix is okay without
them: mem_cgroup_commit_charge_swapin() expects swp_entry in
page->private, but now reuse_swap_page() (formerly can_share_swap_page())
might already have done delete_from_swap_cache(): move
commit_charge_swapin() earlier.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++++++++
 mm/memory.c     |   15 +++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-memswap-controller-core-swapcache-fixes mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-memswap-controller-core-swapcache-fixes
+++ a/mm/memcontrol.c
@@ -848,6 +848,14 @@ int mem_cgroup_try_charge_swapin(struct 
 	if (!do_swap_account)
 		goto charge_cur_mm;
 
+	/*
+	 * A racing thread's fault, or swapoff, may have already updated
+	 * the pte, and even removed page from swap cache: return success
+	 * to go on to do_swap_page()'s pte_same() test, which should fail.
+	 */
+	if (!PageSwapCache(page))
+		return 0;
+
 	ent.val = page_private(page);
 
 	mem = lookup_swap_cgroup(ent);
diff -puN mm/memory.c~memcg-memswap-controller-core-swapcache-fixes mm/memory.c
--- a/mm/memory.c~memcg-memswap-controller-core-swapcache-fixes
+++ a/mm/memory.c
@@ -2363,8 +2363,20 @@ static int do_swap_page(struct mm_struct
 		goto out_nomap;
 	}
 
-	/* The page isn't present yet, go ahead with the fault. */
+	/*
+	 * The page isn't present yet, go ahead with the fault.
+	 *
+	 * Be careful about the sequence of operations here.
+	 * To get its accounting right, reuse_swap_page() must be called
+	 * while the page is counted on swap but not yet in mapcount i.e.
+	 * before page_add_anon_rmap() and swap_free(); try_to_free_swap()
+	 * must be called after the swap_free(), or it will never succeed.
+	 * And mem_cgroup_commit_charge_swapin(), which uses the swp_entry
+	 * in page->private, must be called before reuse_swap_page(),
+	 * which may delete_from_swap_cache().
+	 */
 
+	mem_cgroup_commit_charge_swapin(page, ptr);
 	inc_mm_counter(mm, anon_rss);
 	pte = mk_pte(page, vma->vm_page_prot);
 	if (write_access && reuse_swap_page(page)) {
@@ -2375,7 +2387,6 @@ static int do_swap_page(struct mm_struct
 	flush_icache_page(vma, page);
 	set_pte_at(mm, address, page_table, pte);
 	page_add_anon_rmap(page, vma, address);
-	mem_cgroup_commit_charge_swapin(page, ptr);
 
 	swap_free(entry);
 	if (vm_swap_full() || (vma->vm_flags & VM_LOCKED) || PageMlocked(page))
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
memcg-handle-swap-caches.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-swapcache-fixes.patch
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
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-explain-details-and-test-document.patch
memcg-fix-swap-accounting-leak-v3.patch
memcg-fix-swap-accounting-leak-doc-fix.patch
memcg-fix-shmems-swap-accounting.patch
prio_tree-debugging-patch.patch

