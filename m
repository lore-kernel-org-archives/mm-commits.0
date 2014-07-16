From: akpm@linux-foundation.org
Subject: + vmstat-on-demand-vmstat-workers-v8.patch added to -mm tree
Date: Wed, 16 Jul 2014 15:00:00 -0700
Message-ID: <53c6f5e0./VLhPktaaEdNg5iv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:62857 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbaGPWAD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Jul 2014 18:00:03 -0400
Received: by mail-ie0-f202.google.com with SMTP id rl12so463982iec.3
        for <mm-commits@vger.kernel.org>; Wed, 16 Jul 2014 15:00:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@gentwo.org, cl@linux.com, fweisbec@gmail.com, gilad@benyossef.com, hakanakkan@gmail.com, hpa@zytor.com, hughd@google.com, johnstul@us.ibm.com, maxk@qualcomm.com, minchan.kim@gmail.com, mingo@kernel.org, paulmck@linux.vnet.ibm.com, peterz@infradead.org, tglx@linutronix.de, tj@kernel.org, vapier@gentoo.org, viresh.kumar@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: vmstat: On demand vmstat workers V8
has been added to the -mm tree.  Its filename is
     vmstat-on-demand-vmstat-workers-v8.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmstat-on-demand-vmstat-workers-v8.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmstat-on-demand-vmstat-workers-v8.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Lameter <cl@gentwo.org>
Subject: vmstat: On demand vmstat workers V8

vmstat workers are used for folding counter differentials into the zone,
per node and global counters at certain time intervals.  They currently
run at defined intervals on all processors which will cause some holdoff
for processors that need minimal intrusion by the OS.

The current vmstat_update mechanism depends on a deferrable timer firing
every other second by default which registers a work queue item that runs
on the local CPU, with the result that we have 1 interrupt and one
additional schedulable task on each CPU every 2 seconds If a workload
indeed causes VM activity or multiple tasks are running on a CPU, then
there are probably bigger issues to deal with.

However, some workloads dedicate a CPU for a single CPU bound task.  This
is done in high performance computing, in high frequency financial
applications, in networking (Intel DPDK, EZchip NPS) and with the advent
of systems with more and more CPUs over time, this may become more and
more common to do since when one has enough CPUs one cares less about
efficiently sharing a CPU with other tasks and more about efficiently
monopolizing a CPU per task.

The difference of having this timer firing and workqueue kernel thread
scheduled per second can be enormous.  An artificial test measuring the
worst case time to do a simple "i++" in an endless loop on a bare metal
system and under Linux on an isolated CPU with dynticks and with and
without this patch, have Linux match the bare metal performance (~700
cycles) with this patch and loose by couple of orders of magnitude (~200k
cycles) without it[*].  The loss occurs for something that just calculates
statistics.  For networking applications, for example, this could be the
difference between dropping packets or sustaining line rate.

Statistics are important and useful, but it would be great if there would
be a way to not cause statistics gathering produce a huge performance
difference.  This patche does just that.

This patch creates a vmstat shepherd worker that monitors the per cpu
differentials on all processors.  If there are differentials on a
processor then a vmstat worker local to the processors with the
differentials is created.  That worker will then start folding the diffs
in regular intervals.  Should the worker find that there is no work to be
done then it will make the shepherd worker monitor the differentials
again.

With this patch it is possible then to have periods longer than
2 seconds without any OS event on a "cpu" (hardware thread).

The patch shows a very minor increased in system performance.

hackbench -s 512 -l 2000 -g 15 -f 25 -P

Results before the patch:

Running in process mode with 15 groups using 50 file descriptors each (== 750 tasks)
Each sender will pass 2000 messages of 512 bytes
Time: 4.992
Running in process mode with 15 groups using 50 file descriptors each (== 750 tasks)
Each sender will pass 2000 messages of 512 bytes
Time: 4.971
Running in process mode with 15 groups using 50 file descriptors each (== 750 tasks)
Each sender will pass 2000 messages of 512 bytes
Time: 5.063

Hackbench after the patch:

Running in process mode with 15 groups using 50 file descriptors each (== 750 tasks)
Each sender will pass 2000 messages of 512 bytes
Time: 4.973
Running in process mode with 15 groups using 50 file descriptors each (== 750 tasks)
Each sender will pass 2000 messages of 512 bytes
Time: 4.990
Running in process mode with 15 groups using 50 file descriptors each (== 750 tasks)
Each sender will pass 2000 messages of 512 bytes
Time: 4.993

Signed-off-by: Christoph Lameter <cl@linux.com>
Reviewed-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |  140 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 118 insertions(+), 22 deletions(-)

diff -puN mm/vmstat.c~vmstat-on-demand-vmstat-workers-v8 mm/vmstat.c
--- a/mm/vmstat.c~vmstat-on-demand-vmstat-workers-v8
+++ a/mm/vmstat.c
@@ -7,6 +7,7 @@
  *  zoned VM statistics
  *  Copyright (C) 2006 Silicon Graphics, Inc.,
  *		Christoph Lameter <christoph@lameter.com>
+ *  Copyright (C) 2008-2014 Christoph Lameter
  */
 #include <linux/fs.h>
 #include <linux/mm.h>
@@ -14,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/cpu.h>
+#include <linux/cpumask.h>
 #include <linux/vmstat.h>
 #include <linux/sched.h>
 #include <linux/math64.h>
@@ -419,13 +421,22 @@ void dec_zone_page_state(struct page *pa
 EXPORT_SYMBOL(dec_zone_page_state);
 #endif
 
-static inline void fold_diff(int *diff)
+
+/*
+ * Fold a differential into the global counters.
+ * Returns the number of counters updated.
+ */
+static int fold_diff(int *diff)
 {
 	int i;
+	int changes = 0;
 
 	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
-		if (diff[i])
+		if (diff[i]) {
 			atomic_long_add(diff[i], &vm_stat[i]);
+			changes++;
+	}
+	return changes;
 }
 
 /*
@@ -441,12 +452,15 @@ static inline void fold_diff(int *diff)
  * statistics in the remote zone struct as well as the global cachelines
  * with the global counters. These could cause remote node cache line
  * bouncing and will have to be only done when necessary.
+ *
+ * The function returns the number of global counters updated.
  */
-static void refresh_cpu_vm_stats(void)
+static int refresh_cpu_vm_stats(void)
 {
 	struct zone *zone;
 	int i;
 	int global_diff[NR_VM_ZONE_STAT_ITEMS] = { 0, };
+	int changes = 0;
 
 	for_each_populated_zone(zone) {
 		struct per_cpu_pageset __percpu *p = zone->pageset;
@@ -486,15 +500,17 @@ static void refresh_cpu_vm_stats(void)
 			continue;
 		}
 
-
 		if (__this_cpu_dec_return(p->expire))
 			continue;
 
-		if (__this_cpu_read(p->pcp.count))
+		if (__this_cpu_read(p->pcp.count)) {
 			drain_zone_pages(zone, this_cpu_ptr(&p->pcp));
+			changes++;
+		}
 #endif
 	}
-	fold_diff(global_diff);
+	changes += fold_diff(global_diff);
+	return changes;
 }
 
 /*
@@ -1229,20 +1245,105 @@ static const struct file_operations proc
 #ifdef CONFIG_SMP
 static DEFINE_PER_CPU(struct delayed_work, vmstat_work);
 int sysctl_stat_interval __read_mostly = HZ;
+struct cpumask *cpu_stat_off;
 
 static void vmstat_update(struct work_struct *w)
 {
-	refresh_cpu_vm_stats();
-	schedule_delayed_work(this_cpu_ptr(&vmstat_work),
+	if (refresh_cpu_vm_stats())
+		/*
+		 * Counters were updated so we expect more updates
+		 * to occur in the future. Keep on running the
+		 * update worker thread.
+		 */
+		schedule_delayed_work(this_cpu_ptr(&vmstat_work),
+			round_jiffies_relative(sysctl_stat_interval));
+	else {
+		/*
+		 * We did not update any counters so the app may be in
+		 * a mode where it does not cause counter updates.
+		 * We may be uselessly running vmstat_update.
+		 * Defer the checking for differentials to the
+		 * shepherd thread on a different processor.
+		 */
+		int r;
+		/*
+		 * Shepherd work thread does not race since it never
+		 * changes the bit if its zero but the cpu
+		 * online / off line code may race if
+		 * worker threads are still allowed during
+		 * shutdown / startup.
+		 */
+		r = cpumask_test_and_set_cpu(smp_processor_id(),
+			cpu_stat_off);
+		VM_BUG_ON(r);
+	}
+}
+
+/*
+ * Check if the diffs for a certain cpu indicate that
+ * an update is needed.
+ */
+static bool need_update(int cpu)
+{
+	struct zone *zone;
+
+	for_each_populated_zone(zone) {
+		struct per_cpu_pageset *p = per_cpu_ptr(zone->pageset, cpu);
+
+		BUILD_BUG_ON(sizeof(p->vm_stat_diff[0]) != 1);
+		/*
+		 * The fast way of checking if there are any vmstat diffs.
+		 * This works because the diffs are byte sized items.
+		 */
+		if (memchr_inv(p->vm_stat_diff, 0, NR_VM_ZONE_STAT_ITEMS))
+			return true;
+
+	}
+	return false;
+}
+
+
+/*
+ * Shepherd worker thread that checks the
+ * differentials of processors that have their worker
+ * threads for vm statistics updates disabled because of
+ * inactivity.
+ */
+static void vmstat_shepherd(struct work_struct *w);
+
+static DECLARE_DELAYED_WORK(shepherd, vmstat_shepherd);
+
+static void vmstat_shepherd(struct work_struct *w)
+{
+	int cpu;
+
+	/* Check processors whose vmstat worker threads have been disabled */
+	for_each_cpu(cpu, cpu_stat_off)
+		if (need_update(cpu) &&
+			cpumask_test_and_clear_cpu(cpu, cpu_stat_off))
+
+			schedule_delayed_work_on(cpu, &per_cpu(vmstat_work, cpu),
+				__round_jiffies_relative(sysctl_stat_interval, cpu));
+
+
+	schedule_delayed_work(&shepherd,
 		round_jiffies_relative(sysctl_stat_interval));
+
 }
 
-static void start_cpu_timer(int cpu)
+static void __init start_shepherd_timer(void)
 {
-	struct delayed_work *work = &per_cpu(vmstat_work, cpu);
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		INIT_DEFERRABLE_WORK(per_cpu_ptr(&vmstat_work, cpu),
+			vmstat_update);
+
+	cpu_stat_off = kmalloc(cpumask_size(), GFP_KERNEL);
+	cpumask_copy(cpu_stat_off, cpu_online_mask);
 
-	INIT_DEFERRABLE_WORK(work, vmstat_update);
-	schedule_delayed_work_on(cpu, work, __round_jiffies_relative(HZ, cpu));
+	schedule_delayed_work(&shepherd,
+		round_jiffies_relative(sysctl_stat_interval));
 }
 
 static void vmstat_cpu_dead(int node)
@@ -1273,17 +1374,17 @@ static int vmstat_cpuup_callback(struct
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		refresh_zone_stat_thresholds();
-		start_cpu_timer(cpu);
 		node_set_state(cpu_to_node(cpu), N_CPU);
+		cpumask_set_cpu(cpu, cpu_stat_off);
 		break;
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
-		cancel_delayed_work_sync(&per_cpu(vmstat_work, cpu));
-		per_cpu(vmstat_work, cpu).work.func = NULL;
+		if (!cpumask_test_and_set_cpu(cpu, cpu_stat_off))
+			cancel_delayed_work_sync(&per_cpu(vmstat_work, cpu));
 		break;
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
-		start_cpu_timer(cpu);
+		cpumask_set_cpu(cpu, cpu_stat_off);
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
@@ -1303,15 +1404,10 @@ static struct notifier_block vmstat_noti
 static int __init setup_vmstat(void)
 {
 #ifdef CONFIG_SMP
-	int cpu;
