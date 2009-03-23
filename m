From: akpm@linux-foundation.org
Subject: [to-be-updated] via-sdmmc-via-msp-card-reader-driver-support.patch removed from -mm tree
Date: Sun, 22 Mar 2009 17:29:28 -0700
Message-ID: <200903230033.n2N0Xkeb028092@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754316AbZCWAhr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 22 Mar 2009 20:37:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josephchan@via.com.tw, arnd@arndb.de, ben-linux@fluff.org, drzeus-mmc@drzeus.cx, mm-commits@vger.kernel.org


The patch titled
     via-sdmmc: VIA MSP card reader driver support
has been removed from the -mm tree.  Its filename was
     via-sdmmc-via-msp-card-reader-driver-support.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: via-sdmmc: VIA MSP card reader driver support
From: Joseph Chan <josephchan@via.com.tw>

Provide VIA MSP SD/MMC card reader driver support.  Special thanks for
Arnd's suggestions and help.

Signed-off-by: Joseph Chan <josephchan@via.com.tw>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/Kconfig     |   12 
 drivers/mmc/host/Makefile    |    1 
 drivers/mmc/host/via-sdmmc.c | 1346 +++++++++++++++++++++++++++++++++
 3 files changed, 1359 insertions(+)

diff -puN drivers/mmc/host/Kconfig~via-sdmmc-via-msp-card-reader-driver-support drivers/mmc/host/Kconfig
--- a/drivers/mmc/host/Kconfig~via-sdmmc-via-msp-card-reader-driver-support
+++ a/drivers/mmc/host/Kconfig
@@ -212,3 +212,15 @@ config MMC_TMIO
 	help
 	  This provides support for the SD/MMC cell found in TC6393XB,
 	  T7L66XB and also ipaq ASIC3
+
+config MMC_VIA_SDMMC
+	tristate "VIA SD/MMC Card Reader driver"
+	depends on PCI && EXPERIMENTAL
+	help
+	  This selects the VIA SD/MMC Card Reader driver, say Y or M here.
+	  VIA provides one multi-functional card reader which integrated into
+	  some motherboards manufactured by VIA. This card reader supports
+	  SD/MMC/SDHC.
+	  If you have a controller with this interface, say Y or M here.
+
+	  If unsure, say N.
diff -puN drivers/mmc/host/Makefile~via-sdmmc-via-msp-card-reader-driver-support drivers/mmc/host/Makefile
--- a/drivers/mmc/host/Makefile~via-sdmmc-via-msp-card-reader-driver-support
+++ a/drivers/mmc/host/Makefile
@@ -27,4 +27,5 @@ endif
 obj-$(CONFIG_MMC_S3C)   	+= s3cmci.o
 obj-$(CONFIG_MMC_SDRICOH_CS)	+= sdricoh_cs.o
 obj-$(CONFIG_MMC_TMIO)		+= tmio_mmc.o
+obj-$(CONFIG_MMC_VIA_SDMMC)	+= via-sdmmc.o
 
diff -puN /dev/null drivers/mmc/host/via-sdmmc.c
--- /dev/null
+++ a/drivers/mmc/host/via-sdmmc.c
@@ -0,0 +1,1346 @@
+/*
+ *  drivers/mmc/host/via-sdmmc.c - VIA SD/MMC Card Reader driver
+ *  Copyright (c) 2008, VIA Technologies Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or (at
+ * your option) any later version.
+ */
+
+#include <linux/pci.h>
+#include <linux/dma-mapping.h>
+#include <linux/highmem.h>
+#include <linux/delay.h>
+#include <linux/mmc/card.h>
+#include <linux/mmc/mmc.h>
+#include <linux/mmc/sd.h>
+#include <linux/mmc/host.h>
+
+#define DEV_NULL	0
+#define DEV_SDC		1
+#define DEV_CEATA	2
+#define DEV_MSC		4
+#define DEV_XDC		8
+
+#define NFC_OFFSET	0x0
+#define MSC_OFFSET	0x100
+#define SDC_OFFSET	0x200
+#define CEA_OFFSET	0x300
+#define DDMA_OFFSET	0x400
+#define CICH_OFFSET	0x500
+#define PCICTRL_OFFSET	0x600
+
+enum DMA_DIRECTION {
+	CARD_TO_MEM,
+	MEM_TO_CARD
+};
+
+enum PCI_HOST_CLK_CONTROL {
+	PCI_CLK_375K = 0x03,
+	PCI_CLK_8M  = 0x04,
+	PCI_CLK_12M = 0x00,
+	PCI_CLK_16M = 0x05,
+	PCI_CLK_24M = 0x01,
+	PCI_CLK_33M = 0x06,
+	PCI_CLK_48M = 0x02
+};
+
+/*
+ * PCI registers
+ */
+
+#define PCI_WORK_MODE		0x40
+#define PCI_DEBUG_MODE		0x41
+
+/*
+ * SDC MMIO Registers
+ */
+
+#define SDCONTROL_REG		0x0
+#define SDCMDARG_REG		0x4
+
+#define SDBUSMODE_REG		0x8
+#define SD_MODE_SPI		0x01
+#define SD_MODE_4BIT		0x02
+#define SD_MODE_RW		0x04
+#define SD_MODE_SPICRC		0x08
+#define SD_MODE_CST		0x10
+#define SD_MODE_SPICS		0x20
+#define SD_MODE_SDPWR		0x40
+#define SD_MODE_SFTRST		0x80
+
+#define SDBLKLEN_REG		0xc
+#define SD_BLKLEN_CRCSTP	0x0800
+#define SD_BLKLEN_DETPOL	0x1000
+#define SD_BLKLEN_GPIDET	0x2000
+#define SD_BLKLEN_DT3DET	0x4000
+#define SD_BLKLEN_INTEN		0x8000
+
+#define SDRESP0_REG		0x10
+#define SDRESP1_REG		0x14
+#define SDRESP2_REG		0x18
+#define SDRESP3_REG		0x1c
+#define SDCURBLKCNT_REG		0x20
+
+#define SDINTMASK_REG		0x24
+#define SD_INTMASK_BDIE		0x10
+#define SD_INTMASK_DDIE		0x20
+#define SD_INTMASK_CDIE		0x40
+#define SD_INTMASK_SIIE		0x80
+#define SD_INTMASK_IOIE		0x100
+#define SD_INTMASK_CRIE		0x200
+#define SD_INTMASK_RAIE		0x400
+#define SD_INTMASK_PDIE		0x800
+#define SD_INTMASK_DTIE		0x1000
+#define SD_INTMASK_SCIE		0x2000
+#define SD_INTMASK_RCIE		0x4000
+#define SD_INTMASK_WCIE		0x8000
+#define SD_ACTIVE_INTMASK \
+	(SD_INTMASK_BDIE | SD_INTMASK_SIIE | SD_INTMASK_CRIE \
+	| SD_INTMASK_RAIE | SD_INTMASK_DTIE | SD_INTMASK_SCIE \
+	| SD_INTMASK_RCIE | SD_INTMASK_WCIE)
+
+#define SDSTATUS_REG		0x28
+#define SD_STS_CECC		0x01
+#define SD_STS_WP		0x02
+#define SD_STS_SLOTD		0x04
+#define SD_STS_SLOTG		0x08
+#define SD_STS_BD		0x10
+#define SD_STS_DD		0x20
+#define SD_STS_CD		0x40
+#define SD_STS_SI		0x80
+#define SD_STS_IO		0x100
+#define SD_STS_CR		0x200
+#define SD_STS_RA		0x400
+#define SD_STS_PD		0x800
+#define SD_STS_DT		0x1000
+#define SD_STS_SC		0x2000
+#define SD_STS_RC		0x4000
+#define SD_STS_WC		0x8000
+#define SD_STS_IGN_MASK\
+	(SD_STS_DD | SD_STS_PD | SD_STS_IO)
+#define SD_STS_INT_MASK \
+	(SD_STS_BD | SD_STS_DD | SD_STS_CD | SD_STS_SI \
+	| SD_STS_IO | SD_STS_CR | SD_STS_RA | SD_STS_PD \
+	| SD_STS_DT | SD_STS_SC | SD_STS_RC | SD_STS_WC)
+#define SD_STS_W1C_MASK \
+	(SD_STS_CECC | SD_STS_BD | SD_STS_DD | SD_STS_CD \
+	| SD_STS_SI | SD_STS_CR  | SD_STS_RA | SD_STS_PD \
+	| SD_STS_DT | SD_STS_SC | SD_STS_RC | SD_STS_WC)
+#define  SD_STS_CMD_MASK \
+	(SD_STS_CR | SD_STS_RA | SD_STS_SC)
+#define  SD_STS_DATA_MASK\
+	(SD_STS_BD | SD_STS_DT | SD_STS_RC | SD_STS_WC)
+
+#define SDSTATUS_REG2		0x2a
+#define SD_STS_DB		0x20
+#define SD_STS_CFE		0x80
+
+#define SDRSPTMO_REG		0x2C
+
+#define SDCLKSEL_REG		0x30
+#define SD_CLKSEL_375k		0x00
+#define SD_CLKSEL_10M		0x01
+#define SD_CLKSEL_12M		0x02
+#define SD_CLKSEL_15M		0x03
+#define SD_CLKSEL_20M		0x04
+#define SD_CLKSEL_24M		0x05
+#define SD_CLKSEL_30M		0x06
+#define SD_CLKSEL_40M		0x07
+
+#define SDEXTCTRL_REG		0x34
+#define SD_EXTCTRL_AUTO		0x01
+#define SD_EXTCTRL_8BIT		0x04
+/* 0x38-0xFF reserved */
+
+/*
+ * Data DMA Control Registers
+ */
+
+#define DDMABASEADD_REG		0x0
+#define DDMACOUNTER_REG		0x4
+
+#define DDMACONTROL_REG		0x8
+#define DDMA_CONTROL_RDDIR	0x100
+#define DDMA_CONTROL_DATA16	0x200
+#define DDMA_CONTROL_EFMODE	0x400
+#define DDMA_CONTROL_RDENIRQ	0x10000
+#define DDMA_CONTROL_SOFTRESET	0x1000000
+
+#define DDMASTATUS_REG		0xc
+#define DDMA_STATUS_IRQSTATUS	0x10000
+
+#define DDMASTART_REG		0x10
+/*0x14-0xFF reserved*/
+
+/*
+ * PCI Control Registers
+ */
+
+/*0x0 - 0x1 reserved*/
+#define PCICLKGATT_REG		0x2
+#define PCI_CLKGATT_SOFTRST	0x01
+#define PCI_CLKGATT_CKGEN	0x02
+#define PCI_CLKGATT_POWSEL	0x10
+#define PCI_CLKGATT_POWOFF	0x20
+
+#define PCINFCCLK_REG		0x3
+#define PCIMSCCLK_REG		0x4
+#define PCISDCCLK_REG		0x5
+#define PCICEACLK_REG		0x6
+
+#define PCIDMACLK_REG		0x7
+#define PCI_DMA_CLK_NFC		0x0
+#define PCI_DMA_CLK_MSC		0x1
+#define PCI_DMA_CLK_SDC		0x2
+#define PCI_DMA_CLK_CEA		0x3
+
+#define PCIINTCTRL_REG		0x8
+#define PCI_INTCTRL_NFCIRQEN	0x01
+#define PCI_INTCTRL_MSCIRQEN	0x02
+#define PCI_INTCTRL_SDCIRQEN	0x04
+#define PCI_INTCTRL_CEAIRQEN	0x08
+#define PCI_INTCTRL_DMAIRQEN	0x10
+#define PCI_INTCTRL_CICHIRQEN	0x20
+
+#define PCIINTSTATUS_REG	0x9
+#define PCI_INT_STATUS_NFC	0x01
+#define PCI_INT_STATUS_MSC	0x02
+#define PCI_INT_STATUS_SDC	0x04
+#define PCI_INT_STATUS_CEA	0x08
+#define PCI_INT_STATUS_DMA	0x10
+#define PCI_INT_STATUS_CICH	0x20
+
+#define PCITMOCTRL_REG		0xa
+#define PCI_TMO_CTRL_NO		0x0
+#define PCI_TMO_CTRL_32US	0x1
+#define PCI_TMO_CTRL_256US	0x2
+#define PCI_TMO_CTRL_1024US	0x3
+#define PCI_TMO_CTRL_256MS	0x4
+#define PCI_TMO_CTRL_512MS	0x5
+#define PCI_TMO_CTRL_1024MS	0x6
+
+/*0xB-0xFF reserved*/
+
+struct sdhcreg {
+	u32 sdcontrol_reg;
+	u32 sdcmdarg_reg;
+	u32 sdbusmode_reg;
+	u32 sdblklen_reg;
+	u32 sdresp_reg[4];
+	u32 sdcurblkcnt_reg;
+	u32 sdintmask_reg;
+	u32 sdstatus_reg;
+	u32 sdrsptmo_reg;
+	u32 sdclksel_reg;
+	u32 sdextctrl_reg;
+};
+
+struct pcictrlreg {
+	u8 reserve[2];
+	u8 pciclkgat_reg;
+	u8 pcinfcclk_reg;
+	u8 pcimscclk_reg;
+	u8 pcisdclk_reg;
+	u8 pcicaclk_reg;
+	u8 pcidmaclk_reg;
+	u8 pciintctrl_reg;
+	u8 pciintstatus_reg;
+	u8 pcitmoctrl_reg;
+	u8 Resv;
+};
+
+struct via_crdr_chip {
+	struct via_crdr_mmc_host *sdc;
+	void __iomem *mmiobase;
+	void __iomem *sdhc_mmiobase;
+	void __iomem *ddma_mmiobase;
+	void __iomem *pcictrl_mmiobase;
+	struct workqueue_struct *card_detect_queue;
+	u32 cur_device;
+
+	u8 pci_cfg_bak[0x42];
+	struct pcictrlreg pm_pcictrl_reg;
+	struct sdhcreg pm_sdhc_reg;
+};
+
+struct via_crdr_mmc_host {
+	struct via_crdr_chip *chip;
+	struct mmc_host *mmc;
+	spinlock_t lock;
+	struct mmc_request *mrq;
+	struct mmc_command *cmd;
+	struct mmc_data *data;
+	int data_early:1;
+	u8 bus_width;
+	u8 *ddmabuf;
+	dma_addr_t dmaaddr;
+
+	struct work_struct carddet_work;
+	struct tasklet_struct finish_tasklet;
+
+	struct timer_list timer;
+};
+
+#define DRV_NAME	"via_sdmmc_driver"
+#define DRIVER_VERSION 	"2.1 beta 2"
+
+static struct pci_device_id via_ids[] = {
+	{PCI_VENDOR_ID_VIA, 0x9530, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0,},
+	{0,}
+};
+
+MODULE_DEVICE_TABLE(pci, via_ids);
+
+static void via_print_sdchc(struct via_crdr_chip *vcrdr_chip)
+{
+	void __iomem *addrbase;
+
+	addrbase = vcrdr_chip->sdhc_mmiobase;
+
+	pr_debug("SDC MMIO Registers:\n");
+	pr_debug("SDCONTROL_REG=%x ,", readl(addrbase + SDCONTROL_REG));
+	pr_debug("SDCMDARG_REG=%x ,", readl(addrbase + SDCMDARG_REG));
+	pr_debug("SDBUSMODE_REG=%x\n", readl(addrbase + SDBUSMODE_REG));
+	pr_debug("SDBLKLEN_REG=%x ,", readl(addrbase + SDBLKLEN_REG));
+	pr_debug("SDCURBLKCNT_REG=%x,", readl(addrbase + SDCURBLKCNT_REG));
+	pr_debug("SDINTMASK_REG=%x\n", readl(addrbase + SDINTMASK_REG));
+	pr_debug("SDSTATUS_REG=%x,", readl(addrbase + SDSTATUS_REG));
+	pr_debug("SDCLKSEL_REG=%x,", readl(addrbase + SDCLKSEL_REG));
+	pr_debug("SDEXTCTRL_REG=%x\n", readl(addrbase + SDEXTCTRL_REG));
+}
+
+static void via_print_pcictrl(struct via_crdr_chip *vcrdr_chip)
+{
+	void __iomem *addrbase;
+
+	addrbase = vcrdr_chip->pcictrl_mmiobase;
+
+	pr_debug("PCI Control Registers:\n");
+	pr_debug("PCICLKGATT_REG=%x,", readb(addrbase + PCICLKGATT_REG));
+	pr_debug("PCIMSCCCLK_REG=%x,", readb(addrbase + PCIMSCCLK_REG));
+	pr_debug("PCISDCCLK_REG=%x,", readb(addrbase + PCISDCCLK_REG));
+	pr_debug("PCIDMACLK_REG=%x\n,", readb(addrbase + PCIDMACLK_REG));
+	pr_debug("PCIINTCTRL_REG=%x,", readb(addrbase + PCIINTCTRL_REG));
+	pr_debug("PCIINTSTATUS_REG=%x\n", readb(addrbase + PCIINTSTATUS_REG));
+}
+
+static void via_save_pcictrlreg(struct via_crdr_chip *vcrdr_chip)
+{
+	struct pcictrlreg *pm_pcictrl_reg;
+	void __iomem *addrbase;
+
+	pm_pcictrl_reg = &(vcrdr_chip->pm_pcictrl_reg);
+	addrbase = vcrdr_chip->pcictrl_mmiobase;
+
+	pm_pcictrl_reg->pciclkgat_reg = readb(addrbase + PCICLKGATT_REG);
+	pm_pcictrl_reg->pciclkgat_reg |=
+	    PCI_CLKGATT_POWSEL | PCI_CLKGATT_POWOFF;
+	pm_pcictrl_reg->pcimscclk_reg = readb(addrbase + PCIMSCCLK_REG);
+	pm_pcictrl_reg->pcisdclk_reg = readb(addrbase + PCISDCCLK_REG);
+	pm_pcictrl_reg->pcidmaclk_reg = readb(addrbase + PCIDMACLK_REG);
+	pm_pcictrl_reg->pciintctrl_reg = readb(addrbase + PCIINTCTRL_REG);
+	pm_pcictrl_reg->pciintstatus_reg = readb(addrbase + PCIINTSTATUS_REG);
+	pm_pcictrl_reg->pcitmoctrl_reg = readb(addrbase + PCITMOCTRL_REG);
+}
+
+static void via_restore_pcictrlreg(struct via_crdr_chip *vcrdr_chip)
+{
+	struct pcictrlreg *pm_pcictrl_reg;
+	void __iomem *addrbase;
+
+	pm_pcictrl_reg = &(vcrdr_chip->pm_pcictrl_reg);
+	addrbase = vcrdr_chip->pcictrl_mmiobase;
+
+	writeb(pm_pcictrl_reg->pciclkgat_reg, addrbase + PCICLKGATT_REG);
+	writeb(pm_pcictrl_reg->pcimscclk_reg, addrbase + PCIMSCCLK_REG);
+	writeb(pm_pcictrl_reg->pcisdclk_reg, addrbase + PCISDCCLK_REG);
+	writeb(pm_pcictrl_reg->pcidmaclk_reg, addrbase + PCIDMACLK_REG);
+	writeb(pm_pcictrl_reg->pciintctrl_reg, addrbase + PCIINTCTRL_REG);
+	writeb(pm_pcictrl_reg->pciintstatus_reg, addrbase + PCIINTSTATUS_REG);
+	writeb(pm_pcictrl_reg->pcitmoctrl_reg, addrbase + PCITMOCTRL_REG);
+}
+
+static void via_save_sdcreg(struct via_crdr_chip *vcrdr_chip)
+{
+	struct sdhcreg *pm_sdhc_reg;
+	void __iomem *addrbase;
+
+	pm_sdhc_reg = &(vcrdr_chip->pm_sdhc_reg);
+	addrbase = vcrdr_chip->sdhc_mmiobase;
+
+	pm_sdhc_reg->sdcontrol_reg = readl(addrbase + SDCONTROL_REG);
+	pm_sdhc_reg->sdcmdarg_reg = readl(addrbase + SDCMDARG_REG);
+	pm_sdhc_reg->sdbusmode_reg = readl(addrbase + SDBUSMODE_REG);
+	pm_sdhc_reg->sdblklen_reg = readl(addrbase + SDBLKLEN_REG);
+	pm_sdhc_reg->sdcurblkcnt_reg = readl(addrbase + SDCURBLKCNT_REG);
+	pm_sdhc_reg->sdintmask_reg = readl(addrbase + SDINTMASK_REG);
+	pm_sdhc_reg->sdstatus_reg = readl(addrbase + SDSTATUS_REG);
+	pm_sdhc_reg->sdrsptmo_reg = readl(addrbase + SDRSPTMO_REG);
+	pm_sdhc_reg->sdclksel_reg = readl(addrbase + SDCLKSEL_REG);
+	pm_sdhc_reg->sdextctrl_reg = readl(addrbase + SDEXTCTRL_REG);
+}
+
+static void via_restore_sdcreg(struct via_crdr_chip *vcrdr_chip)
+{
+	struct sdhcreg *pm_sdhc_reg;
+	void __iomem *addrbase;
+
+	pm_sdhc_reg = &(vcrdr_chip->pm_sdhc_reg);
+	addrbase = vcrdr_chip->sdhc_mmiobase;
+
+	writel(pm_sdhc_reg->sdcontrol_reg, addrbase + SDCONTROL_REG);
+	writel(pm_sdhc_reg->sdcmdarg_reg, addrbase + SDCMDARG_REG);
+	writel(pm_sdhc_reg->sdbusmode_reg, addrbase + SDBUSMODE_REG);
+	writel(pm_sdhc_reg->sdblklen_reg, addrbase + SDBLKLEN_REG);
+	writel(pm_sdhc_reg->sdcurblkcnt_reg, addrbase + SDCURBLKCNT_REG);
+	writel(pm_sdhc_reg->sdintmask_reg, addrbase + SDINTMASK_REG);
+	writel(pm_sdhc_reg->sdstatus_reg, addrbase + SDSTATUS_REG);
+	writel(pm_sdhc_reg->sdrsptmo_reg, addrbase + SDRSPTMO_REG);
+	writel(pm_sdhc_reg->sdclksel_reg, addrbase + SDCLKSEL_REG);
+	writel(pm_sdhc_reg->sdextctrl_reg, addrbase + SDEXTCTRL_REG);
+}
+
+static void via_set_ddma(struct via_crdr_chip *vcrdr_chip,
+			 dma_addr_t dmaaddr, u32 count, int dir, int enirq)
+{
+	void __iomem *addrbase = vcrdr_chip->ddma_mmiobase;
+	u32 ctrl_data = 0;
+
+	if (enirq)
+		ctrl_data |= DDMA_CONTROL_RDENIRQ;
+
+	if (dir)
+		ctrl_data |= DDMA_CONTROL_RDDIR;
+
+	writel(dmaaddr, addrbase + DDMABASEADD_REG);
+	writel(count, addrbase + DDMACOUNTER_REG);
+	writel(ctrl_data, addrbase + DDMACONTROL_REG);
+	writel(0x01, addrbase + DDMASTART_REG);
+}
+
+static void via_sdc_preparedata(struct via_crdr_mmc_host *host,
+				struct mmc_data *data)
+{
+	void __iomem *addrbase;
+	u32 org_data, blk_reg;
+	u32 offset = 0;
+	int dir, count;
+
+	host->data = data;
+	host->data_early = 0;
+	count = data->blocks * data->blksz;
+
+	memset(host->ddmabuf, 0, count);
+
+	if (data->flags & MMC_DATA_WRITE)
+		dir = MEM_TO_CARD;
+	else
+		dir = CARD_TO_MEM;
+
+	if (data->flags & MMC_DATA_WRITE) {
+		struct scatterlist *sg;
+		unsigned char *tmpbuf = NULL;
+		int i;
+
+		for_each_sg(data->sg, sg, data->sg_len, i) {
+			tmpbuf = kmap_atomic(sg_page(sg), KM_BIO_SRC_IRQ);
+			tmpbuf += sg->offset;
+			memcpy(host->ddmabuf + offset, tmpbuf, sg->length);
+			offset += sg->length;
+			kunmap_atomic(tmpbuf, KM_BIO_SRC_IRQ);
+		}
+	}
+
+	via_set_ddma(host->chip, host->dmaaddr, count, dir, 0);
+
+	addrbase = host->chip->pcictrl_mmiobase;
+	if (readb(addrbase + PCISDCCLK_REG) != PCI_CLK_48M)
+		writeb(PCI_CLK_48M, addrbase + PCISDCCLK_REG);
+
+	addrbase = host->chip->sdhc_mmiobase;
+	blk_reg = (((data->blksz) - 1) & 0xffff) | (data->blocks << 16);
+	org_data = readl(addrbase + SDBLKLEN_REG);
+	org_data &= ~0xffff07ff;
+	blk_reg &= 0xffff07ff;
+	writel(org_data | blk_reg, addrbase + SDBLKLEN_REG);
+}
+
+static void via_sdc_get_response(struct via_crdr_mmc_host *host,
+				 struct mmc_command *cmd)
+{
+	void __iomem *addrbase = host->chip->sdhc_mmiobase;
+	u32 dwdata0 = readl(addrbase + SDRESP0_REG);
+	u32 dwdata1 = readl(addrbase + SDRESP1_REG);
+	u32 dwdata2 = readl(addrbase + SDRESP2_REG);
+	u32 dwdata3 = readl(addrbase + SDRESP3_REG);
+
+	if (cmd->flags & MMC_RSP_136) {
+		cmd->resp[0] = ((u8) (dwdata1)) |
+		    (((u8) (dwdata0 >> 24)) << 8) |
+		    (((u8) (dwdata0 >> 16)) << 16) |
+		    (((u8) (dwdata0 >> 8)) << 24);
+
+		cmd->resp[1] = ((u8) (dwdata2)) |
+		    (((u8) (dwdata1 >> 24)) << 8) |
+		    (((u8) (dwdata1 >> 16)) << 16) |
+		    (((u8) (dwdata1 >> 8)) << 24);
+
+		cmd->resp[2] = ((u8) (dwdata3)) |
+		    (((u8) (dwdata2 >> 24)) << 8) |
+		    (((u8) (dwdata2 >> 16)) << 16) |
+		    (((u8) (dwdata2 >> 8)) << 24);
+
+		cmd->resp[3] = 0xff |
+		    ((((u8) (dwdata3 >> 24))) << 8) |
+		    (((u8) (dwdata3 >> 16)) << 16) |
+		    (((u8) (dwdata3 >> 8)) << 24);
+	} else {
+		dwdata0 >>= 8;
+		cmd->resp[0] = ((dwdata0 & 0xff) << 24) |
+		    (((dwdata0 >> 8) & 0xff) << 16) |
+		    (((dwdata0 >> 16) & 0xff) << 8) | (dwdata1 & 0xff);
+
+		dwdata1 >>= 8;
+		cmd->resp[1] = ((dwdata1 & 0xff) << 24) |
+		    (((dwdata1 >> 8) & 0xff) << 16) |
+		    (((dwdata1 >> 16) & 0xff) << 8);
+	}
+}
+
+static void via_sdc_send_command(struct via_crdr_mmc_host *host,
+				 struct mmc_command *cmd)
+{
+	void __iomem *addrbase;
+	struct mmc_data *data;
+	u32 cmdctrl = 0;
+
+	data = cmd->data;
+
+	mod_timer(&host->timer, jiffies + 10 * HZ);
+	host->cmd = cmd;
+
+	cmdctrl = cmd->opcode << 8;
+
+	cmd->flags &= 0x1f;
+	switch (cmd->flags) {
+	case MMC_RSP_NONE:
+		cmdctrl |= ((u32) (0x0 << 16));
+		break;
+	case MMC_RSP_R1:
+		cmdctrl |= ((u32) (0x01 << 16));
+		break;
+	case MMC_RSP_R1B:
+		cmdctrl |= ((u32) (0x09 << 16));
+		break;
+	case MMC_RSP_R2:
+		cmdctrl |= ((u32) (0x02 << 16));
+		break;
+	case MMC_RSP_R3:
+		cmdctrl |= ((u32) (0x03 << 16));
+		break;
+	default:
+		pr_err("%s: cmd->flag is not valid\n", mmc_hostname(host->mmc));
+		break;
+	}
+
+	if (!(cmd->data))
+		goto nodata;
+
+	via_sdc_preparedata(host, data);
+
+	if (data->blocks > 1) {
+		if (data->flags & MMC_DATA_WRITE)
+			cmdctrl |= 0x34;
+		else
+			cmdctrl |= 0x40;
+	} else {
+		if (data->flags & MMC_DATA_WRITE)
+			cmdctrl |= 0x14;
+		else
+			cmdctrl |= 0x20;
+	}
+
+nodata:
+	if (cmd->opcode == MMC_STOP_TRANSMISSION)
+		cmdctrl |= 0x70;
+
+	cmdctrl |= 1;
+
+	addrbase = host->chip->sdhc_mmiobase;
+	writel(cmd->arg, addrbase + SDCMDARG_REG);
+	writel(cmdctrl, addrbase + SDCONTROL_REG);
+}
+
+static void via_sdc_finish_data(struct via_crdr_mmc_host *host)
+{
+	struct mmc_data *data;
+	u16 blocks;
+	u32 offset = 0;
+
+	BUG_ON(!host->data);
+
+	data = host->data;
+	host->data = NULL;
+
+	if (data->blocks == 1)
+		blocks = (data->error == 0) ? 0 : 1;
+	else
+		blocks = readw(host->chip->sdhc_mmiobase + SDCURBLKCNT_REG);
+	data->bytes_xfered = data->blksz * (data->blocks - blocks);
+
+	if (!data->error && blocks) {
+		pr_err("%s: Controller signalled completion even "
+		       "though there were blocks left.\n",
+		       mmc_hostname(host->mmc));
+		data->error = -EIO;
+	}
+
+	if (data->flags & MMC_DATA_READ) {
+		struct scatterlist *sg;
+		unsigned char *sgbuf;
+		int i;
+
+		for_each_sg(data->sg, sg, data->sg_len, i) {
+			sgbuf = kmap_atomic(sg_page(sg), KM_BIO_SRC_IRQ);
+			memcpy(sgbuf + sg->offset, host->ddmabuf + offset,
+			       sg->length);
+			offset += sg[i].length;
+			kunmap_atomic(sgbuf, KM_BIO_SRC_IRQ);
+		}
+	}
+
+	if (data->stop)
+		via_sdc_send_command(host, data->stop);
+	else
+		tasklet_schedule(&host->finish_tasklet);
+}
+
+static void via_sdc_finish_command(struct via_crdr_mmc_host *host)
+{
+	via_sdc_get_response(host, host->cmd);
+
+	host->cmd->error = 0;
+
+	if (host->data && host->data_early)
+		via_sdc_finish_data(host);
+
+	if (!host->cmd->data)
+		tasklet_schedule(&host->finish_tasklet);
+
+	host->cmd = NULL;
+}
+
+static void via_sdc_request(struct mmc_host *mmc, struct mmc_request *mrq)
+{
+	void __iomem *addrbase;
+	struct via_crdr_mmc_host *host;
+	struct via_crdr_chip *vcrdr_chip;
+	unsigned long flags;
+	u16 status;
+
+	host = mmc_priv(mmc);
+	vcrdr_chip = host->chip;
+
+	spin_lock_irqsave(&host->lock, flags);
+
+	addrbase = vcrdr_chip->pcictrl_mmiobase;
+	writeb(PCI_DMA_CLK_SDC, addrbase + PCIDMACLK_REG);
+	vcrdr_chip->cur_device = DEV_SDC;
+
+	status = readw(vcrdr_chip->sdhc_mmiobase + SDSTATUS_REG);
+	status &= SD_STS_W1C_MASK;
+	writew(status, vcrdr_chip->sdhc_mmiobase + SDSTATUS_REG);
+
+	WARN_ON(host->mrq != NULL);
+	host->mrq = mrq;
+
+	if (host->mrq->cmd->opcode == 5) {
+		host->mrq->cmd->error = -ENOMEDIUM;
+		tasklet_schedule(&host->finish_tasklet);
+		goto out;
+	}
+
+	status = readw(vcrdr_chip->sdhc_mmiobase + SDSTATUS_REG);
+	if (!(status & SD_STS_SLOTG)) {
+		host->mrq->cmd->error = -ENOMEDIUM;
+		tasklet_schedule(&host->finish_tasklet);
+	} else {
+		via_sdc_send_command(host, mrq->cmd);
+	}
+
+out:
+	mmiowb();
+	spin_unlock_irqrestore(&host->lock, flags);
+}
+
+static void via_sdc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
+{
+	struct via_crdr_mmc_host *host;
+	struct via_crdr_chip *vcrdr_chip;
+	unsigned long flags;
+
+	host = mmc_priv(mmc);
+	vcrdr_chip = host->chip;
+
+	spin_lock_irqsave(&host->lock, flags);
+
+	if (host->bus_width != ios->bus_width) {
+		void __iomem *addrbase = vcrdr_chip->sdhc_mmiobase;
+		u32 org_data = readl(addrbase + SDBUSMODE_REG);
+
+		if (ios->bus_width == MMC_BUS_WIDTH_1) {
+			host->bus_width = MMC_BUS_WIDTH_1;
+			org_data &= ~SD_MODE_4BIT;
+		} else {
+			host->bus_width = MMC_BUS_WIDTH_4;
+			org_data |= SD_MODE_4BIT;
+		}
+		writel(org_data, addrbase + SDBUSMODE_REG);
+	}
+
+	mmiowb();
+	spin_unlock_irqrestore(&host->lock, flags);
+}
+
+static int via_sdc_get_ro(struct mmc_host *mmc)
+{
+	struct via_crdr_mmc_host *host;
+	struct via_crdr_chip *vcrdr_chip;
+	unsigned long flags;
+	u16 status;
+
+	host = mmc_priv(mmc);
+	vcrdr_chip = host->chip;
+
+	spin_lock_irqsave(&host->lock, flags);
+
+	status = readw(vcrdr_chip->sdhc_mmiobase + SDSTATUS_REG);
+
+	spin_unlock_irqrestore(&host->lock, flags);
+
+	return !(status & SD_STS_WP);
+}
+
+static const struct mmc_host_ops via_sdc_ops = {
+	.request = via_sdc_request,
+	.set_ios = via_sdc_set_ios,
+	.get_ro = via_sdc_get_ro,
+};
+
+static void via_reset_pcictrl(struct via_crdr_mmc_host *host)
+{
+	struct via_crdr_chip *vcrdr_chip;
+	void __iomem *addrbase;
+	unsigned long flags;
+	u8 gatt;
+
+	vcrdr_chip = host->chip;
+	addrbase = vcrdr_chip->pcictrl_mmiobase;
+
+	spin_lock_irqsave(&host->lock, flags);
+
+	via_save_pcictrlreg(vcrdr_chip);
+	via_save_sdcreg(vcrdr_chip);
+
+	spin_unlock_irqrestore(&host->lock, flags);
+
+	gatt = PCI_CLKGATT_POWSEL | PCI_CLKGATT_POWOFF;
+	writeb(gatt, vcrdr_chip->pcictrl_mmiobase + PCICLKGATT_REG);
+	msleep(3);
+	gatt |= PCI_CLKGATT_SOFTRST;
+	writeb(gatt, vcrdr_chip->pcictrl_mmiobase + PCICLKGATT_REG);
+	msleep(3);
+
+	spin_lock_irqsave(&host->lock, flags);
+
+	via_restore_pcictrlreg(vcrdr_chip);
+	via_restore_sdcreg(vcrdr_chip);
+
+	mmiowb();
+	spin_unlock_irqrestore(&host->lock, flags);
+}
+
+static void via_sdc_cmd_isr(struct via_crdr_mmc_host *host, u16 intmask)
+{
+	BUG_ON(intmask == 0);
+
+	if (!host->cmd) {
+		pr_err("%s: Got command interrupt 0x%x even "
+		       "though no command operation was in progress.\n",
+		       mmc_hostname(host->mmc), intmask);
+		return;
+	}
+
+	if (intmask & SD_STS_RA)
+		host->cmd->error = -ETIMEDOUT;
+	else if (intmask & SD_STS_SC)
+		host->cmd->error = -EILSEQ;
+
+	if (host->cmd->error)
+		tasklet_schedule(&host->finish_tasklet);
+	else if (intmask & SD_STS_CR)
+		via_sdc_finish_command(host);
+}
+
+static void via_sdc_data_isr(struct via_crdr_mmc_host *host, u16 intmask)
+{
+	BUG_ON(intmask == 0);
+
+	if (intmask & SD_STS_DT)
+		host->data->error = -ETIMEDOUT;
+	else if (intmask & (SD_STS_RC | SD_STS_WC))
+		host->data->error = -EILSEQ;
+
+	if (host->data->error)
+		via_sdc_finish_data(host);
+	else {
+		if (host->cmd)
+			host->data_early = 1;
+		else
+			via_sdc_finish_data(host);
+	}
+}
+
+static irqreturn_t via_sdc_isr(int irq, void *dev_id)
+{
+	struct via_crdr_mmc_host *sdhost = dev_id;
+	struct via_crdr_chip *vcrdr_chip = sdhost->chip;
+	void __iomem *addrbase;
+	u8 pci_status;
+	u16 sd_status;
+	irqreturn_t result;
+
+	spin_lock(&sdhost->lock);
+
+	addrbase = vcrdr_chip->pcictrl_mmiobase;
+	pci_status = readb(addrbase + PCIINTSTATUS_REG);
+	if (!(pci_status & PCI_INT_STATUS_SDC)) {
+		result = IRQ_NONE;
+		goto out;
+	}
+
+	addrbase = vcrdr_chip->sdhc_mmiobase;
+	sd_status = readw(addrbase + SDSTATUS_REG);
+	sd_status &= SD_STS_INT_MASK;
+	sd_status &= ~SD_STS_IGN_MASK;
+	if (!sd_status) {
+		result = IRQ_NONE;
+		goto out;
+	}
+
+	if (sd_status & SD_STS_SI) {
+		writew(sd_status & SD_STS_SI, addrbase + SDSTATUS_REG);
+		queue_work(vcrdr_chip->card_detect_queue,
+			 &sdhost->carddet_work);
+	}
+
+	sd_status &= ~SD_STS_SI;
+	if (sd_status & SD_STS_CMD_MASK) {
+		writew(sd_status & SD_STS_CMD_MASK, addrbase + SDSTATUS_REG);
+		via_sdc_cmd_isr(sdhost, sd_status & SD_STS_CMD_MASK);
+	}
+	if (sd_status & SD_STS_DATA_MASK) {
+		writew(sd_status & SD_STS_DATA_MASK, addrbase + SDSTATUS_REG);
+		via_sdc_data_isr(sdhost, sd_status & SD_STS_DATA_MASK);
+	}
+
+	sd_status &= ~(SD_STS_CMD_MASK | SD_STS_DATA_MASK);
+	if (sd_status) {
+		pr_err("%s: Unexpected interrupt 0x%x\n",
+		       mmc_hostname(sdhost->mmc), sd_status);
+		writew(sd_status, addrbase + SDSTATUS_REG);
+	}
+
+	result = IRQ_HANDLED;
+
+	mmiowb();
+out:
+	spin_unlock(&sdhost->lock);
+
+	return result;
+}
+
+static void via_sdc_timeout(unsigned long ulongdata)
+{
+	struct via_crdr_mmc_host *sdhost;
+	unsigned long flags;
+
+	sdhost = (struct via_crdr_mmc_host *)ulongdata;
+
+	spin_lock_irqsave(&sdhost->lock, flags);
+
+	if (sdhost->mrq) {
+		pr_err("%s: Timeout waiting for hardware interrupt."
+		       "cmd:0x%x\n", mmc_hostname(sdhost->mmc),
+		       sdhost->mrq->cmd->opcode);
+		if (sdhost->data) {
+			sdhost->data->error = -ETIMEDOUT;
+			via_sdc_finish_data(sdhost);
+		} else {
+			if (sdhost->cmd)
+				sdhost->cmd->error = -ETIMEDOUT;
+			else
+				sdhost->mrq->cmd->error = -ETIMEDOUT;
+			tasklet_schedule(&sdhost->finish_tasklet);
+		}
+	}
+
+	mmiowb();
+	spin_unlock_irqrestore(&sdhost->lock, flags);
+}
+
+static void via_sdc_tasklet_finish(unsigned long param)
+{
+	struct via_crdr_mmc_host *host;
+	unsigned long flags;
+	struct mmc_request *mrq;
+
+	host = (struct via_crdr_mmc_host *)param;
+
+	spin_lock_irqsave(&host->lock, flags);
+
+	del_timer(&host->timer);
+	mrq = host->mrq;
+	host->mrq = NULL;
+	host->cmd = NULL;
+	host->data = NULL;
+
+	spin_unlock_irqrestore(&host->lock, flags);
+
+	mmc_request_done(host->mmc, mrq);
+}
+
+static void via_sdc_card_detect(struct work_struct *work)
+{
+	struct via_crdr_mmc_host *host;
+	struct via_crdr_chip *vcrdr_chip;
+	void __iomem *addrbase;
+	unsigned long flags;
+	u16 status;
+
+	host = container_of(work, struct via_crdr_mmc_host, carddet_work);
+	vcrdr_chip = host->chip;
+
+	addrbase = vcrdr_chip->ddma_mmiobase;
+	writel(DDMA_CONTROL_SOFTRESET, addrbase + DDMACONTROL_REG);
+
+	spin_lock_irqsave(&host->lock, flags);
+
+	addrbase = vcrdr_chip->pcictrl_mmiobase;
+	writeb(PCI_DMA_CLK_SDC, addrbase + PCIDMACLK_REG);
+	vcrdr_chip->cur_device = DEV_SDC;
+
+	addrbase = vcrdr_chip->sdhc_mmiobase;
+	status = readw(addrbase + SDSTATUS_REG);
+	if (!(status & SD_STS_SLOTG)) {
+		if (host->mrq) {
+			pr_err("%s: Card removed during transfer!\n",
+			       mmc_hostname(host->mmc));
+			host->mrq->cmd->error = -ENOMEDIUM;
+			tasklet_schedule(&host->finish_tasklet);
+		}
+
+		addrbase = vcrdr_chip->pcictrl_mmiobase;
+		writeb(PCI_CLK_375K, addrbase + PCISDCCLK_REG);
+
+		mmiowb();
+		spin_unlock_irqrestore(&host->lock, flags);
+
+		via_reset_pcictrl(host);
+
+		spin_lock_irqsave(&host->lock, flags);
+
+		vcrdr_chip->cur_device = DEV_NULL;
+	}
+
+	mmiowb();
+	spin_unlock_irqrestore(&host->lock, flags);
+
+	via_print_pcictrl(vcrdr_chip);
+	via_print_sdchc(vcrdr_chip);
+
+	mmc_detect_change(host->mmc, 0);
+}
+
+static void via_init_mmc_host(struct via_crdr_mmc_host *host)
+{
+	struct via_crdr_chip *vcrdr_chip = host->chip;
+	struct mmc_host *mmc = host->mmc;
+	void __iomem *addrbase;
+	u32 lenreg;
+	u32 status;
+
+	init_timer(&host->timer);
+	host->timer.data = (unsigned long)host;
+	host->timer.function = via_sdc_timeout;
+
+	spin_lock_init(&host->lock);
+
+	host->mmc->f_min = 450000;
+	host->mmc->f_max = 24000000;
+	host->mmc->max_seg_size = 512;
+	host->mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
+	host->mmc->caps = MMC_CAP_4_BIT_DATA;
+	host->mmc->ops = &via_sdc_ops;
+	host->mmc->max_hw_segs = 128;
+	host->mmc->max_phys_segs = 128;
+	host->mmc->max_seg_size = mmc->max_hw_segs * 512;
+	host->mmc->max_req_size = host->mmc->max_seg_size;
+
+	INIT_WORK(&host->carddet_work, via_sdc_card_detect);
+
+	tasklet_init(&host->finish_tasklet, via_sdc_tasklet_finish,
+		     (unsigned long)host);
+
+	addrbase = vcrdr_chip->sdhc_mmiobase;
+	writel(0x0, addrbase + SDINTMASK_REG);
+	msleep(1);
+
+	lenreg = 0x1ff;
+	lenreg |= SD_BLKLEN_GPIDET | SD_BLKLEN_INTEN;
+	lenreg |= 0x80000;
+	writel(lenreg, addrbase + SDBLKLEN_REG);
+
+	status = readw(addrbase + SDSTATUS_REG);
+	status &= SD_STS_W1C_MASK;
+	writew(status, addrbase + SDSTATUS_REG);
+
+	status = readw(addrbase + SDSTATUS_REG2);
+	status |= SD_STS_CFE;
+	writew(status, addrbase + SDSTATUS_REG2);
+
+	writeb(0x0, addrbase + SDEXTCTRL_REG);
+
+	writel(SD_ACTIVE_INTMASK, addrbase + SDINTMASK_REG);
+	msleep(1);
+
+	host->bus_width = MMC_BUS_WIDTH_1;
+
+	addrbase = vcrdr_chip->pcictrl_mmiobase;
+	writeb(PCI_CLK_375K, addrbase + PCISDCCLK_REG);
+}
+
+static int __devinit via_chip_probe(struct pci_dev *pcidev,
+				    const struct pci_device_id *id)
+{
+	struct device *dev;
+	struct mmc_host *mmc;
+	struct via_crdr_mmc_host *sdhost;
+	struct via_crdr_chip *vcrdr_chip;
+	u32 mmiobase;
+	u32 len;
+	u8 rev;
+	int ret;
+	u8 gatt;
+
+	pci_read_config_byte(pcidev, PCI_CLASS_REVISION, &rev);
+	pr_info(DRV_NAME
+		": VIA SDMMC controller found at %s [%04x:%04x] (rev %x)\n",
+		pci_name(pcidev), (int)pcidev->vendor, (int)pcidev->device,
+		(int)rev);
+
+	ret = pci_enable_device(pcidev);
+	if (ret)
+		return ret;
+
+	ret = pci_request_regions(pcidev, DRV_NAME);
+	if (ret)
+		goto disable;
+
+	vcrdr_chip = kzalloc(sizeof(*vcrdr_chip), GFP_KERNEL);
+	if (!vcrdr_chip) {
+		ret = -ENOMEM;
+		goto release;
+	}
+
+	vcrdr_chip->card_detect_queue =
+		create_singlethread_workqueue("via_card_detect");
+	if (!vcrdr_chip->card_detect_queue) {
+		ret = -ENOMEM;
+		goto chip_free;
+	}
+
+	pci_write_config_byte(pcidev, PCI_WORK_MODE, 0);
+	pci_write_config_byte(pcidev, PCI_DEBUG_MODE, 0);
+
+	len = pci_resource_len(pcidev, 0);
+	mmiobase = pci_resource_start(pcidev, 0);
+	vcrdr_chip->mmiobase = ioremap_nocache(mmiobase, len);
+	if (!vcrdr_chip->mmiobase) {
+		ret = -ENOMEM;
+		goto work_queue_free;
+	}
+
+	vcrdr_chip->sdhc_mmiobase = vcrdr_chip->mmiobase + SDC_OFFSET;
+	vcrdr_chip->ddma_mmiobase = vcrdr_chip->mmiobase + DDMA_OFFSET;
+	vcrdr_chip->pcictrl_mmiobase = vcrdr_chip->mmiobase + PCICTRL_OFFSET;
+
+	dev = &pcidev->dev;
+	dev_set_drvdata(dev, vcrdr_chip);
+
+	vcrdr_chip->cur_device = DEV_NULL;
+
+	gatt = PCI_CLKGATT_POWSEL | PCI_CLKGATT_POWOFF;
+	writeb(gatt, vcrdr_chip->pcictrl_mmiobase + PCICLKGATT_REG);
+	msleep(3);
+	gatt |= PCI_CLKGATT_SOFTRST;
+	writeb(gatt, vcrdr_chip->pcictrl_mmiobase + PCICLKGATT_REG);
+	msleep(3);
+
+	mmc = mmc_alloc_host(sizeof(struct via_crdr_mmc_host), dev);
+	if (!mmc) {
+		ret = -ENOMEM;
+		goto unmap;
+	}
+
+	sdhost = mmc_priv(mmc);
+	sdhost->mmc = mmc;
+	sdhost->chip = vcrdr_chip;
+	vcrdr_chip->sdc = sdhost;
+
+	via_init_mmc_host(sdhost);
+
+	ret =
+	    request_irq(pcidev->irq, via_sdc_isr, IRQF_SHARED, DRV_NAME,
+			sdhost);
+	if (ret)
+		goto free_mmc_host;
+
+	sdhost->ddmabuf = (u8 *) __get_free_pages(GFP_KERNEL, 4);
+	if (!sdhost->ddmabuf) {
+		ret = -ENOMEM;
+		goto free_mmc_irq;
+	}
+
+	sdhost->dmaaddr = dma_map_single(dev, sdhost->ddmabuf,
+		sdhost->mmc->max_req_size, DMA_BIDIRECTIONAL);
+
+	writeb(PCI_INTCTRL_SDCIRQEN,
+	       vcrdr_chip->pcictrl_mmiobase + PCIINTCTRL_REG);
+	writeb(PCI_TMO_CTRL_1024MS,
+	       vcrdr_chip->pcictrl_mmiobase + PCITMOCTRL_REG);
+
+	mmc_add_host(mmc);
+
+	return 0;
+
+free_mmc_irq:
+	free_irq(pcidev->irq, sdhost);
+free_mmc_host:
+	mmc_free_host(mmc);
+unmap:
+	dev_set_drvdata(dev, NULL);
+	iounmap(vcrdr_chip->mmiobase);
+work_queue_free:
+	destroy_workqueue(vcrdr_chip->card_detect_queue);
+chip_free:
+	kfree(vcrdr_chip);
+release:
+	pci_release_regions(pcidev);
+disable:
+	pci_disable_device(pcidev);
+
+	return ret;
+}
+
+static void __devexit via_chip_remove(struct pci_dev *pcidev)
+{
+	struct via_crdr_chip *vcrdr_chip;
+	struct via_crdr_mmc_host *sdhost;
+	u8 gatt;
+
+	pr_info(DRV_NAME
+		": VIA SDMMC controller at %s [%04x:%04x] has been removed\n",
+		pci_name(pcidev), (int)pcidev->vendor, (int)pcidev->device);
+
+	vcrdr_chip = pci_get_drvdata(pcidev);
+
+	flush_workqueue(vcrdr_chip->card_detect_queue);
+
+	sdhost = vcrdr_chip->sdc;
+	if (sdhost) {
+
+		tasklet_kill(&sdhost->finish_tasklet);
+		dma_unmap_single(&pcidev->dev, sdhost->dmaaddr,
+			sdhost->mmc->max_req_size, DMA_BIDIRECTIONAL);
+		free_pages((unsigned long)sdhost->ddmabuf, 4);
+
+		if (&sdhost->timer)
+			del_timer_sync(&sdhost->timer);
+
+		mmc_remove_host(sdhost->mmc);
+	}
+
+	free_irq(pcidev->irq, sdhost);
+	mmc_free_host(sdhost->mmc);
+
+	writeb(0x0, vcrdr_chip->pcictrl_mmiobase + PCIINTCTRL_REG);
+
+	gatt = readb(vcrdr_chip->pcictrl_mmiobase + PCICLKGATT_REG);
+	gatt &= ~PCI_CLKGATT_POWOFF;
+	writeb(gatt, vcrdr_chip->pcictrl_mmiobase + PCICLKGATT_REG);
+
+	dev_set_drvdata(&pcidev->dev, NULL);
+	iounmap(vcrdr_chip->mmiobase);
+	destroy_workqueue(vcrdr_chip->card_detect_queue);
+	kfree(vcrdr_chip);
+	pci_release_regions(pcidev);
+	pci_disable_device(pcidev);
+}
+
+#ifdef CONFIG_PM
+static void via_save_pcicfg(struct pci_dev *pcidev,
+			    struct via_crdr_chip *vcrdr_chip)
+{
+	int i;
+
+	for (i = 0; i < 0x42; i++)
+		pci_read_config_byte(pcidev, i, &(vcrdr_chip->pci_cfg_bak[i]));
+}
+
+static void via_restore_pcicfg(struct pci_dev *pcidev,
+			       struct via_crdr_chip *vcrdr_chip)
+{
+	int i;
+
+	for (i = 0; i < 0x42; i++)
+		pci_write_config_byte(pcidev, i, vcrdr_chip->pci_cfg_bak[i]);
+}
+
+static void via_init_sdc_pm(struct via_crdr_chip *vcrdr_chip)
+{
+	struct sdhcreg *pm_sdhcreg;
+	void __iomem *addrbase;
+	u32 lenreg;
+	u16 status;
+
+	pm_sdhcreg = &(vcrdr_chip->pm_sdhc_reg);
+	addrbase = vcrdr_chip->sdhc_mmiobase;
+
+	writel(0x0, addrbase + SDINTMASK_REG);
+
+	lenreg = 0x1ff;
+	lenreg |= SD_BLKLEN_GPIDET | SD_BLKLEN_INTEN;
+	lenreg |= 0x80000;
+	writel(lenreg, addrbase + SDBLKLEN_REG);
+
+	status = readw(addrbase + SDSTATUS_REG);
+	status &= SD_STS_W1C_MASK;
+	writew(status, addrbase + SDSTATUS_REG);
+
+	status = readw(addrbase + SDSTATUS_REG2);
+	status |= SD_STS_CFE;
+	writew(status, addrbase + SDSTATUS_REG2);
+
+	writel(pm_sdhcreg->sdcontrol_reg, addrbase + SDCONTROL_REG);
+	writel(pm_sdhcreg->sdcmdarg_reg, addrbase + SDCMDARG_REG);
+	writel(pm_sdhcreg->sdintmask_reg, addrbase + SDINTMASK_REG);
+	writel(pm_sdhcreg->sdrsptmo_reg, addrbase + SDRSPTMO_REG);
+	writel(pm_sdhcreg->sdclksel_reg, addrbase + SDCLKSEL_REG);
+	writel(pm_sdhcreg->sdextctrl_reg, addrbase + SDEXTCTRL_REG);
+
+	addrbase = vcrdr_chip->pcictrl_mmiobase;
+	writeb(PCI_CLK_375K, addrbase + PCISDCCLK_REG);
+
+	via_print_pcictrl(vcrdr_chip);
+	via_print_sdchc(vcrdr_chip);
+}
+
+static int via_chip_suspend(struct pci_dev *pcidev, pm_message_t state)
+{
+	struct via_crdr_mmc_host *sdhost;
+	struct via_crdr_chip *vcrdr_chip;
+	int ret = 0;
+
+	vcrdr_chip = pci_get_drvdata(pcidev);
+	sdhost = vcrdr_chip->sdc;
+
+	flush_workqueue(vcrdr_chip->card_detect_queue);
+
+	via_save_pcicfg(pcidev, vcrdr_chip);
+	via_save_pcictrlreg(vcrdr_chip);
+	via_save_sdcreg(vcrdr_chip);
+
+	switch (vcrdr_chip->cur_device) {
+	case DEV_SDC:
+		ret = mmc_suspend_host(sdhost->mmc, state);
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+static int via_chip_resume(struct pci_dev *pcidev)
+{
+	struct via_crdr_mmc_host *sdhost;
+	struct via_crdr_chip *vcrdr_chip;
+	int ret = 0;
+	u8 gatt;
+
+	vcrdr_chip = pci_get_drvdata(pcidev);
+	sdhost = vcrdr_chip->sdc;
+
+	gatt = PCI_CLKGATT_POWSEL | PCI_CLKGATT_POWOFF;
+	writeb(gatt, vcrdr_chip->pcictrl_mmiobase + PCICLKGATT_REG);
+	msleep(3);
+	gatt |= PCI_CLKGATT_SOFTRST;
+	writeb(gatt, vcrdr_chip->pcictrl_mmiobase + PCICLKGATT_REG);
+	msleep(3);
+
+	msleep(100);
+
+	via_restore_pcicfg(pcidev, vcrdr_chip);
+	via_restore_pcictrlreg(vcrdr_chip);
+	via_init_sdc_pm(vcrdr_chip);
+
+	switch (vcrdr_chip->cur_device) {
+	case DEV_SDC:
+		ret = mmc_resume_host(sdhost->mmc);
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+#else /* CONFIG_PM */
+
+#define via_chip_suspend NULL
+#define via_chip_resume NULL
+
+#endif /* CONFIG_PM */
+
+static struct pci_driver via_sd_driver = {
+	.name = DRV_NAME,
+	.id_table = via_ids,
+	.probe = via_chip_probe,
+	.remove = __devexit_p(via_chip_remove),
+	.suspend = via_chip_suspend,
+	.resume = via_chip_resume,
+};
+
+static int __init via_sd_drv_init(void)
+{
+	pr_info(DRV_NAME ": VIA SD/MMC Card Reader driver\n");
+	pr_info(DRV_NAME ": Copyright(c) VIA Technologies Inc.\n");
+
+	return pci_register_driver(&via_sd_driver);
+}
+
+static void __exit via_sd_drv_exit(void)
+{
+	pci_unregister_driver(&via_sd_driver);
+}
+
+module_init(via_sd_drv_init);
+module_exit(via_sd_drv_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("VIA Technologies Inc.");
+MODULE_DESCRIPTION("VIA SD/MMC Card Interface driver");
+MODULE_VERSION(DRIVER_VERSION);
_

Patches currently in -mm which might be from josephchan@via.com.tw are

via-sdmmc-via-msp-card-reader-driver-support.patch
viafb-returns-0-two-too-early.patch

