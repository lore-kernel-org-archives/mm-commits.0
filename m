From: akpm@linux-foundation.org
Subject: + fatfs-add-fat_ioctl_get_volume_id.patch added to -mm tree
Date: Mon, 08 Jul 2013 13:52:47 -0700
Message-ID: <51db269f.hn1ZNhP11N12wMhD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52506 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab3GHUws (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 16:52:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sean@mcneil.com, john.stultz@linaro.org, hirofumi@mail.parknet.co.jp, dpervushin@gmail.com, ccross@android.com, bintian.wang@linaro.org, lockwood@android.com

Subject: + fatfs-add-fat_ioctl_get_volume_id.patch added to -mm tree
To: lockwood@android.com,bintian.wang@linaro.org,ccross@android.com,dpervushin@gmail.com,hirofumi@mail.parknet.co.jp,john.stultz@linaro.org,sean@mcneil.com
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 13:52:47 -0700


The patch titled
     Subject: fatfs: add FAT_IOCTL_GET_VOLUME_ID
has been added to the -mm tree.  Its filename is
     fatfs-add-fat_ioctl_get_volume_id.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fatfs-add-fat_ioctl_get_volume_id.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fatfs-add-fat_ioctl_get_volume_id.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Lockwood <lockwood@android.com>
Subject: fatfs: add FAT_IOCTL_GET_VOLUME_ID

This patch, originally from Android kernel, adds vfat ioctl command
FAT_IOCTL_GET_VOLUME_ID, with this command we can get the vfat volume ID
using following code:

	ioctl(fd, FAT_IOCTL_GET_VOLUME_ID, &volume_ID)

This patch is a modified version of the patch by Mike Lockwood, with
changes from Dmitry Pervushin, who noticed the original patch makes some
volume IDs abiguous with error returns: for example, if volume id is
0xFFFFFDAD, that matches -ENOIOCTLCMD, we get "FFFFFFFF" from the user
space.

So add a parameter to ioctl to get the correct volume ID.

Android uses vfat volume ID to identify different sd card, when a new sd
card is inserted to device, android can scan the media on it and pop up
new contents.

Signed-off-by: Bintian Wang <bintian.wang@linaro.org>
Cc: dmitry pervushin <dpervushin@gmail.com>
Cc: Mike Lockwood <lockwood@android.com>
Cc: Colin Cross <ccross@android.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Sean McNeil <sean@mcneil.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h                  |    1 +
 fs/fat/file.c                 |    8 ++++++++
 fs/fat/inode.c                |   12 ++++++++++++
 include/uapi/linux/msdos_fs.h |   10 ++++++++++
 4 files changed, 31 insertions(+)

diff -puN fs/fat/fat.h~fatfs-add-fat_ioctl_get_volume_id fs/fat/fat.h
--- a/fs/fat/fat.h~fatfs-add-fat_ioctl_get_volume_id
+++ a/fs/fat/fat.h
@@ -86,6 +86,7 @@ struct msdos_sb_info {
 	const void *dir_ops;	      /* Opaque; default directory operations */
 	int dir_per_block;	      /* dir entries per block */
 	int dir_per_block_bits;	      /* log2(dir_per_block) */
+	unsigned int vol_id;		/*volume ID*/
 
 	int fatent_shift;
 	struct fatent_operations *fatent_ops;
diff -puN fs/fat/file.c~fatfs-add-fat_ioctl_get_volume_id fs/fat/file.c
--- a/fs/fat/file.c~fatfs-add-fat_ioctl_get_volume_id
+++ a/fs/fat/file.c
@@ -114,6 +114,12 @@ out:
 	return err;
 }
 
+static int fat_ioctl_get_volume_id(struct inode *inode, u32 __user *user_attr)
+{
+	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
+	return put_user(sbi->vol_id, user_attr);
+}
+
 long fat_generic_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -124,6 +130,8 @@ long fat_generic_ioctl(struct file *filp
 		return fat_ioctl_get_attributes(inode, user_attr);
 	case FAT_IOCTL_SET_ATTRIBUTES:
 		return fat_ioctl_set_attributes(filp, user_attr);
+	case FAT_IOCTL_GET_VOLUME_ID:
+		return fat_ioctl_get_volume_id(inode, user_attr);
 	default:
 		return -ENOTTY;	/* Inappropriate ioctl for device */
 	}
diff -puN fs/fat/inode.c~fatfs-add-fat_ioctl_get_volume_id fs/fat/inode.c
--- a/fs/fat/inode.c~fatfs-add-fat_ioctl_get_volume_id
+++ a/fs/fat/inode.c
@@ -1415,6 +1415,18 @@ int fat_fill_super(struct super_block *s
 		brelse(fsinfo_bh);
 	}
 
+	/* interpret volume ID as a little endian 32 bit integer */
+	if (sbi->fat_bits == 32)
+		sbi->vol_id = (((u32)b->fat32.vol_id[0]) |
+					((u32)b->fat32.vol_id[1] << 8) |
+					((u32)b->fat32.vol_id[2] << 16) |
+					((u32)b->fat32.vol_id[3] << 24));
+	else /* fat 16 or 12 */
+		sbi->vol_id = (((u32)b->fat16.vol_id[0]) |
+					((u32)b->fat16.vol_id[1] << 8) |
+					((u32)b->fat16.vol_id[2] << 16) |
+					((u32)b->fat16.vol_id[3] << 24));
+
 	sbi->dir_per_block = sb->s_blocksize / sizeof(struct msdos_dir_entry);
 	sbi->dir_per_block_bits = ffs(sbi->dir_per_block) - 1;
 
diff -puN include/uapi/linux/msdos_fs.h~fatfs-add-fat_ioctl_get_volume_id include/uapi/linux/msdos_fs.h
--- a/include/uapi/linux/msdos_fs.h~fatfs-add-fat_ioctl_get_volume_id
+++ a/include/uapi/linux/msdos_fs.h
@@ -104,6 +104,8 @@ struct __fat_dirent {
 /* <linux/videotext.h> has used 0x72 ('r') in collision, so skip a few */
 #define FAT_IOCTL_GET_ATTRIBUTES	_IOR('r', 0x10, __u32)
 #define FAT_IOCTL_SET_ATTRIBUTES	_IOW('r', 0x11, __u32)
+/*Android kernel has used 0x12, so we use 0x13*/
+#define FAT_IOCTL_GET_VOLUME_ID		_IOR('r', 0x13, __u32)
 
 struct fat_boot_sector {
 	__u8	ignored[3];	/* Boot strap short or near jump */
@@ -128,6 +130,10 @@ struct fat_boot_sector {
 			__u8	drive_number;	/* Physical drive number */
 			__u8	state;		/* undocumented, but used
 						   for mount state. */
+			__u8	signature;  /* extended boot signature */
+			__u8	vol_id[4];	/* volume ID */
+			__u8	vol_label[11];	/* volume label */
+			__u8	fs_type[8];		/* file system type */
 			/* other fiealds are not added here */
 		} fat16;
 
@@ -147,6 +153,10 @@ struct fat_boot_sector {
 			__u8	drive_number;   /* Physical drive number */
 			__u8    state;       	/* undocumented, but used
 						   for mount state. */
+			__u8	signature;  /* extended boot signature */
+			__u8	vol_id[4];	/* volume ID */
+			__u8	vol_label[11];	/* volume label */
+			__u8	fs_type[8];		/* file system type */
 			/* other fiealds are not added here */
 		} fat32;
 	};
_

Patches currently in -mm which might be from lockwood@android.com are

fatfs-add-fat_ioctl_get_volume_id.patch

