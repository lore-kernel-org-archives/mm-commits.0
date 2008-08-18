From: akpm@linux-foundation.org
Subject: - spi-bugfix-spi_add_device-with-duplicate-chipselects.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:40:20 -0700
Message-ID: <200808181940.m7IJeKY2008445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765679AbYHRTqr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:46:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: bugfix spi_add_device() with duplicate chipselects
has been removed from the -mm tree.  Its filename was
     spi-bugfix-spi_add_device-with-duplicate-chipselects.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: bugfix spi_add_device() with duplicate chipselects
From: David Brownell <dbrownell@users.sourceforge.net>

When reviewing a recent patch I noticed a potential trouble spot in the
registration of new SPI devices.  The SPI master driver is told to set the
device up before adding it to the driver model, so that it's always
properly set up when probe() is called.  (This is important, because in
the case of inverted chipselects, this device can make the bus misbehave
until it's properly deselected.  It's got to be set up even if no driver
binds to the device.)

The trouble spot is that it doesn't first verify that no other device has
been added using that chipselect.  If such a device has been added, its
configuration gets trashed.  (Fortunately this has not been a common
error!)

The fix here adds an explicit check, and a mutex to protect the relevant
critical region.

[akpm@linux-foundation.org: make the lock local to spi_add_device()]
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi.c |   40 +++++++++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 11 deletions(-)

diff -puN drivers/spi/spi.c~spi-bugfix-spi_add_device-with-duplicate-chipselects drivers/spi/spi.c
--- a/drivers/spi/spi.c~spi-bugfix-spi_add_device-with-duplicate-chipselects
+++ a/drivers/spi/spi.c
@@ -226,10 +226,11 @@ EXPORT_SYMBOL_GPL(spi_alloc_device);
  * Companion function to spi_alloc_device.  Devices allocated with
  * spi_alloc_device can be added onto the spi bus with this function.
  *
- * Returns 0 on success; non-zero on failure
+ * Returns 0 on success; negative errno on failure
  */
 int spi_add_device(struct spi_device *spi)
 {
+	static DEFINE_MUTEX(spi_add_lock);
 	struct device *dev = spi->master->dev.parent;
 	int status;
 
@@ -246,26 +247,43 @@ int spi_add_device(struct spi_device *sp
 			"%s.%u", spi->master->dev.bus_id,
 			spi->chip_select);
 
-	/* drivers may modify this initial i/o setup */
+
+	/* We need to make sure there's no other device with this
+	 * chipselect **BEFORE** we call setup(), else we'll trash
+	 * its configuration.  Lock against concurrent add() calls.
+	 */
+	mutex_lock(&spi_add_lock);
+
+	if (bus_find_device_by_name(&spi_bus_type, NULL, spi->dev.bus_id)
+			!= NULL) {
+		dev_err(dev, "chipselect %d already in use\n",
+				spi->chip_select);
+		status = -EBUSY;
+		goto done;
+	}
+
+	/* Drivers may modify this initial i/o setup, but will
+	 * normally rely on the device being setup.  Devices
+	 * using SPI_CS_HIGH can't coexist well otherwise...
+	 */
 	status = spi->master->setup(spi);
 	if (status < 0) {
 		dev_err(dev, "can't %s %s, status %d\n",
 				"setup", spi->dev.bus_id, status);
-		return status;
+		goto done;
 	}
 
-	/* driver core catches callers that misbehave by defining
-	 * devices that already exist.
-	 */
+	/* Device may be bound to an active driver when this returns */
 	status = device_add(&spi->dev);
-	if (status < 0) {
+	if (status < 0)
 		dev_err(dev, "can't %s %s, status %d\n",
 				"add", spi->dev.bus_id, status);
-		return status;
-	}
+	else
+		dev_dbg(dev, "registered child %s\n", spi->dev.bus_id);
 
-	dev_dbg(dev, "registered child %s\n", spi->dev.bus_id);
-	return 0;
+done:
+	mutex_unlock(&spi_add_lock);
+	return status;
 }
 EXPORT_SYMBOL_GPL(spi_add_device);
 
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
linux-next.patch
rtc-ds1307-alarm-support-for-ds1337-ds1339.patch
rtc-remove-some-nop-open-release-methods.patch
legacy-rtc-remove-needless-confusing-hpet_rtc_irq-option.patch
rtc-file-close-consistently-disables-repeating-irqs.patch
irq-warn-about-irqf_disabledirqf_shared.patch

