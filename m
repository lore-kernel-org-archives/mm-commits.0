From: akpm@linux-foundation.org
Subject: - spi-use-menuconfig-for-config_spi.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:55:47 -0700
Message-ID: <200804282155.m3SLtl00018150@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934238AbYD1Vzz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:55:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alessandro.guido@gmail.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: use menuconfig for CONFIG_SPI
has been removed from the -mm tree.  Its filename was
     spi-use-menuconfig-for-config_spi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: use menuconfig for CONFIG_SPI
From: Alessandro Guido <alessandro.guido@gmail.com>

Signed-off-by: Alessandro Guido <alessandro.guido@gmail.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/Kconfig |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN drivers/spi/Kconfig~spi-use-menuconfig-for-config_spi drivers/spi/Kconfig
--- a/drivers/spi/Kconfig~spi-use-menuconfig-for-config_spi
+++ a/drivers/spi/Kconfig
@@ -5,11 +5,9 @@
 # nobody's needed a slave side API yet.  The master-role API is not
 # fully appropriate there, so it'd need some thought to do well.
 #
-menu "SPI support"
-	depends on HAS_IOMEM
-
-config SPI
+menuconfig SPI
 	bool "SPI support"
+	depends on HAS_IOMEM
 	help
 	  The "Serial Peripheral Interface" is a low level synchronous
 	  protocol.  Chips that support SPI can have data transfer rates
@@ -28,9 +26,11 @@ config SPI
 	  (half duplex), SSP, SSI, and PSP.  This driver framework should
 	  work with most such devices and controllers.
 
+if SPI
+
 config SPI_DEBUG
 	boolean "Debug support for SPI drivers"
-	depends on SPI && DEBUG_KERNEL
+	depends on DEBUG_KERNEL
 	help
 	  Say "yes" to enable debug messaging (like dev_dbg and pr_debug),
 	  sysfs, and debugfs support in SPI controller and protocol drivers.
@@ -245,5 +245,4 @@ config SPI_TLE62X0
 
 # (slave support would go here)
 
-endmenu # "SPI support"
