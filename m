Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2012922EE3
	for <mm-commits@vger.kernel.org>; Wed, 14 Feb 2024 15:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707925444; cv=none; b=UKqzADrs/RJEpAY6heho35iT27i9/rwbgYjnNFbpzxcXMI7e+Uf/BHwlix9byKQwxublwBe1nx7YSKUBN9CfQPU9Ib0q77ZnhDBVMZp88snNK37JZ1okJQJqp9N7l5No8/Egdqk+lViTGzUXqZFO+MUOMeFRc+60DQ6UWP8shcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707925444; c=relaxed/simple;
	bh=BDcn/QNcQJDPuj//vcO2TscyiXZdORk9koLxNzmHiIg=;
	h=Date:To:From:Subject:Message-Id; b=n/gebXX90COy4BcdgysQa7+TCFasQu/OZfQfN6tIU92qrcdrqIss+iKrABqFbz+ISxdEM4uZac7ee0/axBApcomR/BMYFtsC2vv7JgzPAyMZ8jGHTAH1HjM+qqP/JmHQPbbDv+hkP4JyP502rCLwnGl0pshXOLrsdEHOjokiHQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kegSmIo/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kegSmIo/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB3CC433C7;
	Wed, 14 Feb 2024 15:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707925443;
	bh=BDcn/QNcQJDPuj//vcO2TscyiXZdORk9koLxNzmHiIg=;
	h=Date:To:From:Subject:From;
	b=kegSmIo/eSGIrzBkyjxVg2VuLOaYJGQRHYowXHgc2jIJtKz6RT3ARAvyKHtq9wC5v
	 p1FDV5g6bYVBCE4/4KVCOjl8JGOlgQ45KnI+q1i8QS7smaAii50bEErA+PbVijDIdB
	 BjwDjJ9n/33aLg2OjAUx+bTqpvDMlfwmJQq7+u1o=
Date: Wed, 14 Feb 2024 07:44:02 -0800
To: mm-commits@vger.kernel.org,pmladek@suse.com,liusong@linux.alibaba.com,kernelfans@gmail.com,dianders@chromium.org,yaoma@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + watchdog-softlockup-low-overhead-detection-of-interrupt.patch added to mm-nonmm-unstable branch
Message-Id: <20240214154403.7AB3CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: watchdog/softlockup: low-overhead detection of interrupt
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     watchdog-softlockup-low-overhead-detection-of-interrupt.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/watchdog-softlockup-low-overhead-detection-of-interrupt.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Bitao Hu <yaoma@linux.alibaba.com>
Subject: watchdog/softlockup: low-overhead detection of interrupt
Date: Wed, 14 Feb 2024 10:14:29 +0800

Patch series "*** Detect interrupt storm in softlockup ***", v7.

A low-overhead method for detecting interrupt storm in softlockup.


This patch (of 2):

The following softlockup is caused by interrupt storm, but it cannot be
identified from the call tree.  Because the call tree is just a snapshot
and doesn't fully capture the behavior of the CPU during the soft lockup.
  watchdog: BUG: soft lockup - CPU#28 stuck for 23s! [fio:83921]
  ...
  Call trace:
    __do_softirq+0xa0/0x37c
    __irq_exit_rcu+0x108/0x140
    irq_exit+0x14/0x20
    __handle_domain_irq+0x84/0xe0
    gic_handle_irq+0x80/0x108
    el0_irq_naked+0x50/0x58

Therefore，I think it is necessary to report CPU utilization during the
softlockup_thresh period (report once every sample_period, for a total of
5 reportings), like this:
  watchdog: BUG: soft lockup - CPU#28 stuck for 23s! [fio:83921]
  CPU#28 Utilization every 4s during lockup:
    #1: 0% system, 0% softirq, 100% hardirq, 0% idle
    #2: 0% system, 0% softirq, 100% hardirq, 0% idle
    #3: 0% system, 0% softirq, 100% hardirq, 0% idle
    #4: 0% system, 0% softirq, 100% hardirq, 0% idle
    #5: 0% system, 0% softirq, 100% hardirq, 0% idle
  ...

This would be helpful in determining whether an interrupt storm has
occurred or in identifying the cause of the softlockup.  The criteria for
determination are as follows:

  a. If the hardirq utilization is high, then interrupt storm should be
  considered and the root cause cannot be determined from the call tree.
  b. If the softirq utilization is high, then we could analyze the call
  tree but it may cannot reflect the root cause.
  c. If the system utilization is high, then we could analyze the root
  cause from the call tree.

The mechanism requires a considerable amount of global storage space when
configured for the maximum number of CPUs.  Therefore, adding a
SOFTLOCKUP_DETECTOR_INTR_STORM Kconfig knob that defaults to "yes" if the
max number of CPUs is <= 128.

Link: https://lkml.kernel.org/r/20240214021430.87471-1-yaoma@linux.alibaba.com
Link: https://lkml.kernel.org/r/20240214021430.87471-2-yaoma@linux.alibaba.com
Signed-off-by: Bitao Hu <yaoma@linux.alibaba.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Liu Song <liusong@linux.alibaba.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Pingfan Liu <kernelfans@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   98 +++++++++++++++++++++++++++++++++++++++++++-
 lib/Kconfig.debug |   13 +++++
 2 files changed, 110 insertions(+), 1 deletion(-)

--- a/kernel/watchdog.c~watchdog-softlockup-low-overhead-detection-of-interrupt
+++ a/kernel/watchdog.c
@@ -16,6 +16,8 @@
 #include <linux/cpu.h>
 #include <linux/nmi.h>
 #include <linux/init.h>
+#include <linux/kernel_stat.h>
+#include <linux/math64.h>
 #include <linux/module.h>
 #include <linux/sysctl.h>
 #include <linux/tick.h>
@@ -35,6 +37,8 @@ static DEFINE_MUTEX(watchdog_mutex);
 # define WATCHDOG_HARDLOCKUP_DEFAULT	0
 #endif
 
+#define NUM_SAMPLE_PERIODS	5
+
 unsigned long __read_mostly watchdog_enabled;
 int __read_mostly watchdog_user_enabled = 1;
 static int __read_mostly watchdog_hardlockup_user_enabled = WATCHDOG_HARDLOCKUP_DEFAULT;
@@ -333,6 +337,95 @@ __setup("watchdog_thresh=", watchdog_thr
 
 static void __lockup_detector_cleanup(void);
 
+#ifdef CONFIG_SOFTLOCKUP_DETECTOR_INTR_STORM
+enum stats_per_group {
+	STATS_SYSTEM,
+	STATS_SOFTIRQ,
+	STATS_HARDIRQ,
+	STATS_IDLE,
+	NUM_STATS_PER_GROUP,
+};
+
+static const enum cpu_usage_stat tracked_stats[NUM_STATS_PER_GROUP] = {
+	CPUTIME_SYSTEM,
+	CPUTIME_SOFTIRQ,
+	CPUTIME_IRQ,
+	CPUTIME_IDLE,
+};
+
+static DEFINE_PER_CPU(u16, cpustat_old[NUM_STATS_PER_GROUP]);
+static DEFINE_PER_CPU(u8, cpustat_util[NUM_SAMPLE_PERIODS][NUM_STATS_PER_GROUP]);
+static DEFINE_PER_CPU(u8, cpustat_tail);
+
+/*
+ * We don't need nanosecond resolution. A granularity of 16ms is
+ * sufficient for our precision, allowing us to use u16 to store
+ * cpustats, which will roll over roughly every ~1000 seconds.
+ * 2^24 ~= 16 * 10^6
+ */
+static u16 get_16bit_precision(u64 data_ns)
+{
+	return data_ns >> 24LL; /* 2^24ns ~= 16.8ms */
+}
+
+static void update_cpustat(void)
+{
+	int i;
+	u8 util;
+	u16 old_stat, new_stat;
+	struct kernel_cpustat kcpustat;
+	u64 *cpustat = kcpustat.cpustat;
+	u8 tail = __this_cpu_read(cpustat_tail);
+	u16 sample_period_16 = get_16bit_precision(sample_period);
+
+	kcpustat_cpu_fetch(&kcpustat, smp_processor_id());
+
+	for (i = 0; i < NUM_STATS_PER_GROUP; i++) {
+		old_stat = __this_cpu_read(cpustat_old[i]);
+		new_stat = get_16bit_precision(cpustat[tracked_stats[i]]);
+		util = DIV_ROUND_UP(100 * (new_stat - old_stat), sample_period_16);
+		__this_cpu_write(cpustat_util[tail][i], util);
+		__this_cpu_write(cpustat_old[i], new_stat);
+	}
+
+	__this_cpu_write(cpustat_tail, (tail + 1) % NUM_SAMPLE_PERIODS);
+}
+
+static void print_cpustat(void)
+{
+	int i, group;
+	u8 tail = __this_cpu_read(cpustat_tail);
+	u64 sample_period_second = sample_period;
+
+	do_div(sample_period_second, NSEC_PER_SEC);
+
+	/*
+	 * We do not want the "watchdog: " prefix on every line,
+	 * hence we use "printk" instead of "pr_crit".
+	 */
+	printk(KERN_CRIT "CPU#%d Utilization every %llus during lockup:\n",
+	       smp_processor_id(), sample_period_second);
+
+	for (i = 0; i < NUM_SAMPLE_PERIODS; i++) {
+		group = (tail + i) % NUM_SAMPLE_PERIODS;
+		printk(KERN_CRIT "\t#%d: %3u%% system,\t%3u%% softirq,\t"
+			"%3u%% hardirq,\t%3u%% idle\n", i + 1,
+			__this_cpu_read(cpustat_util[group][STATS_SYSTEM]),
+			__this_cpu_read(cpustat_util[group][STATS_SOFTIRQ]),
+			__this_cpu_read(cpustat_util[group][STATS_HARDIRQ]),
+			__this_cpu_read(cpustat_util[group][STATS_IDLE]));
+	}
+}
+
+static void report_cpu_status(void)
+{
+	print_cpustat();
+}
+#else
+static inline void update_cpustat(void) { }
+static inline void report_cpu_status(void) { }
+#endif
+
 /*
  * Hard-lockup warnings should be triggered after just a few seconds. Soft-
  * lockups can have false positives under extreme conditions. So we generally
@@ -364,7 +457,7 @@ static void set_sample_period(void)
 	 * and hard thresholds) to increment before the
 	 * hardlockup detector generates a warning
 	 */
-	sample_period = get_softlockup_thresh() * ((u64)NSEC_PER_SEC / 5);
+	sample_period = get_softlockup_thresh() * ((u64)NSEC_PER_SEC / NUM_SAMPLE_PERIODS);
 	watchdog_update_hrtimer_threshold(sample_period);
 }
 
@@ -504,6 +597,8 @@ static enum hrtimer_restart watchdog_tim
 	 */
 	period_ts = READ_ONCE(*this_cpu_ptr(&watchdog_report_ts));
 
+	update_cpustat();
+
 	/* Reset the interval when touched by known problematic code. */
 	if (period_ts == SOFTLOCKUP_DELAY_REPORT) {
 		if (unlikely(__this_cpu_read(softlockup_touch_sync))) {
@@ -539,6 +634,7 @@ static enum hrtimer_restart watchdog_tim
 		pr_emerg("BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
 			smp_processor_id(), duration,
 			current->comm, task_pid_nr(current));
+		report_cpu_status();
 		print_modules();
 		print_irqtrace_events(current);
 		if (regs)
--- a/lib/Kconfig.debug~watchdog-softlockup-low-overhead-detection-of-interrupt
+++ a/lib/Kconfig.debug
@@ -1029,6 +1029,19 @@ config SOFTLOCKUP_DETECTOR
 	  chance to run.  The current stack trace is displayed upon
 	  detection and the system will stay locked up.
 
+config SOFTLOCKUP_DETECTOR_INTR_STORM
+	bool "Detect Interrupt Storm in Soft Lockups"
+	depends on SOFTLOCKUP_DETECTOR && IRQ_TIME_ACCOUNTING
+	default y if NR_CPUS <= 128
+	help
+	  Say Y here to enable the kernel to detect interrupt storm
+	  during "soft lockups".
+
+	  "soft lockups" can be caused by a variety of reasons. If one is
+	  caused by an interrupt storm, then the storming interrupts will not
+	  be on the callstack. To detect this case, it is necessary to report
+	  the CPU stats and the interrupt counts during the "soft lockups".
+
 config BOOTPARAM_SOFTLOCKUP_PANIC
 	bool "Panic (Reboot) On Soft Lockups"
 	depends on SOFTLOCKUP_DETECTOR
_

Patches currently in -mm which might be from yaoma@linux.alibaba.com are

watchdog-softlockup-low-overhead-detection-of-interrupt.patch
watchdog-softlockup-report-the-most-frequent-interrupts.patch

