From: akpm@linux-foundation.org
Subject: + powernow-k8-add-core-performance-boost-support.patch added to -mm tree
Date: Tue, 30 Mar 2010 15:43:53 -0700
Message-ID: <201003302243.o2UMhrWn009292@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750962Ab0C3Wol (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Mar 2010 18:44:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: borislav.petkov@amd.com, davej@codemonkey.org.uk, hpa@zytor.com, mark.langsdorf@amd.com, mingo@elte.hu, tglx@linutronix.de, trenn@suse.de


The patch titled
     powernow-k8: add core performance boost support
has been added to the -mm tree.  Its filename is
     powernow-k8-add-core-performance-boost-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powernow-k8: add core performance boost support
From: Borislav Petkov <borislav.petkov@amd.com>

Starting with F10h, revE, AMD processors add support for a dynamic core
boosting feature called Core Performance Boost.  When a specific condition
is present, a subset of the cores on a system are boosted beyond their P0
operating frequency to speed up the performance of single-threaded
applications.

In the normal case, the system comes out of reset with core boosting
enabled.  This patch adds a sysfs knob with which core boosting can be
switched on or off for benchmarking purposes.

While at it, cleanup the driver init codepath and update copyrights.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Reviewed-by: Thomas Renninger <trenn@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Mark Langsdorf <mark.langsdorf@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |  110 ++++++++++++++++++--
 arch/x86/kernel/cpu/cpufreq/powernow-k8.h |    2 
 2 files changed, 100 insertions(+), 12 deletions(-)

diff -puN arch/x86/kernel/cpu/cpufreq/powernow-k8.c~powernow-k8-add-core-performance-boost-support arch/x86/kernel/cpu/cpufreq/powernow-k8.c
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c~powernow-k8-add-core-performance-boost-support
+++ a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1,6 +1,5 @@
-
 /*
- *   (c) 2003-2006 Advanced Micro Devices, Inc.
+ *   (c) 2003-2010 Advanced Micro Devices, Inc.
  *  Your use of this code is subject to the terms and conditions of the
  *  GNU general public license version 2. See "COPYING" or
  *  http://www.gnu.org/licenses/gpl.html
@@ -54,6 +53,10 @@ static DEFINE_PER_CPU(struct powernow_k8
 
 static int cpu_family = CPU_OPTERON;
 
+/* core performance boost */
+static bool cpb_capable, cpb_enabled;
+static struct msr __percpu *msrs;
+
 #ifndef CONFIG_SMP
 static inline const struct cpumask *cpu_core_mask(int cpu)
 {
@@ -1393,8 +1396,73 @@ out:
 	return khz;
 }
 
+static void _cpb_toggle_msrs(bool t)
+{
+	int cpu;
+
+	rdmsr_on_cpus(cpu_online_mask, MSR_K7_HWCR, msrs);
+
+	for_each_cpu(cpu, cpu_online_mask) {
+		struct msr *reg = per_cpu_ptr(msrs, cpu);
+		if (t)
+			reg->l &= ~BIT(25);
+		else
+			reg->l |= BIT(25);
+	}
+	wrmsr_on_cpus(cpu_online_mask, MSR_K7_HWCR, msrs);
+}
+
+/*
+ * Switch on/off core performance boosting.
+ *
+ * 0=disable
+ * 1=enable.
+ */
+static void cpb_toggle(bool t)
+{
+	if (!cpb_capable)
+		return;
+
+	if (t && !cpb_enabled) {
+		cpb_enabled = true;
+		_cpb_toggle_msrs(t);
+		printk(KERN_INFO PFX "Core Boosting enabled.\n");
+	} else if (!t && cpb_enabled) {
+		cpb_enabled = false;
+		_cpb_toggle_msrs(t);
+		printk(KERN_INFO PFX "Core Boosting disabled.\n");
+	}
+}
+
+static ssize_t store_cpb(struct cpufreq_policy *policy, const char *buf,
+				 size_t count)
+{
+	int ret = -EINVAL;
+	unsigned long val = 0;
+
+	ret = strict_strtoul(buf, 10, &val);
+	if (!ret && (val == 0 || val == 1) && cpb_capable)
+		cpb_toggle(val);
+	else
+		return -EINVAL;
+
+	return count;
+}
+
+static ssize_t show_cpb(struct cpufreq_policy *policy, char *buf)
+{
+	return sprintf(buf, "%u\n", cpb_enabled);
+}
+
+#define define_one_rw(_name) \
+static struct freq_attr _name = \
+__ATTR(_name, 0644, show_##_name, store_##_name)
+
+define_one_rw(cpb);
+
 static struct freq_attr *powernow_k8_attr[] = {
 	&cpufreq_freq_attr_scaling_available_freqs,
+	&cpb,
 	NULL,
 };
 
@@ -1413,7 +1481,7 @@ static struct cpufreq_driver cpufreq_amd
 /* driver entry point for init */
 static int __cpuinit powernowk8_init(void)
 {
-	unsigned int i, supported_cpus = 0;
+	unsigned int i, supported_cpus = 0, cpu;
 
 	for_each_online_cpu(i) {
 		int rc;
@@ -1422,15 +1490,34 @@ static int __cpuinit powernowk8_init(voi
 			supported_cpus++;
 	}
 
-	if (supported_cpus == num_online_cpus()) {
-		printk(KERN_INFO PFX "Found %d %s "
-			"processors (%d cpu cores) (" VERSION ")\n",
-			num_online_nodes(),
-			boot_cpu_data.x86_model_id, supported_cpus);
-		return cpufreq_register_driver(&cpufreq_amd64_driver);
+	if (supported_cpus != num_online_cpus())
+		return -ENODEV;
+
+	printk(KERN_INFO PFX "Found %d %s (%d cpu cores) (" VERSION ")\n",
+		num_online_nodes(), boot_cpu_data.x86_model_id, supported_cpus);
+
+	if (boot_cpu_has(X86_FEATURE_CPB)) {
+
+		cpb_capable = true;
+
+		msrs = msrs_alloc();
+		if (!msrs) {
+			printk(KERN_ERR "%s: Error allocating msrs!\n", __func__);
+			return -ENOMEM;
+		}
+
+		rdmsr_on_cpus(cpu_online_mask, MSR_K7_HWCR, msrs);
+
+		for_each_cpu(cpu, cpu_online_mask) {
+			struct msr *reg = per_cpu_ptr(msrs, cpu);
+			cpb_enabled |= !(!!(reg->l & BIT(25)));
+		}
+
+		printk(KERN_INFO PFX "Core Performance Boosting: %s.\n",
+			(cpb_enabled ? "on" : "off"));
 	}
 
-	return -ENODEV;
+	return cpufreq_register_driver(&cpufreq_amd64_driver);
 }
 
 /* driver entry point for term */
@@ -1438,6 +1525,9 @@ static void __exit powernowk8_exit(void)
 {
 	dprintk("exit\n");
 
+	msrs_free(msrs);
+	msrs = NULL;
+
 	cpufreq_unregister_driver(&cpufreq_amd64_driver);
 }
 
diff -puN arch/x86/kernel/cpu/cpufreq/powernow-k8.h~powernow-k8-add-core-performance-boost-support arch/x86/kernel/cpu/cpufreq/powernow-k8.h
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h~powernow-k8-add-core-performance-boost-support
+++ a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
@@ -5,7 +5,6 @@
  *  http://www.gnu.org/licenses/gpl.html
  */
 
-
 enum pstate {
 	HW_PSTATE_INVALID = 0xff,
 	HW_PSTATE_0 = 0,
@@ -55,7 +54,6 @@ struct powernow_k8_data {
 	struct cpumask *available_cores;
 };
 
