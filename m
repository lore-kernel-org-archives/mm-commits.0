From: akpm@linux-foundation.org
Subject: [merged]
 sched-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:16:25 -0800
Message-ID: <54e25019.knQD4M8xYPIh0PUC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50972 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbbBPURB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:17:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, mingo@redhat.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sched: use %*pb[l] to print bitmaps including cpumasks and nodemasks
has been removed from the -mm tree.  Its filename was
     sched-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: sched: use %*pb[l] to print bitmaps including cpumasks and nodemasks

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/core.c  |   10 ++++------
 kernel/sched/stats.c |   11 ++---------
 2 files changed, 6 insertions(+), 15 deletions(-)

diff -puN kernel/sched/core.c~sched-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks kernel/sched/core.c
--- a/kernel/sched/core.c~sched-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/kernel/sched/core.c
@@ -5462,9 +5462,7 @@ static int sched_domain_debug_one(struct
 				  struct cpumask *groupmask)
 {
 	struct sched_group *group = sd->groups;
-	char str[256];
 
-	cpulist_scnprintf(str, sizeof(str), sched_domain_span(sd));
 	cpumask_clear(groupmask);
 
 	printk(KERN_DEBUG "%*s domain %d: ", level, "", level);
@@ -5477,7 +5475,8 @@ static int sched_domain_debug_one(struct
 		return -1;
 	}
 
-	printk(KERN_CONT "span %s level %s\n", str, sd->name);
+	printk(KERN_CONT "span %*pbl level %s\n",
+	       cpumask_pr_args(sched_domain_span(sd)), sd->name);
 
 	if (!cpumask_test_cpu(cpu, sched_domain_span(sd))) {
 		printk(KERN_ERR "ERROR: domain->span does not contain "
@@ -5522,9 +5521,8 @@ static int sched_domain_debug_one(struct
 
 		cpumask_or(groupmask, groupmask, sched_group_cpus(group));
 
-		cpulist_scnprintf(str, sizeof(str), sched_group_cpus(group));
-
-		printk(KERN_CONT " %s", str);
+		printk(KERN_CONT " %*pbl",
+		       cpumask_pr_args(sched_group_cpus(group)));
 		if (group->sgc->capacity != SCHED_CAPACITY_SCALE) {
 			printk(KERN_CONT " (cpu_capacity = %d)",
 				group->sgc->capacity);
diff -puN kernel/sched/stats.c~sched-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks kernel/sched/stats.c
--- a/kernel/sched/stats.c~sched-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/kernel/sched/stats.c
@@ -15,11 +15,6 @@
 static int show_schedstat(struct seq_file *seq, void *v)
 {
 	int cpu;
-	int mask_len = DIV_ROUND_UP(NR_CPUS, 32) * 9;
-	char *mask_str = kmalloc(mask_len, GFP_KERNEL);
-
-	if (mask_str == NULL)
-		return -ENOMEM;
 
 	if (v == (void *)1) {
 		seq_printf(seq, "version %d\n", SCHEDSTAT_VERSION);
@@ -50,9 +45,8 @@ static int show_schedstat(struct seq_fil
 		for_each_domain(cpu, sd) {
 			enum cpu_idle_type itype;
 
-			cpumask_scnprintf(mask_str, mask_len,
-					  sched_domain_span(sd));
-			seq_printf(seq, "domain%d %s", dcount++, mask_str);
+			seq_printf(seq, "domain%d %*pb", dcount++,
+				   cpumask_pr_args(sched_domain_span(sd)));
 			for (itype = CPU_IDLE; itype < CPU_MAX_IDLE_TYPES;
 					itype++) {
 				seq_printf(seq, " %u %u %u %u %u %u %u %u",
@@ -76,7 +70,6 @@ static int show_schedstat(struct seq_fil
 		rcu_read_unlock();
 #endif
 	}
-	kfree(mask_str);
 	return 0;
 }
 
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch

