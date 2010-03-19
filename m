From: akpm@linux-foundation.org
Subject: + wait_for_helper-sigchld-from-user-space-can-lead-to-use-after-free.patch added to -mm tree
Date: Fri, 19 Mar 2010 15:06:52 -0700
Message-ID: <201003192206.o2JM6rKp015042@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751393Ab0CSWHM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 18:07:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, nhorman@tuxdriver.com


The patch titled
     wait_for_helper: SIGCHLD from user-space can lead to use-after-free
has been added to the -mm tree.  Its filename is
     wait_for_helper-sigchld-from-user-space-can-lead-to-use-after-free.patch

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
Subject: wait_for_helper: SIGCHLD from user-space can lead to use-after-free
From: Oleg Nesterov <oleg@redhat.com>

1. wait_for_helper() calls allow_signal(SIGCHLD) to ensure the child
   can't autoreap itself.

   However, this means that a spurious SIGCHILD from user-space can
   set TIF_SIGPENDING and:

   	- kernel_thread() or sys_wait4() can fail due to signal_pending()

   	- worse, wait4() can fail before ____call_usermodehelper() execs
   	  or exits. In this case the caller may kfree(subprocess_info)
   	  while the child still uses this memory.

   Change the code to use SIG_DFL instead of magic "(void __user *)2"
   set by allow_signal(). This means that SIGCHLD won't be delivered,
   yet the child won't autoreap itsefl.

   The problem is minor, only root can send a signal to this kthread.

2. If sys_wait4(&ret) fails it doesn't populate "ret", in this case
   wait_for_helper() reports a random value from uninitialized var.

   With this patch sys_wait4() should never fail, but still it makes
   sense to initialize ret = -ECHILD so that the caller can notice
   the problem.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN kernel/kmod.c~wait_for_helper-sigchld-from-user-space-can-lead-to-use-after-free kernel/kmod.c
--- a/kernel/kmod.c~wait_for_helper-sigchld-from-user-space-can-lead-to-use-after-free
+++ a/kernel/kmod.c
@@ -175,16 +175,16 @@ static int wait_for_helper(void *data)
 	struct subprocess_info *sub_info = data;
 	pid_t pid;
 
-	/* Install a handler: if SIGCLD isn't handled sys_wait4 won't
-	 * populate the status, but will return -ECHILD. */
-	allow_signal(SIGCHLD);
+	/* If SIGCLD is ignored sys_wait4 won't populate the status. */
+	spin_lock_irq(&current->sighand->siglock);
+	current->sighand->action[SIGCHLD-1].sa.sa_handler = SIG_DFL;
+	spin_unlock_irq(&current->sighand->siglock);
 
 	pid = kernel_thread(____call_usermodehelper, sub_info, SIGCHLD);
 	if (pid < 0) {
 		sub_info->retval = pid;
 	} else {
-		int ret;
-
+		int ret = -ECHILD;
 		/*
 		 * Normally it is bogus to call wait4() from in-kernel because
 		 * wait4() wants to write the exit code to a userspace address.
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch
cpu-timers-simplify-rlimit_cpu-handling.patch
cpu-timers-cleanup-arm_timer.patch
cpu-timers-return-correct-previous-timer-reload-value.patch
cpu-timers-change-sigev_none-timer-implementation.patch
cpu-timers-assure-to-not-iterate-over-all-threads-in-fastpath_timer_check.patch
cpu-timers-optimize-run_posix_cpu_timers.patch
proc-cleanup-remove-unused-assignments.patch
kmod-add-init-function-to-usermodehelper.patch
exec-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit.patch
umh-creds-convert-call_usermodehelper_keys-to-use-subprocess_info-init.patch
umh-creds-kill-subprocess_info-cred-logic.patch
call_usermodehelper-no-need-to-unblock-signals.patch
wait_for_helper-sigchld-from-user-space-can-lead-to-use-after-free.patch
call_usermodehelper-simplify-fix-umh_no_wait-case.patch
call_usermodehelper-umh_wait_exec-ignores-kernel_thread-failure.patch

