From: akpm@linux-foundation.org
Subject: [merged] sections-fix-section-conflicts-in-drivers-ide.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:12:51 -0700
Message-ID: <20121005201252.1721120004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:60125 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab2JEUMy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:12:54 -0400
Received: by mail-ee0-f74.google.com with SMTP id b57so139447eek.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:12:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     Subject: sections: fix section conflicts in drivers/ide
has been removed from the -mm tree.  Its filename was
     sections-fix-section-conflicts-in-drivers-ide.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: sections: fix section conflicts in drivers/ide

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/aec62xx.c         |    2 +-
 drivers/ide/ali14xx.c         |    4 ++--
 drivers/ide/alim15x3.c        |    2 +-
 drivers/ide/amd74xx.c         |    2 +-
 drivers/ide/atiixp.c          |    2 +-
 drivers/ide/cmd640.c          |    2 +-
 drivers/ide/cmd64x.c          |    2 +-
 drivers/ide/cs5520.c          |    2 +-
 drivers/ide/cs5530.c          |    2 +-
 drivers/ide/cs5535.c          |    2 +-
 drivers/ide/cy82c693.c        |    2 +-
 drivers/ide/dtc2278.c         |    2 +-
 drivers/ide/hpt366.c          |   24 ++++++++++++------------
 drivers/ide/ht6560b.c         |    2 +-
 drivers/ide/icside.c          |    2 +-
 drivers/ide/ide-pci-generic.c |    2 +-
 drivers/ide/it8172.c          |    2 +-
 drivers/ide/it8213.c          |    2 +-
 drivers/ide/it821x.c          |    2 +-
 drivers/ide/jmicron.c         |    2 +-
 drivers/ide/ns87415.c         |    2 +-
 drivers/ide/opti621.c         |    2 +-
 drivers/ide/pdc202xx_new.c    |    2 +-
 drivers/ide/pdc202xx_old.c    |    2 +-
 drivers/ide/piix.c            |    2 +-
 drivers/ide/qd65xx.c          |    2 +-
 drivers/ide/rz1000.c          |    2 +-
 drivers/ide/sc1200.c          |    2 +-
 drivers/ide/scc_pata.c        |    2 +-
 drivers/ide/serverworks.c     |    2 +-
 drivers/ide/siimage.c         |    2 +-
 drivers/ide/sis5513.c         |    2 +-
 drivers/ide/sl82c105.c        |    2 +-
 drivers/ide/slc90e66.c        |    2 +-
 drivers/ide/tc86c001.c        |    2 +-
 drivers/ide/triflex.c         |    2 +-
 drivers/ide/trm290.c          |    2 +-
 drivers/ide/tx4938ide.c       |    2 +-
 drivers/ide/tx4939ide.c       |    2 +-
 drivers/ide/umc8672.c         |    2 +-
 drivers/ide/via82cxxx.c       |    2 +-
 41 files changed, 53 insertions(+), 53 deletions(-)

diff -puN drivers/ide/aec62xx.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/aec62xx.c
--- a/drivers/ide/aec62xx.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/aec62xx.c
@@ -181,7 +181,7 @@ static const struct ide_port_ops atp86x_
 	.cable_detect		= atp86x_cable_detect,
 };
 
-static const struct ide_port_info aec62xx_chipsets[] __devinitdata = {
+static const struct ide_port_info aec62xx_chipsets[] __devinitconst = {
 	{	/* 0: AEC6210 */
 		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_aec62xx,
diff -puN drivers/ide/ali14xx.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/ali14xx.c
--- a/drivers/ide/ali14xx.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/ali14xx.c
@@ -52,13 +52,13 @@
 
 /* port addresses for auto-detection */
 #define ALI_NUM_PORTS 4
-static const int ports[ALI_NUM_PORTS] __initdata =
+static const int ports[ALI_NUM_PORTS] __initconst =
 	{ 0x074, 0x0f4, 0x034, 0x0e4 };
 
 /* register initialization data */
 typedef struct { u8 reg, data; } RegInitializer;
 
-static const RegInitializer initData[] __initdata = {
+static const RegInitializer initData[] __initconst = {
 	{0x01, 0x0f}, {0x02, 0x00}, {0x03, 0x00}, {0x04, 0x00},
 	{0x05, 0x00}, {0x06, 0x00}, {0x07, 0x2b}, {0x0a, 0x0f},
 	{0x25, 0x00}, {0x26, 0x00}, {0x27, 0x00}, {0x28, 0x00},
diff -puN drivers/ide/alim15x3.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/alim15x3.c
--- a/drivers/ide/alim15x3.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/alim15x3.c
@@ -512,7 +512,7 @@ static const struct ide_dma_ops ali_dma_
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
-static const struct ide_port_info ali15x3_chipset __devinitdata = {
+static const struct ide_port_info ali15x3_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.init_chipset	= init_chipset_ali15x3,
 	.init_hwif	= init_hwif_ali15x3,
diff -puN drivers/ide/amd74xx.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/amd74xx.c
--- a/drivers/ide/amd74xx.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/amd74xx.c
@@ -223,7 +223,7 @@ static const struct ide_port_ops amd_por
 		.udma_mask	= udma,					\
 	}
 
-static const struct ide_port_info amd74xx_chipsets[] __devinitdata = {
+static const struct ide_port_info amd74xx_chipsets[] __devinitconst = {
 	/* 0: AMD7401 */	DECLARE_AMD_DEV(0x00, ATA_UDMA2),
 	/* 1: AMD7409 */	DECLARE_AMD_DEV(ATA_SWDMA2, ATA_UDMA4),
 	/* 2: AMD7411/7441 */	DECLARE_AMD_DEV(ATA_SWDMA2, ATA_UDMA5),
diff -puN drivers/ide/atiixp.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/atiixp.c
--- a/drivers/ide/atiixp.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/atiixp.c
@@ -139,7 +139,7 @@ static const struct ide_port_ops atiixp_
 	.cable_detect		= atiixp_cable_detect,
 };
 
-static const struct ide_port_info atiixp_pci_info[] __devinitdata = {
+static const struct ide_port_info atiixp_pci_info[] __devinitconst = {
 	{	/* 0: IXP200/300/400/700 */
 		.name		= DRV_NAME,
 		.enablebits	= {{0x48,0x01,0x00}, {0x48,0x08,0x00}},
diff -puN drivers/ide/cmd640.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/cmd640.c
--- a/drivers/ide/cmd640.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/cmd640.c
@@ -685,7 +685,7 @@ static int pci_conf2(void)
 	return 0;
 }
 
-static const struct ide_port_info cmd640_port_info __initdata = {
+static const struct ide_port_info cmd640_port_info __initconst = {
 	.chipset		= ide_cmd640,
 	.host_flags		= IDE_HFLAG_SERIALIZE |
 				  IDE_HFLAG_NO_DMA |
diff -puN drivers/ide/cmd64x.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/cmd64x.c
--- a/drivers/ide/cmd64x.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/cmd64x.c
@@ -327,7 +327,7 @@ static const struct ide_dma_ops cmd646_r
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
-static const struct ide_port_info cmd64x_chipsets[] __devinitdata = {
+static const struct ide_port_info cmd64x_chipsets[] __devinitconst = {
 	{	/* 0: CMD643 */
 		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_cmd64x,
diff -puN drivers/ide/cs5520.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/cs5520.c
--- a/drivers/ide/cs5520.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/cs5520.c
@@ -94,7 +94,7 @@ static const struct ide_port_ops cs5520_
 	.set_dma_mode		= cs5520_set_dma_mode,
 };
 
-static const struct ide_port_info cyrix_chipset __devinitdata = {
+static const struct ide_port_info cyrix_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.enablebits	= { { 0x60, 0x01, 0x01 }, { 0x60, 0x02, 0x02 } },
 	.port_ops	= &cs5520_port_ops,
diff -puN drivers/ide/cs5530.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/cs5530.c
--- a/drivers/ide/cs5530.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/cs5530.c
@@ -245,7 +245,7 @@ static const struct ide_port_ops cs5530_
 	.udma_filter		= cs5530_udma_filter,
 };
 
-static const struct ide_port_info cs5530_chipset __devinitdata = {
+static const struct ide_port_info cs5530_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.init_chipset	= init_chipset_cs5530,
 	.init_hwif	= init_hwif_cs5530,
diff -puN drivers/ide/cs5535.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/cs5535.c
--- a/drivers/ide/cs5535.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/cs5535.c
@@ -170,7 +170,7 @@ static const struct ide_port_ops cs5535_
 	.cable_detect		= cs5535_cable_detect,
 };
 
-static const struct ide_port_info cs5535_chipset __devinitdata = {
+static const struct ide_port_info cs5535_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.port_ops	= &cs5535_port_ops,
 	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_POST_SET_MODE,
diff -puN drivers/ide/cy82c693.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/cy82c693.c
--- a/drivers/ide/cy82c693.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/cy82c693.c
@@ -163,7 +163,7 @@ static const struct ide_port_ops cy82c69
 	.set_dma_mode		= cy82c693_set_dma_mode,
 };
 
-static const struct ide_port_info cy82c693_chipset __devinitdata = {
+static const struct ide_port_info cy82c693_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.init_iops	= init_iops_cy82c693,
 	.port_ops	= &cy82c693_port_ops,
diff -puN drivers/ide/dtc2278.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/dtc2278.c
--- a/drivers/ide/dtc2278.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/dtc2278.c
@@ -91,7 +91,7 @@ static const struct ide_port_ops dtc2278
 	.set_pio_mode		= dtc2278_set_pio_mode,
 };
 
-static const struct ide_port_info dtc2278_port_info __initdata = {
+static const struct ide_port_info dtc2278_port_info __initconst = {
 	.name			= DRV_NAME,
 	.chipset		= ide_dtc2278,
 	.port_ops		= &dtc2278_port_ops,
diff -puN drivers/ide/hpt366.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/hpt366.c
--- a/drivers/ide/hpt366.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/hpt366.c
@@ -443,7 +443,7 @@ static struct hpt_timings hpt37x_timings
 	}
 };
 
-static const struct hpt_info hpt36x __devinitdata = {
+static const struct hpt_info hpt36x __devinitconst = {
 	.chip_name	= "HPT36x",
 	.chip_type	= HPT36x,
 	.udma_mask	= HPT366_ALLOW_ATA66_3 ? (HPT366_ALLOW_ATA66_4 ? ATA_UDMA4 : ATA_UDMA3) : ATA_UDMA2,
@@ -451,7 +451,7 @@ static const struct hpt_info hpt36x __de
 	.timings	= &hpt36x_timings
 };
 
-static const struct hpt_info hpt370 __devinitdata = {
+static const struct hpt_info hpt370 __devinitconst = {
 	.chip_name	= "HPT370",
 	.chip_type	= HPT370,
 	.udma_mask	= HPT370_ALLOW_ATA100_5 ? ATA_UDMA5 : ATA_UDMA4,
@@ -459,7 +459,7 @@ static const struct hpt_info hpt370 __de
 	.timings	= &hpt37x_timings
 };
 
-static const struct hpt_info hpt370a __devinitdata = {
+static const struct hpt_info hpt370a __devinitconst = {
 	.chip_name	= "HPT370A",
 	.chip_type	= HPT370A,
 	.udma_mask	= HPT370_ALLOW_ATA100_5 ? ATA_UDMA5 : ATA_UDMA4,
@@ -467,7 +467,7 @@ static const struct hpt_info hpt370a __d
 	.timings	= &hpt37x_timings
 };
 
-static const struct hpt_info hpt374 __devinitdata = {
+static const struct hpt_info hpt374 __devinitconst = {
 	.chip_name	= "HPT374",
 	.chip_type	= HPT374,
 	.udma_mask	= ATA_UDMA5,
@@ -475,7 +475,7 @@ static const struct hpt_info hpt374 __de
 	.timings	= &hpt37x_timings
 };
 
-static const struct hpt_info hpt372 __devinitdata = {
+static const struct hpt_info hpt372 __devinitconst = {
 	.chip_name	= "HPT372",
 	.chip_type	= HPT372,
 	.udma_mask	= HPT372_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -483,7 +483,7 @@ static const struct hpt_info hpt372 __de
 	.timings	= &hpt37x_timings
 };
 
-static const struct hpt_info hpt372a __devinitdata = {
+static const struct hpt_info hpt372a __devinitconst = {
 	.chip_name	= "HPT372A",
 	.chip_type	= HPT372A,
 	.udma_mask	= HPT372_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -491,7 +491,7 @@ static const struct hpt_info hpt372a __d
 	.timings	= &hpt37x_timings
 };
 
-static const struct hpt_info hpt302 __devinitdata = {
+static const struct hpt_info hpt302 __devinitconst = {
 	.chip_name	= "HPT302",
 	.chip_type	= HPT302,
 	.udma_mask	= HPT302_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -499,7 +499,7 @@ static const struct hpt_info hpt302 __de
 	.timings	= &hpt37x_timings
 };
 
-static const struct hpt_info hpt371 __devinitdata = {
+static const struct hpt_info hpt371 __devinitconst = {
 	.chip_name	= "HPT371",
 	.chip_type	= HPT371,
 	.udma_mask	= HPT371_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -507,7 +507,7 @@ static const struct hpt_info hpt371 __de
 	.timings	= &hpt37x_timings
 };
 
-static const struct hpt_info hpt372n __devinitdata = {
+static const struct hpt_info hpt372n __devinitconst = {
 	.chip_name	= "HPT372N",
 	.chip_type	= HPT372N,
 	.udma_mask	= HPT372_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -515,7 +515,7 @@ static const struct hpt_info hpt372n __d
 	.timings	= &hpt37x_timings
 };
 
-static const struct hpt_info hpt302n __devinitdata = {
+static const struct hpt_info hpt302n __devinitconst = {
 	.chip_name	= "HPT302N",
 	.chip_type	= HPT302N,
 	.udma_mask	= HPT302_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -523,7 +523,7 @@ static const struct hpt_info hpt302n __d
 	.timings	= &hpt37x_timings
 };
 
-static const struct hpt_info hpt371n __devinitdata = {
+static const struct hpt_info hpt371n __devinitconst = {
 	.chip_name	= "HPT371N",
 	.chip_type	= HPT371N,
 	.udma_mask	= HPT371_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -1361,7 +1361,7 @@ static const struct ide_dma_ops hpt36x_d
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
-static const struct ide_port_info hpt366_chipsets[] __devinitdata = {
+static const struct ide_port_info hpt366_chipsets[] __devinitconst = {
 	{	/* 0: HPT36x */
 		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_hpt366,
diff -puN drivers/ide/ht6560b.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/ht6560b.c
--- a/drivers/ide/ht6560b.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/ht6560b.c
@@ -341,7 +341,7 @@ static const struct ide_port_ops ht6560b
 	.set_pio_mode		= ht6560b_set_pio_mode,
 };
 
-static const struct ide_port_info ht6560b_port_info __initdata = {
+static const struct ide_port_info ht6560b_port_info __initconst = {
 	.name			= DRV_NAME,
 	.chipset		= ide_ht6560b,
 	.tp_ops 		= &ht6560b_tp_ops,
diff -puN drivers/ide/icside.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/icside.c
--- a/drivers/ide/icside.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/icside.c
@@ -451,7 +451,7 @@ err_free:
 	return ret;
 }
 
-static const struct ide_port_info icside_v6_port_info __initdata = {
+static const struct ide_port_info icside_v6_port_info __initconst = {
 	.init_dma		= icside_dma_off_init,
 	.port_ops		= &icside_v6_no_dma_port_ops,
 	.host_flags		= IDE_HFLAG_SERIALIZE | IDE_HFLAG_MMIO,
diff -puN drivers/ide/ide-pci-generic.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/ide-pci-generic.c
--- a/drivers/ide/ide-pci-generic.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/ide-pci-generic.c
@@ -53,7 +53,7 @@ static const struct ide_port_ops netcell
 		.udma_mask	= ATA_UDMA6, \
 	}
 
-static const struct ide_port_info generic_chipsets[] __devinitdata = {
+static const struct ide_port_info generic_chipsets[] __devinitconst = {
 	/*  0: Unknown */
 	DECLARE_GENERIC_PCI_DEV(0),
 
diff -puN drivers/ide/it8172.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/it8172.c
--- a/drivers/ide/it8172.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/it8172.c
@@ -115,7 +115,7 @@ static const struct ide_port_ops it8172_
 	.set_dma_mode	= it8172_set_dma_mode,
 };
 
-static const struct ide_port_info it8172_port_info __devinitdata = {
+static const struct ide_port_info it8172_port_info __devinitconst = {
 	.name		= DRV_NAME,
 	.port_ops	= &it8172_port_ops,
 	.enablebits	= { {0x41, 0x80, 0x80}, {0x00, 0x00, 0x00} },
diff -puN drivers/ide/it8213.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/it8213.c
--- a/drivers/ide/it8213.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/it8213.c
@@ -156,7 +156,7 @@ static const struct ide_port_ops it8213_
 	.cable_detect		= it8213_cable_detect,
 };
 
-static const struct ide_port_info it8213_chipset __devinitdata = {
+static const struct ide_port_info it8213_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.enablebits	= { {0x41, 0x80, 0x80} },
 	.port_ops	= &it8213_port_ops,
diff -puN drivers/ide/it821x.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/it821x.c
--- a/drivers/ide/it821x.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/it821x.c
@@ -630,7 +630,7 @@ static const struct ide_port_ops it821x_
 	.cable_detect		= it821x_cable_detect,
 };
 
-static const struct ide_port_info it821x_chipset __devinitdata = {
+static const struct ide_port_info it821x_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.init_chipset	= init_chipset_it821x,
 	.init_hwif	= init_hwif_it821x,
diff -puN drivers/ide/jmicron.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/jmicron.c
--- a/drivers/ide/jmicron.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/jmicron.c
@@ -102,7 +102,7 @@ static const struct ide_port_ops jmicron
 	.cable_detect		= jmicron_cable_detect,
 };
 
-static const struct ide_port_info jmicron_chipset __devinitdata = {
+static const struct ide_port_info jmicron_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.enablebits	= { { 0x40, 0x01, 0x01 }, { 0x40, 0x10, 0x10 } },
 	.port_ops	= &jmicron_port_ops,
diff -puN drivers/ide/ns87415.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/ns87415.c
--- a/drivers/ide/ns87415.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/ns87415.c
@@ -293,7 +293,7 @@ static const struct ide_dma_ops ns87415_
 	.dma_sff_read_status	= superio_dma_sff_read_status,
 };
 
-static const struct ide_port_info ns87415_chipset __devinitdata = {
+static const struct ide_port_info ns87415_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.init_hwif	= init_hwif_ns87415,
 	.tp_ops 	= &ns87415_tp_ops,
diff -puN drivers/ide/opti621.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/opti621.c
--- a/drivers/ide/opti621.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/opti621.c
@@ -131,7 +131,7 @@ static const struct ide_port_ops opti621
 	.set_pio_mode		= opti621_set_pio_mode,
 };
 
-static const struct ide_port_info opti621_chipset __devinitdata = {
+static const struct ide_port_info opti621_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.enablebits	= { {0x45, 0x80, 0x00}, {0x40, 0x08, 0x00} },
 	.port_ops	= &opti621_port_ops,
diff -puN drivers/ide/pdc202xx_new.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/pdc202xx_new.c
--- a/drivers/ide/pdc202xx_new.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/pdc202xx_new.c
@@ -465,7 +465,7 @@ static const struct ide_port_ops pdcnew_
 		.udma_mask	= udma, \
 	}
 
-static const struct ide_port_info pdcnew_chipsets[] __devinitdata = {
+static const struct ide_port_info pdcnew_chipsets[] __devinitconst = {
 	/* 0: PDC202{68,70} */		DECLARE_PDCNEW_DEV(ATA_UDMA5),
 	/* 1: PDC202{69,71,75,76,77} */	DECLARE_PDCNEW_DEV(ATA_UDMA6),
 };
diff -puN drivers/ide/pdc202xx_old.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/pdc202xx_old.c
--- a/drivers/ide/pdc202xx_old.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/pdc202xx_old.c
@@ -270,7 +270,7 @@ static const struct ide_dma_ops pdc2026x
 		.max_sectors	= sectors, \
 	}
 
-static const struct ide_port_info pdc202xx_chipsets[] __devinitdata = {
+static const struct ide_port_info pdc202xx_chipsets[] __devinitconst = {
 	{	/* 0: PDC20246 */
 		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_pdc202xx,
diff -puN drivers/ide/piix.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/piix.c
--- a/drivers/ide/piix.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/piix.c
@@ -344,7 +344,7 @@ static const struct ide_port_ops ich_por
 		.udma_mask	= udma, \
 	}
 
-static const struct ide_port_info piix_pci_info[] __devinitdata = {
+static const struct ide_port_info piix_pci_info[] __devinitconst = {
 	/* 0: MPIIX */
 	{	/*
 		 * MPIIX actually has only a single IDE channel mapped to
diff -puN drivers/ide/qd65xx.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/qd65xx.c
--- a/drivers/ide/qd65xx.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/qd65xx.c
@@ -335,7 +335,7 @@ static const struct ide_port_ops qd6580_
 	.set_pio_mode		= qd6580_set_pio_mode,
 };
 
-static const struct ide_port_info qd65xx_port_info __initdata = {
+static const struct ide_port_info qd65xx_port_info __initconst = {
 	.name			= DRV_NAME,
 	.tp_ops 		= &qd65xx_tp_ops,
 	.chipset		= ide_qd65xx,
diff -puN drivers/ide/rz1000.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/rz1000.c
--- a/drivers/ide/rz1000.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/rz1000.c
@@ -38,7 +38,7 @@ static int __devinit rz1000_disable_read
 	}
 }
 
-static const struct ide_port_info rz1000_chipset __devinitdata = {
+static const struct ide_port_info rz1000_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.host_flags	= IDE_HFLAG_NO_DMA,
 };
diff -puN drivers/ide/sc1200.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/sc1200.c
--- a/drivers/ide/sc1200.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/sc1200.c
@@ -291,7 +291,7 @@ static const struct ide_dma_ops sc1200_d
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
-static const struct ide_port_info sc1200_chipset __devinitdata = {
+static const struct ide_port_info sc1200_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.port_ops	= &sc1200_port_ops,
 	.dma_ops	= &sc1200_dma_ops,
diff -puN drivers/ide/scc_pata.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/scc_pata.c
--- a/drivers/ide/scc_pata.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/scc_pata.c
@@ -811,7 +811,7 @@ static const struct ide_dma_ops scc_dma_
 	.dma_sff_read_status	= scc_dma_sff_read_status,
 };
 
-static const struct ide_port_info scc_chipset __devinitdata = {
+static const struct ide_port_info scc_chipset __devinitconst = {
 	.name		= "sccIDE",
 	.init_iops	= init_iops_scc,
 	.init_dma	= scc_init_dma,
diff -puN drivers/ide/serverworks.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/serverworks.c
--- a/drivers/ide/serverworks.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/serverworks.c
@@ -337,7 +337,7 @@ static const struct ide_port_ops svwks_p
 	.cable_detect		= svwks_cable_detect,
 };
 
-static const struct ide_port_info serverworks_chipsets[] __devinitdata = {
+static const struct ide_port_info serverworks_chipsets[] __devinitconst = {
 	{	/* 0: OSB4 */
 		.name		= DRV_NAME,
 		.init_chipset	= init_chipset_svwks,
diff -puN drivers/ide/siimage.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/siimage.c
--- a/drivers/ide/siimage.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/siimage.c
@@ -719,7 +719,7 @@ static const struct ide_dma_ops sil_dma_
 		.udma_mask	= ATA_UDMA6,		\
 	}
 
-static const struct ide_port_info siimage_chipsets[] __devinitdata = {
+static const struct ide_port_info siimage_chipsets[] __devinitconst = {
 	/* 0: SiI680 */  DECLARE_SII_DEV(&sil_pata_port_ops),
 	/* 1: SiI3112 */ DECLARE_SII_DEV(&sil_sata_port_ops)
 };
diff -puN drivers/ide/sis5513.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/sis5513.c
--- a/drivers/ide/sis5513.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/sis5513.c
@@ -563,7 +563,7 @@ static const struct ide_port_ops sis_ata
 	.cable_detect		= sis_cable_detect,
 };
 
-static const struct ide_port_info sis5513_chipset __devinitdata = {
+static const struct ide_port_info sis5513_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.init_chipset	= init_chipset_sis5513,
 	.enablebits	= { {0x4a, 0x02, 0x02}, {0x4a, 0x04, 0x04} },
diff -puN drivers/ide/sl82c105.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/sl82c105.c
--- a/drivers/ide/sl82c105.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/sl82c105.c
@@ -299,7 +299,7 @@ static const struct ide_dma_ops sl82c105
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
-static const struct ide_port_info sl82c105_chipset __devinitdata = {
+static const struct ide_port_info sl82c105_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.init_chipset	= init_chipset_sl82c105,
 	.enablebits	= {{0x40,0x01,0x01}, {0x40,0x10,0x10}},
diff -puN drivers/ide/slc90e66.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/slc90e66.c
--- a/drivers/ide/slc90e66.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/slc90e66.c
@@ -132,7 +132,7 @@ static const struct ide_port_ops slc90e6
 	.cable_detect		= slc90e66_cable_detect,
 };
 
-static const struct ide_port_info slc90e66_chipset __devinitdata = {
+static const struct ide_port_info slc90e66_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.enablebits	= { {0x41, 0x80, 0x80}, {0x43, 0x80, 0x80} },
 	.port_ops	= &slc90e66_port_ops,
diff -puN drivers/ide/tc86c001.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/tc86c001.c
--- a/drivers/ide/tc86c001.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/tc86c001.c
@@ -192,7 +192,7 @@ static const struct ide_dma_ops tc86c001
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
-static const struct ide_port_info tc86c001_chipset __devinitdata = {
+static const struct ide_port_info tc86c001_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.init_hwif	= init_hwif_tc86c001,
 	.port_ops	= &tc86c001_port_ops,
diff -puN drivers/ide/triflex.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/triflex.c
--- a/drivers/ide/triflex.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/triflex.c
@@ -92,7 +92,7 @@ static const struct ide_port_ops triflex
 	.set_dma_mode		= triflex_set_mode,
 };
 
-static const struct ide_port_info triflex_device __devinitdata = {
+static const struct ide_port_info triflex_device __devinitconst = {
 	.name		= DRV_NAME,
 	.enablebits	= {{0x80, 0x01, 0x01}, {0x80, 0x02, 0x02}},
 	.port_ops	= &triflex_port_ops,
diff -puN drivers/ide/trm290.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/trm290.c
--- a/drivers/ide/trm290.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/trm290.c
@@ -324,7 +324,7 @@ static struct ide_dma_ops trm290_dma_ops
 	.dma_check		= trm290_dma_check,
 };
 
-static const struct ide_port_info trm290_chipset __devinitdata = {
+static const struct ide_port_info trm290_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.init_hwif	= init_hwif_trm290,
 	.tp_ops 	= &trm290_tp_ops,
diff -puN drivers/ide/tx4938ide.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/tx4938ide.c
--- a/drivers/ide/tx4938ide.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/tx4938ide.c
@@ -117,7 +117,7 @@ static const struct ide_port_ops tx4938i
 	.set_pio_mode		= tx4938ide_set_pio_mode,
 };
 
-static const struct ide_port_info tx4938ide_port_info __initdata = {
+static const struct ide_port_info tx4938ide_port_info __initconst = {
 	.port_ops		= &tx4938ide_port_ops,
 #ifdef __BIG_ENDIAN
 	.tp_ops			= &tx4938ide_tp_ops,
diff -puN drivers/ide/tx4939ide.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/tx4939ide.c
--- a/drivers/ide/tx4939ide.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/tx4939ide.c
@@ -522,7 +522,7 @@ static const struct ide_dma_ops tx4939id
 	.dma_sff_read_status	= tx4939ide_dma_sff_read_status,
 };
 
-static const struct ide_port_info tx4939ide_port_info __initdata = {
+static const struct ide_port_info tx4939ide_port_info __initconst = {
 	.init_hwif		= tx4939ide_init_hwif,
 	.init_dma		= tx4939ide_init_dma,
 	.port_ops		= &tx4939ide_port_ops,
diff -puN drivers/ide/umc8672.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/umc8672.c
--- a/drivers/ide/umc8672.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/umc8672.c
@@ -128,7 +128,7 @@ static const struct ide_port_ops umc8672
 	.set_pio_mode		= umc_set_pio_mode,
 };
 
-static const struct ide_port_info umc8672_port_info __initdata = {
+static const struct ide_port_info umc8672_port_info __initconst = {
 	.name			= DRV_NAME,
 	.chipset		= ide_umc8672,
 	.port_ops		= &umc8672_port_ops,
diff -puN drivers/ide/via82cxxx.c~sections-fix-section-conflicts-in-drivers-ide drivers/ide/via82cxxx.c
--- a/drivers/ide/via82cxxx.c~sections-fix-section-conflicts-in-drivers-ide
+++ a/drivers/ide/via82cxxx.c
@@ -403,7 +403,7 @@ static const struct ide_port_ops via_por
 	.cable_detect		= via82cxxx_cable_detect,
 };
 
-static const struct ide_port_info via82cxxx_chipset __devinitdata = {
+static const struct ide_port_info via82cxxx_chipset __devinitconst = {
 	.name		= DRV_NAME,
 	.init_chipset	= init_chipset_via82cxxx,
 	.enablebits	= { { 0x40, 0x02, 0x02 }, { 0x40, 0x01, 0x01 } },
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch

