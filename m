From: akpm@linux-foundation.org
Subject: - remove-hotplug-cpu-crap-from-cpufreq.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:55:56 -0800
Message-ID: <200702112255.l1BMtuFE016368@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60680 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932894AbXBKW4N (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:56:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Remove hotplug cpu crap from cpufreq
has been removed from the -mm tree.  Its filename was
     remove-hotplug-cpu-crap-from-cpufreq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove hotplug cpu crap from cpufreq
From: Dave Jones <davej@redhat.com>

The hotplug CPU locking in cpufreq is horrendous.  No-one seems to care
enough to fix it, so just remove it so that the 99.9% of the real world
users of this code can use cpufreq without being bothered by warnings.

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq.c              |   16 ----------------
 drivers/cpufreq/cpufreq_conservative.c |    2 --
 drivers/cpufreq/cpufreq_ondemand.c     |    2 --
 drivers/cpufreq/cpufreq_stats.c        |    2 --
 drivers/cpufreq/cpufreq_userspace.c    |    2 --
 5 files changed, 24 deletions(-)

diff -puN drivers/cpufreq/cpufreq.c~remove-hotplug-cpu-crap-from-cpufreq drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c~remove-hotplug-cpu-crap-from-cpufreq
+++ a/drivers/cpufreq/cpufreq.c
@@ -415,12 +415,10 @@ static ssize_t store_##file_name					\
 	if (ret != 1)							\
 		return -EINVAL;						\
 									\
-	lock_cpu_hotplug();						\
 	mutex_lock(&policy->lock);					\
 	ret = __cpufreq_set_policy(policy, &new_policy);		\
 	policy->user_policy.object = policy->object;			\
 	mutex_unlock(&policy->lock);					\
-	unlock_cpu_hotplug();						\
 									\
 	return ret ? ret : count;					\
 }
@@ -479,8 +477,6 @@ static ssize_t store_scaling_governor (s
 						&new_policy.governor))
 		return -EINVAL;
 
-	lock_cpu_hotplug();
-
 	/* Do not use cpufreq_set_policy here or the user_policy.max
 	   will be wrongly overridden */
 	mutex_lock(&policy->lock);
@@ -490,8 +486,6 @@ static ssize_t store_scaling_governor (s
 	policy->user_policy.governor = policy->governor;
 	mutex_unlock(&policy->lock);
 
-	unlock_cpu_hotplug();
-
 	if (ret)
 		return ret;
 	else
@@ -1278,7 +1272,6 @@ EXPORT_SYMBOL(cpufreq_unregister_notifie
  *********************************************************************/
 
 
-/* Must be called with lock_cpu_hotplug held */
 int __cpufreq_driver_target(struct cpufreq_policy *policy,
 			    unsigned int target_freq,
 			    unsigned int relation)
@@ -1304,13 +1297,11 @@ int cpufreq_driver_target(struct cpufreq
 	if (!policy)
 		return -EINVAL;
 
-	lock_cpu_hotplug();
 	mutex_lock(&policy->lock);
 
 	ret = __cpufreq_driver_target(policy, target_freq, relation);
 
 	mutex_unlock(&policy->lock);
-	unlock_cpu_hotplug();
 
 	cpufreq_cpu_put(policy);
 	return ret;
@@ -1338,7 +1329,6 @@ int cpufreq_driver_getavg(struct cpufreq
 EXPORT_SYMBOL_GPL(cpufreq_driver_getavg);
 
 /*
- * Locking: Must be called with the lock_cpu_hotplug() lock held
  * when "event" is CPUFREQ_GOV_LIMITS
  */
 
@@ -1433,7 +1423,6 @@ EXPORT_SYMBOL(cpufreq_get_policy);
 /*
  * data   : current policy.
  * policy : policy to be set.
- * Locking: Must be called with the lock_cpu_hotplug() lock held
  */
 static int __cpufreq_set_policy(struct cpufreq_policy *data,
 				struct cpufreq_policy *policy)
@@ -1539,8 +1528,6 @@ int cpufreq_set_policy(struct cpufreq_po
 	if (!data)
 		return -EINVAL;
 
-	lock_cpu_hotplug();
-
 	/* lock this CPU */
 	mutex_lock(&data->lock);
 
@@ -1552,7 +1539,6 @@ int cpufreq_set_policy(struct cpufreq_po
 
 	mutex_unlock(&data->lock);
 
-	unlock_cpu_hotplug();
 	cpufreq_cpu_put(data);
 
 	return ret;
@@ -1576,7 +1562,6 @@ int cpufreq_update_policy(unsigned int c
 	if (!data)
 		return -ENODEV;
 
-	lock_cpu_hotplug();
 	mutex_lock(&data->lock);
 
 	dprintk("updating policy for CPU %u\n", cpu);
@@ -1603,7 +1588,6 @@ int cpufreq_update_policy(unsigned int c
 	ret = __cpufreq_set_policy(data, &policy);
 
 	mutex_unlock(&data->lock);
-	unlock_cpu_hotplug();
 	cpufreq_cpu_put(data);
 	return ret;
 }
diff -puN drivers/cpufreq/cpufreq_conservative.c~remove-hotplug-cpu-crap-from-cpufreq drivers/cpufreq/cpufreq_conservative.c
--- a/drivers/cpufreq/cpufreq_conservative.c~remove-hotplug-cpu-crap-from-cpufreq
+++ a/drivers/cpufreq/cpufreq_conservative.c
@@ -430,14 +430,12 @@ static void dbs_check_cpu(int cpu)
 static void do_dbs_timer(struct work_struct *work)
 { 
 	int i;
-	lock_cpu_hotplug();
 	mutex_lock(&dbs_mutex);
 	for_each_online_cpu(i)
 		dbs_check_cpu(i);
 	schedule_delayed_work(&dbs_work, 
 			usecs_to_jiffies(dbs_tuners_ins.sampling_rate));
 	mutex_unlock(&dbs_mutex);
-	unlock_cpu_hotplug();
 } 
 
 static inline void dbs_timer_init(void)
diff -puN drivers/cpufreq/cpufreq_ondemand.c~remove-hotplug-cpu-crap-from-cpufreq drivers/cpufreq/cpufreq_ondemand.c
--- a/drivers/cpufreq/cpufreq_ondemand.c~remove-hotplug-cpu-crap-from-cpufreq
+++ a/drivers/cpufreq/cpufreq_ondemand.c
@@ -440,9 +440,7 @@ static void do_dbs_timer(struct work_str
 	dbs_info->sample_type = DBS_NORMAL_SAMPLE;
 	if (!dbs_tuners_ins.powersave_bias ||
 	    sample_type == DBS_NORMAL_SAMPLE) {
-		lock_cpu_hotplug();
 		dbs_check_cpu(dbs_info);
-		unlock_cpu_hotplug();
 		if (dbs_info->freq_lo) {
 			/* Setup timer for SUB_SAMPLE */
 			dbs_info->sample_type = DBS_SUB_SAMPLE;
diff -puN drivers/cpufreq/cpufreq_stats.c~remove-hotplug-cpu-crap-from-cpufreq drivers/cpufreq/cpufreq_stats.c
--- a/drivers/cpufreq/cpufreq_stats.c~remove-hotplug-cpu-crap-from-cpufreq
+++ a/drivers/cpufreq/cpufreq_stats.c
@@ -370,12 +370,10 @@ __exit cpufreq_stats_exit(void)
 	cpufreq_unregister_notifier(&notifier_trans_block,
 			CPUFREQ_TRANSITION_NOTIFIER);
 	unregister_hotcpu_notifier(&cpufreq_stat_cpu_notifier);
-	lock_cpu_hotplug();
 	for_each_online_cpu(cpu) {
 		cpufreq_stat_cpu_callback(&cpufreq_stat_cpu_notifier,
 						CPU_DEAD, (void *)(long)cpu);
 	}
-	unlock_cpu_hotplug();
 }
 
 MODULE_AUTHOR ("Zou Nan hai <nanhai.zou@intel.com>");
diff -puN drivers/cpufreq/cpufreq_userspace.c~remove-hotplug-cpu-crap-from-cpufreq drivers/cpufreq/cpufreq_userspace.c
--- a/drivers/cpufreq/cpufreq_userspace.c~remove-hotplug-cpu-crap-from-cpufreq
+++ a/drivers/cpufreq/cpufreq_userspace.c
@@ -71,7 +71,6 @@ static int cpufreq_set(unsigned int freq
 
 	dprintk("cpufreq_set for cpu %u, freq %u kHz\n", policy->cpu, freq);
 
-	lock_cpu_hotplug();
 	mutex_lock(&userspace_mutex);
 	if (!cpu_is_managed[policy->cpu])
 		goto err;
@@ -94,7 +93,6 @@ static int cpufreq_set(unsigned int freq
 
  err:
 	mutex_unlock(&userspace_mutex);
-	unlock_cpu_hotplug();
 	return ret;
 }
 
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
git-agpgart.patch
git-cpufreq.patch
