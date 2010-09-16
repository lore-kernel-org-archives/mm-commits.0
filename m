From: akpm@linux-foundation.org
Subject: + arm-fix-arm-fix-pci_set_consistent_dma_mask-for-dmabounce-devices.patch added to -mm tree
Date: Thu, 16 Sep 2010 12:41:55 -0700
Message-ID: <201009161941.o8GJftal009757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39417 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754628Ab0IPTmO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Sep 2010 15:42:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, khc@pm.waw.pl, rmk+kernel@arm.linux.org.uk


The patch titled
     arm: fix "arm: fix pci_set_consistent_dma_mask for dmabounce devices"
has been added to the -mm tree.  Its filename is
     arm-fix-arm-fix-pci_set_consistent_dma_mask-for-dmabounce-devices.patch

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
Subject: arm: fix "arm: fix pci_set_consistent_dma_mask for dmabounce devices"
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This fixes the regression caused by the commit
6fee48cd330c68332f9712bc968d934a1a84a32a ("dma-mapping: arm: use generic
pci_set_dma_mask and pci_set_consistent_dma_mask").

ARM needs to clip the dma coherent mask for dmabounce devices. This
restores the old trick.

Note that strictly speaking, the DMA API doesn't allow architectures to do
such but I'm not sure it's worth adding the new API to set the dma mask
that allows architectures to clip it.

Reported-by: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/common/it8152.c                     |    8 ++++++++
 arch/arm/mach-ixp4xx/common-pci.c            |    8 ++++++++
 arch/arm/mach-ixp4xx/include/mach/hardware.h |    2 ++
 arch/arm/mach-pxa/include/mach/hardware.h    |    2 +-
 arch/arm/mach-pxa/include/mach/io.h          |    2 ++
 include/linux/dma-mapping.h                  |    4 ++++
 6 files changed, 25 insertions(+), 1 deletion(-)

diff -puN arch/arm/common/it8152.c~arm-fix-arm-fix-pci_set_consistent_dma_mask-for-dmabounce-devices arch/arm/common/it8152.c
--- a/arch/arm/common/it8152.c~arm-fix-arm-fix-pci_set_consistent_dma_mask-for-dmabounce-devices
+++ a/arch/arm/common/it8152.c
@@ -271,6 +271,14 @@ int dma_needs_bounce(struct device *dev,
 		((dma_addr + size - PHYS_OFFSET) >= SZ_64M);
 }
 
+int dma_set_coherent_mask(struct device *dev, u64 mask)
+{
+	if (mask >= PHYS_OFFSET + SZ_64M - 1)
+		return 0;
+
+	return -EIO;
+}
+
 int __init it8152_pci_setup(int nr, struct pci_sys_data *sys)
 {
 	it8152_io.start = IT8152_IO_BASE + 0x12000;
diff -puN arch/arm/mach-ixp4xx/common-pci.c~arm-fix-arm-fix-pci_set_consistent_dma_mask-for-dmabounce-devices arch/arm/mach-ixp4xx/common-pci.c
--- a/arch/arm/mach-ixp4xx/common-pci.c~arm-fix-arm-fix-pci_set_consistent_dma_mask-for-dmabounce-devices
+++ a/arch/arm/mach-ixp4xx/common-pci.c
@@ -503,6 +503,14 @@ struct pci_bus * __devinit ixp4xx_scan_b
 	return pci_scan_bus(sys->busnr, &ixp4xx_ops, sys);
 }
 
+int dma_set_coherent_mask(struct device *dev, u64 mask)
+{
+	if (mask >= SZ_64M - 1)
+		return 0;
+
+	return -EIO;
+}
+
 EXPORT_SYMBOL(ixp4xx_pci_read);
 EXPORT_SYMBOL(ixp4xx_pci_write);
 
diff -puN arch/arm/mach-ixp4xx/include/mach/hardware.h~arm-fix-arm-fix-pci_set_consistent_dma_mask-for-dmabounce-devices arch/arm/mach-ixp4xx/include/mach/hardware.h
--- a/arch/arm/mach-ixp4xx/include/mach/hardware.h~arm-fix-arm-fix-pci_set_consistent_dma_mask-for-dmabounce-devices
+++ a/arch/arm/mach-ixp4xx/include/mach/hardware.h
@@ -26,6 +26,8 @@
 #define PCIBIOS_MAX_MEM		0x4BFFFFFF
 #endif
 
+#define ARCH_HAS_DMA_SET_COHERENT_MASK
+
 #define pcibios_assign_all_busses()	1
 
 /* Register locations and bits */
diff -puN arch/arm/mach-pxa/include/mach/hardware.h~arm-fix-arm-fix-pci_set_consistent_dma_mask-for-dmabounce-devices arch/arm/mach-pxa/include/mach/hardware.h
--- a/arch/arm/mach-pxa/include/mach/hardware.h~arm-fix-arm-fix-pci_set_consistent_dma_mask-for-dmabounce-devices
+++ a/arch/arm/mach-pxa/include/mach/hardware.h
@@ -309,7 +309,7 @@ extern unsigned long get_clock_tick_rate
 #define PCIBIOS_MIN_IO		0
 #define PCIBIOS_MIN_MEM		0
 #define pcibios_assign_all_busses()	1
+#define ARCH_HAS_DMA_SET_COHERENT_MASK
 #endif
 
-
 #endif  /* _ASM_ARCH_HARDWARE_H */
diff -puN arch/arm/mach-pxa/include/mach/io.h~arm-fix-arm-fix-pci_set_consistent_dma_mask-for-dmabounce-devices arch/arm/mach-pxa/include/mach/io.h
--- a/arch/arm/mach-pxa/include/mach/io.h~arm-fix-arm-fix-pci_set_consistent_dma_mask-for-dmabounce-devices
+++ a/arch/arm/mach-pxa/include/mach/io.h
@@ -6,6 +6,8 @@
 #ifndef __ASM_ARM_ARCH_IO_H
 #define __ASM_ARM_ARCH_IO_H
 
+#include <mach/hardware.h>
+
 #define IO_SPACE_LIMIT 0xffffffff
 
 /*
diff -puN include/linux/dma-mapping.h~arm-fix-arm-fix-pci_set_consistent_dma_mask-for-dmabounce-devices include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~arm-fix-arm-fix-pci_set_consistent_dma_mask-for-dmabounce-devices
+++ a/include/linux/dma-mapping.h
@@ -102,6 +102,9 @@ static inline u64 dma_get_mask(struct de
 	return DMA_BIT_MASK(32);
 }
 
+#ifdef ARCH_HAS_DMA_SET_COHERENT_MASK
+int dma_set_coherent_mask(struct device *dev, u64 mask);
+#else
 static inline int dma_set_coherent_mask(struct device *dev, u64 mask)
 {
 	if (!dma_supported(dev, mask))
@@ -109,6 +112,7 @@ static inline int dma_set_coherent_mask(
 	dev->coherent_dma_mask = mask;
 	return 0;
 }
+#endif
 
 extern u64 dma_get_required_mask(struct device *dev);
 
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
arm-fix-arm-fix-pci_set_consistent_dma_mask-for-dmabounce-devices.patch
x86-enable-arch_dma_addr_t_64bit-with-x86_64-highmem64g.patch
powerpc-enable-arch_dma_addr_t_64bit-with-arch_phys_addr_t_64bit.patch
tile-enable-arch_dma_addr_t_64bit.patch
ia64-enable-arch_dma_addr_t_64bit.patch
mips-enable-arch_dma_addr_t_64bit-with-highmem-64bit_phys_addr-64bit.patch
s390-enable-arch_dma_addr_t_64bit-with-64bit.patch
alpha-enable-arch_dma_addr_t_64bit.patch
uml-define-config_no_dma.patch
add-the-common-dma_addr_t-typedef-to-include-linux-typesh.patch

