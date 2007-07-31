From: akpm@linux-foundation.org
Subject: - spi-device-setup-gets-better-error-checking.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:59:09 -0700
Message-ID: <200707312359.l6VNx9Qh029627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59097 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760749AbXHAAQw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:16:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi device setup gets better error checking
has been removed from the -mm tree.  Its filename was
     spi-device-setup-gets-better-error-checking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi device setup gets better error checking
From: David Brownell <david-b@pacbell.net>

This updates some error reporting paths in SPI device setup:

 - Move validation logic for SPI chipselects to spi_new_device(),
   which is where it should always have been.

 - In spi_new_device(), emit error messages if the device can't
   be created.  This is LOTS better than a silent failure; though
   eventually, the calling convention should probably change to
   use the <linux/err.h> conventions.

 - Includes one previously-missing check:  SPI masters must always
   have at least one chipselect, even for dedicated busses which
   always keep it selected!

It also adds a FIXME (IDR for dynamic ID allocation) so the issue doesn't live
purely in my mailbox.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi.c |   45 +++++++++++++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 15 deletions(-)

diff -puN drivers/spi/spi.c~spi-device-setup-gets-better-error-checking drivers/spi/spi.c
--- a/drivers/spi/spi.c~spi-device-setup-gets-better-error-checking
+++ a/drivers/spi/spi.c
@@ -200,6 +200,8 @@ static DEFINE_MUTEX(board_lock);
  * platforms may not be able to use spi_register_board_info though, and
  * this is exported so that for example a USB or parport based adapter
  * driver could add devices (which it would learn about out-of-band).
+ *
+ * Returns the new device, or NULL.
  */
 struct spi_device *spi_new_device(struct spi_master *master,
 				  struct spi_board_info *chip)
@@ -208,7 +210,20 @@ struct spi_device *spi_new_device(struct
 	struct device		*dev = master->cdev.dev;
 	int			status;
 
-	/* NOTE:  caller did any chip->bus_num checks necessary */
+	/* NOTE:  caller did any chip->bus_num checks necessary.
+	 *
+	 * Also, unless we change the return value convention to use
+	 * error-or-pointer (not NULL-or-pointer), troubleshootability
+	 * suggests syslogged diagnostics are best here (ugh).
+	 */
+
+	/* Chipselects are numbered 0..max; validate. */
+	if (chip->chip_select >= master->num_chipselect) {
+		dev_err(dev, "cs%d > max %d\n",
+			chip->chip_select,
+			master->num_chipselect);
+		return NULL;
+	}
 
 	if (!spi_master_get(master))
 		return NULL;
@@ -236,10 +251,10 @@ struct spi_device *spi_new_device(struct
 	proxy->controller_state = NULL;
 	proxy->dev.release = spidev_release;
 
-	/* drivers may modify this default i/o setup */
+	/* drivers may modify this initial i/o setup */
 	status = master->setup(proxy);
 	if (status < 0) {
-		dev_dbg(dev, "can't %s %s, status %d\n",
+		dev_err(dev, "can't %s %s, status %d\n",
 				"setup", proxy->dev.bus_id, status);
 		goto fail;
 	}
@@ -249,7 +264,7 @@ struct spi_device *spi_new_device(struct
 	 */
 	status = device_register(&proxy->dev);
 	if (status < 0) {
-		dev_dbg(dev, "can't %s %s, status %d\n",
+		dev_err(dev, "can't %s %s, status %d\n",
 				"add", proxy->dev.bus_id, status);
 		goto fail;
 	}
@@ -306,7 +321,6 @@ spi_register_board_info(struct spi_board
 static void scan_boardinfo(struct spi_master *master)
 {
 	struct boardinfo	*bi;
-	struct device		*dev = master->cdev.dev;
 
 	mutex_lock(&board_lock);
 	list_for_each_entry(bi, &board_list, list) {
@@ -316,17 +330,9 @@ static void scan_boardinfo(struct spi_ma
 		for (n = bi->n_board_info; n > 0; n--, chip++) {
 			if (chip->bus_num != master->bus_num)
 				continue;
-			/* some controllers only have one chip, so they
-			 * might not use chipselects.  otherwise, the
-			 * chipselects are numbered 0..max.
+			/* NOTE: this relies on spi_new_device to
+			 * issue diagnostics when given bogus inputs
 			 */
-			if (chip->chip_select >= master->num_chipselect
-					&& master->num_chipselect) {
-				dev_dbg(dev, "cs%d > max %d\n",
-					chip->chip_select,
-					master->num_chipselect);
-				continue;
-			}
 			(void) spi_new_device(master, chip);
 		}
 	}
@@ -419,8 +425,17 @@ int spi_register_master(struct spi_maste
 	if (!dev)
 		return -ENODEV;
 
+	/* even if it's just one always-selected device, there must
+	 * be at least one chipselect
+	 */
+	if (master->num_chipselect == 0)
+		return -EINVAL;
+
 	/* convention:  dynamically assigned bus IDs count down from the max */
 	if (master->bus_num < 0) {
+		/* FIXME switch to an IDR based scheme, something like
+		 * I2C now uses, so we can't run out of "dynamic" IDs
+		 */
 		master->bus_num = atomic_dec_return(&dyn_bus_id);
 		dynamic = 1;
 	}
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
git-mmc.patch
git-mtd.patch
dma_free_coherent-needs-irqs-enabled-sigh.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91.patch
clean-up-duplicate-includes-in-drivers-spi.patch
rtc_irq_set_freq-requires-power-of-two-and-associated-kerneldoc.patch
