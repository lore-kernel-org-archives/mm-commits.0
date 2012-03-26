From: akpm@linux-foundation.org
Subject: [merged] usermodehelper-____call_usermodehelper-doesnt-need-do_exit.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:32:32 -0700
Message-ID: <20120326193232.6BB38A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:62114 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802Ab2CZTcd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:32:33 -0400
Received: by yenq2 with SMTP id q2so832475yen.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:32:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, rusty@rustcorp.com.au, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: usermodehelper: ____call_usermodehelper() doesn't need do_exit()
has been removed from the -mm tree.  Its filename was
     usermodehelper-____call_usermodehelper-doesnt-need-do_exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: usermodehelper: ____call_usermodehelper() doesn't need do_exit()

Minor cleanup.  ____call_usermodehelper() can simply return, no need to
call do_exit() explicitely.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kmod.c~usermodehelper-____call_usermodehelper-doesnt-need-do_exit kernel/kmod.c
--- a/kernel/kmod.c~usermodehelper-____call_usermodehelper-doesnt-need-do_exit
+++ a/kernel/kmod.c
@@ -188,7 +188,7 @@ static int ____call_usermodehelper(void 
 	/* Exec failed? */
 fail:
 	sub_info->retval = retval;
-	do_exit(0);
+	return 0;
 }
 
 void call_usermodehelper_freeinfo(struct subprocess_info *info)
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

