From: akpm@linux-foundation.org
Subject: [merged] usermodehelper-implement-umh_killable.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:32:27 -0700
Message-ID: <20120326193227.C43EEA00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:58080 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab2CZTc2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:32:28 -0400
Received: by mail-gx0-f202.google.com with SMTP id d2so830938ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:32:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, rusty@rustcorp.com.au, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: usermodehelper: implement UMH_KILLABLE
has been removed from the -mm tree.  Its filename was
     usermodehelper-implement-umh_killable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: usermodehelper: implement UMH_KILLABLE

Implement UMH_KILLABLE, should be used along with UMH_WAIT_EXEC/PROC.  The
caller must ensure that subprocess_info->path/etc can not go away until
call_usermodehelper_freeinfo().

call_usermodehelper_exec(UMH_KILLABLE) does wait_for_completion_killable. 
If it fails, it uses xchg(&sub_info->complete, NULL) to serialize with
umh_complete() which does the same xhcg() to access sub_info->complete.

If call_usermodehelper_exec wins, it can safely return.  umh_complete()
should get NULL and call call_usermodehelper_freeinfo().

Otherwise we know that umh_complete() was already called, in this case
call_usermodehelper_exec() falls back to wait_for_completion() which
should succeed "very soon".

Note: UMH_NO_WAIT == -1 but it obviously should not be used with
UMH_KILLABLE.  We delay the neccessary cleanup to simplify the back
porting.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmod.h |    2 ++
 kernel/kmod.c        |   27 +++++++++++++++++++++++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff -puN include/linux/kmod.h~usermodehelper-implement-umh_killable include/linux/kmod.h
--- a/include/linux/kmod.h~usermodehelper-implement-umh_killable
+++ a/include/linux/kmod.h
@@ -54,6 +54,8 @@ enum umh_wait {
 	UMH_WAIT_PROC = 1,	/* wait for the process to complete */
 };
 
+#define UMH_KILLABLE	4	/* wait for EXEC/PROC killable */
+
 struct subprocess_info {
 	struct work_struct work;
 	struct completion *complete;
diff -puN kernel/kmod.c~usermodehelper-implement-umh_killable kernel/kmod.c
--- a/kernel/kmod.c~usermodehelper-implement-umh_killable
+++ a/kernel/kmod.c
@@ -201,7 +201,15 @@ EXPORT_SYMBOL(call_usermodehelper_freein
 
 static void umh_complete(struct subprocess_info *sub_info)
 {
-	complete(sub_info->complete);
+	struct completion *comp = xchg(&sub_info->complete, NULL);
+	/*
+	 * See call_usermodehelper_exec(). If xchg() returns NULL
+	 * we own sub_info, the UMH_KILLABLE caller has gone away.
+	 */
+	if (comp)
+		complete(comp);
+	else
+		call_usermodehelper_freeinfo(sub_info);
 }
 
 /* Keventd can't block, but this (a child) can. */
@@ -252,6 +260,9 @@ static void __call_usermodehelper(struct
 	enum umh_wait wait = sub_info->wait;
 	pid_t pid;
 
+	if (wait != UMH_NO_WAIT)
+		wait &= ~UMH_KILLABLE;
+
 	/* CLONE_VFORK: wait until the usermode helper has execve'd
 	 * successfully We need the data structures to stay around
 	 * until that is done.  */
@@ -461,9 +472,21 @@ int call_usermodehelper_exec(struct subp
 	queue_work(khelper_wq, &sub_info->work);
 	if (wait == UMH_NO_WAIT)	/* task has freed sub_info */
 		goto unlock;
+
+	if (wait & UMH_KILLABLE) {
+		retval = wait_for_completion_killable(&done);
+		if (!retval)
+			goto wait_done;
+
+		/* umh_complete() will see NULL and free sub_info */
+		if (xchg(&sub_info->complete, NULL))
+			goto unlock;
+		/* fallthrough, umh_complete() was already called */
+	}
+
 	wait_for_completion(&done);
+wait_done:
 	retval = sub_info->retval;
-
 out:
 	call_usermodehelper_freeinfo(sub_info);
 unlock:
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
avr32-dont-mask-signals-in-the-error-path.patch
avr32-use-set_current_blocked-in-handle_signal-sys_rt_sigreturn.patch
avr32-use-block_sigmask.patch
ia64-use-set_current_blocked-and-block_sigmask.patch
microblaze-dont-reimplement-force_sigsegv.patch
microblaze-no-need-to-reset-handler-if-sa_oneshot.patch
microblaze-fix-signal-masking.patch
microblaze-use-set_current_blocked-and-block_sigmask.patch
mips-use-set_current_blocked-and-block_sigmask.patch
score-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch
score-use-set_current_blocked-and-block_sigmask.patch
unicore32-use-block_sigmask.patch
blackfin-use-set_current_blocked-and-block_sigmask.patch
parisc-use-set_current_blocked-and-block_sigmask.patch
mm-coredump-fail-allocations-when-coredumping-instead-of-oom-killing.patch
frv-use-set_current_blocked-and-block_sigmask.patch
sh-no-need-to-reset-handler-if-sa_oneshot.patch
sh-use-set_current_blocked-and-block_sigmask.patch
h8300-use-set_current_blocked-and-block_sigmask.patch
alpha-use-set_current_blocked-and-block_sigmask.patch
m32r-use-set_current_blocked-and-block_sigmask.patch
m68k-use-set_current_blocked-and-block_sigmask.patch
mn10300-use-set_current_blocked-and-block_sigmask.patch
c6x-use-set_current_blocked-and-block_sigmask.patch
cris-use-set_current_blocked-and-block_sigmask.patch
powerpc-eeh-remove-eeh_event_handler-daemonize.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
c-r-prctl-add-ability-to-get-clear_tid_address-fix.patch

