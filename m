From: akpm@linux-foundation.org
Subject: - fat-fix-attr_ro-in-the-case-of-umask-s_wugo-==-0.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:33:35 -0800
Message-ID: <200811102033.mAAKXZmn024557@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50412 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753191AbYKJUeH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:34:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     fat: Fix ATTR_RO in the case of (~umask & S_WUGO) == 0
has been removed from the -mm tree.  Its filename was
     fat-fix-attr_ro-in-the-case-of-umask-s_wugo-==-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

