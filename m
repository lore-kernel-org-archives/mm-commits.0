From: akpm@linux-foundation.org
Subject: - physmap-fix-memory-leak-on-physmap_flash_remove-by-using-devres.patch removed from -mm tree
Date: Mon, 01 Dec 2008 11:49:21 -0800
Message-ID: <200812011949.mB1JnLXf025228@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752604AbYLATt2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2008 14:49:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     physmap: fix memory leak on physmap_flash_remove by using devres
has been removed from the -mm tree.  Its filename was
     physmap-fix-memory-leak-on-physmap_flash_remove-by-using-devres.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: physmap: fix memory leak on physmap_flash_remove by using devres
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

physmap_flash_remove releases only last memory region.  This causes
memory leak if multiple resources were provided.

This patch fixes this leakage by using devm_ functions.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/physmap.c |   32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

diff -puN drivers/mtd/maps/physmap.c~physmap-fix-memory-leak-on-physmap_flash_remove-by-using-devres drivers/mtd/maps/physmap.c
--- a/drivers/mtd/maps/physmap.c~physmap-fix-memory-leak-on-physmap_flash_remove-by-using-devres
+++ a/drivers/mtd/maps/physmap.c
@@ -19,7 +19,7 @@
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/physmap.h>
 #include <linux/mtd/concat.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 #define MAX_RESOURCES		4
 
@@ -27,7 +27,6 @@ struct physmap_flash_info {
 	struct mtd_info		*mtd[MAX_RESOURCES];
 	struct mtd_info		*cmtd;
 	struct map_info		map[MAX_RESOURCES];
-	struct resource		*res;
 #ifdef CONFIG_MTD_PARTITIONS
 	int			nr_parts;
 #endif
@@ -65,16 +64,7 @@ static int physmap_flash_remove(struct p
 #endif
 			map_destroy(info->mtd[i]);
 		}
-
-		if (info->map[i].virt != NULL)
-			iounmap(info->map[i].virt);
-	}
-
-	if (info->res != NULL) {
-		release_resource(info->res);
-		kfree(info->res);
 	}
-
 	return 0;
 }
 
@@ -99,7 +89,8 @@ static int physmap_flash_probe(struct pl
 	if (physmap_data == NULL)
 		return -ENODEV;
 
-	info = kzalloc(sizeof(struct physmap_flash_info), GFP_KERNEL);
+	info = devm_kzalloc(&dev->dev, sizeof(struct physmap_flash_info),
+			    GFP_KERNEL);
 	if (info == NULL) {
 		err = -ENOMEM;
 		goto err_out;
@@ -112,13 +103,13 @@ static int physmap_flash_probe(struct pl
 		       (unsigned long long)(dev->resource[i].end - dev->resource[i].start + 1),
 		       (unsigned long long)dev->resource[i].start);
 
-		info->res = request_mem_region(dev->resource[i].start,
-					       dev->resource[i].end - dev->resource[i].start + 1,
-					       dev_name(&dev->dev));
-		if (info->res == NULL) {
-			dev_err(&dev->dev, "Could not reserve memory region\n");
-			err = -ENOMEM;
-			goto err_out;
+		if (!devm_request_mem_region(&dev->dev,
+			dev->resource[i].start,
+			dev->resource[i].end - dev->resource[i].start + 1,
+			dev_name(&dev->dev))) {
+				dev_err(&dev->dev, "Could not reserve memory region\n");
+				err = -ENOMEM;
+				goto err_out;
 		}
 
 		info->map[i].name = dev_name(&dev->dev);
@@ -127,7 +118,8 @@ static int physmap_flash_probe(struct pl
 		info->map[i].bankwidth = physmap_data->width;
 		info->map[i].set_vpp = physmap_data->set_vpp;
 
-		info->map[i].virt = ioremap(info->map[i].phys, info->map[i].size);
+		info->map[i].virt = devm_ioremap(&dev->dev, info->map[i].phys,
+						 info->map[i].size);
 		if (info->map[i].virt == NULL) {
 			dev_err(&dev->dev, "Failed to ioremap flash region\n");
 			err = EIO;
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

linux-next.patch
physmap-make-map_info-customizable.patch
physmap-fix-leak-of-memory-returned-by-parse_mtd_partitions.patch
atmel_serial-might-lose-modem-status-change.patch
rtc-add-alarm-update-irq-interfaces-version-5.patch
rtc-add-rtc-tx4939-driver-v2.patch

