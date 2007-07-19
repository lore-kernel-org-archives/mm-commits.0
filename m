From: akpm@linux-foundation.org
Subject: - cell-cbe_cpufreq-fix-initialization.patch removed from -mm tree
Date: Wed, 18 Jul 2007 17:23:32 -0700
Message-ID: <200707190023.l6J0NWOT004726@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42878 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761586AbXGSAXm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 20:23:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krafft@de.ibm.com, arnd.bergmann@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cell: cbe_cpufreq: fix initialization
has been removed from the -mm tree.  Its filename was
     cell-cbe_cpufreq-fix-initialization.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: cell: cbe_cpufreq: fix initialization
From: Christian Krafft <krafft@de.ibm.com>

This patch fixes the initialization of the cbe_cpufreq driver.

The code that initializes the PMI related functions was called per cpu:

* registering cpufreq notifier block
* registering a pmi handler

This ends in a bug that the notifier block gets called in an endless loop. 
The initialization code is being put to the module init code path by this
patch.  This way it only gets called once.

Signed-off-by: Christian Krafft <krafft@de.ibm.com>
Signed-off-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/cbe_cpufreq.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff -puN arch/powerpc/platforms/cell/cbe_cpufreq.c~cell-cbe_cpufreq-fix-initialization arch/powerpc/platforms/cell/cbe_cpufreq.c
--- a/arch/powerpc/platforms/cell/cbe_cpufreq.c~cell-cbe_cpufreq-fix-initialization
+++ a/arch/powerpc/platforms/cell/cbe_cpufreq.c
@@ -196,10 +196,9 @@ static int pmi_notifier(struct notifier_
 {
 	struct cpufreq_policy *policy = data;
 
-	if (event != CPUFREQ_INCOMPATIBLE)
-		return 0;
+	if (pmi_frequency_limit)
+		cpufreq_verify_within_limits(policy, 0, pmi_frequency_limit);
 
-	cpufreq_verify_within_limits(policy, 0, pmi_frequency_limit);
 	return 0;
 }
 
@@ -263,11 +262,6 @@ static int cbe_cpufreq_cpu_init(struct c
 
 	cpufreq_frequency_table_get_attr(cbe_freqs, policy->cpu);
 
-	if (cbe_cpufreq_has_pmi) {
-		/* frequency might get limited later, initialize limit with max_freq */
-		pmi_frequency_limit = max_freq;
-		cpufreq_register_notifier(&pmi_notifier_block, CPUFREQ_POLICY_NOTIFIER);
-	}
 
 	/* this ensures that policy->cpuinfo_min and policy->cpuinfo_max are set correctly */
 	return cpufreq_frequency_table_cpuinfo(policy, cbe_freqs);
@@ -275,9 +269,6 @@ static int cbe_cpufreq_cpu_init(struct c
 
 static int cbe_cpufreq_cpu_exit(struct cpufreq_policy *policy)
 {
-	if (cbe_cpufreq_has_pmi)
-		cpufreq_unregister_notifier(&pmi_notifier_block, CPUFREQ_POLICY_NOTIFIER);
-
 	cpufreq_frequency_table_put_attr(policy->cpu);
 	return 0;
 }
@@ -341,6 +332,9 @@ static int __init cbe_cpufreq_init(void)
 
 	cbe_cpufreq_has_pmi = pmi_register_handler(&cbe_pmi_handler) == 0;
 
+	if (cbe_cpufreq_has_pmi)
+		cpufreq_register_notifier(&pmi_notifier_block, CPUFREQ_POLICY_NOTIFIER);
+
 	return cpufreq_register_driver(&cbe_cpufreq_driver);
 }
 
@@ -348,8 +342,10 @@ static void __exit cbe_cpufreq_exit(void
 {
 	cpufreq_unregister_driver(&cbe_cpufreq_driver);
 
-	if (cbe_cpufreq_has_pmi)
+	if (cbe_cpufreq_has_pmi) {
+		cpufreq_unregister_notifier(&pmi_notifier_block, CPUFREQ_POLICY_NOTIFIER);
 		pmi_unregister_handler(&cbe_pmi_handler);
+	}
 }
 
 module_init(cbe_cpufreq_init);
_

Patches currently in -mm which might be from krafft@de.ibm.com are

cell-cbe_cpufreq-fix-initialization.patch
cell-cbe_cpufreq-fix-minor-issues.patch
cell-cbe_cpufreq-reorganize-code.patch
cell-fix-cbe_cpufreq-for-legacy-slof-tree.patch
cell-fix-cbe_regc-for-legacy-slof-tree.patch
cell-fix-cbe_thermal-for-legacy-slof-tree.patch
cell-allow-linux-to-map-cell-regs-on-legacy-slof-tree.patch
