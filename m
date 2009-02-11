From: akpm@linux-foundation.org
Subject: [folded] mtd-txx9-soc-nand-flash-memory-controller-driver-v3.patch removed from -mm tree
Date: Wed, 11 Feb 2009 13:26:32 -0800
Message-ID: <200902112126.n1BLQWn0030437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34414 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757577AbZBKV0v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 16:26:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, dwmw2@infradead.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     MTD: TXx9 SoC NAND Flash Memory Controller driver (v3)
has been removed from the -mm tree.  Its filename was
     mtd-txx9-soc-nand-flash-memory-controller-driver-v3.patch

This patch was dropped because it was folded into mtd-txx9-soc-nand-flash-memory-controller-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MTD: TXx9 SoC NAND Flash Memory Controller driver (v3)
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

* fix wrong free of mtd_partition parsed by cmdlinepart.
* do not use ':' for name of mtd device

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/txx9ndfmc.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN drivers/mtd/nand/txx9ndfmc.c~mtd-txx9-soc-nand-flash-memory-controller-driver-v3 drivers/mtd/nand/txx9ndfmc.c
--- a/drivers/mtd/nand/txx9ndfmc.c~mtd-txx9-soc-nand-flash-memory-controller-driver-v3
+++ a/drivers/mtd/nand/txx9ndfmc.c
@@ -74,6 +74,9 @@ struct txx9ndfmc_drvdata {
 	unsigned char hold;	/* in gbusclock */
 	unsigned char spw;	/* in gbusclock */
 	struct nand_hw_control hw_control;
+#ifdef CONFIG_MTD_PARTITIONS
+	struct mtd_partition *parts[MAX_TXX9NDFMC_DEV];
+#endif
 };
 
 static struct platform_device *mtd_to_platdev(struct mtd_info *mtd)
@@ -294,7 +297,6 @@ static int __init txx9ndfmc_probe(struct
 		struct mtd_info *mtd;
 #ifdef CONFIG_MTD_PARTITIONS
 		int nr_parts;
-		struct mtd_partition *parts;
 #endif
 
 		if (!(plat->ch_mask & (1 << i)))
@@ -332,7 +334,7 @@ static int __init txx9ndfmc_probe(struct
 
 		if (plat->ch_mask != 1) {
 			txx9_priv->cs = i;
-			sprintf(txx9_priv->mtdname, "%s:%u",
+			sprintf(txx9_priv->mtdname, "%s.%u",
 				dev_name(&dev->dev), i);
 		} else {
 			txx9_priv->cs = -1;
@@ -348,11 +350,10 @@ static int __init txx9ndfmc_probe(struct
 		mtd->name = txx9_priv->mtdname;
 
 #ifdef CONFIG_MTD_PARTITIONS
-		nr_parts = parse_mtd_partitions(mtd, probes, &parts, 0);
-		if (nr_parts > 0) {
-			add_mtd_partitions(mtd, parts, nr_parts);
-			kfree(parts);
-		}
+		nr_parts = parse_mtd_partitions(mtd, probes,
+						&drvdata->parts[i], 0);
+		if (nr_parts > 0)
+			add_mtd_partitions(mtd, drvdata->parts[i], nr_parts);
 #endif
 		add_mtd_device(mtd);
 		drvdata->mtds[i] = mtd;
@@ -381,6 +382,7 @@ static int __exit txx9ndfmc_remove(struc
 
 #ifdef CONFIG_MTD_PARTITIONS
 		del_mtd_partitions(mtd);
+		kfree(drvdata->parts[i]);
 #endif
 		del_mtd_device(mtd);
 		kfree(txx9_priv);
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
mtd-txx9-add-ndfmc-support.patch
mtd-rbtx4939-add-mtd-support.patch
mtd-txx9-soc-nand-flash-memory-controller-driver.patch
mtd-txx9-soc-nand-flash-memory-controller-driver-v3.patch
mtd-rbtx4939-map-driver-v2.patch
atmel-mci-fix-initialization-of-dma-slave-data.patch
mtd-physmap-fix-wrong-free-and-del_mtd_partitiondevice.patch
atmel_serial-might-lose-modem-status-change.patch

