From: akpm@linux-foundation.org
Subject: - tle62x0-driver-stops-ignoring-read-errors.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:10:26 -0800
Message-ID: <200711152110.lAFLAQmT015561@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47388 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932321AbXKOVRS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     tle62x0 driver stops ignoring read errors
has been removed from the -mm tree.  Its filename was
     tle62x0-driver-stops-ignoring-read-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tle62x0 driver stops ignoring read errors
From: David Brownell <david-b@pacbell.net>

The tle62x0 driver was ignoring all read errors.  This patch makes it
pass such errors up the stack, instead of returning bogus data.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/tle62x0.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/spi/tle62x0.c~tle62x0-driver-stops-ignoring-read-errors drivers/spi/tle62x0.c
--- a/drivers/spi/tle62x0.c~tle62x0-driver-stops-ignoring-read-errors
+++ a/drivers/spi/tle62x0.c
@@ -107,8 +107,11 @@ static ssize_t tle62x0_status_show(struc
 
 	mutex_lock(&st->lock);
 	ret = tle62x0_read(st);
-
 	dev_dbg(dev, "tle62x0_read() returned %d\n", ret);
+	if (ret < 0) {
+		mutex_unlock(&st->lock);
+		return ret;
+	}
 
 	for (ptr = 0; ptr < (st->nr_gpio * 2)/8; ptr += 1) {
 		fault <<= 8;
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
rtc-dont-write-rtc-century-when-setting-a-wake-alarm.patch
git-mmc.patch
usb-s3c2410_udc-minor-irq-handler-cleanups.patch
usb-device-dma-support-on-omap2.patch
rtc-convert-mutex-to-bitfield.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
remove-pointless-casts-from-void-pointers.patch
spi-at25-driver-is-for-eeprom-not-flash.patch
spi-use-mutex-not-semaphore.patch
blackfin-spi-driver-use-cpu_relax-to-replace-continue-in-while-busywait.patch
blackfin-spi-driver-use-void-__iomem-for-regs_base.patch
blackfin-spi-driver-move-hard-coded-pin_req-to-board-file.patch
blackfin-spi-driver-reconfigure-speed_hz-and-bits_per_word-in-each-spi-transfer.patch
cosmetic-fixes-to-rtc-subsystems-kconfig.patch
rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
rtc-cmos-exports-nvram-in-sysfs.patch
generic-gpio-gpio_chip-support.patch
generic-gpio-gpio_chip-support-fix.patch
avr32-uses-gpio_chip.patch
mcp23s08-spi-gpio-expander.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch
