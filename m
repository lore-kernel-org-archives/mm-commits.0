From: akpm@linux-foundation.org
Subject: - fix-compiler-warnings-in-acornc.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:54:03 -0700
Message-ID: <200707162054.l6GKs3i0001775@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38006 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755744AbXGPVTl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:19:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: denver@ossguy.com, mm-commits@vger.kernel.org


The patch titled
     fix compiler warnings in acorn.c
has been removed from the -mm tree.  Its filename was
     fix-compiler-warnings-in-acornc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix compiler warnings in acorn.c
From: "Denver Gingerich" <denver@ossguy.com>

warning: 'adfs_partition' defined but not used
warning: 'riscix_partition' defined but not used
warning: 'linux_partition' defined but not used

Signed-off-by: Denver Gingerich <denver@ossguy.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/acorn.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN fs/partitions/acorn.c~fix-compiler-warnings-in-acornc fs/partitions/acorn.c
--- a/fs/partitions/acorn.c~fix-compiler-warnings-in-acornc
+++ a/fs/partitions/acorn.c
@@ -25,6 +25,8 @@
 #define PARTITION_RISCIX_SCSI	2
 #define PARTITION_LINUX		9
 
+#if defined(CONFIG_ACORN_PARTITION_CUMANA) || \
+	defined(CONFIG_ACORN_PARTITION_ADFS)
 static struct adfs_discrecord *
 adfs_partition(struct parsed_partitions *state, char *name, char *data,
 	       unsigned long first_sector, int slot)
@@ -48,6 +50,7 @@ adfs_partition(struct parsed_partitions 
 	put_partition(state, slot, first_sector, nr_sects);
 	return dr;
 }
+#endif
 
 #ifdef CONFIG_ACORN_PARTITION_RISCIX
 
@@ -65,6 +68,8 @@ struct riscix_record {
 	struct riscix_part part[8];
 };
 
+#if defined(CONFIG_ACORN_PARTITION_CUMANA) || \
+	defined(CONFIG_ACORN_PARTITION_ADFS)
 static int
 riscix_partition(struct parsed_partitions *state, struct block_device *bdev,
 		unsigned long first_sect, int slot, unsigned long nr_sects)
@@ -105,6 +110,7 @@ riscix_partition(struct parsed_partition
 	return slot;
 }
 #endif
+#endif
 
 #define LINUX_NATIVE_MAGIC 0xdeafa1de
 #define LINUX_SWAP_MAGIC   0xdeafab1e
@@ -115,6 +121,8 @@ struct linux_part {
 	__le32 nr_sects;
 };
 
+#if defined(CONFIG_ACORN_PARTITION_CUMANA) || \
+	defined(CONFIG_ACORN_PARTITION_ADFS)
 static int
 linux_partition(struct parsed_partitions *state, struct block_device *bdev,
 		unsigned long first_sect, int slot, unsigned long nr_sects)
@@ -146,6 +154,7 @@ linux_partition(struct parsed_partitions
 	put_dev_sector(sect);
 	return slot;
 }
+#endif
 
 #ifdef CONFIG_ACORN_PARTITION_CUMANA
 int
_

Patches currently in -mm which might be from denver@ossguy.com are

origin.patch
