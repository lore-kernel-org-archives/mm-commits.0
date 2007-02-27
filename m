From: akpm@linux-foundation.org
Subject: + speedup-divides-by-cpu_power-in-scheduler.patch added to -mm tree
Date: Tue, 27 Feb 2007 13:01:29 -0800
Message-ID: <200702272101.l1RL1XNv028495@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52102 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbXB0VCw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 16:02:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dada1@cosmosbay.com, mingo@elte.hu, nickpiggin@yahoo.com.au


The patch titled
     Speed up divides by cpu_power in scheduler
has been added to the -mm tree.  Its filename is
     speedup-divides-by-cpu_power-in-scheduler.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Speed up divides by cpu_power in scheduler
From: Eric Dumazet <dada1@cosmosbay.com>

I noticed expensive divides done in try_to_wakeup() and
find_busiest_group() on a bi dual core Opteron machine (total of 4 cores),
moderatly loaded (15.000 context switch per second)

oprofile numbers :

CPU: AMD64 processors, speed 2600.05 MHz (estimated)
Counted CPU_CLK_UNHALTED events (Cycles outside of halt state) with a unit
mask of 0x00 (No unit mask) count 50000
samples  %        symbol name
...
613914    1.0498  try_to_wake_up
    834  0.0013 :ffffffff80227ae1:   div    %rcx
77513  0.1191 :ffffffff80227ae4:   mov    %rax,%r11

608893    1.0413  find_busiest_group
   1841  0.0031 :ffffffff802260bf:       div    %rdi
140109  0.2394 :ffffffff802260c2:       test   %sil,%sil

Some of these divides can use the reciprocal divides we introduced some
time ago (currently used in slab AFAIK)

We can assume a load will fit in a 32bits number, because with a
SCHED_LOAD_SCALE=128 value, its still a theorical limit of 33554432

When/if we reach this limit one day, probably cpus will have a fast
hardware divide and we can zap the reciprocal divide trick.

Ingo suggested to rename cpu_power to __cpu_power to make clear it should
not be modified without changing its reciprocal value too.

I did not convert the divide in cpu_avg_load_per_task(), because tracking
nr_running changes may be not worth it ?  We could use a static table of 32
reciprocal values but it would add a conditional branch and table lookup.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    8 +++
 kernel/sched.c        |   81 +++++++++++++++++++++++++---------------
 2 files changed, 59 insertions(+), 30 deletions(-)

diff -puN include/linux/sched.h~speedup-divides-by-cpu_power-in-scheduler include/linux/sched.h
--- a/include/linux/sched.h~speedup-divides-by-cpu_power-in-scheduler
+++ a/include/linux/sched.h
@@ -677,8 +677,14 @@ struct sched_group {
 	/*
 	 * CPU power of this group, SCHED_LOAD_SCALE being max power for a
 	 * single CPU. This is read only (except for setup, hotplug CPU).
+	 * Note : Never change cpu_power without recompute its reciprocal
 	 */
-	unsigned long cpu_power;
+	unsigned int __cpu_power;
+	/*
+	 * reciprocal value of cpu_power to avoid expensive divides
+	 * (see include/linux/reciprocal_div.h)
+	 */
+	u32 reciprocal_cpu_power;
 };
 
 struct sched_domain {
diff -puN kernel/sched.c~speedup-divides-by-cpu_power-in-scheduler kernel/sched.c
--- a/kernel/sched.c~speedup-divides-by-cpu_power-in-scheduler
+++ a/kernel/sched.c
@@ -52,8 +52,9 @@
 #include <linux/tsacct_kern.h>
 #include <linux/kprobes.h>
 #include <linux/delayacct.h>
-#include <asm/tlb.h>
+#include <linux/reciprocal_div.h>
 
+#include <asm/tlb.h>
 #include <asm/unistd.h>
 
 /*
@@ -182,6 +183,25 @@ static unsigned int static_prio_timeslic
 }
 
 /*
+ * Divide a load by a sched group cpu_power : (load / sg->__cpu_power)
+ * Since cpu_power is a 'constant', we can use a reciprocal divide.
+ */
+static inline u32 sg_div_cpu_power(const struct sched_group *sg, u32 load)
+{
+	return reciprocal_divide(load, sg->reciprocal_cpu_power);
+}
+
+/*
+ * Each time a sched group cpu_power is changed,
+ * we must compute its reciprocal value
+ */
+static inline void sg_inc_cpu_power(struct sched_group *sg, u32 val)
+{
+	sg->__cpu_power += val;
+	sg->reciprocal_cpu_power = reciprocal_value(sg->__cpu_power);
+}
+
+/*
  * task_timeslice() scales user-nice values [ -20 ... 0 ... 19 ]
  * to time slice values: [800ms ... 100ms ... 5ms]
  *
@@ -1257,7 +1277,8 @@ find_idlest_group(struct sched_domain *s
 		}
 
 		/* Adjust by relative CPU power of the group */
-		avg_load = (avg_load * SCHED_LOAD_SCALE) / group->cpu_power;
+		avg_load = sg_div_cpu_power(group,
+				avg_load * SCHED_LOAD_SCALE);
 
 		if (local_group) {
 			this_load = avg_load;
@@ -2368,12 +2389,13 @@ find_busiest_group(struct sched_domain *
 		}
 
 		total_load += avg_load;
-		total_pwr += group->cpu_power;
+		total_pwr += group->__cpu_power;
 
 		/* Adjust by relative CPU power of the group */
-		avg_load = (avg_load * SCHED_LOAD_SCALE) / group->cpu_power;
+		avg_load = sg_div_cpu_power(group,
+				avg_load * SCHED_LOAD_SCALE);
 
-		group_capacity = group->cpu_power / SCHED_LOAD_SCALE;
+		group_capacity = group->__cpu_power / SCHED_LOAD_SCALE;
 
 		if (local_group) {
 			this_load = avg_load;
@@ -2484,8 +2506,8 @@ group_next:
 	max_pull = min(max_load - avg_load, max_load - busiest_load_per_task);
 
 	/* How much load to actually move to equalise the imbalance */
-	*imbalance = min(max_pull * busiest->cpu_power,
-				(avg_load - this_load) * this->cpu_power)
+	*imbalance = min(max_pull * busiest->__cpu_power,
+				(avg_load - this_load) * this->__cpu_power)
 			/ SCHED_LOAD_SCALE;
 
 	/*
@@ -2519,28 +2541,29 @@ small_imbalance:
 		 * moving them.
 		 */
 
-		pwr_now += busiest->cpu_power *
-			min(busiest_load_per_task, max_load);
-		pwr_now += this->cpu_power *
-			min(this_load_per_task, this_load);
+		pwr_now += busiest->__cpu_power *
+				min(busiest_load_per_task, max_load);
+		pwr_now += this->__cpu_power *
+				min(this_load_per_task, this_load);
 		pwr_now /= SCHED_LOAD_SCALE;
 
 		/* Amount of load we'd subtract */
-		tmp = busiest_load_per_task * SCHED_LOAD_SCALE /
-			busiest->cpu_power;
+		tmp = sg_div_cpu_power(busiest,
+				busiest_load_per_task * SCHED_LOAD_SCALE);
 		if (max_load > tmp)
-			pwr_move += busiest->cpu_power *
+			pwr_move += busiest->__cpu_power *
 				min(busiest_load_per_task, max_load - tmp);
 
 		/* Amount of load we'd add */
-		if (max_load * busiest->cpu_power <
+		if (max_load * busiest->__cpu_power <
 				busiest_load_per_task * SCHED_LOAD_SCALE)
-			tmp = max_load * busiest->cpu_power / this->cpu_power;
+			tmp = sg_div_cpu_power(this,
+					max_load * busiest->__cpu_power);
 		else
-			tmp = busiest_load_per_task * SCHED_LOAD_SCALE /
-				this->cpu_power;
-		pwr_move += this->cpu_power *
-			min(this_load_per_task, this_load + tmp);
+			tmp = sg_div_cpu_power(this,
+				busiest_load_per_task * SCHED_LOAD_SCALE);
+		pwr_move += this->__cpu_power *
+				min(this_load_per_task, this_load + tmp);
 		pwr_move /= SCHED_LOAD_SCALE;
 
 		/* Move if we gain throughput */
@@ -5706,7 +5729,7 @@ static void sched_domain_debug(struct sc
 				break;
 			}
 
-			if (!group->cpu_power) {
+			if (!group->__cpu_power) {
 				printk("\n");
 				printk(KERN_ERR "ERROR: domain->cpu_power not "
 						"set\n");
@@ -5883,7 +5906,7 @@ init_sched_build_groups(cpumask_t span, 
 			continue;
 
 		sg->cpumask = CPU_MASK_NONE;
-		sg->cpu_power = 0;
+		sg->__cpu_power = 0;
 
 		for_each_cpu_mask(j, span) {
 			if (group_fn(j, cpu_map, NULL) != group)
@@ -6572,7 +6595,7 @@ next_sg:
 			continue;
 		}
 
-		sg->cpu_power += sd->groups->cpu_power;
+		sg_inc_cpu_power(sg, sd->groups->__cpu_power);
 	}
 	sg = sg->next;
 	if (sg != group_head)
@@ -6647,6 +6670,8 @@ static void init_sched_groups_power(int 
 
 	child = sd->child;
 
+	sd->groups->__cpu_power = 0;
+
 	/*
 	 * For perf policy, if the groups in child domain share resources
 	 * (for example cores sharing some portions of the cache hierarchy
@@ -6657,18 +6682,16 @@ static void init_sched_groups_power(int 
 	if (!child || (!(sd->flags & SD_POWERSAVINGS_BALANCE) &&
 		       (child->flags &
 			(SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES)))) {
-		sd->groups->cpu_power = SCHED_LOAD_SCALE;
+		sg_inc_cpu_power(sd->groups, SCHED_LOAD_SCALE);
 		return;
 	}
 
-	sd->groups->cpu_power = 0;
-
 	/*
 	 * add cpu_power of each child group to this groups cpu_power
 	 */
 	group = child->groups;
 	do {
-		sd->groups->cpu_power += group->cpu_power;
+		sg_inc_cpu_power(sd->groups, group->__cpu_power);
 		group = group->next;
 	} while (group != child->groups);
 }
@@ -6828,7 +6851,7 @@ static int build_sched_domains(const cpu
 			sd = &per_cpu(node_domains, j);
 			sd->groups = sg;
 		}
-		sg->cpu_power = 0;
+		sg->__cpu_power = 0;
 		sg->cpumask = nodemask;
 		sg->next = sg;
 		cpus_or(covered, covered, nodemask);
@@ -6856,7 +6879,7 @@ static int build_sched_domains(const cpu
 				"Can not alloc domain group for node %d\n", j);
 				goto error;
 			}
-			sg->cpu_power = 0;
+			sg->__cpu_power = 0;
 			sg->cpumask = tmp;
 			sg->next = prev->next;
 			cpus_or(covered, covered, tmp);
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
speedup-divides-by-cpu_power-in-scheduler.patch
