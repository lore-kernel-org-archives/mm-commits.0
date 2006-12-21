From: akpm@osdl.org
Subject: + spi-kconfig-fix.patch added to -mm tree
Date: Thu, 21 Dec 2006 00:35:59 -0800
Message-ID: <200612210835.kBL8Zxl5021776@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49429 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422830AbWLUIgO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 03:36:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     SPI Kconfig fix
has been added to the -mm tree.  Its filename is
     spi-kconfig-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SPI Kconfig fix
From: David Brownell <david-b@pacbell.net>

Minor Kconfig cleanup ... put the SPI_S3C24XX entry in the
correct location (alphabetical order).

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/spi/Kconfig |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN drivers/spi/Kconfig~spi-kconfig-fix drivers/spi/Kconfig
--- a/drivers/spi/Kconfig~spi-kconfig-fix
+++ a/drivers/spi/Kconfig
@@ -95,6 +95,12 @@ config SPI_PXA2XX
 	  The driver can be configured to use any SSP port and additional
 	  documentation can be found a Documentation/spi/pxa2xx.
 
+config SPI_S3C24XX
+	tristate "Samsung S3C24XX series SPI"
+	depends on SPI_MASTER && ARCH_S3C2410 && EXPERIMENTAL
+	help
+	  SPI driver for Samsung S3C24XX series ARM SoCs
+
 config SPI_S3C24XX_GPIO
 	tristate "Samsung S3C24XX series SPI by GPIO"
 	depends on SPI_MASTER && ARCH_S3C2410 && SPI_BITBANG && EXPERIMENTAL
@@ -107,13 +113,6 @@ config SPI_S3C24XX_GPIO
 # Add new SPI master controllers in alphabetical order above this line
 #
 
-
-config SPI_S3C24XX
-	tristate "Samsung S3C24XX series SPI"
-	depends on SPI_MASTER && ARCH_S3C2410 && EXPERIMENTAL
-	help
-	  SPI driver for Samsung S3C24XX series ARM SoCs
-
 #
 # There are lots of SPI device types, with sensors and memory
 # being probably the most widely used ones.
_

Patches currently in -mm which might be from david-b@pacbell.net are

spi-kconfig-fix.patch
gpio-core.patch
omap-gpio-wrappers.patch
at91-gpio-wrappers.patch

