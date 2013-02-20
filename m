From: akpm@linux-foundation.org
Subject: + coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch added to -mm tree
Date: Wed, 20 Feb 2013 15:13:22 -0800
Message-ID: <20130220231322.8F8F45A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:39195 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab3BTXNY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Feb 2013 18:13:24 -0500
Received: by mail-qe0-f73.google.com with SMTP id 7so842753qeb.0
        for <mm-commits@vger.kernel.org>; Wed, 20 Feb 2013 15:13:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, mingo@redhat.com, msb@chromium.org, nhorman@redhat.com, rjw@sisk.pl, roland@hack.frob.com, tj@kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: coredump: ensure that SIGKILL always kills the dumping thread
has been added to the -mm tree.  Its filename is
     coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch

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
Subject: coredump: ensure that SIGKILL always kills the dumping thread

prepare_signal() blesses SIGKILL sent to the dumping process but this
signal can be "lost" anyway.  The problems is, complete_signal() sees
SIGNAL_GROUP_EXIT and skips the "kill them all" logic.  And even if the
dumping process is single-threaded (so the target is always "correct"),
the group-wide SIGKILL is not recorded in task->pending and thus
__fatal_signal_pending() won't be true.  A multi-threaded case has even
more problems.

And even ignoring all technical details, SIGNAL_GROUP_EXIT doesn't look
right to me.  This coredumping process is not exiting yet, it can do a lot
of work dumping the core.

With this patch the dumping process doesn't have SIGNAL_GROUP_EXIT, we set
signal->group_exit_task instead.  This makes signal_group_exit() true and
thus this should equally close the races with exit/exec/stop but allows to
kill the dumping thread reliably.

Notes:
	- It is not clear what should we do with ->group_exit_code
	  if the dumper was killed, see the next change.

	- we need more (hopefully straightforward) changes to ensure
	  that SIGKILL actually interrupts the coredump. Basically we
	  need to check __fatal_signal_pending() in dump_write() and
	  dump_seek().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Tested-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Neil Horman <nhorman@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Roland McGrath <roland@hack.frob.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN fs/coredump.c~coredump-ensure-that-sigkill-always-kills-the-dumping-thread fs/coredump.c
--- a/fs/coredump.c~coredump-ensure-that-sigkill-always-kills-the-dumping-thread
+++ a/fs/coredump.c
@@ -263,7 +263,6 @@ static int zap_process(struct task_struc
 	struct task_struct *t;
 	int nr = 0;
 
-	start->signal->flags = SIGNAL_GROUP_EXIT;
 	start->signal->group_exit_code = exit_code;
 	start->signal->group_stop_count = 0;
 
@@ -291,8 +290,9 @@ static int zap_threads(struct task_struc
 	if (!signal_group_exit(tsk->signal)) {
 		mm->core_state = core_state;
 		nr = zap_process(tsk, exit_code);
+		tsk->signal->group_exit_task = tsk;
 		/* ignore all signals except SIGKILL, see prepare_signal() */
-		tsk->signal->flags |= SIGNAL_GROUP_COREDUMP;
+		tsk->signal->flags = SIGNAL_GROUP_COREDUMP;
 		clear_tsk_thread_flag(tsk, TIF_SIGPENDING);
 	}
 	spin_unlock_irq(&tsk->sighand->siglock);
@@ -343,6 +343,7 @@ static int zap_threads(struct task_struc
 				if (unlikely(p->mm == mm)) {
 					lock_task_sighand(p, &flags);
 					nr += zap_process(p, exit_code);
+					p->signal->flags = SIGNAL_GROUP_EXIT;
 					unlock_task_sighand(p, &flags);
 				}
 				break;
@@ -394,6 +395,11 @@ static void coredump_finish(struct mm_st
 	struct core_thread *curr, *next;
 	struct task_struct *task;
 
+	spin_lock_irq(&current->sighand->siglock);
+	current->signal->group_exit_task = NULL;
+	current->signal->flags = SIGNAL_GROUP_EXIT;
+	spin_unlock_irq(&current->sighand->siglock);
+
 	next = mm->core_state->dumper.next;
 	while ((curr = next) != NULL) {
 		next = curr->next;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
signal-allow-to-send-any-siginfo-to-itself.patch
kernel-signalc-fix-suboptimal-printk-usage.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
vfork-dont-freezer_count-for-in-kernel-users-of-clone_vfork.patch
lockdep-check-that-no-locks-held-at-freeze-time.patch
lockdep-check-that-no-locks-held-at-freeze-time-fix.patch
coredump-cleanup-the-waiting-for-coredump_finish-code.patch
coredump-use-a-freezable_schedule-for-the-coredump_finish-wait.patch
coredump-abort-core-dump-piping-only-due-to-a-fatal-signal.patch

