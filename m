From: akpm@linux-foundation.org
Subject: + spi-add-spi-over-gpio-driver-v3.patch added to -mm tree
Date: Sun, 20 Jul 2008 18:29:53 -0700
Message-ID: <200807210129.m6L1TrMH010854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754385AbYGUBao (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 Jul 2008 21:30:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mb@bu3sch.de, david-b@pacbell.net, drzeus-list@drzeus.cx


The patch titled
     spi-add-spi-over-gpio-driver-v3
has been added to the -mm tree.  Its filename is
     spi-add-spi-over-gpio-driver-v3.patch

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
Subject: spi-add-spi-over-gpio-driver-v3
From: Michael Buesch <mb@bu3sch.de>

Simple spelling fixes since v2.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: David Brownell <david-b@pacbell.net>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                  |   10 +++++-----
 drivers/spi/Kconfig          |    2 +-
 include/linux/spi/spi_gpio.h |   12 +++++++++---
 3 files changed, 15 insertions(+), 9 deletions(-)

diff -puN MAINTAINERS~spi-add-spi-over-gpio-driver-v3 MAINTAINERS
--- a/MAINTAINERS~spi-add-spi-over-gpio-driver-v3
+++ a/MAINTAINERS
@@ -3876,11 +3876,6 @@ M:	dbrownell@users.sourceforge.net
 L:	spi-devel-general@lists.sourceforge.net
 S:	Maintained
 
-SPI GPIO MASTER DRIVER
-P:	Michael Buesch
-M:	mb@bu3sch.de
-S:	Maintained
-
 SPU FILE SYSTEM
 P:	Jeremy Kerr
 M:	jk@ozlabs.org
@@ -3889,6 +3884,11 @@ L:	cbe-oss-dev@ozlabs.org
 W:	http://www.ibm.com/developerworks/power/cell/
 S:	Supported
 
+SPI GPIO MASTER DRIVER
+P:	Michael Buesch
+M:	mb@bu3sch.de
+S:	Maintained
+
 STABLE BRANCH:
 P:	Greg Kroah-Hartman
 M:	greg@kroah.com
diff -puN drivers/spi/Kconfig~spi-add-spi-over-gpio-driver-v3 drivers/spi/Kconfig
--- a/drivers/spi/Kconfig~spi-add-spi-over-gpio-driver-v3
+++ a/drivers/spi/Kconfig
@@ -107,7 +107,7 @@ config SPI_GPIO
 	help
 	  This is a platform driver that can be used for bitbanging
 	  an SPI bus over GPIO pins.
-	  Select this, if you have any SPI device that is connected via
+	  Select this if you have any SPI device that is connected via
 	  GPIO pins.
 	  The module will be called spi_gpio.
 
diff -puN include/linux/spi/spi_gpio.h~spi-add-spi-over-gpio-driver-v3 include/linux/spi/spi_gpio.h
--- a/include/linux/spi/spi_gpio.h~spi-add-spi-over-gpio-driver-v3
+++ a/include/linux/spi/spi_gpio.h
@@ -15,7 +15,9 @@
 #include <linux/spi/spi.h>
 
 
-/** struct spi_gpio_platform_data - Data definitions for a SPI-GPIO device.
+/**
+ * struct spi_gpio_platform_data - Data definitions for a SPI-GPIO device.
+ *
  * This structure holds information about a GPIO-based SPI device.
  *
  * @pin_clk: The GPIO pin number of the CLOCK pin.
@@ -51,13 +53,17 @@ struct spi_gpio_platform_data {
 	void *boardinfo_setup_data;
 };
 
-/** SPI_GPIO_PLATDEV_NAME - The platform device name string.
+/**
+ * SPI_GPIO_PLATDEV_NAME - The platform device name string.
+ *
  * The name string that has to be used for platform_device_alloc
  * when allocating a spi-gpio device.
  */
 #define SPI_GPIO_PLATDEV_NAME	"spi-gpio"
 
-/** spi_gpio_next_id - Get another platform device ID number.
+/**
+ * spi_gpio_next_id - Get another platform device ID number.
+ *
  * This returns the next platform device ID number that has to be used
  * for platform_device_alloc. The ID is opaque and should not be used for
  * anything else.
_

Patches currently in -mm which might be from mb@bu3sch.de are

origin.patch
linux-next.patch
gpio-sysfs-interface-updated-gpio-linux-next-fixes-for-sysfs-support.patch
gpio-add-bt8xxgpio-driver.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-fix.patch
gpio-add-bt8xxgpio-driver-checkpatch-fixes-cleanup.patch
gpiolib-allow-user-selection.patch
gpiolib-allow-user-selection-update.patch
spi-add-spi-over-gpio-driver.patch
spi-add-spi-over-gpio-driver-v3.patch
mmc-add-gpio-based-mmc-sd-driver.patch

