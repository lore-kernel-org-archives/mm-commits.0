From: akpm@linux-foundation.org
Subject: + mm-show-free-swap-as-signed.patch added to -mm tree
Date: Mon, 18 Aug 2008 15:34:44 -0700
Message-ID: <200808182234.m7IMYicC016599@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59344 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753994AbYHRWfU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 18:35:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     mm: show free swap as signed
has been added to the -mm tree.  Its filename is
     mm-show-free-swap-as-signed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
mm-page_remove_rmap-comments-on-pageanon.patch
mm-show-free-swap-as-signed.patch
linux-next.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
mm-owner-fix-race-between-swap-and-exit.patch
mm-owner-fix-race-between-swap-and-exit-fix.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
mlock-mlocked-pages-are-unevictable.patch
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

