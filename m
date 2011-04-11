From: akpm@linux-foundation.org
Subject: + signal-sigprocmask-narrow-the-scope-of-sigloc.patch added to -mm tree
Date: Mon, 11 Apr 2011 13:38:13 -0700
Message-ID: <201104112038.p3BKcDTZ032214@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753836Ab1DKUjM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Apr 2011 16:39:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, hpa@zytor.com, matt@console-pimps.org, mingo@elte.hu, nyoushchenko@mvista.com, tglx@linutronix.de, tj@kernel.org


The patch titled
     signal: sigprocmask: narrow the scope of ->sigloc
has been added to the -mm tree.  Its filename is
     signal-sigprocmask-narrow-the-scope-of-sigloc.patch

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
Subject: signal: sigprocmask: narrow the scope of ->sigloc
From: Oleg Nesterov <oleg@redhat.com>

No functional changes, preparation to simplify the review of the next change.

1. We can read current->block lockless, nobody else can ever change this mask.

2. Calculate the resulting sigset_t outside of ->siglock into the temporary
   variable, then take ->siglock and change ->blocked.

Also, kill the stale comment about BKL.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: "Nikita V. Youshchenko" <nyoushchenko@mvista.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff -puN kernel/signal.c~signal-sigprocmask-narrow-the-scope-of-sigloc kernel/signal.c
--- a/kernel/signal.c~signal-sigprocmask-narrow-the-scope-of-sigloc
+++ a/kernel/signal.c
@@ -2284,12 +2284,6 @@ long do_no_restart_syscall(struct restar
 }
 
 /*
- * We don't need to get the kernel lock - this is all local to this
- * particular thread.. (and that's good, because this is _heavily_
- * used by various programs)
- */
-
-/*
  * This is also useful for kernel threads that want to temporarily
  * (or permanently) block certain signals.
  *
@@ -2299,30 +2293,32 @@ long do_no_restart_syscall(struct restar
  */
 int sigprocmask(int how, sigset_t *set, sigset_t *oldset)
 {
-	int error;
+	struct task_struct *tsk = current;
+	sigset_t newset;
 
-	spin_lock_irq(&current->sighand->siglock);
 	if (oldset)
-		*oldset = current->blocked;
+		*oldset = tsk->blocked;
 
-	error = 0;
 	switch (how) {
 	case SIG_BLOCK:
-		sigorsets(&current->blocked, &current->blocked, set);
+		sigorsets(&newset, &tsk->blocked, set);
 		break;
 	case SIG_UNBLOCK:
-		signandsets(&current->blocked, &current->blocked, set);
+		signandsets(&newset, &tsk->blocked, set);
 		break;
 	case SIG_SETMASK:
-		current->blocked = *set;
+		newset = *set;
 		break;
 	default:
-		error = -EINVAL;
+		return -EINVAL;
 	}
+
+	spin_lock_irq(&tsk->sighand->siglock);
+	tsk->blocked = newset;
 	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	spin_unlock_irq(&tsk->sighand->siglock);
 
-	return error;
+	return 0;
 }
 
 /**
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

