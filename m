From: akpm@linux-foundation.org
Subject: - partition-add-support-for-sysv68-partitions.patch removed from -mm tree
Date: Tue, 08 May 2007 19:49:22 -0700
Message-ID: <200705090249.l492nMcJ009215@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969574AbXEICtd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:49:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: phdm@macqel.be, mm-commits@vger.kernel.org


The patch titled
     partition: add support for sysv68 partitions
has been removed from the -mm tree.  Its filename was
     partition-add-support-for-sysv68-partitions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: partition: add support for sysv68 partitions
From: Philippe De Muyter <phdm@macqel.be>

Add support for the Motorola sysv68 disk partition (slices in motorola
doc).

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/Kconfig  |    9 +++
 fs/partitions/Makefile |    1 
 fs/partitions/check.c  |    4 +
 fs/partitions/sysv68.c |   92 +++++++++++++++++++++++++++++++++++++++
 fs/partitions/sysv68.h |    1 
 5 files changed, 107 insertions(+)

diff -puN fs/partitions/Kconfig~partition-add-support-for-sysv68-partitions fs/partitions/Kconfig
--- a/fs/partitions/Kconfig~partition-add-support-for-sysv68-partitions
+++ a/fs/partitions/Kconfig
@@ -236,3 +236,12 @@ config EFI_PARTITION
 	help
 	  Say Y here if you would like to use hard disks under Linux which
 	  were partitioned using EFI GPT.
+
+config SYSV68_PARTITION
+	bool "SYSV68 partition table support" if PARTITION_ADVANCED
+	default y if M68K
+	help
+	  Say Y here if you would like to be able to read the hard disk
+	  partition table format used by Motorola Delta machines (using
+	  sysv68).
+	  Otherwise, say N.
diff -puN fs/partitions/Makefile~partition-add-support-for-sysv68-partitions fs/partitions/Makefile
--- a/fs/partitions/Makefile~partition-add-support-for-sysv68-partitions
+++ a/fs/partitions/Makefile
@@ -17,3 +17,4 @@ obj-$(CONFIG_ULTRIX_PARTITION) += ultrix
 obj-$(CONFIG_IBM_PARTITION) += ibm.o
 obj-$(CONFIG_EFI_PARTITION) += efi.o
 obj-$(CONFIG_KARMA_PARTITION) += karma.o
+obj-$(CONFIG_SYSV68_PARTITION) += sysv68.o
diff -puN fs/partitions/check.c~partition-add-support-for-sysv68-partitions fs/partitions/check.c
--- a/fs/partitions/check.c~partition-add-support-for-sysv68-partitions
+++ a/fs/partitions/check.c
@@ -34,6 +34,7 @@
 #include "ultrix.h"
 #include "efi.h"
 #include "karma.h"
+#include "sysv68.h"
 
 #ifdef CONFIG_BLK_DEV_MD
 extern void md_autodetect_dev(dev_t dev);
@@ -105,6 +106,9 @@ static int (*check_part[])(struct parsed
 #ifdef CONFIG_KARMA_PARTITION
 	karma_partition,
 #endif
+#ifdef CONFIG_SYSV68_PARTITION
+	sysv68_partition,
+#endif
 	NULL
 };
  
diff -puN /dev/null fs/partitions/sysv68.c
--- /dev/null
+++ a/fs/partitions/sysv68.c
@@ -0,0 +1,92 @@
+/*
+ *  fs/partitions/sysv68.c
+ *
+ *  Copyright (C) 2007 Philippe De Muyter <phdm@macqel.be>
+ */
+
+#include "check.h"
+#include "sysv68.h"
+
+/*
+ *	Volume ID structure: on first 256-bytes sector of disk
+ */
+
+struct volumeid {
+	u8	vid_unused[248];
+	u8	vid_mac[8];	/* ASCII string "MOTOROLA" */
+};
+
+/*
+ *	config block: second 256-bytes sector on disk
+ */
+
+struct dkconfig {
+	u8	ios_unused0[128];
+	__be32	ios_slcblk;	/* Slice table block number */
+	__be16	ios_slccnt;	/* Number of entries in slice table */
+	u8	ios_unused1[122];
+};
+
+/*
+ *	combined volumeid and dkconfig block
+ */
+
+struct dkblk0 {
+	struct volumeid dk_vid;
+	struct dkconfig dk_ios;
+};
+
+/*
+ *	Slice Table Structure
+ */
+
+struct slice {
+	__be32	nblocks;		/* slice size (in blocks) */
+	__be32	blkoff;			/* block offset of slice */
+};
+
+
+int sysv68_partition(struct parsed_partitions *state, struct block_device *bdev)
+{
+	int i, slices;
+	int slot = 1;
+	Sector sect;
+	unsigned char *data;
+	struct dkblk0 *b;
+	struct slice *slice;
+
+	data = read_dev_sector(bdev, 0, &sect);
+	if (!data)
+		return -1;
+
+	b = (struct dkblk0 *)data;
+	if (memcmp(b->dk_vid.vid_mac, "MOTOROLA", sizeof(b->dk_vid.vid_mac))) {
+		put_dev_sector(sect);
+		return 0;
+	}
+	slices = be16_to_cpu(b->dk_ios.ios_slccnt);
+	i = be32_to_cpu(b->dk_ios.ios_slcblk);
+	put_dev_sector(sect);
+
+	data = read_dev_sector(bdev, i, &sect);
+	if (!data)
+		return -1;
+
+	slices -= 1; /* last slice is the whole disk */
+	printk("sysV68: %s(s%u)", state->name, slices);
+	slice = (struct slice *)data;
+	for (i = 0; i < slices; i++, slice++) {
+		if (slot == state->limit)
+			break;
+		if (be32_to_cpu(slice->nblocks)) {
+			put_partition(state, slot,
+				be32_to_cpu(slice->blkoff),
+				be32_to_cpu(slice->nblocks));
+			printk("(s%u)", i);
+		}
+		slot++;
+	}
+	printk("\n");
+	put_dev_sector(sect);
+	return 1;
+}
diff -puN /dev/null fs/partitions/sysv68.h
--- /dev/null
+++ a/fs/partitions/sysv68.h
@@ -0,0 +1 @@
+extern int sysv68_partition(struct parsed_partitions *state, struct block_device *bdev);
_

Patches currently in -mm which might be from phdm@macqel.be are

origin.patch
