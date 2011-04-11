From: akpm@linux-foundation.org
Subject: + signal-retarget_shared_pending-consider-shared-unblocked-signals-only.patch added to -mm tree
Date: Mon, 11 Apr 2011 13:38:11 -0700
Message-ID: <201104112038.p3BKcBII032211@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59201 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753836Ab1DKUjN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Apr 2011 16:39:13 -0400
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

Add the has_pending_signals(shared_pending, blocked) check.  We don not
use tsk->blocked directly but pass this sigset_t as an argument, this is
needed for the next patch.

Note: we can optimize this more.  while_each_thread(t) can check
t->blocked into account and stop after every pending signal has the new
target.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: "Nikita V. Youshchenko" <nyoushchenko@mvista.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN kernel/signal.c~signal-retarget_shared_pending-consider-shared-unblocked-signals-only kernel/signal.c
--- a/kernel/signal.c~signal-retarget_shared_pending-consider-shared-unblocked-signals-only
+++ a/kernel/signal.c
@@ -2203,10 +2203,13 @@ relock:
  * group-wide signal. Another thread should be notified now to take
  * the signal since we will not.
  */
-static void retarget_shared_pending(struct task_struct *tsk)
+static void retarget_shared_pending(struct task_struct *tsk, sigset_t *blocked)
 {
 	struct task_struct *t;
 
+	if (!has_pending_signals(&tsk->signal->shared_pending.signal, blocked))
+		return;
+
 	t = tsk;
 	while_each_thread(tsk, t) {
 		if (!signal_pending(t) && !(t->flags & PF_EXITING))
@@ -2232,7 +2235,7 @@ void exit_signals(struct task_struct *ts
 	if (!signal_pending(tsk))
 		goto out;
 
-	retarget_shared_pending(tsk);
+	retarget_shared_pending(tsk, &tsk->blocked);
 
 	if (unlikely(tsk->group_stop & GROUP_STOP_PENDING) &&
 	    task_participate_group_stop(tsk))
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
signal-introduce-retarget_shared_pending.patch
signal-retarget_shared_pending-consider-shared-unblocked-signals-only.patch
signal-sigprocmask-narrow-the-scope-of-sigloc.patch
signal-sigprocmask-should-do-retarget_shared_pending.patch
x86-signal-handle_signal-should-use-sigprocmask.patch
x86-signal-sys_rt_sigreturn-should-use-sigprocmask.patch
fs-execc-provide-the-correct-process-pid-to-the-pipe-helper.patch

