From: akpm@linux-foundation.org
Subject: [merged] signal-oom_kill_task-use-send_sig_forced-instead-of-force_sig.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:32:19 -0700
Message-ID: <20120326193219.A0F0EA00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:60876 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674Ab2CZTcX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:32:23 -0400
Received: by lbbgj3 with SMTP id gj3so288199lbb.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:32:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, anton.vorontsov@linaro.org, ebiederm@xmission.com, kosaki.motohiro@gmail.com, rientjes@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: signal: oom_kill_task: use SEND_SIG_FORCED instead of force_sig()
has been removed from the -mm tree.  Its filename was
     signal-oom_kill_task-use-send_sig_forced-instead-of-force_sig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: signal: oom_kill_task: use SEND_SIG_FORCED instead of force_sig()

Change oom_kill_task() to use do_send_sig_info(SEND_SIG_FORCED) instead of
force_sig(SIGKILL).  With the recent changes we do not need force_ to kill
the CLONE_NEWPID tasks.

And this is more correct.  force_sig() can race with the exiting thread
even if oom_kill_task() checks p->mm != NULL, while do_send_sig_info(group
=> true) kille the whole process.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/oom_kill.c~signal-oom_kill_task-use-send_sig_forced-instead-of-force_sig mm/oom_kill.c
--- a/mm/oom_kill.c~signal-oom_kill_task-use-send_sig_forced-instead-of-force_sig
+++ a/mm/oom_kill.c
@@ -521,11 +521,11 @@ static void oom_kill_process(struct task
 			pr_err("Kill process %d (%s) sharing same memory\n",
 				task_pid_nr(p), p->comm);
 			task_unlock(p);
-			force_sig(SIGKILL, p);
+			do_send_sig_info(SIGKILL, SEND_SIG_FORCED, p, true);
 		}
 
 	set_tsk_thread_flag(victim, TIF_MEMDIE);
-	force_sig(SIGKILL, victim);
+	do_send_sig_info(SIGKILL, SEND_SIG_FORCED, victim, true);
 }
 #undef K
 
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

