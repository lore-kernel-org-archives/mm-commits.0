From: akpm@linux-foundation.org
Subject: [to-be-updated] cpufreq-powernow-k8-add-core-performance-boost-support.patch removed from -mm tree
Date: Thu, 04 Mar 2010 14:04:35 -0800
Message-ID: <201003042204.o24M4ZPn032615@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755247Ab0CDWFS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Mar 2010 17:05:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mark.langsdorf@amd.com, borislav.petkov@amd.com, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     cpufreq: powernow-k8: add core performance boost support
has been removed from the -mm tree.  Its filename was
     cpufreq-powernow-k8-add-core-performance-boost-support.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpufreq: powernow-k8: add core performance boost support
From: Mark Langsdorf <mark.langsdorf@amd.com>

Add CPUID check for hardware CPB support

Also, update copyright while at it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   41 ++++++++++++++++++--
 arch/x86/kernel/cpu/cpufreq/powernow-k8.h |    3 -
 include/linux/cpufreq.h                   |    4 +
 3 files changed, 42 insertions(+), 6 deletions(-)

diff -puN arch/x86/kernel/cpu/cpufreq/powernow-k8.c~cpufreq-powernow-k8-add-core-performance-boost-support arch/x86/kernel/cpu/cpufreq/powernow-k8.c
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c~cpufreq-powernow-k8-add-core-performance-boost-support
+++ a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1,6 +1,5 @@
-
 /*
- *   (c) 2003-2006 Advanced Micro Devices, Inc.
+ *   (c) 2003-2009 Advanced Micro Devices, Inc.
  *  Your use of this code is subject to the terms and conditions of the
  *  GNU general public license version 2. See "COPYING" or
  *  http://www.gnu.org/licenses/gpl.html
@@ -57,6 +56,9 @@ static int cpu_family = CPU_OPTERON;
 
 static struct cpufreq_driver cpufreq_amd64_driver;
 
+/* core performance boost */
+static bool cpb_capable;
+
 #ifndef CONFIG_SMP
 static inline const struct cpumask *cpu_core_mask(int cpu)
 {
@@ -511,6 +513,24 @@ static int core_voltage_post_transition(
 	return 0;
 }
 
+/* CPB 0=disable, 1=enable. */
+static void cpb_toggle(u32 t)
+{
+	if (cpb_capable) {
+		u32 lo, hi;
+		rdmsr(MSR_K7_HWCR, lo, hi);
+
+		if (t)
+			lo &= ~(1 << 25);
+		else
+			lo |= (1 << 25);
+
+		wrmsr(MSR_K7_HWCR, lo, hi);
+
+		printk(KERN_ERR "CPB: %s.\n", (t ? "on" : "off"));
+	}
+}
+
 static void check_supported_cpu(void *_rc)
 {
 	u32 eax, ebx, ecx, edx;
@@ -1173,8 +1193,8 @@ static int powernowk8_target(struct cpuf
 		}
 	}
 
-	if (cpufreq_frequency_table_target(pol, data->powernow_table,
-				targfreq, relation, &newstate))
+	if (cpufreq_frequency_table_target(pol, data->powernow_table, targfreq,
+					   relation, &newstate))
 		goto err_out;
 
 	mutex_lock(&fidvid_mutex);
@@ -1191,6 +1211,9 @@ static int powernowk8_target(struct cpuf
 		mutex_unlock(&fidvid_mutex);
 		goto err_out;
 	}
+
+	cpb_toggle(pol->flags.cpb);
+
 	mutex_unlock(&fidvid_mutex);
 
 	if (cpu_family == CPU_HW_PSTATE)
@@ -1330,6 +1353,7 @@ static int __cpuinit powernowk8_cpu_init
 	/* Check for APERF/MPERF support in hardware */
 	if (cpu_has(c, X86_FEATURE_APERFMPERF))
 		cpufreq_amd64_driver.getavg = get_measured_perf;
+	pol->flags.cpb = cpb_capable;
 
 	cpufreq_frequency_table_get_attr(data->powernow_table, pol->cpu);
 
@@ -1419,11 +1443,20 @@ static struct cpufreq_driver cpufreq_amd
 	.attr		= powernow_k8_attr,
 };
 
+static bool __cpuinit check_cpb_capable(void)
+{
+	u32 tmp = cpuid_edx(CPUID_FREQ_VOLT_CAPABILITIES);
+
+	return (tmp & CPB_CAPABLE);
+}
+
 /* driver entry point for init */
 static int __cpuinit powernowk8_init(void)
 {
 	unsigned int i, supported_cpus = 0;
 
+	cpb_capable = check_cpb_capable();
+
 	for_each_online_cpu(i) {
 		int rc;
 		smp_call_function_single(i, check_supported_cpu, &rc, 1);
diff -puN arch/x86/kernel/cpu/cpufreq/powernow-k8.h~cpufreq-powernow-k8-add-core-performance-boost-support arch/x86/kernel/cpu/cpufreq/powernow-k8.h
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h~cpufreq-powernow-k8-add-core-performance-boost-support
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
 
-
 /* processor's cpuid instruction support */
 #define CPUID_PROCESSOR_SIGNATURE	1	/* function 1 */
 #define CPUID_XFAM			0x0ff00000	/* extended family */
@@ -67,6 +65,7 @@ struct powernow_k8_data {
 #define CPUID_GET_MAX_CAPABILITIES	0x80000000
 #define CPUID_FREQ_VOLT_CAPABILITIES	0x80000007
 #define P_STATE_TRANSITION_CAPABLE	6
+#define CPB_CAPABLE			0x00000200
 
 /* Model Specific Registers for p-state transitions. MSRs are 64-bit. For     */
 /* writes (wrmsr - opcode 0f 30), the register number is placed in ecx, and   */
diff -puN include/linux/cpufreq.h~cpufreq-powernow-k8-add-core-performance-boost-support include/linux/cpufreq.h
--- a/include/linux/cpufreq.h~cpufreq-powernow-k8-add-core-performance-boost-support
+++ a/include/linux/cpufreq.h
@@ -104,6 +104,10 @@ struct cpufreq_policy {
 
 	struct kobject		kobj;
 	struct completion	kobj_unregister;
+
+	struct flags {
+		unsigned long cpb:1;	/* toggle CPB on this cpu */
+	} flags;
 };
 
 #define CPUFREQ_ADJUST		(0)
_

Patches currently in -mm which might be from mark.langsdorf@amd.com are

cpufreq-powernow-k8-add-core-performance-boost-support.patch
cpufreq-add-sysfs-knob-for-toggling-core-performance-boost.patch

