From: akpm@osdl.org
Subject: - debugging-feature-proc-timer_list.patch removed from -mm tree
Date: Wed, 24 Jan 2007 22:13:01 -0800
Message-ID: <200701250613.l0P6D1WI007870@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49224 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965516AbXAYGNP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:13:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     debugging feature: /proc/timer_list
has been removed from the -mm tree.  Its filename was
     debugging-feature-proc-timer_list.patch

This patch was dropped because an updated version will be merged

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

kvm-add-vm-exit-profiling-fix.patch
revert-nmi_known_cpu-check-during-boot-option-parsing.patch
paravirt-mark-the-paravirt_ops-export-internal.patch
kvm-make-sure-there-is-a-vcpu-context-loaded-when.patch
kvm-fix-race-between-mmio-reads-and-injected-interrupts.patch
kvm-x86-emulator-fix-bit-string-instructions.patch
kvm-fix-bogus-pagefault-on-writable-pages.patch
fix-config_compat_vdso.patch
fix-gate_vmavm_flags.patch
add-vm_alwaysdump.patch
i386-vdso-use-vm_alwaysdump.patch
i386-vdso-use-vm_alwaysdump-tidy.patch
x86_64-ia32-vdso-use-vm_alwaysdump.patch
powerpc-vdso-use-vm_alwaysdump.patch
x86_64-ia32-vdso-define-arch_vma_name.patch
acpi-fix-cpufreq-regression.patch
add-install_special_mapping.patch
i386-vdso-use-install_special_mapping.patch
x86_64-ia32-vdso-use-install_special_mapping.patch
powerpc-vdso-use-install_special_mapping.patch
use-correct-macros-in-raid-code-not-raw-asm.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch
fix-for-crash-in-adummy_init.patch
fix-x86_64-mm-convert-i386-pda-code-to-use-%fs.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch
spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation-fix.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation-fix-fix.patch
i386-kwatch-kernel-watchpoints-using-cpu-debug-registers.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
lockdep-also-check-for-freed-locks-in-kmem_cache_free.patch
lockdep-more-unlock-on-error-fixes.patch
lockdep-more-unlock-on-error-fixes-fix.patch
lockdep-add-graph-depth-information-to-proc-lockdep.patch
consolidate-default-sched_clock.patch
use-cycle_t-instead-of-u64-in-struct-time_interpolator.patch
proc-remove-useless-and-buggy-nlink-settings.patch
simplify-the-stacktrace-code.patch
audit-fix-audit_filter_user_rules-initialization-bug.patch
remove-references-to-obsolete-kernel-config-option-debug_rwsems.patch
debugging-feature-proc-timer_list.patch
debugging-feature-proc-timer_list-warning-fix.patch
debugging-feature-sysrq-q-to-print-timers.patch
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
schedule_on_each_cpu-use-preempt_disable.patch
fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine.patch
fsaio-rename-__lock_page-to-lock_page_blocking.patch
fsaio-interfaces-to-initialize-and-to-test-a-wait-bit-key.patch
fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch
fsaio-enable-asynchronous-wait-page-and-lock-page.patch
fsaio-filesystem-aio-read.patch
fsaio-aio-o_sync-filesystem-write.patch
aio-is-unlikely.patch
make-good_sigevent-non-static.patch
aio-completion-signal-notification.patch
sched-avoid-div-in-rebalance_tick.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2.patch
scheduled-removal-of-sa_xxx-interrupt-flags.patch
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
