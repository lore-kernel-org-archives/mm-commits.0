From: akpm@linux-foundation.org
Subject: [merged] cred-remove-task_is_dead-from-__task_cred-validation.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:33:44 -0700
Message-ID: <20120601193344.7F2B0A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:52540 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932615Ab2FATdq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:33:46 -0400
Received: by mail-ey0-f202.google.com with SMTP id o13so111891eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:33:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, dhowells@redhat.com, ebiederm@xmission.com, jmorris@namei.org, jolsa@redhat.com, paulmck@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cred: remove task_is_dead() from __task_cred() validation
has been removed from the -mm tree.  Its filename was
     cred-remove-task_is_dead-from-__task_cred-validation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: cred: remove task_is_dead() from __task_cred() validation

commit 8f92054e ("CRED: Fix __task_cred()'s lockdep check and banner
comment"):

    add the following validation condition:

        task->exit_state >= 0

    to permit the access if the target task is dead and therefore
    unable to change its own credentials.

OK, but afaics currently this can only help wait_task_zombie() which calls
__task_cred() without rcu lock.

Remove this validation and change wait_task_zombie() to use task_uid()
instead.  This means we do rcu_read_lock() only to shut up the lockdep,
but we already do the same in, say, wait_task_stopped().

task_is_dead() should die, task->exit_state != 0 means that this task has
passed exit_notify(), only do_wait-like code paths should use this.

Unfortunately, we can't kill task_is_dead() right now, it has already
acquired buggy users in drivers/staging.  The fix already exists.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: David Howells <dhowells@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cred.h |   10 +++-------
 kernel/exit.c        |    2 +-
 2 files changed, 4 insertions(+), 8 deletions(-)

diff -puN include/linux/cred.h~cred-remove-task_is_dead-from-__task_cred-validation include/linux/cred.h
--- a/include/linux/cred.h~cred-remove-task_is_dead-from-__task_cred-validation
+++ a/include/linux/cred.h
@@ -277,17 +277,13 @@ static inline void put_cred(const struct
  * @task: The task to query
  *
  * Access the objective credentials of a task.  The caller must hold the RCU
- * readlock or the task must be dead and unable to change its own credentials.
+ * readlock.
  *
  * The result of this function should not be passed directly to get_cred();
  * rather get_task_cred() should be used instead.
  */
-#define __task_cred(task)						\
-	({								\
-		const struct task_struct *__t = (task);			\
-		rcu_dereference_check(__t->real_cred,			\
-				      task_is_dead(__t));		\
-	})
+#define __task_cred(task)	\
+	rcu_dereference((task)->real_cred)
 
 /**
  * get_current_cred - Get the current task's subjective credentials
diff -puN kernel/exit.c~cred-remove-task_is_dead-from-__task_cred-validation kernel/exit.c
--- a/kernel/exit.c~cred-remove-task_is_dead-from-__task_cred-validation
+++ a/kernel/exit.c
@@ -1214,7 +1214,7 @@ static int wait_task_zombie(struct wait_
 	unsigned long state;
 	int retval, status, traced;
 	pid_t pid = task_pid_vnr(p);
-	uid_t uid = from_kuid_munged(current_user_ns(), __task_cred(p)->uid);
+	uid_t uid = from_kuid_munged(current_user_ns(), task_uid(p));
 	struct siginfo __user *infop;
 
 	if (!likely(wo->wo_flags & WEXITED))
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
stack-usage-add-pid-to-warning-printk-in-check_stack_usage.patch
proc-clean-up-proc-pid-environ-handling.patch
proc-remove-mm_for_maps.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
cpu-introduce-clear_tasks_mm_cpumask-helper.patch
arm-use-clear_tasks_mm_cpumask.patch
powerpc-use-clear_tasks_mm_cpumask.patch
sh-use-clear_tasks_mm_cpumask.patch
blackfin-a-couple-of-task-mm-handling-fixes.patch
blackfin-fix-possible-deadlock-in-decode_address.patch
um-should-hold-tasklist_lock-while-traversing-processes.patch
um-fix-possible-race-on-task-mm.patch
um-properly-check-all-process-threads-for-a-live-mm.patch
pidns-use-task_active_pid_ns-in-do_notify_parent.patch
pidns-make-killed-children-autoreap.patch
aio-vfs-cleanup-of-rw_copy_check_uvector-and-compat_rw_copy_check_uvector.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
c-r-prctl-drop-vma-flags-test-on-pr_set_mm_-stack-data-assignment.patch

