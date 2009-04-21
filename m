From: akpm@linux-foundation.org
Subject: + mm-fix-pageref-leak-in-do_swap_page.patch added to -mm tree
Date: Tue, 21 Apr 2009 12:45:43 -0700
Message-ID: <200904211945.n3LJjhkS027153@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756070AbZDUTsr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Apr 2009 15:48:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com


The patch titled
     mm: fix pageref leak in do_swap_page()
has been added to the -mm tree.  Its filename is
     mm-fix-pageref-leak-in-do_swap_page.patch

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

vmscanmemcg-reintroduce-sc-may_swap.patch
mm-fix-pageref-leak-in-do_swap_page.patch
linux-next.patch

