From: akpm@linux-foundation.org
Subject: + net-dccp-fix-link-error-with-config_sysctl.patch added to -mm tree
Date: Mon, 15 Oct 2007 16:19:19 -0700
Message-ID: <200710152319.l9FNJJKg030477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59775 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755062AbXJOXUF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 19:20:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, davem@davemloft.net, ian.mcdonald@jandi.co.nz


The patch titled
     net/DCCP: fix link error with !CONFIG_SYSCTL
has been added to the -mm tree.  Its filename is
     net-dccp-fix-link-error-with-config_sysctl.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: net/DCCP: fix link error with !CONFIG_SYSCTL
From: Ingo Molnar <mingo@elte.hu>

Do not define the sysctl_dccp_sync_ratelimit sysctl variable in the
CONFIG_SYSCTL dependent sysctl.c module - move it to input.c instead.

This fixes the following build bug:

 net/built-in.o: In function `dccp_check_seqno':
 input.c:(.text+0xbd859): undefined reference to `sysctl_dccp_sync_ratelimit'
 distcc[29953] ERROR: compile (null) on localhost failed
 make: *** [vmlinux] Error 1

Found via 'make randconfig' build testing.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Ian McDonald <ian.mcdonald@jandi.co.nz>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/dccp/input.c  |    3 +++
 net/dccp/sysctl.c |    3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN net/dccp/input.c~net-dccp-fix-link-error-with-config_sysctl net/dccp/input.c
--- a/net/dccp/input.c~net-dccp-fix-link-error-with-config_sysctl
+++ a/net/dccp/input.c
@@ -19,6 +19,9 @@
 #include "ccid.h"
 #include "dccp.h"
 
+/* rate-limit for syncs in reply to sequence-invalid packets; RFC 4340, 7.5.4 */
+int sysctl_dccp_sync_ratelimit	__read_mostly = HZ / 8;
+
 static void dccp_fin(struct sock *sk, struct sk_buff *skb)
 {
 	sk->sk_shutdown |= RCV_SHUTDOWN;
diff -puN net/dccp/sysctl.c~net-dccp-fix-link-error-with-config_sysctl net/dccp/sysctl.c
--- a/net/dccp/sysctl.c~net-dccp-fix-link-error-with-config_sysctl
+++ a/net/dccp/sysctl.c
@@ -18,9 +18,6 @@
 #error This file should not be compiled without CONFIG_SYSCTL defined
 #endif
 
-/* rate-limit for syncs in reply to sequence-invalid packets; RFC 4340, 7.5.4 */
-int sysctl_dccp_sync_ratelimit	__read_mostly = HZ / 8;
-
 static struct ctl_table dccp_default_table[] = {
 	{
 		.procname	= "seq_window",
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
git-acpi.patch
net-dccp-fix-link-error-with-config_sysctl.patch
provide-stubs-for-enable_irq_wake-and-disable_irq_wake.patch
git-sched.patch
i386-convert-mm_context_t-semaphore-to-a-mutex.patch
hpet-force-enable-on-vt8235-37-chipsets.patch
x86_64-vsyscall-fix-the-oops-crash-with-__pa_vsymbol.patch
replace-nt_prxfpreg-with-elf_core_xfpreg_type-define.patch
powerpc-add-altivec-vmx-state-to-coredumps.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
immunize-rcu_dereference-against-crazy-compiler-writers.patch
remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch
softlockup-use-cpu_clock-instead-of-sched_clock.patch
fix-the-softlockup-watchdog-to-actually-work.patch
softlockup-make-asm-irq_regsh-available-on-every-platform.patch
softlockup-improve-debug-output.patch
softlockup-improve-debug-output-fix.patch
softlockup-watchdog-style-cleanups.patch
softlockup-add-a-proc-tuning-parameter.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
time-simplify-smp_call_function_single-call-sequence.patch
kernel-rtmutex-debugc-cleanups.patch
pi-futex-set-pf_exiting-without-taking-pi_lock.patch
do_sigaction-remove-now-unneeded-recalc_sigpending.patch
handle-the-multi-threaded-inits-exit-properly.patch
wait_task_zombie-fix-2-3-races-vs-forget_original_parent.patch
pie-executable-randomization.patch
pie-executable-randomization-fix.patch
pie-executable-randomization-fix-2.patch
pie-executable-randomization-fix-3.patch
make-rcutorture-rng-use-temporal-entropy.patch
shrink-task_struct-if-config_futex=n.patch
move-preempt_notifiers-into-an-always-included-kconfig.patch
mutex-documentation-is-unclear-about-software-interrupts-tasklets-and-timers.patch
break-elf_platform-and-stack-pointer-randomization-dependency.patch
printk-add-kern_cont-annotation.patch
lockdep-annotate-kprobes-irq-fiddling.patch
lockdep-annotate-kprobes-irq-fiddling-fix.patch
do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist.patch
do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist-fix.patch
migration_callcpu_dead-use-spin_lock_irq-instead-of-task_rq_lock.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
lockdep-fix-mismatched-lockdep_depth-curr_chain_hash.patch
lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
uninline-find_task_by_xxx-set-of-functions.patch
cpuset-sched_load_balance-flag.patch
cpuset-sched_load_balance-flag-fix.patch
cpusets-decrustify-cpuset-mask-update-code.patch
cpusets-decrustify-cpuset-mask-update-code-checkpatch-fixes.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
hook-up-group-scheduler-with-control-groups.patch
hook-up-group-scheduler-with-control-groups-fix.patch
uninline-forkc-exitc.patch
uninline-forkc-exitc-checkpatch-fixes.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
