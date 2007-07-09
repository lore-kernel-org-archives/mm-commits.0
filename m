From: akpm@linux-foundation.org
Subject: - spi-omap2_mcspi-driver-cleanups.patch removed from -mm tree
Date: Mon, 09 Jul 2007 15:07:51 -0700
Message-ID: <200707092207.l69M7qkD015381@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46525 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756079AbXGIWIL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 18:08:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, juha.yrjola@solidboot.com, soni.trilok@gmail.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     SPI: omap2_mcspi driver cleanups
has been removed from the -mm tree.  Its filename was
     spi-omap2_mcspi-driver-cleanups.patch

This patch was dropped because it was folded into spi-omap2_mcspi-driver.patch

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
git-leds.patch
git-mmc.patch
git-mtd.patch
git-netdev-all.patch
git-backlight.patch
geode-basic-infrastructure-support-for-amd-geode-class.patch
char-genrtc-use-wait_event_interruptible.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
spi-controller-drivers-check-for-unsupported-modes.patch
spi-add-3wire-mode-flag.patch
spidev-compiler-warning-gone.patch
spi_mpc83xxc-underclocking-hotfix.patch
atmel_spi-minor-updates.patch
s3c24xx-spi-controllers-both-select-bitbang.patch
spi-master-driver-for-xilinx-virtex.patch
spi-omap2_mcspi-driver.patch
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
