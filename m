Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011587493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wp3NhDz1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C15C433C9;
	Mon, 11 Dec 2023 01:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257783;
	bh=7el56iew5J39n7ecpdzfebuLHrkCF5HC12xFXz8xs1Y=;
	h=Date:To:From:Subject:From;
	b=wp3NhDz1mhtojnOuP2h1msQJ/uJkpwm/Ki9mnDW/+wA6yE9hA6qnkfAHdoagwC1li
	 tJ7yI/dm3gl8ZRYRCj05LfpfqlZfoext9JwORneVSwANgiTj+1Kh+iWogZktRs41OJ
	 DWzs71hI5+GGEUDluh8+YtjBgbQDI+epansXvN0A=
Date: Sun, 10 Dec 2023 17:23:03 -0800
To: mm-commits@vger.kernel.org,ebiederm@xmission.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] simplify-force_sig_info_to_task-kill-recalc_sigpending_and_wake.patch removed from -mm tree
Message-Id: <20231211012303.C0C15C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/signal.c: simplify force_sig_info_to_task(), kill recalc_sigpending_and_wake()
has been removed from the -mm tree.  Its filename was
     simplify-force_sig_info_to_task-kill-recalc_sigpending_and_wake.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: kernel/signal.c: simplify force_sig_info_to_task(), kill recalc_sigpending_and_wake()
Date: Mon, 20 Nov 2023 16:16:49 +0100

The purpose of recalc_sigpending_and_wake() is not clear, it looks
"obviously unneeded" because we are going to send the signal which can't
be blocked or ignored.

Add the comment to explain why we can't rely on send_signal_locked() and
make this logic more simple/explicit.  recalc_sigpending_and_wake() has no
other users, it can die.

In fact I think we don't even need signal_wake_up(), the target task must
be either current or a TASK_TRACED child, otherwise the usage of siglock
is not safe.  But this needs another change.

Link: https://lkml.kernel.org/r/20231120151649.GA15995@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/signal.h |    1 -
 kernel/signal.c              |   17 ++++-------------
 2 files changed, 4 insertions(+), 14 deletions(-)

--- a/include/linux/sched/signal.h~simplify-force_sig_info_to_task-kill-recalc_sigpending_and_wake
+++ a/include/linux/sched/signal.h
@@ -432,7 +432,6 @@ static inline bool fault_signal_pending(
  * This is required every time the blocked sigset_t changes.
  * callers must hold sighand->siglock.
  */
-extern void recalc_sigpending_and_wake(struct task_struct *t);
 extern void recalc_sigpending(void);
 extern void calculate_sigpending(void);
 
--- a/kernel/signal.c~simplify-force_sig_info_to_task-kill-recalc_sigpending_and_wake
+++ a/kernel/signal.c
@@ -171,16 +171,6 @@ static bool recalc_sigpending_tsk(struct
 	return false;
 }
 
-/*
- * After recalculating TIF_SIGPENDING, we need to make sure the task wakes up.
- * This is superfluous when called on current, the wakeup is a harmless no-op.
- */
-void recalc_sigpending_and_wake(struct task_struct *t)
-{
-	if (recalc_sigpending_tsk(t))
-		signal_wake_up(t, 0);
-}
-
 void recalc_sigpending(void)
 {
 	if (!recalc_sigpending_tsk(current) && !freezing(current))
@@ -1348,10 +1338,8 @@ force_sig_info_to_task(struct kernel_sig
 		action->sa.sa_handler = SIG_DFL;
 		if (handler == HANDLER_EXIT)
 			action->sa.sa_flags |= SA_IMMUTABLE;
-		if (blocked) {
+		if (blocked)
 			sigdelset(&t->blocked, sig);
-			recalc_sigpending_and_wake(t);
-		}
 	}
 	/*
 	 * Don't clear SIGNAL_UNKILLABLE for traced tasks, users won't expect
@@ -1361,6 +1349,9 @@ force_sig_info_to_task(struct kernel_sig
 	    (!t->ptrace || (handler == HANDLER_EXIT)))
 		t->signal->flags &= ~SIGNAL_UNKILLABLE;
 	ret = send_signal_locked(sig, info, t, PIDTYPE_PID);
+	/* This can happen if the signal was already pending and blocked */
+	if (!task_sigpending(t))
+		signal_wake_up(t, 0);
 	spin_unlock_irqrestore(&t->sighand->siglock, flags);
 
 	return ret;
_

Patches currently in -mm which might be from oleg@redhat.com are


