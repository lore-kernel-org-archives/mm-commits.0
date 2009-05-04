From: akpm@linux-foundation.org
Subject: [merged] mm-fix-pageref-leak-in-do_swap_page.patch removed from -mm tree
Date: Mon, 04 May 2009 13:12:24 -0700
Message-ID: <200905042012.n44KCOb6021854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753860AbZEDUQN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 16:16:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: fix pageref leak in do_swap_page()
has been removed from the -mm tree.  Its filename was
     mm-fix-pageref-leak-in-do_swap_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix pageref leak in do_swap_page()
From: Johannes Weiner <hannes@cmpxchg.org>

By the time the memory cgroup code is notified about a swapin we
already hold a reference on the fault page.

If the cgroup callback fails make sure to unlock AND release the page
reference which was taken by lookup_swap_cach(), or we leak the reference.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~mm-fix-pageref-leak-in-do_swap_page mm/memory.c
--- a/mm/memory.c~mm-fix-pageref-leak-in-do_swap_page
+++ a/mm/memory.c
@@ -2458,8 +2458,7 @@ static int do_swap_page(struct mm_struct
 
 	if (mem_cgroup_try_charge_swapin(mm, page, GFP_KERNEL, &ptr)) {
 		ret = VM_FAULT_OOM;
-		unlock_page(page);
-		goto out;
+		goto out_page;
 	}
 
 	/*
@@ -2521,6 +2520,7 @@ out:
 out_nomap:
 	mem_cgroup_cancel_charge_swapin(ptr);
 	pte_unmap_unlock(page_table, ptl);
+out_page:
 	unlock_page(page);
 	page_cache_release(page);
 	return ret;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
linux-next.patch
eliminate-thousands-of-warnings-with-gcc-32-build.patch
eliminate-thousands-of-warnings-with-gcc-32-build-cleanup.patch
mm-page-writebackc-dirty-limit-type-should-be-unsigned-long.patch

