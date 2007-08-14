From: akpm@linux-foundation.org
Subject: - x86_64-store-core-id-bits-in-cpuinfo_x8.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:14:17 -0700
Message-ID: <200708141914.l7EJEH2K016602@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44501 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933729AbXHNTVP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:21:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yhlu.kernel@gmail.com, ak@suse.de, clameter@sgi.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     x86_64: store core id bits in cpuinfo_x8
has been removed from the -mm tree.  Its filename was
     x86_64-store-core-id-bits-in-cpuinfo_x8.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: store core id bits in cpuinfo_x8
From: "Yinghai Lu" <yhlu.kernel@gmail.com>

We need to store core id bits to cpuinfo_x86 in early_identify_cpu. So we
use it to create acpiid_to_node array in k8topolgy.c

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/setup.c     |   72 ++++++++++++++++++++-----------
 include/asm-x86_64/processor.h |    1 
 2 files changed, 49 insertions(+), 24 deletions(-)

diff -puN arch/x86_64/kernel/setup.c~x86_64-store-core-id-bits-in-cpuinfo_x8 arch/x86_64/kernel/setup.c
--- a/arch/x86_64/kernel/setup.c~x86_64-store-core-id-bits-in-cpuinfo_x8
+++ a/arch/x86_64/kernel/setup.c
@@ -499,18 +499,7 @@ static void __init amd_detect_cmp(struct
 	int node = 0;
 	unsigned apicid = hard_smp_processor_id();
 #endif
-	unsigned ecx = cpuid_ecx(0x80000008);
-
-	c->x86_max_cores = (ecx & 0xff) + 1;
-
-	/* CPU telling us the core id bits shift? */
-	bits = (ecx >> 12) & 0xF;
-
-	/* Otherwise recompute */
-	if (bits == 0) {
-		while ((1 << bits) < c->x86_max_cores)
-			bits++;
-	}
+	bits = c->x86_coreid_bits;
 
 	/* Low order bits define the core id (index of core in socket) */
 	c->cpu_core_id = c->phys_proc_id & ((1 << bits)-1);
@@ -546,6 +535,34 @@ static void __init amd_detect_cmp(struct
 #endif
 }
 
+static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_SMP
+	unsigned bits;
+	unsigned ecx;
+
+	/* Multi core CPU? */
+	if (c->extended_cpuid_level < 0x80000008)
+		return;
+
+	ecx = cpuid_ecx(0x80000008);
+
+	c->x86_max_cores = (ecx & 0xff) + 1;
+
+	/* CPU telling us the core id bits shift? */
+	bits = (ecx >> 12) & 0xF;
+
+	/* Otherwise recompute */
+	if (bits == 0) {
+		while ((1 << bits) < c->x86_max_cores)
+			bits++;
+	}
+
+	c->x86_coreid_bits = bits;
+
+#endif
+}
+
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 {
 	unsigned level;
@@ -776,6 +793,7 @@ struct cpu_model_info {
 void __cpuinit early_identify_cpu(struct cpuinfo_x86 *c)
 {
 	u32 tfms;
+	u32 xlvl;
 
 	c->loops_per_jiffy = loops_per_jiffy;
 	c->x86_cache_size = -1;
@@ -786,6 +804,7 @@ void __cpuinit early_identify_cpu(struct
 	c->x86_clflush_size = 64;
 	c->x86_cache_alignment = c->x86_clflush_size;
 	c->x86_max_cores = 1;
+	c->x86_coreid_bits = 0;
 	c->extended_cpuid_level = 0;
 	memset(&c->x86_capability, 0, sizeof c->x86_capability);
 
@@ -822,18 +841,6 @@ void __cpuinit early_identify_cpu(struct
 #ifdef CONFIG_SMP
 	c->phys_proc_id = (cpuid_ebx(1) >> 24) & 0xff;
 #endif
-}
-
-/*
- * This does the hard work of actually picking apart the CPU stuff...
- */
-void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
-{
-	int i;
-	u32 xlvl;
-
-	early_identify_cpu(c);
-
 	/* AMD-defined flags: level 0x80000001 */
 	xlvl = cpuid_eax(0x80000000);
 	c->extended_cpuid_level = xlvl;
@@ -854,6 +861,23 @@ void __cpuinit identify_cpu(struct cpuin
 			c->x86_capability[2] = cpuid_edx(0x80860001);
 	}
 
+	switch (c->x86_vendor) {
+	case X86_VENDOR_AMD:
+		early_init_amd(c);
+		break;
+	}
+
+}
+
+/*
+ * This does the hard work of actually picking apart the CPU stuff...
+ */
+void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
+{
+	int i;
+
+	early_identify_cpu(c);
+
 	init_scattered_cpuid_features(c);
 
 	c->apicid = phys_pkg_id(0);
diff -puN include/asm-x86_64/processor.h~x86_64-store-core-id-bits-in-cpuinfo_x8 include/asm-x86_64/processor.h
--- a/include/asm-x86_64/processor.h~x86_64-store-core-id-bits-in-cpuinfo_x8
+++ a/include/asm-x86_64/processor.h
@@ -63,6 +63,7 @@ struct cpuinfo_x86 {
 	int	x86_tlbsize;	/* number of 4K pages in DTLB/ITLB combined(in pages)*/
         __u8    x86_virt_bits, x86_phys_bits;
 	__u8	x86_max_cores;	/* cpuid returned max cores value */
+	__u8	x86_coreid_bits; /* cpuid returned core id bits */
         __u32   x86_power; 	
 	__u32   extended_cpuid_level;	/* Max extended CPUID function supported */
 	unsigned long loops_per_jiffy;
_

Patches currently in -mm which might be from yhlu.kernel@gmail.com are

x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes.patch
