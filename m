From: akpm@linux-foundation.org
Subject: [merged] signals-remove-handler-parameter-to-tracehook-functions.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:35:16 -0700
Message-ID: <200904061935.n36JZGBF011984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37429 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754283AbZDFTmw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:42:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, daniel.lezcano@free.fr, ebiederm@xmission.com, hpa@zytor.com, mingo@elte.hu, oleg@tv-sign.ru, roland@redhat.com, sukadev@linux.vnet.ibm.com, tglx@linutronix.de, mm-co


The patch titled
     signals: remove 'handler' parameter to tracehook functions
has been removed from the -mm tree.  Its filename was
     signals-remove-handler-parameter-to-tracehook-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: remove 'handler' parameter to tracehook functions
From: Oleg Nesterov <oleg@redhat.com>

Container-init must behave like global-init to processes within the
container and hence it must be immune to unhandled fatal signals from
within the container (i.e SIG_DFL signals that terminate the process).

But the same container-init must behave like a normal process to processes
in ancestor namespaces and so if it receives the same fatal signal from a
process in ancestor namespace, the signal must be processed.

Implementing these semantics requires that send_signal() determine pid
namespace of the sender but since signals can originate from workqueues/
interrupt-handlers, determining pid namespace of sender may not always be
possible or safe.

This patchset implements the design/simplified semantics suggested by
Oleg Nesterov.  The simplified semantics for container-init are:

	- container-init must never be terminated by a signal from a
	  descendant process.

	- container-init must never be immune to SIGKILL from an ancestor
	  namespace (so a process in parent namespace must always be able
	  to terminate a descendant container).

	- container-init may be immune to unhandled fatal signals (like
	  SIGUSR1) even if they are from ancestor namespace. SIGKILL/SIGSTOP
	  are the only reliable signals to a container-init from ancestor
	  namespace.


This patch:

Based on an earlier patch submitted by Oleg Nesterov and comments from
Roland McGrath (http://lkml.org/lkml/2008/11/19/258).

The handler parameter is currently unused in the tracehook functions. 
Besides, the tracehook functions are called with siglock held, so the
functions can check the handler if they later need to.

Removing the parameter simiplifies changes to sig_ignored() in a follow-on
patch.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/ptrace.c  |    2 +-
 include/linux/tracehook.h |   13 ++++---------
 kernel/signal.c           |    6 +++---
 3 files changed, 8 insertions(+), 13 deletions(-)

diff -puN arch/x86/kernel/ptrace.c~signals-remove-handler-parameter-to-tracehook-functions arch/x86/kernel/ptrace.c
--- a/arch/x86/kernel/ptrace.c~signals-remove-handler-parameter-to-tracehook-functions
+++ a/arch/x86/kernel/ptrace.c
@@ -1455,6 +1455,6 @@ asmregparm void syscall_trace_leave(stru
 	 * system call instruction.
 	 */
 	if (test_thread_flag(TIF_SINGLESTEP) &&
-	    tracehook_consider_fatal_signal(current, SIGTRAP, SIG_DFL))
+	    tracehook_consider_fatal_signal(current, SIGTRAP))
 		send_sigtrap(current, regs, 0, TRAP_BRKPT);
 }
diff -puN include/linux/tracehook.h~signals-remove-handler-parameter-to-tracehook-functions include/linux/tracehook.h
--- a/include/linux/tracehook.h~signals-remove-handler-parameter-to-tracehook-functions
+++ a/include/linux/tracehook.h
@@ -388,17 +388,14 @@ static inline void tracehook_signal_hand
  * tracehook_consider_ignored_signal - suppress short-circuit of ignored signal
  * @task:		task receiving the signal
  * @sig:		signal number being sent
- * @handler:		%SIG_IGN or %SIG_DFL
  *
  * Return zero iff tracing doesn't care to examine this ignored signal,
  * so it can short-circuit normal delivery and never even get queued.
- * Either @handler is %SIG_DFL and @sig's default is ignore, or it's %SIG_IGN.
  *
  * Called with @task->sighand->siglock held.
  */
 static inline int tracehook_consider_ignored_signal(struct task_struct *task,
-						    int sig,
-						    void __user *handler)
+						    int sig)
 {
 	return (task_ptrace(task) & PT_PTRACED) != 0;
 }
@@ -407,19 +404,17 @@ static inline int tracehook_consider_ign
  * tracehook_consider_fatal_signal - suppress special handling of fatal signal
  * @task:		task receiving the signal
  * @sig:		signal number being sent
- * @handler:		%SIG_DFL or %SIG_IGN
  *
  * Return nonzero to prevent special handling of this termination signal.
- * Normally @handler is %SIG_DFL.  It can be %SIG_IGN if @sig is ignored,
- * in which case force_sig() is about to reset it to %SIG_DFL.
+ * Normally handler for signal is %SIG_DFL.  It can be %SIG_IGN if @sig is
+ * ignored, in which case force_sig() is about to reset it to %SIG_DFL.
  * When this returns zero, this signal might cause a quick termination
  * that does not give the debugger a chance to intercept the signal.
  *
  * Called with or without @task->sighand->siglock held.
  */
 static inline int tracehook_consider_fatal_signal(struct task_struct *task,
-						  int sig,
-						  void __user *handler)
+						  int sig)
 {
 	return (task_ptrace(task) & PT_PTRACED) != 0;
 }
diff -puN kernel/signal.c~signals-remove-handler-parameter-to-tracehook-functions kernel/signal.c
--- a/kernel/signal.c~signals-remove-handler-parameter-to-tracehook-functions
+++ a/kernel/signal.c
@@ -74,7 +74,7 @@ static int sig_ignored(struct task_struc
 	/*
 	 * Tracers may want to know about even ignored signals.
 	 */
-	return !tracehook_consider_ignored_signal(t, sig, handler);
+	return !tracehook_consider_ignored_signal(t, sig);
 }
 
 /*
@@ -318,7 +318,7 @@ int unhandled_signal(struct task_struct 
 		return 1;
 	if (handler != SIG_IGN && handler != SIG_DFL)
 		return 0;
-	return !tracehook_consider_fatal_signal(tsk, sig, handler);
+	return !tracehook_consider_fatal_signal(tsk, sig);
 }
 
 
@@ -777,7 +777,7 @@ static void complete_signal(int sig, str
 	    !(signal->flags & (SIGNAL_UNKILLABLE | SIGNAL_GROUP_EXIT)) &&
 	    !sigismember(&t->real_blocked, sig) &&
 	    (sig == SIGKILL ||
-	     !tracehook_consider_fatal_signal(t, sig, SIG_DFL))) {
+	     !tracehook_consider_fatal_signal(t, sig))) {
 		/*
 		 * This signal will be fatal to the whole group.
 		 */
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
getrusage-fill-ru_maxrss-value.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
signals-tracehook_notify_jctl-change.patch

