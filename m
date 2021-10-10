Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25F76C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 10 Oct 2021 20:52:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E90960E76
	for <mm-commits@archiver.kernel.org>; Sun, 10 Oct 2021 20:52:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbhJJUyF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Oct 2021 16:54:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231266AbhJJUyE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 10 Oct 2021 16:54:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C01F60C49;
        Sun, 10 Oct 2021 20:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633899125;
        bh=TtAEtAXTlcYExzKwT6ZTIr0IHl+1kLO//zAnj3OG4JA=;
        h=Date:From:To:Subject:From;
        b=fdeps3lYB/lN3aidmOmuRMToT89mV5mx5aUgYREDA09xLqraNIQOpNpSYugT+OytI
         94jH64rGB6jjSNBL2CcO5Hnd9TgkzPIp6mqiLfHYMo7KBf8jRc9w6gPRuKaDVrPhN+
         E4KYccs9fEBq8MdTssEp/fye68ogNXKJAuVXYfC0=
Date:   Sun, 10 Oct 2021 13:52:04 -0700
From:   akpm@linux-foundation.org
To:     alan@lxorguk.ukuu.org.uk, angus@akkea.ca, david@fubar.dk,
        gregkh@linuxfoundation.org, hirofumi@mail.parknet.co.jp,
        kay.sievers@vrfy.org, lennart@poettering.net, martink@posteo.de,
        mm-commits@vger.kernel.org, tytso@mit.edu
Subject:  [to-be-updated]
 fs-fat-make-the-volume-label-writable-when-mounted.patch removed from -mm
 tree
Message-ID: <20211010205204.SF1RvgB5P%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: fat: make the volume label writable when mounted
has been removed from the -mm tree.  Its filename was
     fs-fat-make-the-volume-label-writable-when-mounted.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Martin Kepplinger <martink@posteo.de>
Subject: fs: fat: make the volume label writable when mounted

The motivation for this change (probably) has its origin in a whishlist
for the kernel that popped up in 2011, see
https://lore.kernel.org/lkml/1319135973.1020.9.camel@mop/

Subsequently the "eudyptula programming challenge", see
http://eudyptula-challenge.org/ included the task of making a mounted FAT
filesystems' label writable.  That's where it found its way to me in 2014.

During the following years I was asked not to publish this in order to
help the challenge be successful.  Time has passed and I'm not asked to
keep it secret anymore.

As for the API, I'm sending the original implementation as an ioctl() and
the example program that I've occasionally used over the years.  Based on
the previous discussions, it might be less controversal to create a
debugfs dir for the fs and make the label a file there.  I'm happy for
acceptable ideas and all feedback:

We add

	#define VFAT_IOCTL_SET_LABEL _IOW('r', 0x14, __u32)

for users to assign a new FAT volume label while the fat volume is mounted
(it works on the mountpoint).

* A pointer to a string as it's attribute changes the label.
* A nullpointer prints the current label strings to the kernel log.
* An empty string clears the label to "NO NAME    ". (I at least found this
  in the FAT16 spec)

I simply dump a test app here for completeness:

	#include <stdio.h>
	#include <stdint.h>
	#include <sys/ioctl.h>
	#include <fcntl.h>
	#include <unistd.h>
	#include <errno.h>
	#include <linux/msdos_fs.h>
	#include <string.h>
	#include <limits.h>

	#ifndef VFAT_IOCTL_SET_LABEL
	#define VFAT_IOCTL_SET_LABEL _IOW('r', 0x14, __u32)
	#endif

	int main(int argc, char **argv)
	{
		int fd;
		char path[LINE_MAX];
		char mylabel[MSDOS_NAME];
		char *label = mylabel;

		if (argc < 2 || argc > 3) {
			printf("Change label:
   %s [MOUNTPOINT] [LABEL]
", argv[0]);
			printf("Show label in kernel logs:
   %s [MOUNTPOINT]

", argv[0]);
			printf("Available filesystems and their mountpoints are:
");
			printf("   df --output=source,fstype,target | grep -E 'msdos|fat'
");
			return -EINVAL;
		}
		if (strlen(argv[1]) >= LINE_MAX) {
			printf("Path to mountpoint too long");
			return -EINVAL;
		}

		strcpy(path, argv[1]);
		if (argc == 3) {
			#pragma GCC diagnostic push
			#pragma GCC diagnostic ignored "-Wstringop-truncation"
			strncpy(label, argv[2], MSDOS_NAME);
			#pragma GCC diagnostic pop
		}
		if (argc == 2)
			label = NULL;

		fd = open(path, O_RDONLY);
		if (fd < 0)
			goto err;

		ioctl(fd, VFAT_IOCTL_SET_LABEL, label);

		close(fd);
	err:
		perror(NULL);
		return errno;
	}

Link: https://lkml.kernel.org/r/20211007095639.5002-1-martink@posteo.de
Signed-off-by: Martin Kepplinger <martink@posteo.de>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Angus Ainslie <angus@akkea.ca>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Harald Hoyer harald@redhat.com
Cc: David Zeuthen <david@fubar.dk>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Martin Kepplinger <martink@posteo.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/dir.c                  |   22 ++++
 fs/fat/fat.h                  |    3 
 fs/fat/file.c                 |  164 ++++++++++++++++++++++++++++++++
 include/uapi/linux/msdos_fs.h |    1 
 4 files changed, 190 insertions(+)

--- a/fs/fat/dir.c~fs-fat-make-the-volume-label-writable-when-mounted
+++ a/fs/fat/dir.c
@@ -1412,3 +1412,25 @@ error_remove:
 	return err;
 }
 EXPORT_SYMBOL_GPL(fat_add_entries);
+
+/* found at https://lwn.net/Articles/343565/ */
+int fat_get_label_entry(struct inode *root_inode, struct buffer_head **bh,
+			struct msdos_dir_entry **de)
+{
+	loff_t pos;
+
+	if (WARN_ON(root_inode->i_ino != MSDOS_ROOT_INO))
+		return -EINVAL;
+
+	pos = 0;
+	*bh = NULL;
+	while (fat_get_entry(root_inode, &pos, bh, de) >= 0) {
+		/* volume label: note that it is not enough to check only
+		 * whether the ATTR_VOLUME bit is set, since this would yield
+		 * true on any vfat extended entry.
+		 */
+		if ((*de)->attr != ATTR_EXT && ((*de)->attr & ATTR_VOLUME))
+			return 0;
+	}
+	return -ENOENT;
+}
--- a/fs/fat/fat.h~fs-fat-make-the-volume-label-writable-when-mounted
+++ a/fs/fat/fat.h
@@ -336,6 +336,9 @@ extern int fat_alloc_new_dir(struct inod
 extern int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
 			   struct fat_slot_info *sinfo);
 extern int fat_remove_entries(struct inode *dir, struct fat_slot_info *sinfo);
+extern int fat_get_label_entry(struct inode *root_inode,
+			       struct buffer_head **bh,
+			       struct msdos_dir_entry **de);
 
 /* fat/fatent.c */
 struct fat_entry {
--- a/fs/fat/file.c~fs-fat-make-the-volume-label-writable-when-mounted
+++ a/fs/fat/file.c
@@ -153,6 +153,168 @@ static int fat_ioctl_fitrim(struct inode
 	return 0;
 }
 
+/* protect access to the FAT fs label */
+DEFINE_MUTEX(label_mutex);
+
+static int fat_set_directory_volume_label(struct file *file, char *label)
+{
+	struct msdos_dir_entry *de;
+	struct buffer_head *bh;
+	struct inode *root_inode = file_inode(file);
+	struct super_block *sb = root_inode->i_sb;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	int err;
+	int offset;
+	sector_t blocknr;
+	loff_t i_pos;
+
+	err = 0;
+	i_pos = fat_i_pos_read(sbi, root_inode);
+	if (!i_pos)
+		return 0;
+
+	/* code found in inode.c */
+	fat_get_blknr_offset(sbi, i_pos, &blocknr, &offset);
+	bh = sb_bread(sb, blocknr);
+	if (!bh) {
+		fat_msg(sb, KERN_ERR,
+			"unable to read inode block for updating (i_pos %lld)",
+			i_pos);
+		return -EIO;
+	}
+
+	de = NULL;
+	err = fat_get_label_entry(root_inode, &bh, &de);
+	if (err)
+		return err;
+
+	if (label) {
+		fat_msg(sb, KERN_INFO,
+			"rename directory label from %.11s to %.11s",
+			de->name, label);
+		mutex_lock(&label_mutex);
+		strncpy(de->name, label, MSDOS_NAME);
+		mark_buffer_dirty(bh);
+		sync_dirty_buffer(bh);
+		brelse(bh);
+		mutex_unlock(&label_mutex);
+	} else {
+		fat_msg(sb, KERN_INFO, "directory label is %.11s", de->name);
+	}
+
+	return 0;
+}
+
+static int fat_set_partition_volume_label(struct file *file, char *label)
+{
+	struct fat_boot_sector *b;
+	struct buffer_head *bh;
+	struct inode *inode = file_inode(file);
+	struct super_block *sb = inode->i_sb;
+	struct msdos_sb_info *sbi = inode->i_sb->s_fs_info;
+
+	bh = sb_bread(sb, 0);
+	if (!bh) {
+		fat_msg(sb, KERN_ERR, "unable to read boot sector\n");
+		return -EIO;
+	}
+	b = (struct fat_boot_sector *)bh->b_data;
+
+	if (sbi->fat_bits == 32) {
+		if (label) {
+			fat_msg(sb, KERN_INFO,
+				"rename partition label from %.11s to %.11s",
+				b->fat32.vol_label, label);
+
+			mutex_lock(&MSDOS_SB(sb)->s_lock);
+			b->fat32.state |= FAT_STATE_DIRTY;
+			memcpy(b->fat32.vol_label, label, MSDOS_NAME);
+			mutex_unlock(&MSDOS_SB(sb)->s_lock);
+		} else {
+			b->fat32.state &= ~FAT_STATE_DIRTY;
+			fat_msg(sb, KERN_INFO, "partition label is %.11s",
+				b->fat32.vol_label);
+		}
+	} else {
+		if (label) {
+			fat_msg(sb, KERN_INFO,
+				"rename partition label from %.11s to %.11s ",
+				b->fat16.vol_label, label);
+
+			mutex_lock(&MSDOS_SB(sb)->s_lock);
+			b->fat32.state |= FAT_STATE_DIRTY;
+			memcpy(b->fat32.vol_label, label, MSDOS_NAME);
+			mutex_unlock(&MSDOS_SB(sb)->s_lock);
+		} else {
+			b->fat32.state &= ~FAT_STATE_DIRTY;
+			fat_msg(sb, KERN_INFO, "partition label is %.11s",
+				b->fat16.vol_label);
+		}
+	}
+	mark_buffer_dirty(bh);
+	sync_dirty_buffer(bh);
+	brelse(bh);
+
+	return 0;
+}
+
+static int fat_ioctl_set_label(struct file *file, u32 __user *user_attr)
+{
+	struct inode *inode = file_inode(file);
+	struct super_block *sb = inode->i_sb;
+	unsigned char newlabel[MSDOS_NAME + 1];
+	char *label;
+	int err;
+	int i;
+	int len;
+	unsigned char c;
+
+	if (!user_attr) {
+		label = NULL;
+		goto print_only;
+	}
+
+	label = newlabel;
+	err = copy_from_user(label, (void *)user_attr, MSDOS_NAME);
+	if (err) {
+		fat_msg(sb, KERN_ERR,
+			"copy_from_user failed %d bytes not copied\n", err);
+		return -EFAULT;
+	}
+	label[MSDOS_NAME] = '\0';
+	len = strlen(label);
+
+	if (len == 0) {
+		strncpy(label, "NO NAME    ", MSDOS_NAME);
+	} else {
+		for (i = 0; i < len; i++) {
+			c = label[i];
+			if ((c < 'a' || c > 'z') && (c < 'A' || c > 'Z')) {
+				if ((c < '0' || c > '9') && c != 0x20)
+					return -EINVAL;
+			}
+		}
+	}
+
+print_only:
+	err = fat_set_directory_volume_label(file, label);
+	if (err == -ENOENT) {
+		fat_msg(sb, KERN_ERR, "no label entry. please reformat\n");
+		strncpy(label, "NO NAME    ", MSDOS_NAME);
+	} else if (err) {
+		fat_msg(sb, KERN_ERR, "error setting directory label\n");
+		return err;
+	}
+
+	err = fat_set_partition_volume_label(file, label);
+	if (err) {
+		fat_msg(sb, KERN_ERR, "error setting partition label\n");
+		return err;
+	}
+
+	return 0;
+}
+
 long fat_generic_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -167,6 +329,8 @@ long fat_generic_ioctl(struct file *filp
 		return fat_ioctl_get_volume_id(inode, user_attr);
 	case FITRIM:
 		return fat_ioctl_fitrim(inode, arg);
+	case VFAT_IOCTL_SET_LABEL:
+		return fat_ioctl_set_label(filp, user_attr);
 	default:
 		return -ENOTTY;	/* Inappropriate ioctl for device */
 	}
--- a/include/uapi/linux/msdos_fs.h~fs-fat-make-the-volume-label-writable-when-mounted
+++ a/include/uapi/linux/msdos_fs.h
@@ -104,6 +104,7 @@ struct __fat_dirent {
 #define FAT_IOCTL_SET_ATTRIBUTES	_IOW('r', 0x11, __u32)
 /*Android kernel has used 0x12, so we use 0x13*/
 #define FAT_IOCTL_GET_VOLUME_ID		_IOR('r', 0x13, __u32)
+#define VFAT_IOCTL_SET_LABEL		_IOW('r', 0x14, __u32)
 
 struct fat_boot_sector {
 	__u8	ignored[3];	/* Boot strap short or near jump */
_

Patches currently in -mm which might be from martink@posteo.de are


