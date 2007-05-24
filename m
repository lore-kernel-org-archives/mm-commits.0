From: akpm@linux-foundation.org
Subject: + display-intel-dynamic-acceleration-feature-in-proc-cpuinfo.patch added to -mm tree
Date: Thu, 24 May 2007 13:55:18 -0700
Message-ID: <200705242055.l4OKtIXo002389@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48416 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753495AbXEXUzk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 May 2007 16:55:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com, ak@suse.de, davej@redhat.com, len.brown@intel.com


The patch titled
     Display Intel Dynamic Acceleration feature in /proc/cpuinfo
has been added to the -mm tree.  Its filename is
     display-intel-dynamic-acceleration-feature-in-proc-cpuinfo.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Display Intel Dynamic Acceleration feature in /proc/cpuinfo
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

Display Intel Dynamic Acceleration feature in /proc/cpuinfo. This feature
will be enabled automatically by current acpi-cpufreq driver and cpufreq.

Refer to Intel Software Developer's Manual for more details about the feature.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c |   13 ++++++++++++-
 arch/i386/kernel/cpu/proc.c                 |    2 +-
 arch/x86_64/kernel/setup.c                  |    2 +-
 include/asm-i386/cpufeature.h               |    1 +
 include/asm-x86_64/cpufeature.h             |    1 +
 5 files changed, 16 insertions(+), 3 deletions(-)

diff -puN arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c~display-intel-dynamic-acceleration-feature-in-proc-cpuinfo arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
--- a/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c~display-intel-dynamic-acceleration-feature-in-proc-cpuinfo
+++ a/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -58,6 +58,7 @@ enum {
 
 #define INTEL_MSR_RANGE		(0xffff)
 #define CPUID_6_ECX_APERFMPERF_CAPABILITY	(0x1)
+#define CPUID_6_EAX_IDA_CAPABILITY		(0x2)
 
 struct acpi_cpufreq_data {
 	struct acpi_processor_performance *acpi_data;
@@ -702,10 +703,20 @@ static int acpi_cpufreq_cpu_init(struct 
 
 	/* Check for APERF/MPERF support in hardware */
 	if (c->x86_vendor == X86_VENDOR_INTEL && c->cpuid_level >= 6) {
-		unsigned int ecx;
+		unsigned int eax, ecx;
 		ecx = cpuid_ecx(6);
 		if (ecx & CPUID_6_ECX_APERFMPERF_CAPABILITY)
 			acpi_cpufreq_driver.getavg = get_measured_perf;
+
+		eax = cpuid_eax(6);
+		if (eax & CPUID_6_EAX_IDA_CAPABILITY) {
+			unsigned int i;
+
+			for_each_cpu_mask(i, policy->cpus) {
+				struct cpuinfo_x86 *c = &cpu_data[i];
+				set_bit(X86_FEATURE_IDA, c->x86_capability);
+			}
+		}
 	}
 
 	dprintk("CPU%u - ACPI performance management activated.\n", cpu);
diff -puN arch/i386/kernel/cpu/proc.c~display-intel-dynamic-acceleration-feature-in-proc-cpuinfo arch/i386/kernel/cpu/proc.c
--- a/arch/i386/kernel/cpu/proc.c~display-intel-dynamic-acceleration-feature-in-proc-cpuinfo
+++ a/arch/i386/kernel/cpu/proc.c
@@ -41,7 +41,7 @@ static int show_cpuinfo(struct seq_file 
 		"cxmmx", "k6_mtrr", "cyrix_arr", "centaur_mcr",
 		NULL, NULL, NULL, NULL,
 		"constant_tsc", "up", NULL, NULL, NULL, NULL, NULL, NULL,
-		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
+		"ida", NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 
 		/* Intel-defined (#2) */
diff -puN arch/x86_64/kernel/setup.c~display-intel-dynamic-acceleration-feature-in-proc-cpuinfo arch/x86_64/kernel/setup.c
--- a/arch/x86_64/kernel/setup.c~display-intel-dynamic-acceleration-feature-in-proc-cpuinfo
+++ a/arch/x86_64/kernel/setup.c
@@ -951,7 +951,7 @@ static int show_cpuinfo(struct seq_file 
 		/* Other (Linux-defined) */
 		"cxmmx", NULL, "cyrix_arr", "centaur_mcr", NULL,
 		"constant_tsc", NULL, NULL,
-		"up", NULL, NULL, NULL, NULL, NULL, NULL, NULL,
+		"up", NULL, NULL, NULL, "ida", NULL, NULL, NULL,
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 
diff -puN include/asm-i386/cpufeature.h~display-intel-dynamic-acceleration-feature-in-proc-cpuinfo include/asm-i386/cpufeature.h
--- a/include/asm-i386/cpufeature.h~display-intel-dynamic-acceleration-feature-in-proc-cpuinfo
+++ a/include/asm-i386/cpufeature.h
@@ -81,6 +81,7 @@
 #define X86_FEATURE_BTS		(3*32+13)  /* Branch Trace Store */
 #define X86_FEATURE_LAPIC_TIMER_BROKEN (3*32+ 14) /* lapic timer broken in C1 */
 #define X86_FEATURE_SYNC_RDTSC	(3*32+15)  /* RDTSC synchronizes the CPU */
+#define X86_FEATURE_IDA		(3*32+16)  /* Intel Dynamic Acceleration */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* Streaming SIMD Extensions-3 */
diff -puN include/asm-x86_64/cpufeature.h~display-intel-dynamic-acceleration-feature-in-proc-cpuinfo include/asm-x86_64/cpufeature.h
--- a/include/asm-x86_64/cpufeature.h~display-intel-dynamic-acceleration-feature-in-proc-cpuinfo
+++ a/include/asm-x86_64/cpufeature.h
@@ -70,6 +70,7 @@
 #define X86_FEATURE_ARCH_PERFMON (3*32+9) /* Intel Architectural PerfMon */
 #define X86_FEATURE_PEBS	(3*32+10) /* Precise-Event Based Sampling */
 #define X86_FEATURE_BTS		(3*32+11) /* Branch Trace Store */
+#define X86_FEATURE_IDA		(3*32+12) /* Intel Dynamic Acceleration */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* Streaming SIMD Extensions-3 */
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

display-intel-dynamic-acceleration-feature-in-proc-cpuinfo.patch
