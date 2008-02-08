From: akpm@linux-foundation.org
Subject: - lib-remove-fastcall-from-lib-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:44:48 -0800
Message-ID: <200802080844.m188iTfl016208@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36376 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756862AbYBHIpA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:45:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     lib-remove-fastcall-from-lib-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     lib-remove-fastcall-from-lib-checkpatch-fixes.patch

This patch was dropped because it was folded into lib-remove-fastcall-from-lib.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib-remove-fastcall-from-lib-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "foo * bar" should be "foo *bar"
#244: FILE: lib/semaphore-sleepers.c:56:
+void __sched __down(struct semaphore * sem)

ERROR: "foo * bar" should be "foo *bar"
#253: FILE: lib/semaphore-sleepers.c:93:
+int __sched __down_interruptible(struct semaphore * sem)

ERROR: "foo * bar" should be "foo *bar"
#262: FILE: lib/semaphore-sleepers.c:156:
+int __down_trylock(struct semaphore * sem)

total: 3 errors, 0 warnings, 222 lines checked

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/semaphore-sleepers.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/semaphore-sleepers.c~lib-remove-fastcall-from-lib-checkpatch-fixes lib/semaphore-sleepers.c
--- a/lib/semaphore-sleepers.c~lib-remove-fastcall-from-lib-checkpatch-fixes
+++ a/lib/semaphore-sleepers.c
@@ -53,7 +53,7 @@ void __up(struct semaphore *sem)
 	wake_up(&sem->wait);
 }
 
-void __sched __down(struct semaphore * sem)
+void __sched __down(struct semaphore *sem)
 {
 	struct task_struct *tsk = current;
 	DECLARE_WAITQUEUE(wait, tsk);
@@ -90,7 +90,7 @@ void __sched __down(struct semaphore * s
 	tsk->state = TASK_RUNNING;
 }
 
-int __sched __down_interruptible(struct semaphore * sem)
+int __sched __down_interruptible(struct semaphore *sem)
 {
 	int retval = 0;
 	struct task_struct *tsk = current;
@@ -153,7 +153,7 @@ int __sched __down_interruptible(struct 
  * single "cmpxchg" without failure cases,
  * but then it wouldn't work on a 386.
  */
-int __down_trylock(struct semaphore * sem)
+int __down_trylock(struct semaphore *sem)
 {
 	int sleepers;
 	unsigned long flags;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option.patch
proc-detect-duplicate-names-on-registration.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-fix-openless-usage-due-to-proc_fops-flip.patch
intel-iommu-fault_reason_index_cleanuppatch.patch
modules-make-module_address_lookup-safe-fix.patch
wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace.patch
pid-sys_wait-fixes-v2.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel.patch
rewrite-rd.patch
fs-remove-fastcall-it-is-always-empty.patch
kernel-remove-fastcall-in-kernel.patch
lib-remove-fastcall-from-lib.patch
lib-remove-fastcall-from-lib-checkpatch-fixes.patch
remove-fastcall-from-linux-include-checkpatch-fixes.patch
constify-tables-in-kernel-sysctl_checkc-fix.patch
aoe-statically-initialise-devlist_lock.patch
ufs-fix-symlink-creation-on-ufs2-fix.patch
libfs-allow-error-return-from-simple-attributes-fix.patch
fs-hfsplus-unicodec-fix-uninitialized-var-warning.patch
fs-afs-securityc-fix-uninitialized-var-warning.patch
mount-options-fix-tmpfs-fix.patch
char-applicom-use-pci_match_id-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch
