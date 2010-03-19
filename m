From: akpm@linux-foundation.org
Subject: + coredump-shift-down_writemmap_sem-into-coredump_wait.patch added to -mm tree
Date: Fri, 19 Mar 2010 15:09:14 -0700
Message-ID: <201003192209.o2JM9Edh015097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751260Ab0CSWJg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 18:09:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, andi@firstfloor.org, dhowells@redhat.com, nhorman@tuxdriver.com, roland@redhat.com


The patch titled
     coredump: shift down_write(mmap_sem) into coredump_wait()
has been added to the -mm tree.  Its filename is
     coredump-shift-down_writemmap_sem-into-coredump_wait.patch

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
Subject: coredump: shift down_write(mmap_sem) into coredump_wait()
From: Oleg Nesterov <oleg@redhat.com>

- move the cprm.mm_flags checks up, before we take mmap_sem

- move down_write(mmap_sem) and ->core_state check from do_coredump()
  to coredump_wait()

This simplifies the code and makes the locking symmetrical.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff -puN fs/exec.c~coredump-shift-down_writemmap_sem-into-coredump_wait fs/exec.c
--- a/fs/exec.c~coredump-shift-down_writemmap_sem-into-coredump_wait
+++ a/fs/exec.c
@@ -1659,12 +1659,15 @@ static int coredump_wait(int exit_code, 
 	struct task_struct *tsk = current;
 	struct mm_struct *mm = tsk->mm;
 	struct completion *vfork_done;
-	int core_waiters;
+	int core_waiters = -EBUSY;
 
 	init_completion(&core_state->startup);
 	core_state->dumper.task = tsk;
 	core_state->dumper.next = NULL;
-	core_waiters = zap_threads(tsk, mm, core_state, exit_code);
+
+	down_write(&mm->mmap_sem);
+	if (!mm->core_state)
+		core_waiters = zap_threads(tsk, mm, core_state, exit_code);
 	up_write(&mm->mmap_sem);
 
 	if (unlikely(core_waiters < 0))
@@ -1857,20 +1860,12 @@ void do_coredump(long signr, int exit_co
 	binfmt = mm->binfmt;
 	if (!binfmt || !binfmt->core_dump)
 		goto fail;
+	if (!__get_dumpable(cprm.mm_flags))
+		goto fail;
 
 	cred = prepare_creds();
 	if (!cred)
 		goto fail;
-
-	down_write(&mm->mmap_sem);
-	/*
-	 * If another thread got here first, or we are not dumpable, bail out.
-	 */
-	if (mm->core_state || !__get_dumpable(cprm.mm_flags)) {
-		up_write(&mm->mmap_sem);
-		goto fail_creds;
-	}
-
 	/*
 	 *	We cannot trust fsuid as being the "true" uid of the
 	 *	process nor do we know its entire history. We only know it
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

