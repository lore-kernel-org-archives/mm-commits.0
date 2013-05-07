From: akpm@linux-foundation.org
Subject: [merged] coredump-sanitize-the-setting-of-signal-group_exit_code.patch removed from -mm tree
Date: Tue, 07 May 2013 10:49:30 -0700
Message-ID: <20130507174930.910DB31C2D0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:50565 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759445Ab3EGRtb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:49:31 -0400
Received: by mail-ye0-f202.google.com with SMTP id r13so85305yen.3
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:49:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, mingo@redhat.com, msb@chromium.org, nhorman@redhat.com, rjw@sisk.pl, roland@hack.frob.com, tj@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: sanitize the setting of signal->group_exit_code
has been removed from the -mm tree.  Its filename was
     coredump-sanitize-the-setting-of-signal-group_exit_code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: coredump: sanitize the setting of signal->group_exit_code

Now that the coredumping process can be SIGKILL'ed, the setting of
->group_exit_code in do_coredump() can race with complete_signal() and
SIGKILL or 0x80 can be "lost", or wait(status) can report status ==
SIGKILL | 0x80.

But the main problem is that it is not clear to me what should we do if
binfmt->core_dump() succeeds but SIGKILL was sent, that is why this patch
comes as a separate change.

This patch adds 0x80 if ->core_dump() succeeds and the process was not
killed.  But perhaps we can (should?) re-set ->group_exit_code changed by
SIGKILL back to "siginfo->si_signo |= 0x80" in case when core_dumped == T.

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

 fs/coredump.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN fs/coredump.c~coredump-sanitize-the-setting-of-signal-group_exit_code fs/coredump.c
--- a/fs/coredump.c~coredump-sanitize-the-setting-of-signal-group_exit_code
+++ a/fs/coredump.c
@@ -390,12 +390,14 @@ static int coredump_wait(int exit_code,
 	return core_waiters;
 }
 
-static void coredump_finish(struct mm_struct *mm)
+static void coredump_finish(struct mm_struct *mm, bool core_dumped)
 {
 	struct core_thread *curr, *next;
 	struct task_struct *task;
 
 	spin_lock_irq(&current->sighand->siglock);
+	if (core_dumped && !__fatal_signal_pending(current))
+		current->signal->group_exit_code |= 0x80;
 	current->signal->group_exit_task = NULL;
 	current->signal->flags = SIGNAL_GROUP_EXIT;
 	spin_unlock_irq(&current->sighand->siglock);
@@ -480,6 +482,7 @@ void do_coredump(siginfo_t *siginfo)
 	int ispipe;
 	struct files_struct *displaced;
 	bool need_nonrelative = false;
+	bool core_dumped = false;
 	static atomic_t core_dump_count = ATOMIC_INIT(0);
 	struct coredump_params cprm = {
 		.siginfo = siginfo,
@@ -638,9 +641,7 @@ void do_coredump(siginfo_t *siginfo)
 		goto close_fail;
 	if (displaced)
 		put_files_struct(displaced);
-	retval = binfmt->core_dump(&cprm);
-	if (retval)
-		current->signal->group_exit_code |= 0x80;
+	core_dumped = binfmt->core_dump(&cprm);
 
 	if (ispipe && core_pipe_limit)
 		wait_for_dump_helpers(cprm.file);
@@ -653,7 +654,7 @@ fail_dropcount:
 fail_unlock:
 	kfree(cn.corename);
 fail_corename:
-	coredump_finish(mm);
+	coredump_finish(mm, core_dumped);
 	revert_creds(old_cred);
 fail_creds:
 	put_cred(cred);
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

