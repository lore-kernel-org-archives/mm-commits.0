From: akpm@linux-foundation.org
Subject: + fat-fix-vfat_ioctl_readdir_xxx-and-cleanup-for-userland.patch added to -mm tree
Date: Mon, 30 Jun 2008 20:34:10 -0700
Message-ID: <200807010334.m613YApp007133@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39480 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751996AbYGADeN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 23:34:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp


The patch titled
     fat: fix VFAT_IOCTL_READDIR_xxx and cleanup for userland
has been added to the -mm tree.  Its filename is
     fat-fix-vfat_ioctl_readdir_xxx-and-cleanup-for-userland.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fat: fix VFAT_IOCTL_READDIR_xxx and cleanup for userland
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

"struct dirent" is a kernel type here, but is a **different type** in
userspace!  This means both the structure and the IOCTL number is wrong!

So, this adds new "struct __fat_dirent" to generate correct IOCTL number. 
And kernel stuff moves to under __KERNEL__.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/msdos_fs.h |   47 +++++++++++++++++++++----------------
 1 file changed, 27 insertions(+), 20 deletions(-)

diff -puN include/linux/msdos_fs.h~fat-fix-vfat_ioctl_readdir_xxx-and-cleanup-for-userland include/linux/msdos_fs.h
--- a/include/linux/msdos_fs.h~fat-fix-vfat_ioctl_readdir_xxx-and-cleanup-for-userland
+++ a/include/linux/msdos_fs.h
@@ -2,11 +2,11 @@
 #define _LINUX_MSDOS_FS_H
 
 #include <linux/magic.h>
+#include <asm/byteorder.h>
 
 /*
  * The MS-DOS filesystem constants/structures
  */
-#include <asm/byteorder.h>
 
 #define SECTOR_SIZE	512		/* sector size (bytes) */
 #define SECTOR_BITS	9		/* log2(SECTOR_SIZE) */
@@ -89,24 +89,22 @@
 #define IS_FSINFO(x)	(le32_to_cpu((x)->signature1) == FAT_FSINFO_SIG1 \
 			 && le32_to_cpu((x)->signature2) == FAT_FSINFO_SIG2)
 
+struct __fat_dirent {
+	long		d_ino;
+	__kernel_off_t	d_off;
+	unsigned short	d_reclen;
+	char		d_name[256]; /* We must not include limits.h! */
+};
+
 /*
  * ioctl commands
  */
-#define VFAT_IOCTL_READDIR_BOTH		_IOR('r', 1, struct dirent [2])
-#define VFAT_IOCTL_READDIR_SHORT	_IOR('r', 2, struct dirent [2])
+#define VFAT_IOCTL_READDIR_BOTH		_IOR('r', 1, struct __fat_dirent[2])
+#define VFAT_IOCTL_READDIR_SHORT	_IOR('r', 2, struct __fat_dirent[2])
 /* <linux/videotext.h> has used 0x72 ('r') in collision, so skip a few */
 #define FAT_IOCTL_GET_ATTRIBUTES	_IOR('r', 0x10, __u32)
 #define FAT_IOCTL_SET_ATTRIBUTES	_IOW('r', 0x11, __u32)
 
-/*
- * vfat shortname flags
- */
-#define VFAT_SFN_DISPLAY_LOWER	0x0001 /* convert to lowercase for display */
-#define VFAT_SFN_DISPLAY_WIN95	0x0002 /* emulate win95 rule for display */
-#define VFAT_SFN_DISPLAY_WINNT	0x0004 /* emulate winnt rule for display */
-#define VFAT_SFN_CREATE_WIN95	0x0100 /* emulate win95 rule for create */
-#define VFAT_SFN_CREATE_WINNT	0x0200 /* emulate winnt rule for create */
-
 struct fat_boot_sector {
 	__u8	ignored[3];	/* Boot strap short or near jump */
 	__u8	system_id[8];	/* Name - can be used to special case
@@ -168,14 +166,6 @@ struct msdos_dir_slot {
 	__u8    name11_12[4];	/* last 2 characters in name */
 };
 
-struct fat_slot_info {
-	loff_t i_pos;		/* on-disk position of directory entry */
-	loff_t slot_off;	/* offset for slot or de start */
-	int nr_slots;		/* number of slots + 1(de) in filename */
-	struct msdos_dir_entry *de;
-	struct buffer_head *bh;
-};
-
 #ifdef __KERNEL__
 
 #include <linux/buffer_head.h>
@@ -184,6 +174,15 @@ struct fat_slot_info {
 #include <linux/fs.h>
 #include <linux/mutex.h>
 
+/*
+ * vfat shortname flags
+ */
+#define VFAT_SFN_DISPLAY_LOWER	0x0001 /* convert to lowercase for display */
+#define VFAT_SFN_DISPLAY_WIN95	0x0002 /* emulate win95 rule for display */
+#define VFAT_SFN_DISPLAY_WINNT	0x0004 /* emulate winnt rule for display */
+#define VFAT_SFN_CREATE_WIN95	0x0100 /* emulate win95 rule for create */
+#define VFAT_SFN_CREATE_WINNT	0x0200 /* emulate winnt rule for create */
+
 struct fat_mount_options {
 	uid_t fs_uid;
 	gid_t fs_gid;
@@ -267,6 +266,14 @@ struct msdos_inode_info {
 	struct inode vfs_inode;
 };
 
+struct fat_slot_info {
+	loff_t i_pos;		/* on-disk position of directory entry */
+	loff_t slot_off;	/* offset for slot or de start */
+	int nr_slots;		/* number of slots + 1(de) in filename */
+	struct msdos_dir_entry *de;
+	struct buffer_head *bh;
+};
+
 static inline struct msdos_sb_info *MSDOS_SB(struct super_block *sb)
 {
 	return sb->s_fs_info;
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

fat-fix-parse_options.patch
fat-fix-vfat_ioctl_readdir_xxx-and-cleanup-for-userland.patch
fat-dirc-switch-to-struct-__fat_dirent.patch
fat-cleanup-fs-fat-dirc.patch
fat-use-same-logic-in-fat_search_long-and-__fat_readdir.patch
fat-small-optimization-to-__fat_readdir.patch
pdflush-use-time_after-instead-of-open-coding-it.patch
msdos-fs-remove-unsettable-atari-option.patch
fat-dirc-switch-to-struct-__fat_fs_dirent.patch
remove-the-in-kernel-struct-dirent64.patch

