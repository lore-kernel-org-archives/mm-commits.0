From: akpm@linux-foundation.org
Subject: + memcg-swap-cgroup-for-remembering-usage-fix-4.patch added to -mm tree
Date: Tue, 18 Nov 2008 23:44:27 -0800
Message-ID: <200811190744.mAJ7iRVn021314@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750747AbYKSHol (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Nov 2008 02:44:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp, xemul@openvz.org


The patch titled
     memcg: avoid using buggy kmap at swap_cgroup
has been added to the -mm tree.  Its filename is
     memcg-swap-cgroup-for-remembering-usage-fix-4.patch

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
Subject: memcg: avoid using buggy kmap at swap_cgroup
From: Hugh Dickins <hugh@veritas.com>

swap_cgroup's kmap logic conflicts shmem's kmap logic.
avoid to use HIGHMEM for now and revisit this later.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Hugh Dickins <hugh@veritas.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN mm/page_cgroup.c~memcg-swap-cgroup-for-remembering-usage-fix-4 mm/page_cgroup.c
--- a/mm/page_cgroup.c~memcg-swap-cgroup-for-remembering-usage-fix-4
+++ a/mm/page_cgroup.c
@@ -305,7 +305,7 @@ static int swap_cgroup_prepare(int type)
 	ctrl = &swap_cgroup_ctrl[type];
 
 	for (idx = 0; idx < ctrl->length; idx++) {
-		page = alloc_page(GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO);
+		page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 		if (!page)
 			goto not_enough_page;
 		ctrl->map[idx] = page;
@@ -346,11 +346,10 @@ struct mem_cgroup *swap_cgroup_record(sw
 
 	mappage = ctrl->map[idx];
 	spin_lock_irqsave(&ctrl->lock, flags);
-	sc = kmap_atomic(mappage, KM_USER0);
+	sc = page_address(mappage);
 	sc += pos;
 	old = sc->val;
 	sc->val = mem;
-	kunmap_atomic((void *)sc, KM_USER0);
 	spin_unlock_irqrestore(&ctrl->lock, flags);
 	return old;
 }
@@ -381,10 +380,9 @@ struct mem_cgroup *lookup_swap_cgroup(sw
 	mappage = ctrl->map[idx];
 
 	spin_lock_irqsave(&ctrl->lock, flags);
-	sc = kmap_atomic(mappage, KM_USER0);
+	sc = page_address(mappage);
 	sc += pos;
 	ret = sc->val;
-	kunmap_atomic((void *)sc, KM_USER0);
 	spin_unlock_irqrestore(&ctrl->lock, flags);
 	return ret;
 }
_

Patches currently in -mm which might be from hugh@veritas.com are

lib-scatterlistc-fix-kunmap-argument-in-sg_miter_stop.patch
sprint_symbol-use-less-stack.patch
migration-fix-writepage-error.patch
vmscan-let-gfp_nofs-go-to-swap-again.patch
dont-unlink-an-active-swapfile.patch
linux-next.patch
mm-dont-mark_page_accessed-in-shmem_fault.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage-fix-2.patch
memcg-swap-cgroup-for-remembering-usage-fix-3.patch
memcg-swap-cgroup-for-remembering-usage-fix-4.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
prio_tree-debugging-patch.patch

