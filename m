From: akpm@linux-foundation.org
Subject: + fat-relax-the-permission-check-of-fat_setattr.patch added to -mm tree
Date: Sun, 08 Jun 2008 13:47:57 -0700
Message-ID: <200806082047.m58KlvJ0019757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754490AbYFHUsA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 16:48:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp


The patch titled
     fat: relax the permission check of fat_setattr()
has been added to the -mm tree.  Its filename is
     fat-relax-the-permission-check-of-fat_setattr.patch

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
Subject: fat: relax the permission check of fat_setattr()
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

New chmod() allows only acceptable permission, and if not acceptable, it
returns -EPERM.  Old one allows even if it can't store permission to on
disk inode.  But it seems too strict for users.

E.g.  https://bugzilla.redhat.com/show_bug.cgi?id=449080: With new one,
rsync couldn't create the temporary file.

So, this patch allows like old one, but now it doesn't change the
permission if it can't store, and it returns 0.

Also, this patch fixes missing check.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/file.c |   44 +++++++++++++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff -puN fs/fat/file.c~fat-relax-the-permission-check-of-fat_setattr fs/fat/file.c
--- a/fs/fat/file.c~fat-relax-the-permission-check-of-fat_setattr
+++ a/fs/fat/file.c
@@ -257,26 +257,34 @@ int fat_getattr(struct vfsmount *mnt, st
 }
 EXPORT_SYMBOL_GPL(fat_getattr);
 
-static int fat_check_mode(const struct msdos_sb_info *sbi, struct inode *inode,
-			  mode_t mode)
+static int fat_sanitize_mode(const struct msdos_sb_info *sbi,
+			     struct inode *inode, umode_t *mode_ptr)
 {
-	mode_t mask, req = mode & ~S_IFMT;
+	mode_t mask, perm;
 
-	if (S_ISREG(mode))
+	/*
+	 * Note, the basic check is already done by a caller of
+	 * (attr->ia_mode & ~MSDOS_VALID_MODE)
+	 */
+
+	if (S_ISREG(inode->i_mode))
 		mask = sbi->options.fs_fmask;
 	else
 		mask = sbi->options.fs_dmask;
 
+	perm = *mode_ptr & ~(S_IFMT | mask);
+
 	/*
 	 * Of the r and x bits, all (subject to umask) must be present. Of the
 	 * w bits, either all (subject to umask) or none must be present.
 	 */
-	req &= ~mask;
-	if ((req & (S_IRUGO | S_IXUGO)) != (inode->i_mode & (S_IRUGO|S_IXUGO)))
+	if ((perm & (S_IRUGO | S_IXUGO)) != (inode->i_mode & (S_IRUGO|S_IXUGO)))
 		return -EPERM;
-	if ((req & S_IWUGO) && ((req & S_IWUGO) != (S_IWUGO & ~mask)))
+	if ((perm & S_IWUGO) && ((perm & S_IWUGO) != (S_IWUGO & ~mask)))
 		return -EPERM;
 
+	*mode_ptr &= S_IFMT | perm;
+
 	return 0;
 }
 
@@ -299,7 +307,7 @@ int fat_setattr(struct dentry *dentry, s
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(dentry->d_sb);
 	struct inode *inode = dentry->d_inode;
-	int mask, error = 0;
+	int error = 0;
 	unsigned int ia_valid;
 
 	lock_kernel();
@@ -332,12 +340,13 @@ int fat_setattr(struct dentry *dentry, s
 			error = 0;
 		goto out;
 	}
+
 	if (((attr->ia_valid & ATTR_UID) &&
 	     (attr->ia_uid != sbi->options.fs_uid)) ||
 	    ((attr->ia_valid & ATTR_GID) &&
 	     (attr->ia_gid != sbi->options.fs_gid)) ||
 	    ((attr->ia_valid & ATTR_MODE) &&
-	     fat_check_mode(sbi, inode, attr->ia_mode) < 0))
+	     (attr->ia_mode & ~MSDOS_VALID_MODE)))
 		error = -EPERM;
 
 	if (error) {
@@ -346,15 +355,16 @@ int fat_setattr(struct dentry *dentry, s
 		goto out;
 	}
 
-	error = inode_setattr(inode, attr);
-	if (error)
-		goto out;
+	/*
+	 * We don't return -EPERM here. Yes, strange, but this is too
+	 * old behavior.
+	 */
+	if (attr->ia_valid & ATTR_MODE) {
+		if (fat_sanitize_mode(sbi, inode, &attr->ia_mode) < 0)
+			attr->ia_valid &= ~ATTR_MODE;
+	}
 
-	if (S_ISDIR(inode->i_mode))
-		mask = sbi->options.fs_dmask;
-	else
-		mask = sbi->options.fs_fmask;
-	inode->i_mode &= S_IFMT | (S_IRWXUGO & ~mask);
+	error = inode_setattr(inode, attr);
 out:
 	unlock_kernel();
 	return error;
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

fat-relax-the-permission-check-of-fat_setattr.patch
linux-next.patch
msdos-fs-remove-unsettable-atari-option.patch

