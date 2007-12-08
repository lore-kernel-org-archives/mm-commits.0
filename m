From: akpm@linux-foundation.org
Subject: - spi-at25-driver-is-for-eeprom-not-flash.patch removed from -mm tree
Date: Fri, 07 Dec 2007 17:28:52 -0800
Message-ID: <200712080128.lB81Sqva013359@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42755 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753890AbXLHB3c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2007 20:29:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: at25 driver is for EEPROM not FLASH
has been removed from the -mm tree.  Its filename was
     spi-at25-driver-is-for-eeprom-not-flash.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi: at25 driver is for EEPROM not FLASH
From: David Brownell <david-b@pacbell.net>

Add comment to at25 driver that it's for EEPROM chips, not FLASH
chips ... the AT25 series has both types of chip, and sometimes
they're even pin-compatible.  The command sets are different, as
is the treatment of erasure.  (FLASH needs explicit erasure, but
with EEPROM it's implicit.)  Note that all vendors seem to have
this same confusion in their *25* series SPI memory parts.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/at25.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/spi/at25.c~spi-at25-driver-is-for-eeprom-not-flash drivers/spi/at25.c
--- a/drivers/spi/at25.c~spi-at25-driver-is-for-eeprom-not-flash
+++ a/drivers/spi/at25.c
@@ -21,6 +21,13 @@
 #include <linux/spi/eeprom.h>
 
 
+/*
+ * NOTE: this is an *EEPROM* driver.  The vagaries of product naming
+ * mean that some AT25 products are EEPROMs, and others are FLASH.
+ * Handle FLASH chips with the drivers/mtd/devices/m25p80.c driver,
+ * not this one!
+ */
+
 struct at25_data {
 	struct spi_device	*spi;
 	struct mutex		lock;
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
rtc-dont-write-rtc-century-when-setting-a-wake-alarm.patch
ads7846-stop-updating-dev-powerpower_state.patch
git-mmc.patch
git-mtd.patch
pcmcia-stop-updating-dev-powerpower_state.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
remove-pointless-casts-from-void-pointers.patch
spi-core-stop-updating-dev-powerpower_state.patch
cosmetic-fixes-to-rtc-subsystems-kconfig.patch
rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
rtc-cmos-exports-nvram-in-sysfs.patch
rtc-cmos-alarm-acts-as-oneshot.patch
platform-real-time-clock-driver-for-dallas-1511-chip.patch
generic-gpio-gpio_chip-support.patch
generic-gpio-gpio_chip-support-fix.patch
generic-gpio-gpio_chip-support-gpiolib-locking-simplified.patch
avr32-uses-gpio_chip.patch
mcp23s08-spi-gpio-expander.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
arm-pxa-gpiolib-support-make-pxa_gpio_chip-static.patch
pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch
