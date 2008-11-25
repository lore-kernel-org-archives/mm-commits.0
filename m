From: akpm@linux-foundation.org
Subject: + memcg-memswap-controller-core-swapcache-fixes.patch added to -mm tree
Date: Tue, 25 Nov 2008 14:22:19 -0800
Message-ID: <200811252222.mAPMMJBK009279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751443AbYKYWWm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 17:22:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp, xemul@openvz.org


The patch titled
     memcg: memswap controller core swapcache fixes
has been added to the -mm tree.  Its filename is
     memcg-memswap-controller-core-swapcache-fixes.patch

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
@@ -2361,8 +2361,20 @@ static int do_swap_page(struct mm_struct
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
@@ -2373,7 +2385,6 @@ static int do_swap_page(struct mm_struct
 	flush_icache_page(vma, page);
 	set_pte_at(mm, address, page_table, pte);
 	page_add_anon_rmap(page, vma, address);
-	mem_cgroup_commit_charge_swapin(page, ptr);
 
 	swap_free(entry);
 	if (vm_swap_full() || (vma->vm_flags & VM_LOCKED) || PageMlocked(page))
_

Patches currently in -mm which might be from hugh@veritas.com are

linux-next.patch
mm-dont-mark_page_accessed-in-shmem_fault.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
mm-remove-cgroup_mm_owner_callbacks.patch
mm-remove-aop_writepage_activate.patch
mm-remove-gfp_highuser_pagecache.patch
mm-add-setclearpageswapcache-stubs.patch
mm-replace-some-bug_ons-by-vm_bug_ons.patch
mm-add_active_or_unevictable-into-rmap.patch
mm-make-page_lock_anon_vma-static.patch
mm-further-cleanup-page_add_new_anon_rmap.patch
mm-gup-persist-for-write-permission.patch
mm-wp-lock-page-before-deciding-cow.patch
mm-reuse_swap_page-replaces-can_share_swap_page.patch
mm-try_to_free_swap-replaces-remove_exclusive_swap_page.patch
mm-try_to_unuse-check-removing-right-swap.patch
mm-remove-try_to_munlock-from-vmscan.patch
mm-remove-gfp_mask-from-add_to_swap.patch
mm-add-add_to_swap-stub.patch
mm-optimize-get_scan_ratio-for-no-swap.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
prio_tree-debugging-patch.patch

