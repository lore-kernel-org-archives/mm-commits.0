From: akpm@linux-foundation.org
Subject: - allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default-kconfig-fix.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:56:14 -0700
Message-ID: <200710051956.l95JuEAs022338@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35958 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761117AbXJET4k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 15:56:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: trenn@suse.de, bunk@stusta.de, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     cpufreq: Only check for transition latency on problematic governors (kconfig fix)
has been removed from the -mm tree.  Its filename was
     allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default-kconfig-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cpufreq: Only check for transition latency on problematic governors (kconfig fix)
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
@@ -286,8 +286,9 @@ static inline unsigned int cpufreq_quick
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

git-cpufreq.patch
