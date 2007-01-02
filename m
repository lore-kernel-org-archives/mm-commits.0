From: akpm@osdl.org
Subject: + rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues.patch added to -mm tree
Date: Tue, 02 Jan 2007 13:13:58 -0800
Message-ID: <200701022113.l02LDwAL029864@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:32800 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400AbXABVOY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 16:14:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com, davej@codemonkey.org.uk, ego@in.ibm.com


The patch titled
     Rewrite lock in cpufreq to eliminate cpufreq/hotplug related issues
has been added to the -mm tree.  Its filename is
     rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Rewrite lock in cpufreq to eliminate cpufreq/hotplug related issues
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Yet another attempt to resolve cpufreq and hotplug locking issues.

Patchset has 3 patches:
* Rewrite the lock infrastructure of cpufreq using a per cpu rwsem.
* Minor restructuring of work callback in ondemand driver.
* Use the new cpufreq rwsem infrastructure in ondemand work.

This patch:

Convert policy->lock to rwsem and move it to per_cpu area.
This rwsem will protect against both changing/accessing policy
related parameters and CPU hot plug/unplug.

Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/cpufreq/cpufreq.c |  197 +++++++++++++++++++++++++++---------
 include/linux/cpufreq.h   |   10 +
 2 files changed, 158 insertions(+), 49 deletions(-)

diff -puN drivers/cpufreq/cpufreq.c~rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c~rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues
+++ a/drivers/cpufreq/cpufreq.c
@@ -41,6 +41,64 @@ static struct cpufreq_driver *cpufreq_dr
 static struct cpufreq_policy *cpufreq_cpu_data[NR_CPUS];
 static DEFINE_SPINLOCK(cpufreq_driver_lock);
 
+/*
+ * cpu_policy_rwsem is a per CPU reader-writer semaphore designed to cure
+ * all cpufreq/hotplug/workqueue/etc related lock issues.
+ *
+ * The rules for this semaphore:
+ * - Any routine that wants to read from the policy structure will
+ *   do a down_read on this semaphore.
+ * - Any routine that will write to the policy structure and/or may take away
+ *   the policy altogether (eg. CPU hotplug), will hold this lock in write
+ *   mode before doing so.
+ *
+ * Additional rules:
+ * - All holders of the lock should check to make sure that the CPU they
+ *   are concerned with are online after they get the lock.
+ * - Governor routines that can be called in cpufreq hotplug path should not
+ *   take this sem as top level hotplug notifier handler takes this.
+ */
+static DEFINE_PER_CPU(int, policy_cpu);
+static DEFINE_PER_CPU(struct rw_semaphore, cpu_policy_rwsem);
+
+#define lock_policy_rwsem(mode, cpu)					\
+int lock_policy_rwsem_##mode						\
+(int cpu)								\
+{									\
+	int policy_cpu = per_cpu(policy_cpu, cpu);			\
+	BUG_ON(policy_cpu == -1);					\
+	down_##mode(&per_cpu(cpu_policy_rwsem, policy_cpu));		\
+	if (unlikely(!cpu_online(cpu))) {				\
+		up_##mode(&per_cpu(cpu_policy_rwsem, policy_cpu));	\
+		return -1;						\
+	}								\
+									\
+	return 0;							\
+}
+
+lock_policy_rwsem(read, cpu);
+EXPORT_SYMBOL_GPL(lock_policy_rwsem_read);
+
+lock_policy_rwsem(write, cpu);
+EXPORT_SYMBOL_GPL(lock_policy_rwsem_write);
+
+void unlock_policy_rwsem_read(int cpu)
+{
+	int policy_cpu = per_cpu(policy_cpu, cpu);
+	BUG_ON(policy_cpu == -1);
+	up_read(&per_cpu(cpu_policy_rwsem, policy_cpu));
+}
+EXPORT_SYMBOL_GPL(unlock_policy_rwsem_read);
+
+void unlock_policy_rwsem_write(int cpu)
+{
+	int policy_cpu = per_cpu(policy_cpu, cpu);
+	BUG_ON(policy_cpu == -1);
+	up_write(&per_cpu(cpu_policy_rwsem, policy_cpu));
+}
+EXPORT_SYMBOL_GPL(unlock_policy_rwsem_write);
+
+
 /* internal prototypes */
 static int __cpufreq_governor(struct cpufreq_policy *policy, unsigned int event);
 static void handle_update(struct work_struct *work);
@@ -415,10 +473,8 @@ static ssize_t store_##file_name					\
 	if (ret != 1)							\
 		return -EINVAL;						\
 									\
-	mutex_lock(&policy->lock);					\
 	ret = __cpufreq_set_policy(policy, &new_policy);		\
 	policy->user_policy.object = policy->object;			\
-	mutex_unlock(&policy->lock);					\
 									\
 	return ret ? ret : count;					\
 }
@@ -479,12 +535,10 @@ static ssize_t store_scaling_governor (s
 
 	/* Do not use cpufreq_set_policy here or the user_policy.max
 	   will be wrongly overridden */
-	mutex_lock(&policy->lock);
 	ret = __cpufreq_set_policy(policy, &new_policy);
 
 	policy->user_policy.policy = policy->policy;
 	policy->user_policy.governor = policy->governor;
-	mutex_unlock(&policy->lock);
 
 	if (ret)
 		return ret;
@@ -589,11 +643,17 @@ static ssize_t show(struct kobject * kob
 	policy = cpufreq_cpu_get(policy->cpu);
 	if (!policy)
 		return -EINVAL;
+
+	if (lock_policy_rwsem_read(policy->cpu) < 0)
+		return -EINVAL;
+
 	if (fattr->show)
 		ret = fattr->show(policy, buf);
 	else
 		ret = -EIO;
 
+	unlock_policy_rwsem_read(policy->cpu);
+
 	cpufreq_cpu_put(policy);
 	return ret;
 }
@@ -607,11 +667,17 @@ static ssize_t store(struct kobject * ko
 	policy = cpufreq_cpu_get(policy->cpu);
 	if (!policy)
 		return -EINVAL;
+
+	if (lock_policy_rwsem_write(policy->cpu) < 0)
+		return -EINVAL;
+
 	if (fattr->store)
 		ret = fattr->store(policy, buf, count);
 	else
 		ret = -EIO;
 
+	unlock_policy_rwsem_write(policy->cpu);
+
 	cpufreq_cpu_put(policy);
 	return ret;
 }
@@ -685,8 +751,10 @@ static int cpufreq_add_dev (struct sys_d
 	policy->cpu = cpu;
 	policy->cpus = cpumask_of_cpu(cpu);
 
-	mutex_init(&policy->lock);
-	mutex_lock(&policy->lock);
+	/* Initially set CPU itself as the policy_cpu */
+	per_cpu(policy_cpu, cpu) = cpu;
+	lock_policy_rwsem_write(cpu);
+
 	init_completion(&policy->kobj_unregister);
 	INIT_WORK(&policy->update, handle_update);
 
@@ -696,7 +764,7 @@ static int cpufreq_add_dev (struct sys_d
 	ret = cpufreq_driver->init(policy);
 	if (ret) {
 		dprintk("initialization failed\n");
-		mutex_unlock(&policy->lock);
+		unlock_policy_rwsem_write(cpu);
 		goto err_out;
 	}
 
@@ -710,6 +778,14 @@ static int cpufreq_add_dev (struct sys_d
 		 */
 		managed_policy = cpufreq_cpu_get(j);
 		if (unlikely(managed_policy)) {
+
+			/* Set proper policy_cpu */
+			unlock_policy_rwsem_write(cpu);
+			per_cpu(policy_cpu, cpu) = managed_policy->cpu;
+
+			if (lock_policy_rwsem_write(cpu) < 0)
+				goto err_out_driver_exit;
+
 			spin_lock_irqsave(&cpufreq_driver_lock, flags);
 			managed_policy->cpus = policy->cpus;
 			cpufreq_cpu_data[cpu] = managed_policy;
@@ -720,8 +796,8 @@ static int cpufreq_add_dev (struct sys_d
 					  &managed_policy->kobj, "cpufreq");
 
 			cpufreq_debug_enable_ratelimit();
-			mutex_unlock(&policy->lock);
 			ret = 0;
+			unlock_policy_rwsem_write(cpu);
 			goto err_out_driver_exit; /* call driver->exit() */
 		}
 	}
@@ -735,7 +811,7 @@ static int cpufreq_add_dev (struct sys_d
 
 	ret = kobject_register(&policy->kobj);
 	if (ret) {
-		mutex_unlock(&policy->lock);
+		unlock_policy_rwsem_write(cpu);
 		goto err_out_driver_exit;
 	}
 	/* set up files for this cpu device */
@@ -750,8 +826,10 @@ static int cpufreq_add_dev (struct sys_d
 		sysfs_create_file(&policy->kobj, &scaling_cur_freq.attr);
 
 	spin_lock_irqsave(&cpufreq_driver_lock, flags);
-	for_each_cpu_mask(j, policy->cpus)
+	for_each_cpu_mask(j, policy->cpus) {
 		cpufreq_cpu_data[j] = policy;
+		per_cpu(policy_cpu, j) = policy->cpu;
+	}
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	/* symlink affected CPUs */
@@ -770,7 +848,7 @@ static int cpufreq_add_dev (struct sys_d
 
 	policy->governor = NULL; /* to assure that the starting sequence is
 				  * run in cpufreq_set_policy */
-	mutex_unlock(&policy->lock);
+	unlock_policy_rwsem_write(cpu);
 
 	/* set default policy */
 	ret = cpufreq_set_policy(&new_policy);
@@ -811,11 +889,13 @@ module_out:
 
 
 /**
- * cpufreq_remove_dev - remove a CPU device
+ * __cpufreq_remove_dev - remove a CPU device
  *
  * Removes the cpufreq interface for a CPU device.
+ * Caller should already have policy_rwsem in write mode for this CPU.
+ * This routine frees the rwsem before returning.
  */
-static int cpufreq_remove_dev (struct sys_device * sys_dev)
+static int __cpufreq_remove_dev (struct sys_device * sys_dev)
 {
 	unsigned int cpu = sys_dev->id;
 	unsigned long flags;
@@ -834,6 +914,7 @@ static int cpufreq_remove_dev (struct sy
 	if (!data) {
 		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 		cpufreq_debug_enable_ratelimit();
+		unlock_policy_rwsem_write(cpu);
 		return -EINVAL;
 	}
 	cpufreq_cpu_data[cpu] = NULL;
@@ -850,6 +931,7 @@ static int cpufreq_remove_dev (struct sy
 		sysfs_remove_link(&sys_dev->kobj, "cpufreq");
 		cpufreq_cpu_put(data);
 		cpufreq_debug_enable_ratelimit();
+		unlock_policy_rwsem_write(cpu);
 		return 0;
 	}
 #endif
@@ -858,6 +940,7 @@ static int cpufreq_remove_dev (struct sy
 	if (!kobject_get(&data->kobj)) {
 		spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 		cpufreq_debug_enable_ratelimit();
+		unlock_policy_rwsem_write(cpu);
 		return -EFAULT;
 	}
 
@@ -891,10 +974,10 @@ static int cpufreq_remove_dev (struct sy
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 #endif
 
-	mutex_lock(&data->lock);
 	if (cpufreq_driver->target)
 		__cpufreq_governor(data, CPUFREQ_GOV_STOP);
-	mutex_unlock(&data->lock);
+
+	unlock_policy_rwsem_write(cpu);
 
 	kobject_unregister(&data->kobj);
 
@@ -918,6 +1001,18 @@ static int cpufreq_remove_dev (struct sy
 }
 
 
+static int cpufreq_remove_dev (struct sys_device * sys_dev)
+{
+	unsigned int cpu = sys_dev->id;
+	int retval;
+	if (unlikely(lock_policy_rwsem_write(cpu)))
+		BUG();
+
+	retval = __cpufreq_remove_dev(sys_dev);
+	return retval;
+}
+
+
 static void handle_update(struct work_struct *work)
 {
 	struct cpufreq_policy *policy =
@@ -965,9 +1060,12 @@ unsigned int cpufreq_quick_get(unsigned 
 	unsigned int ret_freq = 0;
 
 	if (policy) {
-		mutex_lock(&policy->lock);
+		if (unlikely(lock_policy_rwsem_read(cpu)))
+			return ret_freq;
+
 		ret_freq = policy->cur;
-		mutex_unlock(&policy->lock);
+
+		unlock_policy_rwsem_read(cpu);
 		cpufreq_cpu_put(policy);
 	}
 
@@ -993,7 +1091,8 @@ unsigned int cpufreq_get(unsigned int cp
 	if (!cpufreq_driver->get)
 		goto out;
 
-	mutex_lock(&policy->lock);
+	if (unlikely(lock_policy_rwsem_write(cpu)))
+		goto out;
 
 	ret_freq = cpufreq_driver->get(cpu);
 
@@ -1007,7 +1106,7 @@ unsigned int cpufreq_get(unsigned int cp
 		}
 	}
 
-	mutex_unlock(&policy->lock);
+	unlock_policy_rwsem_write(cpu);
 
 out:
 	cpufreq_cpu_put(policy);
@@ -1288,18 +1387,19 @@ int cpufreq_driver_target(struct cpufreq
 	if (!policy)
 		return -EINVAL;
 
-	mutex_lock(&policy->lock);
+	if (unlikely(lock_policy_rwsem_write(policy->cpu)))
+		return -EINVAL;
 
 	ret = __cpufreq_driver_target(policy, target_freq, relation);
 
-	mutex_unlock(&policy->lock);
+	unlock_policy_rwsem_write(policy->cpu);
 
 	cpufreq_cpu_put(policy);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(cpufreq_driver_target);
 
-int cpufreq_driver_getavg(struct cpufreq_policy *policy)
+int __cpufreq_driver_getavg(struct cpufreq_policy *policy)
 {
 	int ret = 0;
 
@@ -1307,17 +1407,13 @@ int cpufreq_driver_getavg(struct cpufreq
 	if (!policy)
 		return -EINVAL;
 
-	mutex_lock(&policy->lock);
-
 	if (cpu_online(policy->cpu) && cpufreq_driver->getavg)
 		ret = cpufreq_driver->getavg(policy->cpu);
 
-	mutex_unlock(&policy->lock);
-
 	cpufreq_cpu_put(policy);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(cpufreq_driver_getavg);
+EXPORT_SYMBOL_GPL(__cpufreq_driver_getavg);
 
 /*
  * when "event" is CPUFREQ_GOV_LIMITS
@@ -1401,9 +1497,7 @@ int cpufreq_get_policy(struct cpufreq_po
 	if (!cpu_policy)
 		return -EINVAL;
 
-	mutex_lock(&cpu_policy->lock);
 	memcpy(policy, cpu_policy, sizeof(struct cpufreq_policy));
-	mutex_unlock(&cpu_policy->lock);
 
 	cpufreq_cpu_put(cpu_policy);
 	return 0;
@@ -1519,8 +1613,9 @@ int cpufreq_set_policy(struct cpufreq_po
 	if (!data)
 		return -EINVAL;
 
-	/* lock this CPU */
-	mutex_lock(&data->lock);
+	if (unlikely(lock_policy_rwsem_write(policy->cpu)))
+		return -EINVAL;
+
 
 	ret = __cpufreq_set_policy(data, policy);
 	data->user_policy.min = data->min;
@@ -1528,7 +1623,7 @@ int cpufreq_set_policy(struct cpufreq_po
 	data->user_policy.policy = data->policy;
 	data->user_policy.governor = data->governor;
 
-	mutex_unlock(&data->lock);
+	unlock_policy_rwsem_write(policy->cpu);
 
 	cpufreq_cpu_put(data);
 
@@ -1553,7 +1648,8 @@ int cpufreq_update_policy(unsigned int c
 	if (!data)
 		return -ENODEV;
 
-	mutex_lock(&data->lock);
+	if (unlikely(lock_policy_rwsem_write(cpu)))
+		return -EINVAL;
 
 	dprintk("updating policy for CPU %u\n", cpu);
 	memcpy(&policy, data, sizeof(struct cpufreq_policy));
@@ -1578,7 +1674,8 @@ int cpufreq_update_policy(unsigned int c
 
 	ret = __cpufreq_set_policy(data, &policy);
 
-	mutex_unlock(&data->lock);
+	unlock_policy_rwsem_write(cpu);
+
 	cpufreq_cpu_put(data);
 	return ret;
 }
@@ -1588,31 +1685,28 @@ static int cpufreq_cpu_callback(struct n
 					unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
-	struct cpufreq_policy *policy;
 	struct sys_device *sys_dev;
+	struct cpufreq_policy *policy;
 
 	sys_dev = get_cpu_sysdev(cpu);
-
 	if (sys_dev) {
 		switch (action) {
 		case CPU_ONLINE:
 			cpufreq_add_dev(sys_dev);
 			break;
 		case CPU_DOWN_PREPARE:
-			/*
-			 * We attempt to put this cpu in lowest frequency
-			 * possible before going down. This will permit
-			 * hardware-managed P-State to switch other related
-			 * threads to min or higher speeds if possible.
-			 */
+			if (unlikely(lock_policy_rwsem_write(cpu)))
+				BUG();
+
 			policy = cpufreq_cpu_data[cpu];
 			if (policy) {
-				cpufreq_driver_target(policy, policy->min,
+				__cpufreq_driver_target(policy, policy->min,
 						CPUFREQ_RELATION_H);
 			}
+			__cpufreq_remove_dev(sys_dev);
 			break;
-		case CPU_DEAD:
-			cpufreq_remove_dev(sys_dev);
+		case CPU_DOWN_FAILED:
+			cpufreq_add_dev(sys_dev);
 			break;
 		}
 	}
@@ -1726,3 +1820,16 @@ int cpufreq_unregister_driver(struct cpu
 	return 0;
 }
 EXPORT_SYMBOL_GPL(cpufreq_unregister_driver);
+
+static int __init cpufreq_core_init(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		per_cpu(policy_cpu, cpu) = -1;
+		init_rwsem(&per_cpu(cpu_policy_rwsem, cpu));
+	}
+	return 0;
+}
+
+core_initcall(cpufreq_core_init);
diff -puN include/linux/cpufreq.h~rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues include/linux/cpufreq.h
--- a/include/linux/cpufreq.h~rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues
+++ a/include/linux/cpufreq.h
@@ -84,9 +84,6 @@ struct cpufreq_policy {
         unsigned int		policy; /* see above */
 	struct cpufreq_governor	*governor; /* see below */
 
- 	struct mutex		lock;   /* CPU ->setpolicy or ->target may
-					   only be called once a time */
-
 	struct work_struct	update; /* if update_policy() needs to be
 					 * called, but you're in IRQ context */
 
@@ -172,11 +169,16 @@ extern int __cpufreq_driver_target(struc
 				   unsigned int relation);
 
 
-extern int cpufreq_driver_getavg(struct cpufreq_policy *policy);
+extern int __cpufreq_driver_getavg(struct cpufreq_policy *policy);
 
 int cpufreq_register_governor(struct cpufreq_governor *governor);
 void cpufreq_unregister_governor(struct cpufreq_governor *governor);
 
+int lock_policy_rwsem_read(int cpu);
+int lock_policy_rwsem_write(int cpu);
+void unlock_policy_rwsem_read(int cpu);
+void unlock_policy_rwsem_write(int cpu);
+
 
 /*********************************************************************
  *                      CPUFREQ DRIVER INTERFACE                     *
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

git-cpufreq.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues.patch
ondemand-governor-restructure-the-work-callback.patch
ondemand-governor-use-new-cpufreq-rwsem-locking-in-work-callback.patch
