From: akpm@linux-foundation.org
Subject: + call_usermodehelper-umh_wait_exec-ignores-kernel_thread-failure.patch added to -mm tree
Date: Fri, 19 Mar 2010 15:06:56 -0700
Message-ID: <201003192206.o2JM6ulO015048@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751243Ab0CSWHK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 18:07:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com


The patch titled
     call_usermodehelper: UMH_WAIT_EXEC ignores kernel_thread() failure
has been added to the -mm tree.  Its filename is
     call_usermodehelper-umh_wait_exec-ignores-kernel_thread-failure.patch

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
Subject: call_usermodehelper: UMH_WAIT_EXEC ignores kernel_thread() failure
From: Oleg Nesterov <oleg@redhat.com>

UMH_WAIT_EXEC should report the error if kernel_thread() fails, like
UMH_WAIT_PROC does.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/kmod.c~call_usermodehelper-umh_wait_exec-ignores-kernel_thread-failure kernel/kmod.c
--- a/kernel/kmod.c~call_usermodehelper-umh_wait_exec-ignores-kernel_thread-failure
+++ a/kernel/kmod.c
@@ -235,10 +235,10 @@ static void __call_usermodehelper(struct
 	case UMH_WAIT_PROC:
 		if (pid > 0)
 			break;
-		sub_info->retval = pid;
 		/* FALLTHROUGH */
-
 	case UMH_WAIT_EXEC:
+		if (pid < 0)
+			sub_info->retval = pid;
 		complete(sub_info->complete);
 	}
 }
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

