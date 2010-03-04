From: akpm@linux-foundation.org
Subject: + cpufreq-add-aperf-mperf-support-for-amd-processors.patch added to -mm tree
Date: Thu, 04 Mar 2010 13:28:33 -0800
Message-ID: <201003042128.o24LSXot030900@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752877Ab0CDV2t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Mar 2010 16:28:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mark.langsdorf@amd.com, davej@codemonkey.org.uk


The patch titled
     cpufreq: add APERF/MPERF support for AMD processors
has been added to the -mm tree.  Its filename is
     cpufreq-add-aperf-mperf-support-for-amd-processors.patch

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
Subject: cpufreq: add APERF/MPERF support for AMD processors
From: Mark Langsdorf <mark.langsdorf@amd.com>

Starting with model 10 of Family 0x10, AMD processors may have support for
APERF/MPERF.  Add support for identifying it and using it within cpufreq. 
Move the APERF/MPERF functions out of the acpi-cpufreq code and into their
own file so they can easily be shared.

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/amd.c                  |    6 ++
 arch/x86/kernel/cpu/cpufreq/Makefile       |    4 -
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   42 ---------------
 arch/x86/kernel/cpu/cpufreq/mperf.c        |   50 +++++++++++++++++++
 arch/x86/kernel/cpu/cpufreq/mperf.h        |    9 +++
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c  |   11 +++-
 6 files changed, 78 insertions(+), 44 deletions(-)

diff -puN arch/x86/kernel/cpu/amd.c~cpufreq-add-aperf-mperf-support-for-amd-processors arch/x86/kernel/cpu/amd.c
--- a/arch/x86/kernel/cpu/amd.c~cpufreq-add-aperf-mperf-support-for-amd-processors
+++ a/arch/x86/kernel/cpu/amd.c
@@ -537,6 +537,12 @@ static void __cpuinit init_amd(struct cp
 		set_cpu_cap(c, X86_FEATURE_MFENCE_RDTSC);
 	}
 
+	if (c->cpuid_level >= 6) {
+		unsigned ecx = cpuid_ecx(6);
+		if (ecx & 0x01)
+			set_cpu_cap(c, X86_FEATURE_APERFMPERF);
+	}
+
 #ifdef CONFIG_X86_64
 	if (c->x86 == 0x10) {
 		/* do this for boot cpu */
diff -puN arch/x86/kernel/cpu/cpufreq/Makefile~cpufreq-add-aperf-mperf-support-for-amd-processors arch/x86/kernel/cpu/cpufreq/Makefile
--- a/arch/x86/kernel/cpu/cpufreq/Makefile~cpufreq-add-aperf-mperf-support-for-amd-processors
+++ a/arch/x86/kernel/cpu/cpufreq/Makefile
@@ -2,8 +2,8 @@
 # K8 systems. ACPI is preferred to all other hardware-specific drivers.
 # speedstep-* is preferred over p4-clockmod.
 
-obj-$(CONFIG_X86_POWERNOW_K8)		+= powernow-k8.o
-obj-$(CONFIG_X86_ACPI_CPUFREQ)		+= acpi-cpufreq.o
+obj-$(CONFIG_X86_POWERNOW_K8)		+= powernow-k8.o mperf.o
+obj-$(CONFIG_X86_ACPI_CPUFREQ)		+= acpi-cpufreq.o mperf.o
 obj-$(CONFIG_X86_PCC_CPUFREQ)		+= pcc-cpufreq.o
 obj-$(CONFIG_X86_POWERNOW_K6)		+= powernow-k6.o
 obj-$(CONFIG_X86_POWERNOW_K7)		+= powernow-k7.o
diff -puN arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c~cpufreq-add-aperf-mperf-support-for-amd-processors arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c~cpufreq-add-aperf-mperf-support-for-amd-processors
+++ a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -45,6 +45,7 @@
 #include <asm/msr.h>
 #include <asm/processor.h>
 #include <asm/cpufeature.h>
+#include "mperf.h"
 
 #define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, \
 		"acpi-cpufreq", msg)
@@ -70,8 +71,6 @@ struct acpi_cpufreq_data {
 
 static DEFINE_PER_CPU(struct acpi_cpufreq_data *, acfreq_data);
 
-static DEFINE_PER_CPU(struct aperfmperf, acfreq_old_perf);
-
 /* acpi_perf_data is a pointer to percpu data. */
 static struct acpi_processor_performance *acpi_perf_data;
 
@@ -239,45 +238,6 @@ static u32 get_cur_val(const struct cpum
 	return cmd.val;
 }
 
-/* Called via smp_call_function_single(), on the target CPU */
-static void read_measured_perf_ctrs(void *_cur)
-{
-	struct aperfmperf *am = _cur;
-
-	get_aperfmperf(am);
-}
-
-/*
- * Return the measured active (C0) frequency on this CPU since last call
- * to this function.
- * Input: cpu number
- * Return: Average CPU frequency in terms of max frequency (zero on error)
- *
- * We use IA32_MPERF and IA32_APERF MSRs to get the measured performance
- * over a period of time, while CPU is in C0 state.
- * IA32_MPERF counts at the rate of max advertised frequency
- * IA32_APERF counts at the rate of actual CPU frequency
- * Only IA32_APERF/IA32_MPERF ratio is architecturally defined and
- * no meaning should be associated with absolute values of these MSRs.
- */
-static unsigned int get_measured_perf(struct cpufreq_policy *policy,
-				      unsigned int cpu)
-{
-	struct aperfmperf perf;
-	unsigned long ratio;
-	unsigned int retval;
-
-	if (smp_call_function_single(cpu, read_measured_perf_ctrs, &perf, 1))
-		return 0;
-
-	ratio = calc_aperfmperf_ratio(&per_cpu(acfreq_old_perf, cpu), &perf);
-	per_cpu(acfreq_old_perf, cpu) = perf;
-
-	retval = (policy->cpuinfo.max_freq * ratio) >> APERFMPERF_SHIFT;
-
-	return retval;
-}
-
 static unsigned int get_cur_freq_on_cpu(unsigned int cpu)
 {
 	struct acpi_cpufreq_data *data = per_cpu(acfreq_data, cpu);
diff -puN /dev/null arch/x86/kernel/cpu/cpufreq/mperf.c
--- /dev/null
+++ a/arch/x86/kernel/cpu/cpufreq/mperf.c
@@ -0,0 +1,50 @@
+#include <linux/kernel.h>
+#include <linux/smp.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/cpufreq.h>
+#include <linux/slab.h>
+
+#include "mperf.h"
+
+static DEFINE_PER_CPU(struct aperfmperf, acfreq_old_perf);
+
+/* Called via smp_call_function_single(), on the target CPU */
+static void read_measured_perf_ctrs(void *_cur)
+{
+	struct aperfmperf *am = _cur;
+
+	get_aperfmperf(am);
+}
+
+/*
+ * Return the measured active (C0) frequency on this CPU since last call
+ * to this function.
+ * Input: cpu number
+ * Return: Average CPU frequency in terms of max frequency (zero on error)
+ *
+ * We use IA32_MPERF and IA32_APERF MSRs to get the measured performance
+ * over a period of time, while CPU is in C0 state.
+ * IA32_MPERF counts at the rate of max advertised frequency
+ * IA32_APERF counts at the rate of actual CPU frequency
+ * Only IA32_APERF/IA32_MPERF ratio is architecturally defined and
+ * no meaning should be associated with absolute values of these MSRs.
+ */
+unsigned int get_measured_perf(struct cpufreq_policy *policy,
+					unsigned int cpu)
+{
+	struct aperfmperf perf;
+	unsigned long ratio;
+	unsigned int retval;
+
+	if (smp_call_function_single(cpu, read_measured_perf_ctrs, &perf, 1))
+		return 0;
+
+	ratio = calc_aperfmperf_ratio(&per_cpu(acfreq_old_perf, cpu), &perf);
+	per_cpu(acfreq_old_perf, cpu) = perf;
+
+	retval = (policy->cpuinfo.max_freq * ratio) >> APERFMPERF_SHIFT;
+
+	return retval;
+}
+EXPORT_SYMBOL_GPL(get_measured_perf);
diff -puN /dev/null arch/x86/kernel/cpu/cpufreq/mperf.h
--- /dev/null
+++ a/arch/x86/kernel/cpu/cpufreq/mperf.h
@@ -0,0 +1,9 @@
+/*
+ *  (c) 2003-2006 Advanced Micro Devices, Inc.
+ *  Your use of this code is subject to the terms and conditions of the
+ *  GNU general public license version 2. See "COPYING" or
+ *  http://www.gnu.org/licenses/gpl.html
+ */
+
+unsigned int get_measured_perf(struct cpufreq_policy *policy,
+				unsigned int cpu);
diff -puN arch/x86/kernel/cpu/cpufreq/powernow-k8.c~cpufreq-add-aperf-mperf-support-for-amd-processors arch/x86/kernel/cpu/cpufreq/powernow-k8.c
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c~cpufreq-add-aperf-mperf-support-for-amd-processors
+++ a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -46,6 +46,7 @@
 #define PFX "powernow-k8: "
 #define VERSION "version 2.20.00"
 #include "powernow-k8.h"
+#include "mperf.h"
 
 /* serialize freq changes  */
 static DEFINE_MUTEX(fidvid_mutex);
@@ -54,6 +55,8 @@ static DEFINE_PER_CPU(struct powernow_k8
 
 static int cpu_family = CPU_OPTERON;
 
+static struct cpufreq_driver cpufreq_amd64_driver;
+
 #ifndef CONFIG_SMP
 static inline const struct cpumask *cpu_core_mask(int cpu)
 {
@@ -929,7 +932,8 @@ static int fill_powernow_table_pstate(st
 		powernow_table[i].index = index;
 
 		/* Frequency may be rounded for these */
-		if (boot_cpu_data.x86 == 0x10 || boot_cpu_data.x86 == 0x11) {
+		if ((boot_cpu_data.x86 == 0x10 && boot_cpu_data.x86_model < 10)
+				 || boot_cpu_data.x86 == 0x11) {
 			powernow_table[i].frequency =
 				freq_from_fid_did(lo & 0x3f, (lo >> 6) & 7);
 		} else
@@ -1248,6 +1252,7 @@ static int __cpuinit powernowk8_cpu_init
 	struct powernow_k8_data *data;
 	struct init_on_cpu init_on_cpu;
 	int rc;
+	struct cpuinfo_x86 *c = &cpu_data(pol->cpu);
 
 	if (!cpu_online(pol->cpu))
 		return -ENODEV;
@@ -1322,6 +1327,10 @@ static int __cpuinit powernowk8_cpu_init
 		return -EINVAL;
 	}
 
+	/* Check for APERF/MPERF support in hardware */
+	if (cpu_has(c, X86_FEATURE_APERFMPERF))
+		cpufreq_amd64_driver.getavg = get_measured_perf;
+
 	cpufreq_frequency_table_get_attr(data->powernow_table, pol->cpu);
 
 	if (cpu_family == CPU_HW_PSTATE)
_

Patches currently in -mm which might be from mark.langsdorf@amd.com are

cpufreq-add-aperf-mperf-support-for-amd-processors.patch
cpufreq-powernow-k8-add-core-performance-boost-support.patch
cpufreq-add-sysfs-knob-for-toggling-core-performance-boost.patch

