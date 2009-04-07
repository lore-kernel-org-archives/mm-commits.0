From: akpm@linux-foundation.org
Subject: [merged] replace-all-dma_64bit_mask-macro-with-dma_bit_mask64.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:07:49 -0700
Message-ID: <200904071907.n37J7nKB011512@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753547AbZDGTJR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:09:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yanghy@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     dma-mapping: replace all DMA_64BIT_MASK macro with DMA_BIT_MASK(64)
has been removed from the -mm tree.  Its filename was
     replace-all-dma_64bit_mask-macro-with-dma_bit_mask64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping: replace all DMA_64BIT_MASK macro with DMA_BIT_MASK(64)
From: Yang Hongyang <yanghy@cn.fujitsu.com>

Replace all DMA_64BIT_MASK macro with DMA_BIT_MASK(64)

Signed-off-by: Yang Hongyang<yanghy@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-iop13xx/setup.c               |    8 ++++----
 arch/arm/mach-iop13xx/tpmi.c                |   10 +++++-----
 arch/arm/mach-kirkwood/common.c             |    8 ++++----
 arch/arm/mach-orion5x/common.c              |    4 ++--
 arch/arm/plat-iop/adma.c                    |    6 +++---
 arch/ia64/sn/pci/pci_dma.c                  |    2 +-
 arch/powerpc/platforms/cell/iommu.c         |    2 +-
 drivers/ata/ahci.c                          |    4 ++--
 drivers/ata/sata_mv.c                       |    4 ++--
 drivers/ata/sata_qstor.c                    |    4 ++--
 drivers/ata/sata_sil24.c                    |    4 ++--
 drivers/block/DAC960.c                      |    4 ++--
 drivers/block/cciss.c                       |    2 +-
 drivers/block/sx8.c                         |    4 ++--
 drivers/block/umem.c                        |    2 +-
 drivers/dma/ioat.c                          |    4 ++--
 drivers/idle/i7300_idle.c                   |    2 +-
 drivers/infiniband/hw/amso1100/c2.c         |    2 +-
 drivers/infiniband/hw/ipath/ipath_driver.c  |    4 ++--
 drivers/infiniband/hw/mthca/mthca_main.c    |    4 ++--
 drivers/infiniband/hw/nes/nes.c             |    4 ++--
 drivers/message/fusion/mptbase.c            |    4 ++--
 drivers/message/i2o/memory.c                |    4 ++--
 drivers/message/i2o/pci.c                   |    2 +-
 drivers/net/8139cp.c                        |    4 ++--
 drivers/net/acenic.c                        |    2 +-
 drivers/net/bnx2.c                          |    2 +-
 drivers/net/bnx2x_main.c                    |    4 ++--
 drivers/net/cassini.c                       |    4 ++--
 drivers/net/chelsio/cxgb2.c                 |    4 ++--
 drivers/net/cxgb3/cxgb3_main.c              |    4 ++--
 drivers/net/e1000/e1000_main.c              |    4 ++--
 drivers/net/e1000e/netdev.c                 |    4 ++--
 drivers/net/igb/igb_main.c                  |    4 ++--
 drivers/net/ioc3-eth.c                      |    4 ++--
 drivers/net/ixgb/ixgb_main.c                |    4 ++--
 drivers/net/ixgbe/ixgbe_main.c              |    4 ++--
 drivers/net/mlx4/main.c                     |    4 ++--
 drivers/net/myri10ge/myri10ge.c             |    4 ++--
 drivers/net/ns83820.c                       |    2 +-
 drivers/net/qla3xxx.c                       |    4 ++--
 drivers/net/qlge/qlge_main.c                |    4 ++--
 drivers/net/r8169.c                         |    2 +-
 drivers/net/s2io.c                          |    4 ++--
 drivers/net/skge.c                          |    4 ++--
 drivers/net/sky2.c                          |    4 ++--
 drivers/net/sungem.c                        |    2 +-
 drivers/net/tehuti.c                        |    4 ++--
 drivers/net/tehuti.h                        |    5 +----
 drivers/net/tg3.c                           |    4 ++--
 drivers/net/usb/usbnet.c                    |    2 +-
 drivers/net/wireless/b43/dma.c              |    6 +++---
 drivers/net/wireless/b43legacy/dma.c        |    6 +++---
 drivers/pci/intel-iommu.c                   |    2 +-
 drivers/scsi/3w-9xxx.c                      |    4 ++--
 drivers/scsi/aacraid/aachba.c               |    4 ++--
 drivers/scsi/aic7xxx/aic79xx_osm_pci.c      |    2 +-
 drivers/scsi/aic94xx/aic94xx_init.c         |    4 ++--
 drivers/scsi/arcmsr/arcmsr_hba.c            |    2 +-
 drivers/scsi/dpt_i2o.c                      |    2 +-
 drivers/scsi/gdth.c                         |    2 +-
 drivers/scsi/hptiop.c                       |    2 +-
 drivers/scsi/ips.c                          |    2 +-
 drivers/scsi/lpfc/lpfc_init.c               |    2 +-
 drivers/scsi/megaraid.c                     |    2 +-
 drivers/scsi/megaraid/megaraid_mbox.c       |    2 +-
 drivers/scsi/megaraid/megaraid_sas.c        |    2 +-
 drivers/scsi/mvsas.c                        |    4 ++--
 drivers/scsi/qla1280.c                      |    2 +-
 drivers/scsi/qla2xxx/qla_os.c               |    4 ++--
 drivers/scsi/qla4xxx/ql4_os.c               |    4 ++--
 drivers/scsi/stex.c                         |    4 ++--
 drivers/scsi/sym53c8xx_2/sym_hipd.h         |    2 +-
 drivers/sn/ioc3.c                           |    4 ++--
 drivers/staging/altpciechdma/altpciechdma.c |    4 ++--
 drivers/staging/slicoss/slicoss.c           |    4 ++--
 drivers/staging/sxg/sxg.c                   |    4 ++--
 drivers/usb/host/ehci-hcd.c                 |    2 +-
 drivers/uwb/whci.c                          |    4 ++--
 79 files changed, 140 insertions(+), 143 deletions(-)

diff -puN arch/arm/mach-iop13xx/setup.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 arch/arm/mach-iop13xx/setup.c
--- a/arch/arm/mach-iop13xx/setup.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/arch/arm/mach-iop13xx/setup.c
@@ -307,7 +307,7 @@ static struct resource iop13xx_adma_2_re
 	}
 };
 
-static u64 iop13xx_adma_dmamask = DMA_64BIT_MASK;
+static u64 iop13xx_adma_dmamask = DMA_BIT_MASK(64);
 static struct iop_adma_platform_data iop13xx_adma_0_data = {
 	.hw_id = 0,
 	.pool_size = PAGE_SIZE,
@@ -331,7 +331,7 @@ static struct platform_device iop13xx_ad
 	.resource = iop13xx_adma_0_resources,
 	.dev = {
 		.dma_mask = &iop13xx_adma_dmamask,
-		.coherent_dma_mask = DMA_64BIT_MASK,
+		.coherent_dma_mask = DMA_BIT_MASK(64),
 		.platform_data = (void *) &iop13xx_adma_0_data,
 	},
 };
@@ -343,7 +343,7 @@ static struct platform_device iop13xx_ad
 	.resource = iop13xx_adma_1_resources,
 	.dev = {
 		.dma_mask = &iop13xx_adma_dmamask,
-		.coherent_dma_mask = DMA_64BIT_MASK,
+		.coherent_dma_mask = DMA_BIT_MASK(64),
 		.platform_data = (void *) &iop13xx_adma_1_data,
 	},
 };
@@ -355,7 +355,7 @@ static struct platform_device iop13xx_ad
 	.resource = iop13xx_adma_2_resources,
 	.dev = {
 		.dma_mask = &iop13xx_adma_dmamask,
-		.coherent_dma_mask = DMA_64BIT_MASK,
+		.coherent_dma_mask = DMA_BIT_MASK(64),
 		.platform_data = (void *) &iop13xx_adma_2_data,
 	},
 };
diff -puN arch/arm/mach-iop13xx/tpmi.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 arch/arm/mach-iop13xx/tpmi.c
--- a/arch/arm/mach-iop13xx/tpmi.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/arch/arm/mach-iop13xx/tpmi.c
@@ -151,7 +151,7 @@ static struct resource iop13xx_tpmi_3_re
 	}
 };
 
-u64 iop13xx_tpmi_mask = DMA_64BIT_MASK;
+u64 iop13xx_tpmi_mask = DMA_BIT_MASK(64);
 static struct platform_device iop13xx_tpmi_0_device = {
 	.name = "iop-tpmi",
 	.id = 0,
@@ -159,7 +159,7 @@ static struct platform_device iop13xx_tp
 	.resource = iop13xx_tpmi_0_resources,
 	.dev = {
 		.dma_mask          = &iop13xx_tpmi_mask,
-		.coherent_dma_mask = DMA_64BIT_MASK,
+		.coherent_dma_mask = DMA_BIT_MASK(64),
 	},
 };
 
@@ -170,7 +170,7 @@ static struct platform_device iop13xx_tp
 	.resource = iop13xx_tpmi_1_resources,
 	.dev = {
 		.dma_mask          = &iop13xx_tpmi_mask,
-		.coherent_dma_mask = DMA_64BIT_MASK,
+		.coherent_dma_mask = DMA_BIT_MASK(64),
 	},
 };
 
@@ -181,7 +181,7 @@ static struct platform_device iop13xx_tp
 	.resource = iop13xx_tpmi_2_resources,
 	.dev = {
 		.dma_mask          = &iop13xx_tpmi_mask,
-		.coherent_dma_mask = DMA_64BIT_MASK,
+		.coherent_dma_mask = DMA_BIT_MASK(64),
 	},
 };
 
@@ -192,7 +192,7 @@ static struct platform_device iop13xx_tp
 	.resource = iop13xx_tpmi_3_resources,
 	.dev = {
 		.dma_mask          = &iop13xx_tpmi_mask,
-		.coherent_dma_mask = DMA_64BIT_MASK,
+		.coherent_dma_mask = DMA_BIT_MASK(64),
 	},
 };
 
diff -puN arch/arm/mach-kirkwood/common.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 arch/arm/mach-kirkwood/common.c
--- a/arch/arm/mach-kirkwood/common.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/arch/arm/mach-kirkwood/common.c
@@ -559,7 +559,7 @@ static struct platform_device kirkwood_x
 	.resource	= kirkwood_xor00_resources,
 	.dev		= {
 		.dma_mask		= &kirkwood_xor_dmamask,
-		.coherent_dma_mask	= DMA_64BIT_MASK,
+		.coherent_dma_mask	= DMA_BIT_MASK(64),
 		.platform_data		= (void *)&kirkwood_xor00_data,
 	},
 };
@@ -585,7 +585,7 @@ static struct platform_device kirkwood_x
 	.resource	= kirkwood_xor01_resources,
 	.dev		= {
 		.dma_mask		= &kirkwood_xor_dmamask,
-		.coherent_dma_mask	= DMA_64BIT_MASK,
+		.coherent_dma_mask	= DMA_BIT_MASK(64),
 		.platform_data		= (void *)&kirkwood_xor01_data,
 	},
 };
@@ -657,7 +657,7 @@ static struct platform_device kirkwood_x
 	.resource	= kirkwood_xor10_resources,
 	.dev		= {
 		.dma_mask		= &kirkwood_xor_dmamask,
-		.coherent_dma_mask	= DMA_64BIT_MASK,
+		.coherent_dma_mask	= DMA_BIT_MASK(64),
 		.platform_data		= (void *)&kirkwood_xor10_data,
 	},
 };
@@ -683,7 +683,7 @@ static struct platform_device kirkwood_x
 	.resource	= kirkwood_xor11_resources,
 	.dev		= {
 		.dma_mask		= &kirkwood_xor_dmamask,
-		.coherent_dma_mask	= DMA_64BIT_MASK,
+		.coherent_dma_mask	= DMA_BIT_MASK(64),
 		.platform_data		= (void *)&kirkwood_xor11_data,
 	},
 };
diff -puN arch/arm/mach-orion5x/common.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 arch/arm/mach-orion5x/common.c
--- a/arch/arm/mach-orion5x/common.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/arch/arm/mach-orion5x/common.c
@@ -486,7 +486,7 @@ static struct platform_device orion5x_xo
 	.resource	= orion5x_xor0_resources,
 	.dev		= {
 		.dma_mask		= &orion5x_xor_dmamask,
-		.coherent_dma_mask	= DMA_64BIT_MASK,
+		.coherent_dma_mask	= DMA_BIT_MASK(64),
 		.platform_data		= (void *)&orion5x_xor0_data,
 	},
 };
@@ -512,7 +512,7 @@ static struct platform_device orion5x_xo
 	.resource	= orion5x_xor1_resources,
 	.dev		= {
 		.dma_mask		= &orion5x_xor_dmamask,
-		.coherent_dma_mask	= DMA_64BIT_MASK,
+		.coherent_dma_mask	= DMA_BIT_MASK(64),
 		.platform_data		= (void *)&orion5x_xor1_data,
 	},
 };
diff -puN arch/arm/plat-iop/adma.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 arch/arm/plat-iop/adma.c
--- a/arch/arm/plat-iop/adma.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/arch/arm/plat-iop/adma.c
@@ -143,7 +143,7 @@ struct platform_device iop3xx_dma_0_chan
 	.resource = iop3xx_dma_0_resources,
 	.dev = {
 		.dma_mask = &iop3xx_adma_dmamask,
-		.coherent_dma_mask = DMA_64BIT_MASK,
+		.coherent_dma_mask = DMA_BIT_MASK(64),
 		.platform_data = (void *) &iop3xx_dma_0_data,
 	},
 };
@@ -155,7 +155,7 @@ struct platform_device iop3xx_dma_1_chan
 	.resource = iop3xx_dma_1_resources,
 	.dev = {
 		.dma_mask = &iop3xx_adma_dmamask,
-		.coherent_dma_mask = DMA_64BIT_MASK,
+		.coherent_dma_mask = DMA_BIT_MASK(64),
 		.platform_data = (void *) &iop3xx_dma_1_data,
 	},
 };
@@ -167,7 +167,7 @@ struct platform_device iop3xx_aau_channe
 	.resource = iop3xx_aau_resources,
 	.dev = {
 		.dma_mask = &iop3xx_adma_dmamask,
-		.coherent_dma_mask = DMA_64BIT_MASK,
+		.coherent_dma_mask = DMA_BIT_MASK(64),
 		.platform_data = (void *) &iop3xx_aau_data,
 	},
 };
diff -puN arch/ia64/sn/pci/pci_dma.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 arch/ia64/sn/pci/pci_dma.c
--- a/arch/ia64/sn/pci/pci_dma.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/arch/ia64/sn/pci/pci_dma.c
@@ -349,7 +349,7 @@ static int sn_dma_mapping_error(struct d
 
 u64 sn_dma_get_required_mask(struct device *dev)
 {
-	return DMA_64BIT_MASK;
+	return DMA_BIT_MASK(64);
 }
 EXPORT_SYMBOL_GPL(sn_dma_get_required_mask);
 
diff -puN arch/powerpc/platforms/cell/iommu.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 arch/powerpc/platforms/cell/iommu.c
--- a/arch/powerpc/platforms/cell/iommu.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/arch/powerpc/platforms/cell/iommu.c
@@ -644,7 +644,7 @@ static void dma_fixed_unmap_sg(struct de
 
 static int dma_fixed_dma_supported(struct device *dev, u64 mask)
 {
-	return mask == DMA_64BIT_MASK;
+	return mask == DMA_BIT_MASK(64);
 }
 
 static int dma_set_mask_and_switch(struct device *dev, u64 dma_mask);
diff -puN drivers/ata/ahci.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/ata/ahci.c
--- a/drivers/ata/ahci.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/ata/ahci.c
@@ -2405,8 +2405,8 @@ static int ahci_configure_dma_masks(stru
 	int rc;
 
 	if (using_dac &&
-	    !pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
-		rc = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
+	    !pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
+		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 		if (rc) {
 			rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
 			if (rc) {
diff -puN drivers/ata/sata_mv.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/ata/sata_mv.c
--- a/drivers/ata/sata_mv.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/ata/sata_mv.c
@@ -3913,8 +3913,8 @@ static int pci_go_64(struct pci_dev *pde
 {
 	int rc;
 
-	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
-		rc = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
+	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
+		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 		if (rc) {
 			rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
 			if (rc) {
diff -puN drivers/ata/sata_qstor.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/ata/sata_qstor.c
--- a/drivers/ata/sata_qstor.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/ata/sata_qstor.c
@@ -584,8 +584,8 @@ static int qs_set_dma_masks(struct pci_d
 	int rc, have_64bit_bus = (bus_info & QS_HPHY_64BIT);
 
 	if (have_64bit_bus &&
-	    !pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
-		rc = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
+	    !pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
+		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 		if (rc) {
 			rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
 			if (rc) {
diff -puN drivers/ata/sata_sil24.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/ata/sata_sil24.c
--- a/drivers/ata/sata_sil24.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/ata/sata_sil24.c
@@ -1297,8 +1297,8 @@ static int sil24_init_one(struct pci_dev
 	host->iomap = iomap;
 
 	/* configure and activate the device */
-	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
-		rc = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
+	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
+		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 		if (rc) {
 			rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
 			if (rc) {
diff -puN drivers/block/DAC960.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/block/DAC960.c
--- a/drivers/block/DAC960.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/block/DAC960.c
@@ -1372,8 +1372,8 @@ static bool DAC960_V2_EnableMemoryMailbo
   dma_addr_t	CommandMailboxDMA;
   DAC960_V2_CommandStatus_T CommandStatus;
 
-	if (!pci_set_dma_mask(Controller->PCIDevice, DMA_64BIT_MASK))
-		Controller->BounceBufferLimit = DMA_64BIT_MASK;
+	if (!pci_set_dma_mask(Controller->PCIDevice, DMA_BIT_MASK(64)))
+		Controller->BounceBufferLimit = DMA_BIT_MASK(64);
 	else if (!pci_set_dma_mask(Controller->PCIDevice, DMA_32BIT_MASK))
 		Controller->BounceBufferLimit = DMA_32BIT_MASK;
 	else
diff -puN drivers/block/cciss.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/block/cciss.c
--- a/drivers/block/cciss.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/block/cciss.c
@@ -3637,7 +3637,7 @@ static int __devinit cciss_init_one(stru
 	hba[i]->pdev = pdev;
 
 	/* configure PCI DMA stuff */
-	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK))
+	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64)))
 		dac = 1;
 	else if (!pci_set_dma_mask(pdev, DMA_32BIT_MASK))
 		dac = 0;
diff -puN drivers/block/sx8.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/block/sx8.c
--- a/drivers/block/sx8.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/block/sx8.c
@@ -1586,9 +1586,9 @@ static int carm_init_one (struct pci_dev
 		goto err_out;
 
 #ifdef IF_64BIT_DMA_IS_POSSIBLE /* grrrr... */
-	rc = pci_set_dma_mask(pdev, DMA_64BIT_MASK);
+	rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
 	if (!rc) {
-		rc = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
+		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 		if (rc) {
 			printk(KERN_ERR DRV_NAME "(%s): consistent DMA mask failure\n",
 				pci_name(pdev));
diff -puN drivers/block/umem.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/block/umem.c
--- a/drivers/block/umem.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/block/umem.c
@@ -829,7 +829,7 @@ static int __devinit mm_pci_probe(struct
 	dev_printk(KERN_INFO, &dev->dev,
 	  "Micro Memory(tm) controller found (PCI Mem Module (Battery Backup))\n");
 
-	if (pci_set_dma_mask(dev, DMA_64BIT_MASK) &&
+	if (pci_set_dma_mask(dev, DMA_BIT_MASK(64)) &&
 	    pci_set_dma_mask(dev, DMA_32BIT_MASK)) {
 		dev_printk(KERN_WARNING, &dev->dev, "NO suitable DMA found\n");
 		return  -ENOMEM;
diff -puN drivers/dma/ioat.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/dma/ioat.c
--- a/drivers/dma/ioat.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/dma/ioat.c
@@ -98,13 +98,13 @@ static int __devinit ioat_probe(struct p
 	if (err)
 		goto err_request_regions;
 
-	err = pci_set_dma_mask(pdev, DMA_64BIT_MASK);
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
 	if (err)
 		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
 	if (err)
 		goto err_set_dma_mask;
 
-	err = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
+	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 	if (err)
 		err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
 	if (err)
diff -puN drivers/idle/i7300_idle.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/idle/i7300_idle.c
--- a/drivers/idle/i7300_idle.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/idle/i7300_idle.c
@@ -178,7 +178,7 @@ static int __init i7300_idle_ioat_selfte
 
 static struct device dummy_dma_dev = {
 	.init_name = "fallback device",
-	.coherent_dma_mask = DMA_64BIT_MASK,
+	.coherent_dma_mask = DMA_BIT_MASK(64),
 	.dma_mask = &dummy_dma_dev.coherent_dma_mask,
 };
 
diff -puN drivers/infiniband/hw/amso1100/c2.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/infiniband/hw/amso1100/c2.c
--- a/drivers/infiniband/hw/amso1100/c2.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/infiniband/hw/amso1100/c2.c
@@ -989,7 +989,7 @@ static int __devinit c2_probe(struct pci
 	}
 
 	if ((sizeof(dma_addr_t) > 4)) {
-		ret = pci_set_dma_mask(pcidev, DMA_64BIT_MASK);
+		ret = pci_set_dma_mask(pcidev, DMA_BIT_MASK(64));
 		if (ret < 0) {
 			printk(KERN_ERR PFX "64b DMA configuration failed\n");
 			goto bail2;
diff -puN drivers/infiniband/hw/ipath/ipath_driver.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/infiniband/hw/ipath/ipath_driver.c
--- a/drivers/infiniband/hw/ipath/ipath_driver.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -470,7 +470,7 @@ static int __devinit ipath_init_one(stru
 		goto bail_disable;
 	}
 
-	ret = pci_set_dma_mask(pdev, DMA_64BIT_MASK);
+	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
 	if (ret) {
 		/*
 		 * if the 64 bit setup fails, try 32 bit.  Some systems
@@ -496,7 +496,7 @@ static int __devinit ipath_init_one(stru
 		}
 	}
 	else {
-		ret = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
+		ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 		if (ret)
 			dev_info(&pdev->dev,
 				"Unable to set DMA consistent mask "
diff -puN drivers/infiniband/hw/mthca/mthca_main.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/infiniband/hw/mthca/mthca_main.c
--- a/drivers/infiniband/hw/mthca/mthca_main.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/infiniband/hw/mthca/mthca_main.c
@@ -1016,7 +1016,7 @@ static int __mthca_init_one(struct pci_d
 
 	pci_set_master(pdev);
 
-	err = pci_set_dma_mask(pdev, DMA_64BIT_MASK);
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
 	if (err) {
 		dev_warn(&pdev->dev, "Warning: couldn't set 64-bit PCI DMA mask.\n");
 		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
@@ -1025,7 +1025,7 @@ static int __mthca_init_one(struct pci_d
 			goto err_free_res;
 		}
 	}
-	err = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
+	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 	if (err) {
 		dev_warn(&pdev->dev, "Warning: couldn't set 64-bit "
 			 "consistent PCI DMA mask.\n");
diff -puN drivers/infiniband/hw/nes/nes.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/infiniband/hw/nes/nes.c
--- a/drivers/infiniband/hw/nes/nes.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/infiniband/hw/nes/nes.c
@@ -478,12 +478,12 @@ static int __devinit nes_probe(struct pc
 	}
 
 	if ((sizeof(dma_addr_t) > 4)) {
-		ret = pci_set_dma_mask(pcidev, DMA_64BIT_MASK);
+		ret = pci_set_dma_mask(pcidev, DMA_BIT_MASK(64));
 		if (ret < 0) {
 			printk(KERN_ERR PFX "64b DMA mask configuration failed\n");
 			goto bail2;
 		}
-		ret = pci_set_consistent_dma_mask(pcidev, DMA_64BIT_MASK);
+		ret = pci_set_consistent_dma_mask(pcidev, DMA_BIT_MASK(64));
 		if (ret) {
 			printk(KERN_ERR PFX "64b DMA consistent mask configuration failed\n");
 			goto bail2;
diff -puN drivers/message/fusion/mptbase.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/message/fusion/mptbase.c
@@ -1534,8 +1534,8 @@ mpt_mapresources(MPT_ADAPTER *ioc)
 
 	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);
 
-	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)
-	    && !pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK)) {
+	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))
+	    && !pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		dinitprintk(ioc, printk(MYIOC_s_INFO_FMT
 		    ": 64 BIT PCI BUS DMA ADDRESSING SUPPORTED\n",
 		    ioc->name));
diff -puN drivers/message/i2o/memory.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/message/i2o/memory.c
--- a/drivers/message/i2o/memory.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/message/i2o/memory.c
@@ -185,7 +185,7 @@ int i2o_dma_alloc(struct device *dev, st
 	int dma_64 = 0;
 
 	mutex_lock(&mem_lock);
-	if ((sizeof(dma_addr_t) > 4) && (pdev->dma_mask == DMA_64BIT_MASK)) {
+	if ((sizeof(dma_addr_t) > 4) && (pdev->dma_mask == DMA_BIT_MASK(64))) {
 		dma_64 = 1;
 		if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
 			mutex_unlock(&mem_lock);
@@ -196,7 +196,7 @@ int i2o_dma_alloc(struct device *dev, st
 	addr->virt = dma_alloc_coherent(dev, len, &addr->phys, GFP_KERNEL);
 
 	if ((sizeof(dma_addr_t) > 4) && dma_64)
-		if (pci_set_dma_mask(pdev, DMA_64BIT_MASK))
+		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)))
 			printk(KERN_WARNING "i2o: unable to set 64-bit DMA");
 	mutex_unlock(&mem_lock);
 
diff -puN drivers/message/i2o/pci.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/message/i2o/pci.c
--- a/drivers/message/i2o/pci.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/message/i2o/pci.c
@@ -397,7 +397,7 @@ static int __devinit i2o_pci_probe(struc
 		}
 #ifdef CONFIG_I2O_EXT_ADAPTEC_DMA64
 		if (sizeof(dma_addr_t) > 4) {
-			if (pci_set_dma_mask(pdev, DMA_64BIT_MASK))
+			if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)))
 				printk(KERN_INFO "%s: 64-bit DMA unavailable\n",
 				       c->name);
 			else {
diff -puN drivers/net/8139cp.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/net/8139cp.c
--- a/drivers/net/8139cp.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/net/8139cp.c
@@ -1929,8 +1929,8 @@ static int cp_init_one (struct pci_dev *
 
 	/* Configure DMA attributes. */
 	if ((sizeof(dma_addr_t) > 4) &&
-	    !pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK) &&
-	    !pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
+	    !pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)) &&
+	    !pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		pci_using_dac = 1;
 	} else {
 		pci_using_dac = 0;
diff -puN drivers/net/acenic.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/net/acenic.c
--- a/drivers/net/acenic.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/net/acenic.c
@@ -1161,7 +1161,7 @@ static int __devinit ace_init(struct net
 	/*
 	 * Configure DMA attributes.
 	 */
-	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
+	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		ap->pci_using_dac = 1;
 	} else if (!pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
 		ap->pci_using_dac = 0;
diff -puN drivers/net/bnx2.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/net/bnx2.c
--- a/drivers/net/bnx2.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/net/bnx2.c
@@ -7475,7 +7475,7 @@ bnx2_init_board(struct pci_dev *pdev, st
 	if (CHIP_NUM(bp) == CHIP_NUM_5708)
 		persist_dma_mask = dma_mask = DMA_40BIT_MASK;
 	else
-		persist_dma_mask = dma_mask = DMA_64BIT_MASK;
+		persist_dma_mask = dma_mask = DMA_BIT_MASK(64);
 
 	/* Configure DMA attributes. */
 	if (pci_set_dma_mask(pdev, dma_mask) == 0) {
diff -puN drivers/net/bnx2x_main.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/net/bnx2x_main.c
--- a/drivers/net/bnx2x_main.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/net/bnx2x_main.c
@@ -10979,9 +10979,9 @@ static int __devinit bnx2x_init_dev(stru
 		goto err_out_release;
 	}
 
-	if (pci_set_dma_mask(pdev, DMA_64BIT_MASK) == 0) {
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) == 0) {
 		bp->flags |= USING_DAC_FLAG;
-		if (pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK) != 0) {
+		if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)) != 0) {
 			printk(KERN_ERR PFX "pci_set_consistent_dma_mask"
 			       " failed, aborting\n");
 			rc = -EIO;
diff -puN drivers/net/cassini.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/net/cassini.c
--- a/drivers/net/cassini.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/net/cassini.c
@@ -5074,10 +5074,10 @@ static int __devinit cas_init_one(struct
 
 
 	/* Configure DMA attributes. */
-	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
+	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		pci_using_dac = 1;
 		err = pci_set_consistent_dma_mask(pdev,
-						  DMA_64BIT_MASK);
+						  DMA_BIT_MASK(64));
 		if (err < 0) {
 			dev_err(&pdev->dev, "Unable to obtain 64-bit DMA "
 			       "for consistent allocations\n");
diff -puN drivers/net/chelsio/cxgb2.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/net/chelsio/cxgb2.c
--- a/drivers/net/chelsio/cxgb2.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/net/chelsio/cxgb2.c
@@ -1056,10 +1056,10 @@ static int __devinit init_one(struct pci
 		goto out_disable_pdev;
 	}
 
-	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
+	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		pci_using_dac = 1;
 
-		if (pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK)) {
+		if (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64))) {
 			CH_ERR("%s: unable to obtain 64-bit DMA for "
 			       "consistent allocations\n", pci_name(pdev));
 			err = -ENODEV;
diff -puN drivers/net/cxgb3/cxgb3_main.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/net/cxgb3/cxgb3_main.c
--- a/drivers/net/cxgb3/cxgb3_main.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/net/cxgb3/cxgb3_main.c
@@ -3038,9 +3038,9 @@ static int __devinit init_one(struct pci
 		goto out_release_regions;
 	}
 
-	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
+	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		pci_using_dac = 1;
-		err = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
+		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 		if (err) {
 			dev_err(&pdev->dev, "unable to obtain 64-bit DMA for "
 			       "coherent allocations\n");
diff -puN drivers/net/e1000/e1000_main.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/net/e1000/e1000_main.c
--- a/drivers/net/e1000/e1000_main.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/net/e1000/e1000_main.c
@@ -962,8 +962,8 @@ static int __devinit e1000_probe(struct 
 	if (err)
 		return err;
 
-	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK) &&
-	    !pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK)) {
+	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) &&
+	    !pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		pci_using_dac = 1;
 	} else {
 		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
diff -puN drivers/net/e1000e/netdev.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/net/e1000e/netdev.c
--- a/drivers/net/e1000e/netdev.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/net/e1000e/netdev.c
@@ -4763,9 +4763,9 @@ static int __devinit e1000_probe(struct 
 		return err;
 
 	pci_using_dac = 0;
-	err = pci_set_dma_mask(pdev, DMA_64BIT_MASK);
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
 	if (!err) {
-		err = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
+		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 		if (!err)
 			pci_using_dac = 1;
 	} else {
diff -puN drivers/net/igb/igb_main.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/net/igb/igb_main.c
--- a/drivers/net/igb/igb_main.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/net/igb/igb_main.c
@@ -1154,9 +1154,9 @@ static int __devinit igb_probe(struct pc
 		return err;
 
 	pci_using_dac = 0;
-	err = pci_set_dma_mask(pdev, DMA_64BIT_MASK);
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
 	if (!err) {
-		err = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
+		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 		if (!err)
 			pci_using_dac = 1;
 	} else {
diff -puN drivers/net/ioc3-eth.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/net/ioc3-eth.c
--- a/drivers/net/ioc3-eth.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/net/ioc3-eth.c
@@ -1226,10 +1226,10 @@ static int __devinit ioc3_probe(struct p
 	int err, pci_using_dac;
 
 	/* Configure DMA attributes. */
-	err = pci_set_dma_mask(pdev, DMA_64BIT_MASK);
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
 	if (!err) {
 		pci_using_dac = 1;
-		err = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
+		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 		if (err < 0) {
 			printk(KERN_ERR "%s: Unable to obtain 64 bit DMA "
 			       "for consistent allocations\n", pci_name(pdev));
diff -puN drivers/net/ixgb/ixgb_main.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/net/ixgb/ixgb_main.c
--- a/drivers/net/ixgb/ixgb_main.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/net/ixgb/ixgb_main.c
@@ -365,8 +365,8 @@ ixgb_probe(struct pci_dev *pdev, const s
 	if (err)
 		return err;
 
-	if (!(err = pci_set_dma_mask(pdev, DMA_64BIT_MASK)) &&
-	    !(err = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK))) {
+	if (!(err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) &&
+	    !(err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)))) {
 		pci_using_dac = 1;
 	} else {
 		if ((err = pci_set_dma_mask(pdev, DMA_32BIT_MASK)) ||
diff -puN drivers/net/ixgbe/ixgbe_main.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/net/ixgbe/ixgbe_main.c
--- a/drivers/net/ixgbe/ixgbe_main.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/net/ixgbe/ixgbe_main.c
@@ -4509,8 +4509,8 @@ static int __devinit ixgbe_probe(struct 
 	if (err)
 		return err;
 
-	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK) &&
-	    !pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK)) {
+	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) &&
+	    !pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		pci_using_dac = 1;
 	} else {
 		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
diff -puN drivers/net/mlx4/main.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/net/mlx4/main.c
--- a/drivers/net/mlx4/main.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/net/mlx4/main.c
@@ -1076,7 +1076,7 @@ static int __mlx4_init_one(struct pci_de
 
 	pci_set_master(pdev);
 
-	err = pci_set_dma_mask(pdev, DMA_64BIT_MASK);
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
 	if (err) {
 		dev_warn(&pdev->dev, "Warning: couldn't set 64-bit PCI DMA mask.\n");
 		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
@@ -1085,7 +1085,7 @@ static int __mlx4_init_one(struct pci_de
 			goto err_release_bar2;
 		}
 	}
-	err = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
+	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 	if (err) {
 		dev_warn(&pdev->dev, "Warning: couldn't set 64-bit "
 			 "consistent PCI DMA mask.\n");
diff -puN drivers/net/myri10ge/myri10ge.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/net/myri10ge/myri10ge.c
--- a/drivers/net/myri10ge/myri10ge.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/net/myri10ge/myri10ge.c
@@ -3792,7 +3792,7 @@ static int myri10ge_probe(struct pci_dev
 
 	pci_set_master(pdev);
 	dac_enabled = 1;
-	status = pci_set_dma_mask(pdev, DMA_64BIT_MASK);
+	status = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
 	if (status != 0) {
 		dac_enabled = 0;
 		dev_err(&pdev->dev,
@@ -3804,7 +3804,7 @@ static int myri10ge_probe(struct pci_dev
 		dev_err(&pdev->dev, "Error %d setting DMA mask\n", status);
 		goto abort_with_enabled;
 	}
-	(void)pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
+	(void)pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 	mgp->cmd = dma_alloc_coherent(&pdev->dev, sizeof(*mgp->cmd),
 				      &mgp->cmd_bus, GFP_KERNEL);
 	if (mgp->cmd == NULL)
diff -puN drivers/net/ns83820.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/net/ns83820.c
--- a/drivers/net/ns83820.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/net/ns83820.c
@@ -1973,7 +1973,7 @@ static int __devinit ns83820_init_one(st
 
 	/* See if we can set the dma mask early on; failure is fatal. */
 	if (sizeof(dma_addr_t) == 8 &&
-	 	!pci_set_dma_mask(pci_dev, DMA_64BIT_MASK)) {
+	 	!pci_set_dma_mask(pci_dev, DMA_BIT_MASK(64))) {
 		using_dac = 1;
 	} else if (!pci_set_dma_mask(pci_dev, DMA_32BIT_MASK)) {
 		using_dac = 0;
diff -puN drivers/net/qla3xxx.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/net/qla3xxx.c
--- a/drivers/net/qla3xxx.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/net/qla3xxx.c
@@ -3934,9 +3934,9 @@ static int __devinit ql3xxx_probe(struct
 
 	pci_set_master(pdev);
 
-	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
+	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		pci_using_dac = 1;
-		err = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
+		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 	} else if (!(err = pci_set_dma_mask(pdev, DMA_32BIT_MASK))) {
 		pci_using_dac = 0;
 		err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
diff -puN drivers/net/qlge/qlge_main.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/net/qlge/qlge_main.c
--- a/drivers/net/qlge/qlge_main.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/net/qlge/qlge_main.c
@@ -3726,9 +3726,9 @@ static int __devinit ql_init_device(stru
 	}
 
 	pci_set_master(pdev);
-	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
+	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		set_bit(QL_DMA64, &qdev->flags);
-		err = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
+		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 	} else {
 		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
 		if (!err)
diff -puN drivers/net/r8169.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/net/r8169.c
--- a/drivers/net/r8169.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/net/r8169.c
@@ -2046,7 +2046,7 @@ rtl8169_init_one(struct pci_dev *pdev, c
 	tp->cp_cmd = PCIMulRW | RxChkSum;
 
 	if ((sizeof(dma_addr_t) > 4) &&
-	    !pci_set_dma_mask(pdev, DMA_64BIT_MASK) && use_dac) {
+	    !pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) && use_dac) {
 		tp->cp_cmd |= PCIDAC;
 		dev->features |= NETIF_F_HIGHDMA;
 	} else {
diff -puN drivers/net/s2io.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/net/s2io.c
--- a/drivers/net/s2io.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/net/s2io.c
@@ -7775,11 +7775,11 @@ s2io_init_nic(struct pci_dev *pdev, cons
 		return ret;
 	}
 
-	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
+	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		DBG_PRINT(INIT_DBG, "s2io_init_nic: Using 64bit DMA\n");
 		dma_flag = TRUE;
 		if (pci_set_consistent_dma_mask
-		    (pdev, DMA_64BIT_MASK)) {
+		    (pdev, DMA_BIT_MASK(64))) {
 			DBG_PRINT(ERR_DBG,
 				  "Unable to obtain 64bit DMA for \
 					consistent allocations\n");
diff -puN drivers/net/skge.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/net/skge.c
--- a/drivers/net/skge.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/net/skge.c
@@ -3912,9 +3912,9 @@ static int __devinit skge_probe(struct p
 
 	pci_set_master(pdev);
 
-	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
+	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		using_dac = 1;
-		err = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
+		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 	} else if (!(err = pci_set_dma_mask(pdev, DMA_32BIT_MASK))) {
 		using_dac = 0;
 		err = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
diff -puN drivers/net/sky2.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/net/sky2.c
--- a/drivers/net/sky2.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/net/sky2.c
@@ -4374,9 +4374,9 @@ static int __devinit sky2_probe(struct p
 	pci_set_master(pdev);
 
 	if (sizeof(dma_addr_t) > sizeof(u32) &&
-	    !(err = pci_set_dma_mask(pdev, DMA_64BIT_MASK))) {
+	    !(err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64)))) {
 		using_dac = 1;
-		err = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
+		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 		if (err < 0) {
 			dev_err(&pdev->dev, "unable to obtain 64 bit DMA "
 				"for consistent allocations\n");
diff -puN drivers/net/sungem.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/net/sungem.c
--- a/drivers/net/sungem.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/net/sungem.c
@@ -3042,7 +3042,7 @@ static int __devinit gem_init_one(struct
 	 */
 	if (pdev->vendor == PCI_VENDOR_ID_SUN &&
 	    pdev->device == PCI_DEVICE_ID_SUN_GEM &&
-	    !pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
+	    !pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		pci_using_dac = 1;
 	} else {
 		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
diff -puN drivers/net/tehuti.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/net/tehuti.c
--- a/drivers/net/tehuti.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/net/tehuti.c
@@ -1941,8 +1941,8 @@ bdx_probe(struct pci_dev *pdev, const st
 	if ((err = pci_enable_device(pdev)))	/* it trigers interrupt, dunno why. */
 		goto err_pci;			/* it's not a problem though */
 
-	if (!(err = pci_set_dma_mask(pdev, DMA_64BIT_MASK)) &&
-	    !(err = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK))) {
+	if (!(err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) &&
+	    !(err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)))) {
 		pci_using_dac = 1;
 	} else {
 		if ((err = pci_set_dma_mask(pdev, DMA_32BIT_MASK)) ||
diff -puN drivers/net/tehuti.h~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/net/tehuti.h
--- a/drivers/net/tehuti.h~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/net/tehuti.h
@@ -31,6 +31,7 @@
 #include <linux/vmalloc.h>
 #include <linux/firmware.h>
 #include <asm/byteorder.h>
+#include <linux/dma-mapping.h>
 
 /* Compile Time Switches */
 /* start */
@@ -98,10 +99,6 @@
 #define READ_REG(pp, reg)         readl(pp->pBdxRegs + reg)
 #define WRITE_REG(pp, reg, val)   writel(val, pp->pBdxRegs + reg)
 
-#ifndef DMA_64BIT_MASK
-#   define DMA_64BIT_MASK  0xffffffffffffffffULL
-#endif
-
 #ifndef DMA_32BIT_MASK
 #   define DMA_32BIT_MASK  0x00000000ffffffffULL
 #endif
diff -puN drivers/net/tg3.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/net/tg3.c
--- a/drivers/net/tg3.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/net/tg3.c
@@ -13232,10 +13232,10 @@ static int __devinit tg3_init_one(struct
 	else if (tp->tg3_flags & TG3_FLAG_40BIT_DMA_BUG) {
 		persist_dma_mask = dma_mask = DMA_40BIT_MASK;
 #ifdef CONFIG_HIGHMEM
-		dma_mask = DMA_64BIT_MASK;
+		dma_mask = DMA_BIT_MASK(64);
 #endif
 	} else
-		persist_dma_mask = dma_mask = DMA_64BIT_MASK;
+		persist_dma_mask = dma_mask = DMA_BIT_MASK(64);
 
 	/* Configure DMA attributes. */
 	if (dma_mask > DMA_32BIT_MASK) {
diff -puN drivers/net/usb/usbnet.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/net/usb/usbnet.c
--- a/drivers/net/usb/usbnet.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/net/usb/usbnet.c
@@ -1180,7 +1180,7 @@ usbnet_probe (struct usb_interface *udev
 #if 0
 // dma_supported() is deeply broken on almost all architectures
 	// possible with some EHCI controllers
-	if (dma_supported (&udev->dev, DMA_64BIT_MASK))
+	if (dma_supported (&udev->dev, DMA_BIT_MASK(64)))
 		net->features |= NETIF_F_HIGHDMA;
 #endif
 
diff -puN drivers/net/wireless/b43/dma.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/net/wireless/b43/dma.c
--- a/drivers/net/wireless/b43/dma.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/net/wireless/b43/dma.c
@@ -772,7 +772,7 @@ static u64 supported_dma_mask(struct b43
 
 	tmp = b43_read32(dev, SSB_TMSHIGH);
 	if (tmp & SSB_TMSHIGH_DMA64)
-		return DMA_64BIT_MASK;
+		return DMA_BIT_MASK(64);
 	mmio_base = b43_dmacontroller_base(0, 0);
 	b43_write32(dev, mmio_base + B43_DMA32_TXCTL, B43_DMA32_TXADDREXT_MASK);
 	tmp = b43_read32(dev, mmio_base + B43_DMA32_TXCTL);
@@ -788,7 +788,7 @@ static enum b43_dmatype dma_mask_to_engi
 		return B43_DMA_30BIT;
 	if (dmamask == DMA_32BIT_MASK)
 		return B43_DMA_32BIT;
-	if (dmamask == DMA_64BIT_MASK)
+	if (dmamask == DMA_BIT_MASK(64))
 		return B43_DMA_64BIT;
 	B43_WARN_ON(1);
 	return B43_DMA_30BIT;
@@ -999,7 +999,7 @@ static int b43_dma_set_mask(struct b43_w
 		err = ssb_dma_set_mask(dev->dev, mask);
 		if (!err)
 			break;
-		if (mask == DMA_64BIT_MASK) {
+		if (mask == DMA_BIT_MASK(64)) {
 			mask = DMA_32BIT_MASK;
 			fallback = 1;
 			continue;
diff -puN drivers/net/wireless/b43legacy/dma.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/net/wireless/b43legacy/dma.c
--- a/drivers/net/wireless/b43legacy/dma.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/net/wireless/b43legacy/dma.c
@@ -846,7 +846,7 @@ static u64 supported_dma_mask(struct b43
 
 	tmp = b43legacy_read32(dev, SSB_TMSHIGH);
 	if (tmp & SSB_TMSHIGH_DMA64)
-		return DMA_64BIT_MASK;
+		return DMA_BIT_MASK(64);
 	mmio_base = b43legacy_dmacontroller_base(0, 0);
 	b43legacy_write32(dev,
 			mmio_base + B43legacy_DMA32_TXCTL,
@@ -865,7 +865,7 @@ static enum b43legacy_dmatype dma_mask_t
 		return B43legacy_DMA_30BIT;
 	if (dmamask == DMA_32BIT_MASK)
 		return B43legacy_DMA_32BIT;
-	if (dmamask == DMA_64BIT_MASK)
+	if (dmamask == DMA_BIT_MASK(64))
 		return B43legacy_DMA_64BIT;
 	B43legacy_WARN_ON(1);
 	return B43legacy_DMA_30BIT;
@@ -1042,7 +1042,7 @@ static int b43legacy_dma_set_mask(struct
 		err = ssb_dma_set_mask(dev->dev, mask);
 		if (!err)
 			break;
-		if (mask == DMA_64BIT_MASK) {
+		if (mask == DMA_BIT_MASK(64)) {
 			mask = DMA_32BIT_MASK;
 			fallback = 1;
 			continue;
diff -puN drivers/pci/intel-iommu.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/pci/intel-iommu.c
@@ -57,7 +57,7 @@
 
 #define IOVA_PFN(addr)		((addr) >> PAGE_SHIFT)
 #define DMA_32BIT_PFN		IOVA_PFN(DMA_32BIT_MASK)
-#define DMA_64BIT_PFN		IOVA_PFN(DMA_64BIT_MASK)
+#define DMA_64BIT_PFN		IOVA_PFN(DMA_BIT_MASK(64))
 
 /* global iommu list, set NULL for ignored DMAR units */
 static struct intel_iommu **g_iommus;
diff -puN drivers/scsi/3w-9xxx.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/scsi/3w-9xxx.c
--- a/drivers/scsi/3w-9xxx.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/scsi/3w-9xxx.c
@@ -2016,8 +2016,8 @@ static int __devinit twa_probe(struct pc
 	pci_set_master(pdev);
 	pci_try_set_mwi(pdev);
 
-	if (pci_set_dma_mask(pdev, DMA_64BIT_MASK)
-	    || pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK))
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64))
+	    || pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)))
 		if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)
 		    || pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK)) {
 			TW_PRINTK(host, TW_DRIVER, 0x23, "Failed to set dma mask");
diff -puN drivers/scsi/aacraid/aachba.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/scsi/aacraid/aachba.c
--- a/drivers/scsi/aacraid/aachba.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/scsi/aacraid/aachba.c
@@ -1402,8 +1402,8 @@ int aac_get_adapter_info(struct aac_dev*
 	}
 
 	if(dev->dac_support != 0) {
-		if (!pci_set_dma_mask(dev->pdev, DMA_64BIT_MASK) &&
-			!pci_set_consistent_dma_mask(dev->pdev, DMA_64BIT_MASK)) {
+		if (!pci_set_dma_mask(dev->pdev, DMA_BIT_MASK(64)) &&
+			!pci_set_consistent_dma_mask(dev->pdev, DMA_BIT_MASK(64))) {
 			if (!dev->in_reset)
 				printk(KERN_INFO"%s%d: 64 Bit DAC enabled\n",
 					dev->name, dev->id);
diff -puN drivers/scsi/aic7xxx/aic79xx_osm_pci.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/scsi/aic7xxx/aic79xx_osm_pci.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
@@ -195,7 +195,7 @@ ahd_linux_pci_dev_probe(struct pci_dev *
 		const u64 required_mask = dma_get_required_mask(dev);
 
 		if (required_mask > DMA_39BIT_MASK &&
-		    dma_set_mask(dev, DMA_64BIT_MASK) == 0)
+		    dma_set_mask(dev, DMA_BIT_MASK(64)) == 0)
 			ahd->flags |= AHD_64BIT_ADDRESSING;
 		else if (required_mask > DMA_32BIT_MASK &&
 			 dma_set_mask(dev, DMA_39BIT_MASK) == 0)
diff -puN drivers/scsi/aic94xx/aic94xx_init.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/scsi/aic94xx/aic94xx_init.c
--- a/drivers/scsi/aic94xx/aic94xx_init.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/scsi/aic94xx/aic94xx_init.c
@@ -790,8 +790,8 @@ static int __devinit asd_pci_probe(struc
 		goto Err_remove;
 
 	err = -ENODEV;
-	if (!pci_set_dma_mask(dev, DMA_64BIT_MASK)
-	    && !pci_set_consistent_dma_mask(dev, DMA_64BIT_MASK))
+	if (!pci_set_dma_mask(dev, DMA_BIT_MASK(64))
+	    && !pci_set_consistent_dma_mask(dev, DMA_BIT_MASK(64)))
 		;
 	else if (!pci_set_dma_mask(dev, DMA_32BIT_MASK)
 		 && !pci_set_consistent_dma_mask(dev, DMA_32BIT_MASK))
diff -puN drivers/scsi/arcmsr/arcmsr_hba.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -393,7 +393,7 @@ static int arcmsr_probe(struct pci_dev *
 	acb = (struct AdapterControlBlock *)host->hostdata;
 	memset(acb, 0, sizeof (struct AdapterControlBlock));
 
-	error = pci_set_dma_mask(pdev, DMA_64BIT_MASK);
+	error = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
 	if (error) {
 		error = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
 		if (error) {
diff -puN drivers/scsi/dpt_i2o.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/scsi/dpt_i2o.c
--- a/drivers/scsi/dpt_i2o.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/scsi/dpt_i2o.c
@@ -1014,7 +1014,7 @@ static int adpt_install_hba(struct scsi_
 	 *	See if we should enable dma64 mode.
 	 */
 	if (sizeof(dma_addr_t) > 4 &&
-	    pci_set_dma_mask(pDev, DMA_64BIT_MASK) == 0) {
+	    pci_set_dma_mask(pDev, DMA_BIT_MASK(64)) == 0) {
 		if (dma_get_required_mask(&pDev->dev) > DMA_32BIT_MASK)
 			dma64 = 1;
 	}
diff -puN drivers/scsi/gdth.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/scsi/gdth.c
@@ -5030,7 +5030,7 @@ static int __devinit gdth_pci_probe_one(
 		}
 	} else {
 		shp->max_cmd_len = 16;
-		if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
+		if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 			printk("GDT-PCI %d: 64-bit DMA enabled\n", ha->hanum);
 		} else if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
 			printk(KERN_WARNING "GDT-PCI %d: "
diff -puN drivers/scsi/hptiop.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/scsi/hptiop.c
--- a/drivers/scsi/hptiop.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/scsi/hptiop.c
@@ -958,7 +958,7 @@ static int __devinit hptiop_probe(struct
 	pci_set_master(pcidev);
 
 	/* Enable 64bit DMA if possible */
-	if (pci_set_dma_mask(pcidev, DMA_64BIT_MASK)) {
+	if (pci_set_dma_mask(pcidev, DMA_BIT_MASK(64))) {
 		if (pci_set_dma_mask(pcidev, DMA_32BIT_MASK)) {
 			printk(KERN_ERR "hptiop: fail to set dma_mask\n");
 			goto disable_pci_device;
diff -puN drivers/scsi/ips.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/scsi/ips.c
--- a/drivers/scsi/ips.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/scsi/ips.c
@@ -7048,7 +7048,7 @@ ips_init_phase1(struct pci_dev *pci_dev,
 	 * are guaranteed to be < 4G.
 	 */
 	if (IPS_ENABLE_DMA64 && IPS_HAS_ENH_SGLIST(ha) &&
-	    !pci_set_dma_mask(ha->pcidev, DMA_64BIT_MASK)) {
+	    !pci_set_dma_mask(ha->pcidev, DMA_BIT_MASK(64))) {
 		(ha)->flags |= IPS_HA_ENH_SG;
 	} else {
 		if (pci_set_dma_mask(ha->pcidev, DMA_32BIT_MASK) != 0) {
diff -puN drivers/scsi/lpfc/lpfc_init.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/scsi/lpfc/lpfc_init.c
@@ -2660,7 +2660,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	pci_save_state(pdev);
 	pci_try_set_mwi(pdev);
 
-	if (pci_set_dma_mask(phba->pcidev, DMA_64BIT_MASK) != 0)
+	if (pci_set_dma_mask(phba->pcidev, DMA_BIT_MASK(64)) != 0)
 		if (pci_set_dma_mask(phba->pcidev, DMA_32BIT_MASK) != 0)
 			goto out_idr_remove;
 
diff -puN drivers/scsi/megaraid.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/scsi/megaraid.c
@@ -4793,7 +4793,7 @@ megaraid_probe_one(struct pci_dev *pdev,
 
 	/* Set the Mode of addressing to 64 bit if we can */
 	if ((adapter->flag & BOARD_64BIT) && (sizeof(dma_addr_t) == 8)) {
-		pci_set_dma_mask(pdev, DMA_64BIT_MASK);
+		pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
 		adapter->has_64bit_addr = 1;
 	} else  {
 		pci_set_dma_mask(pdev, DMA_32BIT_MASK);
diff -puN drivers/scsi/megaraid/megaraid_mbox.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/scsi/megaraid/megaraid_mbox.c
--- a/drivers/scsi/megaraid/megaraid_mbox.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/scsi/megaraid/megaraid_mbox.c
@@ -900,7 +900,7 @@ megaraid_init_mbox(adapter_t *adapter)
 		adapter->pdev->device == PCI_DEVICE_ID_PERC4_DI_EVERGLADES) ||
 		(adapter->pdev->vendor == PCI_VENDOR_ID_DELL &&
 		adapter->pdev->device == PCI_DEVICE_ID_PERC4E_DI_KOBUK)) {
-		if (pci_set_dma_mask(adapter->pdev, DMA_64BIT_MASK)) {
+		if (pci_set_dma_mask(adapter->pdev, DMA_BIT_MASK(64))) {
 			con_log(CL_ANN, (KERN_WARNING
 				"megaraid: DMA mask for 64-bit failed\n"));
 
diff -puN drivers/scsi/megaraid/megaraid_sas.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/scsi/megaraid/megaraid_sas.c
--- a/drivers/scsi/megaraid/megaraid_sas.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/scsi/megaraid/megaraid_sas.c
@@ -2497,7 +2497,7 @@ megasas_set_dma_mask(struct pci_dev *pde
 	 * All our contollers are capable of performing 64-bit DMA
 	 */
 	if (IS_DMA64) {
-		if (pci_set_dma_mask(pdev, DMA_64BIT_MASK) != 0) {
+		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) != 0) {
 
 			if (pci_set_dma_mask(pdev, DMA_32BIT_MASK) != 0)
 				goto fail_set_dma_mask;
diff -puN drivers/scsi/mvsas.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/scsi/mvsas.c
--- a/drivers/scsi/mvsas.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/scsi/mvsas.c
@@ -875,8 +875,8 @@ static int pci_go_64(struct pci_dev *pde
 {
 	int rc;
 
-	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
-		rc = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
+	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
+		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 		if (rc) {
 			rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);
 			if (rc) {
diff -puN drivers/scsi/qla1280.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/scsi/qla1280.c
--- a/drivers/scsi/qla1280.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/scsi/qla1280.c
@@ -4275,7 +4275,7 @@ qla1280_probe_one(struct pci_dev *pdev, 
 	ha->devnum = devnum;	/* specifies microcode load address */
 
 #ifdef QLA_64BIT_PTR
-	if (pci_set_dma_mask(ha->pdev, DMA_64BIT_MASK)) {
+	if (pci_set_dma_mask(ha->pdev, DMA_BIT_MASK(64))) {
 		if (pci_set_dma_mask(ha->pdev, DMA_32BIT_MASK)) {
 			printk(KERN_WARNING "scsi(%li): Unable to set a "
 			       "suitable DMA mask - aborting\n", ha->host_no);
diff -puN drivers/scsi/qla2xxx/qla_os.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/scsi/qla2xxx/qla_os.c
@@ -1176,10 +1176,10 @@ qla2x00_config_dma_addressing(struct qla
 	/* Assume a 32bit DMA mask. */
 	ha->flags.enable_64bit_addressing = 0;
 
-	if (!dma_set_mask(&ha->pdev->dev, DMA_64BIT_MASK)) {
+	if (!dma_set_mask(&ha->pdev->dev, DMA_BIT_MASK(64))) {
 		/* Any upper-dword bits set? */
 		if (MSD(dma_get_required_mask(&ha->pdev->dev)) &&
-		    !pci_set_consistent_dma_mask(ha->pdev, DMA_64BIT_MASK)) {
+		    !pci_set_consistent_dma_mask(ha->pdev, DMA_BIT_MASK(64))) {
 			/* Ok, a 64bit DMA mask is applicable. */
 			ha->flags.enable_64bit_addressing = 1;
 			ha->isp_ops->calc_req_entries = qla2x00_calc_iocbs_64;
diff -puN drivers/scsi/qla4xxx/ql4_os.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/scsi/qla4xxx/ql4_os.c
--- a/drivers/scsi/qla4xxx/ql4_os.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/scsi/qla4xxx/ql4_os.c
@@ -1369,8 +1369,8 @@ static void qla4xxx_config_dma_addressin
 	int retval;
 
 	/* Update our PCI device dma_mask for full 64 bit mask */
-	if (pci_set_dma_mask(ha->pdev, DMA_64BIT_MASK) == 0) {
-		if (pci_set_consistent_dma_mask(ha->pdev, DMA_64BIT_MASK)) {
+	if (pci_set_dma_mask(ha->pdev, DMA_BIT_MASK(64)) == 0) {
+		if (pci_set_consistent_dma_mask(ha->pdev, DMA_BIT_MASK(64))) {
 			dev_dbg(&ha->pdev->dev,
 				  "Failed to set 64 bit PCI consistent mask; "
 				   "using 32 bit.\n");
diff -puN drivers/scsi/stex.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/scsi/stex.c
--- a/drivers/scsi/stex.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/scsi/stex.c
@@ -1395,8 +1395,8 @@ static int stex_set_dma_mask(struct pci_
 {
 	int ret;
 
-	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)
-		&& !pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK))
+	if (!pci_set_dma_mask(pdev,  DMA_BIT_MASK(64))
+		&& !pci_set_consistent_dma_mask(pdev,  DMA_BIT_MASK(64)))
 		return 0;
 	ret = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
 	if (!ret)
diff -puN drivers/scsi/sym53c8xx_2/sym_hipd.h~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/scsi/sym53c8xx_2/sym_hipd.h
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.h~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/scsi/sym53c8xx_2/sym_hipd.h
@@ -1094,7 +1094,7 @@ do {									\
 	(data)->size = cpu_to_scr((((badd) >> 8) & 0xff000000) + len);	\
 } while (0)
 #elif SYM_CONF_DMA_ADDRESSING_MODE == 2
-#define DMA_DAC_MASK	DMA_64BIT_MASK
+#define DMA_DAC_MASK	DMA_BIT_MASK(64)
 int sym_lookup_dmap(struct sym_hcb *np, u32 h, int s);
 static inline void
 sym_build_sge(struct sym_hcb *np, struct sym_tblmove *data, u64 badd, int len)
diff -puN drivers/sn/ioc3.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/sn/ioc3.c
--- a/drivers/sn/ioc3.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/sn/ioc3.c
@@ -617,9 +617,9 @@ static int ioc3_probe(struct pci_dev *pd
 	pci_set_master(pdev);
 
 #ifdef USE_64BIT_DMA
-        ret = pci_set_dma_mask(pdev, DMA_64BIT_MASK);
+        ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
         if (!ret) {
-                ret = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
+                ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
                 if (ret < 0) {
                         printk(KERN_WARNING "%s: Unable to obtain 64 bit DMA "
                                "for consistent allocations\n",
diff -puN drivers/staging/altpciechdma/altpciechdma.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/staging/altpciechdma/altpciechdma.c
--- a/drivers/staging/altpciechdma/altpciechdma.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/staging/altpciechdma/altpciechdma.c
@@ -849,8 +849,8 @@ static int __devinit probe(struct pci_de
 #if 1   /* @todo For now, disable 64-bit, because I do not understand the implications (DAC!) */
 	/* query for DMA transfer */
 	/* @see Documentation/PCI/PCI-DMA-mapping.txt */
-	if (!pci_set_dma_mask(dev, DMA_64BIT_MASK)) {
-		pci_set_consistent_dma_mask(dev, DMA_64BIT_MASK);
+	if (!pci_set_dma_mask(dev, DMA_BIT_MASK(64))) {
+		pci_set_consistent_dma_mask(dev, DMA_BIT_MASK(64));
 		/* use 64-bit DMA */
 		printk(KERN_DEBUG "Using a 64-bit DMA mask.\n");
 	} else
diff -puN drivers/staging/slicoss/slicoss.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/staging/slicoss/slicoss.c
--- a/drivers/staging/slicoss/slicoss.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/staging/slicoss/slicoss.c
@@ -371,9 +371,9 @@ static int __devinit slic_entry_probe(st
 		printk(KERN_DEBUG "%s\n", slic_proc_version);
 	}
 
-	err = pci_set_dma_mask(pcidev, DMA_64BIT_MASK);
+	err = pci_set_dma_mask(pcidev, DMA_BIT_MASK(64));
 	if (err) {
-		err = pci_set_dma_mask(pcidev, DMA_32BIT_MASK);
+		err = pci_set_dma_mask(pcidev, DMA_BIT_MASK(32));
 		if (err)
 			goto err_out_disable_pci;
 	}
diff -puN drivers/staging/sxg/sxg.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/staging/sxg/sxg.c
--- a/drivers/staging/sxg/sxg.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/staging/sxg/sxg.c
@@ -934,8 +934,8 @@ static int sxg_entry_probe(struct pci_de
 
 	pci_read_config_byte(pcidev, PCI_REVISION_ID, &revision_id);
 
-	if (!(err = pci_set_dma_mask(pcidev, DMA_64BIT_MASK))) {
-		DBG_ERROR("pci_set_dma_mask(DMA_64BIT_MASK) successful\n");
+	if (!(err = pci_set_dma_mask(pcidev, DMA_BIT_MASK(64)))) {
+		DBG_ERROR("pci_set_dma_mask(DMA_BIT_MASK(64)) successful\n");
 	} else {
 		if ((err = pci_set_dma_mask(pcidev, DMA_32BIT_MASK))) {
 			DBG_ERROR
diff -puN drivers/usb/host/ehci-hcd.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/usb/host/ehci-hcd.c
--- a/drivers/usb/host/ehci-hcd.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/usb/host/ehci-hcd.c
@@ -622,7 +622,7 @@ static int ehci_run (struct usb_hcd *hcd
 		ehci_writel(ehci, 0, &ehci->regs->segment);
 #if 0
 // this is deeply broken on almost all architectures
-		if (!dma_set_mask(hcd->self.controller, DMA_64BIT_MASK))
+		if (!dma_set_mask(hcd->self.controller, DMA_BIT_MASK(64)))
 			ehci_info(ehci, "enabled 64bit DMA\n");
 #endif
 	}
diff -puN drivers/uwb/whci.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64 drivers/uwb/whci.c
--- a/drivers/uwb/whci.c~replace-all-dma_64bit_mask-macro-with-dma_bit_mask64
+++ a/drivers/uwb/whci.c
@@ -160,8 +160,8 @@ static int whci_probe(struct pci_dev *pc
 	pci_enable_msi(pci);
 	pci_set_master(pci);
 	err = -ENXIO;
-	if (!pci_set_dma_mask(pci, DMA_64BIT_MASK))
-		pci_set_consistent_dma_mask(pci, DMA_64BIT_MASK);
+	if (!pci_set_dma_mask(pci, DMA_BIT_MASK(64)))
+		pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(64));
 	else if (!pci_set_dma_mask(pci, DMA_32BIT_MASK))
 		pci_set_consistent_dma_mask(pci, DMA_32BIT_MASK);
 	else
_

Patches currently in -mm which might be from yanghy@cn.fujitsu.com are

origin.patch

