From: akpm@linux-foundation.org
Subject: + x86_64-fix-section-mismatch-warnings.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:52:16 -0800
Message-ID: <200702272052.l1RKqKQs028154@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51398 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582AbXB0Uwa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:52:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, ak@suse.de, anemo@mba.ocn.ne.jp


The patch titled
     x86_64: fix section mismatch warnings
has been added to the -mm tree.  Its filename is
     x86_64-fix-section-mismatch-warnings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: fix section mismatch warnings
From: Sam Ravnborg <sam@ravnborg.org>

Fix the following section mismatch warnings on x86_64:
(build using defconfig)

WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.text:mtrr_bp_init from .text between 'identify_cpu' (at offset 0x65eb) and 'IRQ0x20_interrupt'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data: from .text between 'finish_e820_parsing' (at offset 0x7dc2) and 'early_panic'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.text:e820_print_map from .text between 'finish_e820_parsing' (at offset 0x7de1) and 'early_panic'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:num_processors from .text between 'acpi_unmap_lsapic' (at offset 0xc88f) and 'acpi_register_ioapic'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:disabled_cpus from .text between 'MP_processor_info' (at offset 0x11f35) and 'mp_register_lapic'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:num_processors from .text between 'MP_processor_info' (at offset 0x11f6e) and 'mp_register_lapic'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:num_processors from .text between 'MP_processor_info' (at offset 0x11f93) and 'mp_register_lapic'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:fix_aperture from .text between 'gart_parse_options' (at offset 0x15517) and 'iommu_full'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:fix_aperture from .text between 'gart_parse_options' (at offset 0x1552c) and 'iommu_full'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:iommu_aperture_allowed from .text between 'gart_parse_options' (at offset 0x1553d) and 'iommu_full'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:iommu_aperture_allowed from .text between 'gart_parse_options' (at offset 0x15552) and 'iommu_full'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:iommu_aperture_allowed from .text between 'gart_parse_options' (at offset 0x15561) and 'iommu_full'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:iommu_aperture_allowed from .text between 'gart_parse_options' (at offset 0x15577) and 'iommu_full'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:fallback_aper_force from .text between 'gart_parse_options' (at offset 0x1558a) and 'iommu_full'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:fallback_aper_order from .text between 'gart_parse_options' (at offset 0x155bf) and 'iommu_full'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:timer_over_8254 from .text between 'ati_bugs' (at offset 0x16344) and 'via_bugs'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:timer_over_8254 from .text between 'ati_bugs' (at offset 0x16356) and 'via_bugs'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:iommu_aperture_allowed from .text between 'via_bugs' (at offset 0x16380) and 'nvidia_bugs'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:iommu_aperture_disabled from .text between 'via_bugs' (at offset 0x16397) and 'nvidia_bugs'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:acpi_use_timer_override from .text between 'nvidia_bugs' (at offset 0x163a7) and 'arch_unregister_cpu'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.text:nvidia_hpet_check from .text between 'nvidia_bugs' (at offset 0x163b1) and 'arch_unregister_cpu'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data: from .text between 'nvidia_bugs' (at offset 0x163be) and 'arch_unregister_cpu'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data: from .text between 'nvidia_bugs' (at offset 0x163d1) and 'arch_unregister_cpu'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.data:acpi_skip_timer_override from .text between 'nvidia_bugs' (at offset 0x163e1) and 'arch_unregister_cpu'
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.text:quirk_intel_irqbalance from .text between 'intel_bugs' (at offset 0x1633c) and 'ati_bugs'

But adds:
WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to .init.text:get_mtrr_state from .text between 'mtrr_bp_init' (at offset 0xb887) and 'ipi_handler'

The warnings does not show up during a normal build due to kbuild
failing to check for section mismatch in vmlinux.
To see these warnings run:
scripts/mod/modpost arch/x86_64/kernel/built-in.o

kbuild will be fixed but the 'noise-level' had to be decresed first.
There remains a few section mismatch warnigns for x86_64 for areas where I did
not feel confident.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/mtrr/main.c  |    2 +-
 arch/x86_64/kernel/e820.c         |    2 +-
 arch/x86_64/kernel/early-quirks.c |    8 ++++----
 arch/x86_64/kernel/mpparse.c      |    4 ++--
 arch/x86_64/kernel/pci-gart.c     |    2 +-
 include/asm-x86_64/proto.h        |    2 +-
 include/asm-x86_64/smp.h          |    3 ++-
 7 files changed, 12 insertions(+), 11 deletions(-)

diff -puN arch/i386/kernel/cpu/mtrr/main.c~x86_64-fix-section-mismatch-warnings arch/i386/kernel/cpu/mtrr/main.c
--- a/arch/i386/kernel/cpu/mtrr/main.c~x86_64-fix-section-mismatch-warnings
+++ a/arch/i386/kernel/cpu/mtrr/main.c
@@ -639,7 +639,7 @@ static struct sysdev_driver mtrr_sysdev_
  * initialized (i.e. before smp_init()).
  * 
  */
-void __init mtrr_bp_init(void)
+void __cpuinit mtrr_bp_init(void)
 {
 	init_ifs();
 
diff -puN arch/x86_64/kernel/e820.c~x86_64-fix-section-mismatch-warnings arch/x86_64/kernel/e820.c
--- a/arch/x86_64/kernel/e820.c~x86_64-fix-section-mismatch-warnings
+++ a/arch/x86_64/kernel/e820.c
@@ -662,7 +662,7 @@ static int __init parse_memmap_opt(char 
 }
 early_param("memmap", parse_memmap_opt);
 
-void finish_e820_parsing(void)
+void __init finish_e820_parsing(void)
 {
 	if (userdef) {
 		printk(KERN_INFO "user-defined physical RAM map:\n");
diff -puN arch/x86_64/kernel/early-quirks.c~x86_64-fix-section-mismatch-warnings arch/x86_64/kernel/early-quirks.c
--- a/arch/x86_64/kernel/early-quirks.c~x86_64-fix-section-mismatch-warnings
+++ a/arch/x86_64/kernel/early-quirks.c
@@ -16,7 +16,7 @@
 #include <asm/proto.h>
 #include <asm/dma.h>
 
-static void via_bugs(void)
+static void __init via_bugs(void)
 {
 #ifdef CONFIG_IOMMU
 	if ((end_pfn > MAX_DMA32_PFN ||  force_iommu) &&
@@ -39,7 +39,7 @@ static int __init nvidia_hpet_check(stru
 }
 #endif
 
-static void nvidia_bugs(void)
+static void __init nvidia_bugs(void)
 {
 #ifdef CONFIG_ACPI
 	/*
@@ -69,7 +69,7 @@ static void nvidia_bugs(void)
 
 }
 
-static void ati_bugs(void)
+static void __init ati_bugs(void)
 {
 	if (timer_over_8254 == 1) {
 		timer_over_8254 = 0;
@@ -83,7 +83,7 @@ struct chipset {
 	void (*f)(void);
 };
 
-static struct chipset early_qrk[] = {
+static struct __initdata chipset early_qrk[] = {
 	{ PCI_VENDOR_ID_NVIDIA, nvidia_bugs },
 	{ PCI_VENDOR_ID_VIA, via_bugs },
 	{ PCI_VENDOR_ID_ATI, ati_bugs },
diff -puN arch/x86_64/kernel/mpparse.c~x86_64-fix-section-mismatch-warnings arch/x86_64/kernel/mpparse.c
--- a/arch/x86_64/kernel/mpparse.c~x86_64-fix-section-mismatch-warnings
+++ a/arch/x86_64/kernel/mpparse.c
@@ -60,9 +60,9 @@ unsigned long mp_lapic_addr = 0;
 /* Processor that is doing the boot up */
 unsigned int boot_cpu_id = -1U;
 /* Internal processor count */
-unsigned int num_processors __initdata = 0;
+unsigned int num_processors __cpuinitdata = 0;
 
-unsigned disabled_cpus __initdata;
+unsigned disabled_cpus __cpuinitdata;
 
 /* Bitmask of physically existing CPUs */
 physid_mask_t phys_cpu_present_map = PHYSID_MASK_NONE;
diff -puN arch/x86_64/kernel/pci-gart.c~x86_64-fix-section-mismatch-warnings arch/x86_64/kernel/pci-gart.c
--- a/arch/x86_64/kernel/pci-gart.c~x86_64-fix-section-mismatch-warnings
+++ a/arch/x86_64/kernel/pci-gart.c
@@ -675,7 +675,7 @@ void __init gart_iommu_init(void)
 	dma_ops = &gart_dma_ops;
 } 
 
-void gart_parse_options(char *p)
+void __init gart_parse_options(char *p)
 {
 	int arg;
 
diff -puN include/asm-x86_64/proto.h~x86_64-fix-section-mismatch-warnings include/asm-x86_64/proto.h
--- a/include/asm-x86_64/proto.h~x86_64-fix-section-mismatch-warnings
+++ a/include/asm-x86_64/proto.h
@@ -98,7 +98,7 @@ extern int force_iommu, no_iommu;
 extern int iommu_detected;
 #ifdef CONFIG_IOMMU
 extern void gart_iommu_init(void);
-extern void gart_parse_options(char *);
+extern void __init gart_parse_options(char *);
 extern void iommu_hole_init(void);
 extern int fallback_aper_order;
 extern int fallback_aper_force;
diff -puN include/asm-x86_64/smp.h~x86_64-fix-section-mismatch-warnings include/asm-x86_64/smp.h
--- a/include/asm-x86_64/smp.h~x86_64-fix-section-mismatch-warnings
+++ a/include/asm-x86_64/smp.h
@@ -7,6 +7,7 @@
 #include <linux/threads.h>
 #include <linux/cpumask.h>
 #include <linux/bitops.h>
+#include <linux/init.h>
 extern int disable_apic;
 
 #include <asm/mpspec.h>
@@ -66,7 +67,7 @@ extern int __cpu_disable(void);
 extern void __cpu_die(unsigned int cpu);
 extern void prefill_possible_map(void);
 extern unsigned num_processors;
-extern unsigned disabled_cpus;
+extern unsigned __cpuinitdata disabled_cpus;
 
 #define NO_PROC_ID		0xFF		/* No processor magic marker */
 
_

Patches currently in -mm which might be from sam@ravnborg.org are

fix-section-mismatch-warning-in-lockdep.patch
kbuild-override-build-timestamp.patch
kbuild-add-the-code-maturity-levels-deprecated-and-obsolete.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
allow-kernel-to-build-on-cygwin.patch
git-lxdialog.patch
git-parisc.patch
x86_64-fix-section-mismatch-warnings.patch
fix-section-mismatch-warning-in-lib-swiotlbc.patch
