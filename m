From: akpm@linux-foundation.org
Subject: + fat-fat_setattr-fix.patch added to -mm tree
Date: Sun, 27 Apr 2008 12:07:44 -0700
Message-ID: <200804271907.m3RJ7ii9020426@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762985AbYD0THr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 15:07:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp


The patch titled
     fat: fat_setattr() fix
has been added to the -mm tree.  Its filename is
     fat-fat_setattr-fix.patch

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
Subject: fat: fat_setattr() fix
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Fix fat_setattr() on the case of showexec option. If user specified
showexec option, inode->i_mode may not have S_IXUGO. This just use
inode->i_mode to fix it.

And with this patch, we don't allow chmod() on memory inode, it's just
bad behaviour. IOW, we allow changing S_IWUGO only which can be stored
to disk.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/file.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN fs/fat/file.c~fat-fat_setattr-fix fs/fat/file.c
--- a/fs/fat/file.c~fat-fat_setattr-fix
+++ a/fs/fat/file.c
@@ -257,7 +257,8 @@ int fat_getattr(struct vfsmount *mnt, st
 }
 EXPORT_SYMBOL_GPL(fat_getattr);
 
-static int fat_check_mode(const struct msdos_sb_info *sbi, mode_t mode)
+static int fat_check_mode(const struct msdos_sb_info *sbi, struct inode *inode,
+			  mode_t mode)
 {
 	mode_t mask, req = mode & ~S_IFMT;
 
@@ -271,7 +272,7 @@ static int fat_check_mode(const struct m
 	 * w bits, either all (subject to umask) or none must be present.
 	 */
 	req &= ~mask;
-	if ((req & (S_IRUGO | S_IXUGO)) != ((S_IRUGO | S_IXUGO) & ~mask))
+	if ((req & (S_IRUGO | S_IXUGO)) != (inode->i_mode & (S_IRUGO|S_IXUGO)))
 		return -EPERM;
 	if ((req & S_IWUGO) && ((req & S_IWUGO) != (S_IWUGO & ~mask)))
 		return -EPERM;
@@ -310,7 +311,9 @@ int fat_setattr(struct dentry *dentry, s
 	if (((attr->ia_valid & ATTR_UID) &&
 	     (attr->ia_uid != sbi->options.fs_uid)) ||
 	    ((attr->ia_valid & ATTR_GID) &&
-	     (attr->ia_gid != sbi->options.fs_gid)))
+	     (attr->ia_gid != sbi->options.fs_gid)) ||
+	    ((attr->ia_valid & ATTR_MODE) &&
+	     fat_check_mode(sbi, inode, attr->ia_mode) < 0))
 		error = -EPERM;
 
 	if (error) {
@@ -319,12 +322,6 @@ int fat_setattr(struct dentry *dentry, s
 		goto out;
 	}
 
-	if (attr->ia_valid & ATTR_MODE) {
-		error = fat_check_mode(sbi, attr->ia_mode);
-		if (error != 0 && !sbi->options.quiet)
-			goto out;
-	}
