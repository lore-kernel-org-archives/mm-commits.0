From: akpm@linux-foundation.org
Subject: + cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch added to -mm tree
Date: Mon, 30 Jul 2007 18:38:55 -0700
Message-ID: <200707310138.l6V1ctoV008835@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37088 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752102AbXGaBjh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 21:39:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: trenn@suse.de, ak@suse.de, benh@kernel.crashing.org, bryan.wu@analog.com, davej@redhat.com, davem@davemloft.net, lethal@linux-sh.org, paulus@samba.org, rmk@arm.linux.org.uk, tony.luck@intel.com, venkatesh.pallipadi@intel.com


The patch titled
     cpufreq: allow ondemand and conservative cpufreq governors to be used as default
has been added to the -mm tree.  Its filename is
     cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cpufreq: allow ondemand and conservative cpufreq governors to be used as default
From: Thomas Renninger <trenn@suse.de>

Depending on the transition latency of the HW for cpufreq switches, the
ondemand or conservative governor cannot be used with certain cpufreq
drivers.  Still the ondemand should be the default governor on a wide range
of systems.  This patch allows this and lets the governor fallback to the
performance governor at cpufreq driver load time, if the driver does not
support fast enough frequency switching.

Main benefit is that on e.g.  installation or other systems without
userspace support a working dynamic cpufreq support can be achieved on most
systems by simply loading the cpufreq driver.  This is especially essential
for recent x86(_64) laptop hardware which may rely on working dynamic
cpufreq OS support.

Signed-off-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Bryan Wu <bryan.wu@analog.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/Kconfig                |   27 +++++++++++++++++++----
 drivers/cpufreq/cpufreq.c              |   12 ++++++++++
 drivers/cpufreq/cpufreq_conservative.c |   19 +++++++---------
 drivers/cpufreq/cpufreq_ondemand.c     |   22 +++++++-----------
 include/linux/cpufreq.h                |   20 ++++++++++++++---
 5 files changed, 70 insertions(+), 30 deletions(-)

diff -puN drivers/cpufreq/Kconfig~cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default drivers/cpufreq/Kconfig
--- a/drivers/cpufreq/Kconfig~cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default
+++ a/drivers/cpufreq/Kconfig
@@ -56,10 +56,6 @@ config CPU_FREQ_STAT_DETAILS
 
 	  If in doubt, say N.
 
-# Note that it is not currently possible to set the other governors (such as ondemand)
-# as the default, since if they fail to initialise, cpufreq will be
-# left in an undefined state.
-
 choice
 	prompt "Default CPUFreq governor"
 	default CPU_FREQ_DEFAULT_GOV_USERSPACE if CPU_FREQ_SA1100 || CPU_FREQ_SA1110
@@ -85,6 +81,29 @@ config CPU_FREQ_DEFAULT_GOV_USERSPACE
 	  program shall be able to set the CPU dynamically without having
 	  to enable the userspace governor manually.
 
+config CPU_FREQ_DEFAULT_GOV_ONDEMAND
+	bool "ondemand"
+	select CPU_FREQ_GOV_ONDEMAND
+	select CPU_FREQ_GOV_PERFORMANCE
+	help
+	  Use the CPUFreq governor 'ondemand' as default. This allows
+	  you to get a full dynamic frequency capable system by simply
+	  loading your cpufreq low-level hardware driver.
+	  Be aware that not all cpufreq drivers support the ondemand
+	  governor. If unsure have a look at the help section of the
+	  driver. Fallback governor will be the performance governor.
+
+config CPU_FREQ_DEFAULT_GOV_CONSERVATIVE
+	bool "conservative"
+	select CPU_FREQ_GOV_CONSERVATIVE
+	select CPU_FREQ_GOV_PERFORMANCE
+	help
+	  Use the CPUFreq governor 'conservative' as default. This allows
+	  you to get a full dynamic frequency capable system by simply
+	  loading your cpufreq low-level hardware driver.
+	  Be aware that not all cpufreq drivers support the conservative
+	  governor. If unsure have a look at the help section of the
+	  driver. Fallback governor will be the performance governor.
 endchoice
 
 config CPU_FREQ_GOV_PERFORMANCE
diff -puN drivers/cpufreq/cpufreq.c~cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c~cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default
+++ a/drivers/cpufreq/cpufreq.c
@@ -1484,6 +1484,18 @@ static int __cpufreq_governor(struct cpu
 					unsigned int event)
 {
 	int ret;
+	struct cpufreq_governor *gov = CPUFREQ_PERFORMANCE_GOVERNOR;
+
+	if (policy->governor->max_transition_latency &&
+	    policy->cpuinfo.transition_latency >
+	    policy->governor->max_transition_latency) {
+		printk(KERN_WARNING "%s governor failed, too long"
+		       " transition latency of HW, fallback"
+		       " to %s governor\n",
+		       policy->governor->name,
+		       gov->name);
+		       policy->governor = gov;
+	}
 
 	if (!try_module_get(policy->governor->owner))
 		return -EINVAL;
diff -puN drivers/cpufreq/cpufreq_conservative.c~cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default drivers/cpufreq/cpufreq_conservative.c
--- a/drivers/cpufreq/cpufreq_conservative.c~cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default
+++ a/drivers/cpufreq/cpufreq_conservative.c
@@ -58,7 +58,7 @@ static unsigned int 				def_sampling_rat
 #define DEF_SAMPLING_RATE_LATENCY_MULTIPLIER	(1000)
 #define DEF_SAMPLING_DOWN_FACTOR		(1)
 #define MAX_SAMPLING_DOWN_FACTOR		(10)
-#define TRANSITION_LATENCY_LIMIT		(10 * 1000)
+#define TRANSITION_LATENCY_LIMIT		(10 * 1000 * 1000)
 
 static void do_dbs_timer(struct work_struct *work);
 
@@ -466,9 +466,6 @@ static int cpufreq_governor_dbs(struct c
 		    (!policy->cur))
 			return -EINVAL;
 
-		if (policy->cpuinfo.transition_latency >
-				(TRANSITION_LATENCY_LIMIT * 1000))
-			return -EINVAL;
 		if (this_dbs_info->enable) /* Already enabled */
 			break;
 		 
@@ -551,15 +548,17 @@ static int cpufreq_governor_dbs(struct c
 	return 0;
 }
 
-static struct cpufreq_governor cpufreq_gov_dbs = {
-	.name		= "conservative",
-	.governor	= cpufreq_governor_dbs,
-	.owner		= THIS_MODULE,
+struct cpufreq_governor cpufreq_gov_conservative = {
+	.name			= "conservative",
+	.governor		= cpufreq_governor_dbs,
+	.max_transition_latency	= TRANSITION_LATENCY_LIMIT,
+	.owner			= THIS_MODULE,
 };
+EXPORT_SYMBOL(cpufreq_gov_conservative);
 
 static int __init cpufreq_gov_dbs_init(void)
 {
-	return cpufreq_register_governor(&cpufreq_gov_dbs);
+	return cpufreq_register_governor(&cpufreq_gov_conservative);
 }
 
 static void __exit cpufreq_gov_dbs_exit(void)
@@ -567,7 +566,7 @@ static void __exit cpufreq_gov_dbs_exit(
 	/* Make sure that the scheduled work is indeed not running */
 	flush_scheduled_work();
 
-	cpufreq_unregister_governor(&cpufreq_gov_dbs);
+	cpufreq_unregister_governor(&cpufreq_gov_conservative);
 }
 
 
diff -puN drivers/cpufreq/cpufreq_ondemand.c~cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default drivers/cpufreq/cpufreq_ondemand.c
--- a/drivers/cpufreq/cpufreq_ondemand.c~cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default
+++ a/drivers/cpufreq/cpufreq_ondemand.c
@@ -47,7 +47,7 @@ static unsigned int def_sampling_rate;
 			(def_sampling_rate / MIN_SAMPLING_RATE_RATIO)
 #define MAX_SAMPLING_RATE			(500 * def_sampling_rate)
 #define DEF_SAMPLING_RATE_LATENCY_MULTIPLIER	(1000)
-#define TRANSITION_LATENCY_LIMIT		(10 * 1000)
+#define TRANSITION_LATENCY_LIMIT		(10 * 1000 * 1000)
 
 static void do_dbs_timer(struct work_struct *work);
 
@@ -508,12 +508,6 @@ static int cpufreq_governor_dbs(struct c
 		if ((!cpu_online(cpu)) || (!policy->cur))
 			return -EINVAL;
 
-		if (policy->cpuinfo.transition_latency >
-				(TRANSITION_LATENCY_LIMIT * 1000)) {
-			printk(KERN_WARNING "ondemand governor failed to load "
-			       "due to too long transition latency\n");
-			return -EINVAL;
-		}
 		if (this_dbs_info->enable) /* Already enabled */
 			break;
 
@@ -585,11 +579,13 @@ static int cpufreq_governor_dbs(struct c
 	return 0;
 }
 
-static struct cpufreq_governor cpufreq_gov_dbs = {
-	.name = "ondemand",
-	.governor = cpufreq_governor_dbs,
-	.owner = THIS_MODULE,
+struct cpufreq_governor cpufreq_gov_ondemand = {
+	.name			= "ondemand",
+	.governor		= cpufreq_governor_dbs,
+	.max_transition_latency = TRANSITION_LATENCY_LIMIT,
+	.owner			= THIS_MODULE,
 };
+EXPORT_SYMBOL(cpufreq_gov_ondemand);
 
 static int __init cpufreq_gov_dbs_init(void)
 {
@@ -598,12 +594,12 @@ static int __init cpufreq_gov_dbs_init(v
 		printk(KERN_ERR "Creation of kondemand failed\n");
 		return -EFAULT;
 	}
-	return cpufreq_register_governor(&cpufreq_gov_dbs);
+	return cpufreq_register_governor(&cpufreq_gov_ondemand);
 }
 
 static void __exit cpufreq_gov_dbs_exit(void)
 {
-	cpufreq_unregister_governor(&cpufreq_gov_dbs);
+	cpufreq_unregister_governor(&cpufreq_gov_ondemand);
 	destroy_workqueue(kondemand_wq);
 }
 
diff -puN include/linux/cpufreq.h~cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default include/linux/cpufreq.h
--- a/include/linux/cpufreq.h~cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default
+++ a/include/linux/cpufreq.h
@@ -163,6 +163,9 @@ struct cpufreq_governor {
 	char	name[CPUFREQ_NAME_LEN];
 	int 	(*governor)	(struct cpufreq_policy *policy,
 				 unsigned int event);
+	unsigned int max_transition_latency; /* HW must be able to switch to
+			next freq faster than this value in nano secs or we
+			will fallback to performance governor */
 	struct list_head	governor_list;
 	struct module		*owner;
 };
@@ -292,12 +295,23 @@ static inline unsigned int cpufreq_get(u
  *********************************************************************/
 
 
-#ifdef CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE
+/*
+  Performance governor is fallback governor if any other gov failed to
+  auto load due latency restrictions
+*/
 extern struct cpufreq_governor cpufreq_gov_performance;
-#define CPUFREQ_DEFAULT_GOVERNOR	&cpufreq_gov_performance
+#define CPUFREQ_PERFORMANCE_GOVERNOR	(&cpufreq_gov_performance)
+#ifdef CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE
+#define CPUFREQ_DEFAULT_GOVERNOR	(&cpufreq_gov_performance)
 #elif defined(CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE)
 extern struct cpufreq_governor cpufreq_gov_userspace;
-#define CPUFREQ_DEFAULT_GOVERNOR	&cpufreq_gov_userspace
+#define CPUFREQ_DEFAULT_GOVERNOR	(&cpufreq_gov_userspace)
+#elif defined(CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND)
+extern struct cpufreq_governor cpufreq_gov_ondemand;
+#define CPUFREQ_DEFAULT_GOVERNOR	(&cpufreq_gov_ondemand)
+#elif defined(CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE)
+extern struct cpufreq_governor cpufreq_gov_conservative;
+#define CPUFREQ_DEFAULT_GOVERNOR	(&cpufreq_gov_conservative)
 #endif
 
 
_

Patches currently in -mm which might be from trenn@suse.de are

origin.patch
exit-acpi-processor-module-gracefully-if-acpi-is-disabled.patch
cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core.patch
cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch
