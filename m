From: akpm@osdl.org
Subject: + spi-mtd-mtd_dataflash-oops-prevention.patch added to -mm tree
Date: Wed, 27 Dec 2006 01:11:33 -0800
Message-ID: <200612270911.kBR9BXF6006479@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:42921 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688AbWL0JLo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 04:11:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net, dwmw2@infradead.org


The patch titled
     SPI/MTD: mtd_dataflash oops prevention
has been added to the -mm tree.  Its filename is
     spi-mtd-mtd_dataflash-oops-prevention.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SPI/MTD: mtd_dataflash oops prevention
From: David Brownell <david-b@pacbell.net>

Return a fault code if the Dataflash driver runs into a "no device present"
error when the MISO line has a pulldown (it currently expects a pullup), so
that rmmod won't oops.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/mtd/devices/mtd_dataflash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/devices/mtd_dataflash.c~spi-mtd-mtd_dataflash-oops-prevention drivers/mtd/devices/mtd_dataflash.c
--- a/drivers/mtd/devices/mtd_dataflash.c~spi-mtd-mtd_dataflash-oops-prevention
+++ a/drivers/mtd/devices/mtd_dataflash.c
@@ -536,7 +536,7 @@ static int __devinit dataflash_probe(str
 	if (status <= 0 || status == 0xff) {
 		DEBUG(MTD_DEBUG_LEVEL1, "%s: status error %d\n",
 				spi->dev.bus_id, status);
-		if (status == 0xff)
+		if (status == 0 || status == 0xff)
 			status = -ENODEV;
 		return status;
 	}
_

Patches currently in -mm which might be from david-b@pacbell.net are

spi-define-null-tx_buf-to-mean-shift-out-zeroes.patch
m25p80-build-fixes-with-mtd-debug.patch
spi-mtd-mtd_dataflash-oops-prevention.patch
spi-kconfig-fix.patch
spi-controller-driver-for-omap-microwire.patch
gpio-core.patch
omap-gpio-wrappers.patch
at91-gpio-wrappers.patch

