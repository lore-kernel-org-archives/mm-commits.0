From: akpm@linux-foundation.org
Subject: - memcg-avoid-unnecessary-initialization.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:58:37 -0700
Message-ID: <200807252258.m6PMwbEf003305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752985AbYGYW7O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:59:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, lizf@cn.fujitsu.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     memcg: avoid unnecessary initialization
has been removed from the -mm tree.  Its filename was
     memcg-avoid-unnecessary-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: avoid unnecessary initialization
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

* remove over-killing initialization (in fast path)
* makeing the condition for PAGE_CGROUP_FLAG_ACTIVE be more obvious.

Signed-off-by: KAMEAZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~memcg-avoid-unnecessary-initialization mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-avoid-unnecessary-initialization
+++ a/mm/memcontrol.c
@@ -296,7 +296,7 @@ static void __mem_cgroup_remove_list(str
 		MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_INACTIVE) -= 1;
 
 	mem_cgroup_charge_statistics(pc->mem_cgroup, pc->flags, false);
-	list_del_init(&pc->lru);
+	list_del(&pc->lru);
 }
 
 static void __mem_cgroup_add_list(struct mem_cgroup_per_zone *mz,
@@ -559,7 +559,7 @@ retry:
 	}
 	unlock_page_cgroup(page);
 
-	pc = kmem_cache_zalloc(page_cgroup_cache, gfp_mask);
+	pc = kmem_cache_alloc(page_cgroup_cache, gfp_mask);
 	if (pc == NULL)
 		goto err;
 
@@ -606,9 +606,14 @@ retry:
 	pc->ref_cnt = 1;
 	pc->mem_cgroup = mem;
 	pc->page = page;
-	pc->flags = PAGE_CGROUP_FLAG_ACTIVE;
+	/*
+	 * If a page is accounted as a page cache, insert to inactive list.
+	 * If anon, insert to active list.
+	 */
 	if (ctype == MEM_CGROUP_CHARGE_TYPE_CACHE)
 		pc->flags = PAGE_CGROUP_FLAG_CACHE;
+	else
+		pc->flags = PAGE_CGROUP_FLAG_ACTIVE;
 
 	lock_page_cgroup(page);
 	if (page_get_page_cgroup(page)) {
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
mm-speculative-page-references-fix-migration_entry_wait-for-speculative-page-cache.patch
define-page_file_cache-function-fix-splitlru-shmem_getpage-setpageswapbacked-sooner.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-memcg-swapbacked-pages-active.patch
vmscan-second-chance-replacement-for-anonymous-pages-fix.patch
vmscan-second-chance-replacement-for-anonymous-pages-memcg-lru-scan-fix.patch
unevictable-lru-infrastructure-putback_lru_page-unevictable-page-handling-rework.patch
mlock-mlocked-pages-are-unevictable-fix-truncate-race-and-sevaral-comments.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
restore-patch-failure-of-vmstat-unevictable-and-mlocked-pages-vm-eventspatch.patch

