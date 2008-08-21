From: akpm@linux-foundation.org
Subject: - mm-show-free-swap-as-signed.patch removed from -mm tree
Date: Wed, 20 Aug 2008 20:49:15 -0700
Message-ID: <200808210349.m7L3nFCN015623@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753283AbYHUDtW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 23:49:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm: show free swap as signed
has been removed from the -mm tree.  Its filename was
     mm-show-free-swap-as-signed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: show free swap as signed
From: Hugh Dickins <hugh@veritas.com>

Adjust <Alt><SysRq>m show_swap_cache_info() to show "Free swap" as a
signed long: the signed format is preferable, because during swapoff
nr_swap_pages can legitimately go negative, so makes more sense thus
(it used to be shown redundantly, once as signed and once as unsigned).

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swap_state.c~mm-show-free-swap-as-signed mm/swap_state.c
--- a/mm/swap_state.c~mm-show-free-swap-as-signed
+++ a/mm/swap_state.c
@@ -60,7 +60,7 @@ void show_swap_cache_info(void)
 	printk("Swap cache stats: add %lu, delete %lu, find %lu/%lu\n",
 		swap_cache_info.add_total, swap_cache_info.del_total,
 		swap_cache_info.find_success, swap_cache_info.find_total);
-	printk("Free swap  = %lukB\n", nr_swap_pages << (PAGE_SHIFT - 10));
+	printk("Free swap  = %ldkB\n", nr_swap_pages << (PAGE_SHIFT - 10));
 	printk("Total swap = %lukB\n", total_swap_pages << (PAGE_SHIFT - 10));
 }
 
_

Patches currently in -mm which might be from hugh@veritas.com are

memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
mm-owner-fix-race-between-swap-and-exit.patch
mm-owner-fix-race-between-swap-and-exit-fix.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
vmscan-unevictable-lru-scan-sysctl.patch
mmapc-deinline-a-few-functions.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-enhance-mm_owner_changed-callback-to-deal-with-exited-owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
make-mm-rmapc-anon_vma_cachep-static.patch
prio_tree-debugging-patch.patch

