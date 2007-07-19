From: akpm@linux-foundation.org
Subject: - x86_84-move-iommu-declaration-from-proto-to-iommuh.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:10:12 -0700
Message-ID: <200707192010.l6JKACO2020650@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47320 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757178AbXGSUcS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:32:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@Sun.COM, ak@suse.de, alan@lxorguk.ukuu.org.uk, davej@codemonkey.org.uk, ebiederm@xmission.com, muli@il.ibm.com, vgoyal@in.ibm.com, yinghai.lu@Sun.COM, mm-commits@vger.kernel.org


The patch titled
     x86_84: move iommu declaration from proto to iommu.h
has been removed from the -mm tree.  Its filename was
     x86_84-move-iommu-declaration-from-proto-to-iommuh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_84: move iommu declaration from proto to iommu.h
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

[akpm@linux-foundation.org: build fix]
Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/aperture.c     |    2 -
 arch/x86_64/kernel/early-quirks.c |    1 
 arch/x86_64/kernel/pci-calgary.c  |    2 -
 arch/x86_64/kernel/pci-dma.c      |    2 -
 arch/x86_64/kernel/pci-gart.c     |    1 
 arch/x86_64/kernel/pci-nommu.c    |    2 -
 arch/x86_64/kernel/pci-swiotlb.c  |    2 -
 arch/x86_64/kernel/reboot.c       |    2 -
 include/asm-x86_64/iommu.h        |   29 ++++++++++++++++++++++++++++
 include/asm-x86_64/proto.h        |   25 ------------------------
 10 files changed, 37 insertions(+), 31 deletions(-)

diff -puN arch/x86_64/kernel/aperture.c~x86_84-move-iommu-declaration-from-proto-to-iommuh arch/x86_64/kernel/aperture.c
--- a/arch/x86_64/kernel/aperture.c~x86_84-move-iommu-declaration-from-proto-to-iommuh
+++ a/arch/x86_64/kernel/aperture.c
@@ -20,7 +20,7 @@
 #include <linux/ioport.h>
 #include <asm/e820.h>
 #include <asm/io.h>
-#include <asm/proto.h>
+#include <asm/iommu.h>
 #include <asm/pci-direct.h>
 #include <asm/dma.h>
 #include <asm/k8.h>
diff -puN arch/x86_64/kernel/early-quirks.c~x86_84-move-iommu-declaration-from-proto-to-iommuh arch/x86_64/kernel/early-quirks.c
--- a/arch/x86_64/kernel/early-quirks.c~x86_84-move-iommu-declaration-from-proto-to-iommuh
+++ a/arch/x86_64/kernel/early-quirks.c
@@ -14,6 +14,7 @@
 #include <linux/pci_ids.h>
 #include <asm/pci-direct.h>
 #include <asm/proto.h>
+#include <asm/iommu.h>
 #include <asm/dma.h>
 
 static void __init via_bugs(void)
diff -puN arch/x86_64/kernel/pci-calgary.c~x86_84-move-iommu-declaration-from-proto-to-iommuh arch/x86_64/kernel/pci-calgary.c
--- a/arch/x86_64/kernel/pci-calgary.c~x86_84-move-iommu-declaration-from-proto-to-iommuh
+++ a/arch/x86_64/kernel/pci-calgary.c
@@ -35,7 +35,7 @@
 #include <linux/pci_ids.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
-#include <asm/proto.h>
+#include <asm/iommu.h>
 #include <asm/calgary.h>
 #include <asm/tce.h>
 #include <asm/pci-direct.h>
diff -puN arch/x86_64/kernel/pci-dma.c~x86_84-move-iommu-declaration-from-proto-to-iommuh arch/x86_64/kernel/pci-dma.c
--- a/arch/x86_64/kernel/pci-dma.c~x86_84-move-iommu-declaration-from-proto-to-iommuh
+++ a/arch/x86_64/kernel/pci-dma.c
@@ -8,7 +8,7 @@
 #include <linux/pci.h>
 #include <linux/module.h>
 #include <asm/io.h>
-#include <asm/proto.h>
+#include <asm/iommu.h>
 #include <asm/calgary.h>
 
 int iommu_merge __read_mostly = 0;
diff -puN arch/x86_64/kernel/pci-gart.c~x86_84-move-iommu-declaration-from-proto-to-iommuh arch/x86_64/kernel/pci-gart.c
--- a/arch/x86_64/kernel/pci-gart.c~x86_84-move-iommu-declaration-from-proto-to-iommuh
+++ a/arch/x86_64/kernel/pci-gart.c
@@ -28,6 +28,7 @@
 #include <asm/mtrr.h>
 #include <asm/pgtable.h>
 #include <asm/proto.h>
+#include <asm/iommu.h>
 #include <asm/cacheflush.h>
 #include <asm/swiotlb.h>
 #include <asm/dma.h>
diff -puN arch/x86_64/kernel/pci-nommu.c~x86_84-move-iommu-declaration-from-proto-to-iommuh arch/x86_64/kernel/pci-nommu.c
--- a/arch/x86_64/kernel/pci-nommu.c~x86_84-move-iommu-declaration-from-proto-to-iommuh
+++ a/arch/x86_64/kernel/pci-nommu.c
@@ -6,7 +6,7 @@
 #include <linux/string.h>
 #include <linux/dma-mapping.h>
 
-#include <asm/proto.h>
+#include <asm/iommu.h>
 #include <asm/processor.h>
 #include <asm/dma.h>
 
diff -puN arch/x86_64/kernel/pci-swiotlb.c~x86_84-move-iommu-declaration-from-proto-to-iommuh arch/x86_64/kernel/pci-swiotlb.c
--- a/arch/x86_64/kernel/pci-swiotlb.c~x86_84-move-iommu-declaration-from-proto-to-iommuh
+++ a/arch/x86_64/kernel/pci-swiotlb.c
@@ -5,7 +5,7 @@
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
 
-#include <asm/proto.h>
+#include <asm/iommu.h>
 #include <asm/swiotlb.h>
 #include <asm/dma.h>
 
diff -puN arch/x86_64/kernel/reboot.c~x86_84-move-iommu-declaration-from-proto-to-iommuh arch/x86_64/kernel/reboot.c
--- a/arch/x86_64/kernel/reboot.c~x86_84-move-iommu-declaration-from-proto-to-iommuh
+++ a/arch/x86_64/kernel/reboot.c
@@ -16,7 +16,7 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/apic.h>
-#include <asm/proto.h>
+#include <asm/iommu.h>
 
 /*
  * Power off function, if any
diff -puN /dev/null include/asm-x86_64/iommu.h
--- /dev/null
+++ a/include/asm-x86_64/iommu.h
@@ -0,0 +1,29 @@
+#ifndef _ASM_X8664_IOMMU_H
+#define _ASM_X8664_IOMMU_H 1
+
+extern void pci_iommu_shutdown(void);
+extern void no_iommu_init(void);
+extern int force_iommu, no_iommu;
+extern int iommu_detected;
+#ifdef CONFIG_IOMMU
+extern void gart_iommu_init(void);
+extern void gart_iommu_shutdown(void);
+extern void __init gart_parse_options(char *);
+extern void iommu_hole_init(void);
+extern int fallback_aper_order;
+extern int fallback_aper_force;
+extern int iommu_aperture;
+extern int iommu_aperture_allowed;
+extern int iommu_aperture_disabled;
+extern int fix_aperture;
+#else
+#define iommu_aperture 0
+#define iommu_aperture_allowed 0
+
+static inline void gart_iommu_shutdown(void)
+{
+}
+
+#endif
+
+#endif
diff -puN include/asm-x86_64/proto.h~x86_84-move-iommu-declaration-from-proto-to-iommuh include/asm-x86_64/proto.h
--- a/include/asm-x86_64/proto.h~x86_84-move-iommu-declaration-from-proto-to-iommuh
+++ a/include/asm-x86_64/proto.h
@@ -85,31 +85,6 @@ extern int exception_trace;
 extern unsigned cpu_khz;
 extern unsigned tsc_khz;
 
-extern void pci_iommu_shutdown(void);
-extern void no_iommu_init(void);
-extern int force_iommu, no_iommu;
-extern int iommu_detected;
-#ifdef CONFIG_IOMMU
-extern void gart_iommu_init(void);
-extern void gart_iommu_shutdown(void);
-extern void __init gart_parse_options(char *);
-extern void iommu_hole_init(void);
-extern int fallback_aper_order;
-extern int fallback_aper_force;
-extern int iommu_aperture;
-extern int iommu_aperture_allowed;
-extern int iommu_aperture_disabled;
-extern int fix_aperture;
-#else
-#define iommu_aperture 0
-#define iommu_aperture_allowed 0
-
-static inline void gart_iommu_shutdown(void)
-{
-}
-
-#endif
-
 extern int reboot_force;
 extern int notsc_setup(char *);
 
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

origin.patch
