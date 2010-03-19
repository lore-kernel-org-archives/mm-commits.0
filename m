From: akpm@linux-foundation.org
Subject: + exit-change-zap_other_threads-to-count-sub-threads.patch added to -mm tree
Date: Fri, 19 Mar 2010 15:12:20 -0700
Message-ID: <201003192212.o2JMCKTQ015268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33434 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038Ab0CSWMe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 18:12:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, roland@redhat.com, vfalico@redhat.com


The patch titled
     exit: change zap_other_threads() to count sub-threads
has been added to the -mm tree.  Its filename is
     exit-change-zap_other_threads-to-count-sub-threads.patch

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
Subject: exit: change zap_other_threads() to count sub-threads
From: Oleg Nesterov <oleg@redhat.com>

Change zap_other_threads() to return the number of other sub-threads found
on ->thread_group list.

Other changes are cosmetic:

	- change the code to use while_each_thread() helper

	- remove the obsolete comment about SIGKILL/SIGSTOP

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: Veaceslav Falico <vfalico@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 +-
 kernel/signal.c       |   17 +++++++++--------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff -puN include/linux/sched.h~exit-change-zap_other_threads-to-count-sub-threads include/linux/sched.h
--- a/include/linux/sched.h~exit-change-zap_other_threads-to-count-sub-threads
+++ a/include/linux/sched.h
@@ -2038,7 +2038,7 @@ extern int do_notify_parent(struct task_
 extern void __wake_up_parent(struct task_struct *p, struct task_struct *parent);
 extern void force_sig(int, struct task_struct *);
 extern int send_sig(int, struct task_struct *, int);
-extern void zap_other_threads(struct task_struct *p);
+extern int zap_other_threads(struct task_struct *p);
 extern struct sigqueue *sigqueue_alloc(void);
 extern void sigqueue_free(struct sigqueue *);
 extern int send_sigqueue(struct sigqueue *,  struct task_struct *, int group);
diff -puN kernel/signal.c~exit-change-zap_other_threads-to-count-sub-threads kernel/signal.c
--- a/kernel/signal.c~exit-change-zap_other_threads-to-count-sub-threads
+++ a/kernel/signal.c
@@ -1083,23 +1083,24 @@ force_sig_info(int sig, struct siginfo *
 /*
  * Nuke all other threads in the group.
  */
-void zap_other_threads(struct task_struct *p)
+int zap_other_threads(struct task_struct *p)
 {
-	struct task_struct *t;
+	struct task_struct *t = p;
+	int count = 0;
 
 	p->signal->group_stop_count = 0;
 
-	for (t = next_thread(p); t != p; t = next_thread(t)) {
-		/*
-		 * Don't bother with already dead threads
-		 */
+	while_each_thread(p, t) {
+		count++;
+
+		/* Don't bother with already dead threads */
 		if (t->exit_state)
 			continue;
-
-		/* SIGKILL will be handled before any pending SIGSTOP */
 		sigaddset(&t->pending.signal, SIGKILL);
 		signal_wake_up(t, 1);
 	}
+
+	return count;
 }
 
 struct sighand_struct *lock_task_sighand(struct task_struct *tsk, unsigned long *flags)
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch
cpu-timers-simplify-rlimit_cpu-handling.patch
cpu-timers-cleanup-arm_timer.patch
cpu-timers-return-correct-previous-timer-reload-value.patch
cpu-timers-change-sigev_none-timer-implementation.patch
cpu-timers-assure-to-not-iterate-over-all-threads-in-fastpath_timer_check.patch
cpu-timers-optimize-run_posix_cpu_timers.patch
proc-cleanup-remove-unused-assignments.patch
kmod-add-init-function-to-usermodehelper.patch
exec-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit.patch
umh-creds-convert-call_usermodehelper_keys-to-use-subprocess_info-init.patch
umh-creds-kill-subprocess_info-cred-logic.patch
call_usermodehelper-no-need-to-unblock-signals.patch
wait_for_helper-sigchld-from-user-space-can-lead-to-use-after-free.patch
call_usermodehelper-simplify-fix-umh_no_wait-case.patch
call_usermodehelper-umh_wait_exec-ignores-kernel_thread-failure.patch
coredump-factor-out-the-not-ispipe-file-checks.patch
coredump-cleanup-ispipe-code.patch
coredump-factor-out-put_cred-calls.patch
coredump-shift-down_writemmap_sem-into-coredump_wait.patch
exit-exit_notify-can-trust-signal-notify_count-0.patch
exit-change-zap_other_threads-to-count-sub-threads.patch
exit-avoid-sig-count-in-de_thread-__exit_signal-synchronization.patch
exit-avoid-sig-count-in-__exit_signal-to-detect-the-group-dead-case.patch

