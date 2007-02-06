From: akpm@linux-foundation.org
Subject: - rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix.patch removed from -mm tree
Date: Mon, 05 Feb 2007 16:11:01 -0800
Message-ID: <200702060012.l160C4ew003832@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40780 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965220AbXBFAM0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 19:12:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: venkatesh.pallipadi@intel.com, davej@codemonkey.org.uk, ego@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cpufreq lock rewrite bugfix - Fix locking in cpufreq_get
has been removed from the -mm tree.  Its filename was
     rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix.patch

This patch was dropped because it was folded into rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues.patch

------------------------------------------------------
Subject: cpufreq lock rewrite bugfix - Fix locking in cpufreq_get
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Incremental bugfix to previous 3 patch patchset of cpufreq lock rewrite.

There was one code path in cpufreq_get, that was using the write lock
in place of read and also potential recursive lock with sysfs
interface of cpuinfo_cur_freq.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/cpufreq/cpufreq.c |   46 +++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff -puN drivers/cpufreq/cpufreq.c~rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c~rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix
+++ a/drivers/cpufreq/cpufreq.c
@@ -101,6 +101,7 @@ EXPORT_SYMBOL_GPL(unlock_policy_rwsem_wr
 
 /* internal prototypes */
 static int __cpufreq_governor(struct cpufreq_policy *policy, unsigned int event);
+static unsigned int __cpufreq_get(unsigned int cpu);
 static void handle_update(struct work_struct *work);
 
 /**
@@ -488,7 +489,7 @@ store_one(scaling_max_freq,max);
 static ssize_t show_cpuinfo_cur_freq (struct cpufreq_policy * policy,
 							char *buf)
 {
-	unsigned int cur_freq = cpufreq_get(policy->cpu);
+	unsigned int cur_freq = __cpufreq_get(policy->cpu);
 	if (!cur_freq)
 		return sprintf(buf, "<unknown>");
 	return sprintf(buf, "%u\n", cur_freq);
@@ -1083,25 +1084,13 @@ unsigned int cpufreq_quick_get(unsigned 
 EXPORT_SYMBOL(cpufreq_quick_get);
 
 
-/**
- * cpufreq_get - get the current CPU frequency (in kHz)
- * @cpu: CPU number
- *
- * Get the CPU current (static) CPU frequency
- */
-unsigned int cpufreq_get(unsigned int cpu)
+static unsigned int __cpufreq_get(unsigned int cpu)
 {
-	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
+	struct cpufreq_policy *policy = cpufreq_cpu_data[cpu];
 	unsigned int ret_freq = 0;
 
-	if (!policy)
-		return 0;
-
 	if (!cpufreq_driver->get)
-		goto out;
-
-	if (unlikely(lock_policy_rwsem_write(cpu)))
-		goto out;
+		return (ret_freq);
 
 	ret_freq = cpufreq_driver->get(cpu);
 
@@ -1115,11 +1104,32 @@ unsigned int cpufreq_get(unsigned int cp
 		}
 	}
 
-	unlock_policy_rwsem_write(cpu);
+	return (ret_freq);
+}
+
+/**
+ * cpufreq_get - get the current CPU frequency (in kHz)
+ * @cpu: CPU number
+ *
+ * Get the CPU current (static) CPU frequency
+ */
+unsigned int cpufreq_get(unsigned int cpu)
+{
+	unsigned int ret_freq = 0;
+	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
+
+	if (!policy)
+		goto out;
+
+	if (unlikely(lock_policy_rwsem_read(cpu)))
+		goto out;
+
+	ret_freq = __cpufreq_get(cpu);
+
+	unlock_policy_rwsem_read(cpu);
 
 out:
 	cpufreq_cpu_put(policy);
-
 	return (ret_freq);
 }
 EXPORT_SYMBOL(cpufreq_get);
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix-2.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix-3.patch
ondemand-governor-restructure-the-work-callback.patch
ondemand-governor-use-new-cpufreq-rwsem-locking-in-work-callback.patch
workqueue-fix-freezeable-workqueues-implementation.patch
workqueue-fix-flush_workqueue-vs-cpu_dead-race.patch
workqueue-dont-clear-cwq-thread-until-it-exits.patch
workqueue-dont-migrate-pending-works-from-the-dead-cpu.patch
