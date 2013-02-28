From: akpm@linux-foundation.org
Subject: [merged] fat-add-extended-fileds-to-struct-fat_boot_sector.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:11:21 -0800
Message-ID: <20130228201121.B257531C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:54458 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab3B1ULX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:11:23 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so244813vch.0
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:11:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bug-track@fisher-privat.net, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: add extended fileds to struct fat_boot_sector
has been removed from the -mm tree.  Its filename was
     fat-add-extended-fileds-to-struct-fat_boot_sector.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleksij Rempel <bug-track@fisher-privat.net>
Subject: fat: add extended fileds to struct fat_boot_sector

Later we will need "state" field to check if volume was cleanly unmounted.

Signed-off-by: Oleksij Rempel <bug-track@fisher-privat.net>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c                |    8 +++----
 include/uapi/linux/msdos_fs.h |   36 ++++++++++++++++++++++++--------
 2 files changed, 32 insertions(+), 12 deletions(-)

diff -puN fs/fat/inode.c~fat-add-extended-fileds-to-struct-fat_boot_sector fs/fat/inode.c
--- a/fs/fat/inode.c~fat-add-extended-fileds-to-struct-fat_boot_sector
+++ a/fs/fat/inode.c
@@ -1298,17 +1298,17 @@ int fat_fill_super(struct super_block *s
 	sbi->prev_free = FAT_START_ENT;
 	sb->s_maxbytes = 0xffffffff;
 
-	if (!sbi->fat_length && b->fat32_length) {
+	if (!sbi->fat_length && b->fat32.length) {
 		struct fat_boot_fsinfo *fsinfo;
 		struct buffer_head *fsinfo_bh;
 
 		/* Must be FAT32 */
 		sbi->fat_bits = 32;
-		sbi->fat_length = le32_to_cpu(b->fat32_length);
-		sbi->root_cluster = le32_to_cpu(b->root_cluster);
+		sbi->fat_length = le32_to_cpu(b->fat32.length);
+		sbi->root_cluster = le32_to_cpu(b->fat32.root_cluster);
 
 		/* MC - if info_sector is 0, don't multiply by 0 */
-		sbi->fsinfo_sector = le16_to_cpu(b->info_sector);
+		sbi->fsinfo_sector = le16_to_cpu(b->fat32.info_sector);
 		if (sbi->fsinfo_sector == 0)
 			sbi->fsinfo_sector = 1;
 
diff -puN include/uapi/linux/msdos_fs.h~fat-add-extended-fileds-to-struct-fat_boot_sector include/uapi/linux/msdos_fs.h
--- a/include/uapi/linux/msdos_fs.h~fat-add-extended-fileds-to-struct-fat_boot_sector
+++ a/include/uapi/linux/msdos_fs.h
@@ -120,14 +120,34 @@ struct fat_boot_sector {
 	__le32	hidden;		/* hidden sectors (unused) */
 	__le32	total_sect;	/* number of sectors (if sectors == 0) */
 
-	/* The following fields are only used by FAT32 */
-	__le32	fat32_length;	/* sectors/FAT */
-	__le16	flags;		/* bit 8: fat mirroring, low 4: active fat */
-	__u8	version[2];	/* major, minor filesystem version */
-	__le32	root_cluster;	/* first cluster in root directory */
-	__le16	info_sector;	/* filesystem info sector */
-	__le16	backup_boot;	/* backup boot sector */
-	__le16	reserved2[6];	/* Unused */
+	union {
+		struct {
+			/*  Extended BPB Fields for FAT16 */
+			__u8	drive_number;	/* Physical drive number */
+			__u8	state;		/* undocumented, but used
+						   for mount state. */
+			/* other fiealds are not added here */
+		} fat16;
+
+		struct {
+			/* only used by FAT32 */
+			__le32	length;		/* sectors/FAT */
+			__le16	flags;		/* bit 8: fat mirroring,
+						   low 4: active fat */
+			__u8	version[2];	/* major, minor filesystem
+						   version */
+			__le32	root_cluster;	/* first cluster in
+						   root directory */
+			__le16	info_sector;	/* filesystem info sector */
+			__le16	backup_boot;	/* backup boot sector */
+			__le16	reserved2[6];	/* Unused */
+			/* Extended BPB Fields for FAT32 */
+			__u8	drive_number;   /* Physical drive number */
+			__u8    state;       	/* undocumented, but used
+						   for mount state. */
+			/* other fiealds are not added here */
+		} fat32;
+	};
 };
 
 struct fat_boot_fsinfo {
_

Patches currently in -mm which might be from bug-track@fisher-privat.net are

origin.patch

