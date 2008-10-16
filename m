From: akpm@linux-foundation.org
Subject: + fat-fix-attr_ro-in-the-case-of-umask-s_wugo-==-0.patch added to -mm tree
Date: Thu, 16 Oct 2008 15:07:44 -0700
Message-ID: <200810162207.m9GM7iGo028108@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756584AbYJPWHs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 18:07:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp


The patch titled
     fat: Fix ATTR_RO in the case of (~umask & S_WUGO) == 0
has been added to the -mm tree.  Its filename is
     fat-fix-attr_ro-in-the-case-of-umask-s_wugo-==-0.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fat: Fix ATTR_RO in the case of (~umask & S_WUGO) == 0
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

If inode->i_mode doesn't have S_WUGO, current code assumes it means
ATTR_RO.  However, if (~[ufd]mask & S_WUGO) == 0, inode->i_mode can't
hold S_WUGO. Therefore the updated directory entry will always have
ATTR_RO.

This adds fat_mode_can_hold_ro() to check it. And if inode->i_mode
can't hold, uses -i_attrs to hold ATTR_RO instead.

With this, we don't set ATTR_RO unless users change it via ioctl() if
(~[ufd]mask & S_WUGO) == 0.

And on FAT_IOCTL_GET_ATTRIBUTES path, this adds ->i_mutex to it for
not returning the partially updated attributes by FAT_IOCTL_SET_ATTRIBUTES
to userland.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h  |   33 +++++++++++++++++++++++++++++----
 fs/fat/file.c |    7 ++++++-
 2 files changed, 35 insertions(+), 5 deletions(-)

diff -puN fs/fat/fat.h~fat-fix-attr_ro-in-the-case-of-umask-s_wugo-==-0 fs/fat/fat.h
--- a/fs/fat/fat.h~fat-fix-attr_ro-in-the-case-of-umask-s_wugo-==-0
+++ a/fs/fat/fat.h
@@ -117,6 +117,25 @@ static inline struct msdos_inode_info *M
 	return container_of(inode, struct msdos_inode_info, vfs_inode);
 }
 
+/*
+ * If ->i_mode can't hold S_IWUGO (i.e. ATTR_RO), we use ->i_attrs to
+ * save ATTR_RO instead of ->i_mode.
+ */
+static inline int fat_mode_can_hold_ro(struct inode *inode)
+{
+	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
+	mode_t mask;
+
+	if (S_ISDIR(inode->i_mode))
+		mask = ~sbi->options.fs_dmask;
+	else
+		mask = ~sbi->options.fs_fmask;
+
+	if (!(mask & S_IWUGO))
+		return 0;
+	return 1;
+}
+
 /* Convert attribute bits and a mask to the UNIX mode. */
 static inline mode_t fat_make_mode(struct msdos_sb_info *sbi,
 				   u8 attrs, mode_t mode)
@@ -133,14 +152,20 @@ static inline mode_t fat_make_mode(struc
 /* Return the FAT attribute byte for this inode */
 static inline u8 fat_make_attrs(struct inode *inode)
 {
-	return ((inode->i_mode & S_IWUGO) ? ATTR_NONE : ATTR_RO) |
-		(S_ISDIR(inode->i_mode) ? ATTR_DIR : ATTR_NONE) |
-		MSDOS_I(inode)->i_attrs;
+	u8 attrs = MSDOS_I(inode)->i_attrs;
+	if (S_ISDIR(inode->i_mode))
+		attrs |= ATTR_DIR;
+	if (fat_mode_can_hold_ro(inode) && !(inode->i_mode & S_IWUGO))
+		attrs |= ATTR_RO;
+	return attrs;
 }
 
 static inline void fat_save_attrs(struct inode *inode, u8 attrs)
 {
-	MSDOS_I(inode)->i_attrs = attrs & ATTR_UNUSED;
+	if (fat_mode_can_hold_ro(inode))
+		MSDOS_I(inode)->i_attrs = attrs & ATTR_UNUSED;
+	else
+		MSDOS_I(inode)->i_attrs = attrs & (ATTR_UNUSED | ATTR_RO);
 }
 
 static inline unsigned char fat_checksum(const __u8 *name)
diff -puN fs/fat/file.c~fat-fix-attr_ro-in-the-case-of-umask-s_wugo-==-0 fs/fat/file.c
--- a/fs/fat/file.c~fat-fix-attr_ro-in-the-case-of-umask-s_wugo-==-0
+++ a/fs/fat/file.c
@@ -27,7 +27,12 @@ int fat_generic_ioctl(struct inode *inod
 	switch (cmd) {
 	case FAT_IOCTL_GET_ATTRIBUTES:
 	{
-		u32 attr = fat_make_attrs(inode);
+		u32 attr;
+
+		mutex_lock(&inode->i_mutex);
+		attr = fat_make_attrs(inode);
+		mutex_unlock(&inode->i_mutex);
+
 		return put_user(attr, user_attr);
 	}
 	case FAT_IOCTL_SET_ATTRIBUTES:
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

origin.patch
fat-document-additional-vfat-mount-options.patch
fat-move-fs-vfat-and-fs-msdos-to-fs-fat.patch
fat-split-include-msdos_fsh.patch
fat-fix-and-cleanup-timestamp-conversion.patch
fat-use-generic_file_llseek-for-directory.patch
fat-cleanup-fat_parse_long-error-handling.patch
fat-improve-fat_hash.patch
fat-fix-fat_ent_update_ptr-for-fat12.patch
fat-use-fat_detach-in-fat_clear_inode.patch
vfat-fix-vfat_find-error-path-in-vfat_lookup.patch
fat-fix-cleanup-dcache-handling-for-vfat.patch
fat-kill-d_invalidate-in-vfat_lookup.patch
fat-cleanup-msdos_lookup.patch
fat-cleanup-fat-attribute-stuff.patch
fat-fix-attr_ro-in-the-case-of-umask-s_wugo-==-0.patch
fat-fix-attr_ro-for-directory.patch
fat-fix-_fat_bmap-race.patch
fat-add-printf-attribute-to-fat_fs_panic.patch
fat-mmu_private-race-fix.patch
fat-i_pos-race-fix.patch
fat-i_blocks-warning-fix.patch

