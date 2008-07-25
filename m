From: akpm@linux-foundation.org
Subject: - ipc-semc-rewrite-undo-list-locking-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:33:28 -0700
Message-ID: <200807250033.m6P0XS1P014461@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752858AbYGYAeE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:34:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Nadia.Derbey@bull.net, manfred@colorfullife.com, peifferp@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ipc-semc-rewrite-undo-list-locking-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ipc-semc-rewrite-undo-list-locking-checkpatch-fixes.patch

This patch was dropped because it was folded into ipc-semc-rewrite-undo-list-locking.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc-semc-rewrite-undo-list-locking-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#42: FILE: include/linux/sem.h:118:
+	struct list_head	list_proc;	/* per-process list: all undos from one process. */

WARNING: line over 80 characters
#45: FILE: include/linux/sem.h:121:
+	struct sem_undo_list	*ulp;		/* sem_undo_list for the process */

WARNING: line over 80 characters
#167: FILE: ipc/sem.c:1025:
+	/* step 4: check for races: did someone else allocate the undo struct? */

ERROR: space required before the open parenthesis '('
#213: FILE: ipc/sem.c:1126:
+		if(un->semid == -1) {

ERROR: spaces required around that '=' (ctx:WxV)
#255: FILE: ipc/sem.c:1284:
+		un =list_entry(rcu_dereference(ulp->list_proc.next),
 		   ^

ERROR: space required before the open parenthesis '('
#266: FILE: ipc/sem.c:1292:
+		if(semid == -1)

total: 3 errors, 3 warnings, 272 lines checked

./patches/ipc-semc-rewrite-undo-list-locking.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN ipc/sem.c~ipc-semc-rewrite-undo-list-locking-checkpatch-fixes ipc/sem.c
--- a/ipc/sem.c~ipc-semc-rewrite-undo-list-locking-checkpatch-fixes
+++ a/ipc/sem.c
@@ -1022,7 +1022,9 @@ static struct sem_undo *find_alloc_undo(
 	}
 	spin_lock(&ulp->lock);
 
-	/* step 4: check for races: did someone else allocate the undo struct? */
+	/*
+	 * step 4: check for races: did someone else allocate the undo struct?
+	 */
 	un = lookup_undo(ulp, semid);
 	if (un) {
 		kfree(new);
@@ -1123,7 +1125,7 @@ asmlinkage long sys_semtimedop(int semid
 	 */
 	error = -EIDRM;
 	if (un) {
-		if(un->semid == -1) {
+		if (un->semid == -1) {
 			rcu_read_unlock();
 			goto out_unlock_free;
 		} else {
@@ -1281,7 +1283,7 @@ void exit_sem(struct task_struct *tsk)
 		int i;
 
 		rcu_read_lock();
-		un =list_entry(rcu_dereference(ulp->list_proc.next),
+		un = list_entry(rcu_dereference(ulp->list_proc.next),
 					struct sem_undo, list_proc);
 		if (&un->list_proc == &ulp->list_proc)
 			semid = -1;
@@ -1289,7 +1291,7 @@ void exit_sem(struct task_struct *tsk)
 			semid = un->semid;
 		rcu_read_unlock();
 
-		if(semid == -1)
+		if (semid == -1)
 			break;
 
 		sma = sem_lock_check(tsk->nsproxy->ipc_ns, un->semid);
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
memcg-limit-change-shrink-usage.patch
coredump-format_corename-fix-the-core_uses_pid-logic.patch
workqueues-make-get_online_cpus-useable-for-work-func.patch
ipc-semc-convert-undo-structures-to-struct-list_head.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head.patch
ipc-semc-rewrite-undo-list-locking.patch
ipc-semc-rewrite-undo-list-locking-checkpatch-fixes.patch
fs-partition-checkc-fix-return-value-warning-v2-cleanup.patch
block-ioctlc-and-fs-partition-checkc-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
edac-mpc85xx-fix-pci-ofdev-2nd-pass-checkpatch-fixes.patch

