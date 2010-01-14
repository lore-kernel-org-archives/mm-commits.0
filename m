From: akpm@linux-foundation.org
Subject: [to-be-updated] fs-make-sure-data-is-on-disk-before-calling-write_inode.patch removed from -mm tree
Date: Wed, 13 Jan 2010 22:23:52 -0800
Message-ID: <201001140623.o0E6NrFI020520@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751321Ab0ANGYQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Jan 2010 01:24:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, david@fromrobit.com, jack@suse.cz, trond.myklebust@fys.uio.no, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs: make sure data is on disk before calling ->write_inode
has been removed from the -mm tree.  Its filename was
     fs-make-sure-data-is-on-disk-before-calling-write_inode.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: make sure data is on disk before calling ->write_inode
From: Christoph Hellwig <hch@lst.de>

Similar to the fsync issue fixed a while ago in commit
2daea67e966dc0c42067ebea015ddac6834cef88 ("fsync: wait for data writeout
completion before calling ->fsync") we need to wait for data to actually
hit the disk before writing out the metadata to guarantee data integrity
for filesystems that modify the inode in the data I/O completion path. 

Currently XFS and NFS handle this manually and AFS has a write_inode()
method that does nothing but wait for data, while others are possibly
missing out on this.

Fortunately this change has a lot less impact than the fsync change as
none of the write_inode methods starts data writeout of any form by
itself.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Dave Chinner <david@fromrobit.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/internal.h            |    1 -
 fs/afs/super.c               |    1 -
 fs/afs/write.c               |   21 ---------------------
 fs/fs-writeback.c            |   15 ++++++++++-----
 fs/xfs/linux-2.6/xfs_super.c |    6 ------
 5 files changed, 10 insertions(+), 34 deletions(-)

diff -puN fs/afs/internal.h~fs-make-sure-data-is-on-disk-before-calling-write_inode fs/afs/internal.h
--- a/fs/afs/internal.h~fs-make-sure-data-is-on-disk-before-calling-write_inode
+++ a/fs/afs/internal.h
@@ -733,7 +733,6 @@ extern int afs_write_end(struct file *fi
 			struct page *page, void *fsdata);
 extern int afs_writepage(struct page *, struct writeback_control *);
 extern int afs_writepages(struct address_space *, struct writeback_control *);
-extern int afs_write_inode(struct inode *, int);
 extern void afs_pages_written_back(struct afs_vnode *, struct afs_call *);
 extern ssize_t afs_file_write(struct kiocb *, const struct iovec *,
 			      unsigned long, loff_t);
diff -puN fs/afs/super.c~fs-make-sure-data-is-on-disk-before-calling-write_inode fs/afs/super.c
--- a/fs/afs/super.c~fs-make-sure-data-is-on-disk-before-calling-write_inode
+++ a/fs/afs/super.c
@@ -48,7 +48,6 @@ struct file_system_type afs_fs_type = {
 static const struct super_operations afs_super_ops = {
 	.statfs		= afs_statfs,
 	.alloc_inode	= afs_alloc_inode,
-	.write_inode	= afs_write_inode,
 	.destroy_inode	= afs_destroy_inode,
 	.clear_inode	= afs_clear_inode,
 	.put_super	= afs_put_super,
diff -puN fs/afs/write.c~fs-make-sure-data-is-on-disk-before-calling-write_inode fs/afs/write.c
--- a/fs/afs/write.c~fs-make-sure-data-is-on-disk-before-calling-write_inode
+++ a/fs/afs/write.c
@@ -585,27 +585,6 @@ int afs_writepages(struct address_space 
 }
 
 /*
- * write an inode back
- */
-int afs_write_inode(struct inode *inode, int sync)
-{
-	struct afs_vnode *vnode = AFS_FS_I(inode);
-	int ret;
-
-	_enter("{%x:%u},", vnode->fid.vid, vnode->fid.vnode);
-
-	ret = 0;
-	if (sync) {
-		ret = filemap_fdatawait(inode->i_mapping);
-		if (ret < 0)
-			__mark_inode_dirty(inode, I_DIRTY_DATASYNC);
-	}
-
-	_leave(" = %d", ret);
-	return ret;
-}
-
-/*
  * completion of write to server
  */
 void afs_pages_written_back(struct afs_vnode *vnode, struct afs_call *call)
diff -puN fs/fs-writeback.c~fs-make-sure-data-is-on-disk-before-calling-write_inode fs/fs-writeback.c
--- a/fs/fs-writeback.c~fs-make-sure-data-is-on-disk-before-calling-write_inode
+++ a/fs/fs-writeback.c
@@ -472,15 +472,20 @@ writeback_single_inode(struct inode *ino
 
 	ret = do_writepages(mapping, wbc);
 
-	/* Don't write the inode if only I_DIRTY_PAGES was set */
-	if (dirty & (I_DIRTY_SYNC | I_DIRTY_DATASYNC)) {
-		int err = write_inode(inode, wait);
+	/*
+	 * Make sure to wait on the data before writing out the metadata.
+	 * This is important for filesystems that modify metadata on data
+	 * I/O completion.
+	 */
+	if (wait) {
+		int err = filemap_fdatawait(mapping);
 		if (ret == 0)
 			ret = err;
 	}
 
-	if (wait) {
-		int err = filemap_fdatawait(mapping);
+	/* Don't write the inode if only I_DIRTY_PAGES was set */
+	if (dirty & (I_DIRTY_SYNC | I_DIRTY_DATASYNC)) {
+		int err = write_inode(inode, wait);
 		if (ret == 0)
 			ret = err;
 	}
diff -puN fs/xfs/linux-2.6/xfs_super.c~fs-make-sure-data-is-on-disk-before-calling-write_inode fs/xfs/linux-2.6/xfs_super.c
--- a/fs/xfs/linux-2.6/xfs_super.c~fs-make-sure-data-is-on-disk-before-calling-write_inode
+++ a/fs/xfs/linux-2.6/xfs_super.c
@@ -1044,12 +1044,6 @@ xfs_fs_write_inode(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
-	if (sync) {
-		error = xfs_wait_on_pages(ip, 0, -1);
-		if (error)
-			goto out;
-	}
