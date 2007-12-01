From: akpm@linux-foundation.org
Subject: - atmel_spi-labels-gpios-better.patch removed from -mm tree
Date: Fri, 30 Nov 2007 16:20:38 -0800
Message-ID: <200712010020.lB10KcbD031710@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42860 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756033AbXLAAU4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Nov 2007 19:20:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, hskinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     atmel_spi: label GPIOs better
has been removed from the -mm tree.  Its filename was
     atmel_spi-labels-gpios-better.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atmel_spi: label GPIOs better
From: David Brownell <david-b@pacbell.net>

Make the atmel_spi driver label GPIOs according to the device for which
they're acting as a chipselect.  This way the debugfs dump of gpio state is
more informative.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/atmel_spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/atmel_spi.c~atmel_spi-labels-gpios-better drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c~atmel_spi-labels-gpios-better
+++ a/drivers/spi/atmel_spi.c
@@ -497,7 +497,7 @@ static int atmel_spi_setup(struct spi_de
 	/* chipselect must have been muxed as GPIO (e.g. in board setup) */
 	npcs_pin = (unsigned int)spi->controller_data;
 	if (!spi->controller_state) {
-		ret = gpio_request(npcs_pin, "spi_npcs");
+		ret = gpio_request(npcs_pin, spi->dev.bus_id);
 		if (ret)
 			return ret;
 		spi->controller_state = (void *)npcs_pin;
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
rtc-dont-write-rtc-century-when-setting-a-wake-alarm.patch
git-mmc.patch
git-mtd.patch
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
rtc-cmos-alarm-acts-as-oneshot.patch
generic-gpio-gpio_chip-support.patch
generic-gpio-gpio_chip-support-fix.patch
generic-gpio-gpio_chip-support-gpiolib-locking-simplified.patch
avr32-uses-gpio_chip.patch
mcp23s08-spi-gpio-expander.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
arm-pxa-gpiolib-support-make-pxa_gpio_chip-static.patch
pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch
