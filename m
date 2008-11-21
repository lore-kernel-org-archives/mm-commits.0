From: akpm@linux-foundation.org
Subject: - memcg-swap-cgroup-for-remembering-usage-fix-4.patch removed from -mm tree
Date: Fri, 21 Nov 2008 15:16:06 -0800
Message-ID: <200811212316.mALNG6Ka018014@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754507AbYKUXQV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 18:16:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     memcg: avoid using buggy kmap at swap_cgroup
has been removed from the -mm tree.  Its filename was
     memcg-swap-cgroup-for-remembering-usage-fix-4.patch

This patch was dropped because an updated version will be merged

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

origin.patch
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
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage-fix-4.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
prio_tree-debugging-patch.patch

