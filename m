From: akpm@linux-foundation.org
Subject: - dma-mapping-add-the-device-argument-to-dma_mapping_error.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:13:30 -0700
Message-ID: <200807262113.m6QLDUFx019604@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44674 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757586AbYGZVPd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:15:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, andi@firstfloor.org, avi@qumranet.com, mingo@elte.hu, muli@il.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     dma-mapping: add the device argument to dma_mapping_error()
has been removed from the -mm tree.  Its filename was
     dma-mapping-add-the-device-argument-to-dma_mapping_error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping: add the device argument to dma_mapping_error()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Add per-device dma_mapping_ops support for CONFIG_X86_64 as POWER
architecture does:

This enables us to cleanly fix the Calgary IOMMU issue that some devices
are not behind the IOMMU (http://lkml.org/lkml/2008/5/8/423).

I think that per-device dma_mapping_ops support would be also helpful for
KVM people to support PCI passthrough but Andi thinks that this makes it
difficult to support the PCI passthrough (see the above thread).  So I
CC'ed this to KVM camp.  Comments are appreciated.

A pointer to dma_mapping_ops to struct dev_archdata is added.  If the
pointer is non NULL, DMA operations in asm/dma-mapping.h use it.  If it's
NULL, the system-wide dma_ops pointer is used as before.

If it's useful for KVM people, I plan to implement a mechanism to register
a hook called when a new pci (or dma capable) device is created (it works
with hot plugging).  It enables IOMMUs to set up an appropriate
dma_mapping_ops per device.

The major obstacle is that dma_mapping_error doesn't take a pointer to the
device unlike other DMA operations.  So x86 can't have dma_mapping_ops per
device.  Note all the POWER IOMMUs use the same dma_mapping_error function
so this is not a problem for POWER but x86 IOMMUs use different
dma_mapping_error functions.

The first patch adds the device argument to dma_mapping_error.  The patch
is trivial but large since it touches lots of drivers and dma-mapping.h in
all the architecture.



This patch:

dma_mapping_error() doesn't take a pointer to the device unlike other DMA
operations.  So we can't have dma_mapping_ops per device.

Note that POWER already has dma_mapping_ops per device but all the POWER
IOMMUs use the same dma_mapping_error function.  x86 IOMMUs use device
argument.

[akpm@linux-foundation.org: fix sge]
[akpm@linux-foundation.org: fix svc_rdma]
[akpm@linux-foundation.org: build fix]
[akpm@linux-foundation.org: fix bnx2x]
[akpm@linux-foundation.org: fix s2io]
[akpm@linux-foundation.org: fix pasemi_mac]
[akpm@linux-foundation.org: fix sdhci]
[akpm@linux-foundation.org: build fix]
[akpm@linux-foundation.org: fix sparc]
[akpm@linux-foundation.org: fix ibmvscsi]
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API.txt                      |    4 
 arch/arm/common/dmabounce.c                    |    2 
 arch/ia64/hp/common/hwsw_iommu.c               |    5 
 arch/ia64/hp/common/sba_iommu.c                |    2 
 arch/ia64/sn/pci/pci_dma.c                     |    2 
 arch/mips/mm/dma-default.c                     |    2 
 arch/powerpc/platforms/cell/celleb_scc_pciex.c |    2 
 arch/powerpc/platforms/cell/spider-pci.c       |    2 
 arch/powerpc/platforms/iseries/mf.c            |    2 
 arch/x86/kernel/pci-calgary_64.c               |    2 
 arch/x86/kernel/pci-dma.c                      |   27 ++--
 arch/x86/kernel/pci-gart_64.c                  |    3 
 arch/x86/kernel/pci-nommu.c                    |   14 --
 arch/x86/kernel/pci-swiotlb_64.c               |    2 
 drivers/firewire/fw-iso.c                      |    2 
 drivers/firewire/fw-ohci.c                     |    2 
 drivers/firewire/fw-sbp2.c                     |    8 -
 drivers/infiniband/hw/ipath/ipath_sdma.c       |    2 
 drivers/infiniband/hw/ipath/ipath_user_sdma.c  |    6 
 drivers/infiniband/hw/mthca/mthca_eq.c         |    2 
 drivers/media/dvb/pluto2/pluto2.c              |    2 
 drivers/mmc/host/sdhci.c                       |    4 
 drivers/net/arm/ep93xx_eth.c                   |    4 
 drivers/net/bnx2x_main.c                       |    4 
 drivers/net/cxgb3/sge.c                        |    2 
 drivers/net/e100.c                             |    2 
 drivers/net/e1000e/ethtool.c                   |    4 
 drivers/net/e1000e/netdev.c                    |   11 -
 drivers/net/ibmveth.c                          |   38 +++--
 drivers/net/iseries_veth.c                     |    4 
 drivers/net/mlx4/eq.c                          |    2 
 drivers/net/pasemi_mac.c                       |    6 
 drivers/net/qla3xxx.c                          |   12 -
 drivers/net/s2io.c                             |   48 ++++---
 drivers/net/sfc/rx.c                           |    4 
 drivers/net/sfc/tx.c                           |    7 -
 drivers/net/spider_net.c                       |    4 
 drivers/net/tc35815.c                          |    4 
 drivers/net/wireless/ath5k/base.c              |    4 
 drivers/scsi/ibmvscsi/ibmvfc.c                 |    4 
 drivers/scsi/ibmvscsi/ibmvscsi.c               |    4 
 drivers/scsi/ibmvscsi/ibmvstgt.c               |    2 
 drivers/scsi/ibmvscsi/rpa_vscsi.c              |    2 
 drivers/spi/atmel_spi.c                        |    4 
 drivers/spi/au1550_spi.c                       |    6 
 drivers/spi/omap2_mcspi.c                      |    4 
 drivers/spi/pxa2xx_spi.c                       |    4 
 drivers/spi/spi_imx.c                          |    6 
 include/asm-alpha/dma-mapping.h                |    6 
 include/asm-alpha/pci.h                        |    2 
 include/asm-arm/dma-mapping.h                  |    2 
 include/asm-avr32/dma-mapping.h                |    2 
 include/asm-cris/dma-mapping.h                 |    2 
 include/asm-frv/dma-mapping.h                  |    2 
 include/asm-generic/dma-mapping-broken.h       |    2 
 include/asm-generic/dma-mapping.h              |    4 
 include/asm-generic/pci-dma-compat.h           |    4 
 include/asm-ia64/machvec.h                     |    2 
 include/asm-m68k/dma-mapping.h                 |    2 
 include/asm-mips/dma-mapping.h                 |    2 
 include/asm-mn10300/dma-mapping.h              |    2 
 include/asm-parisc/dma-mapping.h               |    2 
 include/asm-powerpc/dma-mapping.h              |    2 
 include/asm-sh/dma-mapping.h                   |    2 
 include/asm-sparc/dma-mapping_64.h             |    2 
 include/asm-sparc/pci_32.h                     |    3 
 include/asm-sparc/pci_64.h                     |    5 
 include/asm-x86/device.h                       |    3 
 include/asm-x86/dma-mapping.h                  |   99 ++++++++++-----
 include/asm-x86/swiotlb.h                      |    2 
 include/asm-xtensa/dma-mapping.h               |    2 
 include/linux/i2o.h                            |    2 
 include/linux/ssb/ssb.h                        |    4 
 include/rdma/ib_verbs.h                        |    2 
 lib/swiotlb.c                                  |    4 
 net/sunrpc/xprtrdma/svc_rdma_sendto.c          |    3 
 76 files changed, 256 insertions(+), 210 deletions(-)

diff -puN Documentation/DMA-API.txt~dma-mapping-add-the-device-argument-to-dma_mapping_error Documentation/DMA-API.txt
--- a/Documentation/DMA-API.txt~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/Documentation/DMA-API.txt
@@ -298,10 +298,10 @@ recommended that you never use these unl
 cache width is.
 
 int
-dma_mapping_error(dma_addr_t dma_addr)
+dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 
 int
-pci_dma_mapping_error(dma_addr_t dma_addr)
+pci_dma_mapping_error(struct pci_dev *hwdev, dma_addr_t dma_addr)
 
 In some circumstances dma_map_single and dma_map_page will fail to create
 a mapping. A driver can check for these errors by testing the returned
diff -puN arch/arm/common/dmabounce.c~dma-mapping-add-the-device-argument-to-dma_mapping_error arch/arm/common/dmabounce.c
--- a/arch/arm/common/dmabounce.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/arch/arm/common/dmabounce.c
@@ -280,7 +280,7 @@ unmap_single(struct device *dev, dma_add
 	/*
 	 * Trying to unmap an invalid mapping
 	 */
-	if (dma_mapping_error(dma_addr)) {
+	if (dma_mapping_error(dev, dma_addr)) {
 		dev_err(dev, "Trying to unmap invalid mapping\n");
 		return;
 	}
diff -puN arch/ia64/hp/common/hwsw_iommu.c~dma-mapping-add-the-device-argument-to-dma_mapping_error arch/ia64/hp/common/hwsw_iommu.c
--- a/arch/ia64/hp/common/hwsw_iommu.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/arch/ia64/hp/common/hwsw_iommu.c
@@ -186,9 +186,10 @@ hwsw_dma_supported (struct device *dev, 
 }
 
 int
-hwsw_dma_mapping_error (dma_addr_t dma_addr)
+hwsw_dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
-	return hwiommu_dma_mapping_error (dma_addr) || swiotlb_dma_mapping_error(dma_addr);
+	return hwiommu_dma_mapping_error(dev, dma_addr) ||
+		swiotlb_dma_mapping_error(dev, dma_addr);
 }
 
 EXPORT_SYMBOL(hwsw_dma_mapping_error);
diff -puN arch/ia64/hp/common/sba_iommu.c~dma-mapping-add-the-device-argument-to-dma_mapping_error arch/ia64/hp/common/sba_iommu.c
--- a/arch/ia64/hp/common/sba_iommu.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/arch/ia64/hp/common/sba_iommu.c
@@ -2147,7 +2147,7 @@ sba_dma_supported (struct device *dev, u
 }
 
 int
-sba_dma_mapping_error (dma_addr_t dma_addr)
+sba_dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	return 0;
 }
diff -puN arch/ia64/sn/pci/pci_dma.c~dma-mapping-add-the-device-argument-to-dma_mapping_error arch/ia64/sn/pci/pci_dma.c
--- a/arch/ia64/sn/pci/pci_dma.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/arch/ia64/sn/pci/pci_dma.c
@@ -350,7 +350,7 @@ void sn_dma_sync_sg_for_device(struct de
 }
 EXPORT_SYMBOL(sn_dma_sync_sg_for_device);
 
-int sn_dma_mapping_error(dma_addr_t dma_addr)
+int sn_dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	return 0;
 }
diff -puN arch/mips/mm/dma-default.c~dma-mapping-add-the-device-argument-to-dma_mapping_error arch/mips/mm/dma-default.c
--- a/arch/mips/mm/dma-default.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/arch/mips/mm/dma-default.c
@@ -348,7 +348,7 @@ void dma_sync_sg_for_device(struct devic
 
 EXPORT_SYMBOL(dma_sync_sg_for_device);
 
-int dma_mapping_error(dma_addr_t dma_addr)
+int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	return 0;
 }
diff -puN arch/powerpc/platforms/cell/celleb_scc_pciex.c~dma-mapping-add-the-device-argument-to-dma_mapping_error arch/powerpc/platforms/cell/celleb_scc_pciex.c
--- a/arch/powerpc/platforms/cell/celleb_scc_pciex.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/arch/powerpc/platforms/cell/celleb_scc_pciex.c
@@ -281,7 +281,7 @@ static int __init scc_pciex_iowa_init(st
 
 	dummy_page_da = dma_map_single(bus->phb->parent, dummy_page_va,
 				       PAGE_SIZE, DMA_FROM_DEVICE);
-	if (dma_mapping_error(dummy_page_da)) {
+	if (dma_mapping_error(bus->phb->parent, dummy_page_da)) {
 		pr_err("PCIEX:Map dummy page failed.\n");
 		kfree(dummy_page_va);
 		return -1;
diff -puN arch/powerpc/platforms/cell/spider-pci.c~dma-mapping-add-the-device-argument-to-dma_mapping_error arch/powerpc/platforms/cell/spider-pci.c
--- a/arch/powerpc/platforms/cell/spider-pci.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/arch/powerpc/platforms/cell/spider-pci.c
@@ -111,7 +111,7 @@ static int __init spiderpci_pci_setup_ch
 
 	dummy_page_da = dma_map_single(phb->parent, dummy_page_va,
 				       PAGE_SIZE, DMA_FROM_DEVICE);
-	if (dma_mapping_error(dummy_page_da)) {
+	if (dma_mapping_error(phb->parent, dummy_page_da)) {
 		pr_err("SPIDER-IOWA:Map dummy page filed.\n");
 		kfree(dummy_page_va);
 		return -1;
diff -puN arch/powerpc/platforms/iseries/mf.c~dma-mapping-add-the-device-argument-to-dma_mapping_error arch/powerpc/platforms/iseries/mf.c
--- a/arch/powerpc/platforms/iseries/mf.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/arch/powerpc/platforms/iseries/mf.c
@@ -871,7 +871,7 @@ static int proc_mf_dump_cmdline(char *pa
 		count = 256 - off;
 
 	dma_addr = iseries_hv_map(page, off + count, DMA_FROM_DEVICE);
-	if (dma_mapping_error(dma_addr))
+	if (dma_mapping_error(NULL, dma_addr))
 		return -ENOMEM;
 	memset(page, 0, off + count);
 	memset(&vsp_cmd, 0, sizeof(vsp_cmd));
diff -puN arch/x86/kernel/pci-calgary_64.c~dma-mapping-add-the-device-argument-to-dma_mapping_error arch/x86/kernel/pci-calgary_64.c
--- a/arch/x86/kernel/pci-calgary_64.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/arch/x86/kernel/pci-calgary_64.c
@@ -544,7 +544,7 @@ error:
 	return ret;
 }
 
-static const struct dma_mapping_ops calgary_dma_ops = {
+static struct dma_mapping_ops calgary_dma_ops = {
 	.alloc_coherent = calgary_alloc_coherent,
 	.map_single = calgary_map_single,
 	.unmap_single = calgary_unmap_single,
diff -puN arch/x86/kernel/pci-dma.c~dma-mapping-add-the-device-argument-to-dma_mapping_error arch/x86/kernel/pci-dma.c
--- a/arch/x86/kernel/pci-dma.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/arch/x86/kernel/pci-dma.c
@@ -11,7 +11,7 @@
 
 static int forbid_dac __read_mostly;
 
-const struct dma_mapping_ops *dma_ops;
+struct dma_mapping_ops *dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
 static int iommu_sac_force __read_mostly;
@@ -312,6 +312,8 @@ static int dma_release_coherent(struct d
 
 int dma_supported(struct device *dev, u64 mask)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(dev);
+
 #ifdef CONFIG_PCI
 	if (mask > 0xffffffff && forbid_dac > 0) {
 		dev_info(dev, "PCI: Disallowing DAC for device\n");
@@ -319,8 +321,8 @@ int dma_supported(struct device *dev, u6
 	}
 #endif
 
-	if (dma_ops->dma_supported)
-		return dma_ops->dma_supported(dev, mask);
+	if (ops->dma_supported)
+		return ops->dma_supported(dev, mask);
 
 	/* Copied from i386. Doesn't make much sense, because it will
 	   only work for pci_alloc_coherent.
@@ -367,6 +369,7 @@ void *
 dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		   gfp_t gfp)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(dev);
 	void *memory = NULL;
 	struct page *page;
 	unsigned long dma_mask = 0;
@@ -435,8 +438,8 @@ dma_alloc_coherent(struct device *dev, s
 			/* Let low level make its own zone decisions */
 			gfp &= ~(GFP_DMA32|GFP_DMA);
 
-			if (dma_ops->alloc_coherent)
-				return dma_ops->alloc_coherent(dev, size,
+			if (ops->alloc_coherent)
+				return ops->alloc_coherent(dev, size,
 							   dma_handle, gfp);
 			return NULL;
 		}
@@ -448,14 +451,14 @@ dma_alloc_coherent(struct device *dev, s
 		}
 	}
 
-	if (dma_ops->alloc_coherent) {
+	if (ops->alloc_coherent) {
 		free_pages((unsigned long)memory, get_order(size));
 		gfp &= ~(GFP_DMA|GFP_DMA32);
-		return dma_ops->alloc_coherent(dev, size, dma_handle, gfp);
+		return ops->alloc_coherent(dev, size, dma_handle, gfp);
 	}
 
-	if (dma_ops->map_simple) {
-		*dma_handle = dma_ops->map_simple(dev, virt_to_phys(memory),
+	if (ops->map_simple) {
+		*dma_handle = ops->map_simple(dev, virt_to_phys(memory),
 					      size,
 					      PCI_DMA_BIDIRECTIONAL);
 		if (*dma_handle != bad_dma_address)
@@ -477,12 +480,14 @@ EXPORT_SYMBOL(dma_alloc_coherent);
 void dma_free_coherent(struct device *dev, size_t size,
 			 void *vaddr, dma_addr_t bus)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(dev);
+
 	int order = get_order(size);
 	WARN_ON(irqs_disabled());	/* for portability */
 	if (dma_release_coherent(dev, order, vaddr))
 		return;
-	if (dma_ops->unmap_single)
-		dma_ops->unmap_single(dev, bus, size, 0);
+	if (ops->unmap_single)
+		ops->unmap_single(dev, bus, size, 0);
 	free_pages((unsigned long)vaddr, order);
 }
 EXPORT_SYMBOL(dma_free_coherent);
diff -puN arch/x86/kernel/pci-gart_64.c~dma-mapping-add-the-device-argument-to-dma_mapping_error arch/x86/kernel/pci-gart_64.c
--- a/arch/x86/kernel/pci-gart_64.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/arch/x86/kernel/pci-gart_64.c
@@ -692,8 +692,7 @@ static __init int init_k8_gatt(struct ag
 
 extern int agp_amd64_init(void);
 
-static const struct dma_mapping_ops gart_dma_ops = {
-	.mapping_error			= NULL,
+static struct dma_mapping_ops gart_dma_ops = {
 	.map_single			= gart_map_single,
 	.map_simple			= gart_map_simple,
 	.unmap_single			= gart_unmap_single,
diff -puN arch/x86/kernel/pci-nommu.c~dma-mapping-add-the-device-argument-to-dma_mapping_error arch/x86/kernel/pci-nommu.c
--- a/arch/x86/kernel/pci-nommu.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/arch/x86/kernel/pci-nommu.c
@@ -72,21 +72,9 @@ static int nommu_map_sg(struct device *h
 	return nents;
 }
 
-/* Make sure we keep the same behaviour */
-static int nommu_mapping_error(dma_addr_t dma_addr)
-{
-#ifdef CONFIG_X86_32
-	return 0;
-#else
-	return (dma_addr == bad_dma_address);
-#endif
-}
-
-
-const struct dma_mapping_ops nommu_dma_ops = {
+struct dma_mapping_ops nommu_dma_ops = {
 	.map_single = nommu_map_single,
 	.map_sg = nommu_map_sg,
-	.mapping_error = nommu_mapping_error,
 	.is_phys = 1,
 };
 
diff -puN arch/x86/kernel/pci-swiotlb_64.c~dma-mapping-add-the-device-argument-to-dma_mapping_error arch/x86/kernel/pci-swiotlb_64.c
--- a/arch/x86/kernel/pci-swiotlb_64.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/arch/x86/kernel/pci-swiotlb_64.c
@@ -18,7 +18,7 @@ swiotlb_map_single_phys(struct device *h
 	return swiotlb_map_single(hwdev, phys_to_virt(paddr), size, direction);
 }
 
-const struct dma_mapping_ops swiotlb_dma_ops = {
+struct dma_mapping_ops swiotlb_dma_ops = {
 	.mapping_error = swiotlb_dma_mapping_error,
 	.alloc_coherent = swiotlb_alloc_coherent,
 	.free_coherent = swiotlb_free_coherent,
diff -puN drivers/firewire/fw-iso.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/firewire/fw-iso.c
--- a/drivers/firewire/fw-iso.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/firewire/fw-iso.c
@@ -50,7 +50,7 @@ fw_iso_buffer_init(struct fw_iso_buffer 
 
 		address = dma_map_page(card->device, buffer->pages[i],
 				       0, PAGE_SIZE, direction);
-		if (dma_mapping_error(address)) {
+		if (dma_mapping_error(card->device, address)) {
 			__free_page(buffer->pages[i]);
 			goto out_pages;
 		}
diff -puN drivers/firewire/fw-ohci.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/firewire/fw-ohci.c
--- a/drivers/firewire/fw-ohci.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/firewire/fw-ohci.c
@@ -953,7 +953,7 @@ at_context_queue_packet(struct context *
 		payload_bus =
 			dma_map_single(ohci->card.device, packet->payload,
 				       packet->payload_length, DMA_TO_DEVICE);
-		if (dma_mapping_error(payload_bus)) {
+		if (dma_mapping_error(ohci->card.device, payload_bus)) {
 			packet->ack = RCODE_SEND_ERROR;
 			return -1;
 		}
diff -puN drivers/firewire/fw-sbp2.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/firewire/fw-sbp2.c
--- a/drivers/firewire/fw-sbp2.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/firewire/fw-sbp2.c
@@ -543,7 +543,7 @@ sbp2_send_management_orb(struct sbp2_log
 	orb->response_bus =
 		dma_map_single(device->card->device, &orb->response,
 			       sizeof(orb->response), DMA_FROM_DEVICE);
-	if (dma_mapping_error(orb->response_bus))
+	if (dma_mapping_error(device->card->device, orb->response_bus))
 		goto fail_mapping_response;
 
 	orb->request.response.high = 0;
@@ -577,7 +577,7 @@ sbp2_send_management_orb(struct sbp2_log
 	orb->base.request_bus =
 		dma_map_single(device->card->device, &orb->request,
 			       sizeof(orb->request), DMA_TO_DEVICE);
-	if (dma_mapping_error(orb->base.request_bus))
+	if (dma_mapping_error(device->card->device, orb->base.request_bus))
 		goto fail_mapping_request;
 
 	sbp2_send_orb(&orb->base, lu, node_id, generation,
@@ -1424,7 +1424,7 @@ sbp2_map_scatterlist(struct sbp2_command
 	orb->page_table_bus =
 		dma_map_single(device->card->device, orb->page_table,
 			       sizeof(orb->page_table), DMA_TO_DEVICE);
-	if (dma_mapping_error(orb->page_table_bus))
+	if (dma_mapping_error(device->card->device, orb->page_table_bus))
 		goto fail_page_table;
 
 	/*
@@ -1509,7 +1509,7 @@ static int sbp2_scsi_queuecommand(struct
 	orb->base.request_bus =
 		dma_map_single(device->card->device, &orb->request,
 			       sizeof(orb->request), DMA_TO_DEVICE);
-	if (dma_mapping_error(orb->base.request_bus))
+	if (dma_mapping_error(device->card->device, orb->base.request_bus))
 		goto out;
 
 	sbp2_send_orb(&orb->base, lu, lu->tgt->node_id, lu->generation,
diff -puN drivers/infiniband/hw/ipath/ipath_sdma.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/infiniband/hw/ipath/ipath_sdma.c
--- a/drivers/infiniband/hw/ipath/ipath_sdma.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/infiniband/hw/ipath/ipath_sdma.c
@@ -698,7 +698,7 @@ retry:
 
 	addr = dma_map_single(&dd->pcidev->dev, tx->txreq.map_addr,
 			      tx->map_len, DMA_TO_DEVICE);
-	if (dma_mapping_error(addr)) {
+	if (dma_mapping_error(&dd->pcidev->dev, addr)) {
 		ret = -EIO;
 		goto unlock;
 	}
diff -puN drivers/infiniband/hw/ipath/ipath_user_sdma.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/infiniband/hw/ipath/ipath_user_sdma.c
--- a/drivers/infiniband/hw/ipath/ipath_user_sdma.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/infiniband/hw/ipath/ipath_user_sdma.c
@@ -206,7 +206,7 @@ static int ipath_user_sdma_coalesce(cons
 
 	dma_addr = dma_map_page(&dd->pcidev->dev, page, 0, len,
 				DMA_TO_DEVICE);
-	if (dma_mapping_error(dma_addr)) {
+	if (dma_mapping_error(&dd->pcidev->dev, dma_addr)) {
 		ret = -ENOMEM;
 		goto free_unmap;
 	}
@@ -301,7 +301,7 @@ static int ipath_user_sdma_pin_pages(con
 				     pages[j], 0, flen, DMA_TO_DEVICE);
 		unsigned long fofs = addr & ~PAGE_MASK;
 
-		if (dma_mapping_error(dma_addr)) {
+		if (dma_mapping_error(&dd->pcidev->dev, dma_addr)) {
 			ret = -ENOMEM;
 			goto done;
 		}
@@ -508,7 +508,7 @@ static int ipath_user_sdma_queue_pkts(co
 		if (page) {
 			dma_addr = dma_map_page(&dd->pcidev->dev,
 						page, 0, len, DMA_TO_DEVICE);
-			if (dma_mapping_error(dma_addr)) {
+			if (dma_mapping_error(&dd->pcidev->dev, dma_addr)) {
 				ret = -ENOMEM;
 				goto free_pbc;
 			}
diff -puN drivers/infiniband/hw/mthca/mthca_eq.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/infiniband/hw/mthca/mthca_eq.c
--- a/drivers/infiniband/hw/mthca/mthca_eq.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/infiniband/hw/mthca/mthca_eq.c
@@ -780,7 +780,7 @@ int mthca_map_eq_icm(struct mthca_dev *d
 		return -ENOMEM;
 	dev->eq_table.icm_dma  = pci_map_page(dev->pdev, dev->eq_table.icm_page, 0,
 					      PAGE_SIZE, PCI_DMA_BIDIRECTIONAL);
-	if (pci_dma_mapping_error(dev->eq_table.icm_dma)) {
+	if (pci_dma_mapping_error(dev->pdev, dev->eq_table.icm_dma)) {
 		__free_page(dev->eq_table.icm_page);
 		return -ENOMEM;
 	}
diff -puN drivers/media/dvb/pluto2/pluto2.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/media/dvb/pluto2/pluto2.c
--- a/drivers/media/dvb/pluto2/pluto2.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/media/dvb/pluto2/pluto2.c
@@ -242,7 +242,7 @@ static int __devinit pluto_dma_map(struc
 	pluto->dma_addr = pci_map_single(pluto->pdev, pluto->dma_buf,
 			TS_DMA_BYTES, PCI_DMA_FROMDEVICE);
 
-	return pci_dma_mapping_error(pluto->dma_addr);
+	return pci_dma_mapping_error(pluto->pdev, pluto->dma_addr);
 }
 
 static void pluto_dma_unmap(struct pluto *pluto)
diff -puN drivers/mmc/host/sdhci.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/mmc/host/sdhci.c
@@ -337,7 +337,7 @@ static int sdhci_adma_table_pre(struct s
 
 	host->align_addr = dma_map_single(mmc_dev(host->mmc),
 		host->align_buffer, 128 * 4, direction);
-	if (dma_mapping_error(host->align_addr))
+	if (dma_mapping_error(mmc_dev(host->mmc), host->align_addr))
 		goto fail;
 	BUG_ON(host->align_addr & 0x3);
 
@@ -439,7 +439,7 @@ static int sdhci_adma_table_pre(struct s
 
 	host->adma_addr = dma_map_single(mmc_dev(host->mmc),
 		host->adma_desc, (128 * 2 + 1) * 4, DMA_TO_DEVICE);
-	if (dma_mapping_error(host->align_addr))
+	if (dma_mapping_error(mmc_dev(host->mmc), host->align_addr))
 		goto unmap_entries;
 	BUG_ON(host->adma_addr & 0x3);
 
diff -puN drivers/net/arm/ep93xx_eth.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/net/arm/ep93xx_eth.c
--- a/drivers/net/arm/ep93xx_eth.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/net/arm/ep93xx_eth.c
@@ -482,7 +482,7 @@ static int ep93xx_alloc_buffers(struct e
 			goto err;
 
 		d = dma_map_single(NULL, page, PAGE_SIZE, DMA_FROM_DEVICE);
-		if (dma_mapping_error(d)) {
+		if (dma_mapping_error(NULL, d)) {
 			free_page((unsigned long)page);
 			goto err;
 		}
@@ -505,7 +505,7 @@ static int ep93xx_alloc_buffers(struct e
 			goto err;
 
 		d = dma_map_single(NULL, page, PAGE_SIZE, DMA_TO_DEVICE);
-		if (dma_mapping_error(d)) {
+		if (dma_mapping_error(NULL, d)) {
 			free_page((unsigned long)page);
 			goto err;
 		}
diff -puN drivers/net/bnx2x_main.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/net/bnx2x_main.c
--- a/drivers/net/bnx2x_main.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/net/bnx2x_main.c
@@ -1020,7 +1020,7 @@ static inline int bnx2x_alloc_rx_sge(str
 
 	mapping = pci_map_page(bp->pdev, page, 0, BCM_PAGE_SIZE*PAGES_PER_SGE,
 			       PCI_DMA_FROMDEVICE);
-	if (unlikely(dma_mapping_error(mapping))) {
+	if (unlikely(dma_mapping_error(&bp->pdev->dev, mapping))) {
 		__free_pages(page, PAGES_PER_SGE_SHIFT);
 		return -ENOMEM;
 	}
@@ -1048,7 +1048,7 @@ static inline int bnx2x_alloc_rx_skb(str
 
 	mapping = pci_map_single(bp->pdev, skb->data, bp->rx_buf_use_size,
 				 PCI_DMA_FROMDEVICE);
-	if (unlikely(dma_mapping_error(mapping))) {
+	if (unlikely(dma_mapping_error(&bp->pdev->dev, mapping))) {
 		dev_kfree_skb(skb);
 		return -ENOMEM;
 	}
diff -puN drivers/net/cxgb3/sge.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/net/cxgb3/sge.c
--- a/drivers/net/cxgb3/sge.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/net/cxgb3/sge.c
@@ -386,7 +386,7 @@ static inline int add_one_rx_buf(void *v
 	dma_addr_t mapping;
 
 	mapping = pci_map_single(pdev, va, len, PCI_DMA_FROMDEVICE);
-	if (unlikely(pci_dma_mapping_error(mapping)))
+	if (unlikely(pci_dma_mapping_error(pdev, mapping)))
 		return -ENOMEM;
 
 	pci_unmap_addr_set(sd, dma_addr, mapping);
diff -puN drivers/net/e100.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/net/e100.c
--- a/drivers/net/e100.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/net/e100.c
@@ -1790,7 +1790,7 @@ static int e100_rx_alloc_skb(struct nic 
 	rx->dma_addr = pci_map_single(nic->pdev, rx->skb->data,
 		RFD_BUF_LEN, PCI_DMA_BIDIRECTIONAL);
 
-	if (pci_dma_mapping_error(rx->dma_addr)) {
+	if (pci_dma_mapping_error(nic->pdev, rx->dma_addr)) {
 		dev_kfree_skb_any(rx->skb);
 		rx->skb = NULL;
 		rx->dma_addr = 0;
diff -puN drivers/net/e1000e/ethtool.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/net/e1000e/ethtool.c
--- a/drivers/net/e1000e/ethtool.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/net/e1000e/ethtool.c
@@ -1090,7 +1090,7 @@ static int e1000_setup_desc_rings(struct
 		tx_ring->buffer_info[i].dma =
 			pci_map_single(pdev, skb->data, skb->len,
 				       PCI_DMA_TODEVICE);
-		if (pci_dma_mapping_error(tx_ring->buffer_info[i].dma)) {
+		if (pci_dma_mapping_error(pdev, tx_ring->buffer_info[i].dma)) {
 			ret_val = 4;
 			goto err_nomem;
 		}
@@ -1153,7 +1153,7 @@ static int e1000_setup_desc_rings(struct
 		rx_ring->buffer_info[i].dma =
 			pci_map_single(pdev, skb->data, 2048,
 				       PCI_DMA_FROMDEVICE);
-		if (pci_dma_mapping_error(rx_ring->buffer_info[i].dma)) {
+		if (pci_dma_mapping_error(pdev, rx_ring->buffer_info[i].dma)) {
 			ret_val = 8;
 			goto err_nomem;
 		}
diff -puN drivers/net/e1000e/netdev.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/net/e1000e/netdev.c
--- a/drivers/net/e1000e/netdev.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/net/e1000e/netdev.c
@@ -195,7 +195,7 @@ map_skb:
 		buffer_info->dma = pci_map_single(pdev, skb->data,
 						  adapter->rx_buffer_len,
 						  PCI_DMA_FROMDEVICE);
-		if (pci_dma_mapping_error(buffer_info->dma)) {
+		if (pci_dma_mapping_error(pdev, buffer_info->dma)) {
 			dev_err(&pdev->dev, "RX DMA map failed\n");
 			adapter->rx_dma_failed++;
 			break;
@@ -265,7 +265,7 @@ static void e1000_alloc_rx_buffers_ps(st
 						   ps_page->page,
 						   0, PAGE_SIZE,
 						   PCI_DMA_FROMDEVICE);
-				if (pci_dma_mapping_error(ps_page->dma)) {
+				if (pci_dma_mapping_error(pdev, ps_page->dma)) {
 					dev_err(&adapter->pdev->dev,
 					  "RX DMA page map failed\n");
 					adapter->rx_dma_failed++;
@@ -300,7 +300,7 @@ static void e1000_alloc_rx_buffers_ps(st
 		buffer_info->dma = pci_map_single(pdev, skb->data,
 						  adapter->rx_ps_bsize0,
 						  PCI_DMA_FROMDEVICE);
-		if (pci_dma_mapping_error(buffer_info->dma)) {
+		if (pci_dma_mapping_error(pdev, buffer_info->dma)) {
 			dev_err(&pdev->dev, "RX DMA map failed\n");
 			adapter->rx_dma_failed++;
 			/* cleanup skb */
@@ -3344,7 +3344,7 @@ static int e1000_tx_map(struct e1000_ada
 				skb->data + offset,
 				size,
 				PCI_DMA_TODEVICE);
-		if (pci_dma_mapping_error(buffer_info->dma)) {
+		if (pci_dma_mapping_error(adapter->pdev, buffer_info->dma)) {
 			dev_err(&adapter->pdev->dev, "TX DMA map failed\n");
 			adapter->tx_dma_failed++;
 			return -1;
@@ -3382,7 +3382,8 @@ static int e1000_tx_map(struct e1000_ada
 					offset,
 					size,
 					PCI_DMA_TODEVICE);
-			if (pci_dma_mapping_error(buffer_info->dma)) {
+			if (pci_dma_mapping_error(adapter->pdev,
+						  buffer_info->dma)) {
 				dev_err(&adapter->pdev->dev,
 					"TX DMA page map failed\n");
 				adapter->tx_dma_failed++;
diff -puN drivers/net/ibmveth.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/net/ibmveth.c
--- a/drivers/net/ibmveth.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/net/ibmveth.c
@@ -260,7 +260,7 @@ static void ibmveth_replenish_buffer_poo
 		dma_addr = dma_map_single(&adapter->vdev->dev, skb->data,
 				pool->buff_size, DMA_FROM_DEVICE);
 
-		if (dma_mapping_error(dma_addr))
+		if (dma_mapping_error((&adapter->vdev->dev, dma_addr))
 			goto failure;
 
 		pool->free_map[free_index] = IBM_VETH_INVALID_MAP;
@@ -294,7 +294,7 @@ failure:
 		pool->consumer_index = pool->size - 1;
 	else
 		pool->consumer_index--;
-	if (!dma_mapping_error(dma_addr))
+	if (!dma_mapping_error((&adapter->vdev->dev, dma_addr))
 		dma_unmap_single(&adapter->vdev->dev,
 		                 pool->dma_addr[index], pool->buff_size,
 		                 DMA_FROM_DEVICE);
@@ -448,11 +448,11 @@ static void ibmveth_rxq_harvest_buffer(s
 static void ibmveth_cleanup(struct ibmveth_adapter *adapter)
 {
 	int i;
+	struct device *dev = &adapter->vdev->dev;
 
 	if(adapter->buffer_list_addr != NULL) {
-		if(!dma_mapping_error(adapter->buffer_list_dma)) {
-			dma_unmap_single(&adapter->vdev->dev,
-					adapter->buffer_list_dma, 4096,
+		if (!dma_mapping_error(dev, adapter->buffer_list_dma)) {
+			dma_unmap_single(dev, adapter->buffer_list_dma, 4096,
 					DMA_BIDIRECTIONAL);
 			adapter->buffer_list_dma = DMA_ERROR_CODE;
 		}
@@ -461,9 +461,8 @@ static void ibmveth_cleanup(struct ibmve
 	}
 
 	if(adapter->filter_list_addr != NULL) {
-		if(!dma_mapping_error(adapter->filter_list_dma)) {
-			dma_unmap_single(&adapter->vdev->dev,
-					adapter->filter_list_dma, 4096,
+		if (!dma_mapping_error(dev, adapter->filter_list_dma)) {
+			dma_unmap_single(dev, adapter->filter_list_dma, 4096,
 					DMA_BIDIRECTIONAL);
 			adapter->filter_list_dma = DMA_ERROR_CODE;
 		}
@@ -472,8 +471,8 @@ static void ibmveth_cleanup(struct ibmve
 	}
 
 	if(adapter->rx_queue.queue_addr != NULL) {
-		if(!dma_mapping_error(adapter->rx_queue.queue_dma)) {
-			dma_unmap_single(&adapter->vdev->dev,
+		if (!dma_mapping_error(dev, adapter->rx_queue.queue_dma)) {
+			dma_unmap_single(dev,
 					adapter->rx_queue.queue_dma,
 					adapter->rx_queue.queue_len,
 					DMA_BIDIRECTIONAL);
@@ -535,6 +534,7 @@ static int ibmveth_open(struct net_devic
 	int rc;
 	union ibmveth_buf_desc rxq_desc;
 	int i;
+	struct device *dev;
 
 	ibmveth_debug_printk("open starting\n");
 
@@ -563,17 +563,19 @@ static int ibmveth_open(struct net_devic
 		return -ENOMEM;
 	}
 
-	adapter->buffer_list_dma = dma_map_single(&adapter->vdev->dev,
+	dev = &adapter->vdev->dev;
+
+	adapter->buffer_list_dma = dma_map_single(dev,
 			adapter->buffer_list_addr, 4096, DMA_BIDIRECTIONAL);
-	adapter->filter_list_dma = dma_map_single(&adapter->vdev->dev,
+	adapter->filter_list_dma = dma_map_single(dev,
 			adapter->filter_list_addr, 4096, DMA_BIDIRECTIONAL);
-	adapter->rx_queue.queue_dma = dma_map_single(&adapter->vdev->dev,
+	adapter->rx_queue.queue_dma = dma_map_single(dev,
 			adapter->rx_queue.queue_addr,
 			adapter->rx_queue.queue_len, DMA_BIDIRECTIONAL);
 
-	if((dma_mapping_error(adapter->buffer_list_dma) ) ||
-	   (dma_mapping_error(adapter->filter_list_dma)) ||
-	   (dma_mapping_error(adapter->rx_queue.queue_dma))) {
+	if ((dma_mapping_error(dev, adapter->buffer_list_dma)) ||
+	    (dma_mapping_error(dev, adapter->filter_list_dma)) ||
+	    (dma_mapping_error(dev, adapter->rx_queue.queue_dma))) {
 		ibmveth_error_printk("unable to map filter or buffer list pages\n");
 		ibmveth_cleanup(adapter);
 		napi_disable(&adapter->napi);
@@ -645,7 +647,7 @@ static int ibmveth_open(struct net_devic
 	adapter->bounce_buffer_dma =
 	    dma_map_single(&adapter->vdev->dev, adapter->bounce_buffer,
 			   netdev->mtu + IBMVETH_BUFF_OH, DMA_BIDIRECTIONAL);
-	if (dma_mapping_error(adapter->bounce_buffer_dma)) {
+	if (dma_mapping_error(dev, adapter->bounce_buffer_dma)) {
 		ibmveth_error_printk("unable to map bounce buffer\n");
 		ibmveth_cleanup(adapter);
 		napi_disable(&adapter->napi);
@@ -922,7 +924,7 @@ static int ibmveth_start_xmit(struct sk_
 		buf[1] = 0;
 	}
 
-	if (dma_mapping_error(data_dma_addr)) {
+	if (dma_mapping_error((&adapter->vdev->dev, data_dma_addr)) {
 		if (!firmware_has_feature(FW_FEATURE_CMO))
 			ibmveth_error_printk("tx: unable to map xmit buffer\n");
 		skb_copy_from_linear_data(skb, adapter->bounce_buffer,
diff -puN drivers/net/iseries_veth.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/net/iseries_veth.c
--- a/drivers/net/iseries_veth.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/net/iseries_veth.c
@@ -1128,7 +1128,7 @@ static int veth_transmit_to_one(struct s
 	msg->data.addr[0] = dma_map_single(port->dev, skb->data,
 				skb->len, DMA_TO_DEVICE);
 
-	if (dma_mapping_error(msg->data.addr[0]))
+	if (dma_mapping_error(port->dev, msg->data.addr[0]))
 		goto recycle_and_drop;
 
 	msg->dev = port->dev;
@@ -1226,7 +1226,7 @@ static void veth_recycle_msg(struct veth
 		dma_address = msg->data.addr[0];
 		dma_length = msg->data.len[0];
 
-		if (!dma_mapping_error(dma_address))
+		if (!dma_mapping_error(msg->dev, dma_address))
 			dma_unmap_single(msg->dev, dma_address, dma_length,
 					DMA_TO_DEVICE);
 
diff -puN drivers/net/mlx4/eq.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/net/mlx4/eq.c
--- a/drivers/net/mlx4/eq.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/net/mlx4/eq.c
@@ -526,7 +526,7 @@ int mlx4_map_eq_icm(struct mlx4_dev *dev
 		return -ENOMEM;
 	priv->eq_table.icm_dma  = pci_map_page(dev->pdev, priv->eq_table.icm_page, 0,
 					       PAGE_SIZE, PCI_DMA_BIDIRECTIONAL);
-	if (pci_dma_mapping_error(priv->eq_table.icm_dma)) {
+	if (pci_dma_mapping_error(dev->pdev, priv->eq_table.icm_dma)) {
 		__free_page(priv->eq_table.icm_page);
 		return -ENOMEM;
 	}
diff -puN drivers/net/pasemi_mac.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/net/pasemi_mac.c
--- a/drivers/net/pasemi_mac.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/net/pasemi_mac.c
@@ -650,7 +650,7 @@ static void pasemi_mac_replenish_rx_ring
 				     mac->bufsz - LOCAL_SKB_ALIGN,
 				     PCI_DMA_FROMDEVICE);
 
-		if (unlikely(dma_mapping_error(dma))) {
+		if (unlikely(pci_dma_mapping_error(mac->dma_pdev, dma))) {
 			dev_kfree_skb_irq(info->skb);
 			break;
 		}
@@ -1519,7 +1519,7 @@ static int pasemi_mac_start_tx(struct sk
 	map[0] = pci_map_single(mac->dma_pdev, skb->data, skb_headlen(skb),
 				PCI_DMA_TODEVICE);
 	map_size[0] = skb_headlen(skb);
-	if (dma_mapping_error(map[0]))
+	if (pci_dma_mapping_error(mac->dma_pdev, map[0]))
 		goto out_err_nolock;
 
 	for (i = 0; i < nfrags; i++) {
@@ -1529,7 +1529,7 @@ static int pasemi_mac_start_tx(struct sk
 					frag->page_offset, frag->size,
 					PCI_DMA_TODEVICE);
 		map_size[i+1] = frag->size;
-		if (dma_mapping_error(map[i+1])) {
+		if (pci_dma_mapping_error(mac->dma_pdev, map[i+1])) {
 			nfrags = i;
 			goto out_err_nolock;
 		}
diff -puN drivers/net/qla3xxx.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/net/qla3xxx.c
--- a/drivers/net/qla3xxx.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/net/qla3xxx.c
@@ -328,7 +328,7 @@ static void ql_release_to_lrg_buf_free_l
 					     qdev->lrg_buffer_len -
 					     QL_HEADER_SPACE,
 					     PCI_DMA_FROMDEVICE);
-			err = pci_dma_mapping_error(map);
+			err = pci_dma_mapping_error(qdev->pdev, map);
 			if(err) {
 				printk(KERN_ERR "%s: PCI mapping failed with error: %d\n",
 				       qdev->ndev->name, err);
@@ -1919,7 +1919,7 @@ static int ql_populate_free_queue(struct
 						     QL_HEADER_SPACE,
 						     PCI_DMA_FROMDEVICE);
 
-				err = pci_dma_mapping_error(map);
+				err = pci_dma_mapping_error(qdev->pdev, map);
 				if(err) {
 					printk(KERN_ERR "%s: PCI mapping failed with error: %d\n",
 					       qdev->ndev->name, err);
@@ -2454,7 +2454,7 @@ static int ql_send_map(struct ql3_adapte
 	 */
 	map = pci_map_single(qdev->pdev, skb->data, len, PCI_DMA_TODEVICE);
 
-	err = pci_dma_mapping_error(map);
+	err = pci_dma_mapping_error(qdev->pdev, map);
 	if(err) {
 		printk(KERN_ERR "%s: PCI mapping failed with error: %d\n",
 		       qdev->ndev->name, err);
@@ -2487,7 +2487,7 @@ static int ql_send_map(struct ql3_adapte
 						     sizeof(struct oal),
 						     PCI_DMA_TODEVICE);
 
-				err = pci_dma_mapping_error(map);
+				err = pci_dma_mapping_error(qdev->pdev, map);
 				if(err) {
 
 					printk(KERN_ERR "%s: PCI mapping outbound address list with error: %d\n",
@@ -2514,7 +2514,7 @@ static int ql_send_map(struct ql3_adapte
 					 frag->page_offset, frag->size,
 					 PCI_DMA_TODEVICE);
 
-			err = pci_dma_mapping_error(map);
+			err = pci_dma_mapping_error(qdev->pdev, map);
 			if(err) {
 				printk(KERN_ERR "%s: PCI mapping frags failed with error: %d\n",
 				       qdev->ndev->name, err);
@@ -2916,7 +2916,7 @@ static int ql_alloc_large_buffers(struct
 					     QL_HEADER_SPACE,
 					     PCI_DMA_FROMDEVICE);
 
-			err = pci_dma_mapping_error(map);
+			err = pci_dma_mapping_error(qdev->pdev, map);
 			if(err) {
 				printk(KERN_ERR "%s: PCI mapping failed with error: %d\n",
 				       qdev->ndev->name, err);
diff -puN drivers/net/s2io.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/net/s2io.c
--- a/drivers/net/s2io.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/net/s2io.c
@@ -2512,8 +2512,8 @@ static void stop_nic(struct s2io_nic *ni
  *   Return Value:
  *  SUCCESS on success or an appropriate -ve value on failure.
  */
-
-static int fill_rx_buffers(struct ring_info *ring, int from_card_up)
+static int fill_rx_buffers(struct s2io_nic *nic, struct ring_info *ring,
+				int from_card_up)
 {
 	struct sk_buff *skb;
 	struct RxD_t *rxdp;
@@ -2602,7 +2602,8 @@ static int fill_rx_buffers(struct ring_i
 			rxdp1->Buffer0_ptr = pci_map_single
 			    (ring->pdev, skb->data, size - NET_IP_ALIGN,
 				PCI_DMA_FROMDEVICE);
-			if(pci_dma_mapping_error(rxdp1->Buffer0_ptr))
+			if (pci_dma_mapping_error(nic->pdev,
+						rxdp1->Buffer0_ptr))
 				goto pci_map_failed;
 
 			rxdp->Control_2 =
@@ -2636,7 +2637,8 @@ static int fill_rx_buffers(struct ring_i
 				rxdp3->Buffer0_ptr =
 				   pci_map_single(ring->pdev, ba->ba_0,
 					BUF0_LEN, PCI_DMA_FROMDEVICE);
-				if (pci_dma_mapping_error(rxdp3->Buffer0_ptr))
+			if (pci_dma_mapping_error(nic->pdev,
+						rxdp3->Buffer0_ptr))
 					goto pci_map_failed;
 			} else
 				pci_dma_sync_single_for_device(ring->pdev,
@@ -2655,7 +2657,8 @@ static int fill_rx_buffers(struct ring_i
 				(ring->pdev, skb->data, ring->mtu + 4,
 						PCI_DMA_FROMDEVICE);
 
-				if (pci_dma_mapping_error(rxdp3->Buffer2_ptr))
+				if (pci_dma_mapping_error(nic->pdev,
+							rxdp3->Buffer2_ptr))
 					goto pci_map_failed;
 
 				if (from_card_up) {
@@ -2664,8 +2667,8 @@ static int fill_rx_buffers(struct ring_i
 						ba->ba_1, BUF1_LEN,
 						PCI_DMA_FROMDEVICE);
 
-					if (pci_dma_mapping_error
-						(rxdp3->Buffer1_ptr)) {
+					if (pci_dma_mapping_error(nic->pdev,
+						rxdp3->Buffer1_ptr)) {
 						pci_unmap_single
 							(ring->pdev,
 						    (dma_addr_t)(unsigned long)
@@ -2806,9 +2809,9 @@ static void free_rx_buffers(struct s2io_
 	}
 }
 
-static int s2io_chk_rx_buffers(struct ring_info *ring)
+static int s2io_chk_rx_buffers(struct s2io_nic *nic, struct ring_info *ring)
 {
-	if (fill_rx_buffers(ring, 0) == -ENOMEM) {
+	if (fill_rx_buffers(nic, ring, 0) == -ENOMEM) {
 		DBG_PRINT(INFO_DBG, "%s:Out of memory", ring->dev->name);
 		DBG_PRINT(INFO_DBG, " in Rx Intr!!\n");
 	}
@@ -2848,7 +2851,7 @@ static int s2io_poll_msix(struct napi_st
 		return 0;
 
 	pkts_processed = rx_intr_handler(ring, budget);
-	s2io_chk_rx_buffers(ring);
+	s2io_chk_rx_buffers(nic, ring);
 
 	if (pkts_processed < budget_org) {
 		netif_rx_complete(dev, napi);
@@ -2882,7 +2885,7 @@ static int s2io_poll_inta(struct napi_st
 	for (i = 0; i < config->rx_ring_num; i++) {
 		ring = &mac_control->rings[i];
 		ring_pkts_processed = rx_intr_handler(ring, budget);
-		s2io_chk_rx_buffers(ring);
+		s2io_chk_rx_buffers(nic, ring);
 		pkts_processed += ring_pkts_processed;
 		budget -= ring_pkts_processed;
 		if (budget <= 0)
@@ -2939,7 +2942,8 @@ static void s2io_netpoll(struct net_devi
 		rx_intr_handler(&mac_control->rings[i], 0);
 
 	for (i = 0; i < config->rx_ring_num; i++) {
-		if (fill_rx_buffers(&mac_control->rings[i], 0) == -ENOMEM) {
+		if (fill_rx_buffers(nic, &mac_control->rings[i], 0) ==
+				-ENOMEM) {
 			DBG_PRINT(INFO_DBG, "%s:Out of memory", dev->name);
 			DBG_PRINT(INFO_DBG, " in Rx Netpoll!!\n");
 			break;
@@ -4235,14 +4239,14 @@ static int s2io_xmit(struct sk_buff *skb
 		txdp->Buffer_Pointer = pci_map_single(sp->pdev,
 					fifo->ufo_in_band_v,
 					sizeof(u64), PCI_DMA_TODEVICE);
-		if (pci_dma_mapping_error(txdp->Buffer_Pointer))
+		if (pci_dma_mapping_error(sp->pdev, txdp->Buffer_Pointer))
 			goto pci_map_failed;
 		txdp++;
 	}
 
 	txdp->Buffer_Pointer = pci_map_single
 	    (sp->pdev, skb->data, frg_len, PCI_DMA_TODEVICE);
-	if (pci_dma_mapping_error(txdp->Buffer_Pointer))
+	if (pci_dma_mapping_error(sp->pdev, txdp->Buffer_Pointer))
 		goto pci_map_failed;
 
 	txdp->Host_Control = (unsigned long) skb;
@@ -4345,7 +4349,7 @@ static irqreturn_t s2io_msix_ring_handle
 		netif_rx_schedule(dev, &ring->napi);
 	} else {
 		rx_intr_handler(ring, 0);
-		s2io_chk_rx_buffers(ring);
+		s2io_chk_rx_buffers(sp, ring);
 	}
 
 	return IRQ_HANDLED;
@@ -4826,7 +4830,7 @@ static irqreturn_t s2io_isr(int irq, voi
 		 */
 		if (!config->napi) {
 			for (i = 0; i < config->rx_ring_num; i++)
-				s2io_chk_rx_buffers(&mac_control->rings[i]);
+				s2io_chk_rx_buffers(sp, &mac_control->rings[i]);
 		}
 		writeq(sp->general_int_mask, &bar0->general_int_mask);
 		readl(&bar0->general_int_status);
@@ -6859,7 +6863,7 @@ static int set_rxd_buffer_pointer(struct
 				pci_map_single( sp->pdev, (*skb)->data,
 					size - NET_IP_ALIGN,
 					PCI_DMA_FROMDEVICE);
-			if (pci_dma_mapping_error(rxdp1->Buffer0_ptr))
+			if (pci_dma_mapping_error(sp->pdev, rxdp1->Buffer0_ptr))
 				goto memalloc_failed;
 			rxdp->Host_Control = (unsigned long) (*skb);
 		}
@@ -6886,12 +6890,13 @@ static int set_rxd_buffer_pointer(struct
 				pci_map_single(sp->pdev, (*skb)->data,
 					       dev->mtu + 4,
 					       PCI_DMA_FROMDEVICE);
-			if (pci_dma_mapping_error(rxdp3->Buffer2_ptr))
+			if (pci_dma_mapping_error(sp->pdev, rxdp3->Buffer2_ptr))
 				goto memalloc_failed;
 			rxdp3->Buffer0_ptr = *temp0 =
 				pci_map_single( sp->pdev, ba->ba_0, BUF0_LEN,
 						PCI_DMA_FROMDEVICE);
-			if (pci_dma_mapping_error(rxdp3->Buffer0_ptr)) {
+			if (pci_dma_mapping_error(sp->pdev,
+						rxdp3->Buffer0_ptr)) {
 				pci_unmap_single (sp->pdev,
 					(dma_addr_t)rxdp3->Buffer2_ptr,
 					dev->mtu + 4, PCI_DMA_FROMDEVICE);
@@ -6903,7 +6908,8 @@ static int set_rxd_buffer_pointer(struct
 			rxdp3->Buffer1_ptr = *temp1 =
 				pci_map_single(sp->pdev, ba->ba_1, BUF1_LEN,
 						PCI_DMA_FROMDEVICE);
-			if (pci_dma_mapping_error(rxdp3->Buffer1_ptr)) {
+			if (pci_dma_mapping_error(sp->pdev,
+						rxdp3->Buffer1_ptr)) {
 				pci_unmap_single (sp->pdev,
 					(dma_addr_t)rxdp3->Buffer0_ptr,
 					BUF0_LEN, PCI_DMA_FROMDEVICE);
@@ -7187,7 +7193,7 @@ static int s2io_card_up(struct s2io_nic 
 
 	for (i = 0; i < config->rx_ring_num; i++) {
 		mac_control->rings[i].mtu = dev->mtu;
-		ret = fill_rx_buffers(&mac_control->rings[i], 1);
+		ret = fill_rx_buffers(sp, &mac_control->rings[i], 1);
 		if (ret) {
 			DBG_PRINT(ERR_DBG, "%s: Out of memory in Open\n",
 				  dev->name);
diff -puN drivers/net/sfc/rx.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/net/sfc/rx.c
--- a/drivers/net/sfc/rx.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/net/sfc/rx.c
@@ -233,7 +233,7 @@ static inline int efx_init_rx_buffer_skb
 					  rx_buf->data, rx_buf->len,
 					  PCI_DMA_FROMDEVICE);
 
-	if (unlikely(pci_dma_mapping_error(rx_buf->dma_addr))) {
+	if (unlikely(pci_dma_mapping_error(efx->pci_dev, rx_buf->dma_addr))) {
 		dev_kfree_skb_any(rx_buf->skb);
 		rx_buf->skb = NULL;
 		return -EIO;
@@ -275,7 +275,7 @@ static inline int efx_init_rx_buffer_pag
 					0, efx_rx_buf_size(efx),
 					PCI_DMA_FROMDEVICE);
 
-		if (unlikely(pci_dma_mapping_error(dma_addr))) {
+		if (unlikely(pci_dma_mapping_error(efx->pci_dev, dma_addr))) {
 			__free_pages(rx_buf->page, efx->rx_buffer_order);
 			rx_buf->page = NULL;
 			return -EIO;
diff -puN drivers/net/sfc/tx.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/net/sfc/tx.c
--- a/drivers/net/sfc/tx.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/net/sfc/tx.c
@@ -172,7 +172,7 @@ static inline int efx_enqueue_skb(struct
 
 	/* Process all fragments */
 	while (1) {
-		if (unlikely(pci_dma_mapping_error(dma_addr)))
+		if (unlikely(pci_dma_mapping_error(pci_dev, dma_addr)))
 			goto pci_err;
 
 		/* Store fields for marking in the per-fragment final
@@ -661,7 +661,8 @@ efx_tsoh_heap_alloc(struct efx_tx_queue 
 	tsoh->dma_addr = pci_map_single(tx_queue->efx->pci_dev,
 					TSOH_BUFFER(tsoh), header_len,
 					PCI_DMA_TODEVICE);
-	if (unlikely(pci_dma_mapping_error(tsoh->dma_addr))) {
+	if (unlikely(pci_dma_mapping_error(tx_queue->efx->pci_dev,
+					   tsoh->dma_addr))) {
 		kfree(tsoh);
 		return NULL;
 	}
@@ -863,7 +864,7 @@ static inline int tso_get_fragment(struc
 
 	st->ifc.unmap_addr = pci_map_page(efx->pci_dev, page, page_off,
 					  len, PCI_DMA_TODEVICE);
-	if (likely(!pci_dma_mapping_error(st->ifc.unmap_addr))) {
+	if (likely(!pci_dma_mapping_error(efx->pci_dev, st->ifc.unmap_addr))) {
 		st->ifc.unmap_len = len;
 		st->ifc.len = len;
 		st->ifc.dma_addr = st->ifc.unmap_addr;
diff -puN drivers/net/spider_net.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/net/spider_net.c
--- a/drivers/net/spider_net.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/net/spider_net.c
@@ -452,7 +452,7 @@ spider_net_prepare_rx_descr(struct spide
 	/* iommu-map the skb */
 	buf = pci_map_single(card->pdev, descr->skb->data,
 			SPIDER_NET_MAX_FRAME, PCI_DMA_FROMDEVICE);
-	if (pci_dma_mapping_error(buf)) {
+	if (pci_dma_mapping_error(card->pdev, buf)) {
 		dev_kfree_skb_any(descr->skb);
 		descr->skb = NULL;
 		if (netif_msg_rx_err(card) && net_ratelimit())
@@ -691,7 +691,7 @@ spider_net_prepare_tx_descr(struct spide
 	unsigned long flags;
 
 	buf = pci_map_single(card->pdev, skb->data, skb->len, PCI_DMA_TODEVICE);
-	if (pci_dma_mapping_error(buf)) {
+	if (pci_dma_mapping_error(card->pdev, buf)) {
 		if (netif_msg_tx_err(card) && net_ratelimit())
 			dev_err(&card->netdev->dev, "could not iommu-map packet (%p, %i). "
 				  "Dropping packet\n", skb->data, skb->len);
diff -puN drivers/net/tc35815.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/net/tc35815.c
--- a/drivers/net/tc35815.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/net/tc35815.c
@@ -506,7 +506,7 @@ static void *alloc_rxbuf_page(struct pci
 		return NULL;
 	*dma_handle = pci_map_single(hwdev, buf, PAGE_SIZE,
 				     PCI_DMA_FROMDEVICE);
-	if (pci_dma_mapping_error(*dma_handle)) {
+	if (pci_dma_mapping_error(hwdev, *dma_handle)) {
 		free_page((unsigned long)buf);
 		return NULL;
 	}
@@ -536,7 +536,7 @@ static struct sk_buff *alloc_rxbuf_skb(s
 		return NULL;
 	*dma_handle = pci_map_single(hwdev, skb->data, RX_BUF_SIZE,
 				     PCI_DMA_FROMDEVICE);
-	if (pci_dma_mapping_error(*dma_handle)) {
+	if (pci_dma_mapping_error(hwdev, *dma_handle)) {
 		dev_kfree_skb_any(skb);
 		return NULL;
 	}
diff -puN drivers/net/wireless/ath5k/base.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/net/wireless/ath5k/base.c
--- a/drivers/net/wireless/ath5k/base.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/net/wireless/ath5k/base.c
@@ -1166,7 +1166,7 @@ ath5k_rxbuf_setup(struct ath5k_softc *sc
 		bf->skb = skb;
 		bf->skbaddr = pci_map_single(sc->pdev,
 			skb->data, sc->rxbufsize, PCI_DMA_FROMDEVICE);
-		if (unlikely(pci_dma_mapping_error(bf->skbaddr))) {
+		if (unlikely(pci_dma_mapping_error(sc->pdev, bf->skbaddr))) {
 			ATH5K_ERR(sc, "%s: DMA mapping failed\n", __func__);
 			dev_kfree_skb(skb);
 			bf->skb = NULL;
@@ -1918,7 +1918,7 @@ ath5k_beacon_setup(struct ath5k_softc *s
 	ATH5K_DBG(sc, ATH5K_DEBUG_BEACON, "skb %p [data %p len %u] "
 			"skbaddr %llx\n", skb, skb->data, skb->len,
 			(unsigned long long)bf->skbaddr);
-	if (pci_dma_mapping_error(bf->skbaddr)) {
+	if (pci_dma_mapping_error(sc->pdev, bf->skbaddr)) {
 		ATH5K_ERR(sc, "beacon DMA mapping failed\n");
 		return -EIO;
 	}
diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/scsi/ibmvscsi/ibmvfc.c
--- a/drivers/scsi/ibmvscsi/ibmvfc.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -3525,7 +3525,7 @@ static int ibmvfc_init_crq(struct ibmvfc
 	crq->msg_token = dma_map_single(dev, crq->msgs,
 					PAGE_SIZE, DMA_BIDIRECTIONAL);
 
-	if (dma_mapping_error(crq->msg_token))
+	if (dma_mapping_error(dev, crq->msg_token))
 		goto map_failed;
 
 	retrc = rc = plpar_hcall_norets(H_REG_CRQ, vdev->unit_address,
@@ -3618,7 +3618,7 @@ static int ibmvfc_alloc_mem(struct ibmvf
 					    async_q->size * sizeof(*async_q->msgs),
 					    DMA_BIDIRECTIONAL);
 
-	if (dma_mapping_error(async_q->msg_token)) {
+	if (dma_mapping_error(dev, async_q->msg_token)) {
 		dev_err(dev, "Failed to map async queue\n");
 		goto free_async_crq;
 	}
diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/scsi/ibmvscsi/ibmvscsi.c
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -859,7 +859,7 @@ static void send_mad_adapter_info(struct
 					    sizeof(hostdata->madapter_info),
 					    DMA_BIDIRECTIONAL);
 
-	if (dma_mapping_error(req->buffer)) {
+	if (dma_mapping_error(hostdata->dev, req->buffer)) {
 		if (!firmware_has_feature(FW_FEATURE_CMO))
 			dev_err(hostdata->dev,
 			        "Unable to map request_buffer for "
@@ -1407,7 +1407,7 @@ static int ibmvscsi_do_host_config(struc
 						    length,
 						    DMA_BIDIRECTIONAL);
 
-	if (dma_mapping_error(host_config->buffer)) {
+	if (dma_mapping_error(hostdata->dev, host_config->buffer)) {
 		if (!firmware_has_feature(FW_FEATURE_CMO))
 			dev_err(hostdata->dev,
 			        "dma_mapping error getting host config\n");
diff -puN drivers/scsi/ibmvscsi/ibmvstgt.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/scsi/ibmvscsi/ibmvstgt.c
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -564,7 +564,7 @@ static int crq_queue_create(struct crq_q
 					  queue->size * sizeof(*queue->msgs),
 					  DMA_BIDIRECTIONAL);
 
-	if (dma_mapping_error(queue->msg_token))
+	if (dma_mapping_error(target->dev, queue->msg_token))
 		goto map_failed;
 
 	err = h_reg_crq(vport->dma_dev->unit_address, queue->msg_token,
diff -puN drivers/scsi/ibmvscsi/rpa_vscsi.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/scsi/ibmvscsi/rpa_vscsi.c
--- a/drivers/scsi/ibmvscsi/rpa_vscsi.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/scsi/ibmvscsi/rpa_vscsi.c
@@ -253,7 +253,7 @@ static int rpavscsi_init_crq_queue(struc
 					  queue->size * sizeof(*queue->msgs),
 					  DMA_BIDIRECTIONAL);
 
-	if (dma_mapping_error(queue->msg_token))
+	if (dma_mapping_error(hostdata->dev, queue->msg_token))
 		goto map_failed;
 
 	gather_partition_info();
diff -puN drivers/spi/atmel_spi.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/spi/atmel_spi.c
@@ -313,14 +313,14 @@ atmel_spi_dma_map_xfer(struct atmel_spi 
 		xfer->tx_dma = dma_map_single(dev,
 				(void *) xfer->tx_buf, xfer->len,
 				DMA_TO_DEVICE);
-		if (dma_mapping_error(xfer->tx_dma))
+		if (dma_mapping_error(dev, xfer->tx_dma))
 			return -ENOMEM;
 	}
 	if (xfer->rx_buf) {
 		xfer->rx_dma = dma_map_single(dev,
 				xfer->rx_buf, xfer->len,
 				DMA_FROM_DEVICE);
-		if (dma_mapping_error(xfer->rx_dma)) {
+		if (dma_mapping_error(dev, xfer->rx_dma)) {
 			if (xfer->tx_buf)
 				dma_unmap_single(dev,
 						xfer->tx_dma, xfer->len,
diff -puN drivers/spi/au1550_spi.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/spi/au1550_spi.c
--- a/drivers/spi/au1550_spi.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/spi/au1550_spi.c
@@ -334,7 +334,7 @@ static int au1550_spi_dma_rxtmp_alloc(st
 	hw->dma_rx_tmpbuf_size = size;
 	hw->dma_rx_tmpbuf_addr = dma_map_single(hw->dev, hw->dma_rx_tmpbuf,
 			size, DMA_FROM_DEVICE);
-	if (dma_mapping_error(hw->dma_rx_tmpbuf_addr)) {
+	if (dma_mapping_error(hw->dev, hw->dma_rx_tmpbuf_addr)) {
 		kfree(hw->dma_rx_tmpbuf);
 		hw->dma_rx_tmpbuf = 0;
 		hw->dma_rx_tmpbuf_size = 0;
@@ -378,7 +378,7 @@ static int au1550_spi_dma_txrxb(struct s
 			dma_rx_addr = dma_map_single(hw->dev,
 					(void *)t->rx_buf,
 					t->len, DMA_FROM_DEVICE);
-			if (dma_mapping_error(dma_rx_addr))
+			if (dma_mapping_error(hw->dev, dma_rx_addr))
 				dev_err(hw->dev, "rx dma map error\n");
 		}
 	} else {
@@ -401,7 +401,7 @@ static int au1550_spi_dma_txrxb(struct s
 			dma_tx_addr = dma_map_single(hw->dev,
 					(void *)t->tx_buf,
 					t->len, DMA_TO_DEVICE);
-			if (dma_mapping_error(dma_tx_addr))
+			if (dma_mapping_error(hw->dev, dma_tx_addr))
 				dev_err(hw->dev, "tx dma map error\n");
 		}
 	} else {
diff -puN drivers/spi/omap2_mcspi.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/spi/omap2_mcspi.c
--- a/drivers/spi/omap2_mcspi.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/spi/omap2_mcspi.c
@@ -836,7 +836,7 @@ static int omap2_mcspi_transfer(struct s
 		if (tx_buf != NULL) {
 			t->tx_dma = dma_map_single(&spi->dev, (void *) tx_buf,
 					len, DMA_TO_DEVICE);
-			if (dma_mapping_error(t->tx_dma)) {
+			if (dma_mapping_error(&spi->dev, t->tx_dma)) {
 				dev_dbg(&spi->dev, "dma %cX %d bytes error\n",
 						'T', len);
 				return -EINVAL;
@@ -845,7 +845,7 @@ static int omap2_mcspi_transfer(struct s
 		if (rx_buf != NULL) {
 			t->rx_dma = dma_map_single(&spi->dev, rx_buf, t->len,
 					DMA_FROM_DEVICE);
-			if (dma_mapping_error(t->rx_dma)) {
+			if (dma_mapping_error(&spi->dev, t->rx_dma)) {
 				dev_dbg(&spi->dev, "dma %cX %d bytes error\n",
 						'R', len);
 				if (tx_buf != NULL)
diff -puN drivers/spi/pxa2xx_spi.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/spi/pxa2xx_spi.c
@@ -353,7 +353,7 @@ static int map_dma_buffers(struct driver
 	drv_data->rx_dma = dma_map_single(dev, drv_data->rx,
 						drv_data->rx_map_len,
 						DMA_FROM_DEVICE);
-	if (dma_mapping_error(drv_data->rx_dma))
+	if (dma_mapping_error(dev, drv_data->rx_dma))
 		return 0;
 
 	/* Stream map the tx buffer */
@@ -361,7 +361,7 @@ static int map_dma_buffers(struct driver
 						drv_data->tx_map_len,
 						DMA_TO_DEVICE);
 
-	if (dma_mapping_error(drv_data->tx_dma)) {
+	if (dma_mapping_error(dev, drv_data->tx_dma)) {
 		dma_unmap_single(dev, drv_data->rx_dma,
 					drv_data->rx_map_len, DMA_FROM_DEVICE);
 		return 0;
diff -puN drivers/spi/spi_imx.c~dma-mapping-add-the-device-argument-to-dma_mapping_error drivers/spi/spi_imx.c
--- a/drivers/spi/spi_imx.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/drivers/spi/spi_imx.c
@@ -491,7 +491,7 @@ static int map_dma_buffers(struct driver
 							buf,
 							drv_data->tx_map_len,
 							DMA_TO_DEVICE);
-			if (dma_mapping_error(drv_data->tx_dma))
+			if (dma_mapping_error(dev, drv_data->tx_dma))
 				return -1;
 
 			drv_data->tx_dma_needs_unmap = 1;
@@ -516,7 +516,7 @@ static int map_dma_buffers(struct driver
 					buf,
 					drv_data->len,
 					DMA_FROM_DEVICE);
-		if (dma_mapping_error(drv_data->rx_dma))
+		if (dma_mapping_error(dev, drv_data->rx_dma))
 			return -1;
 		drv_data->rx_dma_needs_unmap = 1;
 	}
@@ -534,7 +534,7 @@ static int map_dma_buffers(struct driver
 					buf,
 					drv_data->tx_map_len,
 					DMA_TO_DEVICE);
-	if (dma_mapping_error(drv_data->tx_dma)) {
+	if (dma_mapping_error(dev, drv_data->tx_dma)) {
 		if (drv_data->rx_dma) {
 			dma_unmap_single(dev,
 					drv_data->rx_dma,
diff -puN include/asm-alpha/dma-mapping.h~dma-mapping-add-the-device-argument-to-dma_mapping_error include/asm-alpha/dma-mapping.h
--- a/include/asm-alpha/dma-mapping.h~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/include/asm-alpha/dma-mapping.h
@@ -24,8 +24,8 @@
 		pci_unmap_sg(alpha_gendev_to_pci(dev), sg, nents, dir)
 #define dma_supported(dev, mask)			\
 		pci_dma_supported(alpha_gendev_to_pci(dev), mask)
-#define dma_mapping_error(addr)				\
-		pci_dma_mapping_error(addr)
+#define dma_mapping_error(dev, addr)				\
+		pci_dma_mapping_error(alpha_gendev_to_pci(dev), addr)
 
 #else	/* no PCI - no IOMMU. */
 
@@ -45,7 +45,7 @@ int dma_map_sg(struct device *dev, struc
 #define dma_unmap_page(dev, addr, size, dir)	((void)0)
 #define dma_unmap_sg(dev, sg, nents, dir)	((void)0)
 
-#define dma_mapping_error(addr)  (0)
+#define dma_mapping_error(dev, addr)  (0)
 
 #endif	/* !CONFIG_PCI */
 
diff -puN include/asm-alpha/pci.h~dma-mapping-add-the-device-argument-to-dma_mapping_error include/asm-alpha/pci.h
--- a/include/asm-alpha/pci.h~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/include/asm-alpha/pci.h
@@ -106,7 +106,7 @@ extern dma_addr_t pci_map_page(struct pc
 /* Test for pci_map_single or pci_map_page having generated an error.  */
 
 static inline int
-pci_dma_mapping_error(dma_addr_t dma_addr)
+pci_dma_mapping_error(struct pci_dev *pdev, dma_addr_t dma_addr)
 {
 	return dma_addr == 0;
 }
diff -puN include/asm-arm/dma-mapping.h~dma-mapping-add-the-device-argument-to-dma_mapping_error include/asm-arm/dma-mapping.h
--- a/include/asm-arm/dma-mapping.h~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/include/asm-arm/dma-mapping.h
@@ -56,7 +56,7 @@ static inline int dma_is_consistent(stru
 /*
  * DMA errors are defined by all-bits-set in the DMA address.
  */
-static inline int dma_mapping_error(dma_addr_t dma_addr)
+static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	return dma_addr == ~0;
 }
diff -puN include/asm-avr32/dma-mapping.h~dma-mapping-add-the-device-argument-to-dma_mapping_error include/asm-avr32/dma-mapping.h
--- a/include/asm-avr32/dma-mapping.h~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/include/asm-avr32/dma-mapping.h
@@ -35,7 +35,7 @@ static inline int dma_set_mask(struct de
 /*
  * dma_map_single can't fail as it is implemented now.
  */
-static inline int dma_mapping_error(dma_addr_t addr)
+static inline int dma_mapping_error(struct device *dev, dma_addr_t addr)
 {
 	return 0;
 }
diff -puN include/asm-cris/dma-mapping.h~dma-mapping-add-the-device-argument-to-dma_mapping_error include/asm-cris/dma-mapping.h
--- a/include/asm-cris/dma-mapping.h~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/include/asm-cris/dma-mapping.h
@@ -120,7 +120,7 @@ dma_sync_sg_for_device(struct device *de
 }
 
 static inline int
-dma_mapping_error(dma_addr_t dma_addr)
+dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	return 0;
 }
diff -puN include/asm-frv/dma-mapping.h~dma-mapping-add-the-device-argument-to-dma_mapping_error include/asm-frv/dma-mapping.h
--- a/include/asm-frv/dma-mapping.h~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/include/asm-frv/dma-mapping.h
@@ -126,7 +126,7 @@ void dma_sync_sg_for_device(struct devic
 }
 
 static inline
-int dma_mapping_error(dma_addr_t dma_addr)
+int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	return 0;
 }
diff -puN include/asm-generic/dma-mapping-broken.h~dma-mapping-add-the-device-argument-to-dma_mapping_error include/asm-generic/dma-mapping-broken.h
--- a/include/asm-generic/dma-mapping-broken.h~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/include/asm-generic/dma-mapping-broken.h
@@ -61,7 +61,7 @@ dma_sync_sg_for_cpu(struct device *dev, 
 #define dma_sync_sg_for_device dma_sync_sg_for_cpu
 
 extern int
-dma_mapping_error(dma_addr_t dma_addr);
+dma_mapping_error(struct device *dev, dma_addr_t dma_addr);
 
 extern int
 dma_supported(struct device *dev, u64 mask);
diff -puN include/asm-generic/dma-mapping.h~dma-mapping-add-the-device-argument-to-dma_mapping_error include/asm-generic/dma-mapping.h
--- a/include/asm-generic/dma-mapping.h~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/include/asm-generic/dma-mapping.h
@@ -144,9 +144,9 @@ dma_sync_sg_for_device(struct device *de
 }
 
 static inline int
-dma_mapping_error(dma_addr_t dma_addr)
+dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
-	return pci_dma_mapping_error(dma_addr);
+	return pci_dma_mapping_error(to_pci_dev(dev), dma_addr);
 }
 
 
diff -puN include/asm-generic/pci-dma-compat.h~dma-mapping-add-the-device-argument-to-dma_mapping_error include/asm-generic/pci-dma-compat.h
--- a/include/asm-generic/pci-dma-compat.h~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/include/asm-generic/pci-dma-compat.h
@@ -99,9 +99,9 @@ pci_dma_sync_sg_for_device(struct pci_de
 }
 
 static inline int
-pci_dma_mapping_error(dma_addr_t dma_addr)
+pci_dma_mapping_error(struct pci_dev *pdev, dma_addr_t dma_addr)
 {
-	return dma_mapping_error(dma_addr);
+	return dma_mapping_error(&pdev->dev, dma_addr);
 }
 
 #endif
diff -puN include/asm-ia64/machvec.h~dma-mapping-add-the-device-argument-to-dma_mapping_error include/asm-ia64/machvec.h
--- a/include/asm-ia64/machvec.h~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/include/asm-ia64/machvec.h
@@ -54,7 +54,7 @@ typedef void ia64_mv_dma_sync_single_for
 typedef void ia64_mv_dma_sync_sg_for_cpu (struct device *, struct scatterlist *, int, int);
 typedef void ia64_mv_dma_sync_single_for_device (struct device *, dma_addr_t, size_t, int);
 typedef void ia64_mv_dma_sync_sg_for_device (struct device *, struct scatterlist *, int, int);
-typedef int ia64_mv_dma_mapping_error (dma_addr_t dma_addr);
+typedef int ia64_mv_dma_mapping_error(struct device *, dma_addr_t dma_addr);
 typedef int ia64_mv_dma_supported (struct device *, u64);
 
 typedef dma_addr_t ia64_mv_dma_map_single_attrs (struct device *, void *, size_t, int, struct dma_attrs *);
diff -puN include/asm-m68k/dma-mapping.h~dma-mapping-add-the-device-argument-to-dma_mapping_error include/asm-m68k/dma-mapping.h
--- a/include/asm-m68k/dma-mapping.h~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/include/asm-m68k/dma-mapping.h
@@ -84,7 +84,7 @@ static inline void dma_sync_sg_for_cpu(s
 {
 }
 
-static inline int dma_mapping_error(dma_addr_t handle)
+static inline int dma_mapping_error(struct device *dev, dma_addr_t handle)
 {
 	return 0;
 }
diff -puN include/asm-mips/dma-mapping.h~dma-mapping-add-the-device-argument-to-dma_mapping_error include/asm-mips/dma-mapping.h
--- a/include/asm-mips/dma-mapping.h~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/include/asm-mips/dma-mapping.h
@@ -42,7 +42,7 @@ extern void dma_sync_sg_for_cpu(struct d
 	int nelems, enum dma_data_direction direction);
 extern void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 	int nelems, enum dma_data_direction direction);
-extern int dma_mapping_error(dma_addr_t dma_addr);
+extern int dma_mapping_error(struct device *dev, dma_addr_t dma_addr);
 extern int dma_supported(struct device *dev, u64 mask);
 
 static inline int
diff -puN include/asm-mn10300/dma-mapping.h~dma-mapping-add-the-device-argument-to-dma_mapping_error include/asm-mn10300/dma-mapping.h
--- a/include/asm-mn10300/dma-mapping.h~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/include/asm-mn10300/dma-mapping.h
@@ -182,7 +182,7 @@ void dma_sync_sg_for_device(struct devic
 }
 
 static inline
-int dma_mapping_error(dma_addr_t dma_addr)
+int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	return 0;
 }
diff -puN include/asm-parisc/dma-mapping.h~dma-mapping-add-the-device-argument-to-dma_mapping_error include/asm-parisc/dma-mapping.h
--- a/include/asm-parisc/dma-mapping.h~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/include/asm-parisc/dma-mapping.h
@@ -248,6 +248,6 @@ void * sba_get_iommu(struct parisc_devic
 #endif
 
 /* At the moment, we panic on error for IOMMU resource exaustion */
-#define dma_mapping_error(x)	0
+#define dma_mapping_error(dev, x)	0
 
 #endif
diff -puN include/asm-powerpc/dma-mapping.h~dma-mapping-add-the-device-argument-to-dma_mapping_error include/asm-powerpc/dma-mapping.h
--- a/include/asm-powerpc/dma-mapping.h~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/include/asm-powerpc/dma-mapping.h
@@ -415,7 +415,7 @@ static inline void dma_sync_sg_for_devic
 		__dma_sync_page(sg_page(sg), sg->offset, sg->length, direction);
 }
 
-static inline int dma_mapping_error(dma_addr_t dma_addr)
+static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 #ifdef CONFIG_PPC64
 	return (dma_addr == DMA_ERROR_CODE);
diff -puN include/asm-sh/dma-mapping.h~dma-mapping-add-the-device-argument-to-dma_mapping_error include/asm-sh/dma-mapping.h
--- a/include/asm-sh/dma-mapping.h~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/include/asm-sh/dma-mapping.h
@@ -171,7 +171,7 @@ static inline int dma_get_cache_alignmen
 	return L1_CACHE_BYTES;
 }
 
-static inline int dma_mapping_error(dma_addr_t dma_addr)
+static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	return dma_addr == 0;
 }
diff -puN include/asm-sparc/dma-mapping_64.h~dma-mapping-add-the-device-argument-to-dma_mapping_error include/asm-sparc/dma-mapping_64.h
--- a/include/asm-sparc/dma-mapping_64.h~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/include/asm-sparc/dma-mapping_64.h
@@ -135,7 +135,7 @@ static inline void dma_sync_sg_for_devic
 	/* No flushing needed to sync cpu writes to the device.  */
 }
 
-static inline int dma_mapping_error(dma_addr_t dma_addr)
+static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	return (dma_addr == DMA_ERROR_CODE);
 }
diff -puN include/asm-sparc/pci_32.h~dma-mapping-add-the-device-argument-to-dma_mapping_error include/asm-sparc/pci_32.h
--- a/include/asm-sparc/pci_32.h~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/include/asm-sparc/pci_32.h
@@ -154,7 +154,8 @@ static inline void pci_dma_burst_advice(
 
 #define PCI_DMA_ERROR_CODE      (~(dma_addr_t)0x0)
 
-static inline int pci_dma_mapping_error(dma_addr_t dma_addr)
+static inline int pci_dma_mapping_error(struct pci_dev *pdev,
+					dma_addr_t dma_addr)
 {
         return (dma_addr == PCI_DMA_ERROR_CODE);
 }
diff -puN include/asm-sparc/pci_64.h~dma-mapping-add-the-device-argument-to-dma_mapping_error include/asm-sparc/pci_64.h
--- a/include/asm-sparc/pci_64.h~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/include/asm-sparc/pci_64.h
@@ -140,9 +140,10 @@ extern int pci_dma_supported(struct pci_
 #define PCI64_REQUIRED_MASK	(~(dma64_addr_t)0)
 #define PCI64_ADDR_BASE		0xfffc000000000000UL
 
-static inline int pci_dma_mapping_error(dma_addr_t dma_addr)
+static inline int pci_dma_mapping_error(struct pci_dev *pdev,
+					dma_addr_t dma_addr)
 {
-	return dma_mapping_error(dma_addr);
+	return dma_mapping_error(&pdev->dev, dma_addr);
 }
 
 #ifdef CONFIG_PCI
diff -puN include/asm-x86/device.h~dma-mapping-add-the-device-argument-to-dma_mapping_error include/asm-x86/device.h
--- a/include/asm-x86/device.h~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/include/asm-x86/device.h
@@ -5,6 +5,9 @@ struct dev_archdata {
 #ifdef CONFIG_ACPI
 	void	*acpi_handle;
 #endif
+#ifdef CONFIG_X86_64
+struct dma_mapping_ops *dma_ops;
+#endif
 #ifdef CONFIG_DMAR
 	void *iommu; /* hook for IOMMU specific extension */
 #endif
diff -puN include/asm-x86/dma-mapping.h~dma-mapping-add-the-device-argument-to-dma_mapping_error include/asm-x86/dma-mapping.h
--- a/include/asm-x86/dma-mapping.h~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/include/asm-x86/dma-mapping.h
@@ -17,7 +17,8 @@ extern int panic_on_overflow;
 extern int force_iommu;
 
 struct dma_mapping_ops {
-	int             (*mapping_error)(dma_addr_t dma_addr);
+	int             (*mapping_error)(struct device *dev,
+					 dma_addr_t dma_addr);
 	void*           (*alloc_coherent)(struct device *dev, size_t size,
 				dma_addr_t *dma_handle, gfp_t gfp);
 	void            (*free_coherent)(struct device *dev, size_t size,
@@ -56,14 +57,32 @@ struct dma_mapping_ops {
 	int		is_phys;
 };
 
-extern const struct dma_mapping_ops *dma_ops;
+extern struct dma_mapping_ops *dma_ops;
 
-static inline int dma_mapping_error(dma_addr_t dma_addr)
+static inline struct dma_mapping_ops *get_dma_ops(struct device *dev)
 {
-	if (dma_ops->mapping_error)
-		return dma_ops->mapping_error(dma_addr);
+#ifdef CONFIG_X86_32
+	return dma_ops;
+#else
+	if (unlikely(!dev) || !dev->archdata.dma_ops)
+		return dma_ops;
+	else
+		return dev->archdata.dma_ops;
+#endif
+}
+
+/* Make sure we keep the same behaviour */
+static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
+{
+#ifdef CONFIG_X86_32
+	return 0;
+#else
+	struct dma_mapping_ops *ops = get_dma_ops(dev);
+	if (ops->mapping_error)
+		return ops->mapping_error(dev, dma_addr);
 
 	return (dma_addr == bad_dma_address);
+#endif
 }
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
@@ -83,44 +102,53 @@ static inline dma_addr_t
 dma_map_single(struct device *hwdev, void *ptr, size_t size,
 	       int direction)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+
 	BUG_ON(!valid_dma_direction(direction));
-	return dma_ops->map_single(hwdev, virt_to_phys(ptr), size, direction);
+	return ops->map_single(hwdev, virt_to_phys(ptr), size, direction);
 }
 
 static inline void
 dma_unmap_single(struct device *dev, dma_addr_t addr, size_t size,
 		 int direction)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(dev);
+
 	BUG_ON(!valid_dma_direction(direction));
-	if (dma_ops->unmap_single)
-		dma_ops->unmap_single(dev, addr, size, direction);
+	if (ops->unmap_single)
+		ops->unmap_single(dev, addr, size, direction);
 }
 
 static inline int
 dma_map_sg(struct device *hwdev, struct scatterlist *sg,
 	   int nents, int direction)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+
 	BUG_ON(!valid_dma_direction(direction));
-	return dma_ops->map_sg(hwdev, sg, nents, direction);
+	return ops->map_sg(hwdev, sg, nents, direction);
 }
 
 static inline void
 dma_unmap_sg(struct device *hwdev, struct scatterlist *sg, int nents,
 	     int direction)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+
 	BUG_ON(!valid_dma_direction(direction));
-	if (dma_ops->unmap_sg)
-		dma_ops->unmap_sg(hwdev, sg, nents, direction);
+	if (ops->unmap_sg)
+		ops->unmap_sg(hwdev, sg, nents, direction);
 }
 
 static inline void
 dma_sync_single_for_cpu(struct device *hwdev, dma_addr_t dma_handle,
 			size_t size, int direction)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+
 	BUG_ON(!valid_dma_direction(direction));
-	if (dma_ops->sync_single_for_cpu)
-		dma_ops->sync_single_for_cpu(hwdev, dma_handle, size,
-					     direction);
+	if (ops->sync_single_for_cpu)
+		ops->sync_single_for_cpu(hwdev, dma_handle, size, direction);
 	flush_write_buffers();
 }
 
@@ -128,10 +156,11 @@ static inline void
 dma_sync_single_for_device(struct device *hwdev, dma_addr_t dma_handle,
 			   size_t size, int direction)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+
 	BUG_ON(!valid_dma_direction(direction));
-	if (dma_ops->sync_single_for_device)
-		dma_ops->sync_single_for_device(hwdev, dma_handle, size,
-						direction);
+	if (ops->sync_single_for_device)
+		ops->sync_single_for_device(hwdev, dma_handle, size, direction);
 	flush_write_buffers();
 }
 
@@ -139,11 +168,12 @@ static inline void
 dma_sync_single_range_for_cpu(struct device *hwdev, dma_addr_t dma_handle,
 			      unsigned long offset, size_t size, int direction)
 {
-	BUG_ON(!valid_dma_direction(direction));
-	if (dma_ops->sync_single_range_for_cpu)
-		dma_ops->sync_single_range_for_cpu(hwdev, dma_handle, offset,
-						   size, direction);
+	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
 
+	BUG_ON(!valid_dma_direction(direction));
+	if (ops->sync_single_range_for_cpu)
+		ops->sync_single_range_for_cpu(hwdev, dma_handle, offset,
+					       size, direction);
 	flush_write_buffers();
 }
 
@@ -152,11 +182,12 @@ dma_sync_single_range_for_device(struct 
 				 unsigned long offset, size_t size,
 				 int direction)
 {
-	BUG_ON(!valid_dma_direction(direction));
-	if (dma_ops->sync_single_range_for_device)
-		dma_ops->sync_single_range_for_device(hwdev, dma_handle,
-						      offset, size, direction);
+	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
 
+	BUG_ON(!valid_dma_direction(direction));
+	if (ops->sync_single_range_for_device)
+		ops->sync_single_range_for_device(hwdev, dma_handle,
+						  offset, size, direction);
 	flush_write_buffers();
 }
 
@@ -164,9 +195,11 @@ static inline void
 dma_sync_sg_for_cpu(struct device *hwdev, struct scatterlist *sg,
 		    int nelems, int direction)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+
 	BUG_ON(!valid_dma_direction(direction));
-	if (dma_ops->sync_sg_for_cpu)
-		dma_ops->sync_sg_for_cpu(hwdev, sg, nelems, direction);
+	if (ops->sync_sg_for_cpu)
+		ops->sync_sg_for_cpu(hwdev, sg, nelems, direction);
 	flush_write_buffers();
 }
 
@@ -174,9 +207,11 @@ static inline void
 dma_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
 		       int nelems, int direction)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(hwdev);
+
 	BUG_ON(!valid_dma_direction(direction));
-	if (dma_ops->sync_sg_for_device)
-		dma_ops->sync_sg_for_device(hwdev, sg, nelems, direction);
+	if (ops->sync_sg_for_device)
+		ops->sync_sg_for_device(hwdev, sg, nelems, direction);
 
 	flush_write_buffers();
 }
@@ -185,9 +220,11 @@ static inline dma_addr_t dma_map_page(st
 				      size_t offset, size_t size,
 				      int direction)
 {
+	struct dma_mapping_ops *ops = get_dma_ops(dev);
+
 	BUG_ON(!valid_dma_direction(direction));
-	return dma_ops->map_single(dev, page_to_phys(page)+offset,
-				   size, direction);
+	return ops->map_single(dev, page_to_phys(page) + offset,
+			       size, direction);
 }
 
 static inline void dma_unmap_page(struct device *dev, dma_addr_t addr,
diff -puN include/asm-x86/swiotlb.h~dma-mapping-add-the-device-argument-to-dma_mapping_error include/asm-x86/swiotlb.h
--- a/include/asm-x86/swiotlb.h~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/include/asm-x86/swiotlb.h
@@ -35,7 +35,7 @@ extern int swiotlb_map_sg(struct device 
 			  int nents, int direction);
 extern void swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sg,
 			     int nents, int direction);
-extern int swiotlb_dma_mapping_error(dma_addr_t dma_addr);
+extern int swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr);
 extern void swiotlb_free_coherent(struct device *hwdev, size_t size,
 				  void *vaddr, dma_addr_t dma_handle);
 extern int swiotlb_dma_supported(struct device *hwdev, u64 mask);
diff -puN include/asm-xtensa/dma-mapping.h~dma-mapping-add-the-device-argument-to-dma_mapping_error include/asm-xtensa/dma-mapping.h
--- a/include/asm-xtensa/dma-mapping.h~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/include/asm-xtensa/dma-mapping.h
@@ -139,7 +139,7 @@ dma_sync_sg_for_device(struct device *de
 		consistent_sync(sg_virt(sg), sg->length, dir);
 }
 static inline int
-dma_mapping_error(dma_addr_t dma_addr)
+dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	return 0;
 }
diff -puN include/linux/i2o.h~dma-mapping-add-the-device-argument-to-dma_mapping_error include/linux/i2o.h
--- a/include/linux/i2o.h~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/include/linux/i2o.h
@@ -758,7 +758,7 @@ static inline dma_addr_t i2o_dma_map_sin
 	}
 
 	dma_addr = dma_map_single(&c->pdev->dev, ptr, size, direction);
-	if (!dma_mapping_error(dma_addr)) {
+	if (!dma_mapping_error(&c->pdev->dev, dma_addr)) {
 #ifdef CONFIG_I2O_EXT_ADAPTEC_DMA64
 		if ((sizeof(dma_addr_t) > 4) && c->pae_support) {
 			*mptr++ = cpu_to_le32(0x7C020002);
diff -puN include/linux/ssb/ssb.h~dma-mapping-add-the-device-argument-to-dma_mapping_error include/linux/ssb/ssb.h
--- a/include/linux/ssb/ssb.h~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/include/linux/ssb/ssb.h
@@ -427,9 +427,9 @@ static inline int ssb_dma_mapping_error(
 {
 	switch (dev->bus->bustype) {
 	case SSB_BUSTYPE_PCI:
-		return pci_dma_mapping_error(addr);
+		return pci_dma_mapping_error(dev->bus->host_pci, addr);
 	case SSB_BUSTYPE_SSB:
-		return dma_mapping_error(addr);
+		return dma_mapping_error(dev->dev, addr);
 	default:
 		__ssb_dma_not_implemented(dev);
 	}
diff -puN include/rdma/ib_verbs.h~dma-mapping-add-the-device-argument-to-dma_mapping_error include/rdma/ib_verbs.h
--- a/include/rdma/ib_verbs.h~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/include/rdma/ib_verbs.h
@@ -1590,7 +1590,7 @@ static inline int ib_dma_mapping_error(s
 {
 	if (dev->dma_ops)
 		return dev->dma_ops->mapping_error(dev, dma_addr);
-	return dma_mapping_error(dma_addr);
+	return dma_mapping_error(dev->dma_device, dma_addr);
 }
 
 /**
diff -puN lib/swiotlb.c~dma-mapping-add-the-device-argument-to-dma_mapping_error lib/swiotlb.c
--- a/lib/swiotlb.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/lib/swiotlb.c
@@ -492,7 +492,7 @@ swiotlb_alloc_coherent(struct device *hw
 		 */
 		dma_addr_t handle;
 		handle = swiotlb_map_single(NULL, NULL, size, DMA_FROM_DEVICE);
-		if (swiotlb_dma_mapping_error(handle))
+		if (swiotlb_dma_mapping_error(hwdev, handle))
 			return NULL;
 
 		ret = bus_to_virt(handle);
@@ -824,7 +824,7 @@ swiotlb_sync_sg_for_device(struct device
 }
 
 int
-swiotlb_dma_mapping_error(dma_addr_t dma_addr)
+swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr)
 {
 	return (dma_addr == virt_to_bus(io_tlb_overflow_buffer));
 }
diff -puN net/sunrpc/xprtrdma/svc_rdma_sendto.c~dma-mapping-add-the-device-argument-to-dma_mapping_error net/sunrpc/xprtrdma/svc_rdma_sendto.c
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c~dma-mapping-add-the-device-argument-to-dma_mapping_error
+++ a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -169,7 +169,8 @@ static int send_write(struct svcxprt_rdm
 					  (void *)
 					  vec->sge[xdr_sge_no].iov_base + sge_off,
 					  sge_bytes, DMA_TO_DEVICE);
-		if (dma_mapping_error(sge[sge_no].addr))
+		if (dma_mapping_error(xprt->sc_cm_id->device->dma_device,
+					sge[sge_no].addr))
 			goto err;
 		sge_off = 0;
 		sge_no++;
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

origin.patch
ide-cd-use-the-new-object_is_in_stack-helper.patch

