From: akpm@linux-foundation.org
Subject: + fat-fix-oops-on-corrupted-vfat-fs.patch added to -mm tree
Date: Wed, 26 Nov 2014 14:28:34 -0800
Message-ID: <54765412.5cSSD+fxMKQxhwSB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43916 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbaKZW2f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Nov 2014 17:28:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, stable@vger.kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: Fix oops on corrupted vfat fs
has been added to the -mm tree.  Its filename is
     fat-fix-oops-on-corrupted-vfat-fs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fat-fix-oops-on-corrupted-vfat-fs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fat-fix-oops-on-corrupted-vfat-fs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: fat: Fix oops on corrupted vfat fs

a) don't bother with ->d_time for positives - we only check it for negatives
anyway.
b) make sure to set it at unlink and rmdir time - at *that* point soon-to-be
negative dentry matches then-current directory contents
c) don't go into renaming of old alias in vfat_lookup() unless it has
the same parent (which it will, unless we are seeing corrupted image)

[hirofumi@mail.parknet.co.jp: make change minimum, don't call d_move() for dir]
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: <stable@vger.kernel.org>	[3.17.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/namei_vfat.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff -puN fs/fat/namei_vfat.c~fat-fix-oops-on-corrupted-vfat-fs fs/fat/namei_vfat.c
--- a/fs/fat/namei_vfat.c~fat-fix-oops-on-corrupted-vfat-fs
+++ a/fs/fat/namei_vfat.c
@@ -736,7 +736,12 @@ static struct dentry *vfat_lookup(struct
 	}
 
 	alias = d_find_alias(inode);
-	if (alias && !vfat_d_anon_disconn(alias)) {
+	/*
+	 * Checking "alias->d_parent == dentry->d_parent" to make sure
+	 * FS is not corrupted (especially double linked dir).
+	 */
+	if (alias && alias->d_parent == dentry->d_parent &&
+	    !vfat_d_anon_disconn(alias)) {
 		/*
 		 * This inode has non anonymous-DCACHE_DISCONNECTED
 		 * dentry. This means, the user did ->lookup() by an
@@ -755,12 +760,9 @@ static struct dentry *vfat_lookup(struct
 
 out:
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
-	dentry->d_time = dentry->d_parent->d_inode->i_version;
-	dentry = d_splice_alias(inode, dentry);
-	if (dentry)
-		dentry->d_time = dentry->d_parent->d_inode->i_version;
-	return dentry;
-
+	if (!inode)
+		dentry->d_time = dir->i_version;
+	return d_splice_alias(inode, dentry);
 error:
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	return ERR_PTR(err);
@@ -793,7 +795,6 @@ static int vfat_create(struct inode *dir
 	inode->i_mtime = inode->i_atime = inode->i_ctime = ts;
 	/* timestamp is already written, so mark_inode_dirty() is unneeded. */
 
-	dentry->d_time = dentry->d_parent->d_inode->i_version;
 	d_instantiate(dentry, inode);
 out:
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
@@ -824,6 +825,7 @@ static int vfat_rmdir(struct inode *dir,
 	clear_nlink(inode);
 	inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
 	fat_detach(inode);
+	dentry->d_time = dir->i_version;
 out:
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 
@@ -849,6 +851,7 @@ static int vfat_unlink(struct inode *dir
 	clear_nlink(inode);
 	inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
 	fat_detach(inode);
+	dentry->d_time = dir->i_version;
 out:
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 
@@ -889,7 +892,6 @@ static int vfat_mkdir(struct inode *dir,
 	inode->i_mtime = inode->i_atime = inode->i_ctime = ts;
 	/* timestamp is already written, so mark_inode_dirty() is unneeded. */
 
-	dentry->d_time = dentry->d_parent->d_inode->i_version;
 	d_instantiate(dentry, inode);
 
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

fat-fix-oops-on-corrupted-vfat-fs.patch
fat-add-fat_fallocate-operation.patch
fat-skip-cluster-allocation-on-fallocated-region.patch
fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region.patch
documentation-filesystems-vfattxt-update-the-limitation-for-fat-fallocate.patch
fat-fix-data-past-eof-resulting-from-fsx-testsuite.patch
fat-fix-data-past-eof-resulting-from-fsx-testsuite-v2.patch

