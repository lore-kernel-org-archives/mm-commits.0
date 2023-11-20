Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B90AC2BB3F
	for <mm-commits@archiver.kernel.org>; Mon, 20 Nov 2023 18:13:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjKTSNn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Nov 2023 13:13:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjKTSNm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2023 13:13:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA0D92
        for <mm-commits@vger.kernel.org>; Mon, 20 Nov 2023 10:13:38 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56317C433C7;
        Mon, 20 Nov 2023 18:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700504018;
        bh=UMvreMoYESUM/UjU/k3sWPYWk7J8Htmk78z3S+rtH0Y=;
        h=Date:To:From:Subject:From;
        b=e11r23HE31t73pUzOiTOB+hil97GtEH38lyZUOuKq4TccnDB4ktVxCbqPokj3Oipj
         O4WJDqGWpGj5cPRM3qg+Ndjzwx/UVsKWLqo36EiHEGXiMH12DXzqEfFuoHulk+gUx1
         H9+MQ/oe7hJXqDog6rhk28YPeFAcwC85cIxt6Rps=
Date:   Mon, 20 Nov 2023 10:13:37 -0800
To:     mm-commits@vger.kernel.org, ebiederm@xmission.com, oleg@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + simplify-force_sig_info_to_task-kill-recalc_sigpending_and_wake.patch added to mm-nonmm-unstable branch
Message-Id: <20231120181338.56317C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/signal.c: simplify force_sig_info_to_task(), kill recalc_sigpending_and_wake()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     simplify-force_sig_info_to_task-kill-recalc_sigpending_and_wake.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/simplify-force_sig_info_to_task-kill-recalc_sigpending_and_wake.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

introduce-for_other_threadsp-t.patch
simplify-force_sig_info_to_task-kill-recalc_sigpending_and_wake.patch

