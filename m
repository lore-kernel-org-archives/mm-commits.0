From: akpm@linux-foundation.org
Subject: - mtd-remove-unused-mtd-parameter-in-of_mtd_parse_partitions.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:21:02 -0700
Message-ID: <200810182321.m9INL2lp029877@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751966AbYJRXVK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:21:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bigeasy@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     mtd: remove unused mtd parameter in of_mtd_parse_partitions()
has been removed from the -mm tree.  Its filename was
     mtd-remove-unused-mtd-parameter-in-of_mtd_parse_partitions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd: remove unused mtd parameter in of_mtd_parse_partitions()
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/physmap_of.c    |    3 +--
 drivers/mtd/nand/fsl_elbc_nand.c |    3 +--
 drivers/mtd/ofpart.c             |    1 -
 include/linux/mtd/partitions.h   |    1 -
 4 files changed, 2 insertions(+), 6 deletions(-)

diff -puN drivers/mtd/maps/physmap_of.c~mtd-remove-unused-mtd-parameter-in-of_mtd_parse_partitions drivers/mtd/maps/physmap_of.c
--- a/drivers/mtd/maps/physmap_of.c~mtd-remove-unused-mtd-parameter-in-of_mtd_parse_partitions
+++ a/drivers/mtd/maps/physmap_of.c
@@ -230,8 +230,7 @@ static int __devinit of_flash_probe(stru
 
 #ifdef CONFIG_MTD_OF_PARTS
 	if (err == 0) {
-		err = of_mtd_parse_partitions(&dev->dev, info->mtd,
-		                              dp, &info->parts);
+		err = of_mtd_parse_partitions(&dev->dev, dp, &info->parts);
 		if (err < 0)
 			return err;
 	}
diff -puN drivers/mtd/nand/fsl_elbc_nand.c~mtd-remove-unused-mtd-parameter-in-of_mtd_parse_partitions drivers/mtd/nand/fsl_elbc_nand.c
--- a/drivers/mtd/nand/fsl_elbc_nand.c~mtd-remove-unused-mtd-parameter-in-of_mtd_parse_partitions
+++ a/drivers/mtd/nand/fsl_elbc_nand.c
@@ -918,8 +918,7 @@ static int __devinit fsl_elbc_chip_probe
 
 #ifdef CONFIG_MTD_OF_PARTS
 	if (ret == 0) {
-		ret = of_mtd_parse_partitions(priv->dev, &priv->mtd,
-		                              node, &parts);
+		ret = of_mtd_parse_partitions(priv->dev, node, &parts);
 		if (ret < 0)
 			goto err;
 	}
diff -puN drivers/mtd/ofpart.c~mtd-remove-unused-mtd-parameter-in-of_mtd_parse_partitions drivers/mtd/ofpart.c
--- a/drivers/mtd/ofpart.c~mtd-remove-unused-mtd-parameter-in-of_mtd_parse_partitions
+++ a/drivers/mtd/ofpart.c
@@ -20,7 +20,6 @@
 #include <linux/mtd/partitions.h>
 
 int __devinit of_mtd_parse_partitions(struct device *dev,
-                                      struct mtd_info *mtd,
                                       struct device_node *node,
                                       struct mtd_partition **pparts)
 {
diff -puN include/linux/mtd/partitions.h~mtd-remove-unused-mtd-parameter-in-of_mtd_parse_partitions include/linux/mtd/partitions.h
--- a/include/linux/mtd/partitions.h~mtd-remove-unused-mtd-parameter-in-of_mtd_parse_partitions
+++ a/include/linux/mtd/partitions.h
@@ -73,7 +73,6 @@ struct device;
 struct device_node;
 
 int __devinit of_mtd_parse_partitions(struct device *dev,
-                                      struct mtd_info *mtd,
                                       struct device_node *node,
                                       struct mtd_partition **pparts);
 
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

origin.patch

