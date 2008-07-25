From: akpm@linux-foundation.org
Subject: - ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:32:39 -0700
Message-ID: <200807250032.m6P0WdCv014438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752977AbYGYAdO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:33:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Nadia.Derbey@bull.net, manfred@colorfullife.com, peifferp@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes.patch

This patch was dropped because it was folded into ipc-semc-convert-undo-structures-to-struct-list_head.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#26: FILE: include/linux/sem.h:98:
+	struct list_head	list_id;	/* undo requests on this array */

WARNING: line over 80 characters
#36: FILE: include/linux/sem.h:121:
+	struct list_head	list_proc;	/* per-process list: all undos from one process */

WARNING: line over 80 characters
#37: FILE: include/linux/sem.h:122:
+	struct list_head	list_id;	/* per semaphore array list: all undos for one array */

ERROR: spaces required around that '==' (ctx:VxV)
#135: FILE: ipc/sem.c:976:
+		if(walk->semid==semid)
 		              ^

ERROR: space required before the open parenthesis '('
#135: FILE: ipc/sem.c:976:
+		if(walk->semid==semid)

ERROR: spaces required around that '==' (ctx:VxO)
#137: FILE: ipc/sem.c:978:
+		if(walk->semid==-1) {
 		              ^

ERROR: space required before that '-' (ctx:OxV)
#137: FILE: ipc/sem.c:978:
+		if(walk->semid==-1) {
 		                ^

ERROR: space required before the open parenthesis '('
#137: FILE: ipc/sem.c:978:
+		if(walk->semid==-1) {

ERROR: spaces required around that '=' (ctx:VxW)
#258: FILE: ipc/sem.c:1271:
+	ulp= tsk->sysvsem.undo_list;
 	   ^

ERROR: code indent should use tabs where possible
#285: FILE: ipc/sem.c:1282:
+  ^I^Istruct sem_array *sma;$

ERROR: space required before the open parenthesis '('
#288: FILE: ipc/sem.c:1285:
+		if(un->semid == -1)

total: 8 errors, 3 warnings, 308 lines checked

./patches/ipc-semc-convert-undo-structures-to-struct-list_head.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN ipc/sem.c~ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes ipc/sem.c
--- a/ipc/sem.c~ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes
+++ a/ipc/sem.c
@@ -973,9 +973,9 @@ static struct sem_undo *lookup_undo(stru
 
 	assert_spin_locked(&ulp->lock);
 	list_for_each_entry_safe(walk, tmp, &ulp->list_proc, list_proc) {
-		if(walk->semid==semid)
+		if (walk->semid == semid)
 			return walk;
-		if(walk->semid==-1) {
+		if (walk->semid == -1) {
 			list_del(&walk->list_proc);
 			kfree(walk);
 		}
@@ -1268,7 +1268,7 @@ void exit_sem(struct task_struct *tsk)
 	struct sem_undo_list *ulp;
 	struct sem_undo *un, *tmp;
 
-	ulp= tsk->sysvsem.undo_list;
+	ulp = tsk->sysvsem.undo_list;
 	if (!ulp)
 		return;
 	tsk->sysvsem.undo_list = NULL;
@@ -1279,10 +1279,10 @@ void exit_sem(struct task_struct *tsk)
 	spin_lock(&ulp->lock);
 
 	list_for_each_entry_safe(un, tmp, &ulp->list_proc, list_proc) {
-  		struct sem_array *sma;
+		struct sem_array *sma;
 		int i;
 
-		if(un->semid == -1)
+		if (un->semid == -1)
 			goto free;
 
 		sma = sem_lock(tsk->nsproxy->ipc_ns, un->semid);
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
ipc-semc-convert-undo-structures-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-rewrite-undo-list-locking-checkpatch-fixes.patch
fs-partition-checkc-fix-return-value-warning-v2-cleanup.patch
block-ioctlc-and-fs-partition-checkc-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
edac-mpc85xx-fix-pci-ofdev-2nd-pass-checkpatch-fixes.patch

