From: akpm@linux-foundation.org
Subject: - gpiolib-deprecate-obsolete-pca9539-driver.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:29:22 -0800
Message-ID: <200802052229.m15MT37d011946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56214 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762860AbYBEWp2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:45:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.miao@marvell.com, bgardner@wabtec.com, dbrownell@users.sourceforge.net, hskinnemoen@atmel.com, khali@linux-fr.org, philipp.zabel@gmail.com, rmk@arm.linux.org.uk, sam@ravnborg.org


The patch titled
     deprecate obsolete pca9539 driver
has been removed from the -mm tree.  Its filename was
     gpiolib-deprecate-obsolete-pca9539-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
