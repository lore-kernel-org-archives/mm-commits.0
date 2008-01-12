From: akpm@linux-foundation.org
Subject: + gpiolib-deprecate-obsolete-pca9539-driver.patch added to -mm tree
Date: Fri, 11 Jan 2008 18:23:05 -0800
Message-ID: <200801120223.m0C2N5VR009712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38880 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756039AbYALCb3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 21:31:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.miao@marvell.com, bgardner@wabtec.com, dbrownell@users.sourceforge.net, hskinnemoen@atmel.com, khali@linux-fr.org, philipp.zabel@gmail.com, rmk@arm.linux.org.uk, sam@ravnborg.org


The patch titled
     deprecate obsolete pca9539 driver
has been added to the -mm tree.  Its filename is
     gpiolib-deprecate-obsolete-pca9539-driver.patch

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
Subject: deprecate obsolete pca9539 driver
From: eric miao <eric.miao@marvell.com>

Use drivers/gpio/pca9539.c instead.

Signed-off-by: eric miao <eric.miao@marvell.com>
Acked-by: Ben Gardner <bgardner@wabtec.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Philipp Zabel <philipp.zabel@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/i2c/chips/pca9539 |    3 +++
 drivers/i2c/chips/Kconfig       |    7 +++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff -puN Documentation/i2c/chips/pca9539~gpiolib-deprecate-obsolete-pca9539-driver Documentation/i2c/chips/pca9539
--- a/Documentation/i2c/chips/pca9539~gpiolib-deprecate-obsolete-pca9539-driver
+++ a/Documentation/i2c/chips/pca9539
@@ -1,6 +1,9 @@
 Kernel driver pca9539
 =====================
 
+NOTE: this driver is deprecated and will be dropped soon, use
+drivers/gpio/pca9539.c instead.
+
 Supported chips:
   * Philips PCA9539
     Prefix: 'pca9539'
diff -puN drivers/i2c/chips/Kconfig~gpiolib-deprecate-obsolete-pca9539-driver drivers/i2c/chips/Kconfig
--- a/drivers/i2c/chips/Kconfig~gpiolib-deprecate-obsolete-pca9539-driver
+++ a/drivers/i2c/chips/Kconfig
@@ -54,8 +54,8 @@ config PCF8575
 	  hardware.  If unsure, say N.
 
 config SENSORS_PCA9539
-	tristate "Philips PCA9539 16-bit I/O port"
-	depends on EXPERIMENTAL
+	tristate "Philips PCA9539 16-bit I/O port (DEPRECATED)"
+	depends on EXPERIMENTAL && GPIO_PCA9539 = "n"
 	help
 	  If you say yes here you get support for the Philips PCA9539
 	  16-bit I/O port.
@@ -63,6 +63,9 @@ config SENSORS_PCA9539
 	  This driver can also be built as a module.  If so, the module
 	  will be called pca9539.
 
+	  This driver is deprecated and will be dropped soon. Use
+	  drivers/gpio/pca9539.c instead.
+
 config SENSORS_PCF8591
 	tristate "Philips PCF8591"
 	depends on EXPERIMENTAL
_

Patches currently in -mm which might be from eric.miao@marvell.com are

git-arm.patch
gpiolib-add-drivers-gpio-directory.patch
gpiolib-add-gpio-provider-infrastructure.patch
gpiolib-update-documentation-gpiotxt.patch
gpiolib-avr32-at32ap-platform-support.patch
gpiolib-pxa-platform-support.patch
gpiolib-pcf857x-i2c-gpio-expander-support.patch
gpiolib-mcp23s08-spi-gpio-expander-support.patch
gpiolib-pca9539-i2c-gpio-expander-support.patch
gpiolib-deprecate-obsolete-pca9539-driver.patch
