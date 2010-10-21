From: akpm@linux-foundation.org
Subject: + proc-stat-scalability-of-irq-num-per-cpu.patch added to -mm tree
Date: Thu, 21 Oct 2010 12:58:41 -0700
Message-ID: <201010211958.o9LJwfaq032735@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58417 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753965Ab0JUT7b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Oct 2010 15:59:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, mingo@elte.hu, steiner@sgi.com, tglx@linutronix.de, yinghai@kernel.org


The patch titled
     /proc/stat: scalability of irq num per cpu
has been added to the -mm tree.  Its filename is
     proc-stat-scalability-of-irq-num-per-cpu.patch

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
Subject: /proc/stat: scalability of irq num per cpu
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

/proc/stat shows the total number of all interrupts to each cpu.  But when
the number of IRQs are very large, it take very long time and 'cat
/proc/stat' takes more than 10 secs.  This is because sum of all irq
events are counted when /proc/stat is read.  This patch adds "sum of all
irq" counter percpu and reduce read costs.

The cost of reading /proc/stat is important because it's used by major
applications as 'top', 'ps', 'w', etc....

A test on a mechin (4096cpu, 256 nodes, 4592 irqs) shows

 %time cat /proc/stat > /dev/null
 Before Patch:  12.627 sec
 After  Patch:  2.459 sec

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Tested-by: Jack Steiner <steiner@sgi.com>
Acked-by: Jack Steiner <steiner@sgi.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/stat.c              |    4 +---
 include/linux/kernel_stat.h |   14 ++++++++++++--
 2 files changed, 13 insertions(+), 5 deletions(-)

diff -puN fs/proc/stat.c~proc-stat-scalability-of-irq-num-per-cpu fs/proc/stat.c
--- a/fs/proc/stat.c~proc-stat-scalability-of-irq-num-per-cpu
+++ a/fs/proc/stat.c
@@ -52,9 +52,7 @@ static int show_stat(struct seq_file *p,
 		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
 		guest_nice = cputime64_add(guest_nice,
 			kstat_cpu(i).cpustat.guest_nice);
-		for_each_irq_nr(j) {
-			sum += kstat_irqs_cpu(j, i);
-		}
+		sum += kstat_cpu_irqs_sum(i);
 		sum += arch_irq_stat_cpu(i);
 
 		for (j = 0; j < NR_SOFTIRQS; j++) {
diff -puN include/linux/kernel_stat.h~proc-stat-scalability-of-irq-num-per-cpu include/linux/kernel_stat.h
--- a/include/linux/kernel_stat.h~proc-stat-scalability-of-irq-num-per-cpu
+++ a/include/linux/kernel_stat.h
@@ -33,6 +33,7 @@ struct kernel_stat {
 #ifndef CONFIG_GENERIC_HARDIRQS
        unsigned int irqs[NR_IRQS];
 #endif
+	unsigned long irqs_sum;
 	unsigned int softirqs[NR_SOFTIRQS];
 };
 
@@ -54,6 +55,7 @@ static inline void kstat_incr_irqs_this_
 					    struct irq_desc *desc)
 {
 	kstat_this_cpu.irqs[irq]++;
+	kstat_this_cpu.irqs_sum++;
 }
 
 static inline unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
@@ -65,8 +67,9 @@ static inline unsigned int kstat_irqs_cp
 extern unsigned int kstat_irqs_cpu(unsigned int irq, int cpu);
 #define kstat_irqs_this_cpu(DESC) \
 	((DESC)->kstat_irqs[smp_processor_id()])
-#define kstat_incr_irqs_this_cpu(irqno, DESC) \
-	((DESC)->kstat_irqs[smp_processor_id()]++)
+#define kstat_incr_irqs_this_cpu(irqno, DESC) do {\
+	((DESC)->kstat_irqs[smp_processor_id()]++);\
+	kstat_this_cpu.irqs_sum++; } while (0)
 
 #endif
 
@@ -94,6 +97,13 @@ static inline unsigned int kstat_irqs(un
 	return sum;
 }
 
+/*
+ * Number of interrupts per cpu, since bootup
+ */
+static inline unsigned int kstat_cpu_irqs_sum(unsigned int cpu)
+{
+	return kstat_cpu(cpu).irqs_sum;
+}
 
 /*
  * Lock/unlock the current runqueue - to extract task statistics:
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

