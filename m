From: akpm@linux-foundation.org
Subject: - cpufreq-change-cpu-freq-arrays-to-per_cpu-variables.patch removed from -mm tree
Date: Fri, 09 May 2008 14:46:55 -0700
Message-ID: <200805092146.m49Lktpl027160@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55121 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755533AbYEIVrd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 17:47:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: travis@sgi.com, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     cpufreq: change cpu freq arrays to per_cpu variables
has been removed from the -mm tree.  Its filename was
     cpufreq-change-cpu-freq-arrays-to-per_cpu-variables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpufreq: change cpu freq arrays to per_cpu variables
From: Mike Travis <travis@sgi.com>

Change cpufreq_policy and cpufreq_governor pointer tables from arrays to
per_cpu variables in the cpufreq subsystem.

Also some minor complaints from checkpatch.pl fixed.

Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq.c       |   45 ++++++++++++++++--------------
 drivers/cpufreq/cpufreq_stats.c |   24 ++++++++--------
 drivers/cpufreq/freq_table.c    |   12 ++++----
 3 files changed, 42 insertions(+), 39 deletions(-)

diff -puN drivers/cpufreq/cpufreq.c~cpufreq-change-cpu-freq-arrays-to-per_cpu-variables drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c~cpufreq-change-cpu-freq-arrays-to-per_cpu-variables
+++ a/drivers/cpufreq/cpufreq.c
@@ -38,10 +38,10 @@
  * also protects the cpufreq_cpu_data array.
  */
 static struct cpufreq_driver *cpufreq_driver;
-static struct cpufreq_policy *cpufreq_cpu_data[NR_CPUS];
+static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data);
 #ifdef CONFIG_HOTPLUG_CPU
 /* This one keeps track of the previously set governor of a removed CPU */
-static struct cpufreq_governor *cpufreq_cpu_governor[NR_CPUS];
+static DEFINE_PER_CPU(struct cpufreq_governor *, cpufreq_cpu_governor);
 #endif
 static DEFINE_SPINLOCK(cpufreq_driver_lock);
 
@@ -135,7 +135,7 @@ struct cpufreq_policy *cpufreq_cpu_get(u
 	struct cpufreq_policy *data;
 	unsigned long flags;
 
-	if (cpu >= NR_CPUS)
+	if (cpu >= nr_cpu_ids)
 		goto err_out;
 
 	/* get the cpufreq driver */
@@ -149,7 +149,7 @@ struct cpufreq_policy *cpufreq_cpu_get(u
 
 
 	/* get the CPU */
-	data = cpufreq_cpu_data[cpu];
+	data = per_cpu(cpufreq_cpu_data, cpu);
 
 	if (!data)
 		goto err_out_put_module;
@@ -327,7 +327,7 @@ void cpufreq_notify_transition(struct cp
 	dprintk("notification %u of frequency transition to %u kHz\n",
 		state, freqs->new);
 
-	policy = cpufreq_cpu_data[freqs->cpu];
+	policy = per_cpu(cpufreq_cpu_data, freqs->cpu);
 	switch (state) {
 
 	case CPUFREQ_PRECHANGE:
@@ -828,8 +828,8 @@ static int cpufreq_add_dev(struct sys_de
 #ifdef CONFIG_SMP
 
 #ifdef CONFIG_HOTPLUG_CPU
-	if (cpufreq_cpu_governor[cpu]){
-		policy->governor = cpufreq_cpu_governor[cpu];
+	if (per_cpu(cpufreq_cpu_governor, cpu)) {
+		policy->governor = per_cpu(cpufreq_cpu_governor, cpu);
 		dprintk("Restoring governor %s for cpu %d\n",
 		       policy->governor->name, cpu);
 	}
@@ -854,7 +854,7 @@ static int cpufreq_add_dev(struct sys_de
 
 			spin_lock_irqsave(&cpufreq_driver_lock, flags);
 			managed_policy->cpus = policy->cpus;
-			cpufreq_cpu_data[cpu] = managed_policy;
+			per_cpu(cpufreq_cpu_data, cpu) = managed_policy;
 			spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 			dprintk("CPU already managed, adding link\n");
@@ -899,7 +899,7 @@ static int cpufreq_add_dev(struct sys_de
 
 	spin_lock_irqsave(&cpufreq_driver_lock, flags);
 	for_each_cpu_mask(j, policy->cpus) {
-		cpufreq_cpu_data[j] = policy;
+		per_cpu(cpufreq_cpu_data, j) = policy;
 		per_cpu(policy_cpu, j) = policy->cpu;
 	}
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
@@ -946,7 +946,7 @@ static int cpufreq_add_dev(struct sys_de
 err_out_unregister:
 	spin_lock_irqsave(&cpufreq_driver_lock, flags);
 	for_each_cpu_mask(j, policy->cpus)
-		cpufreq_cpu_data[j] = NULL;
+		per_cpu(cpufreq_cpu_data, j) = NULL;
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	kobject_put(&policy->kobj);
@@ -989,7 +989,7 @@ static int __cpufreq_remove_dev(struct s
 	dprintk("unregistering CPU %u\n", cpu);
 
 	spin_lock_irqsave(&cpufreq_driver_lock, flags);
-	data = cpufreq_cpu_data[cpu];
+	data = per_cpu(cpufreq_cpu_data, cpu);
 
 	if (!data) {
 		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
@@ -997,7 +997,7 @@ static int __cpufreq_remove_dev(struct s
 		unlock_policy_rwsem_write(cpu);
 		return -EINVAL;
 	}
-	cpufreq_cpu_data[cpu] = NULL;
+	per_cpu(cpufreq_cpu_data, cpu) = NULL;
 
 
 #ifdef CONFIG_SMP
@@ -1019,19 +1019,19 @@ static int __cpufreq_remove_dev(struct s
 #ifdef CONFIG_SMP
 
 #ifdef CONFIG_HOTPLUG_CPU
-	cpufreq_cpu_governor[cpu] = data->governor;
+	per_cpu(cpufreq_cpu_governor, cpu) = data->governor;
 #endif
 
 	/* if we have other CPUs still registered, we need to unlink them,
 	 * or else wait_for_completion below will lock up. Clean the
-	 * cpufreq_cpu_data[] while holding the lock, and remove the sysfs
-	 * links afterwards.
+	 * per_cpu(cpufreq_cpu_data) while holding the lock, and remove the
+	 * sysfs links afterwards.
 	 */
 	if (unlikely(cpus_weight(data->cpus) > 1)) {
 		for_each_cpu_mask(j, data->cpus) {
 			if (j == cpu)
 				continue;
-			cpufreq_cpu_data[j] = NULL;
+			per_cpu(cpufreq_cpu_data, j) = NULL;
 		}
 	}
 
@@ -1043,7 +1043,7 @@ static int __cpufreq_remove_dev(struct s
 				continue;
 			dprintk("removing link for cpu %u\n", j);
 #ifdef CONFIG_HOTPLUG_CPU
-			cpufreq_cpu_governor[j] = data->governor;
+			per_cpu(cpufreq_cpu_governor, j) = data->governor;
 #endif
 			cpu_sys_dev = get_cpu_sysdev(j);
 			sysfs_remove_link(&cpu_sys_dev->kobj, "cpufreq");
@@ -1153,7 +1153,7 @@ EXPORT_SYMBOL(cpufreq_quick_get);
 
 static unsigned int __cpufreq_get(unsigned int cpu)
 {
-	struct cpufreq_policy *policy = cpufreq_cpu_data[cpu];
+	struct cpufreq_policy *policy = per_cpu(cpufreq_cpu_data, cpu);
 	unsigned int ret_freq = 0;
 
 	if (!cpufreq_driver->get)
@@ -1822,16 +1822,19 @@ int cpufreq_register_driver(struct cpufr
 	cpufreq_driver = driver_data;
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
-	ret = sysdev_driver_register(&cpu_sysdev_class,&cpufreq_sysdev_driver);
+	ret = sysdev_driver_register(&cpu_sysdev_class,
+					&cpufreq_sysdev_driver);
 
 	if ((!ret) && !(cpufreq_driver->flags & CPUFREQ_STICKY)) {
 		int i;
 		ret = -ENODEV;
 
 		/* check for at least one working CPU */
-		for (i=0; i<NR_CPUS; i++)
-			if (cpufreq_cpu_data[i])
+		for (i = 0; i < nr_cpu_ids; i++)
+			if (cpu_possible(i) && per_cpu(cpufreq_cpu_data, i)) {
 				ret = 0;
+				break;
+			}
 
 		/* if all ->init() calls failed, unregister */
 		if (ret) {
diff -puN drivers/cpufreq/cpufreq_stats.c~cpufreq-change-cpu-freq-arrays-to-per_cpu-variables drivers/cpufreq/cpufreq_stats.c
--- a/drivers/cpufreq/cpufreq_stats.c~cpufreq-change-cpu-freq-arrays-to-per_cpu-variables
+++ a/drivers/cpufreq/cpufreq_stats.c
@@ -43,7 +43,7 @@ struct cpufreq_stats {
 #endif
 };
 
-static struct cpufreq_stats *cpufreq_stats_table[NR_CPUS];
+static DEFINE_PER_CPU(struct cpufreq_stats *, cpufreq_stats_table);
 
 struct cpufreq_stats_attribute {
 	struct attribute attr;
@@ -58,7 +58,7 @@ cpufreq_stats_update (unsigned int cpu)
 
 	cur_time = get_jiffies_64();
 	spin_lock(&cpufreq_stats_lock);
-	stat = cpufreq_stats_table[cpu];
+	stat = per_cpu(cpufreq_stats_table, cpu);
 	if (stat->time_in_state)
 		stat->time_in_state[stat->last_index] =
 			cputime64_add(stat->time_in_state[stat->last_index],
@@ -71,11 +71,11 @@ cpufreq_stats_update (unsigned int cpu)
 static ssize_t
 show_total_trans(struct cpufreq_policy *policy, char *buf)
 {
-	struct cpufreq_stats *stat = cpufreq_stats_table[policy->cpu];
+	struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, policy->cpu);
 	if (!stat)
 		return 0;
 	return sprintf(buf, "%d\n",
-			cpufreq_stats_table[stat->cpu]->total_trans);
+			per_cpu(cpufreq_stats_table, stat->cpu)->total_trans);
 }
 
 static ssize_t
@@ -83,7 +83,7 @@ show_time_in_state(struct cpufreq_policy
 {
 	ssize_t len = 0;
 	int i;
-	struct cpufreq_stats *stat = cpufreq_stats_table[policy->cpu];
+	struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, policy->cpu);
 	if (!stat)
 		return 0;
 	cpufreq_stats_update(stat->cpu);
@@ -101,7 +101,7 @@ show_trans_table(struct cpufreq_policy *
 	ssize_t len = 0;
 	int i, j;
 
-	struct cpufreq_stats *stat = cpufreq_stats_table[policy->cpu];
+	struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, policy->cpu);
 	if (!stat)
 		return 0;
 	cpufreq_stats_update(stat->cpu);
@@ -170,7 +170,7 @@ freq_table_get_index(struct cpufreq_stat
 
 static void cpufreq_stats_free_table(unsigned int cpu)
 {
-	struct cpufreq_stats *stat = cpufreq_stats_table[cpu];
+	struct cpufreq_stats *stat = per_cpu(cpufreq_stats_table, cpu);
 	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
 	if (policy && policy->cpu == cpu)
 		sysfs_remove_group(&policy->kobj, &stats_attr_group);
@@ -178,7 +178,7 @@ static void cpufreq_stats_free_table(uns
 		kfree(stat->time_in_state);
 		kfree(stat);
 	}
-	cpufreq_stats_table[cpu] = NULL;
+	per_cpu(cpufreq_stats_table, cpu) = NULL;
 	if (policy)
 		cpufreq_cpu_put(policy);
 }
@@ -192,7 +192,7 @@ cpufreq_stats_create_table (struct cpufr
 	struct cpufreq_policy *data;
 	unsigned int alloc_size;
 	unsigned int cpu = policy->cpu;
-	if (cpufreq_stats_table[cpu])
+	if (per_cpu(cpufreq_stats_table, cpu))
 		return -EBUSY;
 	if ((stat = kzalloc(sizeof(struct cpufreq_stats), GFP_KERNEL)) == NULL)
 		return -ENOMEM;
@@ -207,7 +207,7 @@ cpufreq_stats_create_table (struct cpufr
 		goto error_out;
 
 	stat->cpu = cpu;
-	cpufreq_stats_table[cpu] = stat;
+	per_cpu(cpufreq_stats_table, cpu) = stat;
 
 	for (i=0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
 		unsigned int freq = table[i].frequency;
@@ -251,7 +251,7 @@ error_out:
 	cpufreq_cpu_put(data);
 error_get_fail:
 	kfree(stat);
-	cpufreq_stats_table[cpu] = NULL;
+	per_cpu(cpufreq_stats_table, cpu) = NULL;
 	return ret;
 }
 
@@ -284,7 +284,7 @@ cpufreq_stat_notifier_trans (struct noti
 	if (val != CPUFREQ_POSTCHANGE)
 		return 0;
 
-	stat = cpufreq_stats_table[freq->cpu];
+	stat = per_cpu(cpufreq_stats_table, freq->cpu);
 	if (!stat)
 		return 0;
 
diff -puN drivers/cpufreq/freq_table.c~cpufreq-change-cpu-freq-arrays-to-per_cpu-variables drivers/cpufreq/freq_table.c
--- a/drivers/cpufreq/freq_table.c~cpufreq-change-cpu-freq-arrays-to-per_cpu-variables
+++ a/drivers/cpufreq/freq_table.c
@@ -169,7 +169,7 @@ int cpufreq_frequency_table_target(struc
 }
 EXPORT_SYMBOL_GPL(cpufreq_frequency_table_target);
 
-static struct cpufreq_frequency_table *show_table[NR_CPUS];
+static DEFINE_PER_CPU(struct cpufreq_frequency_table *, show_table);
 /**
  * show_available_freqs - show available frequencies for the specified CPU
  */
@@ -180,10 +180,10 @@ static ssize_t show_available_freqs (str
 	ssize_t count = 0;
 	struct cpufreq_frequency_table *table;
 
-	if (!show_table[cpu])
+	if (!per_cpu(show_table, cpu))
 		return -ENODEV;
 
-	table = show_table[cpu];
+	table = per_cpu(show_table, cpu);
 
 	for (i=0; (table[i].frequency != CPUFREQ_TABLE_END); i++) {
 		if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
@@ -212,20 +212,20 @@ void cpufreq_frequency_table_get_attr(st
 				      unsigned int cpu)
 {
 	dprintk("setting show_table for cpu %u to %p\n", cpu, table);
-	show_table[cpu] = table;
+	per_cpu(show_table, cpu) = table;
 }
 EXPORT_SYMBOL_GPL(cpufreq_frequency_table_get_attr);
 
 void cpufreq_frequency_table_put_attr(unsigned int cpu)
 {
 	dprintk("clearing show_table for cpu %u\n", cpu);
-	show_table[cpu] = NULL;
+	per_cpu(show_table, cpu) = NULL;
 }
 EXPORT_SYMBOL_GPL(cpufreq_frequency_table_put_attr);
 
 struct cpufreq_frequency_table *cpufreq_frequency_get_table(unsigned int cpu)
 {
-	return show_table[cpu];
+	return per_cpu(show_table, cpu);
 }
 EXPORT_SYMBOL_GPL(cpufreq_frequency_get_table);
 
_

Patches currently in -mm which might be from travis@sgi.com are

cpumask-remove-bitmap_scnprintf_len-and-cpumask_scnprintf_len.patch
linux-next.patch
acpi-change-processors-from-array-to-per_cpu-variable.patch
show_schedstat-fix-memleak.patch
mm-define-default-cpu_to_node.patch
mm-define-default-cpu_to_node-checkpatch-fixes.patch

