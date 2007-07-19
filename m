From: akpm@linux-foundation.org
Subject: - cell-cbe_cpufreq-fix-minor-issues.patch removed from -mm tree
Date: Wed, 18 Jul 2007 17:23:35 -0700
Message-ID: <200707190023.l6J0NZsS004729@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47255 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760972AbXGSAXp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 20:23:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krafft@de.ibm.com, arnd.bergmann@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cell: cbe_cpufreq: fix minor issues
has been removed from the -mm tree.  Its filename was
     cell-cbe_cpufreq-fix-minor-issues.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: cell: cbe_cpufreq: fix minor issues
From: Christian Krafft <krafft@de.ibm.com>

Minor issues have been fixed:
* added a missing call to of_node_put()
* signedness of a function parameter
* added some line breaks
* changed global pmi_frequency_limit to a
  per node pmi_slow_mode_limit array

Signed-off-by: Christian Krafft <krafft@de.ibm.com>
Signed-off-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/cbe_cpufreq.c |   58 +++++++++++++-------
 1 files changed, 40 insertions(+), 18 deletions(-)

diff -puN arch/powerpc/platforms/cell/cbe_cpufreq.c~cell-cbe_cpufreq-fix-minor-issues arch/powerpc/platforms/cell/cbe_cpufreq.c
--- a/arch/powerpc/platforms/cell/cbe_cpufreq.c~cell-cbe_cpufreq-fix-minor-issues
+++ a/arch/powerpc/platforms/cell/cbe_cpufreq.c
@@ -67,7 +67,7 @@ static u64 MIC_Slow_Next_Timer_table[] =
 	0x00003FC000000000ull,
 };
 
-static unsigned int pmi_frequency_limit = 0;
+static u8 pmi_slow_mode_limit[MAX_BE];
 
 /*
  * hardware specific functions
@@ -169,35 +169,50 @@ static int set_pmode_reg(int cpu, unsign
 
 static int set_pmode(int cpu, unsigned int slow_mode)
 {
+	int rc;
 #ifdef CONFIG_PPC_PMI
 	if (cbe_cpufreq_has_pmi)
-		return set_pmode_pmi(cpu, slow_mode);
+		rc = set_pmode_pmi(cpu, slow_mode);
+	else
 #endif
-	return set_pmode_reg(cpu, slow_mode);
+		rc = set_pmode_reg(cpu, slow_mode);
+
+	pr_debug("register contains slow mode %d\n", get_pmode(cpu));
+
+	return rc;
 }
 
 static void cbe_cpufreq_handle_pmi(pmi_message_t pmi_msg)
 {
-	u8 cpu;
-	u8 cbe_pmode_new;
+	u8 node; slow_mode;
 
 	BUG_ON(pmi_msg.type != PMI_TYPE_FREQ_CHANGE);
 
-	cpu = cbe_node_to_cpu(pmi_msg.data1);
-	cbe_pmode_new = pmi_msg.data2;
+	node = pmi_msg.data1;
+	slow_mode = pmi_msg.data2;
 
-	pmi_frequency_limit = cbe_freqs[cbe_pmode_new].frequency;
+	pmi_slow_mode_limit[node] = slow_mode;
 
-	pr_debug("cbe_handle_pmi: max freq=%d\n", pmi_frequency_limit);
+	pr_debug("cbe_handle_pmi: node: %d, max slow_mode=%d\n", slow_mode);
 }
 
 static int pmi_notifier(struct notifier_block *nb,
 				       unsigned long event, void *data)
 {
 	struct cpufreq_policy *policy = data;
+	u8 node;
+
+	node = cbe_cpu_to_node(policy->cpu);
+
+	pr_debug("got notified, event=%lu, node=%u\n", event, node);
 
-	if (pmi_frequency_limit)
-		cpufreq_verify_within_limits(policy, 0, pmi_frequency_limit);
+	if (pmi_slow_mode_limit[node] != 0) {
+		pr_debug("limiting node %d to slow mode %d\n",
+			 node, pmi_slow_mode_limit[node]);
+
+		cpufreq_verify_within_limits(policy, 0,
+			 cbe_freqs[pmi_slow_mode_limit[node]].frequency);
+	}
 
 	return 0;
 }
@@ -232,6 +247,8 @@ static int cbe_cpufreq_cpu_init(struct c
 
 	max_freqp = of_get_property(cpu, "clock-frequency", NULL);
 
+	of_node_put(cpu);
+
 	if (!max_freqp)
 		return -EINVAL;
 
@@ -248,7 +265,9 @@ static int cbe_cpufreq_cpu_init(struct c
 	}
 
 	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
-	/* if DEBUG is enabled set_pmode() measures the correct latency of a transition */
+
+	/* if DEBUG is enabled set_pmode() measures the latency
+	 * of a transition */
 	policy->cpuinfo.transition_latency = 25000;
 
 	cur_pmode = get_pmode(policy->cpu);
@@ -262,8 +281,8 @@ static int cbe_cpufreq_cpu_init(struct c
 
 	cpufreq_frequency_table_get_attr(cbe_freqs, policy->cpu);
 
-
-	/* this ensures that policy->cpuinfo_min and policy->cpuinfo_max are set correctly */
+	/* this ensures that policy->cpuinfo_min
+	 * and policy->cpuinfo_max are set correctly */
 	return cpufreq_frequency_table_cpuinfo(policy, cbe_freqs);
 }
 
@@ -279,12 +298,13 @@ static int cbe_cpufreq_verify(struct cpu
 }
 
 
-static int cbe_cpufreq_target(struct cpufreq_policy *policy, unsigned int target_freq,
-			    unsigned int relation)
+static int cbe_cpufreq_target(struct cpufreq_policy *policy,
+			      unsigned int target_freq,
+			      unsigned int relation)
 {
 	int rc;
 	struct cpufreq_freqs freqs;
-	int cbe_pmode_new;
+	unsigned int cbe_pmode_new;
 
 	cpufreq_frequency_table_target(policy,
 				       cbe_freqs,
@@ -299,12 +319,14 @@ static int cbe_cpufreq_target(struct cpu
 	mutex_lock(&cbe_switch_mutex);
 	cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 
-	pr_debug("setting frequency for cpu %d to %d kHz, 1/%d of max frequency\n",
+	pr_debug("setting frequency for cpu %d to %d kHz, " \
+		 "1/%d of max frequency\n",
 		 policy->cpu,
 		 cbe_freqs[cbe_pmode_new].frequency,
 		 cbe_freqs[cbe_pmode_new].index);
 
 	rc = set_pmode(policy->cpu, cbe_pmode_new);
+
 	cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	mutex_unlock(&cbe_switch_mutex);
 
_

Patches currently in -mm which might be from krafft@de.ibm.com are

cell-cbe_cpufreq-fix-minor-issues.patch
cell-cbe_cpufreq-reorganize-code.patch
cell-fix-cbe_cpufreq-for-legacy-slof-tree.patch
cell-fix-cbe_regc-for-legacy-slof-tree.patch
cell-fix-cbe_thermal-for-legacy-slof-tree.patch
cell-allow-linux-to-map-cell-regs-on-legacy-slof-tree.patch
