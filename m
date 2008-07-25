From: akpm@linux-foundation.org
Subject: - memcg-add-hints-for-branch.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:58:52 -0700
Message-ID: <200807252258.m6PMwqxh003321@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754500AbYGYW7k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:59:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, ebiederm@xmission.com, hugh@veritas.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@google.com, xemul@openvz.org, yamamoto@val


The patch titled
     memcg: add hints for branch
has been removed from the -mm tree.  Its filename was
     memcg-add-hints-for-branch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: add hints for branch
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Showing brach direction for obvious conditions.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~memcg-add-hints-for-branch mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-hints-for-branch
+++ a/mm/memcontrol.c
@@ -550,7 +550,7 @@ retry:
 	 * The page_cgroup exists and
 	 * the page has already been accounted.
 	 */
-	if (pc) {
+	if (unlikely(pc)) {
 		VM_BUG_ON(pc->page != page);
 		VM_BUG_ON(!pc->mem_cgroup);
 		unlock_page_cgroup(page);
@@ -559,7 +559,7 @@ retry:
 	unlock_page_cgroup(page);
 
 	pc = kmem_cache_alloc(page_cgroup_cache, gfp_mask);
-	if (pc == NULL)
+	if (unlikely(pc == NULL))
 		goto err;
 
 	/*
@@ -616,7 +616,7 @@ retry:
 		pc->flags = PAGE_CGROUP_FLAG_ACTIVE;
 
 	lock_page_cgroup(page);
-	if (page_get_page_cgroup(page)) {
+	if (unlikely(page_get_page_cgroup(page))) {
 		unlock_page_cgroup(page);
 		/*
 		 * Another charge has been added to this page already.
@@ -690,7 +690,7 @@ __mem_cgroup_uncharge_common(struct page
 	 */
 	lock_page_cgroup(page);
 	pc = page_get_page_cgroup(page);
-	if (!pc)
+	if (unlikely(!pc))
 		goto unlock;
 
 	VM_BUG_ON(pc->page != page);
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

