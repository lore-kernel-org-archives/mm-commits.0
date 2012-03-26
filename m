From: akpm@linux-foundation.org
Subject: [merged] signal-zap_pid_ns_processes-s-send_sig_noinfo-send_sig_forced.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:32:21 -0700
Message-ID: <20120326193221.9EA82A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:53182 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab2CZTcX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:32:23 -0400
Received: by eaaq10 with SMTP id q10so290033eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:32:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, anton.vorontsov@linaro.org, ebiederm@xmission.com, kosaki.motohiro@gmail.com, rientjes@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: signal: zap_pid_ns_processes: s/SEND_SIG_NOINFO/SEND_SIG_FORCED/
has been removed from the -mm tree.  Its filename was
     signal-zap_pid_ns_processes-s-send_sig_noinfo-send_sig_forced.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: signal: zap_pid_ns_processes: s/SEND_SIG_NOINFO/SEND_SIG_FORCED/

Change zap_pid_ns_processes() to use SEND_SIG_FORCED, it looks more clear
compared to SEND_SIG_NOINFO which relies on from_ancestor_ns logic
send_signal().

It is also more efficient if we need to kill a lot of tasks because it
doesn't alloc sigqueue.

While at it, add the __fatal_signal_pending(task) check as a minor
optimization.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_namespace.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN kernel/pid_namespace.c~signal-zap_pid_ns_processes-s-send_sig_noinfo-send_sig_forced kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~signal-zap_pid_ns_processes-s-send_sig_noinfo-send_sig_forced
+++ a/kernel/pid_namespace.c
@@ -168,13 +168,9 @@ void zap_pid_ns_processes(struct pid_nam
 	while (nr > 0) {
 		rcu_read_lock();
 
-		/*
-		 * Any nested-container's init processes won't ignore the
-		 * SEND_SIG_NOINFO signal, see send_signal()->si_fromuser().
-		 */
 		task = pid_task(find_vpid(nr), PIDTYPE_PID);
-		if (task)
-			send_sig_info(SIGKILL, SEND_SIG_NOINFO, task);
+		if (task && !__fatal_signal_pending(task))
+			send_sig_info(SIGKILL, SEND_SIG_FORCED, task);
 
 		rcu_read_unlock();
 
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

