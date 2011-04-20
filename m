From: akpm@linux-foundation.org
Subject: + signal-retarget_shared_pending-consider-shared-unblocked-signals-only.patch added to -mm tree
Date: Wed, 20 Apr 2011 14:18:55 -0700
Message-ID: <201104202118.p3KLIu8h027661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755861Ab1DTVTY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Apr 2011 17:19:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, hpa@zytor.com, matt@console-pimps.org, mingo@elte.hu, nyoushchenko@mvista.com, tglx@linutronix.de, tj@kernel.org


The patch titled
     signal: retarget_shared_pending: consider shared/unblocked signals only
has been added to the -mm tree.  Its filename is
     signal-retarget_shared_pending-consider-shared-unblocked-signals-only.patch

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
Subject: signal: retarget_shared_pending: consider shared/unblocked signals only
From: Oleg Nesterov <oleg@redhat.com>

exit_signals() checks signal_pending() before retarget_shared_pending()
but this is suboptimal.  We can avoid the while_each_thread() loop in case
when there are no shared signals visible to us.

Add the "shared_pending.signal & ~blocked" check.  We don't use
tsk->blocked directly but pass ~blocked as an argument, this is needed for
the next patch.

Note: we can optimize this more.  while_each_thread(t) can check
t->blocked into account and stop after every pending signal has the new
target, see the next patch.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: "Nikita V. Youshchenko" <nyoushchenko@mvista.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN kernel/signal.c~signal-retarget_shared_pending-consider-shared-unblocked-signals-only kernel/signal.c
--- a/kernel/signal.c~signal-retarget_shared_pending-consider-shared-unblocked-signals-only
+++ a/kernel/signal.c
@@ -2203,10 +2203,15 @@ relock:
  * group-wide signal. Another thread should be notified now to take
  * the signal since we will not.
  */
-static void retarget_shared_pending(struct task_struct *tsk)
+static void retarget_shared_pending(struct task_struct *tsk, sigset_t *set)
 {
+	sigset_t shared_pending;
 	struct task_struct *t;
 
+	sigandsets(&shared_pending, &tsk->signal->shared_pending.signal, set);
+	if (sigisemptyset(&shared_pending))
+		return;
+
 	t = tsk;
 	while_each_thread(tsk, t) {
 		if (!signal_pending(t) && !(t->flags & PF_EXITING))
@@ -2217,6 +2222,7 @@ static void retarget_shared_pending(stru
 void exit_signals(struct task_struct *tsk)
 {
 	int group_stop = 0;
+	sigset_t set;
 
 	if (thread_group_empty(tsk) || signal_group_exit(tsk->signal)) {
 		tsk->flags |= PF_EXITING;
@@ -2232,7 +2238,9 @@ void exit_signals(struct task_struct *ts
 	if (!signal_pending(tsk))
 		goto out;
 
-	retarget_shared_pending(tsk);
+	set = tsk->blocked;
+	signotset(&set);
+	retarget_shared_pending(tsk, &set);
 
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
signal-introduce-retarget_shared_pending.patch
signal-retarget_shared_pending-consider-shared-unblocked-signals-only.patch
signal-retarget_shared_pending-optimize-while_each_thread-loop.patch
signal-sigprocmask-narrow-the-scope-of-siglock.patch
signal-sigprocmask-should-do-retarget_shared_pending.patch
x86-signal-handle_signal-should-use-set_current_blocked.patch
x86-signal-sys_rt_sigreturn-should-use-set_current_blocked.patch
signal-cleanup-sys_rt_sigprocmask.patch
fs-execc-provide-the-correct-process-pid-to-the-pipe-helper.patch

