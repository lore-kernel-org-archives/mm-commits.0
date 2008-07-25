From: akpm@linux-foundation.org
Subject: - memcg-remove-refcnt-from-page_cgroup-fix-2.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:24:08 -0700
Message-ID: <200807250024.m6P0O88S013986@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35754 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751500AbYGYAYj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:24:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, balbir@in.ibm.com, ebiederm@xmission.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@google.com, ser


The patch titled
     memcg-remove-refcnt-from-page_cgroup-fix-2
has been removed from the -mm tree.  Its filename was
     memcg-remove-refcnt-from-page_cgroup-fix-2.patch

This patch was dropped because it was folded into memcg-remove-refcnt-from-page_cgroup.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-remove-refcnt-from-page_cgroup-fix-2
From: Andrew Morton <akpm@linux-foundation.org>

mm/shmem.c: In function 'shmem_getpage':
mm/shmem.c:1369: warning: 'ret' may be used uninitialized in this function

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/shmem.c~memcg-remove-refcnt-from-page_cgroup-fix-2 mm/shmem.c
--- a/mm/shmem.c~memcg-remove-refcnt-from-page_cgroup-fix-2
+++ a/mm/shmem.c
@@ -1396,7 +1396,8 @@ repeat:
 				swap = *entry;
 				shmem_swp_unmap(entry);
 			}
-			if (error || swap.val)
+			ret = error || swap.val;
+			if (ret)
 				mem_cgroup_uncharge_cache_page(filepage);
 			else
 				ret = add_to_page_cache_lru(filepage, mapping,
@@ -1405,7 +1406,7 @@ repeat:
 			 * At add_to_page_cache_lru() failure, uncharge will
 			 * be done automatically.
 			 */
-			if (error || swap.val || ret) {
+			if (ret) {
 				spin_unlock(&info->lock);
 				page_cache_release(filepage);
 				shmem_unacct_blocks(info->flags, 1);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
remove-apparently-unused-fd1772h-header-file.patch
lib-allow-memparse-to-accept-a-null-and-ignorable-second-parm.patch
build-kernel-profileo-only-when-requested-cleanups.patch
seq_file-fix-bug-when-seq_read-reads-nothing.patch
exec-remove-some-includes.patch
inflate-refactor-inflate-malloc-code.patch
drivers-misc-hpiloc-needs-config_pci.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
gpio-sysfs-interface-updated.patch
gpio-add-bt8xxgpio-driver.patch
jbd-fix-race-between-free-buffer-and-commit-trasanction.patch
ext3-handle-corrupted-orphan-list-at-mount.patch
ext3-handle-deleting-corrupted-indirect-blocks.patch
jbd-dont-abort-if-flushing-file-data-failed.patch
reiserfs-convert-j_flush_sem-to-mutex.patch
reiserfs-convert-j_commit_lock-to-mutex.patch
quota-move-function-macros-from-quotah-to-quotaopsh.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup.patch
devcgroup-code-cleanup.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
memcg-limit-change-shrink-usage-checkpatch-fixes.patch
coredump-format_corename-fix-the-core_uses_pid-logic-checkpatch-fixes.patch
workqueues-make-get_online_cpus-useable-for-work-func-fix.patch
ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-rewrite-undo-list-locking-checkpatch-fixes.patch
fs-partition-checkc-fix-return-value-warning-v2-cleanup.patch
block-ioctlc-and-fs-partition-checkc-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
edac-mpc85xx-fix-pci-ofdev-2nd-pass-checkpatch-fixes.patch

