From: akpm@osdl.org
Subject: - kernel-schedc-whitespace-cleanups.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:54:45 -0800
Message-ID: <200612130654.kBD6sjZm030570@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57667 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965014AbWLMGyv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:54:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maxextreme@gmail.com, mingo@elte.hu, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     kernel/sched.c: whitespace cleanups
has been removed from the -mm tree.  Its filename was
     kernel-schedc-whitespace-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kernel/sched.c: whitespace cleanups
From: Miguel Ojeda Sandonis <maxextreme@gmail.com>

[akpm@osdl.org: additional cleanups]
Signed-off-by: Miguel Ojeda Sandonis <maxextreme@gmail.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sched.c |   97 +++++++++++++++++++++++++++--------------------
 1 file changed, 56 insertions(+), 41 deletions(-)

diff -puN kernel/sched.c~kernel-schedc-whitespace-cleanups kernel/sched.c
--- a/kernel/sched.c~kernel-schedc-whitespace-cleanups
+++ a/kernel/sched.c
@@ -466,7 +466,8 @@ static int show_schedstat(struct seq_fil
 			seq_printf(seq, "domain%d %s", dcnt++, mask_str);
 			for (itype = SCHED_IDLE; itype < MAX_IDLE_TYPES;
 					itype++) {
-				seq_printf(seq, " %lu %lu %lu %lu %lu %lu %lu %lu",
+				seq_printf(seq, " %lu %lu %lu %lu %lu %lu %lu "
+						"%lu",
 				    sd->lb_cnt[itype],
 				    sd->lb_balanced[itype],
 				    sd->lb_failed[itype],
@@ -476,11 +477,13 @@ static int show_schedstat(struct seq_fil
 				    sd->lb_nobusyq[itype],
 				    sd->lb_nobusyg[itype]);
 			}
-			seq_printf(seq, " %lu %lu %lu %lu %lu %lu %lu %lu %lu %lu %lu %lu\n",
+			seq_printf(seq, " %lu %lu %lu %lu %lu %lu %lu %lu %lu"
+			    " %lu %lu %lu\n",
 			    sd->alb_cnt, sd->alb_failed, sd->alb_pushed,
 			    sd->sbe_cnt, sd->sbe_balanced, sd->sbe_pushed,
 			    sd->sbf_cnt, sd->sbf_balanced, sd->sbf_pushed,
-			    sd->ttwu_wake_remote, sd->ttwu_move_affine, sd->ttwu_move_balance);
+			    sd->ttwu_wake_remote, sd->ttwu_move_affine,
+			    sd->ttwu_move_balance);
 		}
 		preempt_enable();
 #endif
@@ -1454,7 +1457,9 @@ static int try_to_wake_up(struct task_st
 
 		if (this_sd->flags & SD_WAKE_AFFINE) {
 			unsigned long tl = this_load;
-			unsigned long tl_per_task = cpu_avg_load_per_task(this_cpu);
+			unsigned long tl_per_task;
+
+			tl_per_task = cpu_avg_load_per_task(this_cpu);
 
 			/*
 			 * If sync wakeup then subtract the (maximum possible)
@@ -2487,18 +2492,21 @@ small_imbalance:
 		pwr_now /= SCHED_LOAD_SCALE;
 
 		/* Amount of load we'd subtract */
-		tmp = busiest_load_per_task*SCHED_LOAD_SCALE/busiest->cpu_power;
+		tmp = busiest_load_per_task * SCHED_LOAD_SCALE /
+			busiest->cpu_power;
 		if (max_load > tmp)
 			pwr_move += busiest->cpu_power *
 				min(busiest_load_per_task, max_load - tmp);
 
 		/* Amount of load we'd add */
-		if (max_load*busiest->cpu_power <
-				busiest_load_per_task*SCHED_LOAD_SCALE)
-			tmp = max_load*busiest->cpu_power/this->cpu_power;
+		if (max_load * busiest->cpu_power <
+				busiest_load_per_task * SCHED_LOAD_SCALE)
+			tmp = max_load * busiest->cpu_power / this->cpu_power;
 		else
-			tmp = busiest_load_per_task*SCHED_LOAD_SCALE/this->cpu_power;
-		pwr_move += this->cpu_power*min(this_load_per_task, this_load + tmp);
+			tmp = busiest_load_per_task * SCHED_LOAD_SCALE /
+				this->cpu_power;
+		pwr_move += this->cpu_power *
+			min(this_load_per_task, this_load + tmp);
 		pwr_move /= SCHED_LOAD_SCALE;
 
 		/* Move if we gain throughput */
@@ -3366,7 +3374,8 @@ void fastcall add_preempt_count(int val)
 	/*
 	 * Spinlock count overflowing soon?
 	 */
-	DEBUG_LOCKS_WARN_ON((preempt_count() & PREEMPT_MASK) >= PREEMPT_MASK-10);
+	DEBUG_LOCKS_WARN_ON((preempt_count() & PREEMPT_MASK) >=
+				PREEMPT_MASK - 10);
 }
 EXPORT_SYMBOL(add_preempt_count);
 
@@ -5439,16 +5448,19 @@ static void sched_domain_debug(struct sc
 		if (!(sd->flags & SD_LOAD_BALANCE)) {
 			printk("does not load-balance\n");
 			if (sd->parent)
-				printk(KERN_ERR "ERROR: !SD_LOAD_BALANCE domain has parent");
+				printk(KERN_ERR "ERROR: !SD_LOAD_BALANCE domain"
+						" has parent");
 			break;
 		}
 
 		printk("span %s\n", str);
 
 		if (!cpu_isset(cpu, sd->span))
-			printk(KERN_ERR "ERROR: domain->span does not contain CPU%d\n", cpu);
+			printk(KERN_ERR "ERROR: domain->span does not contain "
+					"CPU%d\n", cpu);
 		if (!cpu_isset(cpu, group->cpumask))
-			printk(KERN_ERR "ERROR: domain->groups does not contain CPU%d\n", cpu);
+			printk(KERN_ERR "ERROR: domain->groups does not contain"
+					" CPU%d\n", cpu);
 
 		printk(KERN_DEBUG);
 		for (i = 0; i < level + 2; i++)
@@ -5463,7 +5475,8 @@ static void sched_domain_debug(struct sc
 
 			if (!group->cpu_power) {
 				printk("\n");
-				printk(KERN_ERR "ERROR: domain->cpu_power not set\n");
+				printk(KERN_ERR "ERROR: domain->cpu_power not "
+						"set\n");
 			}
 
 			if (!cpus_weight(group->cpumask)) {
@@ -5486,15 +5499,17 @@ static void sched_domain_debug(struct sc
 		printk("\n");
 
 		if (!cpus_equal(sd->span, groupmask))
-			printk(KERN_ERR "ERROR: groups don't span domain->span\n");
+			printk(KERN_ERR "ERROR: groups don't span "
+					"domain->span\n");
 
 		level++;
 		sd = sd->parent;
+		if (!sd)
+			continue;
 
-		if (sd) {
-			if (!cpus_subset(groupmask, sd->span))
-				printk(KERN_ERR "ERROR: parent span is not a superset of domain->span\n");
-		}
+		if (!cpus_subset(groupmask, sd->span))
+			printk(KERN_ERR "ERROR: parent span is not a superset "
+				"of domain->span\n");
 
 	} while (sd);
 }
@@ -5812,8 +5827,9 @@ __setup("max_cache_size=", setup_max_cac
  */
 static void touch_cache(void *__cache, unsigned long __size)
 {
-	unsigned long size = __size/sizeof(long), chunk1 = size/3,
-			chunk2 = 2*size/3;
+	unsigned long size = __size / sizeof(long);
+	unsigned long chunk1 = size / 3;
+	unsigned long chunk2 = 2 * size / 3;
 	unsigned long *cache = __cache;
 	int i;
 
@@ -5827,7 +5843,7 @@ static void touch_cache(void *__cache, u
 	 * step is 32 bytes on 32-bit systems, 64 bytes on
 	 * 64-bit systems)
 	 */
-	for (i = 0; i < size/6; i += 8) {
+	for (i = 0; i < size / 6; i += 8) {
 		switch (i % 6*8) {
 			case 0*8: cache[i]++;
 			case 1*8: cache[size-1-i]++;
@@ -5932,11 +5948,11 @@ measure_cost(int cpu1, int cpu2, void *c
 	 */
 	measure_one(cache, size, cpu1, cpu2);
 	for (i = 0; i < ITERATIONS; i++)
-		cost1 += measure_one(cache, size - i*1024, cpu1, cpu2);
+		cost1 += measure_one(cache, size - i * 1024, cpu1, cpu2);
 
 	measure_one(cache, size, cpu2, cpu1);
 	for (i = 0; i < ITERATIONS; i++)
-		cost1 += measure_one(cache, size - i*1024, cpu2, cpu1);
+		cost1 += measure_one(cache, size - i * 1024, cpu2, cpu1);
 
 	/*
 	 * (We measure the non-migrating [cached] cost on both
@@ -5946,17 +5962,17 @@ measure_cost(int cpu1, int cpu2, void *c
 
 	measure_one(cache, size, cpu1, cpu1);
 	for (i = 0; i < ITERATIONS; i++)
-		cost2 += measure_one(cache, size - i*1024, cpu1, cpu1);
+		cost2 += measure_one(cache, size - i * 1024, cpu1, cpu1);
 
 	measure_one(cache, size, cpu2, cpu2);
 	for (i = 0; i < ITERATIONS; i++)
-		cost2 += measure_one(cache, size - i*1024, cpu2, cpu2);
+		cost2 += measure_one(cache, size - i * 1024, cpu2, cpu2);
 
 	/*
 	 * Get the per-iteration migration cost:
 	 */
-	do_div(cost1, 2*ITERATIONS);
-	do_div(cost2, 2*ITERATIONS);
+	do_div(cost1, 2 * ITERATIONS);
+	do_div(cost2, 2 * ITERATIONS);
 
 	return cost1 - cost2;
 }
@@ -5994,7 +6010,7 @@ static unsigned long long measure_migrat
 	 */
 	cache = vmalloc(max_size);
 	if (!cache) {
-		printk("could not vmalloc %d bytes for cache!\n", 2*max_size);
+		printk("could not vmalloc %d bytes for cache!\n", 2 * max_size);
 		return 1000000; /* return 1 msec on very small boxen */
 	}
 
@@ -6019,7 +6035,8 @@ static unsigned long long measure_migrat
 		avg_fluct = (avg_fluct + fluct)/2;
 
 		if (migration_debug)
-			printk("-> [%d][%d][%7d] %3ld.%ld [%3ld.%ld] (%ld): (%8Ld %8Ld)\n",
+			printk("-> [%d][%d][%7d] %3ld.%ld [%3ld.%ld] (%ld): "
+				"(%8Ld %8Ld)\n",
 				cpu1, cpu2, size,
 				(long)cost / 1000000,
 				((long)cost / 100000) % 10,
@@ -6114,20 +6131,18 @@ static void calibrate_migration_costs(co
 			-1
 #endif
 		);
-	if (system_state == SYSTEM_BOOTING) {
-		if (num_online_cpus() > 1) {
-			printk("migration_cost=");
-			for (distance = 0; distance <= max_distance; distance++) {
-				if (distance)
-					printk(",");
-				printk("%ld", (long)migration_cost[distance] / 1000);
-			}
-			printk("\n");
+	if (system_state == SYSTEM_BOOTING && num_online_cpus() > 1) {
+		printk("migration_cost=");
+		for (distance = 0; distance <= max_distance; distance++) {
+			if (distance)
+				printk(",");
+			printk("%ld", (long)migration_cost[distance] / 1000);
 		}
+		printk("\n");
 	}
 	j1 = jiffies;
 	if (migration_debug)
-		printk("migration: %ld seconds\n", (j1-j0)/HZ);
+		printk("migration: %ld seconds\n", (j1-j0) / HZ);
 
 	/*
 	 * Move back to the original CPU. NUMA-Q gets confused
_

Patches currently in -mm which might be from maxextreme@gmail.com are

origin.patch
drivers-add-lcd-support-3.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
drivers-add-lcd-support-update-4.patch
drivers-add-lcd-support-update-5.patch
drivers-add-lcd-support-update6.patch
drivers-add-lcd-support-update-7.patch
drivers-add-lcd-support-update-8.patch
drivers-add-lcd-support-workqueue-fixups.patch

