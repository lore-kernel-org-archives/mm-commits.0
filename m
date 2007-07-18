From: akpm@linux-foundation.org
Subject: + softlockup-improve-debug-output.patch added to -mm tree
Date: Tue, 17 Jul 2007 17:58:48 -0700
Message-ID: <200707180058.l6I0wngF016599@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33739 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752718AbXGRA7B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 20:59:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu


The patch titled
     softlockup: improve debug output
has been added to the -mm tree.  Its filename is
     softlockup-improve-debug-output.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: softlockup: improve debug output
From: Ingo Molnar <mingo@elte.hu>

Improve the debuggability of kernel lockups by enhancing the debug
output of the softlockup detector: print the task that causes the lockup
and try to print a more intelligent backtrace.

The old format was:

  BUG: soft lockup detected on CPU#1!
   [<c0105e4a>] show_trace_log_lvl+0x19/0x2e
   [<c0105f43>] show_trace+0x12/0x14
   [<c0105f59>] dump_stack+0x14/0x16
   [<c015f6bc>] softlockup_tick+0xbe/0xd0
   [<c013457d>] run_local_timers+0x12/0x14
   [<c01346b8>] update_process_times+0x3e/0x63
   [<c0145fb8>] tick_sched_timer+0x7c/0xc0
   [<c0140a75>] hrtimer_interrupt+0x135/0x1ba
   [<c011bde7>] smp_apic_timer_interrupt+0x6e/0x80
   [<c0105aa3>] apic_timer_interrupt+0x33/0x38
   [<c0104f8a>] syscall_call+0x7/0xb
   =======================

The new format is:

  BUG: soft lockup detected on CPU#1! [prctl:2363]

  Pid: 2363, comm:                prctl
  EIP: 0060:[<c013915f>] CPU: 1
  EIP is at sys_prctl+0x24/0x18c
   EFLAGS: 00000213    Not tainted  (2.6.22-cfs-v20 #26)
  EAX: 00000001 EBX: 000003e7 ECX: 00000001 EDX: f6df0000
  ESI: 000003e7 EDI: 000003e7 EBP: f6df0fb0 DS: 007b ES: 007b FS: 00d8
  CR0: 8005003b CR2: 4d8c3340 CR3: 3731d000 CR4: 000006d0
   [<c0105e4a>] show_trace_log_lvl+0x19/0x2e
   [<c0105f43>] show_trace+0x12/0x14
   [<c01040be>] show_regs+0x1ab/0x1b3
   [<c015f807>] softlockup_tick+0xef/0x108
   [<c013457d>] run_local_timers+0x12/0x14
   [<c01346b8>] update_process_times+0x3e/0x63
   [<c0145fcc>] tick_sched_timer+0x7c/0xc0
   [<c0140a89>] hrtimer_interrupt+0x135/0x1ba
   [<c011bde7>] smp_apic_timer_interrupt+0x6e/0x80
   [<c0105aa3>] apic_timer_interrupt+0x33/0x38
   [<c0104f8a>] syscall_call+0x7/0xb
   =======================

Note that in the old format we only knew that some system call locked
up, we didnt know _which_. With the new format we know that it's at a
specific place in sys_prctl(). [which was where i created an artificial
kernel lockup to test the new format.]

This is also useful if the lockup happens in user-space - the user-space
EIP (and other registers) will be printed too. (such a lockup would
either suggest that the task was running at SCHED_FIFO:99 and looping
for more than 10 seconds, or that the softlockup detector has a
false-positive.)

The task name is printed too first, just in case we dont manage to print
a useful backtrace.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softlockup.c |   23 ++++++++++++++++-------
 1 files changed, 16 insertions(+), 7 deletions(-)

diff -puN kernel/softlockup.c~softlockup-improve-debug-output kernel/softlockup.c
--- a/kernel/softlockup.c~softlockup-improve-debug-output
+++ a/kernel/softlockup.c
@@ -16,6 +16,8 @@
 #include <linux/module.h>
 #include <linux/kgdb.h>
 
+#include <asm/irq_regs.h>
+
 static DEFINE_SPINLOCK(print_lock);
 
 static DEFINE_PER_CPU(unsigned long, touch_timestamp);
@@ -74,6 +76,7 @@ void softlockup_tick(void)
 	int this_cpu = smp_processor_id();
 	unsigned long touch_timestamp = per_cpu(touch_timestamp, this_cpu);
 	unsigned long print_timestamp;
+	struct pt_regs *regs;
 	unsigned long now;
 
 	if (touch_timestamp == 0) {
@@ -103,15 +106,21 @@ void softlockup_tick(void)
 		wake_up_process(per_cpu(watchdog_task, this_cpu));
 
 	/* Warn about unreasonable 10+ seconds delays: */
-	if (now > (touch_timestamp + 10)) {
-		per_cpu(print_timestamp, this_cpu) = touch_timestamp;
+	if (now <= (touch_timestamp + 10))
+		return;
+
+	regs = get_irq_regs();
 
-		spin_lock(&print_lock);
-		printk(KERN_ERR "BUG: soft lockup detected on CPU#%d!\n",
-			this_cpu);
+	per_cpu(print_timestamp, this_cpu) = touch_timestamp;
+
+	spin_lock(&print_lock);
+	printk(KERN_ERR "BUG: soft lockup detected on CPU#%d! [%s:%d]\n",
+			this_cpu, current->comm, current->pid);
+	if (regs)
+		show_regs(regs);
+	else
 		dump_stack();
-		spin_unlock(&print_lock);
-	}
+	spin_unlock(&print_lock);
 }
 
 /*
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
git-acpi.patch
git-kvm.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
tick-management-spread-timer-interrupt.patch
highres-improve-debug-output.patch
hrtimer-speedup-hrtimer_enqueue.patch
pcspkr-use-the-global-pit-lock.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
i386-pit-stop-only-when-in-periodic-or-oneshot-mode.patch
i386-remove-volatile-in-apicc.patch
i386-hpet-assumes-boot-cpu-is-0.patch
i386-move-pit-function-declarations-and-constants-to-correct-header-file.patch
x86_64-untangle-asm-hpeth-from-asm-timexh.patch
x86_64-use-generic-cmos-update.patch
x86_64-remove-dead-code-and-other-janitor-work-in-tscc.patch
x86_64-fix-apic-typo.patch
x86_64-convert-to-cleckevents.patch
acpi-remove-the-useless-ifdef-code.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
ich-force-hpet-restructure-hpet-generic-clock-code.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
geode-mfgpt-clock-event-device-support.patch
i386-ioapic-remove-old-irq-balancing-debug-cruft.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
time-make-sure-sys_gettimeofday-and-sys_time-are-in.patch
fix-the-softlockup-watchdog-to-actually-work.patch
sys_time-use-barrier-instead-of-smp_rmb.patch
immunize-rcu_dereference-against-crazy-compiler-writers.patch
remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch
fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats.patch
softlockup-make-asm-irq_regsh-available-on-every-platform.patch
softlockup-improve-debug-output.patch
softlockup-watchdog-style-cleanups.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
fix-raw_spinlock_t-vs-lockdep.patch
lockdep-sanitise-config_prove_locking.patch
lockdep-reduce-the-ifdeffery.patch
lockstat-core-infrastructure.patch
lockstat-human-readability-tweaks.patch
lockstat-hook-into-spinlock_t-rwlock_t-rwsem-and-mutex.patch
lockdep-various-fixes.patch
lockdep-fixup-sk_callback_lock-annotation.patch
lockstat-measure-lock-bouncing.patch
lockstat-better-class-name-representation.patch
lockdep-debugging-give-stacktrace-for-init_error.patch
stacktrace-fix-header-file-for-config_stacktrace.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
random-warning-squishes.patch
