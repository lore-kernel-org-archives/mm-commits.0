From: akpm@osdl.org
Subject: - isofs-change-uses-of-f_dentry.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:01:50 -0800
Message-ID: <200612082001.kB8K1oT6001912@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56968 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426239AbWLHUCM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:02:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     isofs: change uses of f_{dentry, vfsmnt} to use f_path
has been removed from the -mm tree.  Its filename was
     isofs-change-uses-of-f_dentry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: isofs: change uses of f_{dentry, vfsmnt} to use f_path
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

Change all the uses of f_{dentry,vfsmnt} to f_path.{dentry,mnt} in the isofs
filesystem.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/isofs/compress.c |    2 +-
 fs/isofs/dir.c      |    5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff -puN fs/isofs/compress.c~isofs-change-uses-of-f_dentry fs/isofs/compress.c
--- a/fs/isofs/compress.c~isofs-change-uses-of-f_dentry
+++ a/fs/isofs/compress.c
@@ -42,7 +42,7 @@ static struct semaphore zisofs_zlib_sema
  */
 static int zisofs_readpage(struct file *file, struct page *page)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	struct address_space *mapping = inode->i_mapping;
 	unsigned int maxpage, xpage, fpage, blockindex;
 	unsigned long offset;
diff -puN fs/isofs/dir.c~isofs-change-uses-of-f_dentry fs/isofs/dir.c
--- a/fs/isofs/dir.c~isofs-change-uses-of-f_dentry
+++ a/fs/isofs/dir.c
@@ -183,7 +183,7 @@ static int do_isofs_readdir(struct inode
 
 		/* Handle the case of the '..' directory */
 		if (de->name_len[0] == 1 && de->name[0] == 1) {
-			inode_number = parent_ino(filp->f_dentry);
+			inode_number = parent_ino(filp->f_path.dentry);
 			if (filldir(dirent, "..", 2, filp->f_pos, inode_number, DT_DIR) < 0)
 				break;
 			filp->f_pos += de_len;
@@ -255,8 +255,7 @@ static int isofs_readdir(struct file *fi
 	int result;
 	char * tmpname;
 	struct iso_directory_record * tmpde;
-	struct inode *inode = filp->f_dentry->d_inode;
-
+	struct inode *inode = filp->f_path.dentry->d_inode;
 
 	tmpname = (char *)__get_free_page(GFP_KERNEL);
 	if (tmpname == NULL)
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

isofs-change-uses-of-f_dentry.patch
nfs-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
nfsd-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ntfs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
i386-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
x86_64-change-uses-of-f_dentry.patch
kernel-change-uses-of-f_dentry.patch
mm-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
9p-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
affs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
autofs-change-uses-of-f_dentry.patch
autofs4-change-uses-of-f_dentry.patch
configfs-change-uses-of-f_dentry.patch
cifs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ecryptfs-change-uses-of-f_dentry.patch
xfs-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch

