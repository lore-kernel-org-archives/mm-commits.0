From: akpm@linux-foundation.org
Subject: + restore-previously-used-governor-on-a-hot-replugged-cpu.patch added to -mm tree
Date: Thu, 28 Jun 2007 13:50:07 -0700
Message-ID: <200706282050.l5SKo7bH001289@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54651 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752646AbXF1Uu2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jun 2007 16:50:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: trenn@suse.de, davej@codemonkey.org.uk, malattia@linux.it


The patch titled
     Restore previously used governor on a hot-replugged CPU
has been added to the -mm tree.  Its filename is
     restore-previously-used-governor-on-a-hot-replugged-cpu.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Restore previously used governor on a hot-replugged CPU
From: Thomas Renninger <trenn@suse.de>

Negative side effect: needs NR_CPUs pointer array of memory in
CONFIG_HOTPLUG_CPU case.

Still needs userspace track keeping and rewriting of governors if governors
change while a CPU is not active (always the governor at CPU remove time is
restored).

Move of policy->user_policy.governor assignment is just a minor cleanup. 
http://bugzilla.kernel.org/show_bug.cgi?id=8671

Signed-off-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Mattia Dongili <malattia@linux.it>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletion(-)

diff -puN drivers/cpufreq/cpufreq.c~restore-previously-used-governor-on-a-hot-replugged-cpu drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c~restore-previously-used-governor-on-a-hot-replugged-cpu
+++ a/drivers/cpufreq/cpufreq.c
@@ -39,6 +39,10 @@
  */
 static struct cpufreq_driver *cpufreq_driver;
 static struct cpufreq_policy *cpufreq_cpu_data[NR_CPUS];
+#ifdef CONFIG_HOTPLUG_CPU
+/* This one keeps track of the previously set governor of a removed CPU */
+static struct cpufreq_governor *cpufreq_cpu_governor[NR_CPUS];
+#endif
 static DEFINE_SPINLOCK(cpufreq_driver_lock);
 
 /*
@@ -770,9 +774,17 @@ static int cpufreq_add_dev (struct sys_d
 	}
 	policy->user_policy.min = policy->cpuinfo.min_freq;
 	policy->user_policy.max = policy->cpuinfo.max_freq;
-	policy->user_policy.governor = policy->governor;
 
 #ifdef CONFIG_SMP
+
+#ifdef CONFIG_HOTPLUG_CPU
+	if (cpufreq_cpu_governor[cpu]){
+		policy->governor = cpufreq_cpu_governor[cpu];
+		dprintk("Restoring governor %s for cpu %d\n",
+		       policy->governor->name, cpu);
+	}
+#endif
+
 	for_each_cpu_mask(j, policy->cpus) {
 		if (cpu == j)
 			continue;
@@ -873,6 +885,7 @@ static int cpufreq_add_dev (struct sys_d
 	/* set default policy */
 	ret = __cpufreq_set_policy(policy, &new_policy);
 	policy->user_policy.policy = policy->policy;
+	policy->user_policy.governor = policy->governor;
 
 	unlock_policy_rwsem_write(cpu);
 
@@ -969,6 +982,11 @@ static int __cpufreq_remove_dev (struct 
 	}
 
 #ifdef CONFIG_SMP
+
+#ifdef CONFIG_HOTPLUG_CPU
+	cpufreq_cpu_governor[cpu] = data->governor;
+#endif
+
 	/* if we have other CPUs still registered, we need to unlink them,
 	 * or else wait_for_completion below will lock up. Clean the
 	 * cpufreq_cpu_data[] while holding the lock, and remove the sysfs
@@ -989,6 +1007,9 @@ static int __cpufreq_remove_dev (struct 
 			if (j == cpu)
 				continue;
 			dprintk("removing link for cpu %u\n", j);
+#ifdef CONFIG_HOTPLUG_CPU
+			cpufreq_cpu_governor[j] = data->governor;
+#endif
 			cpu_sys_dev = get_cpu_sysdev(j);
 			sysfs_remove_link(&cpu_sys_dev->kobj, "cpufreq");
 			cpufreq_cpu_put(data);
_

Patches currently in -mm which might be from trenn@suse.de are

git-acpi.patch
exit-acpi-processor-module-gracefully-if-acpi-is-disabled.patch
git-cpufreq.patch
restore-previously-used-governor-on-a-hot-replugged-cpu.patch
