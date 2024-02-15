Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815F52CCA0
	for <mm-commits@vger.kernel.org>; Thu, 15 Feb 2024 19:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708026851; cv=none; b=E17Wk2aqVDMWVe4aEfTyYh/vJeWeDAhZTfr1JwhiG9MsUz87pOMufUDR4VmKHB76WbIXfjLpou/a8N2V0qFiu7SodEC7dB/R/6MLhzwhfxLzfCfVJTxfB4CqEk8CHUYx9RA9Mx2QXtA+FPbi3gSbbVUud8HREIQYJRusV2OIwh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708026851; c=relaxed/simple;
	bh=HdfRvYsCVofxib88vnyd2wRjG6StcOYj2nv8xYtLvmo=;
	h=Date:To:From:Subject:Message-Id; b=ODxWGiLI8wx3tmB2GrzpMmJq+7L5Ov9sm6G3yYsY3sLYPCognvBikc27OcEZ8/G3d41sdB2TdX8hoLg8kpTs/i2Xe6wJYcCg8JY3nvRrGnCGUZSHcm9su5+ZPUArVcQCW2dgCwkvmr3Q0HQ0eCss7WkTJoasiKOUEaQ7lAkk4rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hhZRk+rH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hhZRk+rH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2475FC433F1;
	Thu, 15 Feb 2024 19:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708026851;
	bh=HdfRvYsCVofxib88vnyd2wRjG6StcOYj2nv8xYtLvmo=;
	h=Date:To:From:Subject:From;
	b=hhZRk+rHdsUMR6ibJzO9fAeoRyi3efOHGX6kg7InUx19QGfxWUhc+UybTuXIR6nJo
	 R6qRo/IqtPk/5SoUx61lJB30eAvYmR+KJtJ1Xle8Txg2eomteeSvcgkyKomf6bFsYi
	 U+kQaTCNzY/niwo+ytuqYUUM01Smb0k6Lcx5OL8A=
Date: Thu, 15 Feb 2024 11:54:10 -0800
To: mm-commits@vger.kernel.org,pmladek@suse.com,liusong@linux.alibaba.com,kernelfans@gmail.com,dianders@chromium.org,yaoma@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] watchdog-softlockup-report-the-most-frequent-interrupts.patch removed from -mm tree
Message-Id: <20240215195411.2475FC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: watchdog/softlockup: report the most frequent interrupts
has been removed from the -mm tree.  Its filename was
     watchdog-softlockup-report-the-most-frequent-interrupts.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Bitao Hu <yaoma@linux.alibaba.com>
Subject: watchdog/softlockup: report the most frequent interrupts
Date: Wed, 14 Feb 2024 10:14:30 +0800

When the watchdog determines that the current soft lockup is due to an
interrupt storm based on CPU utilization, reporting the most frequent
interrupts could be good enough for further troubleshooting.

Below is an example of interrupt storm. The call tree does not
provide useful information, but we can analyze which interrupt
caused the soft lockup by comparing the counts of interrupts.

[ 2987.488075] watchdog: BUG: soft lockup - CPU#9 stuck for 23s! [kworker/9:1:214]
[ 2987.488607] CPU#9 Utilization every 4s during lockup:
[ 2987.488941]  #1:   0% system,          0% softirq,   100% hardirq,     0% idle
[ 2987.489357]  #2:   0% system,          0% softirq,   100% hardirq,     0% idle
[ 2987.489771]  #3:   0% system,          0% softirq,   100% hardirq,     0% idle
[ 2987.490186]  #4:   0% system,          0% softirq,   100% hardirq,     0% idle
[ 2987.490601]  #5:   0% system,          0% softirq,   100% hardirq,     0% idle
[ 2987.491034] CPU#9 Detect HardIRQ Time exceeds 50%. Most frequent HardIRQs:
[ 2987.491493]  #1: 330985      irq#7(IPI)
[ 2987.491743]  #2: 5000        irq#10(arch_timer)
[ 2987.492039]  #3: 9           irq#91(nvme0q2)
[ 2987.492318]  #4: 3           irq#118(virtio1-output.12)
...
[ 2987.492728] Call trace:
[ 2987.492729]  __do_softirq+0xa8/0x364

Link: https://lkml.kernel.org/r/20240214021430.87471-3-yaoma@linux.alibaba.com
Signed-off-by: Bitao Hu <yaoma@linux.alibaba.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Liu Song <liusong@linux.alibaba.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Pingfan Liu <kernelfans@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |  157 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 153 insertions(+), 4 deletions(-)

--- a/kernel/watchdog.c~watchdog-softlockup-report-the-most-frequent-interrupts
+++ a/kernel/watchdog.c
@@ -12,22 +12,25 @@
 
 #define pr_fmt(fmt) "watchdog: " fmt
 
-#include <linux/mm.h>
 #include <linux/cpu.h>
-#include <linux/nmi.h>
 #include <linux/init.h>
+#include <linux/irq.h>
+#include <linux/irqdesc.h>
 #include <linux/kernel_stat.h>
+#include <linux/kvm_para.h>
 #include <linux/math64.h>
+#include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/nmi.h>
+#include <linux/stop_machine.h>
 #include <linux/sysctl.h>
 #include <linux/tick.h>
+
 #include <linux/sched/clock.h>
 #include <linux/sched/debug.h>
 #include <linux/sched/isolation.h>
-#include <linux/stop_machine.h>
 
 #include <asm/irq_regs.h>
-#include <linux/kvm_para.h>
 
 static DEFINE_MUTEX(watchdog_mutex);
 
@@ -417,13 +420,146 @@ static void print_cpustat(void)
 	}
 }
 
+#define HARDIRQ_PERCENT_THRESH		50
+#define NUM_HARDIRQ_REPORT		5
+static DEFINE_PER_CPU(u32 *, hardirq_counts);
+static DEFINE_PER_CPU(int, actual_nr_irqs);
+struct irq_counts {
+	int irq;
+	u32 counts;
+};
+
+/* Tabulate the most frequent interrupts. */
+static void tabulate_irq_count(struct irq_counts *irq_counts, int irq, u32 counts, int rank)
+{
+	int i;
+	struct irq_counts new_count = {irq, counts};
+
+	for (i = 0; i < rank; i++) {
+		if (counts > irq_counts[i].counts)
+			swap(new_count, irq_counts[i]);
+	}
+}
+
+/*
+ * If the hardirq time exceeds HARDIRQ_PERCENT_THRESH% of the sample_period,
+ * then the cause of softlockup might be interrupt storm. In this case, it
+ * would be useful to start interrupt counting.
+ */
+static bool need_counting_irqs(void)
+{
+	u8 util;
+	int tail = __this_cpu_read(cpustat_tail);
+
+	tail = (tail + NUM_HARDIRQ_REPORT - 1) % NUM_HARDIRQ_REPORT;
+	util = __this_cpu_read(cpustat_util[tail][STATS_HARDIRQ]);
+	return util > HARDIRQ_PERCENT_THRESH;
+}
+
+static void start_counting_irqs(void)
+{
+	int i;
+	int local_nr_irqs;
+	struct irq_desc *desc;
+	u32 *counts = __this_cpu_read(hardirq_counts);
+
+	if (!counts) {
+		/*
+		 * nr_irqs has the potential to grow at runtime. We should read
+		 * it and store locally to avoid array out-of-bounds access.
+		 */
+		local_nr_irqs = nr_irqs;
+		counts = kcalloc(local_nr_irqs, sizeof(u32), GFP_ATOMIC);
+		if (!counts)
+			return;
+
+		for (i = 0; i < local_nr_irqs; i++) {
+			desc = irq_to_desc(i);
+			if (!desc)
+				continue;
+			counts[i] = desc->kstat_irqs ?
+				*this_cpu_ptr(desc->kstat_irqs) : 0;
+		}
+
+		__this_cpu_write(actual_nr_irqs, local_nr_irqs);
+		__this_cpu_write(hardirq_counts, counts);
+	}
+}
+
+static void stop_counting_irqs(void)
+{
+	kfree(__this_cpu_read(hardirq_counts));
+	__this_cpu_write(hardirq_counts, NULL);
+}
+
+static void print_irq_counts(void)
+{
+	int i;
+	struct irq_desc *desc;
+	u32 counts_diff;
+	int local_nr_irqs = __this_cpu_read(actual_nr_irqs);
+	u32 *counts = __this_cpu_read(hardirq_counts);
+	struct irq_counts irq_counts_sorted[NUM_HARDIRQ_REPORT] = {
+		{-1, 0}, {-1, 0}, {-1, 0}, {-1, 0},
+	};
+
+	if (counts) {
+		for_each_irq_desc(i, desc) {
+			/*
+			 * We need to bounds-check in case someone on a different CPU
+			 * expanded nr_irqs.
+			 */
+			if (desc->kstat_irqs) {
+				counts_diff = *this_cpu_ptr(desc->kstat_irqs);
+				if (i < local_nr_irqs)
+					counts_diff -= counts[i];
+				tabulate_irq_count(irq_counts_sorted, i, counts_diff,
+						   NUM_HARDIRQ_REPORT);
+			}
+		}
+
+		/*
+		 * We do not want the "watchdog: " prefix on every line,
+		 * hence we use "printk" instead of "pr_crit".
+		 */
+		printk(KERN_CRIT "CPU#%d Detect HardIRQ Time exceeds %d%%. Most frequent HardIRQs:\n",
+		       smp_processor_id(), HARDIRQ_PERCENT_THRESH);
+
+		for (i = 0; i < NUM_HARDIRQ_REPORT; i++) {
+			if (irq_counts_sorted[i].irq == -1)
+				break;
+
+			desc = irq_to_desc(irq_counts_sorted[i].irq);
+			if (desc && desc->action)
+				printk(KERN_CRIT "\t#%u: %-10u\tirq#%d(%s)\n",
+				       i + 1, irq_counts_sorted[i].counts,
+				       irq_counts_sorted[i].irq, desc->action->name);
+			else
+				printk(KERN_CRIT "\t#%u: %-10u\tirq#%d\n",
+				       i + 1, irq_counts_sorted[i].counts,
+				       irq_counts_sorted[i].irq);
+		}
+
+		/*
+		 * If the hardirq time is less than HARDIRQ_PERCENT_THRESH% in the last
+		 * sample_period, then we suspect the interrupt storm might be subsiding.
+		 */
+		if (!need_counting_irqs())
+			stop_counting_irqs();
+	}
+}
+
 static void report_cpu_status(void)
 {
 	print_cpustat();
+	print_irq_counts();
 }
 #else
 static inline void update_cpustat(void) { }
 static inline void report_cpu_status(void) { }
+static inline bool need_counting_irqs(void) { return false; }
+static inline void start_counting_irqs(void) { }
+static inline void stop_counting_irqs(void) { }
 #endif
 
 /*
@@ -527,6 +663,18 @@ static int is_softlockup(unsigned long t
 			 unsigned long now)
 {
 	if ((watchdog_enabled & WATCHDOG_SOFTOCKUP_ENABLED) && watchdog_thresh) {
+		/*
+		 * If period_ts has not been updated during a sample_period, then
+		 * in the subsequent few sample_periods, period_ts might also not
+		 * be updated, which could indicate a potential softlockup. In
+		 * this case, if we suspect the cause of the potential softlockup
+		 * might be interrupt storm, then we need to count the interrupts
+		 * to find which interrupt is storming.
+		 */
+		if (time_after_eq(now, period_ts + get_softlockup_thresh() / 5) &&
+		    need_counting_irqs())
+			start_counting_irqs();
+
 		/* Warn about unreasonable delays. */
 		if (time_after(now, period_ts + get_softlockup_thresh()))
 			return now - touch_ts;
@@ -549,6 +697,7 @@ static DEFINE_PER_CPU(struct cpu_stop_wo
 static int softlockup_fn(void *data)
 {
 	update_touch_ts();
+	stop_counting_irqs();
 	complete(this_cpu_ptr(&softlockup_completion));
 
 	return 0;
_

Patches currently in -mm which might be from yaoma@linux.alibaba.com are


