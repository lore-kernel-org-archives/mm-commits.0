From: akpm@linux-foundation.org
Subject: - ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 24 Jul 2008 17:33:12 -0700
Message-ID: <200807250033.m6P0XCuh014451@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752518AbYGYAds (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 20:33:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Nadia.Derbey@bull.net, manfred@colorfullife.com, peifferp@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes.patch

This patch was dropped because it was folded into ipc-semc-convert-sem_arraysem_pending-to-struct-list_head.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#25: FILE: include/linux/sem.h:96:
+	struct list_head	sem_pending;	/* pending operations to be processed */

ERROR: space required before the open parenthesis '('
#105: FILE: ipc/sem.c:409:
+	while(&q->list != &sma->sem_pending) {

WARNING: line over 80 characters
#135: FILE: ipc/sem.c:436:
+				n = list_entry(sma->sem_pending.next, struct sem_queue, list);

WARNING: line over 80 characters
#137: FILE: ipc/sem.c:438:
+				n = list_entry(q->list.next, struct sem_queue, list);

total: 1 errors, 3 warnings, 206 lines checked

./patches/ipc-semc-convert-sem_arraysem_pending-to-struct-list_head.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN ipc/sem.c~ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes ipc/sem.c
--- a/ipc/sem.c~ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes
+++ a/ipc/sem.c
@@ -406,7 +406,7 @@ static void update_queue (struct sem_arr
 	struct sem_queue * q;
 
 	q = list_entry(sma->sem_pending.next, struct sem_queue, list);
-	while(&q->list != &sma->sem_pending) {
+	while (&q->list != &sma->sem_pending) {
 		error = try_atomic_semop(sma, q->sops, q->nsops,
 					 q->undo, q->pid);
 
@@ -433,9 +433,11 @@ static void update_queue (struct sem_arr
 			 */
 			if (q->alter) {
 				list_del(&q->list);
-				n = list_entry(sma->sem_pending.next, struct sem_queue, list);
+				n = list_entry(sma->sem_pending.next,
+						struct sem_queue, list);
 			} else {
-				n = list_entry(q->list.next, struct sem_queue, list);
+				n = list_entry(q->list.next, struct sem_queue,
+						list);
 				list_del(&q->list);
 			}
 
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
ipc-semc-convert-sem_arraysem_pending-to-struct-list_head-checkpatch-fixes.patch
ipc-semc-rewrite-undo-list-locking-checkpatch-fixes.patch
fs-partition-checkc-fix-return-value-warning-v2-cleanup.patch
block-ioctlc-and-fs-partition-checkc-checkpatch-fixes.patch
getdelaysc-add-a-usr1-signal-handler-checkpatch-fixes.patch
edac-mpc85xx-fix-pci-ofdev-2nd-pass-checkpatch-fixes.patch

