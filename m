From: akpm@linux-foundation.org
Subject: + spi-dma-support-for-designware-core-on-moorestown-platform.patch added to -mm tree
Date: Mon, 12 Oct 2009 15:26:21 -0700
Message-ID: <200910122226.n9CMQL9j003532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60867 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933461AbZJLW1D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Oct 2009 18:27:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: feng.tang@intel.com, david-b@pacbell.net


The patch titled
     spi: DMA support for Designware core on Moorestown platform
has been added to the -mm tree.  Its filename is
     spi-dma-support-for-designware-core-on-moorestown-platform.patch

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
Subject: spi: DMA support for Designware core on Moorestown platform
From: Feng Tang <feng.tang@intel.com>

Designware core can work with multiple DMA controllers for DMA operation,
and this patch supports it to cowork with the Designware DMA controller
used on Intel Moorestown platform

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/spi/Kconfig~spi-dma-support-for-designware-core-on-moorestown-platform drivers/spi/Kconfig
--- a/drivers/spi/Kconfig~spi-dma-support-for-designware-core-on-moorestown-platform
+++ a/drivers/spi/Kconfig
@@ -265,6 +265,10 @@ config SPI_DESIGNWARE
 	help
 	  general driver for SPI controller core from DesignWare
 
+config SPI_DW_MRST_DMA
+	bool "DMA support for DW SPI controller on Intel Moorestown platform"
+	depends on SPI_DESGINWARE && MRST_DMA
+
 config SPI_DW_PCI
 	tristate "PCI interface driver for DW SPI core"
 	depends on SPI_DESIGNWARE && PCI
diff -puN drivers/spi/dw_spi.c~spi-dma-support-for-designware-core-on-moorestown-platform drivers/spi/dw_spi.c
--- a/drivers/spi/dw_spi.c~spi-dma-support-for-designware-core-on-moorestown-platform
+++ a/drivers/spi/dw_spi.c
@@ -29,6 +29,10 @@
 #include <linux/debugfs.h>
 #endif
 
+#ifdef CONFIG_SPI_MRST_DMA
+#include <linux/lnw_dma.h>
+#endif
+
 #define START_STATE	((void *)0)
 #define RUNNING_STATE	((void *)1)
 #define DONE_STATE	((void *)2)
@@ -62,6 +66,166 @@ struct chip_data {
 	void (*cs_control)(u32 command);
 };
 
+#ifdef CONFIG_SPI_MRST_DMA
+static void dw_spi_dma_init(struct dw_spi *dws)
+{
+	struct lnw_dma_slave *rxs, *txs;
+	dma_cap_mask_t mask;
+
+	dws->txchan = NULL;
+	dws->rxchan = NULL;
+
+	/* 1. Init rx channel */
+	rxs = &dws->dmas_rx;
+
+	rxs->dirn = DMA_FROM_DEVICE;
+	rxs->hs_mode = LNW_DMA_HW_HS;
+	rxs->cfg_mode = LNW_DMA_PER_TO_MEM;
+	rxs->src_width = LNW_DMA_WIDTH_16BIT;
+	rxs->dst_width = LNW_DMA_WIDTH_32BIT;
+	rxs->src_msize = LNW_DMA_MSIZE_16;
+	rxs->dst_msize = LNW_DMA_MSIZE_16;
+
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_MEMCPY, mask);
+	dma_cap_set(DMA_SLAVE, mask);
+
+	dws->rxchan = dma_request_channel(mask, NULL, NULL);
+	if (!dws->rxchan)
+		goto err_exit;
+	dws->rxchan->private = rxs;
+
+	/* 2. Init tx channel */
+	txs = &dws->dmas_tx;
+
+	txs->dirn = DMA_TO_DEVICE;
+	txs->hs_mode = LNW_DMA_HW_HS;
+	txs->cfg_mode = LNW_DMA_MEM_TO_PER;
+	txs->src_width = LNW_DMA_WIDTH_32BIT;
+	txs->dst_width = LNW_DMA_WIDTH_16BIT;
+	txs->src_msize = LNW_DMA_MSIZE_16;
+	txs->dst_msize = LNW_DMA_MSIZE_16;
+
+	dma_cap_set(DMA_SLAVE, mask);
+	dma_cap_set(DMA_MEMCPY, mask);
+
+	dws->txchan = dma_request_channel(mask, NULL, NULL);
+	if (!dws->txchan)
+		goto free_rxchan;
+	dws->txchan->private = txs;
+
+	/* Set the dma done bit to 1 */
+	dws->dma_inited = 1;
+	dws->txdma_done = 1;
+	dws->rxdma_done = 1;
+
+	dws->tx_param = ((u64)(unsigned long)dws << 32)
+				| (unsigned long)(&dws->txdma_done);
+	dws->rx_param = ((u64)(unsigned long)dws << 32)
+				| (unsigned long)(&dws->rxdma_done);
+	return;
+
+free_rxchan:
+	dma_release_channel(dws->rxchan);
+err_exit:
+	return;
+}
+
+static void dw_spi_dma_exit(struct dw_spi *dws)
+{
+	dma_release_channel(dws->txchan);
+	dma_release_channel(dws->rxchan);
+}
+
+static void transfer_complete(struct dw_spi *dws);
+
+static void dw_spi_dma_done(void *arg)
+{
+	u64 *param = arg;
+	struct dw_spi *dws;
+	int *done;
+
+	dws = (struct dw_spi *)(unsigned long)(*param >> 32);
+	done = (int *)(unsigned long)(*param & 0xffffffff);
+
+	*done = 1;
+	/* wait till both tx/rx channels are done */
+	if (!dws->txdma_done || !dws->rxdma_done)
+		return;
+
+	transfer_complete(dws);
+}
+
+static void dma_transfer(struct dw_spi *dws, int cs_change)
+{
+	struct dma_async_tx_descriptor *txdesc = NULL, *rxdesc = NULL;
+	struct dma_chan *txchan, *rxchan;
+	enum dma_ctrl_flags flag;
+	u16 dma_ctrl = 0;
+
+	/* 1. setup DMA related registers */
+	if (cs_change) {
+		spi_enable_chip(dws, 0);
+		dw_writew(dws, dmardlr, 0xf);
+		dw_writew(dws, dmatdlr, 0x10);
+		if (dws->tx_dma)
+			dma_ctrl |= 0x2;
+		if (dws->rx_dma)
+			dma_ctrl |= 0x1;
+		dw_writew(dws, dmacr, dma_ctrl);
+		spi_enable_chip(dws, 1);
+	}
+
+	if (dws->tx_dma)
+		dws->txdma_done = 0;
+	if (dws->rx_dma)
+		dws->rxdma_done = 0;
+
+	/* 2. start the TX dma transfer */
+	txchan = dws->txchan;
+	rxchan = dws->rxchan;
+
+	flag = DMA_PREP_INTERRUPT | DMA_CTRL_ACK;
+	if (dws->tx_dma) {
+		txdesc = txchan->device->device_prep_dma_memcpy(txchan,
+				dws->dma_addr, dws->tx_dma,
+				dws->len, flag);
+		txdesc->callback = dw_spi_dma_done;
+		txdesc->callback_param = &dws->tx_param;
+	}
+
+	/* 3. start the RX dma transfer */
+	if (dws->rx_dma) {
+		rxdesc = rxchan->device->device_prep_dma_memcpy(rxchan,
+				dws->rx_dma, dws->dma_addr,
+				dws->len, flag);
+		rxdesc->callback = dw_spi_dma_done;
+		rxdesc->callback_param = &dws->rx_param;
+	}
+
+	/* rx must be started before tx due to spi instinct */
+	if (rxdesc)
+		rxdesc->tx_submit(rxdesc);
+	if (txdesc)
+		txdesc->tx_submit(txdesc);
+}
+#else
+static inline void dw_spi_dma_init(struct dw_spi *dws)
+{
+	return;
+}
+
+static inline void dw_spi_dma_exit(struct dw_spi *dws)
+{
+	return;
+}
+
+static void dma_transfer(struct dw_spi *dws, int cs_change)
+{
+	return;
+}
+#endif /* CONFIG_SPI_MRST_DMA */
+
 #ifdef CONFIG_DEBUG_FS
 static int spi_show_regs_open(struct inode *inode, struct file *file)
 {
@@ -413,10 +577,6 @@ static void poll_transfer(struct dw_spi 
 	transfer_complete(dws);
 }
 
-static void dma_transfer(struct dw_spi *dws, int cs_change)
-{
-}
-
 static void pump_transfers(unsigned long data)
 {
 	struct dw_spi *dws = (struct dw_spi *)data;
@@ -853,6 +1013,7 @@ int __devinit dw_spi_add_host(struct dw_
 	master->transfer = dw_spi_transfer;
 
 	dws->dma_inited = 0;
+	dw_spi_dma_init(dws);
 
 	/* Basic HW init */
 	spi_hw_init(dws);
@@ -881,6 +1042,7 @@ int __devinit dw_spi_add_host(struct dw_
 
 err_queue_alloc:
 	destroy_queue(dws);
+	dw_spi_dma_exit(dws);
 err_diable_hw:
 	spi_enable_chip(dws, 0);
 	free_irq(dws->irq, dws);
@@ -904,6 +1066,7 @@ void __devexit dw_spi_remove_host(struct
 		dev_err(&dws->master->dev, "dw_spi_remove: workqueue will not "
 			"complete, message memory not freed\n");
 
+	dw_spi_dma_exit(dws);
 	spi_enable_chip(dws, 0);
 	/* Disable clk */
 	spi_set_clk(dws, 0);
diff -puN include/linux/spi/dw_spi.h~spi-dma-support-for-designware-core-on-moorestown-platform include/linux/spi/dw_spi.h
--- a/include/linux/spi/dw_spi.h~spi-dma-support-for-designware-core-on-moorestown-platform
+++ a/include/linux/spi/dw_spi.h
@@ -1,6 +1,7 @@
 #ifndef DW_SPI_HEADER_H
 #define DW_SPI_HEADER_H
 #include <linux/io.h>
+#include <linux/lnw_dma.h>
 
 /* Bit fields in CTRLR0 */
 #define SPI_DFS_OFFSET			0
@@ -141,6 +142,11 @@ struct dw_spi {
 	struct device		*dma_dev;
 	dma_addr_t		dma_addr;
 
+#ifdef CONFIG_SPI_MRST_DMA
+	struct lnw_dma_slave	dmas_tx;
+	struct lnw_dma_slave	dmas_rx;
+#endif
+
 	/* Bus interface info */
 	void			*priv;
 #ifdef CONFIG_DEBUG_FS
_

Patches currently in -mm which might be from feng.tang@intel.com are

hrtimers-remove-the-timer_stats_active-check-when-setting-the-start-info.patch
spi-controller-driver-for-designware-spi-core.patch
spi-add-pci-interface-driver-for-designware-spi-core.patch
spi-dma-support-for-designware-core-on-moorestown-platform.patch

