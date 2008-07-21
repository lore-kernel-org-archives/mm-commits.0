From: akpm@linux-foundation.org
Subject: - vfs-use-kstrdup.patch removed from -mm tree
Date: Mon, 21 Jul 2008 12:57:28 -0700
Message-ID: <200807211957.m6LJvSwJ021222@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755479AbYGUT6H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jul 2008 15:58:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: use kstrdup()
has been removed from the -mm tree.  Its filename was
     vfs-use-kstrdup.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: use kstrdup()
From: Li Zefan <lizf@cn.fujitsu.com>

This piece of code can be replaced by a kstrdup().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff -puN fs/namespace.c~vfs-use-kstrdup fs/namespace.c
--- a/fs/namespace.c~vfs-use-kstrdup
+++ a/fs/namespace.c
@@ -127,14 +127,7 @@ struct vfsmount *alloc_vfsmnt(const char
 		INIT_LIST_HEAD(&mnt->mnt_slave_list);
 		INIT_LIST_HEAD(&mnt->mnt_slave);
 		atomic_set(&mnt->__mnt_writers, 0);
-		if (name) {
-			int size = strlen(name) + 1;
-			char *newname = kmalloc(size, GFP_KERNEL);
-			if (newname) {
-				memcpy(newname, name, size);
-				mnt->mnt_devname = newname;
-			}
-		}
+		mnt->mnt_devname = kstrdup(name, GFP_KERNEL);
 	}
 	return mnt;
 }
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
vfs-use-kstrdup.patch
call_usermodehelper-increase-reliability.patch
mfd-sm501-build-fixes-when-config_mfd_sm501_gpio-unset.patch
rtc-push-the-bkl-down-into-the-driver-ioctl-method-fix.patch
ext3-kill-2-useless-magic-numbers.patch
cgroup-use-read-lock-to-guard-find_existing_css_set.patch
cgroup-list_for_each-cleanup-v2.patch
cgroup-anotate-two-variables-with-__read_mostly.patch
cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler-fix.patch
devcgroup-code-cleanup.patch
devcgroup-code-cleanup-fix.patch
devcgroup-code-cleanup-fix-fix.patch
memcg-avoid-unnecessary-initialization.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch
memcg-remove-refcnt-from-page_cgroup-memcg-fix-shmem_unuse_inode-charging.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-helper-function-for-relcaim-from-shmem-memcg-shmem_getpage-release-page-sooner.patch
memcg-helper-function-for-relcaim-from-shmem-memcg-mem_cgroup_shrink_usage-css_put.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memcg-clean-up-checking-of-the-disabled-flag.patch
memcg-clean-up-checking-of-the-disabled-flag-memcg-further-checking-of-disabled-flag.patch
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
cpusets-restructure-the-function-update_cpumask-and-update_nodemask-fix.patch
cpusets-update-tasks-cpus_allowed-and-mems_allowed-after-cpu-node-offline-online.patch
cpuset-avoid-unnecessary-sched-domains-rebuilding.patch
introduce-__get_user_pages.patch
split-lru-munlock-rework.patch
revert-to-unevictable-lru-infrastructure-kconfig-fixpatch.patch

