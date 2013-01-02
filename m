From: akpm@linux-foundation.org
Subject: + fat-add-extended-fileds-to-struct-fat_boot_sector.patch added to -mm tree
Date: Wed, 02 Jan 2013 15:45:57 -0800
Message-ID: <20130102234558.6788020005C@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:55861 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab3ABXqA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jan 2013 18:46:00 -0500
Received: by mail-wi0-f202.google.com with SMTP id hn17so911990wib.3
        for <mm-commits@vger.kernel.org>; Wed, 02 Jan 2013 15:45:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bug-track@fisher-privat.net, hirofumi@mail.parknet.co.jp


The patch titled
     Subject: fat: add extended fileds to struct fat_boot_sector
has been added to the -mm tree.  Its filename is
     fat-add-extended-fileds-to-struct-fat_boot_sector.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fat-add-extended-fileds-to-struct-fat_boot_sector.patch
fat-mark-fs-as-dirty-on-mount-and-clean-on-umount.patch

