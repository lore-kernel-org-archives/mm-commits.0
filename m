From: akpm@linux-foundation.org
Subject: + jfs-convert-to-use-the-new-truncate-convention.patch added to -mm tree
Date: Thu, 20 Aug 2009 15:48:35 -0700
Message-ID: <200908202248.n7KMmapc029896@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755294AbZHTWt2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Aug 2009 18:49:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, chris.mason@oracle.com, hch@lst.de, hirofumi@mail.parknet.co.jp, hugh.dickins@tiscali.co.uk, jack@suse.cz, miklos@szeredi.hu, sfrench@us.ibm.com, shaggy@linux.vnet.ibm.com, trond.myklebust@fys.uio.no, viro@zeniv.linux.org.uk


The patch titled
     jfs: convert to use the new truncate convention
has been added to the -mm tree.  Its filename is
     jfs-convert-to-use-the-new-truncate-convention.patch

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
Subject: jfs: convert to use the new truncate convention
From: Nick Piggin <npiggin@suse.de>

Note I wasn't able to test jfs because the kernel wasn't mounting the
product of my mkfs.jfs for some reason.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Steven French <sfrench@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jfs/acl.c       |   12 ++-------
 fs/jfs/file.c      |    2 -
 fs/jfs/inode.c     |   56 +++++++++++++++++++++++++++++++++++--------
 fs/jfs/jfs_inode.h |    5 ++-
 fs/jfs/jfs_xtree.c |    2 -
 fs/jfs/namei.c     |    6 ++--
 6 files changed, 57 insertions(+), 26 deletions(-)

diff -puN fs/jfs/acl.c~jfs-convert-to-use-the-new-truncate-convention fs/jfs/acl.c
--- a/fs/jfs/acl.c~jfs-convert-to-use-the-new-truncate-convention
+++ a/fs/jfs/acl.c
@@ -216,20 +216,14 @@ int jfs_setattr(struct dentry *dentry, s
 	struct inode *inode = dentry->d_inode;
 	int rc;
 
-	rc = inode_change_ok(inode, iattr);
+	rc = simple_setattr(dentry, iattr);
 	if (rc)
 		return rc;
 
-	if ((iattr->ia_valid & ATTR_UID && iattr->ia_uid != inode->i_uid) ||
-	    (iattr->ia_valid & ATTR_GID && iattr->ia_gid != inode->i_gid)) {
-		if (vfs_dq_transfer(inode, iattr))
-			return -EDQUOT;
-	}
-
-	rc = inode_setattr(inode, iattr);
-
 	if (!rc && (iattr->ia_valid & ATTR_MODE))
 		rc = jfs_acl_chmod(inode);
 
+	mark_inode_dirty(inode);
+
 	return rc;
 }
diff -puN fs/jfs/file.c~jfs-convert-to-use-the-new-truncate-convention fs/jfs/file.c
--- a/fs/jfs/file.c~jfs-convert-to-use-the-new-truncate-convention
+++ a/fs/jfs/file.c
@@ -89,7 +89,7 @@ static int jfs_release(struct inode *ino
 }
 
 const struct inode_operations jfs_file_inode_operations = {
-	.truncate	= jfs_truncate,
+	.new_truncate	= 1,
 	.setxattr	= jfs_setxattr,
 	.getxattr	= jfs_getxattr,
 	.listxattr	= jfs_listxattr,
diff -puN fs/jfs/inode.c~jfs-convert-to-use-the-new-truncate-convention fs/jfs/inode.c
--- a/fs/jfs/inode.c~jfs-convert-to-use-the-new-truncate-convention
+++ a/fs/jfs/inode.c
@@ -297,8 +297,33 @@ static int jfs_write_begin(struct file *
 				loff_t pos, unsigned len, unsigned flags,
 				struct page **pagep, void **fsdata)
 {
-	return nobh_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
+	int ret;
+
+	ret = nobh_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
 				jfs_get_block);
+	if (ret < 0) {
+		struct inode *inode = mapping->host;
+		loff_t isize = inode->i_size;
+		if (pos + len > isize)
+			jfs_truncate_blocks(inode, isize);
+	}
+	return ret;
+}
+
+static int jfs_write_end(struct file *file, struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned copied,
+				struct page *page, void *fsdata)
+{
+	int ret;
+
+	ret = nobh_write_end(file, mapping, pos, len, copied, page, fsdata);
+	if (ret < len) {
+		struct inode *inode = mapping->host;
+		loff_t isize = inode->i_size;
+		if (pos + len > isize)
+			jfs_truncate_blocks(inode, isize);
+	}
+	return ret;
 }
 
 static sector_t jfs_bmap(struct address_space *mapping, sector_t block)
@@ -311,9 +336,13 @@ static ssize_t jfs_direct_IO(int rw, str
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
+	ssize_t ret;
 
-	return blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
+	ret = blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
 				offset, nr_segs, jfs_get_block, NULL);
+	if (ret < 0)
+		jfs_truncate_blocks(inode, inode->i_size);
+	return ret;
 }
 
 const struct address_space_operations jfs_aops = {
@@ -323,16 +352,16 @@ const struct address_space_operations jf
 	.writepages	= jfs_writepages,
 	.sync_page	= block_sync_page,
 	.write_begin	= jfs_write_begin,
-	.write_end	= nobh_write_end,
+	.write_end	= jfs_write_end,
 	.bmap		= jfs_bmap,
 	.direct_IO	= jfs_direct_IO,
 };
 
 /*
- * Guts of jfs_truncate.  Called with locks already held.  Can be called
+ * Guts of jfs_truncate_blocks.  Called with locks already held.  Can be called
  * with directory for truncating directory index table.
  */
-void jfs_truncate_nolock(struct inode *ip, loff_t length)
+void jfs_truncate_blocks_nolock(struct inode *ip, loff_t length)
 {
 	loff_t newsize;
 	tid_t tid;
@@ -372,13 +401,20 @@ void jfs_truncate_nolock(struct inode *i
 	} while (newsize > length);	/* Truncate isn't always atomic */
 }
 
-void jfs_truncate(struct inode *ip)
+void jfs_truncate_blocks(struct inode *ip, loff_t offset)
 {
-	jfs_info("jfs_truncate: size = 0x%lx", (ulong) ip->i_size);
-
-	nobh_truncate_page(ip->i_mapping, ip->i_size, jfs_get_block);
+	jfs_info("jfs_truncate: size = 0x%lx", (ulong) offset);
 
 	IWRITE_LOCK(ip, RDWRLOCK_NORMAL);
-	jfs_truncate_nolock(ip, ip->i_size);
+	jfs_truncate_blocks_nolock(ip, offset);
 	IWRITE_UNLOCK(ip);
 }
+
+void jfs_setsize(struct inode *ip, loff_t offset)
+{
+	simple_setsize(ip, offset);
+
+	nobh_truncate_page(ip->i_mapping, offset, jfs_get_block);
+
+	jfs_truncate_blocks(ip, offset);
+}
diff -puN fs/jfs/jfs_inode.h~jfs-convert-to-use-the-new-truncate-convention fs/jfs/jfs_inode.h
--- a/fs/jfs/jfs_inode.h~jfs-convert-to-use-the-new-truncate-convention
+++ a/fs/jfs/jfs_inode.h
@@ -29,8 +29,9 @@ extern int jfs_commit_inode(struct inode
 extern int jfs_write_inode(struct inode*, int);
 extern void jfs_delete_inode(struct inode *);
 extern void jfs_dirty_inode(struct inode *);
-extern void jfs_truncate(struct inode *);
-extern void jfs_truncate_nolock(struct inode *, loff_t);
+extern void jfs_truncate_blocks(struct inode *, loff_t);
+extern void jfs_truncate_blocks_nolock(struct inode *, loff_t);
+extern void jfs_setsize(struct inode *, loff_t);
 extern void jfs_free_zero_link(struct inode *);
 extern struct dentry *jfs_get_parent(struct dentry *dentry);
 extern void jfs_get_inode_flags(struct jfs_inode_info *);
diff -puN fs/jfs/jfs_xtree.c~jfs-convert-to-use-the-new-truncate-convention fs/jfs/jfs_xtree.c
--- a/fs/jfs/jfs_xtree.c~jfs-convert-to-use-the-new-truncate-convention
+++ a/fs/jfs/jfs_xtree.c
@@ -3132,7 +3132,7 @@ void xtInitRoot(tid_t tid, struct inode 
  * note:
  *	PWMAP:
  *	 1. truncate (non-COMMIT_NOLINK file)
- *	    by jfs_truncate() or jfs_open(O_TRUNC):
+ *	    by jfs_setsize() or jfs_open(O_TRUNC):
  *	    xtree is updated;
  *	 2. truncate index table of directory when last entry removed
  *	map update via tlock at commit time;
diff -puN fs/jfs/namei.c~jfs-convert-to-use-the-new-truncate-convention fs/jfs/namei.c
--- a/fs/jfs/namei.c~jfs-convert-to-use-the-new-truncate-convention
+++ a/fs/jfs/namei.c
@@ -435,7 +435,7 @@ static int jfs_rmdir(struct inode *dip, 
 	 */
 	if (test_cflag(COMMIT_Stale, dip)) {
 		if (dip->i_size > 1)
-			jfs_truncate_nolock(dip, 0);
+			jfs_truncate_blocks_nolock(dip, 0);
 
 		clear_cflag(COMMIT_Stale, dip);
 	}
@@ -586,7 +586,7 @@ static int jfs_unlink(struct inode *dip,
 	 */
 	if (test_cflag(COMMIT_Stale, dip)) {
 		if (dip->i_size > 1)
-			jfs_truncate_nolock(dip, 0);
+			jfs_truncate_blocks_nolock(dip, 0);
 
 		clear_cflag(COMMIT_Stale, dip);
 	}
@@ -1327,7 +1327,7 @@ static int jfs_rename(struct inode *old_
 	 */
 	if (test_cflag(COMMIT_Stale, old_dir)) {
 		if (old_dir->i_size > 1)
-			jfs_truncate_nolock(old_dir, 0);
+			jfs_truncate_blocks_nolock(old_dir, 0);
 
 		clear_cflag(COMMIT_Stale, old_dir);
 	}
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

