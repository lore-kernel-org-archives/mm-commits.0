From: akpm@linux-foundation.org
Subject: + call_usermodehelper-simplify-fix-umh_no_wait-case.patch added to -mm tree
Date: Fri, 19 Mar 2010 15:06:54 -0700
Message-ID: <201003192206.o2JM6tJ9015045@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751243Ab0CSWHI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 18:07:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com


The patch titled
     call_usermodehelper: simplify/fix UMH_NO_WAIT case
has been added to the -mm tree.  Its filename is
     call_usermodehelper-simplify-fix-umh_no_wait-case.patch

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
Subject: call_usermodehelper: simplify/fix UMH_NO_WAIT case
From: Oleg Nesterov <oleg@redhat.com>

__call_usermodehelper(UMH_NO_WAIT) has 2 problems:

	- if kernel_thread() fails, call_usermodehelper_freeinfo()
	  is not called.

	- for unknown reason UMH_NO_WAIT has UMH_WAIT_PROC logic,
	  we spawn yet another thread which waits until the user
	  mode application exits.

Change the UMH_NO_WAIT code to use ____call_usermodehelper() instead of
wait_for_helper(), and do call_usermodehelper_freeinfo() unconditionally. 
We can rely on CLONE_VFORK, do_fork(CLONE_VFORK) until the child exits or
execs.

With or without this patch UMH_NO_WAIT does not report the error if
kernel_thread() fails, this is correct since the caller doesn't wait for
result.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN kernel/kmod.c~call_usermodehelper-simplify-fix-umh_no_wait-case kernel/kmod.c
--- a/kernel/kmod.c~call_usermodehelper-simplify-fix-umh_no_wait-case
+++ a/kernel/kmod.c
@@ -205,10 +205,7 @@ static int wait_for_helper(void *data)
 			sub_info->retval = ret;
 	}
 
-	if (sub_info->wait == UMH_NO_WAIT)
-		call_usermodehelper_freeinfo(sub_info);
-	else
-		complete(sub_info->complete);
+	complete(sub_info->complete);
 	return 0;
 }
 
@@ -217,13 +214,13 @@ static void __call_usermodehelper(struct
 {
 	struct subprocess_info *sub_info =
 		container_of(work, struct subprocess_info, work);
-	pid_t pid;
 	enum umh_wait wait = sub_info->wait;
+	pid_t pid;
 
 	/* CLONE_VFORK: wait until the usermode helper has execve'd
 	 * successfully We need the data structures to stay around
 	 * until that is done.  */
-	if (wait == UMH_WAIT_PROC || wait == UMH_NO_WAIT)
+	if (wait == UMH_WAIT_PROC)
 		pid = kernel_thread(wait_for_helper, sub_info,
 				    CLONE_FS | CLONE_FILES | SIGCHLD);
 	else
@@ -232,6 +229,7 @@ static void __call_usermodehelper(struct
 
 	switch (wait) {
 	case UMH_NO_WAIT:
+		call_usermodehelper_freeinfo(sub_info);
 		break;
 
 	case UMH_WAIT_PROC:
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

