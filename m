From: akpm@linux-foundation.org
Subject: - cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:22:10 -0700
Message-ID: <200807250022.m6P0MAFN013951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752207AbYGYAW7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:22:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, balbir@in.ibm.com, danms@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, serge@us.ibm.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-checkpatch-fixes.patch

This patch was dropped because it was folded into cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: do not use assignment in if condition
#119: FILE: kernel/fork.c:1115:
+		if ((retval = ns_cgroup_clone(p, pid)))

total: 1 errors, 0 warnings, 94 lines checked

./patches/cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Dan Smith <danms@us.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Serge Hallyn <serge@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/fork.c~cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-checkpatch-fixes kernel/fork.c
--- a/kernel/fork.c~cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-checkpatch-fixes
+++ a/kernel/fork.c
@@ -1108,9 +1108,11 @@ static struct task_struct *copy_process(
 	if (clone_flags & CLONE_THREAD)
 		p->tgid = current->tgid;
 
-	if (current->nsproxy != p->nsproxy)
-		if ((retval = ns_cgroup_clone(p, pid)))
+	if (current->nsproxy != p->nsproxy) {
+		retval = ns_cgroup_clone(p, pid);
+		if (retval)
 			goto bad_fork_free_pid;
+	}
 
 	p->set_child_tid = (clone_flags & CLONE_CHILD_SETTID) ? child_tidptr : NULL;
 	/*
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
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-checkpatch-fixes.patch
devcgroup-code-cleanup-fix.patch
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

