From: akpm@linux-foundation.org
Subject: [merged] coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch removed from -mm tree
Date: Tue, 07 May 2013 10:49:27 -0700
Message-ID: <20130507174927.9D8D731C26F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:41636 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759445Ab3EGRt3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:49:29 -0400
Received: by mail-gg0-f201.google.com with SMTP id k25so85346ggl.0
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:49:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, mingo@redhat.com, msb@chromium.org, nhorman@redhat.com, rjw@sisk.pl, roland@hack.frob.com, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: ensure that SIGKILL always kills the dumping thread
has been removed from the -mm tree.  Its filename was
     coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
posix_cpu_timer-consolidate-expiry-time-type.patch
posix_cpu_timers-consolidate-timer-list-cleanups.patch
posix_cpu_timers-consolidate-expired-timers-check.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
posix_timers-fix-racy-timer-delta-caching-on-task-exit.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch

