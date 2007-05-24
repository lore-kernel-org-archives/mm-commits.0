From: akpm@linux-foundation.org
Subject: - display-intel-dynamic-acceleration-feature-in-proc-cpuinfo.patch removed from -mm tree
Date: Thu, 24 May 2007 15:02:43 -0700
Message-ID: <200705242202.l4OM2hp4004325@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754849AbXEXWDY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 May 2007 18:03:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: venkatesh.pallipadi@intel.com, ak@suse.de, davej@redhat.com, len.brown@intel.com, mm-commits@vger.kernel.org


The patch titled
     Display Intel Dynamic Acceleration feature in /proc/cpuinfo
has been removed from the -mm tree.  Its filename was
     display-intel-dynamic-acceleration-feature-in-proc-cpuinfo.patch

This patch was dropped because of patch conflicts

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
 asm-x86_64/cpufeature.h                     |    0 
 2 files changed, 12 insertions(+), 1 deletion(-)

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
diff -puN arch/x86_64/kernel/setup.c~display-intel-dynamic-acceleration-feature-in-proc-cpuinfo arch/x86_64/kernel/setup.c
diff -puN include/asm-i386/cpufeature.h~display-intel-dynamic-acceleration-feature-in-proc-cpuinfo include/asm-i386/cpufeature.h
diff -puN include/asm-x86_64/cpufeature.h~display-intel-dynamic-acceleration-feature-in-proc-cpuinfo include/asm-x86_64/cpufeature.h
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

display-intel-dynamic-acceleration-feature-in-proc-cpuinfo.patch
