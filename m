From: akpm@linux-foundation.org
Subject: + fat-mark-fs-as-dirty-on-mount-and-clean-on-umount.patch added to -mm tree
Date: Wed, 02 Jan 2013 15:46:01 -0800
Message-ID: <20130102234602.D369A200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:61638 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab3ABXqF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jan 2013 18:46:05 -0500
Received: by mail-fa0-f74.google.com with SMTP id t1so911902fae.3
        for <mm-commits@vger.kernel.org>; Wed, 02 Jan 2013 15:46:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bug-track@fisher-privat.net, hirofumi@mail.parknet.co.jp


The patch titled
     Subject: fat: mark fs as dirty on mount and clean on umount
has been added to the -mm tree.  Its filename is
     fat-mark-fs-as-dirty-on-mount-and-clean-on-umount.patch

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
Subject: fat: mark fs as dirty on mount and clean on umount

There is no documented methods to mark FAT as dirty.  Unofficially MS
started to use reserved Byte in boot sector for this purpose, at least
since Win 2000.  With Win 7 user is warned if fs is dirty and asked to
clean it.

Different versions of Win, handle it in different ways, but always have
same meaning:

- Win 2000 and XP, set it on write operations and
  remove it after operation was finnished
- Win 7, set dirty flag on first write and remove it on umount.

We will do it as follows:

- set dirty flag on mount. If fs was initially dirty, warn user,
  remember it and do not do any changes to boot sector.
- clean it on umount. If fs was initially dirty, leave it dirty.
- do not do any thing if fs mounted read-only.
- TODO: leave fs dirty if we found some error after mount.

Signed-off-by: Oleksij Rempel <bug-track@fisher-privat.net>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h                  |    2 
 fs/fat/inode.c                |   66 ++++++++++++++++++++++++++++++++
 include/uapi/linux/msdos_fs.h |    2 
 3 files changed, 70 insertions(+)

diff -puN fs/fat/fat.h~fat-mark-fs-as-dirty-on-mount-and-clean-on-umount fs/fat/fat.h
--- a/fs/fat/fat.h~fat-mark-fs-as-dirty-on-mount-and-clean-on-umount
+++ a/fs/fat/fat.h
@@ -95,6 +95,8 @@ struct msdos_sb_info {
 
 	spinlock_t dir_hash_lock;
 	struct hlist_head dir_hashtable[FAT_HASH_SIZE];
+
+	unsigned int dirty;           /* fs state before mount */
 };
 
 #define FAT_CACHE_VALID	0	/* special case for valid cache */
diff -puN fs/fat/inode.c~fat-mark-fs-as-dirty-on-mount-and-clean-on-umount fs/fat/inode.c
--- a/fs/fat/inode.c~fat-mark-fs-as-dirty-on-mount-and-clean-on-umount
+++ a/fs/fat/inode.c
@@ -488,10 +488,59 @@ static void fat_evict_inode(struct inode
 	fat_detach(inode);
 }
 
+static void fat_set_state(struct super_block *sb,
+			unsigned int set, unsigned int force)
+{
+	struct buffer_head *bh;
+	struct fat_boot_sector *b;
+	struct msdos_sb_info *sbi = sb->s_fs_info;
+
+	/* do not change any thing if mounted read only */
+	if ((sb->s_flags & MS_RDONLY) && !force)
+		return;
+
+	/* do not change state if fs was dirty */
+	if (sbi->dirty) {
+		/* warn only on set (mount). */
+		if (set)
+			fat_msg(sb, KERN_WARNING, "Volume was not properly "
+				"unmounted. Some data may be corrupt. "
+				"Please run fsck.");
+		return;
+	}
+
+	bh = sb_bread(sb, 0);
+	if (bh == NULL) {
+		fat_msg(sb, KERN_ERR, "unable to read boot sector "
+			"to mark fs as dirty");
+		return;
+	}
+
+	b = (struct fat_boot_sector *) bh->b_data;
+
+	if (sbi->fat_bits == 32) {
+		if (set)
+			b->fat32.state |= FAT_STATE_DIRTY;
+		else
+			b->fat32.state &= ~FAT_STATE_DIRTY;
+	} else /* fat 16 and 12 */ {
+		if (set)
+			b->fat16.state |= FAT_STATE_DIRTY;
+		else
+			b->fat16.state &= ~FAT_STATE_DIRTY;
+	}
+
+	mark_buffer_dirty(bh);
+	sync_dirty_buffer(bh);
+	brelse(bh);
+}
+
 static void fat_put_super(struct super_block *sb)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 
+	fat_set_state(sb, 0, 0);
+
 	iput(sbi->fsinfo_inode);
 	iput(sbi->fat_inode);
 
@@ -566,8 +615,18 @@ static void __exit fat_destroy_inodecach
 
 static int fat_remount(struct super_block *sb, int *flags, char *data)
 {
+	int new_rdonly;
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	*flags |= MS_NODIRATIME | (sbi->options.isvfat ? 0 : MS_NOATIME);
+
+	/* make sure we update state on remount. */
+	new_rdonly = *flags & MS_RDONLY;
+	if (new_rdonly != (sb->s_flags & MS_RDONLY)) {
+		if (new_rdonly)
+			fat_set_state(sb, 0, 0);
+		else
+			fat_set_state(sb, 1, 1);
+	}
 	return 0;
 }
 
@@ -1362,6 +1421,12 @@ int fat_fill_super(struct super_block *s
 	if (sbi->fat_bits != 32)
 		sbi->fat_bits = (total_clusters > MAX_FAT12) ? 16 : 12;
 
+	/* some OSes set FAT_STATE_DIRTY and clean it on unmount. */
+	if (sbi->fat_bits == 32)
+		sbi->dirty = b->fat32.state & FAT_STATE_DIRTY;
+	else /* fat 16 or 12 */
+		sbi->dirty = b->fat16.state & FAT_STATE_DIRTY;
+
 	/* check that FAT table does not overflow */
 	fat_clusters = sbi->fat_length * sb->s_blocksize * 8 / sbi->fat_bits;
 	total_clusters = min(total_clusters, fat_clusters - FAT_START_ENT);
@@ -1456,6 +1521,7 @@ int fat_fill_super(struct super_block *s
 					"the device does not support discard");
 	}
 
+	fat_set_state(sb, 1, 0);
 	return 0;
 
 out_invalid:
diff -puN include/uapi/linux/msdos_fs.h~fat-mark-fs-as-dirty-on-mount-and-clean-on-umount include/uapi/linux/msdos_fs.h
--- a/include/uapi/linux/msdos_fs.h~fat-mark-fs-as-dirty-on-mount-and-clean-on-umount
+++ a/include/uapi/linux/msdos_fs.h
@@ -87,6 +87,8 @@
 #define IS_FSINFO(x)	(le32_to_cpu((x)->signature1) == FAT_FSINFO_SIG1 \
 			 && le32_to_cpu((x)->signature2) == FAT_FSINFO_SIG2)
 
+#define FAT_STATE_DIRTY 0x01
+
 struct __fat_dirent {
 	long		d_ino;
 	__kernel_off_t	d_off;
_

Patches currently in -mm which might be from bug-track@fisher-privat.net are

fat-add-extended-fileds-to-struct-fat_boot_sector.patch
fat-mark-fs-as-dirty-on-mount-and-clean-on-umount.patch

