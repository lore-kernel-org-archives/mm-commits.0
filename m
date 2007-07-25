From: akpm@linux-foundation.org
Subject: + softlockup-use-cpu_clock-instead-of-sched_clock.patch added to -mm tree
Date: Wed, 25 Jul 2007 02:17:47 -0700
Message-ID: <200707250917.l6P9Hl0w026914@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49222 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754906AbXGYJST (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Jul 2007 05:18:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu


The patch titled
     softlockup: use cpu_clock() instead of sched_clock()
has been added to the -mm tree.  Its filename is
     softlockup-use-cpu_clock-instead-of-sched_clock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: softlockup: use cpu_clock() instead of sched_clock()
From: Ingo Molnar <mingo@elte.hu>

sched_clock() is not a reliable time-source, use cpu_clock() instead.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softlockup.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN kernel/softlockup.c~softlockup-use-cpu_clock-instead-of-sched_clock kernel/softlockup.c
--- a/kernel/softlockup.c~softlockup-use-cpu_clock-instead-of-sched_clock
+++ a/kernel/softlockup.c
@@ -41,14 +41,16 @@ static struct notifier_block panic_block
  * resolution, and we don't need to waste time with a big divide when
  * 2^30ns == 1.074s.
  */
-static unsigned long get_timestamp(void)
+static unsigned long get_timestamp(int this_cpu)
 {
-	return sched_clock() >> 30;  /* 2^30 ~= 10^9 */
+	return cpu_clock(this_cpu) >> 30;  /* 2^30 ~= 10^9 */
 }
 
 void touch_softlockup_watchdog(void)
 {
-	__raw_get_cpu_var(touch_timestamp) = get_timestamp();
+	int this_cpu = raw_smp_processor_id();
+
+	per_cpu(touch_timestamp, this_cpu) = get_timestamp(this_cpu);
 #ifdef CONFIG_KGDB
 	atomic_set(&kgdb_sync_softlockup[raw_smp_processor_id()], 0);
 #endif
@@ -95,7 +97,7 @@ void softlockup_tick(void)
 		return;
 	}
 
-	now = get_timestamp();
+	now = get_timestamp(this_cpu);
 
 	/* Wake up the high-prio watchdog task every second: */
 	if (now > (touch_timestamp + 1))
_

Patches currently in -mm which might be from mingo@elte.hu are

git-acpi.patch
git-kvm.patch
fix-theoretical-ccids_readwrite_lock-race.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
geode-mfgpt-clock-event-device-support.patch
i386-remove-unnecessary-code.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
immunize-rcu_dereference-against-crazy-compiler-writers.patch
remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch
fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats.patch
softlockup-use-cpu_clock-instead-of-sched_clock.patch
fix-the-softlockup-watchdog-to-actually-work.patch
softlockup-make-asm-irq_regsh-available-on-every-platform.patch
softlockup-improve-debug-output.patch
softlockup-watchdog-style-cleanups.patch
softlockup-add-a-proc-tuning-parameter.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
futex-pass-nr_wake2-to-futex_wake_op.patch
mark-sysrq_sched_debug_show-static.patch
cfs-mark-print_cfs_stats-static.patch
remove-kconfig-setting-config_debug_shirq.patch
debug-handling-of-early-spurious-interrupts.patch
time-simplify-smp_call_function_single-call-sequence.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
