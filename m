From: akpm@linux-foundation.org
Subject: + cred-remove-task_is_dead-from-__task_cred-validation.patch added to -mm tree
Date: Thu, 12 Apr 2012 15:27:30 -0700
Message-ID: <20120412222731.88502A03B2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:44134 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966110Ab2DLW1e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Apr 2012 18:27:34 -0400
Received: by bkcjm19 with SMTP id jm19so110688bkc.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Apr 2012 15:27:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, dhowells@redhat.com, ebiederm@xmission.com, jmorris@namei.org, jolsa@redhat.com, paulmck@linux.vnet.ibm.com


The patch titled
     Subject: cred: remove task_is_dead() from __task_cred() validation
has been added to the -mm tree.  Its filename is
     cred-remove-task_is_dead-from-__task_cred-validation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -276,17 +276,13 @@ static inline void put_cred(const struct
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
-	uid_t uid = __task_cred(p)->uid;
+	uid_t uid = task_uid(p);
 	struct siginfo __user *infop;
 
 	if (!likely(wo->wo_flags & WEXITED))
_
Subject: Subject: cred: remove task_is_dead() from __task_cred() validation

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
avr32-dont-mask-signals-in-the-error-path.patch
avr32-use-set_current_blocked-in-handle_signal-sys_rt_sigreturn.patch
avr32-use-block_sigmask.patch
m32r-use-set_current_blocked-and-block_sigmask.patch
m68k-use-set_current_blocked-and-block_sigmask.patch
mn10300-use-set_current_blocked-and-block_sigmask.patch
cris-use-set_current_blocked-and-block_sigmask.patch
ia64-use-set_current_blocked-and-block_sigmask.patch
microblaze-dont-reimplement-force_sigsegv.patch
microblaze-no-need-to-reset-handler-if-sa_oneshot.patch
microblaze-fix-signal-masking.patch
microblaze-use-set_current_blocked-and-block_sigmask.patch
mips-use-set_current_blocked-and-block_sigmask.patch
score-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch
score-use-set_current_blocked-and-block_sigmask.patch
h8300-use-set_current_blocked-and-block_sigmask.patch
unicore32-use-block_sigmask.patch
blackfin-use-set_current_blocked-and-block_sigmask.patch
frv-use-set_current_blocked-and-block_sigmask.patch
parisc-use-set_current_blocked-and-block_sigmask.patch
kmod-unexport-call_usermodehelper_freeinfo.patch
kmod-convert-two-call-sites-to-call_usermodehelper_fns.patch
kmod-move-call_usermodehelper_fns-to-c-file-and-unexport-all-its-helpers.patch
cred-remove-task_is_dead-from-__task_cred-validation.patch
proc-clean-up-proc-pid-environ-handling.patch
proc-unify-ptrace_may_access-locking-code.patch
proc-remove-mm_for_maps.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch
proc-use-task_access_lock-instead-of-ptrace_may_access.patch
proc-use-is_err_or_null.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch

