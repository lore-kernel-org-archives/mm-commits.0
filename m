From: akpm@linux-foundation.org
Subject: - tracehook-get_signal_to_deliver.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:16:57 -0700
Message-ID: <200807262116.m6QLGvaQ019884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34864 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757773AbYGZVR2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:17:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, mingo@elte.hu, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     tracehook: get_signal_to_deliver
has been removed from the -mm tree.  Its filename was
     tracehook-get_signal_to_deliver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tracehook: get_signal_to_deliver
From: Roland McGrath <roland@redhat.com>

This defines the tracehook_get_signal() hook to allow tracing code to slip
in before normal signal dequeuing.  This lays the groundwork for new
tracing features that can inject synthetic signals outside the normal
queue or control the disposition of delivered signals.  The calling
convention lets tracehook_get_signal() decide both exactly what will
happen and what signal number to report in the handler/exit.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tracehook.h |   29 +++++++++++++++++++++++++++
 kernel/signal.c           |   38 +++++++++++++++++++++++++-----------
 2 files changed, 56 insertions(+), 11 deletions(-)

diff -puN include/linux/tracehook.h~tracehook-get_signal_to_deliver include/linux/tracehook.h
--- a/include/linux/tracehook.h~tracehook-get_signal_to_deliver
+++ a/include/linux/tracehook.h
@@ -422,4 +422,33 @@ static inline int tracehook_consider_fat
 	return (task_ptrace(task) & PT_PTRACED) != 0;
 }
 
+/**
+ * tracehook_get_signal - deliver synthetic signal to traced task
+ * @task:		@current
+ * @regs:		task_pt_regs(@current)
+ * @info:		details of synthetic signal
+ * @return_ka:		sigaction for synthetic signal
+ *
+ * Return zero to check for a real pending signal normally.
+ * Return -1 after releasing the siglock to repeat the check.
+ * Return a signal number to induce an artifical signal delivery,
+ * setting *@info and *@return_ka to specify its details and behavior.
+ *
+ * The @return_ka->sa_handler value controls the disposition of the
+ * signal, no matter the signal number.  For %SIG_DFL, the return value
+ * is a representative signal to indicate the behavior (e.g. %SIGTERM
+ * for death, %SIGQUIT for core dump, %SIGSTOP for job control stop,
+ * %SIGTSTP for stop unless in an orphaned pgrp), but the signal number
+ * reported will be @info->si_signo instead.
+ *
+ * Called with @task->sighand->siglock held, before dequeuing pending signals.
+ */
+static inline int tracehook_get_signal(struct task_struct *task,
+				       struct pt_regs *regs,
+				       siginfo_t *info,
+				       struct k_sigaction *return_ka)
+{
+	return 0;
+}
+
 #endif	/* <linux/tracehook.h> */
diff -puN kernel/signal.c~tracehook-get_signal_to_deliver kernel/signal.c
--- a/kernel/signal.c~tracehook-get_signal_to_deliver
+++ a/kernel/signal.c
@@ -1754,17 +1754,33 @@ relock:
 		    do_signal_stop(0))
 			goto relock;
 
-		signr = dequeue_signal(current, &current->blocked, info);
-		if (!signr)
-			break; /* will return 0 */
+		/*
+		 * Tracing can induce an artifical signal and choose sigaction.
+		 * The return value in @signr determines the default action,
+		 * but @info->si_signo is the signal number we will report.
+		 */
+		signr = tracehook_get_signal(current, regs, info, return_ka);
+		if (unlikely(signr < 0))
+			goto relock;
+		if (unlikely(signr != 0))
+			ka = return_ka;
+		else {
+			signr = dequeue_signal(current, &current->blocked,
+					       info);
 
-		if (signr != SIGKILL) {
-			signr = ptrace_signal(signr, info, regs, cookie);
 			if (!signr)
-				continue;
+				break; /* will return 0 */
+
+			if (signr != SIGKILL) {
+				signr = ptrace_signal(signr, info,
+						      regs, cookie);
+				if (!signr)
+					continue;
+			}
+
+			ka = &sighand->action[signr-1];
 		}
 
-		ka = &sighand->action[signr-1];
 		if (ka->sa.sa_handler == SIG_IGN) /* Do nothing.  */
 			continue;
 		if (ka->sa.sa_handler != SIG_DFL) {
@@ -1812,7 +1828,7 @@ relock:
 				spin_lock_irq(&sighand->siglock);
 			}
 
-			if (likely(do_signal_stop(signr))) {
+			if (likely(do_signal_stop(info->si_signo))) {
 				/* It released the siglock.  */
 				goto relock;
 			}
@@ -1833,7 +1849,7 @@ relock:
 
 		if (sig_kernel_coredump(signr)) {
 			if (print_fatal_signals)
-				print_fatal_signal(regs, signr);
+				print_fatal_signal(regs, info->si_signo);
 			/*
 			 * If it was able to dump core, this kills all
 			 * other threads in the group and synchronizes with
@@ -1842,13 +1858,13 @@ relock:
 			 * first and our do_group_exit call below will use
 			 * that value and ignore the one we pass it.
 			 */
-			do_coredump((long)signr, signr, regs);
+			do_coredump(info->si_signo, info->si_signo, regs);
 		}
 
 		/*
 		 * Death signals, no core dump.
 		 */
-		do_group_exit(signr);
+		do_group_exit(info->si_signo);
 		/* NOTREACHED */
 	}
 	spin_unlock_irq(&sighand->siglock);
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
tracehook-syscall.patch
tracehook-config_have_arch_tracehook.patch
x86-tracehook_signal_handler.patch
x86-tracehook-syscall.patch
x86-tracehook-asm-syscallh.patch
x86-signals-use-asm-syscallh.patch
x86-tracehook-tif_notify_resume.patch
x86-tracehook-config_have_arch_tracehook.patch

