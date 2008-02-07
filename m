From: akpm@linux-foundation.org
Subject: - spi-remove-more-dev-powerpower_state-usage.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:26:12 -0800
Message-ID: <200802070025.m170PrwA006762@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60448 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932520AbYBGApE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: remove more dev->power.power_state usage
has been removed from the -mm tree.  Its filename was
     spi-remove-more-dev-powerpower_state-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: remove more dev->power.power_state usage
From: David Brownell <david-b@pacbell.net>

Remove some more references to dev->power.power_state.  That field is overdue
for removal, but we can't do that while it's still referenced in the kernel. 
The only reason to update it was to make the /sys/devices/.../power/state
files (now removed) work better.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/pxa2xx_spi.c |   17 -----------------
 drivers/spi/spi_imx.c    |   11 -----------
 2 files changed, 28 deletions(-)

diff -puN drivers/spi/pxa2xx_spi.c~spi-remove-more-dev-powerpower_state-usage drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~spi-remove-more-dev-powerpower_state-usage
+++ a/drivers/spi/pxa2xx_spi.c
@@ -1526,17 +1526,6 @@ static void pxa2xx_spi_shutdown(struct p
 }
 
 #ifdef CONFIG_PM
-static int suspend_devices(struct device *dev, void *pm_message)
-{
-	pm_message_t *state = pm_message;
-
-	if (dev->power.power_state.event != state->event) {
-		dev_warn(dev, "pm state does not match request\n");
-		return -1;
-	}
-
-	return 0;
-}
 
 static int pxa2xx_spi_suspend(struct platform_device *pdev, pm_message_t state)
 {
@@ -1544,12 +1533,6 @@ static int pxa2xx_spi_suspend(struct pla
 	struct ssp_device *ssp = drv_data->ssp;
 	int status = 0;
 
-	/* Check all childern for current power state */
-	if (device_for_each_child(&pdev->dev, &state, suspend_devices) != 0) {
-		dev_warn(&pdev->dev, "suspend aborted\n");
-		return -1;
-	}
-
 	status = stop_queue(drv_data);
 	if (status != 0)
 		return status;
diff -puN drivers/spi/spi_imx.c~spi-remove-more-dev-powerpower_state-usage drivers/spi/spi_imx.c
--- a/drivers/spi/spi_imx.c~spi-remove-more-dev-powerpower_state-usage
+++ a/drivers/spi/spi_imx.c
@@ -1686,17 +1686,6 @@ static void spi_imx_shutdown(struct plat
 }
 
 #ifdef CONFIG_PM
-static int suspend_devices(struct device *dev, void *pm_message)
-{
-	pm_message_t *state = pm_message;
-
-	if (dev->power.power_state.event != state->event) {
-		dev_warn(dev, "pm state does not match request\n");
-		return -1;
-	}
-
-	return 0;
-}
 
 static int spi_imx_suspend(struct platform_device *pdev, pm_message_t state)
 {
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
