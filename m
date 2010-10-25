From: akpm@linux-foundation.org
Subject: + signals-move-cred_guard_mutex-from-task_struct-to-signal_struct.patch added to -mm tree
Date: Mon, 25 Oct 2010 14:51:42 -0700
Message-ID: <201010252151.o9PLpgg1018345@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755531Ab0JYVw2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Oct 2010 17:52:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, dhowells@redhat.com, oleg@redhat.com, roland@redhat.com


The patch titled
     signals: ] move cred_guard_mutex from task_struct to signal_struct
has been added to the -mm tree.  Its filename is
     signals-move-cred_guard_mutex-from-task_struct-to-signal_struct.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: ] move cred_guard_mutex from task_struct to signal_struct
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Oleg Nesterov pointed out we have to prevent multiple-threads-inside-exec
itself and we can reuse ->cred_guard_mutex for it.  Yes, concurrent
execve() has no worth.

Let's move ->cred_guard_mutex from task_struct to signal_struct.  It
naturally prevent multiple-threads-inside-exec.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                 |   10 +++++-----
 fs/proc/base.c            |    8 ++++----
 include/linux/init_task.h |    4 ++--
 include/linux/sched.h     |    7 ++++---
 include/linux/tracehook.h |    2 +-
 kernel/cred.c             |    4 +---
 kernel/fork.c             |    2 ++
 kernel/ptrace.c           |    4 ++--
 8 files changed, 21 insertions(+), 20 deletions(-)

diff -puN fs/exec.c~signals-move-cred_guard_mutex-from-task_struct-to-signal_struct fs/exec.c
--- a/fs/exec.c~signals-move-cred_guard_mutex-from-task_struct-to-signal_struct
+++ a/fs/exec.c
@@ -1083,14 +1083,14 @@ EXPORT_SYMBOL(setup_new_exec);
  */
 int prepare_bprm_creds(struct linux_binprm *bprm)
 {
-	if (mutex_lock_interruptible(&current->cred_guard_mutex))
+	if (mutex_lock_interruptible(&current->signal->cred_guard_mutex))
 		return -ERESTARTNOINTR;
 
 	bprm->cred = prepare_exec_creds();
 	if (likely(bprm->cred))
 		return 0;
 
-	mutex_unlock(&current->cred_guard_mutex);
+	mutex_unlock(&current->signal->cred_guard_mutex);
 	return -ENOMEM;
 }
 
@@ -1098,7 +1098,7 @@ void free_bprm(struct linux_binprm *bprm
 {
 	free_arg_pages(bprm);
 	if (bprm->cred) {
-		mutex_unlock(&current->cred_guard_mutex);
+		mutex_unlock(&current->signal->cred_guard_mutex);
 		abort_creds(bprm->cred);
 	}
 	kfree(bprm);
@@ -1119,13 +1119,13 @@ void install_exec_creds(struct linux_bin
 	 * credentials; any time after this it may be unlocked.
 	 */
 	security_bprm_committed_creds(bprm);
-	mutex_unlock(&current->cred_guard_mutex);
+	mutex_unlock(&current->signal->cred_guard_mutex);
 }
 EXPORT_SYMBOL(install_exec_creds);
 
 /*
  * determine how safe it is to execute the proposed program
- * - the caller must hold current->cred_guard_mutex to protect against
+ * - the caller must hold ->cred_guard_mutex to protect against
  *   PTRACE_ATTACH
  */
 int check_unsafe_exec(struct linux_binprm *bprm)
diff -puN fs/proc/base.c~signals-move-cred_guard_mutex-from-task_struct-to-signal_struct fs/proc/base.c
--- a/fs/proc/base.c~signals-move-cred_guard_mutex-from-task_struct-to-signal_struct
+++ a/fs/proc/base.c
@@ -226,7 +226,7 @@ struct mm_struct *mm_for_maps(struct tas
 {
 	struct mm_struct *mm;
 
-	if (mutex_lock_killable(&task->cred_guard_mutex))
+	if (mutex_lock_killable(&task->signal->cred_guard_mutex))
 		return NULL;
 
 	mm = get_task_mm(task);
@@ -235,7 +235,7 @@ struct mm_struct *mm_for_maps(struct tas
 		mmput(mm);
 		mm = NULL;
 	}
-	mutex_unlock(&task->cred_guard_mutex);
+	mutex_unlock(&task->signal->cred_guard_mutex);
 
 	return mm;
 }
@@ -2353,14 +2353,14 @@ static ssize_t proc_pid_attr_write(struc
 		goto out_free;
 
 	/* Guard against adverse ptrace interaction */
-	length = mutex_lock_interruptible(&task->cred_guard_mutex);
+	length = mutex_lock_interruptible(&task->signal->cred_guard_mutex);
 	if (length < 0)
 		goto out_free;
 
 	length = security_setprocattr(task,
 				      (char*)file->f_path.dentry->d_name.name,
 				      (void*)page, count);
-	mutex_unlock(&task->cred_guard_mutex);
+	mutex_unlock(&task->signal->cred_guard_mutex);
 out_free:
 	free_page((unsigned long) page);
 out:
diff -puN include/linux/init_task.h~signals-move-cred_guard_mutex-from-task_struct-to-signal_struct include/linux/init_task.h
--- a/include/linux/init_task.h~signals-move-cred_guard_mutex-from-task_struct-to-signal_struct
+++ a/include/linux/init_task.h
@@ -29,6 +29,8 @@ extern struct fs_struct init_fs;
 		.running = 0,						\
 		.lock = __SPIN_LOCK_UNLOCKED(sig.cputimer.lock),	\
 	},								\
+	.cred_guard_mutex =						\
+		 __MUTEX_INITIALIZER(sig.cred_guard_mutex),		\
 }
 
 extern struct nsproxy init_nsproxy;
@@ -145,8 +147,6 @@ extern struct cred init_cred;
 	.group_leader	= &tsk,						\
 	RCU_INIT_POINTER(.real_cred, &init_cred),			\
 	RCU_INIT_POINTER(.cred, &init_cred),				\
-	.cred_guard_mutex =						\
-		 __MUTEX_INITIALIZER(tsk.cred_guard_mutex),		\
 	.comm		= "swapper",					\
 	.thread		= INIT_THREAD,					\
 	.fs		= &init_fs,					\
diff -puN include/linux/sched.h~signals-move-cred_guard_mutex-from-task_struct-to-signal_struct include/linux/sched.h
--- a/include/linux/sched.h~signals-move-cred_guard_mutex-from-task_struct-to-signal_struct
+++ a/include/linux/sched.h
@@ -626,6 +626,10 @@ struct signal_struct {
 
 	int oom_adj;		/* OOM kill score adjustment (bit shift) */
 	int oom_score_adj;	/* OOM kill score adjustment */
+
+	struct mutex cred_guard_mutex;	/* guard against foreign influences on
+					 * credential calculations
+					 * (notably. ptrace) */
 };
 
 /* Context switch must be unlocked if interrupts are to be enabled */
@@ -1305,9 +1309,6 @@ struct task_struct {
 					 * credentials (COW) */
 	const struct cred __rcu *cred;	/* effective (overridable) subjective task
 					 * credentials (COW) */
-	struct mutex cred_guard_mutex;	/* guard against foreign influences on
-					 * credential calculations
-					 * (notably. ptrace) */
 	struct cred *replacement_session_keyring; /* for KEYCTL_SESSION_TO_PARENT */
 
 	char comm[TASK_COMM_LEN]; /* executable name excluding path
diff -puN include/linux/tracehook.h~signals-move-cred_guard_mutex-from-task_struct-to-signal_struct include/linux/tracehook.h
--- a/include/linux/tracehook.h~signals-move-cred_guard_mutex-from-task_struct-to-signal_struct
+++ a/include/linux/tracehook.h
@@ -150,7 +150,7 @@ static inline void tracehook_report_sysc
  *
  * Return %LSM_UNSAFE_* bits applied to an exec because of tracing.
  *
- * @task->cred_guard_mutex is held by the caller through the do_execve().
+ * @task->signal->cred_guard_mutex is held by the caller through the do_execve().
  */
 static inline int tracehook_unsafe_exec(struct task_struct *task)
 {
diff -puN kernel/cred.c~signals-move-cred_guard_mutex-from-task_struct-to-signal_struct kernel/cred.c
--- a/kernel/cred.c~signals-move-cred_guard_mutex-from-task_struct-to-signal_struct
+++ a/kernel/cred.c
@@ -325,7 +325,7 @@ EXPORT_SYMBOL(prepare_creds);
 
 /*
  * Prepare credentials for current to perform an execve()
- * - The caller must hold current->cred_guard_mutex
+ * - The caller must hold ->cred_guard_mutex
  */
 struct cred *prepare_exec_creds(void)
 {
@@ -384,8 +384,6 @@ int copy_creds(struct task_struct *p, un
 	struct cred *new;
 	int ret;
 
-	mutex_init(&p->cred_guard_mutex);
-
 	if (
 #ifdef CONFIG_KEYS
 		!p->cred->thread_keyring &&
diff -puN kernel/fork.c~signals-move-cred_guard_mutex-from-task_struct-to-signal_struct kernel/fork.c
--- a/kernel/fork.c~signals-move-cred_guard_mutex-from-task_struct-to-signal_struct
+++ a/kernel/fork.c
@@ -908,6 +908,8 @@ static int copy_signal(unsigned long clo
 	sig->oom_adj = current->signal->oom_adj;
 	sig->oom_score_adj = current->signal->oom_score_adj;
 
+	mutex_init(&sig->cred_guard_mutex);
+
 	return 0;
 }
 
diff -puN kernel/ptrace.c~signals-move-cred_guard_mutex-from-task_struct-to-signal_struct kernel/ptrace.c
--- a/kernel/ptrace.c~signals-move-cred_guard_mutex-from-task_struct-to-signal_struct
+++ a/kernel/ptrace.c
@@ -181,7 +181,7 @@ int ptrace_attach(struct task_struct *ta
 	 * under ptrace.
 	 */
 	retval = -ERESTARTNOINTR;
-	if (mutex_lock_interruptible(&task->cred_guard_mutex))
+	if (mutex_lock_interruptible(&task->signal->cred_guard_mutex))
 		goto out;
 
 	task_lock(task);
@@ -208,7 +208,7 @@ int ptrace_attach(struct task_struct *ta
 unlock_tasklist:
 	write_unlock_irq(&tasklist_lock);
 unlock_creds:
-	mutex_unlock(&task->cred_guard_mutex);
+	mutex_unlock(&task->signal->cred_guard_mutex);
 out:
 	return retval;
 }
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
mm-fix-return-value-of-scan_lru_pages-in-memory-unplug.patch
mm-page-allocator-do-not-check-the-state-of-a-non-existant-buddy-during-free.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
oom-add-per-mm-oom-disable-count.patch
oom-add-per-mm-oom-disable-count-protect-oom_disable_count-with-task_lock-in-fork.patch
oom-add-per-mm-oom-disable-count-use-old_mm-for-oom_disable_count-in-exec.patch
oom-avoid-killing-a-task-if-a-thread-sharing-its-mm-cannot-be-killed.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled.patch
vmscan-prevent-background-aging-of-anon-page-in-no-swap-system.patch
mm-mempolicy-check-return-code-of-check_range.patch
mm-add-account_page_writeback.patch
writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat.patch
writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat-update.patch
writeback-add-sys-devices-system-node-node-vmstat.patch
writeback-add-sys-devices-system-node-node-vmstat-update.patch
writeback-report-dirty-thresholds-in-proc-vmstat.patch
vmscan-delete-dead-code.patch
tracing-vmscan-add-trace-events-for-lru-list-shrinking.patch
writeback-account-for-time-spent-congestion_waited.patch
vmscan-synchronous-lumpy-reclaim-should-not-call-congestion_wait.patch
vmscan-narrow-the-scenarios-lumpy-reclaim-uses-synchrounous-reclaim.patch
vmscan-remove-dead-code-in-shrink_inactive_list.patch
vmscan-isolated_lru_pages-stop-neighbour-search-if-neighbour-cannot-be-isolated.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encountered-in-the-current-zone.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encounted-in-the-current-zone-fix.patch
writeback-remove-the-internal-5%-low-bound-on-dirty_ratio.patch
vmscantmpfs-treat-used-once-pages-on-tmpfs-as-used-once.patch
mm-memory_hotplugc-make-scan_lru_pages-static.patch
mm-page_isolation-codeclean-fix-comment-and-rm-unneeded-val-init.patch
mm-do_migrate_range-exit-loop-if-not_managed-is-true.patch
mm-do_migrate_range-reduce-list_empty-check.patch
signals-move-cred_guard_mutex-from-task_struct-to-signal_struct.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch
proc-pid-smaps-export-amount-of-anonymous-memory-in-a-mapping.patch
proc-pid-smaps-export-amount-of-anonymous-memory-in-a-mapping-doc.patch
proc-pid-pagemap-document-in-documentation-filesystems-proctxt.patch
exec-dont-turn-pf_kthread-off-when-a-target-command-was-not-found.patch

