From: akpm@linux-foundation.org
Subject: - spi-core-stop-updating-dev-powerpower_state.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:25:42 -0800
Message-ID: <200802070025.m170PNX7006710@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45462 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759193AbYBGAoz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi core: stop updating dev->power.power_state
has been removed from the -mm tree.  Its filename was
     spi-core-stop-updating-dev-powerpower_state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

origin.patch
at91-correct-at91sam9263ek-lcd-power-gpio-pin.patch
i2c-isp1301_omap-new-style-i2c-driver-updates-part-1.patch
git-input.patch
git-mmc.patch
git-mtd.patch
basic-pwm-driver-for-avr32-and-at91.patch
basic-pwm-driver-for-avr32-and-at91-fix.patch
pwm-led-driver.patch
