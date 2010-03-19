From: akpm@linux-foundation.org
Subject: + coredump-factor-out-put_cred-calls.patch added to -mm tree
Date: Fri, 19 Mar 2010 15:09:12 -0700
Message-ID: <201003192209.o2JM9Cmx015094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53974 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751260Ab0CSWJh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 18:09:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, andi@firstfloor.org, dhowells@redhat.com, nhorman@tuxdriver.com, roland@redhat.com


The patch titled
     coredump: factor out put_cred() calls
has been added to the -mm tree.  Its filename is
     coredump-factor-out-put_cred-calls.patch

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
Subject: coredump: factor out put_cred() calls
From: Oleg Nesterov <oleg@redhat.com>

Given that do_coredump() calls put_cred() on exit path, it is a bit ugly
to do put_cred() + "goto fail" twice, just add the new "fail_creds" label.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff -puN fs/exec.c~coredump-factor-out-put_cred-calls fs/exec.c
--- a/fs/exec.c~coredump-factor-out-put_cred-calls
+++ a/fs/exec.c
@@ -1859,10 +1859,8 @@ void do_coredump(long signr, int exit_co
 		goto fail;
 
 	cred = prepare_creds();
-	if (!cred) {
-		retval = -ENOMEM;
+	if (!cred)
 		goto fail;
-	}
 
 	down_write(&mm->mmap_sem);
 	/*
@@ -1870,8 +1868,7 @@ void do_coredump(long signr, int exit_co
 	 */
 	if (mm->core_state || !__get_dumpable(cprm.mm_flags)) {
 		up_write(&mm->mmap_sem);
-		put_cred(cred);
-		goto fail;
+		goto fail_creds;
 	}
 
 	/*
@@ -1886,10 +1883,8 @@ void do_coredump(long signr, int exit_co
 	}
 
 	retval = coredump_wait(exit_code, &core_state);
-	if (retval < 0) {
-		put_cred(cred);
-		goto fail;
-	}
+	if (retval < 0)
+		goto fail_creds;
 
 	old_cred = override_creds(cred);
 
@@ -2006,9 +2001,10 @@ fail_dropcount:
 	if (ispipe)
 		atomic_dec(&core_dump_count);
 fail_unlock:
+	coredump_finish(mm);
 	revert_creds(old_cred);
+fail_creds:
 	put_cred(cred);
-	coredump_finish(mm);
 fail:
 	return;
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
coredump-factor-out-the-not-ispipe-file-checks.patch
coredump-cleanup-ispipe-code.patch
coredump-factor-out-put_cred-calls.patch
coredump-shift-down_writemmap_sem-into-coredump_wait.patch

