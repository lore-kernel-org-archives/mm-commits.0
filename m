From: akpm@linux-foundation.org
Subject: + atmel-mci-change-use-of-dma-slave-interface.patch added to -mm tree
Date: Tue, 29 Sep 2009 12:31:00 -0700
Message-ID: <200909291931.n8TJV1SF000571@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41515 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752855AbZI2Tbe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 15:31:34 -0400
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

 arch/avr32/mach-at32ap/at32ap700x.c |    6 +
 drivers/mmc/host/atmel-mci.c        |   82 +++++++++++++++++++-------
 include/linux/atmel-mci.h           |    3 
 3 files changed, 68 insertions(+), 23 deletions(-)

diff -puN arch/avr32/mach-at32ap/at32ap700x.c~atmel-mci-change-use-of-dma-slave-interface arch/avr32/mach-at32ap/at32ap700x.c
--- a/arch/avr32/mach-at32ap/at32ap700x.c~atmel-mci-change-use-of-dma-slave-interface
+++ a/arch/avr32/mach-at32ap/at32ap700x.c
@@ -1323,7 +1323,7 @@ struct platform_device *__init
 at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 {
 	struct platform_device		*pdev;
-	struct dw_dma_slave		*dws = &data->dma_slave;
+	struct dw_dma_slave		*dws;
 	u32				pioa_mask;
 	u32				piob_mask;
 
@@ -1342,6 +1342,8 @@ at32_add_device_mci(unsigned int id, str
 				ARRAY_SIZE(atmel_mci0_resource)))
 		goto fail;
 
+	dws = kzalloc(sizeof(struct dw_dma_slave), GFP_KERNEL);
+
 	dws->dma_dev = &dw_dmac0_device.dev;
 	dws->reg_width = DW_DMA_SLAVE_WIDTH_32BIT;
 	dws->cfg_hi = (DWC_CFGH_SRC_PER(0)
@@ -1349,6 +1351,8 @@ at32_add_device_mci(unsigned int id, str
 	dws->cfg_lo &= ~(DWC_CFGL_HS_DST_POL
 				| DWC_CFGL_HS_SRC_POL);
 
+	data->dma_slave = dws;
+
 	if (platform_device_add_data(pdev, data,
 				sizeof(struct mci_platform_data)))
 		goto fail;
diff -puN drivers/mmc/host/atmel-mci.c~atmel-mci-change-use-of-dma-slave-interface drivers/mmc/host/atmel-mci.c
--- a/drivers/mmc/host/atmel-mci.c~atmel-mci-change-use-of-dma-slave-interface
+++ a/drivers/mmc/host/atmel-mci.c
@@ -1582,16 +1582,71 @@ static void __exit atmci_cleanup_slot(st
 }
 
 #ifdef CONFIG_MMC_ATMELMCI_DMA
-static bool filter(struct dma_chan *chan, void *slave)
+static struct device *find_slave_dev(void *slave)
+{
+	if (!slave)
+		return NULL;
+
+	if (cpu_is_at32ap7000())
+		return ((struct dw_dma_slave *)slave)->dma_dev;
+	else
+		return ((struct at_dma_slave *)slave)->dma_dev;
+}
+
+static void setup_dma_addr(struct mci_platform_data *pdata,
+			dma_addr_t tx_addr, dma_addr_t rx_addr)
 {
-	struct dw_dma_slave *dws = slave;
+	if (!pdata)
+		return;
+
+	if (cpu_is_at32ap7000()) {
+		struct dw_dma_slave *dws = pdata->dma_slave;
+
+		dws->tx_reg = tx_addr;
+		dws->rx_reg = rx_addr;
+	} else {
+		struct at_dma_slave *ats = pdata->dma_slave;
 
-	if (dws->dma_dev == chan->device->dev) {
-		chan->private = dws;
+		ats->tx_reg = tx_addr;
+		ats->rx_reg = rx_addr;
+	}
+}
+
+static bool filter(struct dma_chan *chan, void *slave)
+{
+	if (find_slave_dev(slave) == chan->device->dev) {
+		chan->private = slave;
 		return true;
-	} else
+	} else {
 		return false;
+	}
+}
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
+		setup_dma_addr(pdata, host->mapbase + MCI_TDR,
+				      host->mapbase + MCI_RDR);
+
+		/* Try to grab a DMA channel */
+		dma_cap_zero(mask);
+		dma_cap_set(DMA_SLAVE, mask);
+		host->dma.chan = dma_request_channel(mask, filter, pdata->dma_slave);
+	}
+	if (!host->dma.chan)
+		dev_notice(&host->pdev->dev, "DMA not available, using PIO\n");
 }
+#else
+static void atmci_configure_dma(struct atmel_mci *host) {}
 #endif
 
 static int __init atmci_probe(struct platform_device *pdev)
@@ -1645,22 +1700,7 @@ static int __init atmci_probe(struct pla
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
@@ -4,6 +4,7 @@
 #define ATMEL_MCI_MAX_NR_SLOTS	2
 
 #include <linux/dw_dmac.h>
+#include <mach/at_hdmac.h>
 
 /**
  * struct mci_slot_pdata - board-specific per-slot configuration
@@ -34,7 +35,7 @@ struct mci_slot_pdata {
  * @slot: Per-slot configuration data.
  */
 struct mci_platform_data {
-	struct dw_dma_slave	dma_slave;
+	void			*dma_slave;
 	struct mci_slot_pdata	slot[ATMEL_MCI_MAX_NR_SLOTS];
 };
 
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

linux-next.patch
atmel-mci-change-use-of-dma-slave-interface.patch
mmc-atmel-mci-new-mci2-module-support-in-atmel-mci-driver.patch

