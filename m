From: akpm@osdl.org
Subject: - spi-mtd-mtd_dataflash-oops-prevention.patch removed from -mm tree
Date: Mon, 01 Jan 2007 23:24:42 -0800
Message-ID: <200701020724.l027Ogcr012974@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37373 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932839AbXABHY4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 02:24:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     SPI/MTD: mtd_dataflash oops prevention
has been removed from the -mm tree.  Its filename was
     spi-mtd-mtd_dataflash-oops-prevention.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-dvb.patch
spi-kconfig-fix.patch
spi-controller-driver-for-omap-microwire.patch
spi-controller-driver-for-omap-microwire-update.patch
spi-controller-driver-for-omap-microwire-update-fix.patch
pnp-export-pnp_bus_type.patch
gpio-core.patch
omap-gpio-wrappers.patch
at91-gpio-wrappers.patch
