From: akpm@linux-foundation.org
Subject: + coredump-cleanup-ispipe-code.patch added to -mm tree
Date: Fri, 19 Mar 2010 15:09:10 -0700
Message-ID: <201003192209.o2JM9Ack015091@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33739 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751260Ab0CSWJj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 18:09:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, andi@firstfloor.org, dhowells@redhat.com, nhorman@tuxdriver.com, roland@redhat.com


The patch titled
     coredump: cleanup "ispipe" code
has been added to the -mm tree.  Its filename is
     coredump-cleanup-ispipe-code.patch

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
Subject: coredump: cleanup "ispipe" code
From: Oleg Nesterov <oleg@redhat.com>

- kill "int dump_count", argv_split(argcp) accepts argcp == NULL.

- move "int dump_count" under " if (ispipe)" branch, fail_dropcount
  can check ispipe.

- move "char **helper_argv" as well, change the code to do argv_free()
  right after call_usermodehelper_fns().

- If call_usermodehelper_fns() fails goto close_fail label instead
  of closing the file by hand.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff -puN fs/exec.c~coredump-cleanup-ispipe-code fs/exec.c
--- a/fs/exec.c~coredump-cleanup-ispipe-code
+++ a/fs/exec.c
@@ -1838,10 +1838,7 @@ void do_coredump(long signr, int exit_co
 	struct cred *cred;
 	int retval = 0;
 	int flag = 0;
-	int ispipe = 0;
-	char **helper_argv = NULL;
-	int helper_argc = 0;
-	int dump_count = 0;
+	int ispipe;
 	static atomic_t core_dump_count = ATOMIC_INIT(0);
 	struct coredump_params cprm = {
 		.signr = signr,
@@ -1911,6 +1908,9 @@ void do_coredump(long signr, int exit_co
 	unlock_kernel();
 
  	if (ispipe) {
+		int dump_count;
+		char **helper_argv;
+
 		if (cprm.limit == 1) {
 			/*
 			 * Normally core limits are irrelevant to pipes, since
@@ -1932,6 +1932,7 @@ void do_coredump(long signr, int exit_co
 			printk(KERN_WARNING "Aborting core\n");
 			goto fail_unlock;
 		}
+		cprm.limit = RLIM_INFINITY;
 
 		dump_count = atomic_inc_return(&core_dump_count);
 		if (core_pipe_limit && (core_pipe_limit < dump_count)) {
@@ -1941,26 +1942,21 @@ void do_coredump(long signr, int exit_co
 			goto fail_dropcount;
 		}
 
-		helper_argv = argv_split(GFP_KERNEL, corename+1, &helper_argc);
+		helper_argv = argv_split(GFP_KERNEL, corename+1, NULL);
 		if (!helper_argv) {
 			printk(KERN_WARNING "%s failed to allocate memory\n",
 			       __func__);
 			goto fail_dropcount;
 		}
 
-		cprm.limit = RLIM_INFINITY;
-
-		/* SIGPIPE can happen, but it's just never processed */
-		cprm.file = NULL;
-		if (call_usermodehelper_fns(helper_argv[0], helper_argv, NULL,
-					    UMH_WAIT_EXEC, umh_pipe_setup,
-					    NULL, &cprm)) {
-			if (cprm.file)
-				filp_close(cprm.file, NULL);
-
+		retval = call_usermodehelper_fns(helper_argv[0], helper_argv,
+					NULL, UMH_WAIT_EXEC, umh_pipe_setup,
+					NULL, &cprm);
+		argv_free(helper_argv);
+		if (retval) {
  			printk(KERN_INFO "Core dump to %s pipe failed\n",
 			       corename);
-			goto fail_dropcount;
+			goto close_fail;
  		}
 	} else {
 		struct inode *inode;
@@ -2000,17 +1996,16 @@ void do_coredump(long signr, int exit_co
 	retval = binfmt->core_dump(&cprm);
 	if (retval)
 		current->signal->group_exit_code |= 0x80;
-close_fail:
+
 	if (ispipe && core_pipe_limit)
 		wait_for_dump_helpers(cprm.file);
-	filp_close(cprm.file, NULL);
+close_fail:
+	if (cprm.file)
+		filp_close(cprm.file, NULL);
 fail_dropcount:
-	if (dump_count)
+	if (ispipe)
 		atomic_dec(&core_dump_count);
 fail_unlock:
-	if (helper_argv)
-		argv_free(helper_argv);
-
 	revert_creds(old_cred);
 	put_cred(cred);
 	coredump_finish(mm);
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

