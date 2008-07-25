From: akpm@linux-foundation.org
Subject: - memcg-remove-refcnt-from-page_cgroup-memcg-fix-shmem_unuse_inode-charging.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:24:14 -0700
Message-ID: <200807250024.m6P0OEZs013992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752616AbYGYAaS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:30:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, balbir@linux.vnet.ibm.com, ebiederm@xmission.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@goo


The patch titled
     memcg: fix shmem_unuse_inode charging
has been removed from the -mm tree.  Its filename was
     memcg-remove-refcnt-from-page_cgroup-memcg-fix-shmem_unuse_inode-charging.patch

This patch was dropped because it was folded into memcg-remove-refcnt-from-page_cgroup.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix shmem_unuse_inode charging
From: Hugh Dickins <hugh@veritas.com>

The mem_cgroup_cache_charge in shmem_unuse_inode has been moved after the
radix_tree_preload, so generating a BUG: sleeping function called from
invalid context.  Move it back, uncharging where necessary.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff -puN mm/shmem.c~memcg-remove-refcnt-from-page_cgroup-memcg-fix-shmem_unuse_inode-charging mm/shmem.c
--- a/mm/shmem.c~memcg-remove-refcnt-from-page_cgroup-memcg-fix-shmem_unuse_inode-charging
+++ a/mm/shmem.c
@@ -922,27 +922,24 @@ found:
 	error = 1;
 	if (!inode)
 		goto out;
-	error = radix_tree_preload(GFP_KERNEL);
-	if (error)
-		goto out;
-	/*
-	 * Because we use GFP_NOWAIT in add_to_page_cache(), we can see -ENOMEM
-	 * failure because of memory pressure in memory resource controller.
-	 * Then, precharge page while we can wait, uncharge at failure will be
-	 * automatically done in add_to_page_cache()
-	 */
+	/* Precharge page using GFP_KERNEL while we can wait */
 	error = mem_cgroup_cache_charge(page, current->mm, GFP_KERNEL);
 	if (error)
-		goto preload_out;
-
+		goto out;
+	error = radix_tree_preload(GFP_KERNEL);
+	if (error) {
+		mem_cgroup_uncharge_cache_page(page);
+		goto out;
+	}
 	error = 1;
 
 	spin_lock(&info->lock);
 	ptr = shmem_swp_entry(info, idx, NULL);
-	if (ptr && ptr->val == entry.val)
-		error = add_to_page_cache(page, inode->i_mapping, idx,
-					GFP_NOWAIT);
-	else /* we don't have to account this page. */
+	if (ptr && ptr->val == entry.val) {
+		error = add_to_page_cache(page, inode->i_mapping,
+						idx, GFP_NOWAIT);
+		/* does mem_cgroup_uncharge_cache_page on error */
+	} else	/* we must compensate for our precharge above */
 		mem_cgroup_uncharge_cache_page(page);
 
 	if (error == -EEXIST) {
@@ -969,7 +966,6 @@ found:
 	if (ptr)
 		shmem_swp_unmap(ptr);
 	spin_unlock(&info->lock);
-preload_out:
 	radix_tree_preload_end();
 out:
 	unlock_page(page);
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
exec-remove-some-includes.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-memcg-fix-shmem_unuse_inode-charging.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-helper-function-for-relcaim-from-shmem-memcg-shmem_getpage-release-page-sooner.patch
memcg-helper-function-for-relcaim-from-shmem-memcg-mem_cgroup_shrink_usage-css_put.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memcg-clean-up-checking-of-the-disabled-flag-memcg-further-checking-of-disabled-flag.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-mmap_sem-deadlock.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-sleep-inside-sleeplock-in-mm_update_next_owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memrlimit-improve-fork-and-error-handling.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback-update.patch

