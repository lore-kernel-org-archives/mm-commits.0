From: akpm@linux-foundation.org
Subject: [merged] kmod-make-__request_module-killable.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:32:36 -0700
Message-ID: <20120326193236.74C02A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:62187 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754077Ab2CZTcj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2012 15:32:39 -0400
Received: by laai8 with SMTP id i8so288365laa.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:32:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, rusty@rustcorp.com.au, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kmod: make __request_module() killable
has been removed from the -mm tree.  Its filename was
     kmod-make-__request_module-killable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: kmod: make __request_module() killable

As Tetsuo Handa pointed out, request_module() can stress the system while
the oom-killed caller sleeps in TASK_UNINTERRUPTIBLE.

The task T uses "almost all" memory, then it does something which triggers
request_module().  Say, it can simply call sys_socket().  This in turn
needs more memory and leads to OOM.  oom-killer correctly chooses T and
kills it, but this can't help because it sleeps in TASK_UNINTERRUPTIBLE
and after that oom-killer becomes "disabled" by the TIF_MEMDIE task T. 

Make __request_module() killable.  The only necessary change is that
call_modprobe() should kmalloc argv and module_name, they can't live in
the stack if we use UMH_KILLABLE.  This memory is freed via
call_usermodehelper_freeinfo()->cleanup.

Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff -puN kernel/kmod.c~kmod-make-__request_module-killable kernel/kmod.c
--- a/kernel/kmod.c~kmod-make-__request_module-killable
+++ a/kernel/kmod.c
@@ -60,6 +60,12 @@ static DECLARE_RWSEM(umhelper_sem);
 */
 char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";
 
+static void free_modprobe_argv(struct subprocess_info *info)
+{
+	kfree(info->argv[3]); /* check call_modprobe() */
+	kfree(info->argv);
+}
+
 static int call_modprobe(char *module_name, int wait)
 {
 	static char *envp[] = {
@@ -69,10 +75,26 @@ static int call_modprobe(char *module_na
 		NULL
 	};
 
-	char *argv[] = { modprobe_path, "-q", "--", module_name, NULL };
+	char **argv = kmalloc(sizeof(char *[5]), GFP_KERNEL);
+	if (!argv)
+		goto out;
+
+	module_name = kstrdup(module_name, GFP_KERNEL);
+	if (!module_name)
+		goto free_argv;
+
+	argv[0] = modprobe_path;
+	argv[1] = "-q";
+	argv[2] = "--";
+	argv[3] = module_name;	/* check free_modprobe_argv() */
+	argv[4] = NULL;
 
 	return call_usermodehelper_fns(modprobe_path, argv, envp,
-					wait, NULL, NULL, NULL);
+		wait | UMH_KILLABLE, NULL, free_modprobe_argv, NULL);
+free_argv:
+	kfree(argv);
+out:
+	return -ENOMEM;
 }
 
 /**
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

