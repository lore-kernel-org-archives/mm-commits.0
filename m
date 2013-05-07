From: akpm@linux-foundation.org
Subject: [merged] coredump-only-sigkill-should-interrupt-the-coredumping-task.patch removed from -mm tree
Date: Tue, 07 May 2013 10:49:24 -0700
Message-ID: <20130507174924.A13C631C2FD@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:63619 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759445Ab3EGRt0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:49:26 -0400
Received: by mail-yh0-f73.google.com with SMTP id a41so85331yho.0
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:49:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, mingo@redhat.com, msb@chromium.org, nhorman@redhat.com, rjw@sisk.pl, roland@hack.frob.com, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: only SIGKILL should interrupt the coredumping task
has been removed from the -mm tree.  Its filename was
     coredump-only-sigkill-should-interrupt-the-coredumping-task.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: coredump: only SIGKILL should interrupt the coredumping task

There are 2 well known and ancient problems with coredump/signals, and a
lot of related bug reports:

- do_coredump() clears TIF_SIGPENDING but of course this can't help
  if, say, SIGCHLD comes after that.

  In this case the coredump can fail unexpectedly. See for example
  wait_for_dump_helper()->signal_pending() check but there are other
  reasons.

- At the same time, dumping a huge core on the slow media can take a
  lot of time/resources and there is no way to kill the coredumping
  task reliably. In particular this is not oom_kill-friendly.

This patch tries to fix the 1st problem, and makes the preparation for the
next changes.

We add the new SIGNAL_GROUP_COREDUMP flag set by zap_threads() to indicate
that this process dumps the core.  prepare_signal() checks this flag and
nacks any signal except SIGKILL.

Note that this check tries to be conservative, in the long term we should
probably treat the SIGNAL_GROUP_EXIT case equally but this needs more
discussion.  See marc.info/?l=linux-kernel&m=120508897917439

Notes:
	- recalc_sigpending() doesn't check SIGNAL_GROUP_COREDUMP.
	  The patch assumes that dump_write/etc paths should never
	  call it, but we can change it as well.

	- There is another source of TIF_SIGPENDING, freezer. This
	  will be addressed separately.

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

 fs/coredump.c         |   13 +++++--------
 include/linux/sched.h |    1 +
 kernel/signal.c       |    6 ++++--
 3 files changed, 10 insertions(+), 10 deletions(-)

diff -puN fs/coredump.c~coredump-only-sigkill-should-interrupt-the-coredumping-task fs/coredump.c
--- a/fs/coredump.c~coredump-only-sigkill-should-interrupt-the-coredumping-task
+++ a/fs/coredump.c
@@ -280,8 +280,8 @@ static int zap_process(struct task_struc
 	return nr;
 }
 
-static inline int zap_threads(struct task_struct *tsk, struct mm_struct *mm,
-				struct core_state *core_state, int exit_code)
+static int zap_threads(struct task_struct *tsk, struct mm_struct *mm,
+			struct core_state *core_state, int exit_code)
 {
 	struct task_struct *g, *p;
 	unsigned long flags;
@@ -291,6 +291,9 @@ static inline int zap_threads(struct tas
 	if (!signal_group_exit(tsk->signal)) {
 		mm->core_state = core_state;
 		nr = zap_process(tsk, exit_code);
+		/* ignore all signals except SIGKILL, see prepare_signal() */
+		tsk->signal->flags |= SIGNAL_GROUP_COREDUMP;
+		clear_tsk_thread_flag(tsk, TIF_SIGPENDING);
 	}
 	spin_unlock_irq(&tsk->sighand->siglock);
 	if (unlikely(nr < 0))
@@ -514,12 +517,6 @@ void do_coredump(siginfo_t *siginfo)
 
 	old_cred = override_creds(cred);
 
-	/*
-	 * Clear any false indication of pending signals that might
-	 * be seen by the filesystem code called to write the core file.
-	 */
-	clear_thread_flag(TIF_SIGPENDING);
-
 	ispipe = format_corename(&cn, &cprm);
 
 	if (ispipe) {
diff -puN include/linux/sched.h~coredump-only-sigkill-should-interrupt-the-coredumping-task include/linux/sched.h
--- a/include/linux/sched.h~coredump-only-sigkill-should-interrupt-the-coredumping-task
+++ a/include/linux/sched.h
@@ -626,6 +626,7 @@ struct signal_struct {
 #define SIGNAL_STOP_STOPPED	0x00000001 /* job control stop in effect */
 #define SIGNAL_STOP_CONTINUED	0x00000002 /* SIGCONT since WCONTINUED reap */
 #define SIGNAL_GROUP_EXIT	0x00000004 /* group exit in progress */
+#define SIGNAL_GROUP_COREDUMP	0x00000008 /* coredump in progress */
 /*
  * Pending notifications to parent.
  */
diff -puN kernel/signal.c~coredump-only-sigkill-should-interrupt-the-coredumping-task kernel/signal.c
--- a/kernel/signal.c~coredump-only-sigkill-should-interrupt-the-coredumping-task
+++ a/kernel/signal.c
@@ -854,12 +854,14 @@ static void ptrace_trap_notify(struct ta
  * Returns true if the signal should be actually delivered, otherwise
  * it should be dropped.
  */
-static int prepare_signal(int sig, struct task_struct *p, bool force)
+static bool prepare_signal(int sig, struct task_struct *p, bool force)
 {
 	struct signal_struct *signal = p->signal;
 	struct task_struct *t;
 
-	if (unlikely(signal->flags & SIGNAL_GROUP_EXIT)) {
+	if (signal->flags & (SIGNAL_GROUP_EXIT | SIGNAL_GROUP_COREDUMP)) {
+		if (signal->flags & SIGNAL_GROUP_COREDUMP)
+			return sig == SIGKILL;
 		/*
 		 * The process is in the middle of dying, nothing to do.
 		 */
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

