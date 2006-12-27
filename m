From: akpm@osdl.org
Subject: + m25p80-build-fixes-with-mtd-debug.patch added to -mm tree
Date: Wed, 27 Dec 2006 01:11:01 -0800
Message-ID: <200612270911.kBR9B1vc006466@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:42867 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684AbWL0JLP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 04:11:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net, dwmw2@infradead.org


The patch titled
     m25p80 build fixes (with MTD debug)
has been added to the -mm tree.  Its filename is
     m25p80-build-fixes-with-mtd-debug.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

spi-define-null-tx_buf-to-mean-shift-out-zeroes.patch
m25p80-build-fixes-with-mtd-debug.patch
spi-kconfig-fix.patch
spi-controller-driver-for-omap-microwire.patch
gpio-core.patch
omap-gpio-wrappers.patch
at91-gpio-wrappers.patch

