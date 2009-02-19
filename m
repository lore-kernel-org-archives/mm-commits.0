From: akpm@linux-foundation.org
Subject: + signals-protect-init-from-unwanted-signals-more.patch added to -mm tree
Date: Thu, 19 Feb 2009 14:26:17 -0800
Message-ID: <200902192226.n1JMQIs6027279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754456AbZBSW1I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 17:27:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, daniel.lezcano@free.fr, ebiederm@xmission.com, oleg@tv-sign.ru, roland@redhat.com, sukadev@linux.vnet.ibm.com


The patch titled
     signals: protect init from unwanted signals more
has been added to the -mm tree.  Its filename is
     signals-protect-init-from-unwanted-signals-more.patch

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
Subject: signals: protect init from unwanted signals more
From: Oleg Nesterov <oleg@redhat.com>

(This is a modified version of the patch submitted by Oleg Nesterov
http://lkml.org/lkml/2008/11/18/249 and tries to address comments that
came up in that discussion)

init ignores the SIG_DFL signals but we queue them anyway, including
SIGKILL.  This is mostly OK, the signal will be dropped silently when
dequeued, but the pending SIGKILL has 2 bad implications:

        - it implies fatal_signal_pending(), so we confuse things
          like wait_for_completion_killable/lock_page_killable.

        - for the sub-namespace inits, the pending SIGKILL can
          mask (legacy_queue) the subsequent SIGKILL from the
          parent namespace which must kill cinit reliably.
          (preparation, cinits don't have SIGNAL_UNKILLABLE yet)

The patch can't help when init is ptraced, but ptracing of init is not
"safe" anyway.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff -puN kernel/signal.c~signals-protect-init-from-unwanted-signals-more kernel/signal.c
--- a/kernel/signal.c~signals-protect-init-from-unwanted-signals-more
+++ a/kernel/signal.c
@@ -55,10 +55,21 @@ static int sig_handler_ignored(void __us
 		(handler == SIG_DFL && sig_kernel_ignore(sig));
 }
 
-static int sig_ignored(struct task_struct *t, int sig)
+static int sig_task_ignored(struct task_struct *t, int sig)
 {
 	void __user *handler;
 
+	handler = sig_handler(t, sig);
+
+	if (unlikely(t->signal->flags & SIGNAL_UNKILLABLE) &&
+			handler == SIG_DFL)
+		return 1;
+
+	return sig_handler_ignored(handler, sig);
+}
+
+static int sig_ignored(struct task_struct *t, int sig)
+{
 	/*
 	 * Blocked signals are never ignored, since the
 	 * signal handler may change by the time it is
@@ -67,8 +78,7 @@ static int sig_ignored(struct task_struc
 	if (sigismember(&t->blocked, sig) || sigismember(&t->real_blocked, sig))
 		return 0;
 
-	handler = sig_handler(t, sig);
-	if (!sig_handler_ignored(handler, sig))
+	if (!sig_task_ignored(t, sig))
 		return 0;
 
 	/*
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
pipe_rdwr_fasync-fix-the-error-handling-to-prevent-the-leak-crash.patch
get_mm_hiwater_xxx-trivial-s-define-inline.patch
getrusage-fill-ru_maxrss-value.patch
do_wait-fix-waiting-for-the-group-stop-with-the-dead-leader.patch
signals-remove-handler-parameter-to-tracehook-functions.patch
signals-protect-init-from-unwanted-signals-more.patch
ptrace-kill-__ptrace_detach-fix-exit_state-check.patch
ptrace-simplify-ptrace_exit-ignoring_children-path.patch
ptrace-simplify-ptrace_exit-ignoring_children-pathpatch-fix.patch
ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit.patch
ptrace-reintroduce-__ptrace_detach-as-a-callee-of-ptrace_exit-fix.patch
ptrace-fix-possible-zombie-leak-on-ptrace_detach.patch
reparent_thread-dont-call-kill_orphaned_pgrp-if-task_detached.patch
reparent_thread-fix-the-is-it-traced-check.patch
reparent_thread-fix-a-zombie-leak-if-sbin-init-ignores-sigchld.patch
forget_original_parent-split-out-the-un-ptrace-part.patch
forget_original_parent-do-not-abuse-child-ptrace_entry.patch
forget_original_parent-do-not-abuse-child-ptrace_entry-fix.patch
move-exit_ptrace-from-forget_original_parent-to-do_exit.patch
reparent-untrace-do-nothing-if-no-childs-tracees.patch
tracehook_notify_death-use-task_detached-helper.patch
ptrace_detach-the-wrong-wakeup-breaks-the-erestartxxx-logic.patch
ptrace_untrace-fix-the-signal_stop_stopped-check.patch
workqueue-avoid-recursion-in-run_workqueue.patch
kthreads-simplify-the-startup-synchronization.patch
kthreads-rework-kthread_stop.patch
kthreads-simplify-migration_thread-exit-path.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp.patch
pids-refactor-vnr-nr_ns-helpers-to-make-them-safe.patch
pids-kill-now-unused-signal_struct-__pgrp-__session-and-friends.patch

