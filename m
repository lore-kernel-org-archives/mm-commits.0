From: akpm@linux-foundation.org
Subject: [merged] rapidio-tsi721-add-shutdown-notification-callback.patch
 removed from -mm tree
Date: Wed, 23 Mar 2016 10:41:29 -0700
Message-ID: <56f2d549.xeWRKT2ANSmWE1A2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59200 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756645AbcCWRla (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:41:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721: add shutdown notification callback
has been removed from the -mm tree.  Its filename was
     rapidio-tsi721-add-shutdown-notification-callback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio/tsi721: add shutdown notification callback

Add device driver specific shutdown notification callback.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/devices/tsi721.c     |   15 ++++++++++++
 drivers/rapidio/devices/tsi721.h     |    3 ++
 drivers/rapidio/devices/tsi721_dma.c |   30 +++++++++++++++++++++++++
 3 files changed, 48 insertions(+)

diff -puN drivers/rapidio/devices/tsi721.c~rapidio-tsi721-add-shutdown-notification-callback drivers/rapidio/devices/tsi721.c
--- a/drivers/rapidio/devices/tsi721.c~rapidio-tsi721-add-shutdown-notification-callback
+++ a/drivers/rapidio/devices/tsi721.c
@@ -2638,6 +2638,8 @@ static int tsi721_probe(struct pci_dev *
 	if (err)
 		goto err_free_consistent;
 
+	pci_set_drvdata(pdev, priv);
+
 	return 0;
 
 err_free_consistent:
@@ -2660,6 +2662,18 @@ err_exit:
 	return err;
 }
 
+static void tsi721_shutdown(struct pci_dev *pdev)
+{
+	struct tsi721_device *priv = pci_get_drvdata(pdev);
+
+	dev_dbg(&pdev->dev, "RIO: %s\n", __func__);
+
+	tsi721_disable_ints(priv);
+	tsi721_dma_stop_all(priv);
+	pci_clear_master(pdev);
+	pci_disable_device(pdev);
+}
+
 static const struct pci_device_id tsi721_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_IDT, PCI_DEVICE_ID_TSI721) },
 	{ 0, }	/* terminate list */
@@ -2671,6 +2685,7 @@ static struct pci_driver tsi721_driver =
 	.name		= "tsi721",
 	.id_table	= tsi721_pci_tbl,
 	.probe		= tsi721_probe,
+	.shutdown	= tsi721_shutdown,
 };
 
 static int __init tsi721_init(void)
diff -puN drivers/rapidio/devices/tsi721.h~rapidio-tsi721-add-shutdown-notification-callback drivers/rapidio/devices/tsi721.h
--- a/drivers/rapidio/devices/tsi721.h~rapidio-tsi721-add-shutdown-notification-callback
+++ a/drivers/rapidio/devices/tsi721.h
@@ -866,6 +866,9 @@ struct tsi721_device {
 #ifdef CONFIG_RAPIDIO_DMA_ENGINE
 extern void tsi721_bdma_handler(struct tsi721_bdma_chan *bdma_chan);
 extern int tsi721_register_dma(struct tsi721_device *priv);
+extern void tsi721_dma_stop_all(struct tsi721_device *priv);
+#else
+#define tsi721_dma_stop_all(priv) do {} while (0)
 #endif
 
 #endif
diff -puN drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721-add-shutdown-notification-callback drivers/rapidio/devices/tsi721_dma.c
--- a/drivers/rapidio/devices/tsi721_dma.c~rapidio-tsi721-add-shutdown-notification-callback
+++ a/drivers/rapidio/devices/tsi721_dma.c
@@ -852,6 +852,36 @@ static int tsi721_terminate_all(struct d
 	return 0;
 }
 
+static void tsi721_dma_stop(struct tsi721_bdma_chan *bdma_chan)
+{
+	if (!bdma_chan->active)
+		return;
+	spin_lock_bh(&bdma_chan->lock);
+	if (!tsi721_dma_is_idle(bdma_chan)) {
+		int timeout = 100000;
+
+		/* stop the transfer in progress */
+		iowrite32(TSI721_DMAC_CTL_SUSP,
+			  bdma_chan->regs + TSI721_DMAC_CTL);
+
+		/* Wait until DMA channel stops */
+		while (!tsi721_dma_is_idle(bdma_chan) && --timeout)
+			udelay(1);
+	}
+
+	spin_unlock_bh(&bdma_chan->lock);
+}
+
+void tsi721_dma_stop_all(struct tsi721_device *priv)
+{
+	int i;
+
+	for (i = 0; i < TSI721_DMA_MAXCH; i++) {
+		if (i != TSI721_DMACH_MAINT)
+			tsi721_dma_stop(&priv->bdma[i]);
+	}
+}
+
 int tsi721_register_dma(struct tsi721_device *priv)
 {
 	int i;
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are


