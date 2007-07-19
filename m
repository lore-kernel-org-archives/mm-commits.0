From: akpm@linux-foundation.org
Subject: - x86-64-disable-the-gart-in-shutdown.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:10:10 -0700
Message-ID: <200707192010.l6JKAAiY020647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34517 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932227AbXGSUa6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:30:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@Sun.COM, ak@suse.de, alan@lxorguk.ukuu.org.uk, davej@codemonkey.org.uk, ebiederm@xmission.com, muli@il.ibm.com, vgoyal@in.ibm.com, yinghai.lu@Sun.COM, mm-commits@vger.kernel.org


The patch titled
     x86-64: disable the GART in shutdown
has been removed from the -mm tree.  Its filename was
     x86-64-disable-the-gart-in-shutdown.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86-64: disable the GART in shutdown
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

For K8 system: 4G RAM with memory hole remapping enabled, or more than 4G
RAM installed.  when using kexec to load second kernel.  In the second
kernel, when mem is allocated for GART, it will do the memset for clear, it
will cause restart, because some device still used that for dma.  solution
will be:

in second kernel: disable that at first before we try to allocate mem for
it.  or in the first kernel: do disable that before shutdown. 
Andi/Eric/Alan prefer to second one for clean shutdown in first kernel. 
Andi also point out need to consider to AGP enable but mem less 4G case
too.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/pci-dma.c  |    5 +++++
 arch/x86_64/kernel/pci-gart.c |   20 ++++++++++++++++++++
 arch/x86_64/kernel/reboot.c   |    4 ++++
 include/asm-x86_64/proto.h    |    7 +++++++
 4 files changed, 36 insertions(+)

diff -puN arch/x86_64/kernel/pci-dma.c~x86-64-disable-the-gart-in-shutdown arch/x86_64/kernel/pci-dma.c
--- a/arch/x86_64/kernel/pci-dma.c~x86-64-disable-the-gart-in-shutdown
+++ a/arch/x86_64/kernel/pci-dma.c
@@ -321,6 +321,11 @@ static int __init pci_iommu_init(void)
 	return 0;
 }
 
+void pci_iommu_shutdown(void)
+{
+	gart_iommu_shutdown();
+}
+
 #ifdef CONFIG_PCI
 /* Many VIA bridges seem to corrupt data for DAC. Disable it here */
 
diff -puN arch/x86_64/kernel/pci-gart.c~x86-64-disable-the-gart-in-shutdown arch/x86_64/kernel/pci-gart.c
--- a/arch/x86_64/kernel/pci-gart.c~x86-64-disable-the-gart-in-shutdown
+++ a/arch/x86_64/kernel/pci-gart.c
@@ -571,6 +571,26 @@ static const struct dma_mapping_ops gart
 	.unmap_sg = gart_unmap_sg,
 };
 
+void gart_iommu_shutdown(void)
+{
+	struct pci_dev *dev;
+	int i;
+
+	if (no_agp && (dma_ops != &gart_dma_ops))
+		return;
+
+        for (i = 0; i < num_k8_northbridges; i++) {
+                u32 ctl;
+
+                dev = k8_northbridges[i];
+                pci_read_config_dword(dev, 0x90, &ctl);
+
+                ctl &= ~1;
+
+                pci_write_config_dword(dev, 0x90, ctl);
+        }
+}
+
 void __init gart_iommu_init(void)
 { 
 	struct agp_kern_info info;
diff -puN arch/x86_64/kernel/reboot.c~x86-64-disable-the-gart-in-shutdown arch/x86_64/kernel/reboot.c
--- a/arch/x86_64/kernel/reboot.c~x86-64-disable-the-gart-in-shutdown
+++ a/arch/x86_64/kernel/reboot.c
@@ -16,6 +16,7 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/apic.h>
+#include <asm/proto.h>
 
 /*
  * Power off function, if any
@@ -81,6 +82,7 @@ static inline void kb_wait(void)
 void machine_shutdown(void)
 {
 	unsigned long flags;
+
 	/* Stop the cpus and apics */
 #ifdef CONFIG_SMP
 	int reboot_cpu_id;
@@ -111,6 +113,8 @@ void machine_shutdown(void)
 	disable_IO_APIC();
 
 	local_irq_restore(flags);
+
+	pci_iommu_shutdown();
 }
 
 void machine_emergency_restart(void)
diff -puN include/asm-x86_64/proto.h~x86-64-disable-the-gart-in-shutdown include/asm-x86_64/proto.h
--- a/include/asm-x86_64/proto.h~x86-64-disable-the-gart-in-shutdown
+++ a/include/asm-x86_64/proto.h
@@ -85,11 +85,13 @@ extern int exception_trace;
 extern unsigned cpu_khz;
 extern unsigned tsc_khz;
 
+extern void pci_iommu_shutdown(void);
 extern void no_iommu_init(void);
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
 #ifdef CONFIG_IOMMU
 extern void gart_iommu_init(void);
+extern void gart_iommu_shutdown(void);
 extern void __init gart_parse_options(char *);
 extern void iommu_hole_init(void);
 extern int fallback_aper_order;
@@ -101,6 +103,11 @@ extern int fix_aperture;
 #else
 #define iommu_aperture 0
 #define iommu_aperture_allowed 0
+
+static inline void gart_iommu_shutdown(void)
+{
+}
+
 #endif
 
 extern int reboot_force;
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

origin.patch
