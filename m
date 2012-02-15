From: akpm@linux-foundation.org
Subject: + usermodehelper-implement-umh_killable.patch added to -mm tree
Date: Wed, 15 Feb 2012 12:31:01 -0800
Message-ID: <20120215203102.053D6A01AD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:61460 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab2BOUbE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Feb 2012 15:31:04 -0500
Received: by faaa19 with SMTP id a19so64660faa.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Feb 2012 12:31:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, rusty@rustcorp.com.au, tj@kernel.org


The patch titled
     Subject: usermodehelper: implement UMH_KILLABLE
has been added to the -mm tree.  Its filename is
     usermodehelper-implement-umh_killable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: usermodehelper: implement UMH_KILLABLE

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
arm-use-set_current_blocked-and-block_sigmask.patch
avr32-dont-mask-signals-in-the-error-path.patch
avr32-use-set_current_blocked-in-handle_signal-sys_rt_sigreturn.patch
avr32-use-block_sigmask.patch
powerpc-use-set_current_blocked-and-block_sigmask.patch
hexagon-use-set_current_blocked-and-block_sigmask.patch
tile-use-set_current_blocked-and-block_sigmask.patch
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
openrisc-dont-reimplement-force_sigsegv.patch
openrisc-no-need-to-reset-handler-if-sa_oneshot.patch
openrisc-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch
openrisc-use-set_current_blocked-and-block_sigmask.patch
parisc-use-set_current_blocked-and-block_sigmask.patch
s390-use-block_sigmask.patch
xtensa-dont-reimplement-force_sigsegv.patch
xtensa-no-need-to-reset-handler-if-sa_oneshot.patch
xtensa-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch
xtensa-use-set_current_blocked-and-block_sigmask.patch
sparc-use-block_sigmask.patch
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
um-dont-restore-current-blocked-on-error.patch
um-use-set_current_blocked-and-block_sigmask.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
signal-give-send_sig_forced-more-power-to-beat-signal_unkillable.patch
signal-cosmetic-s-from_ancestor_ns-force-in-prepare_signal-paths.patch
signal-oom_kill_task-use-send_sig_forced-instead-of-force_sig.patch
signal-zap_pid_ns_processes-s-send_sig_noinfo-send_sig_forced.patch
usermodehelper-use-umh_wait_proc-consistently.patch
usermodehelper-introduce-umh_completesub_info.patch
usermodehelper-implement-umh_killable.patch
usermodehelper-kill-umh_wait-renumber-umh_-constants.patch
usermodehelper-____call_usermodehelper-doesnt-need-do_exit.patch
kmod-introduce-call_modprobe-helper.patch
kmod-make-__request_module-killable.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch

