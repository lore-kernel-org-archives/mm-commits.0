From: akpm@linux-foundation.org
Subject: + mtd-remove-unused-mtd-parameter-in-of_mtd_parse_partitions.patch added to -mm tree
Date: Thu, 16 Oct 2008 13:32:10 -0700
Message-ID: <200810162032.m9GKWADm015270@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753803AbYJPUcS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 16:32:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bigeasy@linutronix.de


The patch titled
     mtd: remove unused mtd parameter in of_mtd_parse_partitions()
has been added to the -mm tree.  Its filename is
     mtd-remove-unused-mtd-parameter-in-of_mtd_parse_partitions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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
framebuffer-fix-carminefb-section-mismatch.patch
mtd-remove-unused-mtd-parameter-in-of_mtd_parse_partitions.patch

