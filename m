From: akpm@linux-foundation.org
Subject: - s3c24xx-spi-controllers-both-select-bitbang.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:03:12 -0700
Message-ID: <200707172303.l6HN3C5M011670@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52765 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936631AbXGQXQF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     S3c24xx SPI controllers both select 'bitbang'
has been removed from the -mm tree.  Its filename was
     s3c24xx-spi-controllers-both-select-bitbang.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: S3c24xx SPI controllers both select 'bitbang'
From: David Brownell <david-b@pacbell.net>

Tweak Kconfig for the S3C24XX SPI controller drivers.  Both use the bitbang
framework; only one previously said that.  Plus in this case "select" is
the right way to manage that dependency, since folk will not know up front
to enable bitbang in order to even see those S3C drivers in order to enable
them.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/Kconfig |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/spi/Kconfig~s3c24xx-spi-controllers-both-select-bitbang drivers/spi/Kconfig
--- a/drivers/spi/Kconfig~s3c24xx-spi-controllers-both-select-bitbang
+++ a/drivers/spi/Kconfig
@@ -154,12 +154,14 @@ config SPI_PXA2XX
 config SPI_S3C24XX
 	tristate "Samsung S3C24XX series SPI"
 	depends on SPI_MASTER && ARCH_S3C2410 && EXPERIMENTAL
+	select SPI_BITBANG
 	help
 	  SPI driver for Samsung S3C24XX series ARM SoCs
 
 config SPI_S3C24XX_GPIO
 	tristate "Samsung S3C24XX series SPI by GPIO"
-	depends on SPI_MASTER && ARCH_S3C2410 && SPI_BITBANG && EXPERIMENTAL
+	depends on SPI_MASTER && ARCH_S3C2410 && EXPERIMENTAL
+	select SPI_BITBANG
 	help
 	  SPI driver for Samsung S3C24XX series ARM SoCs using
 	  GPIO lines to provide the SPI bus. This can be used where
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
git-leds.patch
git-mmc.patch
git-mtd.patch
git-backlight.patch
use-mutex-instead-of-semaphore-in-the-usb-gadget-serial-driver.patch
geode-basic-infrastructure-support-for-amd-geode-class.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
gpio-calls-dont-need-i-o-barriers.patch
dev_vdbg-available-with-dverbose_debug.patch
dev_vdbg-available-with-dverbose_debug-docs.patch
