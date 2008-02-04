From: akpm@linux-foundation.org
Subject: + spi-remove-more-dev-powerpower_state-usage.patch added to -mm tree
Date: Mon, 04 Feb 2008 14:46:08 -0800
Message-ID: <200802042246.m14Mk8kh021738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33546 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754874AbYBDWqV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 17:46:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     spi: remove more dev->power.power_state usage
has been added to the -mm tree.  Its filename is
     spi-remove-more-dev-powerpower_state-usage.patch

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
pcmcia-stop-updating-dev-powerpower_state.patch
git-arm.patch
at91-correct-at91sam9263ek-lcd-power-gpio-pin.patch
i2c-isp1301_omap-new-style-i2c-driver-updates-part-1.patch
git-input.patch
git-mmc.patch
git-mtd.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
remove-pointless-casts-from-void-pointers.patch
spi-core-stop-updating-dev-powerpower_state.patch
spi-s3c-drivers-shouldnt-care-about-spi_board_info.patch
spi-remove-more-dev-powerpower_state-usage.patch
cosmetic-fixes-to-rtc-subsystems-kconfig.patch
rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
rtc-cmos-exports-nvram-in-sysfs.patch
rtc-cmos-alarm-acts-as-oneshot.patch
platform-real-time-clock-driver-for-dallas-1511-chip.patch
add-hpet-rtc-emulation-to-rtc_drv_cmos.patch
add-hpet-rtc-emulation-to-rtc_drv_cmos-fix.patch
rtc-add-support-for-epson-rtc-9701je-v2.patch
rtc-add-support-for-epson-rtc-9701je-v4.patch
rtc-update-documentation-wrt-irq_set_freq.patch
rtc-cleanup-example-code.patch
w1-gpio-add-gpio-w1-bus-master-driver.patch
w1-gpio-add-gpio-w1-bus-master-driver-v3.patch
basic-pwm-driver-for-avr32-and-at91.patch
basic-pwm-driver-for-avr32-and-at91-fix.patch
pwm-led-driver.patch
