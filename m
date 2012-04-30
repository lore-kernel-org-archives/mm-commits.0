From: akpm@linux-foundation.org
Subject: + keys-kill-task_struct-replacement_session_keyring.patch added to -mm tree
Date: Mon, 30 Apr 2012 16:51:07 -0700
Message-ID: <20120430235107.71E06A04C2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:55038 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757456Ab2D3XvI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Apr 2012 19:51:08 -0400
Received: by ghbz15 with SMTP id z15so403871ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Apr 2012 16:51:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, agordeev@redhat.com, chris@zankel.net, dhowells@redhat.com, dsmith@redhat.com, fche@redhat.com, geert@linux-m68k.org, lwoodman@redhat.com, mingo@elte.hu, peterz@infradead.org, rkuo@codeaurora.org, tglx@linutronix.de, tj@kernel.org, torvalds@linux-foundation.org


The patch titled
     Subject: keys: kill task_struct->replacement_session_keyring
has been added to the -mm tree.  Its filename is
     keys-kill-task_struct-replacement_session_keyring.patch

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
Subject: keys: kill task_struct->replacement_session_keyring

Kill the no longer used task_struct->replacement_session_keyring, update
copy_creds() and exit_creds().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: David Howells <dhowells@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Gordeev <agordeev@redhat.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Smith <dsmith@redhat.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 --
 kernel/cred.c         |    9 ---------
 2 files changed, 11 deletions(-)

diff -puN include/linux/sched.h~keys-kill-task_struct-replacement_session_keyring include/linux/sched.h
--- a/include/linux/sched.h~keys-kill-task_struct-replacement_session_keyring
+++ a/include/linux/sched.h
@@ -1412,8 +1412,6 @@ struct task_struct {
 					 * credentials (COW) */
 	const struct cred __rcu *cred;	/* effective (overridable) subjective task
 					 * credentials (COW) */
-	struct cred *replacement_session_keyring; /* for KEYCTL_SESSION_TO_PARENT */
-
 	char comm[TASK_COMM_LEN]; /* executable name excluding path
 				     - access with [gs]et_task_comm (which lock
 				       it with task_lock())
diff -puN kernel/cred.c~keys-kill-task_struct-replacement_session_keyring kernel/cred.c
--- a/kernel/cred.c~keys-kill-task_struct-replacement_session_keyring
+++ a/kernel/cred.c
@@ -198,13 +198,6 @@ void exit_creds(struct task_struct *tsk)
 	validate_creds(cred);
 	alter_cred_subscribers(cred, -1);
 	put_cred(cred);
-
-	cred = (struct cred *) tsk->replacement_session_keyring;
-	if (cred) {
-		tsk->replacement_session_keyring = NULL;
-		validate_creds(cred);
-		put_cred(cred);
-	}
 }
 
 /**
@@ -386,8 +379,6 @@ int copy_creds(struct task_struct *p, un
 	struct cred *new;
 	int ret;
 
-	p->replacement_session_keyring = NULL;
-
 	if (
 #ifdef CONFIG_KEYS
 		!p->cred->thread_keyring &&
_
Subject: Subject: keys: kill task_struct->replacement_session_keyring

Patches currently in -mm which might be from oleg@redhat.com are

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
score-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch
score-use-set_current_blocked-and-block_sigmask.patch
h8300-use-set_current_blocked-and-block_sigmask.patch
unicore32-use-block_sigmask.patch
blackfin-use-set_current_blocked-and-block_sigmask.patch
mm-fork-fix-overflow-in-vma-length-when-copying-mmap-on-clone.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
frv-use-set_current_blocked-and-block_sigmask.patch
parisc-use-set_current_blocked-and-block_sigmask.patch
task_work_add-generic-process-context-callbacks.patch
genirq-reimplement-exit_irq_thread-hook-via-task_work_add.patch
hexagon-do_notify_resume-needs-tracehook_notify_resume.patch
keys-change-keyctl_session_to_parent-to-use-task_work_add.patch
keys-kill-the-dummy-key_replace_session_keyring.patch
keys-kill-task_struct-replacement_session_keyring.patch
kmod-unexport-call_usermodehelper_freeinfo.patch
kmod-convert-two-call-sites-to-call_usermodehelper_fns.patch
kmod-move-call_usermodehelper_fns-to-c-file-and-unexport-all-its-helpers.patch
cred-remove-task_is_dead-from-__task_cred-validation.patch
stack-usage-add-pid-to-warning-printk-in-check_stack_usage.patch
proc-clean-up-proc-pid-environ-handling.patch
proc-unify-ptrace_may_access-locking-code.patch
proc-remove-mm_for_maps.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch
proc-use-is_err_or_null.patch
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
aio-vfs-cleanup-of-rw_copy_check_uvector-and-compat_rw_copy_check_uvector.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9-fix.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
c-r-prctl-drop-vma-flags-test-on-pr_set_mm_-stack-data-assignment.patch

