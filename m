From: akpm@linux-foundation.org
Subject: - tracehook-job-control.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:16:59 -0700
Message-ID: <200807262116.m6QLGxJX019887@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40297 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757889AbYGZVRc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:17:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, mingo@elte.hu, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     tracehook: job control
has been removed from the -mm tree.  Its filename was
     tracehook-job-control.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tracehook: job control
From: Roland McGrath <roland@redhat.com>

This defines the tracehook_notify_jctl() hook to formalize the ptrace
effects on the job control notifications.  There is no change, only
cleanup.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tracehook.h |   20 ++++++++++++++++++++
 kernel/signal.c           |   10 +++++-----
 2 files changed, 25 insertions(+), 5 deletions(-)

diff -puN include/linux/tracehook.h~tracehook-job-control include/linux/tracehook.h
--- a/include/linux/tracehook.h~tracehook-job-control
+++ a/include/linux/tracehook.h
@@ -451,4 +451,24 @@ static inline int tracehook_get_signal(s
 	return 0;
 }
 
+/**
+ * tracehook_notify_jctl - report about job control stop/continue
+ * @notify:		nonzero if this is the last thread in the group to stop
+ * @why:		%CLD_STOPPED or %CLD_CONTINUED
+ *
+ * This is called when we might call do_notify_parent_cldstop().
+ * It's called when about to stop for job control; we are already in
+ * %TASK_STOPPED state, about to call schedule().  It's also called when
+ * a delayed %CLD_STOPPED or %CLD_CONTINUED report is ready to be made.
+ *
+ * Return nonzero to generate a %SIGCHLD with @why, which is
+ * normal if @notify is nonzero.
+ *
+ * Called with no locks held.
+ */
+static inline int tracehook_notify_jctl(int notify, int why)
+{
+	return notify || (current->ptrace & PT_PTRACED);
+}
+
 #endif	/* <linux/tracehook.h> */
diff -puN kernel/signal.c~tracehook-job-control kernel/signal.c
--- a/kernel/signal.c~tracehook-job-control
+++ a/kernel/signal.c
@@ -596,9 +596,6 @@ static int check_kill_permission(int sig
 	return security_task_kill(t, info, sig, 0);
 }
 
-/* forward decl */
-static void do_notify_parent_cldstop(struct task_struct *tsk, int why);
-
 /*
  * Handle magic process-wide effects of stop/continue signals. Unlike
  * the signal actions, these happen immediately at signal-generation
@@ -1605,7 +1602,7 @@ finish_stop(int stop_count)
 	 * a group stop in progress and we are the last to stop,
 	 * report to the parent.  When ptraced, every thread reports itself.
 	 */
-	if (stop_count == 0 || (current->ptrace & PT_PTRACED)) {
+	if (tracehook_notify_jctl(stop_count == 0, CLD_STOPPED)) {
 		read_lock(&tasklist_lock);
 		do_notify_parent_cldstop(current, CLD_STOPPED);
 		read_unlock(&tasklist_lock);
@@ -1741,6 +1738,9 @@ relock:
 		signal->flags &= ~SIGNAL_CLD_MASK;
 		spin_unlock_irq(&sighand->siglock);
 
+		if (unlikely(!tracehook_notify_jctl(1, why)))
+			goto relock;
+
 		read_lock(&tasklist_lock);
 		do_notify_parent_cldstop(current->group_leader, why);
 		read_unlock(&tasklist_lock);
@@ -1906,7 +1906,7 @@ void exit_signals(struct task_struct *ts
 out:
 	spin_unlock_irq(&tsk->sighand->siglock);
 
-	if (unlikely(group_stop)) {
+	if (unlikely(group_stop) && tracehook_notify_jctl(1, CLD_STOPPED)) {
 		read_lock(&tasklist_lock);
 		do_notify_parent_cldstop(tsk, CLD_STOPPED);
 		read_unlock(&tasklist_lock);
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

