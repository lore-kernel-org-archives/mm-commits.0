From: akpm@linux-foundation.org
Subject: + physmap-fix-memory-leak-on-physmap_flash_remove-by-using-devres.patch added to -mm tree
Date: Tue, 11 Nov 2008 15:00:35 -0800
Message-ID: <200811112300.mABN0Z5a000765@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39597 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751816AbYKKXB0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Nov 2008 18:01:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, dwmw2@infradead.org


The patch titled
     physmap: fix memory leak on physmap_flash_remove by using devres
has been added to the -mm tree.  Its filename is
     physmap-fix-memory-leak-on-physmap_flash_remove-by-using-devres.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

 drivers/mtd/maps/physmap.c |   26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

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
 	struct mtd_partition	*parts;
@@ -70,16 +69,7 @@ static int physmap_flash_remove(struct p
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
 
@@ -101,7 +91,8 @@ static int physmap_flash_probe(struct pl
 	if (physmap_data == NULL)
 		return -ENODEV;
 
-	info = kzalloc(sizeof(struct physmap_flash_info), GFP_KERNEL);
+	info = devm_kzalloc(&dev->dev, sizeof(struct physmap_flash_info),
+			    GFP_KERNEL);
 	if (info == NULL) {
 		err = -ENOMEM;
 		goto err_out;
@@ -114,10 +105,10 @@ static int physmap_flash_probe(struct pl
 		       (unsigned long long)(dev->resource[i].end - dev->resource[i].start + 1),
 		       (unsigned long long)dev->resource[i].start);
 
-		info->res = request_mem_region(dev->resource[i].start,
-					       dev->resource[i].end - dev->resource[i].start + 1,
-					       dev->dev.bus_id);
-		if (info->res == NULL) {
+		if (!devm_request_mem_region(&dev->dev,
+			dev->resource[i].start,
+			dev->resource[i].end - dev->resource[i].start + 1,
+			dev->dev.bus_id)) {
 			dev_err(&dev->dev, "Could not reserve memory region\n");
 			err = -ENOMEM;
 			goto err_out;
@@ -129,7 +120,8 @@ static int physmap_flash_probe(struct pl
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
physmap-fix-memory-leak-on-physmap_flash_remove-by-using-devres.patch

