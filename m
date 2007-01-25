From: akpm@osdl.org
Subject: + add-irq-flag-to-disable-balancing-for-an-interrupt.patch added to -mm tree
Date: Wed, 24 Jan 2007 22:35:37 -0800
Message-ID: <200701250635.l0P6Zbq6008256@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50205 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965552AbXAYGgX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:36:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org


The patch titled
     Add irq flag to disable balancing for an interrupt
has been added to the -mm tree.  Its filename is
     add-irq-flag-to-disable-balancing-for-an-interrupt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add irq flag to disable balancing for an interrupt
From: Thomas Gleixner <tglx@linutronix.de>

Add a flag so we can prevent the irq balancing of an interrupt.  Move the
bits, so we have room for more :)

Necessary for the ability to setup clocksources more flexible (e.g.  use the
different HPET channels per CPU)

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/io_apic.c |    4 +--
 include/linux/interrupt.h  |    3 ++
 include/linux/irq.h        |   40 +++++++++++++++++++++--------------
 kernel/irq/manage.c        |    4 +++
 kernel/irq/proc.c          |    2 -
 5 files changed, 34 insertions(+), 19 deletions(-)

diff -puN arch/i386/kernel/io_apic.c~add-irq-flag-to-disable-balancing-for-an-interrupt arch/i386/kernel/io_apic.c
--- a/arch/i386/kernel/io_apic.c~add-irq-flag-to-disable-balancing-for-an-interrupt
+++ a/arch/i386/kernel/io_apic.c
@@ -482,8 +482,8 @@ static void do_irq_balance(void)
 		package_index = CPU_TO_PACKAGEINDEX(i);
 		for (j = 0; j < NR_IRQS; j++) {
 			unsigned long value_now, delta;
-			/* Is this an active IRQ? */
-			if (!irq_desc[j].action)
+			/* Is this an active IRQ or balancing disabled ? */
+			if (!irq_desc[j].action || irq_balancing_disabled(j))
 				continue;
 			if ( package_index == i )
 				IRQ_DELTA(package_index,j) = 0;
diff -puN include/linux/interrupt.h~add-irq-flag-to-disable-balancing-for-an-interrupt include/linux/interrupt.h
--- a/include/linux/interrupt.h~add-irq-flag-to-disable-balancing-for-an-interrupt
+++ a/include/linux/interrupt.h
@@ -41,6 +41,8 @@
  * IRQF_SHARED - allow sharing the irq among several devices
  * IRQF_PROBE_SHARED - set by callers when they expect sharing mismatches to occur
  * IRQF_TIMER - Flag to mark this interrupt as timer interrupt
+ * IRQF_PERCPU - Interrupt is per cpu
+ * IRQF_NOBALANCING - Flag to exclude this interrupt from irq balancing
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
@@ -48,6 +50,7 @@
 #define IRQF_PROBE_SHARED	0x00000100
 #define IRQF_TIMER		0x00000200
 #define IRQF_PERCPU		0x00000400
+#define IRQF_NOBALANCING	0x00000800
 
 /*
  * Migration helpers. Scheduled for removal in 1/2007
diff -puN include/linux/irq.h~add-irq-flag-to-disable-balancing-for-an-interrupt include/linux/irq.h
--- a/include/linux/irq.h~add-irq-flag-to-disable-balancing-for-an-interrupt
+++ a/include/linux/irq.h
@@ -31,7 +31,7 @@ typedef	void fastcall (*irq_flow_handler
 /*
  * IRQ line status.
  *
- * Bits 0-16 are reserved for the IRQF_* bits in linux/interrupt.h
+ * Bits 0-7 are reserved for the IRQF_* bits in linux/interrupt.h
  *
  * IRQ types
  */
@@ -45,27 +45,35 @@ typedef	void fastcall (*irq_flow_handler
 #define IRQ_TYPE_PROBE		0x00000010	/* Probing in progress */
 
 /* Internal flags */
-#define IRQ_INPROGRESS		0x00010000	/* IRQ handler active - do not enter! */
-#define IRQ_DISABLED		0x00020000	/* IRQ disabled - do not enter! */
-#define IRQ_PENDING		0x00040000	/* IRQ pending - replay on enable */
-#define IRQ_REPLAY		0x00080000	/* IRQ has been replayed but not acked yet */
-#define IRQ_AUTODETECT		0x00100000	/* IRQ is being autodetected */
-#define IRQ_WAITING		0x00200000	/* IRQ not yet seen - for autodetection */
-#define IRQ_LEVEL		0x00400000	/* IRQ level triggered */
-#define IRQ_MASKED		0x00800000	/* IRQ masked - shouldn't be seen again */
-#define IRQ_PER_CPU		0x01000000	/* IRQ is per CPU */
+#define IRQ_INPROGRESS		0x00000100	/* IRQ handler active - do not enter! */
+#define IRQ_DISABLED		0x00000200	/* IRQ disabled - do not enter! */
+#define IRQ_PENDING		0x00000400	/* IRQ pending - replay on enable */
+#define IRQ_REPLAY		0x00000800	/* IRQ has been replayed but not acked yet */
+#define IRQ_AUTODETECT		0x00001000	/* IRQ is being autodetected */
+#define IRQ_WAITING		0x00002000	/* IRQ not yet seen - for autodetection */
+#define IRQ_LEVEL		0x00004000	/* IRQ level triggered */
+#define IRQ_MASKED		0x00008000	/* IRQ masked - shouldn't be seen again */
+#define IRQ_PER_CPU		0x00010000	/* IRQ is per CPU */
+#define IRQ_NOPROBE		0x00020000	/* IRQ is not valid for probing */
+#define IRQ_NOREQUEST		0x00040000	/* IRQ cannot be requested */
+#define IRQ_NOAUTOEN		0x00080000	/* IRQ will not be enabled on request irq */
+#define IRQ_DELAYED_DISABLE	0x00100000	/* IRQ disable (masking) happens delayed. */
+#define IRQ_WAKEUP		0x00200000	/* IRQ triggers system wakeup */
+#define IRQ_MOVE_PENDING	0x00400000	/* need to re-target IRQ destination */
+#define IRQ_NO_BALANCING	0x00800000	/* IRQ is excluded from balancing */
+
 #ifdef CONFIG_IRQ_PER_CPU
 # define CHECK_IRQ_PER_CPU(var) ((var) & IRQ_PER_CPU)
+# define IRQ_NO_BALANCING_MASK	(IRQ_PER_CPU | IRQ_NO_BALANCING)
 #else
 # define CHECK_IRQ_PER_CPU(var) 0
+# define IRQ_NO_BALANCING_MASK	IRQ_NO_BALANCING
 #endif
 
-#define IRQ_NOPROBE		0x02000000	/* IRQ is not valid for probing */
-#define IRQ_NOREQUEST		0x04000000	/* IRQ cannot be requested */
-#define IRQ_NOAUTOEN		0x08000000	/* IRQ will not be enabled on request irq */
-#define IRQ_DELAYED_DISABLE	0x10000000	/* IRQ disable (masking) happens delayed. */
-#define IRQ_WAKEUP		0x20000000	/* IRQ triggers system wakeup */
-#define IRQ_MOVE_PENDING	0x40000000	/* need to re-target IRQ destination */
+static inline int irq_balancing_disabled(unsigned int irq)
+{
+	return irq_desc[irq].status & IRQ_NO_BALANCING_MASK;
+}
 
 struct proc_dir_entry;
 
diff -puN kernel/irq/manage.c~add-irq-flag-to-disable-balancing-for-an-interrupt kernel/irq/manage.c
--- a/kernel/irq/manage.c~add-irq-flag-to-disable-balancing-for-an-interrupt
+++ a/kernel/irq/manage.c
@@ -281,6 +281,10 @@ int setup_irq(unsigned int irq, struct i
 	if (new->flags & IRQF_PERCPU)
 		desc->status |= IRQ_PER_CPU;
 #endif
+	/* Exclude IRQ from balancing */
+	if (new->flags & IRQF_NOBALANCING)
+		desc->status |= IRQ_NO_BALANCING;
+
 	if (!shared) {
 		irq_chip_set_defaults(desc->chip);
 
diff -puN kernel/irq/proc.c~add-irq-flag-to-disable-balancing-for-an-interrupt kernel/irq/proc.c
--- a/kernel/irq/proc.c~add-irq-flag-to-disable-balancing-for-an-interrupt
+++ a/kernel/irq/proc.c
@@ -55,7 +55,7 @@ static int irq_affinity_write_proc(struc
 	cpumask_t new_value, tmp;
 
 	if (!irq_desc[irq].chip->set_affinity || no_irq_affinity ||
-				CHECK_IRQ_PER_CPU(irq_desc[irq].status))
+	    irq_balancing_disabled(irq))
 		return -EIO;
 
 	err = cpumask_parse_user(buffer, count, new_value);
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-block.patch
use-cycle_t-instead-of-u64-in-struct-time_interpolator.patch
proc-remove-useless-and-buggy-nlink-settings.patch
add-irq-flag-to-disable-balancing-for-an-interrupt.patch
add-a-functions-to-handle-interrupt-affinity-setting.patch
hz-free-ntp.patch
uninline-jiffiesh-functions.patch
fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
fix-timeout-overflow-with-jiffies.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
i386-remove-useless-code-in-tscc.patch
simplify-the-registration-of-clocksources.patch
x86-rewrite-smp-tsc-sync-code.patch
clocksource-replace-is_continuous-by-a-flag-field.patch
clocksource-replace-is_continuous-by-a-flag-field-fix.patch
clocksource-fixup-is_continous-changes-on-arm.patch
clocksource-fixup-is_continous-changes-on-avr32.patch
clocksource-fixup-is_continous-changes-on-s390.patch
clocksource-fixup-is_continous-changes-on-mips.patch
clocksource-remove-the-update-callback.patch
clocksource-add-verification-watchdog-helper.patch
clocksource-add-verification-watchdog-helper-fix.patch
mark-tsc-on-geodelx-reliable.patch
uninline-irq_enter.patch
fix-cascade-lookup-of-next_timer_interrupt.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-cleanup-locking.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-fix-missing-include-for-up.patch
acpi-keep-track-of-timer-broadcasting.patch
allow-early-access-to-the-power-management-timer.patch
i386-apic-clean-up-the-apic-code.patch
clockevents-add-core-functionality.patch
tick-management-core-functionality.patch
tick-management-broadcast-functionality.patch
tick-management-dyntick--highres-functionality.patch
clockevents-i383-drivers.patch
i386-rework-local-apic-timer-calibration.patch
i386-prepare-for-dyntick.patch
i386-prepare-nmi-watchdog-for-dynticks.patch
hrtimers-add-high-resolution-timer-support.patch
hrtimers-prevent-possible-itimer-dos.patch
add-debugging-feature-proc-timer_stat.patch
add-debugging-feature-proc-timer_list.patch
add-sysrq-q-to-print-timer_list-debug-info.patch
generic-vsyscall-gtod-support-for-generic_time.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-hpet_address-cleanup.patch
revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-split-x86_64-kernel-timec-up.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
make-good_sigevent-non-static.patch
aio-completion-signal-notification.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2.patch
scheduled-removal-of-sa_xxx-interrupt-flags.patch
