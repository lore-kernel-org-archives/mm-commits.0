From: akpm@osdl.org
Subject: - m25p80-build-fixes-with-mtd-debug.patch removed from -mm tree
Date: Mon, 01 Jan 2007 23:24:40 -0800
Message-ID: <200701020724.l027OeoE012966@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37372 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932853AbXABHY4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 02:24:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     m25p80 build fixes (with MTD debug)
has been removed from the -mm tree.  Its filename was
     m25p80-build-fixes-with-mtd-debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: m25p80 build fixes (with MTD debug)
From: David Brownell <david-b@pacbell.net>

Fix build issues that show up with the m25p80 SPI flash driver when
building with MTD debug enabled.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/mtd/devices/m25p80.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/mtd/devices/m25p80.c~m25p80-build-fixes-with-mtd-debug drivers/mtd/devices/m25p80.c
--- a/drivers/mtd/devices/m25p80.c~m25p80-build-fixes-with-mtd-debug
+++ a/drivers/mtd/devices/m25p80.c
@@ -437,7 +437,7 @@ static int __devinit m25p_probe(struct s
 		 * or JEDEC get-id commands.  Try them ...
 		 */
 		DEBUG(MTD_DEBUG_LEVEL1, "%s: no chip id\n",
-				flash->spi->dev.bus_id);
+				spi->dev.bus_id);
 		return -ENODEV;
 	}
 
@@ -447,7 +447,7 @@ static int __devinit m25p_probe(struct s
 	}
 	if (i == ARRAY_SIZE(m25p_data)) {
 		DEBUG(MTD_DEBUG_LEVEL1, "%s: unrecognized id %s\n",
-				flash->spi->dev.bus_id, data->type);
+				spi->dev.bus_id, data->type);
 		return -ENODEV;
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
