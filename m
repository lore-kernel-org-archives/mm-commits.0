From: akpm@linux-foundation.org
Subject: [merged] usermodehelper-introduce-umh_completesub_info.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:32:25 -0700
Message-ID: <20120326193225.66162A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:45421 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab2CZTc1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:32:27 -0400
Received: by mail-fa0-f74.google.com with SMTP id a19so298511faa.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:32:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, rusty@rustcorp.com.au, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: usermodehelper: introduce umh_complete(sub_info)
has been removed from the -mm tree.  Its filename was
     usermodehelper-introduce-umh_completesub_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: usermodehelper: introduce umh_complete(sub_info)

Preparation.  Add the new trivial helper, umh_complete().  Currently it
simply does complete(sub_info->complete).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN kernel/kmod.c~usermodehelper-introduce-umh_completesub_info kernel/kmod.c
--- a/kernel/kmod.c~usermodehelper-introduce-umh_completesub_info
+++ a/kernel/kmod.c
@@ -199,6 +199,11 @@ void call_usermodehelper_freeinfo(struct
 }
 EXPORT_SYMBOL(call_usermodehelper_freeinfo);
 
+static void umh_complete(struct subprocess_info *sub_info)
+{
+	complete(sub_info->complete);
+}
+
 /* Keventd can't block, but this (a child) can. */
 static int wait_for_helper(void *data)
 {
@@ -235,7 +240,7 @@ static int wait_for_helper(void *data)
 			sub_info->retval = ret;
 	}
 
-	complete(sub_info->complete);
+	umh_complete(sub_info);
 	return 0;
 }
 
@@ -269,7 +274,7 @@ static void __call_usermodehelper(struct
 	case UMH_WAIT_EXEC:
 		if (pid < 0)
 			sub_info->retval = pid;
-		complete(sub_info->complete);
+		umh_complete(sub_info);
 	}
 }
 
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

