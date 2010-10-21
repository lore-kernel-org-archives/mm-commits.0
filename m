From: akpm@linux-foundation.org
Subject: + proc-stat-fix-scalability-of-irq-sum-of-all-cpu.patch added to -mm tree
Date: Thu, 21 Oct 2010 12:58:43 -0700
Message-ID: <201010211958.o9LJwhjE032738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58229 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751403Ab0JUT73 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Oct 2010 15:59:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, mingo@elte.hu, steiner@sgi.com, tglx@linutronix.de, yinghai@kernel.org


The patch titled
     /proc/stat: fix scalability of irq sum of all cpu
has been added to the -mm tree.  Its filename is
     proc-stat-fix-scalability-of-irq-sum-of-all-cpu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: /proc/stat: fix scalability of irq sum of all cpu
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

In /proc/stat, the number of per-IRQ event is shown by making a sum each
irq's events on all cpus.  But we can make use of kstat_irqs().

kstat_irqs() do the same calculation, If !CONFIG_GENERIC_HARDIRQ,
it's not a big cost. (Both of the number of cpus and irqs are small.)

If a system is very big and CONFIG_GENERIC_HARDIRQ, it does

	for_each_irq()
		for_each_cpu()
			- look up a radix tree
			- read desc->irq_stat[cpu]
This seems not efficient. This patch adds kstat_irqs() for
CONFIG_GENRIC_HARDIRQ and change the calculation as

	for_each_irq()
		look up radix tree
		for_each_cpu()
			- read desc->irq_stat[cpu]

This reduces cost.

A test on (4096cpusp, 256 nodes, 4592 irqs) host (by Jack Steiner)

%time cat /proc/stat > /dev/null

Before Patch:	 2.459 sec
After Patch :	  .561 sec

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Tested-by: Jack Steiner <steiner@sgi.com>
Acked-by: Jack Steiner <steiner@sgi.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/stat.c              |    9 ++-------
 include/linux/kernel_stat.h |    4 ++++
 kernel/irq/irqdesc.c        |   16 ++++++++++++++++
 3 files changed, 22 insertions(+), 7 deletions(-)

diff -puN fs/proc/stat.c~proc-stat-fix-scalability-of-irq-sum-of-all-cpu fs/proc/stat.c
--- a/fs/proc/stat.c~proc-stat-fix-scalability-of-irq-sum-of-all-cpu
+++ a/fs/proc/stat.c
@@ -108,13 +108,8 @@ static int show_stat(struct seq_file *p,
 	seq_printf(p, "intr %llu", (unsigned long long)sum);
 
 	/* sum again ? it could be updated? */
-	for_each_irq_nr(j) {
-		per_irq_sum = 0;
-		for_each_possible_cpu(i)
-			per_irq_sum += kstat_irqs_cpu(j, i);
-
-		seq_printf(p, " %u", per_irq_sum);
-	}
+	for_each_irq_nr(j)
+		seq_printf(p, " %u", kstat_irqs(j));
 
 	seq_printf(p,
 		"\nctxt %llu\n"
diff -puN include/linux/kernel_stat.h~proc-stat-fix-scalability-of-irq-sum-of-all-cpu include/linux/kernel_stat.h
--- a/include/linux/kernel_stat.h~proc-stat-fix-scalability-of-irq-sum-of-all-cpu
+++ a/include/linux/kernel_stat.h
@@ -86,6 +86,7 @@ static inline unsigned int kstat_softirq
 /*
  * Number of interrupts per specific IRQ source, since bootup
  */
+#ifndef CONFIG_GENERIC_HARDIRQS
 static inline unsigned int kstat_irqs(unsigned int irq)
 {
 	unsigned int sum = 0;
@@ -96,6 +97,9 @@ static inline unsigned int kstat_irqs(un
 
 	return sum;
 }
+#else
+extern unsigned int kstat_irqs(unsigned int irq);
+#endif
 
 /*
  * Number of interrupts per cpu, since bootup
diff -puN kernel/irq/irqdesc.c~proc-stat-fix-scalability-of-irq-sum-of-all-cpu kernel/irq/irqdesc.c
--- a/kernel/irq/irqdesc.c~proc-stat-fix-scalability-of-irq-sum-of-all-cpu
+++ a/kernel/irq/irqdesc.c
@@ -393,3 +393,19 @@ unsigned int kstat_irqs_cpu(unsigned int
 	struct irq_desc *desc = irq_to_desc(irq);
 	return desc ? desc->kstat_irqs[cpu] : 0;
 }
+
+#ifdef CONFIG_GENERIC_HARDIRQS
+unsigned int  kstat_irqs(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	int cpu;
+	int sum = 0;
+
+	if (!desc)
+		return 0;
+	for_each_possible_cpu(cpu)
+		sum += desc->kstat_irqs[cpu];
+	return sum;
+}
+EXPORT_SYMBOL_GPL(kstat_irqs);
+#endif /*CONFIG_GENERIC_HARDIRQS*/
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

mm-fix-return-value-of-scan_lru_pages-in-memory-unplug.patch
linux-next.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
oom-add-per-mm-oom-disable-count.patch
oom-add-per-mm-oom-disable-count-protect-oom_disable_count-with-task_lock-in-fork.patch
oom-add-per-mm-oom-disable-count-use-old_mm-for-oom_disable_count-in-exec.patch
oom-avoid-killing-a-task-if-a-thread-sharing-its-mm-cannot-be-killed.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
memory-hotplug-fix-notifiers-return-value-check.patch
memory-hotplug-unify-is_removable-and-offline-detection-code.patch
memory-hotplug-unify-is_removable-and-offline-detection-code-checkpatch-fixes.patch
tracing-vmscan-add-trace-events-for-lru-list-shrinking.patch
writeback-account-for-time-spent-congestion_waited.patch
vmscan-synchronous-lumpy-reclaim-should-not-call-congestion_wait.patch
vmscan-narrow-the-scenarios-lumpy-reclaim-uses-synchrounous-reclaim.patch
vmscan-remove-dead-code-in-shrink_inactive_list.patch
vmscan-isolated_lru_pages-stop-neighbour-search-if-neighbour-cannot-be-isolated.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encountered-in-the-current-zone.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encounted-in-the-current-zone-fix.patch
mm-memory_hotplugc-make-scan_lru_pages-static.patch
mm-fix-error-reporting-in-move_pages-syscall.patch
memcg-fix-race-in-file_mapped-accouting-flag-management.patch
memcg-avoid-lock-in-updating-file_mapped-was-fix-race-in-file_mapped-accouting-flag-management.patch
memcg-use-for_each_mem_cgroup.patch
memcg-cpu-hotplug-aware-percpu-count-updates.patch
memcg-cpu-hotplug-aware-percpu-count-updates-fix.patch
memcg-cpu-hotplug-aware-quick-acount_move-detection.patch
memcg-cpu-hotplug-aware-quick-acount_move-detection-checkpatch-fixes.patch
memcg-generic-filestat-update-interface.patch
proc-stat-scalability-of-irq-num-per-cpu.patch
proc-stat-fix-scalability-of-irq-sum-of-all-cpu.patch
proc-stat-fix-scalability-of-irq-sum-of-all-cpu-fix.patch

