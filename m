From: akpm@osdl.org
Subject: + debugging-feature-proc-timer_list.patch added to -mm tree
Date: Wed, 13 Dec 2006 14:44:42 -0800
Message-ID: <200612132244.kBDMigOE022921@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52454 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbWLMWou (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:44:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu


The patch titled
     debugging feature: /proc/timer_list
has been added to the -mm tree.  Its filename is
     debugging-feature-proc-timer_list.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: debugging feature: /proc/timer_list
From: Ingo Molnar <mingo@elte.hu>

add /proc/timer_list, which prints all currently pending (high-res) timers,
all clock-event sources and their parameters in a human-readable form.

Sample output:

Timer List Version: v0.1
HRTIMER_MAX_CLOCK_BASES: 2
now at 4246046273872 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1273998312645738432 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f5a90ec8>, hrtimer_sched_tick, hrtimer_stop_sched_tick, swapper/0
 # expires at 4246432689566 nsecs [in 386415694 nsecs]
 #1: <f5a90ec8>, hrtimer_wakeup, do_nanosleep, pcscd/2050
 # expires at 4247018194689 nsecs [in 971920817 nsecs]
 #2: <f5a90ec8>, hrtimer_wakeup, do_nanosleep, irqbalance/1909
 # expires at 4247351358392 nsecs [in 1305084520 nsecs]
 #3: <f5a90ec8>, hrtimer_wakeup, do_nanosleep, crond/2157
 # expires at 4249097614968 nsecs [in 3051341096 nsecs]
 #4: <f5a90ec8>, it_real_fn, do_setitimer, syslogd/1888
 # expires at 4251329900926 nsecs [in 5283627054 nsecs]
  .expires_next   : 4246432689566 nsecs
  .hres_active    : 1
  .check_clocks   : 0
  .nr_events      : 31306
  .idle_tick      : 4246020791890 nsecs
  .tick_stopped   : 1
  .idle_jiffies   : 986504
  .idle_calls     : 40700
  .idle_sleeps    : 36014
  .idle_entrytime : 4246019418883 nsecs
  .idle_sleeptime : 4178181972709 nsecs

cpu: 1
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1273998312645738432 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f5a90ec8>, hrtimer_sched_tick, hrtimer_restart_sched_tick, swapper/0
 # expires at 4246050084568 nsecs [in 3810696 nsecs]
 #1: <f5a90ec8>, hrtimer_wakeup, do_nanosleep, atd/2227
 # expires at 4261010635003 nsecs [in 14964361131 nsecs]
 #2: <f5a90ec8>, hrtimer_wakeup, do_nanosleep, smartd/2332
 # expires at 5469485798970 nsecs [in 1223439525098 nsecs]
  .expires_next   : 4246050084568 nsecs
  .hres_active    : 1
  .check_clocks   : 0
  .nr_events      : 24043
  .idle_tick      : 4246046084568 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 986510
  .idle_calls     : 26360
  .idle_sleeps    : 22551
  .idle_entrytime : 4246043874339 nsecs
  .idle_sleeptime : 4170763761184 nsecs

tick_broadcast_mask: 00000003
event_broadcast_mask: 00000001

CPU#0's local event device:

Clock Event Device: lapic
 capabilities:   0000000e
 max_delta_ns:   807385544
 min_delta_ns:   1443
 mult:           44624025
 shift:          32
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt
  .installed:  1
  .expires:    4246432689566 nsecs

CPU#1's local event device:

Clock Event Device: lapic
 capabilities:   0000000e
 max_delta_ns:   807385544
 min_delta_ns:   1443
 mult:           44624025
 shift:          32
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt
  .installed:  1
  .expires:    4246050084568 nsecs

Clock Event Device: hpet
 capabilities:   00000007
 max_delta_ns:   2147483647
 min_delta_ns:   3352
 mult:           61496110
 shift:          32
 set_next_event: hpet_next_event
 set_mode:       hpet_set_mode
 event_handler:  handle_nextevt_broadcast

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/time/Makefile     |    2 
 kernel/time/timer_list.c |  260 +++++++++++++++++++++++++++++++++++++
 2 files changed, 261 insertions(+), 1 deletion(-)

diff -puN kernel/time/Makefile~debugging-feature-proc-timer_list kernel/time/Makefile
--- a/kernel/time/Makefile~debugging-feature-proc-timer_list
+++ a/kernel/time/Makefile
@@ -1,4 +1,4 @@
-obj-y += ntp.o clocksource.o jiffies.o
+obj-y += ntp.o clocksource.o jiffies.o timer_list.o
 
 obj-$(CONFIG_GENERIC_CLOCKEVENTS)	+= clockevents.o
 obj-$(CONFIG_TIMER_STATS)		+= timer_stats.o
diff -puN /dev/null kernel/time/timer_list.c
--- /dev/null
+++ a/kernel/time/timer_list.c
@@ -0,0 +1,260 @@
+/*
+ * kernel/time/timer_list.c
+ *
+ * List pending timers
+ *
+ * Copyright(C) 2006, Red Hat, Inc., Ingo Molnar
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/proc_fs.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/sched.h>
+#include <linux/seq_file.h>
+#include <linux/kallsyms.h>
+#include <linux/clockchips.h>
+
+#include <asm/uaccess.h>
+
+typedef void (*print_fn_t)(struct seq_file *m, unsigned int *classes);
+
+DECLARE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases);
+
+/*
+ * This allows printing both to /proc/timer_list and
+ * to the console (on SysRq-Q):
+ */
+#define SEQ_printf(m, x...)			\
+ do {						\
+	if (m)					\
+		seq_printf(m, x);		\
+	else					\
+		printk(x);			\
+ } while (0)
+
+static void print_name_offset(struct seq_file *m, void *sym)
+{
+	unsigned long addr = (unsigned long)sym;
+	char namebuf[KSYM_NAME_LEN+1];
+	unsigned long size, offset;
+	const char *sym_name;
+	char *modname;
+
+	sym_name = kallsyms_lookup(addr, &size, &offset, &modname, namebuf);
+	if (sym_name)
+		SEQ_printf(m, "%s", sym_name);
+	else
+		SEQ_printf(m, "<%p>", sym);
+}
+
+static void
+print_timer(struct seq_file *m, struct hrtimer *timer, int idx, u64 now)
+{
+#ifdef CONFIG_TIMER_STATS
+	char tmp[TASK_COMM_LEN + 1];
+#endif
+	SEQ_printf(m, " #%d: ", idx);
+	print_name_offset(m, timer);
+	SEQ_printf(m, ", ");
+	print_name_offset(m, timer->function);
+#ifdef CONFIG_TIMER_STATS
+	SEQ_printf(m, ", ");
+	print_name_offset(m, timer->start_site);
+	memcpy(tmp, timer->start_comm, TASK_COMM_LEN);
+	tmp[TASK_COMM_LEN] = 0;
+	SEQ_printf(m, ", %s/%d", tmp, timer->start_pid);
+#endif
+	SEQ_printf(m, "\n");
+	SEQ_printf(m, " # expires at %Ld nsecs [in %Ld nsecs]\n",
+		ktime_to_ns(timer->expires),
+		ktime_to_ns(timer->expires) - now);
+}
+
+static void
+print_active_timers(struct seq_file *m, struct hrtimer_clock_base *base,
+		    u64 now)
+{
+	struct hrtimer *timer, tmp;
+	unsigned long next = 0, i;
+	struct rb_node *curr;
+	unsigned long flags;
+
+next_one:
+	i = 0;
+	spin_lock_irqsave(&base->cpu_base->lock, flags);
+
+	curr = base->first;
+	/*
+	 * Crude but we have to do this O(N*N) thing, because
+	 * we have to unlock the base when printing:
+	 */
+	while (curr && i < next) {
+		curr = rb_next(curr);
+		i++;
+	}
+
+	if (curr) {
+
+		timer = rb_entry(curr, struct hrtimer, node);
+		tmp = *timer;
+		spin_unlock_irqrestore(&base->cpu_base->lock, flags);
+
+		print_timer(m, &tmp, i, now);
+		next++;
+		goto next_one;
+	}
+	spin_unlock_irqrestore(&base->cpu_base->lock, flags);
+}
+
+static void
+print_base(struct seq_file *m, struct hrtimer_clock_base *base, u64 now)
+{
+	SEQ_printf(m, "  .index:      %d\n",
+			base->index);
+	SEQ_printf(m, "  .resolution: %Ld nsecs\n",
+			ktime_to_ns(base->resolution));
+	SEQ_printf(m,   "  .get_time:   ");
+	print_name_offset(m, base->get_time);
+	SEQ_printf(m,   "\n");
+#ifdef CONFIG_HIGH_RES_TIMERS
+	SEQ_printf(m, "  .offset:     %Ld nsecs\n",
+			ktime_to_ns(base->offset));
+#endif
+	SEQ_printf(m,   "active timers:\n");
+	print_active_timers(m, base, now);
+}
+
+static void print_cpu(struct seq_file *m, int cpu, u64 now)
+{
+	struct hrtimer_cpu_base *cpu_base = &per_cpu(hrtimer_bases, cpu);
+	int i;
+
+	SEQ_printf(m, "\ncpu: %d\n", cpu);
+	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
+		SEQ_printf(m, " clock %d:\n", i);
+		print_base(m, cpu_base->clock_base + i, now);
+	}
+#define P(x) \
+	SEQ_printf(m, "  .%-15s: %Ld\n", #x, (u64)(cpu_base->x))
+#define P_ns(x) \
+	SEQ_printf(m, "  .%-15s: %Ld nsecs\n", #x, \
+		(u64)(ktime_to_ns(cpu_base->x)))
+
+#ifdef CONFIG_HIGH_RES_TIMERS
+	P_ns(expires_next);
+	P(hres_active);
+	P(check_clocks);
+	P(nr_events);
+#endif
+#ifdef CONFIG_NO_HZ
+	P_ns(idle_tick);
+	P(tick_stopped);
+	P(idle_jiffies);
+	P(idle_calls);
+	P(idle_sleeps);
+	P_ns(idle_entrytime);
+	P_ns(idle_sleeptime);
+#endif
+#undef P
+}
+
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+static void
+print_eventdevice(struct seq_file *m, struct clock_event_device *dev)
+{
+	if (!dev) {
+		SEQ_printf(m, "\n<NULL>\n");
+		return;
+	}
+	SEQ_printf(m, "\nClock Event Device: %s\n", dev->name);
+	SEQ_printf(m, " capabilities:   %08x\n", dev->capabilities);
+	SEQ_printf(m, " max_delta_ns:   %ld\n", dev->max_delta_ns);
+	SEQ_printf(m, " min_delta_ns:   %ld\n", dev->min_delta_ns);
+	SEQ_printf(m, " mult:           %ld\n", dev->mult);
+	SEQ_printf(m, " shift:          %d\n", dev->shift);
+
+	SEQ_printf(m, " set_next_event: ");
+	print_name_offset(m, dev->set_next_event);
+	SEQ_printf(m, "\n");
+
+	SEQ_printf(m, " set_mode:       ");
+	print_name_offset(m, dev->set_mode);
+	SEQ_printf(m, "\n");
+
+	SEQ_printf(m, " event_handler:  ");
+	print_name_offset(m, dev->event_handler);
+	SEQ_printf(m, "\n");
+}
+#endif
+
+static int timer_list_show(struct seq_file *m, void *v)
+{
+	u64 now = ktime_to_ns(ktime_get());
+	int cpu;
+
+	SEQ_printf(m, "Timer List Version: v0.1\n");
+	SEQ_printf(m, "HRTIMER_MAX_CLOCK_BASES: %d\n", HRTIMER_MAX_CLOCK_BASES);
+	SEQ_printf(m, "now at %Ld nsecs\n", now);
+
+	for_each_online_cpu(cpu)
+		print_cpu(m, cpu, now);
+
+	SEQ_printf(m, "\n");
+#ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
+	SEQ_printf(m, "tick_broadcast_mask: %08lx\n",
+		tick_broadcast_mask.bits[0]);
+	SEQ_printf(m, "event_broadcast_mask: %08lx\n",
+		event_broadcast_mask.bits[0]);
+#endif
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+	for_each_online_cpu(cpu) {
+		struct local_events *levt = &per_cpu(local_eventdevices, cpu);
+		SEQ_printf(m, "\nCPU#%d's local event device:\n", cpu);
+		print_eventdevice(m, levt->nextevt);
+		SEQ_printf(m, "  .installed:  %d\n",
+			levt->installed);
+		SEQ_printf(m, "  .expires:    %Ld nsecs\n",
+			ktime_to_ns(levt->expires_next));
+	}
+	SEQ_printf(m, "\n");
+	print_eventdevice(m, global_eventdevice.event);
+	SEQ_printf(m, "\n");
+#endif
+
+	return 0;
+}
+
+void sysrq_timer_list_show(void)
+{
+	timer_list_show(NULL, NULL);
+}
+
+static int timer_list_open(struct inode *inode, struct file *filp)
+{
+	return single_open(filp, timer_list_show, NULL);
+}
+
+static struct file_operations timer_list_fops = {
+	.open		= timer_list_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+static int __init init_timer_list_procfs(void)
+{
+	struct proc_dir_entry *pe;
+
+	pe = create_proc_entry("timer_list", 0644, NULL);
+	if (!pe)
+		return -ENOMEM;
+
+	pe->proc_fops = &timer_list_fops;
+
+	return 0;
+}
+__initcall(init_timer_list_procfs);
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
debug-add-sysrq_always_enabled-boot-option.patch
lockdep-filter-off-by-default.patch
lockdep-improve-verbose-messages.patch
lockdep-improve-lockdep_reset.patch
lockdep-clean-up-very_verbose-define.patch
lockdep-use-chain-hash-on-config_debug_lockdep-too.patch
lockdep-print-irq-trace-info-on-asserts.patch
lockdep-fix-possible-races-while-disabling-lock-debugging.patch
optimize-calc_load.patch
acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
convert-i386-pda-code-to-use-%fs.patch
convert-i386-pda-code-to-use-%fs-fixes.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
gtod-uninline-jiffiesh.patch
gtod-fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
gtod-fix-timeout-overflow.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-uninline-irq_enter.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-include-fix.patch
acpi-keep-track-of-timer-broadcast.patch
acpi-add-state-propagation-for-dynamic-broadcasting.patch
acpi-cleanups-allow-early-access-to-pmtimer.patch
i386-apic-clean-up-the-apic-code.patch
clockevents-core.patch
clockevents-i386-drivers.patch
clockevents-i386-hpet-driver.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
high-res-timers-core.patch
high-res-timers-core-do-itimer-rearming-in-process-context.patch
high-res-timers-allow-tsc-clocksource-if-pmtimer-present.patch
dynticks-core.patch
dynticks-add-nohz-stats-to-proc-stat.patch
dynticks-i386-support-idle-handler-callbacks.patch
dynticks-i386-prepare-nmi-watchdog.patch
high-res-timers-dynticks-i386-support-enable-in-kconfig.patch
debugging-feature-add-proc-timer_stat.patch
debugging-feature-proc-timer_list.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch
detect-atomic-counter-underflows.patch
debug-shared-irqs.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
vdso-print-fatal-signals.patch
vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix-2.patch
kmap_atomic-debugging.patch

