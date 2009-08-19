From: akpm@linux-foundation.org
Subject: + mtdpart-memory-accessor-interface-for-mtd-layer.patch added to -mm tree
Date: Wed, 19 Aug 2009 14:50:38 -0700
Message-ID: <200908192150.n7JLocnM018307@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48668 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750787AbZHSVuy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Aug 2009 17:50:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sudhakar.raj@ti.com, david-b@pacbell.net, dwmw2@infradead.org


The patch titled
     mtdpart: memory accessor interface for MTD layer
has been added to the -mm tree.  Its filename is
     mtdpart-memory-accessor-interface-for-mtd-layer.patch

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

linux-next.patch
mtdpart-memory-accessor-interface-for-mtd-layer.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v4-cleanup.patch
davinci-fb-frame-buffer-driver-for-ti-da8xx-omap-l1xx-v5.patch

