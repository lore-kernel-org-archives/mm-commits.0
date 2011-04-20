From: akpm@linux-foundation.org
Subject: [to-be-updated] signal-introduce-retarget_shared_pending.patch removed from -mm tree
Date: Wed, 20 Apr 2011 14:13:46 -0700
Message-ID: <201104202113.p3KLDl4x027424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752135Ab1DTVOM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Apr 2011 17:14:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, hpa@zytor.com, matt@console-pimps.org, mingo@elte.hu, nyoushchenko@mvista.com, tglx@linutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     signal: introduce retarget_shared_pending()
has been removed from the -mm tree.  Its filename was
     signal-introduce-retarget_shared_pending.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signal: introduce retarget_shared_pending()
From: Oleg Nesterov <oleg@redhat.com>

No functional changes.  Move the notyfy-other-threads code from
exit_signals() to the new helper, retarget_shared_pending().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: "Nikita V. Youshchenko" <nyoushchenko@mvista.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff -puN kernel/signal.c~signal-introduce-retarget_shared_pending kernel/signal.c
--- a/kernel/signal.c~signal-introduce-retarget_shared_pending
+++ a/kernel/signal.c
@@ -2198,10 +2198,25 @@ relock:
 	return signr;
 }
 
+/*
+ * It could be that complete_signal() picked us to notify about the
+ * group-wide signal. Another thread should be notified now to take
+ * the signal since we will not.
+ */
+static void retarget_shared_pending(struct task_struct *tsk)
+{
+	struct task_struct *t;
+
+	t = tsk;
+	while_each_thread(tsk, t) {
+		if (!signal_pending(t) && !(t->flags & PF_EXITING))
+			recalc_sigpending_and_wake(t);
+	}
+}
+
 void exit_signals(struct task_struct *tsk)
 {
 	int group_stop = 0;
-	struct task_struct *t;
 
 	if (thread_group_empty(tsk) || signal_group_exit(tsk->signal)) {
 		tsk->flags |= PF_EXITING;
@@ -2217,14 +2232,7 @@ void exit_signals(struct task_struct *ts
 	if (!signal_pending(tsk))
 		goto out;
 
-	/*
-	 * It could be that __group_complete_signal() choose us to
-	 * notify about group-wide signal. Another thread should be
-	 * woken now to take the signal since we will not.
-	 */
-	for (t = tsk; (t = next_thread(t)) != tsk; )
-		if (!signal_pending(t) && !(t->flags & PF_EXITING))
-			recalc_sigpending_and_wake(t);
+	retarget_shared_pending(tsk);
 
 	if (unlikely(tsk->group_stop & GROUP_STOP_PENDING) &&
 	    task_participate_group_stop(tsk))
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
cgroups-read-write-lock-clone_thread-forking-per-threadgroup.patch
cgroups-add-per-thread-subsystem-callbacks.patch
cgroups-make-procs-file-writable.patch
cgroups-use-flex_array-in-attach_proc.patch
asm-generic-ptraceh-start-a-common-low-level-ptrace-helper.patch
blackfin-convert-to-asm-generic-ptraceh.patch
x86-convert-to-asm-generic-ptraceh.patch
sh-convert-to-asm-generic-ptraceh.patch
kgdbts-unify-generalize-gdb-breakpoint-adjustment.patch
signal-retarget_shared_pending-consider-shared-unblocked-signals-only.patch
signal-sigprocmask-narrow-the-scope-of-sigloc.patch
signal-sigprocmask-should-do-retarget_shared_pending.patch
x86-signal-handle_signal-should-use-sigprocmask.patch
x86-signal-sys_rt_sigreturn-should-use-sigprocmask.patch
fs-execc-provide-the-correct-process-pid-to-the-pipe-helper.patch

