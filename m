From: akpm@linux-foundation.org
Subject: + spi-bugfix-spi_add_device-with-duplicate-chipselects.patch added to -mm tree
Date: Thu, 14 Aug 2008 14:14:45 -0700
Message-ID: <200808142114.m7ELEktJ029909@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753703AbYHNVP2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Aug 2008 17:15:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net


The patch titled
     spi: bugfix spi_add_device() with duplicate chipselects
has been added to the -mm tree.  Its filename is
     spi-bugfix-spi_add_device-with-duplicate-chipselects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi.c |   41 ++++++++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 11 deletions(-)

diff -puN drivers/spi/spi.c~spi-bugfix-spi_add_device-with-duplicate-chipselects drivers/spi/spi.c
--- a/drivers/spi/spi.c~spi-bugfix-spi_add_device-with-duplicate-chipselects
+++ a/drivers/spi/spi.c
@@ -219,6 +219,8 @@ struct spi_device *spi_alloc_device(stru
 }
 EXPORT_SYMBOL_GPL(spi_alloc_device);
 
+static DEFINE_MUTEX(spi_add_lock);
+
 /**
  * spi_add_device - Add spi_device allocated with spi_alloc_device
  * @spi: spi_device to register
@@ -226,7 +228,7 @@ EXPORT_SYMBOL_GPL(spi_alloc_device);
  * Companion function to spi_alloc_device.  Devices allocated with
  * spi_alloc_device can be added onto the spi bus with this function.
  *
- * Returns 0 on success; non-zero on failure
+ * Returns 0 on success; negative errno on failure
  */
 int spi_add_device(struct spi_device *spi)
 {
@@ -246,26 +248,43 @@ int spi_add_device(struct spi_device *sp
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

spi-bugfix-spi_add_device-with-duplicate-chipselects.patch
spi-bugfix-spi_add_device-with-duplicate-chipselects-cleanup.patch
linux-next.patch
usb-hso-driver-fix-kconfig.patch
rtc-ds1307-alarm-support-for-ds1337-ds1339.patch
rtc-remove-some-nop-open-release-methods.patch
legacy-rtc-remove-needless-confusing-hpet_rtc_irq-option.patch
rtc-file-close-consistently-disables-repeating-irqs.patch
irq-warn-about-irqf_disabledirqf_shared.patch

