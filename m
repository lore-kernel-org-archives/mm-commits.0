From: akpm@linux-foundation.org
Subject: [nacked] mtdpart-memory-accessor-interface-for-mtd-layer.patch removed from -mm tree
Date: Mon, 23 Nov 2009 12:24:22 -0800
Message-ID: <200911232024.nANKOMjB001891@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756222AbZKWUY5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Nov 2009 15:24:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudhakar.raj@ti.com, david-b@pacbell.net, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     mtdpart: memory accessor interface for MTD layer
has been removed from the -mm tree.  Its filename was
     mtdpart-memory-accessor-interface-for-mtd-layer.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtdpart: memory accessor interface for MTD layer
From: Sudhakar Rajashekhara <sudhakar.raj@ti.com>

Implement memory accessor interface in the MTD layer which enables the
kernel to access flash data.

This patch adds two new members to the mtd_partition structure, a function
handler which will be called during setup of the partition and an argument
to be passed to this setup function.

Example:
+static struct mtd_partition spi_flash_partitions[] = {
+       [0] = {
+               .name       = "U-Boot",
+               .offset     = 0,
+               .size       = SZ_256K,
+               .mask_flags = MTD_WRITEABLE,
+       },
+       [1] = {
+               .name       = "U-Boot Environment",
+               .offset     = MTDPART_OFS_NXTBLK,
+               .size       = SZ_64K,
+               .mask_flags = MTD_WRITEABLE,
+       },
+       [2] = {
+               .name       = "Linux",
+               .offset     = MTDPART_OFS_NXTBLK,
+               .size       = SZ_7M,
+               .mask_flags = 0,
+       },
+       [3] = {
+               .name       = "MAC Address",
+               .offset     = MTDPART_OFS_NXTBLK,
+               .size       = SZ_64K,
+               .mask_flags = 0,
+               .setup      = davinci_get_mac_addr,
+               .context    = (void *)0,
+       },
+};

The davinci_get_mac_addr function reads the MAC address from
offset ZERO of last MTD partition.

Signed-off-by: Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdpart.c          |   40 +++++++++++++++++++++++++++++++
 include/linux/mtd/partitions.h |    3 ++
 2 files changed, 43 insertions(+)

diff -puN drivers/mtd/mtdpart.c~mtdpart-memory-accessor-interface-for-mtd-layer drivers/mtd/mtdpart.c
--- a/drivers/mtd/mtdpart.c~mtdpart-memory-accessor-interface-for-mtd-layer
+++ a/drivers/mtd/mtdpart.c
@@ -26,6 +26,7 @@ static LIST_HEAD(mtd_partitions);
 struct mtd_part {
 	struct mtd_info mtd;
 	struct mtd_info *master;
+	struct memory_accessor macc;
 	uint64_t offset;
 	struct list_head list;
 };
@@ -327,6 +328,39 @@ int del_mtd_partitions(struct mtd_info *
 }
 EXPORT_SYMBOL(del_mtd_partitions);
 
+/*
+ * This lets other kernel code access the flash data. For example, it
+ * might hold a board's Ethernet address, or board-specific calibration
+ * data generated on the manufacturing floor.
+ */
+static ssize_t mtd_macc_read(struct memory_accessor *macc, char *buf,
+			off_t offset, size_t count)
+{
+	struct mtd_part *part = container_of(macc, struct mtd_part, macc);
+	ssize_t ret = -EIO;
+	size_t retlen;
+
+	if (part_read((struct mtd_info *)part, offset, count,
+			&retlen, buf) == 0)
+		ret = retlen;
+
+	return ret;
+}
+
+static ssize_t mtd_macc_write(struct memory_accessor *macc, const char *buf,
+			off_t offset, size_t count)
+{
+	struct mtd_part *part = container_of(macc, struct mtd_part, macc);
+	ssize_t ret = -EIO;
+	size_t retlen;
+
+	if (part_write((struct mtd_info *)part, offset, count,
+			&retlen, buf) == 0)
+		ret = retlen;
+
+	return ret;
+}
+
 static struct mtd_part *add_one_partition(struct mtd_info *master,
 		const struct mtd_partition *part, int partno,
 		uint64_t cur_offset)
@@ -364,6 +398,9 @@ static struct mtd_part *add_one_partitio
 	slave->mtd.read = part_read;
 	slave->mtd.write = part_write;
 
+	slave->macc.read = mtd_macc_read;
+	slave->macc.write = mtd_macc_write;
+
 	if (master->panic_write)
 		slave->mtd.panic_write = part_panic_write;
 
@@ -428,6 +465,9 @@ static struct mtd_part *add_one_partitio
 	printk(KERN_NOTICE "0x%012llx-0x%012llx : \"%s\"\n", (unsigned long long)slave->offset,
 		(unsigned long long)(slave->offset + slave->mtd.size), slave->mtd.name);
 
+	if (part->setup)
+		part->setup(&slave->macc, (void *)part->context);
+
 	/* let's do some sanity checks */
 	if (slave->offset >= master->size) {
 		/* let's register it anyway to preserve ordering */
diff -puN include/linux/mtd/partitions.h~mtdpart-memory-accessor-interface-for-mtd-layer include/linux/mtd/partitions.h
--- a/include/linux/mtd/partitions.h~mtdpart-memory-accessor-interface-for-mtd-layer
+++ a/include/linux/mtd/partitions.h
@@ -10,6 +10,7 @@
 #define MTD_PARTITIONS_H
 
 #include <linux/types.h>
+#include <linux/memory.h>
 
 
 /*
@@ -40,6 +41,8 @@ struct mtd_partition {
 	uint64_t offset;		/* offset within the master MTD space */
 	uint32_t mask_flags;		/* master MTD flags to mask out for this partition */
 	struct nand_ecclayout *ecclayout;	/* out of band layout for this partition (NAND only)*/
+	void (*setup)(struct memory_accessor *, void *context);
+	void *context;
 };
 
 #define MTDPART_OFS_NXTBLK	(-2)
_

Patches currently in -mm which might be from sudhakar.raj@ti.com are

davinci-fb-fix-frame-buffer-driver-issues.patch
linux-next.patch
mtd-nand-davinci-correct-4-bit-error-correction.patch
mtdpart-memory-accessor-interface-for-mtd-layer.patch
davinci-mmc-modify-data-types-of-edma-related-variables.patch

