From: akpm@linux-foundation.org
Subject: - spi-kconfig-fix.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:44:33 -0800
Message-ID: <200702122244.l1CMiXPe013613@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44997 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030264AbXBLWol (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:44:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     SPI Kconfig fix
has been removed from the -mm tree.  Its filename was
     spi-kconfig-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SPI Kconfig fix
From: David Brownell <david-b@pacbell.net>

Minor Kconfig cleanup ... put the SPI_S3C24XX entry in the
correct location (alphabetical order).

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

origin.patch
git-acpi.patch
git-avr32.patch
git-md-accel.patch
8250-make-probing-for-txen-bug-a-config-option.patch
