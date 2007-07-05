From: akpm@linux-foundation.org
Subject: + spi-omap2_mcspi-driver-cleanups.patch added to -mm tree
Date: Thu, 05 Jul 2007 13:55:05 -0700
Message-ID: <200707052055.l65Kt57U018851@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49745 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755526AbXGEUz0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 16:55:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net, juha.yrjola@solidboot.com, soni.trilok@gmail.com, tony@atomide.com


The patch titled
     SPI: omap2_mcspi driver cleanups
has been added to the -mm tree.  Its filename is
     spi-omap2_mcspi-driver-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SPI: omap2_mcspi driver cleanups
From: David Brownell <david-b@pacbell.net>

More minor cleanups to the omap2_mcspi driver.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Trilok Soni <soni.trilok@gmail.com>
Cc: Juha Yrjl <juha.yrjola@solidboot.com>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/omap2_mcspi.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/spi/omap2_mcspi.c~spi-omap2_mcspi-driver-cleanups drivers/spi/omap2_mcspi.c
--- a/drivers/spi/omap2_mcspi.c~spi-omap2_mcspi-driver-cleanups
+++ a/drivers/spi/omap2_mcspi.c
@@ -310,6 +310,7 @@ static int mcspi_wait_for_reg_bit(void _
 	while (!(__raw_readl(reg) & bit)) {
 		if (time_after(jiffies, timeout))
 			return -1;
+		cpu_relax();
 	}
 	return 0;
 }
@@ -659,8 +660,7 @@ static void omap2_mcspi_cleanup(struct s
 	mcspi = spi_master_get_devdata(spi->master);
 	mcspi_dma = &mcspi->dma_channels[spi->chip_select];
 
-	if (spi->controller_state != NULL)
-		kfree(spi->controller_state);
+	kfree(spi->controller_state);
 
 	if (mcspi_dma->dma_rx_channel != -1) {
 		omap_free_dma(mcspi_dma->dma_rx_channel);
@@ -1062,7 +1062,8 @@ static struct platform_driver omap2_mcsp
 
 static int __init omap2_mcspi_init(void)
 {
-	omap2_mcspi_wq = create_workqueue(omap2_mcspi_driver.driver.name);
+	omap2_mcspi_wq = create_singlethread_workqueue(
+				omap2_mcspi_driver.driver.name);
 	if (omap2_mcspi_wq == NULL)
 		return -1;
 	return platform_driver_probe(&omap2_mcspi_driver, omap2_mcspi_probe);
_

Patches currently in -mm which might be from david-b@pacbell.net are

git-avr32.patch
pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm.patch
pm-do-not-use-saved_state-from-struct-dev_pm_info-on-arm-update.patch
git-leds.patch
git-mmc.patch
git-mtd.patch
git-netdev-all.patch
git-backlight.patch
char-genrtc-use-wait_event_interruptible.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
spi-controller-drivers-check-for-unsupported-modes.patch
spi-controller-drivers-check-for-unsupported-modes-update.patch
spi-add-3wire-mode-flag.patch
spi-add-3wire-mode-flag-fix.patch
spidev-compiler-warning-gone.patch
spi_lm70llp-parport-adapter-driver-correction.patch
spi_mpc83xxc-underclocking-hotfix.patch
atmel_spi-minor-updates.patch
s3c24xx-spi-controllers-both-select-bitbang.patch
spi-master-driver-for-xilinx-virtex-fix-2.patch
spi-omap2_mcspi-driver-cleanups.patch
rtc-ds1307-cleanups.patch
rtc-rs5c372-becomes-a-new-style-i2c-driver.patch
thecus-n2100-register-rtc-rs5c372-i2c-device.patch
rtc-make-example-code-jump-to-done-instead-of-return-when-ioctl-not-supported.patch
rtc-dev-return-enotty-in-ioctl-if-irq_set_freq-is-not-implemented-by-driver.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix-2.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices-fix-3.patch
rtc-kconfig-tweax.patch
rtc-add-rtc-m41t80-driver-take-2.patch
rtc-add-rtc-m41t80-driver-take-2-fix.patch
rtc-watchdog-support-for-rtc-m41t80-driver-take-2.patch
