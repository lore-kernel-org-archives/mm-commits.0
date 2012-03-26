From: akpm@linux-foundation.org
Subject: [merged] signal-give-send_sig_forced-more-power-to-beat-signal_unkillable.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:32:15 -0700
Message-ID: <20120326193215.8657BA00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:47661 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab2CZTcQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:32:16 -0400
Received: by mail-gy0-f202.google.com with SMTP id z15so831635ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:32:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, anton.vorontsov@linaro.org, ebiederm@xmission.com, kosaki.motohiro@gmail.com, rientjes@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: signal: give SEND_SIG_FORCED more power to beat SIGNAL_UNKILLABLE
has been removed from the -mm tree.  Its filename was
     signal-give-send_sig_forced-more-power-to-beat-signal_unkillable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: signal: give SEND_SIG_FORCED more power to beat SIGNAL_UNKILLABLE

force_sig_info() and friends have the special semantics for synchronous
signals, this interface should not be used if the target is not current. 
And it needs the fixes, in particular the clearing of SIGNAL_UNKILLABLE is
not exactly right.

However there are callers which have to use force_ exactly because it
clears SIGNAL_UNKILLABLE and thus it can kill the CLONE_NEWPID tasks,
although this is almost always is wrong by various reasons.

With this patch SEND_SIG_FORCED ignores SIGNAL_UNKILLABLE, like we do if
the signal comes from the ancestor namespace.

This makes the naming in prepare_signal() paths insane, fixed by the next
cleanup.

Note: this only affects SIGKILL/SIGSTOP, but this is enough for
force_sig() abusers.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/signal.c~signal-give-send_sig_forced-more-power-to-beat-signal_unkillable kernel/signal.c
--- a/kernel/signal.c~signal-give-send_sig_forced-more-power-to-beat-signal_unkillable
+++ a/kernel/signal.c
@@ -1059,7 +1059,8 @@ static int __send_signal(int sig, struct
 	assert_spin_locked(&t->sighand->siglock);
 
 	result = TRACE_SIGNAL_IGNORED;
-	if (!prepare_signal(sig, t, from_ancestor_ns))
+	if (!prepare_signal(sig, t,
+			from_ancestor_ns || (info == SEND_SIG_FORCED)))
 		goto ret;
 
 	pending = group ? &t->signal->shared_pending : &t->pending;
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

