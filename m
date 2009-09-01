From: akpm@linux-foundation.org
Subject: + spi-handle-tx-only-rx-only.patch added to -mm tree
Date: Tue, 01 Sep 2009 14:04:28 -0700
Message-ID: <200909012104.n81L4ShB027008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57606 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752150AbZIAVFL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Sep 2009 17:05:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, m.szyprowski@samsung.com


The patch titled
     spi: handle TX-only/RX-only
has been added to the -mm tree.  Its filename is
     spi-handle-tx-only-rx-only.patch

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
Subject: spi: handle TX-only/RX-only
From: David Brownell <dbrownell@users.sourceforge.net>

Support two new half-duplex SPI implementation restrictions, for links
that talk to TX-only or RX-only devices.  (Existing half-duplex flavors
support both transfer directions, just not at the same time.)

Move spi_async() into the spi.c core, and stop inlining it.  Then make
that function perform error checks and reject messages that demand more
than the underlying controller can support.

Based on a patch from Marek Szyprowski which did this only for the
bitbanged GPIO driver.

Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi.c       |   59 ++++++++++++++++++++++++++++++++++++++
 include/linux/spi/spi.h |   39 +------------------------
 2 files changed, 62 insertions(+), 36 deletions(-)

diff -puN drivers/spi/spi.c~spi-handle-tx-only-rx-only drivers/spi/spi.c
--- a/drivers/spi/spi.c~spi-handle-tx-only-rx-only
+++ a/drivers/spi/spi.c
@@ -663,6 +663,65 @@ int spi_setup(struct spi_device *spi)
 }
 EXPORT_SYMBOL_GPL(spi_setup);
 
+/**
+ * spi_async - asynchronous SPI transfer
+ * @spi: device with which data will be exchanged
+ * @message: describes the data transfers, including completion callback
+ * Context: any (irqs may be blocked, etc)
+ *
+ * This call may be used in_irq and other contexts which can't sleep,
+ * as well as from task contexts which can sleep.
+ *
+ * The completion callback is invoked in a context which can't sleep.
+ * Before that invocation, the value of message->status is undefined.
+ * When the callback is issued, message->status holds either zero (to
+ * indicate complete success) or a negative error code.  After that
+ * callback returns, the driver which issued the transfer request may
+ * deallocate the associated memory; it's no longer in use by any SPI
+ * core or controller driver code.
+ *
+ * Note that although all messages to a spi_device are handled in
+ * FIFO order, messages may go to different devices in other orders.
+ * Some device might be higher priority, or have various "hard" access
+ * time requirements, for example.
+ *
+ * On detection of any fault during the transfer, processing of
+ * the entire message is aborted, and the device is deselected.
+ * Until returning from the associated message completion callback,
+ * no other spi_message queued to that device will be processed.
+ * (This rule applies equally to all the synchronous transfer calls,
+ * which are wrappers around this core asynchronous primitive.)
+ */
+int spi_async(struct spi_device *spi, struct spi_message *message)
+{
+	struct spi_master *master = spi->master;
+
+	/* Half-duplex links include original MicroWire, and ones with
+	 * only one data pin like SPI_3WIRE (switches direction) or where
+	 * either MOSI or MISO is missing.  They can also be caused by
+	 * software limitations.
+	 */
+	if ((master->flags & SPI_MASTER_HALF_DUPLEX)
+			|| (spi->mode & SPI_3WIRE)) {
+		struct spi_transfer *xfer;
+		unsigned flags = master->flags;
+
+		list_for_each_entry(xfer, &message->transfers, transfer_list) {
+			if (xfer->rx_buf && xfer->tx_buf)
+				return -EINVAL;
+			if ((flags & SPI_MASTER_NO_TX) && xfer->tx_buf)
+				return -EINVAL;
+			if ((flags & SPI_MASTER_NO_RX) && xfer->rx_buf)
+				return -EINVAL;
+		}
+	}
+
+	message->spi = spi;
+	message->status = -EINPROGRESS;
+	return master->transfer(spi, message);
+}
+EXPORT_SYMBOL_GPL(spi_async);
+
 
 /*-------------------------------------------------------------------------*/
 
diff -puN include/linux/spi/spi.h~spi-handle-tx-only-rx-only include/linux/spi/spi.h
--- a/include/linux/spi/spi.h~spi-handle-tx-only-rx-only
+++ a/include/linux/spi/spi.h
@@ -258,6 +258,8 @@ struct spi_master {
 	/* other constraints relevant to this driver */
 	u16			flags;
 #define SPI_MASTER_HALF_DUPLEX	BIT(0)		/* can't do full duplex */
+#define SPI_MASTER_NO_RX	BIT(1)		/* can't do buffer read */
+#define SPI_MASTER_NO_TX	BIT(2)		/* can't do buffer write */
 
 	/* Setup mode and clock, etc (spi driver may call many times).
 	 *
@@ -538,42 +540,7 @@ static inline void spi_message_free(stru
 }
 
 extern int spi_setup(struct spi_device *spi);
-
-/**
- * spi_async - asynchronous SPI transfer
- * @spi: device with which data will be exchanged
- * @message: describes the data transfers, including completion callback
- * Context: any (irqs may be blocked, etc)
- *
- * This call may be used in_irq and other contexts which can't sleep,
- * as well as from task contexts which can sleep.
- *
- * The completion callback is invoked in a context which can't sleep.
- * Before that invocation, the value of message->status is undefined.
- * When the callback is issued, message->status holds either zero (to
- * indicate complete success) or a negative error code.  After that
- * callback returns, the driver which issued the transfer request may
- * deallocate the associated memory; it's no longer in use by any SPI
- * core or controller driver code.
- *
- * Note that although all messages to a spi_device are handled in
- * FIFO order, messages may go to different devices in other orders.
- * Some device might be higher priority, or have various "hard" access
- * time requirements, for example.
- *
- * On detection of any fault during the transfer, processing of
- * the entire message is aborted, and the device is deselected.
- * Until returning from the associated message completion callback,
- * no other spi_message queued to that device will be processed.
- * (This rule applies equally to all the synchronous transfer calls,
- * which are wrappers around this core asynchronous primitive.)
- */
-static inline int
-spi_async(struct spi_device *spi, struct spi_message *message)
-{
-	message->spi = spi;
-	return spi->master->transfer(spi, message);
-}
+extern int spi_async(struct spi_device *spi, struct spi_message *message);
 
 /*---------------------------------------------------------------------------*/
 
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

linux-next.patch
mtd-nand-add-page-parameter-to-all-read_page-read_page_raw-apis.patch
mtd-nand-add-new-ecc-mode-ecc_hw_oob_first.patch
mtd-nand-davinci-add-4-bit-ecc-support-for-large-page-nand-chips.patch
mtd-nand-davinci-add-4-bit-ecc-support-for-large-page-nand-chips-update.patch
mmc-register-mmci-omap-hs-using-platform_driver_probe.patch
spi-omap2_mcspi-use-bitn.patch
spi-add-spi_ppc4xx-driver.patch
spih-add-missing-kernel-doc-for-struct-spi_master.patch
spi-add-default-selection-of-pl022-for-arm-reference-platforms.patch
spi-add-support-for-device-table-matching.patch
mtd-m25p80-convert-to-device-table-matching.patch
of-remove-stmm25p40-alias.patch
hwmon-adxx-convert-to-device-table-matching.patch
hwmon-lm70-convert-to-device-table-matching.patch
spi-prefix-modalias-with-spi.patch
pxa2xx_spi-register-earlier.patch
spi-freescale-stmp-driver.patch
spi-mcspi-off-mode-support.patch
spi-mcspi-saves-chconfx-too.patch
spi-mcspi-support-for-omap4.patch
spi-handle-tx-only-rx-only.patch
rtc-at91rm9200-fixes.patch
rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
gpiolib-add-names-file-in-gpio-chip-sysfs-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs-checkpatch-fixes-fix.patch
gpiolib-allow-poll-on-value.patch
omapfb-add-support-for-the-2430sdp-lcd.patch
omapfb-add-support-for-the-omap2evm-lcd.patch
omapfb-add-support-for-the-omap3-evm-lcd.patch
omapfb-add-support-for-the-omap3-beagle-dvi-output.patch

