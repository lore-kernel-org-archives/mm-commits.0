From: akpm@linux-foundation.org
Subject: - ondemand-governor-use-new-cpufreq-rwsem-locking-in-work-callback.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:56:03 -0800
Message-ID: <200702112256.l1BMu3Cf016377@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60877 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932916AbXBKXA7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 18:00:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: venkatesh.pallipadi@intel.com, davej@codemonkey.org.uk, ego@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ondemand governor use new cpufreq rwsem locking in work callback
has been removed from the -mm tree.  Its filename was
     ondemand-governor-use-new-cpufreq-rwsem-locking-in-work-callback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ondemand governor use new cpufreq rwsem locking in work callback
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Eliminate flush_workqueue in cpufreq_governor(STOP) callpath. Using flush
there has a deadlock potential as in

http://uwsg.iu.edu/hypermail/linux/kernel/0611.3/1223.html

Also, cleanup the locking issues with do_dbs_timer delayed_work callback.  As
it changes the CPU frequency using __cpufreq_target, it needs to have
policy_rwsem in write mode, which also protects it from hot plug.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq_ondemand.c |   34 ++++++++++++---------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff -puN drivers/cpufreq/cpufreq_ondemand.c~ondemand-governor-use-new-cpufreq-rwsem-locking-in-work-callback drivers/cpufreq/cpufreq_ondemand.c
--- a/drivers/cpufreq/cpufreq_ondemand.c~ondemand-governor-use-new-cpufreq-rwsem-locking-in-work-callback
+++ a/drivers/cpufreq/cpufreq_ondemand.c
@@ -437,8 +437,14 @@ static void do_dbs_timer(struct work_str
 
 	delay -= jiffies % delay;
 
-	if (!dbs_info->enable)
+	if (lock_policy_rwsem_write(cpu) < 0)
 		return;
+
+	if (!dbs_info->enable) {
+		unlock_policy_rwsem_write(cpu);
+		return;
+	}
+
 	/* Common NORMAL_SAMPLE setup */
 	dbs_info->sample_type = DBS_NORMAL_SAMPLE;
 	if (!dbs_tuners_ins.powersave_bias ||
@@ -455,6 +461,7 @@ static void do_dbs_timer(struct work_str
 	                        	CPUFREQ_RELATION_H);
 	}
 	queue_delayed_work_on(cpu, kondemand_wq, &dbs_info->work, delay);
+	unlock_policy_rwsem_write(cpu);
 }
 
 static inline void dbs_timer_init(struct cpu_dbs_info_s *dbs_info)
@@ -463,6 +470,7 @@ static inline void dbs_timer_init(struct
 	int delay = usecs_to_jiffies(dbs_tuners_ins.sampling_rate);
 	delay -= jiffies % delay;
 
+ 	dbs_info->enable = 1;
 	ondemand_powersave_bias_init();
 	dbs_info->sample_type = DBS_NORMAL_SAMPLE;
 	INIT_DELAYED_WORK_NAR(&dbs_info->work, do_dbs_timer);
@@ -474,7 +482,6 @@ static inline void dbs_timer_exit(struct
 {
 	dbs_info->enable = 0;
 	cancel_delayed_work(&dbs_info->work);
-	flush_workqueue(kondemand_wq);
 }
 
 static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
@@ -503,21 +510,9 @@ static int cpufreq_governor_dbs(struct c
 
 		mutex_lock(&dbs_mutex);
 		dbs_enable++;
-		if (dbs_enable == 1) {
-			kondemand_wq = create_workqueue("kondemand");
-			if (!kondemand_wq) {
-				printk(KERN_ERR
-					 "Creation of kondemand failed\n");
-				dbs_enable--;
-				mutex_unlock(&dbs_mutex);
-				return -ENOSPC;
-			}
-		}
 
 		rc = sysfs_create_group(&policy->kobj, &dbs_attr_group);
 		if (rc) {
-			if (dbs_enable == 1)
-				destroy_workqueue(kondemand_wq);
 			dbs_enable--;
 			mutex_unlock(&dbs_mutex);
 			return rc;
@@ -532,7 +527,6 @@ static int cpufreq_governor_dbs(struct c
 			j_dbs_info->prev_cpu_wall = get_jiffies_64();
 		}
 		this_dbs_info->cpu = cpu;
-		this_dbs_info->enable = 1;
 		/*
 		 * Start the timerschedule work, when this governor
 		 * is used for first time
@@ -562,9 +556,6 @@ static int cpufreq_governor_dbs(struct c
 		dbs_timer_exit(this_dbs_info);
 		sysfs_remove_group(&policy->kobj, &dbs_attr_group);
 		dbs_enable--;
-		if (dbs_enable == 0)
-			destroy_workqueue(kondemand_wq);
-
 		mutex_unlock(&dbs_mutex);
 
 		break;
@@ -593,12 +584,18 @@ static struct cpufreq_governor cpufreq_g
 
 static int __init cpufreq_gov_dbs_init(void)
 {
+	kondemand_wq = create_workqueue("kondemand");
+	if (!kondemand_wq) {
+		printk(KERN_ERR "Creation of kondemand failed\n");
+		return -EFAULT;
+	}
 	return cpufreq_register_governor(&cpufreq_gov_dbs);
 }
 
 static void __exit cpufreq_gov_dbs_exit(void)
 {
 	cpufreq_unregister_governor(&cpufreq_gov_dbs);
+	destroy_workqueue(kondemand_wq);
 }
 
 
@@ -610,3 +607,4 @@ MODULE_LICENSE("GPL");
 
 module_init(cpufreq_gov_dbs_init);
 module_exit(cpufreq_gov_dbs_exit);
+
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

git-cpufreq.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
