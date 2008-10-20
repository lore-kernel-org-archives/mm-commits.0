From: akpm@linux-foundation.org
Subject: - memcg-move-charge-swapin-under-lock.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:36:28 -0700
Message-ID: <200810202036.m9KKaSED011380@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754691AbYJTUrg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:47:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: move charge swapin under lock
has been removed from the -mm tree.  Its filename was
     memcg-move-charge-swapin-under-lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: move charge swapin under lock
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

While page-cache's charge/uncharge is done under page_lock(), swap-cache
isn't.  (anonymous page is charged when it's newly allocated.)

This patch moves do_swap_page()'s charge() call under lock.  I don't see
any bad problem *now* but this fix will be good for future for avoiding
unnecessary racy state.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN mm/memory.c~memcg-move-charge-swapin-under-lock mm/memory.c
--- a/mm/memory.c~memcg-move-charge-swapin-under-lock
+++ a/mm/memory.c
@@ -2326,16 +2326,17 @@ static int do_swap_page(struct mm_struct
 		count_vm_event(PGMAJFAULT);
 	}
 
+	mark_page_accessed(page);
+
+	lock_page(page);
+	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
+
 	if (mem_cgroup_charge(page, mm, GFP_KERNEL)) {
-		delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
 		ret = VM_FAULT_OOM;
+		unlock_page(page);
 		goto out;
 	}
 
-	mark_page_accessed(page);
-	lock_page(page);
-	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
