From: akpm@linux-foundation.org
Subject: + atmel-mci-change-use-of-dma-slave-interface.patch added to -mm tree
Date: Fri, 20 Nov 2009 16:10:48 -0800
Message-ID: <200911210010.nAL0An0x005850@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753233AbZKUAKv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Nov 2009 19:10:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nicolas.ferre@atmel.com, hskinnemoen@atmel.com, linux-mmc@vger.kernel.org


The patch titled
     atmel-mci: change use of dma slave interface
has been added to the -mm tree.  Its filename is
     atmel-mci-change-use-of-dma-slave-interface.patch

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
Subject: atmel-mci: change use of dma slave interface
From: Nicolas Ferre <nicolas.ferre@atmel.com>

Allow the use of another DMA controller driver in atmel-mci sd/mmc driver.
 This adds a generic dma_slave pointer to the mci platform structure where
we can store DMA controller information.  In atmel-mci we use information
provided by this structure to initialize the driver (with new helper
functions that are architecture dependant).

This also adds at32/avr32 chip modifications to cope with this new access
method.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-at91/include/mach/atmel-mci.h     |   24 ++++++
 arch/avr32/mach-at32ap/at32ap700x.c             |   18 +++-
 arch/avr32/mach-at32ap/include/mach/atmel-mci.h |   24 ++++++
 drivers/mmc/host/atmel-mci.c                    |   56 +++++++++-----
 include/linux/atmel-mci.h                       |    4 -
 5 files changed, 98 insertions(+), 28 deletions(-)

diff -puN /dev/null arch/arm/mach-at91/include/mach/atmel-mci.h
--- /dev/null
+++ a/arch/arm/mach-at91/include/mach/atmel-mci.h
@@ -0,0 +1,24 @@
+#ifndef __MACH_ATMEL_MCI_H
+#define __MACH_ATMEL_MCI_H
+
+#include <mach/at_hdmac.h>
+
+/**
+ * struct mci_dma_data - DMA data for MCI interface
+ */
+struct mci_dma_data {
+	struct at_dma_slave	sdata;
+};
+
+/* accessor macros */
+#define	slave_data_ptr(s)	(&(s)->sdata)
+#define find_slave_dev(s)	((s)->sdata.dma_dev)
+
+#define	setup_dma_addr(s, t, r)	do {		\
+	if (s) {				\
+		(s)->sdata.tx_reg = (t);	\
+		(s)->sdata.rx_reg = (r);	\
+	}					\
+} while (0)
+
+#endif /* __MACH_ATMEL_MCI_H */
diff -puN arch/avr32/mach-at32ap/at32ap700x.c~atmel-mci-change-use-of-dma-slave-interface arch/avr32/mach-at32ap/at32ap700x.c
--- a/arch/avr32/mach-at32ap/at32ap700x.c~atmel-mci-change-use-of-dma-slave-interface
+++ a/arch/avr32/mach-at32ap/at32ap700x.c
@@ -15,6 +15,8 @@
 #include <linux/gpio.h>
 #include <linux/spi/spi.h>
 #include <linux/usb/atmel_usba_udc.h>
+
+#include <mach/atmel-mci.h>
 #include <linux/atmel-mci.h>
 
 #include <asm/io.h>
@@ -1323,7 +1325,7 @@ struct platform_device *__init
 at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 {
 	struct platform_device		*pdev;
-	struct dw_dma_slave		*dws = &data->dma_slave;
+	struct mci_dma_slave		*slave;
 	u32				pioa_mask;
 	u32				piob_mask;
 
@@ -1342,13 +1344,17 @@ at32_add_device_mci(unsigned int id, str
 				ARRAY_SIZE(atmel_mci0_resource)))
 		goto fail;
 
-	dws->dma_dev = &dw_dmac0_device.dev;
-	dws->reg_width = DW_DMA_SLAVE_WIDTH_32BIT;
-	dws->cfg_hi = (DWC_CFGH_SRC_PER(0)
+	slave = kzalloc(sizeof(struct mci_dma_slave), GFP_KERNEL);
+
+	slave->sdata.dma_dev = &dw_dmac0_device.dev;
+	slave->sdata.reg_width = DW_DMA_SLAVE_WIDTH_32BIT;
+	slave->sdata.cfg_hi = (DWC_CFGH_SRC_PER(0)
 				| DWC_CFGH_DST_PER(1));
-	dws->cfg_lo &= ~(DWC_CFGL_HS_DST_POL
+	slave->sdata.cfg_lo &= ~(DWC_CFGL_HS_DST_POL
 				| DWC_CFGL_HS_SRC_POL);
 
+	data->dma_slave = slave;
+
 	if (platform_device_add_data(pdev, data,
 				sizeof(struct mci_platform_data)))
 		goto fail;
@@ -1414,6 +1420,8 @@ at32_add_device_mci(unsigned int id, str
 	return pdev;
 
 fail:
+	data->dma_slave = NULL;
+	kfree(slave);
 	platform_device_put(pdev);
 	return NULL;
 }
diff -puN /dev/null arch/avr32/mach-at32ap/include/mach/atmel-mci.h
--- /dev/null
+++ a/arch/avr32/mach-at32ap/include/mach/atmel-mci.h
@@ -0,0 +1,24 @@
+#ifndef __MACH_ATMEL_MCI_H
+#define __MACH_ATMEL_MCI_H
+
+#include <linux/dw_dmac.h>
+
+/**
+ * struct mci_dma_data - DMA data for MCI interface
+ */
+struct mci_dma_data {
+	struct dw_dma_slave	sdata;
+};
+
+/* accessor macros */
+#define	slave_data_ptr(s)	(&(s)->sdata)
+#define find_slave_dev(s)	((s)->sdata.dma_dev)
+
+#define	setup_dma_addr(s, t, r)	do {		\
+	if (s) {				\
+		(s)->sdata.tx_reg = (t);	\
+		(s)->sdata.rx_reg = (r);	\
+	}					\
+} while (0)
+
+#endif /* __MACH_ATMEL_MCI_H */
diff -puN drivers/mmc/host/atmel-mci.c~atmel-mci-change-use-of-dma-slave-interface drivers/mmc/host/atmel-mci.c
--- a/drivers/mmc/host/atmel-mci.c~atmel-mci-change-use-of-dma-slave-interface
+++ a/drivers/mmc/host/atmel-mci.c
@@ -25,6 +25,8 @@
 #include <linux/stat.h>
 
 #include <linux/mmc/host.h>
+
+#include <mach/atmel-mci.h>
 #include <linux/atmel-mci.h>
 
 #include <asm/io.h>
@@ -1584,14 +1586,43 @@ static void __exit atmci_cleanup_slot(st
 #ifdef CONFIG_MMC_ATMELMCI_DMA
 static bool filter(struct dma_chan *chan, void *slave)
 {
-	struct dw_dma_slave *dws = slave;
+	struct mci_dma_data	*sl = slave;
 
-	if (dws->dma_dev == chan->device->dev) {
-		chan->private = dws;
+	if (sl && find_slave_dev(sl) == chan->device->dev) {
+		chan->private = slave_data_ptr(sl);
 		return true;
-	} else
+	} else {
 		return false;
+	}
 }
+
+static void atmci_configure_dma(struct atmel_mci *host)
+{
+	struct mci_platform_data	*pdata;
+
+	if (host == NULL)
+		return;
+
+	pdata = host->pdev->dev.platform_data;
+
+	if (pdata && find_slave_dev(pdata->dma_slave)) {
+		dma_cap_mask_t mask;
+
+		setup_dma_addr(pdata->dma_slave,
+			       host->mapbase + MCI_TDR,
+			       host->mapbase + MCI_RDR);
+
+		/* Try to grab a DMA channel */
+		dma_cap_zero(mask);
+		dma_cap_set(DMA_SLAVE, mask);
+		host->dma.chan =
+			dma_request_channel(mask, filter, pdata->dma_slave);
+	}
+	if (!host->dma.chan)
+		dev_notice(&host->pdev->dev, "DMA not available, using PIO\n");
+}
+#else
+static void atmci_configure_dma(struct atmel_mci *host) {}
 #endif
 
 static int __init atmci_probe(struct platform_device *pdev)
@@ -1645,22 +1676,7 @@ static int __init atmci_probe(struct pla
 	if (ret)
 		goto err_request_irq;
 
-#ifdef CONFIG_MMC_ATMELMCI_DMA
-	if (pdata->dma_slave.dma_dev) {
-		struct dw_dma_slave *dws = &pdata->dma_slave;
-		dma_cap_mask_t mask;
-
-		dws->tx_reg = regs->start + MCI_TDR;
-		dws->rx_reg = regs->start + MCI_RDR;
-
-		/* Try to grab a DMA channel */
-		dma_cap_zero(mask);
-		dma_cap_set(DMA_SLAVE, mask);
-		host->dma.chan = dma_request_channel(mask, filter, dws);
-	}
-	if (!host->dma.chan)
-		dev_notice(&pdev->dev, "DMA not available, using PIO\n");
-#endif /* CONFIG_MMC_ATMELMCI_DMA */
+	atmci_configure_dma(host);
 
 	platform_set_drvdata(pdev, host);
 
diff -puN include/linux/atmel-mci.h~atmel-mci-change-use-of-dma-slave-interface include/linux/atmel-mci.h
--- a/include/linux/atmel-mci.h~atmel-mci-change-use-of-dma-slave-interface
+++ a/include/linux/atmel-mci.h
@@ -3,8 +3,6 @@
 
 #define ATMEL_MCI_MAX_NR_SLOTS	2
 
-#include <linux/dw_dmac.h>
