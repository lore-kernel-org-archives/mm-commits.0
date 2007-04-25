From: akpm@linux-foundation.org
Subject: - vmi-timer-update.patch removed from -mm tree
Date: Wed, 25 Apr 2007 13:40:00 -0700
Message-ID: <200704252040.l3PKe0ej012364@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993158AbXDYUkd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 16:40:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zach@vmware.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     Vmi timer update
has been removed from the -mm tree.  Its filename was
     vmi-timer-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Vmi timer update
From: Zachary Amsden <zach@vmware.com>

Convert VMI timer to use clock events, making it properly able to use the
NO_HZ infrastructure.  On UP systems, with no local APIC, we just continue to
route these events through the PIT.  On systems with a local APIC, or SMP, we
provide a single source interrupt chip which creates the local timer IRQ.  It
actually gets delivered by the APIC hardware, but we don't want to use the
same local APIC clocksource processing, so we create our own handler here.

Signed-off-by: Zachary Amsden <zach@vmware.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/Makefile   |    2 
 arch/i386/kernel/entry.S    |    5 
 arch/i386/kernel/vmi.c      |   26 -
 arch/i386/kernel/vmiclock.c |  318 ++++++++++++++++++++++
 arch/i386/kernel/vmitime.c  |  482 ----------------------------------
 include/asm-i386/vmi_time.h |   18 -
 6 files changed, 327 insertions(+), 524 deletions(-)

diff -puN arch/i386/kernel/Makefile~vmi-timer-update arch/i386/kernel/Makefile
--- a/arch/i386/kernel/Makefile~vmi-timer-update
+++ a/arch/i386/kernel/Makefile
@@ -41,7 +41,7 @@ obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
 obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_STACK_UNWIND)	+= unwind.o
 
-obj-$(CONFIG_VMI)		+= vmi.o vmitime.o
+obj-$(CONFIG_VMI)		+= vmi.o vmiclock.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o
 obj-y				+= pcspeaker.o
 
diff -puN arch/i386/kernel/entry.S~vmi-timer-update arch/i386/kernel/entry.S
--- a/arch/i386/kernel/entry.S~vmi-timer-update
+++ a/arch/i386/kernel/entry.S
@@ -638,11 +638,6 @@ ENDPROC(name)
 /* The include is where all of the SMP etc. interrupts come from */
 #include "entry_arch.h"
 
-/* This alternate entry is needed because we hijack the apic LVTT */
-#if defined(CONFIG_VMI) && defined(CONFIG_X86_LOCAL_APIC)
-BUILD_INTERRUPT(apic_vmi_timer_interrupt,LOCAL_TIMER_VECTOR)
-#endif
-
 KPROBE_ENTRY(page_fault)
 	RING0_EC_FRAME
 	pushl $do_page_fault
diff -puN arch/i386/kernel/vmi.c~vmi-timer-update arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c~vmi-timer-update
+++ a/arch/i386/kernel/vmi.c
@@ -77,6 +77,9 @@ static struct {
 extern struct paravirt_patch_site __parainstructions[],
 	__parainstructions_end[];
 
+/* Cached VMI operations */
+struct vmi_timer_ops vmi_timer_ops;
+
 /*
  * VMI patching routines.
  */
@@ -235,18 +238,6 @@ static void vmi_nop(void)
 {
 }
 
-/* For NO_IDLE_HZ, we stop the clock when halting the kernel */
-static fastcall void vmi_safe_halt(void)
-{
-	int idle = vmi_stop_hz_timer();
-	vmi_ops.halt();
-	if (idle) {
-		local_irq_disable();
-		vmi_account_time_restart_hz_timer();
-		local_irq_enable();
-	}
-}
-
 #ifdef CONFIG_DEBUG_PAGE_TYPE
 
 #ifdef CONFIG_X86_PAE
@@ -726,7 +717,6 @@ do {								\
 	}							\
 } while (0)
 
-
 /*
  * Activate the VMI interface and switch into paravirtualized mode
  */
@@ -905,8 +895,8 @@ static inline int __init activate_vmi(vo
 		paravirt_ops.get_wallclock = vmi_get_wallclock;
 		paravirt_ops.set_wallclock = vmi_set_wallclock;
 #ifdef CONFIG_X86_LOCAL_APIC
-		paravirt_ops.setup_boot_clock = vmi_timer_setup_boot_alarm;
-		paravirt_ops.setup_secondary_clock = vmi_timer_setup_secondary_alarm;
+		paravirt_ops.setup_boot_clock = vmi_time_bsp_init;
+		paravirt_ops.setup_secondary_clock = vmi_time_ap_init;
 #endif
 		paravirt_ops.get_scheduled_cycles = vmi_get_sched_cycles;
  		paravirt_ops.get_cpu_khz = vmi_cpu_khz;
@@ -918,11 +908,7 @@ static inline int __init activate_vmi(vo
 		disable_vmi_timer = 1;
 	}
 
-	/* No idle HZ mode only works if VMI timer and no idle is enabled */
-	if (disable_noidle || disable_vmi_timer)
-		para_fill(safe_halt, Halt);
-	else
-		para_wrap(safe_halt, vmi_safe_halt, halt, Halt);
+	para_fill(safe_halt, Halt);
 
 	/*
 	 * Alternative instruction rewriting doesn't happen soon enough
diff -puN /dev/null arch/i386/kernel/vmiclock.c
--- /dev/null
+++ a/arch/i386/kernel/vmiclock.c
@@ -0,0 +1,318 @@
+/*
+ * VMI paravirtual timer support routines.
+ *
+ * Copyright (C) 2007, VMware, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#include <linux/smp.h>
+#include <linux/interrupt.h>
+#include <linux/cpumask.h>
+#include <linux/clocksource.h>
+#include <linux/clockchips.h>
+
+#include <asm/vmi.h>
+#include <asm/vmi_time.h>
+#include <asm/arch_hooks.h>
+#include <asm/apicdef.h>
+#include <asm/apic.h>
+#include <asm/timer.h>
+
+#include <irq_vectors.h>
+#include "io_ports.h"
+
+#define VMI_ONESHOT  (VMI_ALARM_IS_ONESHOT  | VMI_CYCLES_REAL | vmi_get_alarm_wiring())
+#define VMI_PERIODIC (VMI_ALARM_IS_PERIODIC | VMI_CYCLES_REAL | vmi_get_alarm_wiring())
+
+static DEFINE_PER_CPU(struct clock_event_device, local_events);
+
+static inline u32 vmi_counter(u32 flags)
+{
+	/* Given VMI_ONESHOT or VMI_PERIODIC, return the corresponding
+	 * cycle counter. */
+	return flags & VMI_ALARM_COUNTER_MASK;
+}
+
+/* paravirt_ops.get_wallclock = vmi_get_wallclock */
+unsigned long vmi_get_wallclock(void)
+{
+	unsigned long long wallclock;
+	wallclock = vmi_timer_ops.get_wallclock(); // nsec
+	(void)do_div(wallclock, 1000000000);       // sec
+
+	return wallclock;
+}
+
+/* paravirt_ops.set_wallclock = vmi_set_wallclock */
+int vmi_set_wallclock(unsigned long now)
+{
+	return 0;
+}
+
+/* paravirt_ops.get_scheduled_cycles = vmi_get_sched_cycles */
+unsigned long long vmi_get_sched_cycles(void)
+{
+	return vmi_timer_ops.get_cycle_counter(VMI_CYCLES_AVAILABLE);
+}
+
+/* paravirt_ops.get_cpu_khz = vmi_cpu_khz */
+unsigned long vmi_cpu_khz(void)
+{
+	unsigned long long khz;
+	khz = vmi_timer_ops.get_cycle_frequency();
+	(void)do_div(khz, 1000);
+	return khz;
+}
+
+static inline unsigned int vmi_get_timer_vector(void)
+{
+#ifdef CONFIG_X86_IO_APIC
+	return FIRST_DEVICE_VECTOR;
+#else
+	return FIRST_EXTERNAL_VECTOR;
+#endif
+}
+
+/** vmi clockchip */
+#ifdef CONFIG_X86_LOCAL_APIC
+static unsigned int startup_timer_irq(unsigned int irq)
+{
+	unsigned long val = apic_read(APIC_LVTT);
+	apic_write(APIC_LVTT, vmi_get_timer_vector());
+
+	return (val & APIC_SEND_PENDING);
+}
+
+static void mask_timer_irq(unsigned int irq)
+{
+	unsigned long val = apic_read(APIC_LVTT);
+	apic_write(APIC_LVTT, val | APIC_LVT_MASKED);
+}
+
+static void unmask_timer_irq(unsigned int irq)
+{
+	unsigned long val = apic_read(APIC_LVTT);
+	apic_write(APIC_LVTT, val & ~APIC_LVT_MASKED);
+}
+
+static void ack_timer_irq(unsigned int irq)
+{
+	ack_APIC_irq();
+}
+
+static struct irq_chip vmi_chip __read_mostly = {
+	.name 		= "VMI-LOCAL",
+	.startup 	= startup_timer_irq,
+	.mask	 	= mask_timer_irq,
+	.unmask	 	= unmask_timer_irq,
+	.ack 		= ack_timer_irq
+};
+#endif
+
+/** vmi clockevent */
+#define VMI_ALARM_WIRED_IRQ0    0x00000000
+#define VMI_ALARM_WIRED_LVTT    0x00010000
+static int vmi_wiring = VMI_ALARM_WIRED_IRQ0;
+
+static inline int vmi_get_alarm_wiring(void)
+{
+	return vmi_wiring;
+}
+
+static void vmi_timer_set_mode(enum clock_event_mode mode,
+			       struct clock_event_device *evt)
+{
+	cycle_t now, cycles_per_hz;
+	BUG_ON(!irqs_disabled());
+
+	switch (mode) {
+	case CLOCK_EVT_MODE_ONESHOT:
+		break;
+	case CLOCK_EVT_MODE_PERIODIC:
+		cycles_per_hz = vmi_timer_ops.get_cycle_frequency();
+		(void)do_div(cycles_per_hz, HZ);
+		now = vmi_timer_ops.get_cycle_counter(vmi_counter(VMI_PERIODIC));
+		vmi_timer_ops.set_alarm(VMI_PERIODIC, now, cycles_per_hz);
+		break;
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		switch (evt->mode) {
+		case CLOCK_EVT_MODE_ONESHOT:
+			vmi_timer_ops.cancel_alarm(VMI_ONESHOT);
+			break;
+		case CLOCK_EVT_MODE_PERIODIC:
+			vmi_timer_ops.cancel_alarm(VMI_PERIODIC);
+			break;
+		default:
+			break;
+		}
+		break;
+	default:
+		break;
+	}
+}
+
+static int vmi_timer_next_event(unsigned long delta,
+				struct clock_event_device *evt)
+{
+	/* Unfortunately, set_next_event interface only passes relative
+	 * expiry, but we want absolute expiry.  It'd be better if were
+	 * were passed an aboslute expiry, since a bunch of time may
+	 * have been stolen between the time the delta is computed and
+	 * when we set the alarm below. */
+	cycle_t now = vmi_timer_ops.get_cycle_counter(vmi_counter(VMI_ONESHOT));
+
+	BUG_ON(evt->mode != CLOCK_EVT_MODE_ONESHOT);
+	vmi_timer_ops.set_alarm(VMI_ONESHOT, now + delta, 0);
+	return 0;
+}
+
+static struct clock_event_device vmi_clockevent = {
+	.name		= "vmi-timer",
+	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+	.shift		= 22,
+	.set_mode	= vmi_timer_set_mode,
+	.set_next_event = vmi_timer_next_event,
+	.rating         = 1000,
+	.irq		= 0,
+};
+
+static irqreturn_t vmi_timer_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *evt = &__get_cpu_var(local_events);
+	evt->event_handler(evt);
+	return IRQ_HANDLED;
+}
+
+static struct irqaction vmi_clock_action  = {
+	.name 		= "vmi-timer",
+	.handler 	= vmi_timer_interrupt,
+	.flags 		= IRQF_DISABLED | IRQF_NOBALANCING,
+	.mask 		= CPU_MASK_ALL,
+};
+
+static void __devinit vmi_time_init_clockevent(void)
+{
+	cycle_t cycles_per_msec;
+	struct clock_event_device *evt;
+
+	int cpu = smp_processor_id();
+	evt = &__get_cpu_var(local_events);
+
+	/* Use cycles_per_msec since div_sc params are 32-bits. */
+	cycles_per_msec = vmi_timer_ops.get_cycle_frequency();
+	(void)do_div(cycles_per_msec, 1000);
+
+	memcpy(evt, &vmi_clockevent, sizeof(*evt));
+	/* Must pick .shift such that .mult fits in 32-bits.  Choosing
+	 * .shift to be 22 allows 2^(32-22) cycles per nano-seconds
+	 * before overflow. */
+	evt->mult = div_sc(cycles_per_msec, NSEC_PER_MSEC, evt->shift);
+	/* Upper bound is clockevent's use of ulong for cycle deltas. */
+	evt->max_delta_ns = clockevent_delta2ns(ULONG_MAX, evt);
+	evt->min_delta_ns = clockevent_delta2ns(1, evt);
+	evt->cpumask = cpumask_of_cpu(cpu);
+
+	printk(KERN_WARNING "vmi: registering clock event %s. mult=%lu shift=%u\n",
+	       evt->name, evt->mult, evt->shift);
+	clockevents_register_device(evt);
+}
+
+void __init vmi_time_init(void)
+{
+	/* Disable PIT: BIOSes start PIT CH0 with 18.2hz peridic. */
+	outb_p(0x3a, PIT_MODE); /* binary, mode 5, LSB/MSB, ch 0 */
+
+	vmi_time_init_clockevent();
+	setup_irq(0, &vmi_clock_action);
+}
+
+#ifdef CONFIG_X86_LOCAL_APIC
+void __devinit vmi_time_bsp_init(void)
+{
+	/*
+	 * On APIC systems, we want local timers to fire on each cpu.  We do
+	 * this by programming LVTT to deliver timer events to the IRQ handler
+	 * for IRQ-0, since we can't re-use the APIC local timer handler
+	 * without interfering with that code.
+	 */
+	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
+	local_irq_disable();
+#ifdef CONFIG_X86_SMP
+	/*
+	 * XXX handle_percpu_irq only defined for SMP; we need to switch over
+	 * to using it, since this is a local interrupt, which each CPU must
+	 * handle individually without locking out or dropping simultaneous
+	 * local timers on other CPUs.  We also don't want to trigger the
+	 * quirk workaround code for interrupts which gets invoked from
+	 * handle_percpu_irq via eoi, so we use our own IRQ chip.
+	 */
+	set_irq_chip_and_handler_name(0, &vmi_chip, handle_percpu_irq, "lvtt");
+#else
+	set_irq_chip_and_handler_name(0, &vmi_chip, handle_edge_irq, "lvtt");
+#endif
+	vmi_wiring = VMI_ALARM_WIRED_LVTT;
+	apic_write(APIC_LVTT, vmi_get_timer_vector());
+	local_irq_enable();
+	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
+}
+
+void __devinit vmi_time_ap_init(void)
+{
+	vmi_time_init_clockevent();
+	apic_write(APIC_LVTT, vmi_get_timer_vector());
+}
+#endif
+
+/** vmi clocksource */
+
+static cycle_t read_real_cycles(void)
+{
+	return vmi_timer_ops.get_cycle_counter(VMI_CYCLES_REAL);
+}
+
+static struct clocksource clocksource_vmi = {
+	.name			= "vmi-timer",
+	.rating			= 450,
+	.read			= read_real_cycles,
+	.mask			= CLOCKSOURCE_MASK(64),
+	.mult			= 0, /* to be set */
+	.shift			= 22,
+	.flags			= CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+static int __init init_vmi_clocksource(void)
+{
+	cycle_t cycles_per_msec;
+
+	if (!vmi_timer_ops.get_cycle_frequency)
+		return 0;
+	/* Use khz2mult rather than hz2mult since hz arg is only 32-bits. */
+	cycles_per_msec = vmi_timer_ops.get_cycle_frequency();
+	(void)do_div(cycles_per_msec, 1000);
+
+	/* Note that clocksource.{mult, shift} converts in the opposite direction
+	 * as clockevents.  */
+	clocksource_vmi.mult = clocksource_khz2mult(cycles_per_msec,
+						    clocksource_vmi.shift);
+
+	printk(KERN_WARNING "vmi: registering clock source khz=%lld\n", cycles_per_msec);
+	return clocksource_register(&clocksource_vmi);
+
+}
+module_init(init_vmi_clocksource);
diff -puN arch/i386/kernel/vmitime.c~vmi-timer-update /dev/null
--- a/arch/i386/kernel/vmitime.c
+++ /dev/null
@@ -1,482 +0,0 @@
-/*
- * VMI paravirtual timer support routines.
- *
- * Copyright (C) 2005, VMware, Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- * NON INFRINGEMENT.  See the GNU General Public License for more
- * details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
- * Send feedback to dhecht@vmware.com
- *
- */
-
-/*
- * Portions of this code from arch/i386/kernel/timers/timer_tsc.c.
- * Portions of the CONFIG_NO_IDLE_HZ code from arch/s390/kernel/time.c.
- * See comments there for proper credits.
- */
-
-#include <linux/spinlock.h>
-#include <linux/init.h>
-#include <linux/errno.h>
-#include <linux/jiffies.h>
-#include <linux/interrupt.h>
-#include <linux/kernel_stat.h>
-#include <linux/rcupdate.h>
-#include <linux/clocksource.h>
-
-#include <asm/timer.h>
-#include <asm/io.h>
-#include <asm/apic.h>
-#include <asm/div64.h>
-#include <asm/timer.h>
-#include <asm/desc.h>
-
-#include <asm/vmi.h>
-#include <asm/vmi_time.h>
-
-#include <mach_timer.h>
-#include <io_ports.h>
-
-#ifdef CONFIG_X86_LOCAL_APIC
-#define VMI_ALARM_WIRING VMI_ALARM_WIRED_LVTT
-#else
-#define VMI_ALARM_WIRING VMI_ALARM_WIRED_IRQ0
-#endif
-
-/* Cached VMI operations */
-struct vmi_timer_ops vmi_timer_ops;
-
-#ifdef CONFIG_NO_IDLE_HZ
-
-/* /proc/sys/kernel/hz_timer state. */
-int sysctl_hz_timer;
-
-/* Some stats */
-static DEFINE_PER_CPU(unsigned long, vmi_idle_no_hz_irqs);
-static DEFINE_PER_CPU(unsigned long, vmi_idle_no_hz_jiffies);
-static DEFINE_PER_CPU(unsigned long, idle_start_jiffies);
-
-#endif /* CONFIG_NO_IDLE_HZ */
-
-/* Number of alarms per second. By default this is CONFIG_VMI_ALARM_HZ. */
-static int alarm_hz = CONFIG_VMI_ALARM_HZ;
-
-/* Cache of the value get_cycle_frequency / HZ. */
-static signed long long cycles_per_jiffy;
-
-/* Cache of the value get_cycle_frequency / alarm_hz. */
-static signed long long cycles_per_alarm;
-
-/* The number of cycles accounted for by the 'jiffies'/'xtime' count.
- * Protected by xtime_lock. */
-static unsigned long long real_cycles_accounted_system;
-
-/* The number of cycles accounted for by update_process_times(), per cpu. */
-static DEFINE_PER_CPU(unsigned long long, process_times_cycles_accounted_cpu);
-
-/* The number of stolen cycles accounted, per cpu. */
-static DEFINE_PER_CPU(unsigned long long, stolen_cycles_accounted_cpu);
-
-/* Clock source. */
-static cycle_t read_real_cycles(void)
-{
-	return vmi_timer_ops.get_cycle_counter(VMI_CYCLES_REAL);
-}
-
-static cycle_t read_available_cycles(void)
-{
-	return vmi_timer_ops.get_cycle_counter(VMI_CYCLES_AVAILABLE);
-}
-
-#if 0
-static cycle_t read_stolen_cycles(void)
-{
-	return vmi_timer_ops.get_cycle_counter(VMI_CYCLES_STOLEN);
-}
-#endif  /*  0  */
-
-static struct clocksource clocksource_vmi = {
-	.name			= "vmi-timer",
-	.rating			= 450,
-	.read			= read_real_cycles,
-	.mask			= CLOCKSOURCE_MASK(64),
-	.mult			= 0, /* to be set */
-	.shift			= 22,
-	.flags			= CLOCK_SOURCE_IS_CONTINUOUS,
-};
-
-
-/* Timer interrupt handler. */
-static irqreturn_t vmi_timer_interrupt(int irq, void *dev_id);
-
-static struct irqaction vmi_timer_irq  = {
-	.handler = vmi_timer_interrupt,
-	.flags = IRQF_DISABLED,
-	.mask = CPU_MASK_NONE,
-	.name = "VMI-alarm",
-};
-
-/* Alarm rate */
-static int __init vmi_timer_alarm_rate_setup(char* str)
-{
-	int alarm_rate;
-	if (get_option(&str, &alarm_rate) == 1 && alarm_rate > 0) {
-		alarm_hz = alarm_rate;
-		printk(KERN_WARNING "VMI timer alarm HZ set to %d\n", alarm_hz);
-	}
-	return 1;
-}
-__setup("vmi_timer_alarm_hz=", vmi_timer_alarm_rate_setup);
-
-
-/* Initialization */
-static void vmi_get_wallclock_ts(struct timespec *ts)
-{
-	unsigned long long wallclock;
-	wallclock = vmi_timer_ops.get_wallclock(); // nsec units
-	ts->tv_nsec = do_div(wallclock, 1000000000);
-	ts->tv_sec = wallclock;
-}
-
-unsigned long vmi_get_wallclock(void)
-{
-	struct timespec ts;
-	vmi_get_wallclock_ts(&ts);
-	return ts.tv_sec;
-}
-
-int vmi_set_wallclock(unsigned long now)
-{
-	return -1;
-}
-
-unsigned long long vmi_get_sched_cycles(void)
-{
-	return read_available_cycles();
-}
-
-unsigned long vmi_cpu_khz(void)
-{
-	unsigned long long khz;
-
-	khz = vmi_timer_ops.get_cycle_frequency();
-	(void)do_div(khz, 1000);
-	return khz;
-}
-
-void __init vmi_time_init(void)
-{
-	unsigned long long cycles_per_sec, cycles_per_msec;
-	unsigned long flags;
-
-	local_irq_save(flags);
-	setup_irq(0, &vmi_timer_irq);
-#ifdef CONFIG_X86_LOCAL_APIC
-	set_intr_gate(LOCAL_TIMER_VECTOR, apic_vmi_timer_interrupt);
-#endif
-
-	real_cycles_accounted_system = read_real_cycles();
-	per_cpu(process_times_cycles_accounted_cpu, 0) = read_available_cycles();
-
-	cycles_per_sec = vmi_timer_ops.get_cycle_frequency();
-	cycles_per_jiffy = cycles_per_sec;
-	(void)do_div(cycles_per_jiffy, HZ);
-	cycles_per_alarm = cycles_per_sec;
-	(void)do_div(cycles_per_alarm, alarm_hz);
-	cycles_per_msec = cycles_per_sec;
-	(void)do_div(cycles_per_msec, 1000);
-
-	printk(KERN_WARNING "VMI timer cycles/sec = %llu ; cycles/jiffy = %llu ;"
-	       "cycles/alarm = %llu\n", cycles_per_sec, cycles_per_jiffy,
-	       cycles_per_alarm);
-
-	clocksource_vmi.mult = clocksource_khz2mult(cycles_per_msec,
-						    clocksource_vmi.shift);
-	if (clocksource_register(&clocksource_vmi))
-		printk(KERN_WARNING "Error registering VMITIME clocksource.");
-
-	/* Disable PIT. */
-	outb_p(0x3a, PIT_MODE); /* binary, mode 5, LSB/MSB, ch 0 */
-
-	/* schedule the alarm. do this in phase with process_times_cycles_accounted_cpu
-	 * reduce the latency calling update_process_times. */
-	vmi_timer_ops.set_alarm(
-		      VMI_ALARM_WIRED_IRQ0 | VMI_ALARM_IS_PERIODIC | VMI_CYCLES_AVAILABLE,
-		      per_cpu(process_times_cycles_accounted_cpu, 0) + cycles_per_alarm,
-		      cycles_per_alarm);
-
-	local_irq_restore(flags);
-}
-
-#ifdef CONFIG_X86_LOCAL_APIC
-
-void __init vmi_timer_setup_boot_alarm(void)
-{
-	local_irq_disable();
-
-	/* Route the interrupt to the correct vector. */
-	apic_write_around(APIC_LVTT, LOCAL_TIMER_VECTOR);
-
-	/* Cancel the IRQ0 wired alarm, and setup the LVTT alarm. */
-	vmi_timer_ops.cancel_alarm(VMI_CYCLES_AVAILABLE);
-	vmi_timer_ops.set_alarm(
-		      VMI_ALARM_WIRED_LVTT | VMI_ALARM_IS_PERIODIC | VMI_CYCLES_AVAILABLE,
-		      per_cpu(process_times_cycles_accounted_cpu, 0) + cycles_per_alarm,
-		      cycles_per_alarm);
-	local_irq_enable();
-}
-
-/* Initialize the time accounting variables for an AP on an SMP system.
- * Also, set the local alarm for the AP. */
-void __devinit vmi_timer_setup_secondary_alarm(void)
-{
-	int cpu = smp_processor_id();
-
-	/* Route the interrupt to the correct vector. */
-	apic_write_around(APIC_LVTT, LOCAL_TIMER_VECTOR);
-
-	per_cpu(process_times_cycles_accounted_cpu, cpu) = read_available_cycles();
-
-	vmi_timer_ops.set_alarm(
-		      VMI_ALARM_WIRED_LVTT | VMI_ALARM_IS_PERIODIC | VMI_CYCLES_AVAILABLE,
-		      per_cpu(process_times_cycles_accounted_cpu, cpu) + cycles_per_alarm,
-		      cycles_per_alarm);
-}
-
-#endif
-
-/* Update system wide (real) time accounting (e.g. jiffies, xtime). */
-static void vmi_account_real_cycles(unsigned long long cur_real_cycles)
-{
-	long long cycles_not_accounted;
-
-	write_seqlock(&xtime_lock);
-
-	cycles_not_accounted = cur_real_cycles - real_cycles_accounted_system;
-	while (cycles_not_accounted >= cycles_per_jiffy) {
-		/* systems wide jiffies. */
-		do_timer(1);
-
-		cycles_not_accounted -= cycles_per_jiffy;
-		real_cycles_accounted_system += cycles_per_jiffy;
-	}
-
-	write_sequnlock(&xtime_lock);
-}
-
-/* Update per-cpu process times. */
-static void vmi_account_process_times_cycles(struct pt_regs *regs, int cpu,
-					     unsigned long long cur_process_times_cycles)
-{
-	long long cycles_not_accounted;
-	cycles_not_accounted = cur_process_times_cycles -
-		per_cpu(process_times_cycles_accounted_cpu, cpu);
-
-	while (cycles_not_accounted >= cycles_per_jiffy) {
-		/* Account time to the current process.  This includes
-		 * calling into the scheduler to decrement the timeslice
-		 * and possibly reschedule.*/
-		update_process_times(user_mode(regs));
-		/* XXX handle /proc/profile multiplier.  */
-		profile_tick(CPU_PROFILING);
-
-		cycles_not_accounted -= cycles_per_jiffy;
-		per_cpu(process_times_cycles_accounted_cpu, cpu) += cycles_per_jiffy;
-	}
-}
-
-#ifdef CONFIG_NO_IDLE_HZ
-/* Update per-cpu idle times.  Used when a no-hz halt is ended. */
-static void vmi_account_no_hz_idle_cycles(int cpu,
-					  unsigned long long cur_process_times_cycles)
-{
-	long long cycles_not_accounted;
-	unsigned long no_idle_hz_jiffies = 0;
-
-	cycles_not_accounted = cur_process_times_cycles -
-		per_cpu(process_times_cycles_accounted_cpu, cpu);
-
-	while (cycles_not_accounted >= cycles_per_jiffy) {
-		no_idle_hz_jiffies++;
-		cycles_not_accounted -= cycles_per_jiffy;
-		per_cpu(process_times_cycles_accounted_cpu, cpu) += cycles_per_jiffy;
-	}
-	/* Account time to the idle process. */
-	account_steal_time(idle_task(cpu), jiffies_to_cputime(no_idle_hz_jiffies));
-}
-#endif
-
-/* Update per-cpu stolen time. */
-static void vmi_account_stolen_cycles(int cpu,
-				      unsigned long long cur_real_cycles,
-				      unsigned long long cur_avail_cycles)
-{
-	long long stolen_cycles_not_accounted;
-	unsigned long stolen_jiffies = 0;
-
-	if (cur_real_cycles < cur_avail_cycles)
-		return;
-
-	stolen_cycles_not_accounted = cur_real_cycles - cur_avail_cycles -
-		per_cpu(stolen_cycles_accounted_cpu, cpu);
-
-	while (stolen_cycles_not_accounted >= cycles_per_jiffy) {
-		stolen_jiffies++;
-		stolen_cycles_not_accounted -= cycles_per_jiffy;
-		per_cpu(stolen_cycles_accounted_cpu, cpu) += cycles_per_jiffy;
-	}
-	/* HACK: pass NULL to force time onto cpustat->steal. */
-	account_steal_time(NULL, jiffies_to_cputime(stolen_jiffies));
-}
-
-/* Body of either IRQ0 interrupt handler (UP no local-APIC) or
- * local-APIC LVTT interrupt handler (UP & local-APIC or SMP). */
-static void vmi_local_timer_interrupt(int cpu)
-{
-	unsigned long long cur_real_cycles, cur_process_times_cycles;
-
-	cur_real_cycles = read_real_cycles();
-	cur_process_times_cycles = read_available_cycles();
-	/* Update system wide (real) time state (xtime, jiffies). */
-	vmi_account_real_cycles(cur_real_cycles);
-	/* Update per-cpu process times. */
-	vmi_account_process_times_cycles(get_irq_regs(), cpu, cur_process_times_cycles);
-        /* Update time stolen from this cpu by the hypervisor. */
-	vmi_account_stolen_cycles(cpu, cur_real_cycles, cur_process_times_cycles);
-}
-
-#ifdef CONFIG_NO_IDLE_HZ
-
-/* Must be called only from idle loop, with interrupts disabled. */
-int vmi_stop_hz_timer(void)
-{
-	/* Note that cpu_set, cpu_clear are (SMP safe) atomic on x86. */
-
-	unsigned long seq, next;
-	unsigned long long real_cycles_expiry;
-	int cpu = smp_processor_id();
-
-	BUG_ON(!irqs_disabled());
-	if (sysctl_hz_timer != 0)
-		return 0;
-
-	cpu_set(cpu, nohz_cpu_mask);
-	smp_mb();
-
-	if (rcu_needs_cpu(cpu) || local_softirq_pending() ||
-	    (next = next_timer_interrupt(),
-	     time_before_eq(next, jiffies + HZ/CONFIG_VMI_ALARM_HZ))) {
-		cpu_clear(cpu, nohz_cpu_mask);
-		return 0;
-	}
-
-	/* Convert jiffies to the real cycle counter. */
-	do {
-		seq = read_seqbegin(&xtime_lock);
-		real_cycles_expiry = real_cycles_accounted_system +
-			(long)(next - jiffies) * cycles_per_jiffy;
-	} while (read_seqretry(&xtime_lock, seq));
-
-	/* This cpu is going idle. Disable the periodic alarm. */
-	vmi_timer_ops.cancel_alarm(VMI_CYCLES_AVAILABLE);
-	per_cpu(idle_start_jiffies, cpu) = jiffies;
-	/* Set the real time alarm to expire at the next event. */
-	vmi_timer_ops.set_alarm(
-		VMI_ALARM_WIRING | VMI_ALARM_IS_ONESHOT | VMI_CYCLES_REAL,
-		real_cycles_expiry, 0);
-	return 1;
-}
-
-static void vmi_reenable_hz_timer(int cpu)
-{
-	/* For /proc/vmi/info idle_hz stat. */
-	per_cpu(vmi_idle_no_hz_jiffies, cpu) += jiffies - per_cpu(idle_start_jiffies, cpu);
-	per_cpu(vmi_idle_no_hz_irqs, cpu)++;
-
-	/* Don't bother explicitly cancelling the one-shot alarm -- at
-	 * worse we will receive a spurious timer interrupt. */
-	vmi_timer_ops.set_alarm(
-		      VMI_ALARM_WIRING | VMI_ALARM_IS_PERIODIC | VMI_CYCLES_AVAILABLE,
-		      per_cpu(process_times_cycles_accounted_cpu, cpu) + cycles_per_alarm,
-		      cycles_per_alarm);
-	/* Indicate this cpu is no longer nohz idle. */
-	cpu_clear(cpu, nohz_cpu_mask);
-}
-
-/* Called from interrupt handlers when (local) HZ timer is disabled. */
-void vmi_account_time_restart_hz_timer(void)
-{
-	unsigned long long cur_real_cycles, cur_process_times_cycles;
-	int cpu = smp_processor_id();
-
-	BUG_ON(!irqs_disabled());
-	/* Account the time during which the HZ timer was disabled. */
-	cur_real_cycles = read_real_cycles();
-	cur_process_times_cycles = read_available_cycles();
-	/* Update system wide (real) time state (xtime, jiffies). */
-	vmi_account_real_cycles(cur_real_cycles);
-	/* Update per-cpu idle times. */
-	vmi_account_no_hz_idle_cycles(cpu, cur_process_times_cycles);
-        /* Update time stolen from this cpu by the hypervisor. */
-	vmi_account_stolen_cycles(cpu, cur_real_cycles, cur_process_times_cycles);
-	/* Reenable the hz timer. */
-	vmi_reenable_hz_timer(cpu);
-}
-
-#endif /* CONFIG_NO_IDLE_HZ */
-
-/* UP (and no local-APIC) VMI-timer alarm interrupt handler.
- * Handler for IRQ0. Not used when SMP or X86_LOCAL_APIC after
- * APIC setup and setup_boot_vmi_alarm() is called.  */
-static irqreturn_t vmi_timer_interrupt(int irq, void *dev_id)
-{
-	vmi_local_timer_interrupt(smp_processor_id());
-	return IRQ_HANDLED;
-}
-
-#ifdef CONFIG_X86_LOCAL_APIC
-
-/* SMP VMI-timer alarm interrupt handler. Handler for LVTT vector.
- * Also used in UP when CONFIG_X86_LOCAL_APIC.
- * The wrapper code is from arch/i386/kernel/apic.c#smp_apic_timer_interrupt. */
-void smp_apic_vmi_timer_interrupt(struct pt_regs *regs)
-{
-	struct pt_regs *old_regs = set_irq_regs(regs);
-	int cpu = smp_processor_id();
-
-	/*
-	 * the NMI deadlock-detector uses this.
-	 */
-        per_cpu(irq_stat,cpu).apic_timer_irqs++;
-
-	/*
-	 * NOTE! We'd better ACK the irq immediately,
-	 * because timer handling can be slow.
-	 */
-	ack_APIC_irq();
-
-	/*
-	 * update_process_times() expects us to have done irq_enter().
-	 * Besides, if we don't timer interrupts ignore the global
-	 * interrupt lock, which is the WrongThing (tm) to do.
-	 */
-	irq_enter();
-	vmi_local_timer_interrupt(cpu);
-	irq_exit();
-	set_irq_regs(old_regs);
-}
-
-#endif  /* CONFIG_X86_LOCAL_APIC */
diff -puN include/asm-i386/vmi_time.h~vmi-timer-update include/asm-i386/vmi_time.h
--- a/include/asm-i386/vmi_time.h~vmi-timer-update
+++ a/include/asm-i386/vmi_time.h
@@ -53,22 +53,8 @@ extern unsigned long long vmi_get_sched_
 extern unsigned long vmi_cpu_khz(void);
 
 #ifdef CONFIG_X86_LOCAL_APIC
-extern void __init vmi_timer_setup_boot_alarm(void);
-extern void __devinit vmi_timer_setup_secondary_alarm(void);
-extern void apic_vmi_timer_interrupt(void);
-#endif
-
-#ifdef CONFIG_NO_IDLE_HZ
-extern int vmi_stop_hz_timer(void);
-extern void vmi_account_time_restart_hz_timer(void);
-#else
-static inline int vmi_stop_hz_timer(void)
-{
-	return 0;
-}
-static inline void vmi_account_time_restart_hz_timer(void)
-{
-}
+extern void __devinit vmi_time_bsp_init(void);
+extern void __devinit vmi_time_ap_init(void);
 #endif
 
 /*
_

Patches currently in -mm which might be from zach@vmware.com are

fix-buslogic-to-stop-using-check_region.patch
i386-pte-clear-optimization.patch
i386-pte-xchg-optimization.patch
i386-pte-simplify-ops.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
ignore-stolen-time-in-the-softlockup-watchdog-fix.patch
