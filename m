From: akpm@linux-foundation.org
Subject: + allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default-kconfig-fix.patch added to -mm tree
Date: Thu, 02 Aug 2007 11:56:05 -0700
Message-ID: <200708021856.l72Iu5Pl004139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57813 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756612AbXHBS4c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Aug 2007 14:56:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: trenn@suse.de, bunk@stusta.de, davej@codemonkey.org.uk


The patch titled
     CPUfreq: Only check for transition latency on problematic governors (kconfig fix)
has been added to the -mm tree.  Its filename is
     allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default-kconfig-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: CPUfreq: Only check for transition latency on problematic governors (kconfig fix)
From: Thomas Renninger <trenn@suse.de>

Cc: Adrian Bunk <bunk@stusta.de>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpufreq/cpufreq.c |   27 ++++++++++++++++++++-------
 include/linux/cpufreq.h   |    3 ++-
 2 files changed, 22 insertions(+), 8 deletions(-)

diff -puN drivers/cpufreq/cpufreq.c~allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default-kconfig-fix drivers/cpufreq/cpufreq.c
--- a/drivers/cpufreq/cpufreq.c~allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default-kconfig-fix
+++ a/drivers/cpufreq/cpufreq.c
@@ -1484,17 +1484,30 @@ static int __cpufreq_governor(struct cpu
 					unsigned int event)
 {
 	int ret;
-	struct cpufreq_governor *gov = CPUFREQ_PERFORMANCE_GOVERNOR;
+
+	/* Only must be defined when default governor is known to have latency
+	   restrictions, like e.g. conservative or ondemand.
+	   That this is the case is already ensured in Kconfig
+	*/
+#ifdef CONFIG_CPU_FREQ_GOV_PERFORMANCE
+	struct cpufreq_governor *gov = &cpufreq_gov_performance;
+#else
+	struct cpufreq_governor *gov = NULL;
+#endif
 
 	if (policy->governor->max_transition_latency &&
 	    policy->cpuinfo.transition_latency >
 	    policy->governor->max_transition_latency) {
-		printk(KERN_WARNING "%s governor failed, too long"
-		       " transition latency of HW, fallback"
-		       " to %s governor\n",
-		       policy->governor->name,
-		       gov->name);
-		       policy->governor = gov;
+		if (!gov)
+			return -EINVAL;
+		else {
+			printk(KERN_WARNING "%s governor failed, too long"
+			       " transition latency of HW, fallback"
+			       " to %s governor\n",
+			       policy->governor->name,
+			       gov->name);
+			policy->governor = gov;
+		}
 	}
 
 	if (!try_module_get(policy->governor->owner))
diff -puN include/linux/cpufreq.h~allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default-kconfig-fix include/linux/cpufreq.h
--- a/include/linux/cpufreq.h~allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default-kconfig-fix
+++ a/include/linux/cpufreq.h
@@ -299,8 +299,9 @@ static inline unsigned int cpufreq_get(u
   Performance governor is fallback governor if any other gov failed to
   auto load due latency restrictions
 */
+#ifdef CONFIG_CPU_FREQ_GOV_PERFORMANCE
 extern struct cpufreq_governor cpufreq_gov_performance;
-#define CPUFREQ_PERFORMANCE_GOVERNOR	(&cpufreq_gov_performance)
+#endif
 #ifdef CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE
 #define CPUFREQ_DEFAULT_GOVERNOR	(&cpufreq_gov_performance)
 #elif defined(CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE)
_

Patches currently in -mm which might be from trenn@suse.de are

origin.patch
exit-acpi-processor-module-gracefully-if-acpi-is-disabled.patch
cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core.patch
cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch
allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default-kconfig-fix.patch
