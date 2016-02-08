From: akpm@linux-foundation.org
Subject: + rapidio-tsi721-add-shutdown-notification-callback.patch added
 to -mm tree
Date: Mon, 08 Feb 2016 13:22:12 -0800
Message-ID: <56b90704.HhBwF2hFf2+BzEse%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35778 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267AbcBHVWN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2016 16:22:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, a-jacquiot@ti.com, andre.van.herk@prodrive-technologies.com, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: rapidio/tsi721: add shutdown notification callback
has been added to the -mm tree.  Its filename is
     rapidio-tsi721-add-shutdown-notification-callback.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rapidio-tsi721-add-shutdown-notification-callback.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rapidio-tsi721-add-shutdown-notification-callback.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

rapidio-tsi721-fix-hardcoded-mrrs-setting.patch
rapidio-tsi721-add-check-for-overlapped-ib-window-mappings.patch
rapidio-tsi721-add-option-to-configure-direct-mapping-of-ib-window.patch
rapidio-tsi721_dma-fix-pending-transaction-queue-handling.patch
rapidio-add-query_mport-operation.patch
rapidio-tsi721-add-query_mport-callback.patch
rapidio-add-shutdown-notification-for-rapidio-devices.patch
rapidio-tsi721-add-shutdown-notification-callback.patch
rapidio-rionet-add-shutdown-event-handling.patch
rapidio-rework-common-rio-device-add-delete-routines.patch
rapidio-move-net-allocation-into-core-code.patch
rapidio-add-core-mport-removal-support.patch
rapidio-tsi721-add-hw-specific-mport-removal.patch
powerpc-fsl_rio-changes-to-mport-registration.patch
rapidio-rionet-add-locking-into-add-remove-device.patch
rapidio-rionet-add-mport-removal-handling.patch
rapidio-add-lock-protection-for-doorbell-list.patch
rapidio-move-rio_local_set_device_id-function-to-the-common-core.patch
rapidio-move-rio_pw_enable-into-core-code.patch
rapidio-add-global-inbound-port-write-interfaces.patch
rapidio-tsi721-fix-locking-in-ob_msg-processing.patch
rapidio-add-outbound-window-support.patch
rapidio-tsi721-add-outbound-windows-mapping-support.patch
rapidio-tsi721-add-filtered-debug-output.patch
rapidio-tsi721_dma-update-error-reporting-from-prep_sg-callback.patch
rapidio-tsi721_dma-fix-synchronization-issues.patch
rapidio-tsi721_dma-fix-hardware-error-handling.patch
rapidio-add-mport-char-device-driver.patch

