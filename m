From: akpm@linux-foundation.org
Subject: - vdso-print-fatal-signals.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:54:30 -0700
Message-ID: <200707162054.l6GKsUFY001806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51072 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762725AbXGPV21 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:28:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, arjan@infradead.org, mm-commits@vger.kernel.org


The patch titled
     vdso: print fatal signals
has been removed from the -mm tree.  Its filename was
     vdso-print-fatal-signals.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: vdso: print fatal signals
From: Ingo Molnar <mingo@elte.hu>

Add the print-fatal-signals=1 boot option and the
/proc/sys/kernel/print-fatal-signals runtime switch.

This feature prints some minimal information about userspace segfaults to
the kernel console.  This is useful to find early bootup bugs where
userspace debugging is very hard.

Defaults to off.

[akpm@linux-foundation.org: Don't add new sysctl numbers]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    6 ++++
 kernel/signal.c                     |   33 ++++++++++++++++++++++++++
 kernel/sysctl.c                     |    9 +++++++
 3 files changed, 48 insertions(+)

diff -puN Documentation/kernel-parameters.txt~vdso-print-fatal-signals Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~vdso-print-fatal-signals
+++ a/Documentation/kernel-parameters.txt
@@ -1383,6 +1383,12 @@ and is between 256 and 4096 characters. 
 			autoconfiguration.
 			Ranges are in pairs (memory base and size).
 
+	print-fatal-signals=
+			[KNL] debug: print fatal signals
+			print-fatal-signals=1: print segfault info to
+			the kernel console.
+			default: off.
+
 	profile=	[KNL] Enable kernel profiling via /proc/profile
 			Format: [schedule,]<number>
 			Param: "schedule" - profile schedule points.
diff -puN kernel/signal.c~vdso-print-fatal-signals kernel/signal.c
--- a/kernel/signal.c~vdso-print-fatal-signals
+++ a/kernel/signal.c
@@ -718,6 +718,37 @@ out_set:
 #define LEGACY_QUEUE(sigptr, sig) \
 	(((sig) < SIGRTMIN) && sigismember(&(sigptr)->signal, (sig)))
 
+int print_fatal_signals;
+
+static void print_fatal_signal(struct pt_regs *regs, int signr)
+{
+	printk("%s/%d: potentially unexpected fatal signal %d.\n",
+		current->comm, current->pid, signr);
+
+#ifdef __i386__
+	printk("code at %08lx: ", regs->eip);
+	{
+		int i;
+		for (i = 0; i < 16; i++) {
+			unsigned char insn;
+
+			__get_user(insn, (unsigned char *)(regs->eip + i));
+			printk("%02x ", insn);
+		}
+	}
+#endif
+	printk("\n");
+	show_regs(regs);
+}
+
+static int __init setup_print_fatal_signals(char *str)
+{
+	get_option (&str, &print_fatal_signals);
+
+	return 1;
+}
+
+__setup("print-fatal-signals=", setup_print_fatal_signals);
 
 static int
 specific_send_sig_info(int sig, struct siginfo *info, struct task_struct *t)
@@ -1855,6 +1886,8 @@ relock:
 		 * Anything else is fatal, maybe with a core dump.
 		 */
 		current->flags |= PF_SIGNALED;
+		if ((signr != SIGKILL) && print_fatal_signals)
+			print_fatal_signal(regs, signr);
 		if (sig_kernel_coredump(signr)) {
 			/*
 			 * If it was able to dump core, this kills all
diff -puN kernel/sysctl.c~vdso-print-fatal-signals kernel/sysctl.c
--- a/kernel/sysctl.c~vdso-print-fatal-signals
+++ a/kernel/sysctl.c
@@ -61,6 +61,7 @@ extern int proc_nr_files(ctl_table *tabl
 
 /* External variables not in a header file. */
 extern int C_A_D;
+extern int print_fatal_signals;
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
 extern int sysctl_panic_on_oom;
@@ -340,6 +341,14 @@ static ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "print-fatal-signals",
+		.data		= &print_fatal_signals,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
 #ifdef __sparc__
 	{
 		.ctl_name	= KERN_SPARC_REBOOT,
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
immunize-rcu_dereference-against-crazy-compiler-writers.patch
remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch
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
