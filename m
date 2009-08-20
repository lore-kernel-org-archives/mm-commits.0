From: akpm@linux-foundation.org
Subject: + fs-convert-simple-fs-to-new-truncate.patch added to -mm tree
Date: Thu, 20 Aug 2009 15:48:24 -0700
Message-ID: <200908202248.n7KMmPmS029577@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755181AbZHTWtb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Aug 2009 18:49:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, chris.mason@oracle.com, hch@lst.de, hirofumi@mail.parknet.co.jp, hugh.dickins@tiscali.co.uk, jack@suse.cz, miklos@szeredi.hu, sfrench@us.ibm.com, shaggy@linux.vnet.ibm.com, trond.myklebust@fys.uio.no, viro@zeniv.linux.org.uk


The patch titled
     fs: convert simple fs to new truncate
has been added to the -mm tree.  Its filename is
     fs-convert-simple-fs-to-new-truncate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: convert simple fs to new truncate
From: Nick Piggin <npiggin@suse.de>

Convert simple filesystems: ramfs, configfs, sysfs to new truncate
sequence.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Steven French <sfrench@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/configfs/inode.c   |   11 ++++++++---
 fs/ramfs/file-mmu.c   |    2 ++
 fs/ramfs/file-nommu.c |    8 +++++---
 fs/sysfs/inode.c      |    7 ++-----
 4 files changed, 17 insertions(+), 11 deletions(-)

diff -puN fs/configfs/inode.c~fs-convert-simple-fs-to-new-truncate fs/configfs/inode.c
--- a/fs/configfs/inode.c~fs-convert-simple-fs-to-new-truncate
+++ a/fs/configfs/inode.c
@@ -57,6 +57,7 @@ static struct backing_dev_info configfs_
 };
 
 static const struct inode_operations configfs_inode_operations ={
+	.new_truncate	= 1,
 	.setattr	= configfs_setattr,
 };
 
@@ -77,9 +78,13 @@ int configfs_setattr(struct dentry * den
 	if (error)
 		return error;
 
-	error = inode_setattr(inode, iattr);
-	if (error)
-		return error;
+	if (iattr->ia_valid & ATTR_SIZE) {
+		error = simple_setsize(inode, iattr->ia_size);
+		if (error)
+			return error;
+	}
+
+	generic_setattr(inode, iattr);
 
 	if (!sd_iattr) {
 		/* setting attributes for the first time, allocate now */
diff -puN fs/ramfs/file-mmu.c~fs-convert-simple-fs-to-new-truncate fs/ramfs/file-mmu.c
--- a/fs/ramfs/file-mmu.c~fs-convert-simple-fs-to-new-truncate
+++ a/fs/ramfs/file-mmu.c
@@ -50,5 +50,7 @@ const struct file_operations ramfs_file_
 };
 
 const struct inode_operations ramfs_file_inode_operations = {
+	.new_truncate	= 1,
+	.setattr	= simple_setattr,
 	.getattr	= simple_getattr,
 };
diff -puN fs/ramfs/file-nommu.c~fs-convert-simple-fs-to-new-truncate fs/ramfs/file-nommu.c
--- a/fs/ramfs/file-nommu.c~fs-convert-simple-fs-to-new-truncate
+++ a/fs/ramfs/file-nommu.c
@@ -48,6 +48,7 @@ const struct file_operations ramfs_file_
 };
 
 const struct inode_operations ramfs_file_inode_operations = {
+	.new_truncate		= 1,
 	.setattr		= ramfs_nommu_setattr,
 	.getattr		= simple_getattr,
 };
@@ -169,7 +170,7 @@ static int ramfs_nommu_resize(struct ino
 			return ret;
 	}
 
-	ret = vmtruncate(inode, newsize);
+	ret = simple_setsize(inode, newsize);
 
 	return ret;
 }
@@ -192,7 +193,8 @@ static int ramfs_nommu_setattr(struct de
 
 	/* pick out size-changing events */
 	if (ia->ia_valid & ATTR_SIZE) {
-		loff_t size = i_size_read(inode);
+		loff_t size = inode->i_size;
+
 		if (ia->ia_size != size) {
 			ret = ramfs_nommu_resize(inode, ia->ia_size, size);
 			if (ret < 0 || ia->ia_valid == ATTR_SIZE)
@@ -205,7 +207,7 @@ static int ramfs_nommu_setattr(struct de
 		}
 	}
 
-	ret = inode_setattr(inode, ia);
+	generic_setattr(inode, ia);
  out:
 	ia->ia_valid = old_ia_valid;
 	return ret;
diff -puN fs/sysfs/inode.c~fs-convert-simple-fs-to-new-truncate fs/sysfs/inode.c
--- a/fs/sysfs/inode.c~fs-convert-simple-fs-to-new-truncate
+++ a/fs/sysfs/inode.c
@@ -35,6 +35,7 @@ static struct backing_dev_info sysfs_bac
 };
 
 static const struct inode_operations sysfs_inode_operations ={
+	.new_truncate	= 1,
 	.setattr	= sysfs_setattr,
 };
 
@@ -60,11 +61,7 @@ int sysfs_setattr(struct dentry * dentry
 	if (error)
 		return error;
 
-	iattr->ia_valid &= ~ATTR_SIZE; /* ignore size changes */
-
-	error = inode_setattr(inode, iattr);
-	if (error)
-		return error;
+	generic_setattr(inode, iattr);
 
 	if (!sd_iattr) {
 		/* setting attributes for the first time, allocate now */
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
ksm-no-debug-in-page_dup_rmap.patch
fs-turn-iprune_mutex-into-rwsem.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

