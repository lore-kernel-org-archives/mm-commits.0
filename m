From: akpm@linux-foundation.org
Subject: - kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:44:32 -0800
Message-ID: <200802080844.m188iDmd016205@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36756 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751323AbYBHIo7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:44:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, harvey.harrison@gmail.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     kernel-remove-fastcall-in-kernel-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch

This patch was dropped because it was folded into kernel-remove-fastcall-in-kernel.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel-remove-fastcall-in-kernel-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: inline keyword should sit between storage class and type
#144: FILE: kernel/mutex.c:61:
+static void noinline __sched

ERROR: inline keyword should sit between storage class and type
#153: FILE: kernel/mutex.c:85:
+void inline __sched mutex_lock(struct mutex *lock)

ERROR: inline keyword should sit between storage class and type
#162: FILE: kernel/mutex.c:98:
+static void noinline __sched

ERROR: inline keyword should sit between storage class and type
#198: FILE: kernel/mutex.c:285:
+static int noinline __sched

ERROR: inline keyword should sit between storage class and type
#229: FILE: kernel/mutex.c:319:
+static void noinline __sched

ERROR: inline keyword should sit between storage class and type
#238: FILE: kernel/mutex.c:327:
+static int noinline __sched

ERROR: "foo * bar" should be "foo *bar"
#295: FILE: kernel/pid.c:290:
+struct pid * find_pid_ns(int nr, struct pid_namespace *ns)

ERROR: "foo * bar" should be "foo *bar"
#331: FILE: kernel/pid.c:360:
+struct task_struct * pid_task(struct pid *pid, enum pid_type type)

total: 8 errors, 0 warnings, 530 lines checked

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

(akpm: this is a bit weird)

Cc: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/mutex.c |    9 ++++-----
 kernel/pid.c   |    4 ++--
 2 files changed, 6 insertions(+), 7 deletions(-)

diff -puN kernel/mutex.c~kernel-remove-fastcall-in-kernel-checkpatch-fixes kernel/mutex.c
--- a/kernel/mutex.c~kernel-remove-fastcall-in-kernel-checkpatch-fixes
+++ a/kernel/mutex.c
@@ -95,8 +95,7 @@ void inline __sched mutex_lock(struct mu
 EXPORT_SYMBOL(mutex_lock);
 #endif
 
-static void noinline __sched
-__mutex_unlock_slowpath(atomic_t *lock_count);
+static noinline void __sched __mutex_unlock_slowpath(atomic_t *lock_count);
 
 /***
  * mutex_unlock - release the mutex
@@ -282,7 +281,7 @@ __mutex_unlock_slowpath(atomic_t *lock_c
  * Here come the less common (and hence less performance-critical) APIs:
  * mutex_lock_interruptible() and mutex_trylock().
  */
-static int noinline __sched
+static noinline int __sched
 __mutex_lock_killable_slowpath(atomic_t *lock_count);
 
 static noinline int __sched
@@ -316,7 +315,7 @@ int __sched mutex_lock_killable(struct m
 }
 EXPORT_SYMBOL(mutex_lock_killable);
 
-static void noinline __sched
+static noinline void __sched
 __mutex_lock_slowpath(atomic_t *lock_count)
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
@@ -324,7 +323,7 @@ __mutex_lock_slowpath(atomic_t *lock_cou
 	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0, _RET_IP_);
 }
 
-static int noinline __sched
+static noinline int __sched
 __mutex_lock_killable_slowpath(atomic_t *lock_count)
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
diff -puN kernel/pid.c~kernel-remove-fastcall-in-kernel-checkpatch-fixes kernel/pid.c
--- a/kernel/pid.c~kernel-remove-fastcall-in-kernel-checkpatch-fixes
+++ a/kernel/pid.c
@@ -286,7 +286,7 @@ out_free:
 	goto out;
 }
 
-struct pid * find_pid_ns(int nr, struct pid_namespace *ns)
+struct pid *find_pid_ns(int nr, struct pid_namespace *ns)
 {
 	struct hlist_node *elem;
 	struct upid *pnr;
@@ -356,7 +356,7 @@ void transfer_pid(struct task_struct *ol
 	old->pids[type].pid = NULL;
 }
 
-struct task_struct * pid_task(struct pid *pid, enum pid_type type)
+struct task_struct *pid_task(struct pid *pid, enum pid_type type)
 {
 	struct task_struct *result = NULL;
 	if (pid) {
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
kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
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
