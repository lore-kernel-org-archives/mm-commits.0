From: akpm@osdl.org
Subject: + rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix.patch added to -mm tree
Date: Tue, 02 Jan 2007 15:35:56 -0800
Message-ID: <200701022335.l02NZuno001319@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:44650 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbXABXgO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 18:36:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com, davej@codemonkey.org.uk, ego@in.ibm.com


The patch titled
     cpufreq lock rewrite bugfix - Fix locking in cpufreq_get
has been added to the -mm tree.  Its filename is
     rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 28 insertions(+), 18 deletions(-)

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
@@ -1074,25 +1075,13 @@ unsigned int cpufreq_quick_get(unsigned 
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
 
@@ -1106,11 +1095,32 @@ unsigned int cpufreq_get(unsigned int cp
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

git-cpufreq.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues.patch
rewrite-lock-in-cpufreq-to-eliminate-cpufreq-hotplug-related-issues-fix.patch
ondemand-governor-restructure-the-work-callback.patch
ondemand-governor-use-new-cpufreq-rwsem-locking-in-work-callback.patch
