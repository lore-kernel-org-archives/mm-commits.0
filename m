From: akpm@linux-foundation.org
Subject: - memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:24:11 -0700
Message-ID: <200807250024.m6P0OBQU013989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39636 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751649AbYGYAYk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:24:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, ebiederm@xmission.com, hugh@veritas.com, kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@go


The patch titled
     memcg: fix mem_cgroup_end_migration() race
has been removed from the -mm tree.  Its filename was
     memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch

This patch was dropped because it was folded into memcg-remove-refcnt-from-page_cgroup.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix mem_cgroup_end_migration() race
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

In general, mem_cgroup's charge on ANON page is removed when
page_remove_rmap() is called.

At migration, the newpage is remapped again by remove_migration_ptes(). 
But pte may be already changed (by task exits).  It is charged at page
allocation but have no chance to be uncharged in that case because it is
never added to rmap.

Handle that corner case in mem_cgroup_end_migration().

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race
+++ a/mm/memcontrol.c
@@ -762,10 +762,22 @@ int mem_cgroup_prepare_migration(struct 
 /* remove redundant charge if migration failed*/
 void mem_cgroup_end_migration(struct page *newpage)
 {
-	/* At success, page->mapping is not NULL and nothing to do. */
+	/*
+	 * At success, page->mapping is not NULL.
+	 * special rollback care is necessary when
+	 * 1. at migration failure. (newpage->mapping is cleared in this case)
+	 * 2. the newpage was moved but not remapped again because the task
+	 *    exits and the newpage is obsolete. In this case, the new page
+	 *    may be a swapcache. So, we just call mem_cgroup_uncharge_page()
+	 *    always for avoiding mess. The  page_cgroup will be removed if
+	 *    unnecessary. File cache pages is still on radix-tree. Don't
+	 *    care it.
+	 */
 	if (!newpage->mapping)
 		__mem_cgroup_uncharge_common(newpage,
 					 MEM_CGROUP_CHARGE_TYPE_FORCE);
+	else if (PageAnon(newpage))
+		mem_cgroup_uncharge_page(newpage);
 }
 
 /*
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
mark-res_counter_charge_locked-with-__must_check.patch
cgroup-files-clean-up-whitespace-in-struct-cftype.patch
cgroup-files-add-write_string-cgroup-control-file-method.patch
cgroup-files-move-the-release_agent-file-to-use-typed-handlers.patch
cgroups-misc-cleanups-to-write_string-patchset.patch
cgroup-files-move-notify_on_release-file-to-separate-write-handler.patch
cgroup-files-turn-attach_task_by_pid-directly-into-a-cgroup-write-handler.patch
cgroup-files-remove-cpuset_common_file_write.patch
cgroup-files-convert-devcgroup_access_write-into-a-cgroup-write_string-handler.patch
cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup.patch
memcg-make-global-var-read_mostly.patch
memcg-avoid-unnecessary-initialization.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch
memcg-remove-refcnt-from-page_cgroup-memcg-fix-shmem_unuse_inode-charging.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-helper-function-for-relcaim-from-shmem-memcg-shmem_getpage-release-page-sooner.patch
memcg-helper-function-for-relcaim-from-shmem-memcg-mem_cgroup_shrink_usage-css_put.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memcg-clean-up-checking-of-the-disabled-flag.patch
memcg-clean-up-checking-of-the-disabled-flag-memcg-further-checking-of-disabled-flag.patch
res_counter-limit-change-support-ebusy.patch
memcg-limit-change-shrink-usage.patch
memcg-limit-change-shrink-usage-checkpatch-fixes.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-setup-the-memrlimit-controller-memrlimit-correct-mremap-and-move_vma-accounting.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-mmap_sem-deadlock.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-sleep-inside-sleeplock-in-mm_update_next_owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memrlimit-improve-fork-and-error-handling.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback-update.patch

