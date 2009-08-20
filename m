From: akpm@linux-foundation.org
Subject: + udf-convert-to-use-the-new-truncate-convention.patch added to -mm tree
Date: Thu, 20 Aug 2009 15:48:37 -0700
Message-ID: <200908202248.n7KMmbTX029911@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58762 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932084AbZHTWts (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Aug 2009 18:49:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, chris.mason@oracle.com, hch@lst.de, hirofumi@mail.parknet.co.jp, hugh.dickins@tiscali.co.uk, jack@suse.cz, miklos@szeredi.hu, sfrench@us.ibm.com, shaggy@linux.vnet.ibm.com, trond.myklebust@fys.uio.no, viro@zeniv.linux.org.uk


The patch titled
     udf: convert to use the new truncate convention
has been added to the -mm tree.  Its filename is
     udf-convert-to-use-the-new-truncate-convention.patch

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
Subject: udf: convert to use the new truncate convention
From: Nick Piggin <npiggin@suse.de>

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
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

 fs/udf/file.c    |    3 +
 fs/udf/inode.c   |   73 +++++++++++++++++++++++++++++++++++++++++----
 fs/udf/udfdecl.h |    2 -
 3 files changed, 71 insertions(+), 7 deletions(-)

diff -puN fs/udf/file.c~udf-convert-to-use-the-new-truncate-convention fs/udf/file.c
--- a/fs/udf/file.c~udf-convert-to-use-the-new-truncate-convention
+++ a/fs/udf/file.c
@@ -215,5 +215,6 @@ const struct file_operations udf_file_op
 };
 
 const struct inode_operations udf_file_inode_operations = {
-	.truncate = udf_truncate,
+	.new_truncate = 1,
+	.setattr = udf_setattr,
 };
diff -puN fs/udf/inode.c~udf-convert-to-use-the-new-truncate-convention fs/udf/inode.c
--- a/fs/udf/inode.c~udf-convert-to-use-the-new-truncate-convention
+++ a/fs/udf/inode.c
@@ -67,6 +67,7 @@ static void udf_update_extents(struct in
 			       struct extent_position *);
 static int udf_get_block(struct inode *, sector_t, struct buffer_head *, int);
 
+static void udf_truncate_blocks(struct inode *inode);
 
 void udf_delete_inode(struct inode *inode)
 {
@@ -76,7 +77,7 @@ void udf_delete_inode(struct inode *inod
 		goto no_delete;
 
 	inode->i_size = 0;
-	udf_truncate(inode);
+	udf_truncate_blocks(inode);
 	lock_kernel();
 
 	udf_update_inode(inode, IS_SYNC(inode));
@@ -124,9 +125,34 @@ static int udf_write_begin(struct file *
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata)
 {
+	int ret;
+
 	*pagep = NULL;
-	return block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+	ret = block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
 				udf_get_block);
+	if (ret < 0) {
+		struct inode *inode = mapping->host;
+		loff_t isize = inode->i_size;
+		if (pos + len > isize)
+			udf_truncate_blocks(inode);
+	}
+	return ret;
+}
+
+static int udf_write_end(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned copied,
+			struct page *page, void *fsdata)
+{
+	int ret;
+
+	ret = generic_write_end(file, mapping, pos, len, copied, page, fsdata);
+	if (ret < len) {
+		struct inode *inode = mapping->host;
+		loff_t isize = inode->i_size;
+		if (pos + len > isize)
+			udf_truncate_blocks(inode);
+	}
+	return ret;
 }
 
 static sector_t udf_bmap(struct address_space *mapping, sector_t block)
@@ -138,8 +164,8 @@ const struct address_space_operations ud
 	.readpage	= udf_readpage,
 	.writepage	= udf_writepage,
 	.sync_page	= block_sync_page,
-	.write_begin		= udf_write_begin,
-	.write_end		= generic_write_end,
+	.write_begin	= udf_write_begin,
+	.write_end	= udf_write_end,
 	.bmap		= udf_bmap,
 };
 
@@ -1012,7 +1038,7 @@ struct buffer_head *udf_bread(struct ino
 	return NULL;
 }
 
-void udf_truncate(struct inode *inode)
+static void udf_truncate_blocks(struct inode *inode)
 {
 	int offset;
 	int err;
@@ -1058,6 +1084,43 @@ void udf_truncate(struct inode *inode)
 	unlock_kernel();
 }
 
+static int udf_setsize(struct inode *inode, loff_t newsize)
+{
+	loff_t oldsize;
+	int error;
+
+	error = inode_newsize_ok(inode, newsize);
+	if (error)
+		return error;
+
+	oldsize = inode->i_size;
+	i_size_write(inode, newsize);
+	truncate_pagecache(inode, oldsize, newsize);
+
+	udf_truncate_blocks(inode);
+
+	return error;
+}
+
+int udf_setattr(struct dentry *dentry, struct iattr *attr)
+{
+	struct inode *inode = dentry->d_inode;
+	int error;
+
+	if (attr->ia_valid & ATTR_SIZE) {
+		error = udf_setsize(inode, attr->ia_size);
+		if (error)
+			return error;
+	}
+
+	error = simple_setattr(dentry, attr);
+	if (error)
+		return error;
+
+	mark_inode_dirty(inode);
+	return error;
+}
+
 static void __udf_read_inode(struct inode *inode)
 {
 	struct buffer_head *bh = NULL;
diff -puN fs/udf/udfdecl.h~udf-convert-to-use-the-new-truncate-convention fs/udf/udfdecl.h
--- a/fs/udf/udfdecl.h~udf-convert-to-use-the-new-truncate-convention
+++ a/fs/udf/udfdecl.h
@@ -138,7 +138,7 @@ extern int udf_sync_inode(struct inode *
 extern void udf_expand_file_adinicb(struct inode *, int, int *);
 extern struct buffer_head *udf_expand_dir_adinicb(struct inode *, int *, int *);
 extern struct buffer_head *udf_bread(struct inode *, int, int, int *);
-extern void udf_truncate(struct inode *);
+extern int udf_setattr(struct dentry *, struct iattr *);
 extern void udf_read_inode(struct inode *);
 extern void udf_delete_inode(struct inode *);
 extern void udf_clear_inode(struct inode *);
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

