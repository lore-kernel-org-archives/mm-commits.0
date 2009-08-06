From: akpm@linux-foundation.org
Subject: [folded] mtd-sst25l-non-jedec-spi-flash-driver-fix.patch removed from -mm tree
Date: Thu, 06 Aug 2009 15:35:10 -0700
Message-ID: <200908062235.n76MZAVc018446@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750838AbZHFWfp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Aug 2009 18:35:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ryan@bluewatersys.com, andre@bluewatersys.com, avorontsov@ru.mvista.com, dwmw2@infradead.org, hartleys@visionengravers.com, linus.walleij@stericsson.com, mm-commits@vger.kernel.org


The patch titled
     mtd-sst25l-non-jedec-spi-flash-driver-fix
has been removed from the -mm tree.  Its filename was
     mtd-sst25l-non-jedec-spi-flash-driver-fix.patch

This patch was dropped because it was folded into mtd-sst25l-non-jedec-spi-flash-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd-sst25l-non-jedec-spi-flash-driver-fix
From: Ryan Mallon <ryan@bluewatersys.com>

Cc: "H Hartley Sweeten" <hartleys@visionengravers.com>
Cc: Andre Renaud <andre@bluewatersys.com>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/devices/sst25l.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN drivers/mtd/devices/sst25l.c~mtd-sst25l-non-jedec-spi-flash-driver-fix drivers/mtd/devices/sst25l.c
--- a/drivers/mtd/devices/sst25l.c~mtd-sst25l-non-jedec-spi-flash-driver-fix
+++ a/drivers/mtd/devices/sst25l.c
@@ -298,7 +298,7 @@ static int sst25l_write(struct mtd_info 
 		 * Write the remaining bytes using auto address
 		 * increment mode
 		 */
-		bytes = min(mtd->writesize, (u32)(len - i));
+		bytes = min_t(u32, mtd->writesize, len - i);
 		for (j = 1; j < bytes; j++, copied++) {
 			ret = sst25l_wait_till_ready(flash);
 			if (ret)
@@ -367,7 +367,7 @@ static int __init sst25l_probe(struct sp
 	struct flash_info *flash_info;
 	struct sst25l_flash *flash;
 	struct flash_platform_data *data;
-	int i;
+	int ret, i;
 
 	flash_info = sst25l_match_device(spi);
 	if (!flash_info)
@@ -457,7 +457,14 @@ static int __init sst25l_probe(struct sp
 			 data->nr_parts, data->name);
 	}
 
-	return add_mtd_device(&flash->mtd) == 1 ? -ENODEV : 0;
+	ret = add_mtd_device(&flash->mtd);
+	if (ret == 1) {
+		kfree(flash);
+		dev_set_drvdata(&spi->dev, NULL);
+		return -ENODEV;
+	}
+
+	return 0;
 }
 
 static int __exit sst25l_remove(struct spi_device *spi)
_

Patches currently in -mm which might be from ryan@bluewatersys.com are

linux-next.patch
mtd-sst25l-non-jedec-spi-flash-driver.patch
mtd-sst25l-non-jedec-spi-flash-driver-fix.patch
ep93xx-video-driver-platform-support.patch
ep93xx-video-driver.patch
ep93xx-video-driver-documentation.patch

