From: akpm@linux-foundation.org
Subject: + spi-core-stop-updating-dev-powerpower_state.patch added to -mm tree
Date: Tue, 04 Dec 2007 12:24:06 -0800
Message-ID: <200712042024.lB4KO6S9003307@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37335 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751331AbXLDUYu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 15:24:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     spi core: stop updating dev->power.power_state
has been added to the -mm tree.  Its filename is
     spi-core-stop-updating-dev-powerpower_state.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi core: stop updating dev->power.power_state
From: David Brownell <david-b@pacbell.net>

Don't update dev->power.power_state any more in the SPI core.  The only
reason to update this scheduled-to-be-removed field was to make the
already-removed /sys/devices/.../power/state files work better.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi.c |   34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff -puN drivers/spi/spi.c~spi-core-stop-updating-dev-powerpower_state drivers/spi/spi.c
--- a/drivers/spi/spi.c~spi-core-stop-updating-dev-powerpower_state
+++ a/drivers/spi/spi.c
@@ -76,39 +76,33 @@ static int spi_uevent(struct device *dev
 
 #ifdef	CONFIG_PM
 
-/*
- * NOTE:  the suspend() method for an spi_master controller driver
- * should verify that all its child devices are marked as suspended;
- * suspend requests delivered through sysfs power/state files don't
- * enforce such constraints.
- */
 static int spi_suspend(struct device *dev, pm_message_t message)
 {
-	int			value;
+	int			value = 0;
 	struct spi_driver	*drv = to_spi_driver(dev->driver);
 
-	if (!drv || !drv->suspend)
-		return 0;
-
 	/* suspend will stop irqs and dma; no more i/o */
-	value = drv->suspend(to_spi_device(dev), message);
-	if (value == 0)
-		dev->power.power_state = message;
+	if (drv) {
+		if (drv->suspend)
+			value = drv->suspend(to_spi_device(dev), message);
+		else
+			dev_dbg(dev, "... can't suspend\n");
+	}
 	return value;
 }
 
 static int spi_resume(struct device *dev)
 {
-	int			value;
+	int			value = 0;
 	struct spi_driver	*drv = to_spi_driver(dev->driver);
 
-	if (!drv || !drv->resume)
-		return 0;
-
 	/* resume may restart the i/o queue */
-	value = drv->resume(to_spi_device(dev));
-	if (value == 0)
-		dev->power.power_state = PMSG_ON;
+	if (drv) {
+		if (drv->resume)
+			value = drv->resume(to_spi_device(dev));
+		else
+			dev_dbg(dev, "... can't resume\n");
+	}
 	return value;
 }
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

rtc-assure-proper-memory-ordering-with-respect-to-rtc_dev_busy-flag.patch
spi-use-mutex-not-semaphore.patch
spi-at25-driver-is-for-eeprom-not-flash.patch
blackfin-spi-driver-use-cpu_relax-to-replace-continue-in-while-busywait.patch
blackfin-spi-driver-use-void-__iomem-for-regs_base.patch
blackfin-spi-driver-move-hard-coded-pin_req-to-board-file.patch
blackfin-spi-driver-reconfigure-speed_hz-and-bits_per_word-in-each-spi-transfer.patch
gpio_cs5535-disable-aux-on-output.patch
rtc-dont-write-rtc-century-when-setting-a-wake-alarm.patch
git-mmc.patch
git-mtd.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
remove-pointless-casts-from-void-pointers.patch
spi-core-stop-updating-dev-powerpower_state.patch
cosmetic-fixes-to-rtc-subsystems-kconfig.patch
rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
rtc-cmos-exports-nvram-in-sysfs.patch
rtc-cmos-alarm-acts-as-oneshot.patch
generic-gpio-gpio_chip-support.patch
generic-gpio-gpio_chip-support-fix.patch
generic-gpio-gpio_chip-support-gpiolib-locking-simplified.patch
avr32-uses-gpio_chip.patch
mcp23s08-spi-gpio-expander.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
arm-pxa-gpiolib-support-make-pxa_gpio_chip-static.patch
pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch
