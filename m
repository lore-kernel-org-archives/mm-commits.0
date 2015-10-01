From: akpm@linux-foundation.org
Subject: +
 coredump-ensure-all-coredumping-tasks-have-signal_group_coredump.patch
 added to -mm tree
Date: Thu, 01 Oct 2015 14:53:42 -0700
Message-ID: <560dab66.tLZ/VMZ0nznhuv2T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40893 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbbJAVxn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Oct 2015 17:53:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, kwalker@redhat.com, mhocko@kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, skozina@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: ensure all coredumping tasks have SIGNAL_GROUP_COREDUMP
has been added to the -mm tree.  Its filename is
     coredump-ensure-all-coredumping-tasks-have-signal_group_coredump.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/coredump-ensure-all-coredumping-tasks-have-signal_group_coredump.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/coredump-ensure-all-coredumping-tasks-have-signal_group_coredump.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: coredump: ensure all coredumping tasks have SIGNAL_GROUP_COREDUMP

task_will_free_mem() is wrong in many ways, and in particular the
SIGNAL_GROUP_COREDUMP check is not reliable: a task can participate in the
coredumping without SIGNAL_GROUP_COREDUMP bit set.

change zap_threads() paths to always set SIGNAL_GROUP_COREDUMP even if
other CLONE_VM processes can't react to SIGKILL.  Fortunately, at least
oom-kill case if fine; it kills all tasks sharing the same mm, so it
should also kill the process which actually dumps the core.

The change in prepare_signal() is not strictly necessary, it just ensures
that the patch does not bring another subtle behavioural change.  But it
reminds us that this SIGNAL_GROUP_EXIT/COREDUMP case needs more changes.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Kyle Walker <kwalker@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Stanislav Kozina <skozina@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c   |   12 ++++++------
 kernel/signal.c |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/coredump.c~coredump-ensure-all-coredumping-tasks-have-signal_group_coredump fs/coredump.c
--- a/fs/coredump.c~coredump-ensure-all-coredumping-tasks-have-signal_group_coredump
+++ a/fs/coredump.c
@@ -280,11 +280,13 @@ out:
 	return ispipe;
 }
 
-static int zap_process(struct task_struct *start, int exit_code)
+static int zap_process(struct task_struct *start, int exit_code, int flags)
 {
 	struct task_struct *t;
 	int nr = 0;
 
+	/* ignore all signals except SIGKILL, see prepare_signal() */
+	start->signal->flags = SIGNAL_GROUP_COREDUMP | flags;
 	start->signal->group_exit_code = exit_code;
 	start->signal->group_stop_count = 0;
 
@@ -311,10 +313,8 @@ static int zap_threads(struct task_struc
 	spin_lock_irq(&tsk->sighand->siglock);
 	if (!signal_group_exit(tsk->signal)) {
 		mm->core_state = core_state;
-		nr = zap_process(tsk, exit_code);
 		tsk->signal->group_exit_task = tsk;
-		/* ignore all signals except SIGKILL, see prepare_signal() */
-		tsk->signal->flags = SIGNAL_GROUP_COREDUMP;
+		nr = zap_process(tsk, exit_code, 0);
 		clear_tsk_thread_flag(tsk, TIF_SIGPENDING);
 	}
 	spin_unlock_irq(&tsk->sighand->siglock);
@@ -365,8 +365,8 @@ static int zap_threads(struct task_struc
 			if (p->mm) {
 				if (unlikely(p->mm == mm)) {
 					lock_task_sighand(p, &flags);
-					nr += zap_process(p, exit_code);
-					p->signal->flags = SIGNAL_GROUP_EXIT;
+					nr += zap_process(p, exit_code,
+							  SIGNAL_GROUP_EXIT);
 					unlock_task_sighand(p, &flags);
 				}
 				break;
diff -puN kernel/signal.c~coredump-ensure-all-coredumping-tasks-have-signal_group_coredump kernel/signal.c
--- a/kernel/signal.c~coredump-ensure-all-coredumping-tasks-have-signal_group_coredump
+++ a/kernel/signal.c
@@ -788,7 +788,7 @@ static bool prepare_signal(int sig, stru
 	sigset_t flush;
 
 	if (signal->flags & (SIGNAL_GROUP_EXIT | SIGNAL_GROUP_COREDUMP)) {
-		if (signal->flags & SIGNAL_GROUP_COREDUMP)
+		if (!(signal->flags & SIGNAL_GROUP_EXIT))
 			return sig == SIGKILL;
 		/*
 		 * The process is in the middle of dying, nothing to do.
_

Patches currently in -mm which might be from oleg@redhat.com are

mm-fix-the-racy-mm-locked_vm-change-in.patch
mm-add-the-struct-mm_struct-mm-local-into.patch
signals-kill-block_all_signals-and-unblock_all_signals.patch
coredump-ensure-all-coredumping-tasks-have-signal_group_coredump.patch
coredump-change-zap_threads-and-zap_process-to-use.patch

