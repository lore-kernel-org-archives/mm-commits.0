From: akpm@linux-foundation.org
Subject: + fs-introduce-new-truncate-sequence.patch added to -mm tree
Date: Thu, 20 Aug 2009 15:48:22 -0700
Message-ID: <200908202248.n7KMmMma029487@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755417AbZHTWtY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Aug 2009 18:49:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, chris.mason@oracle.com, hch@lst.de, hirofumi@mail.parknet.co.jp, hugh.dickins@tiscali.co.uk, jack@suse.cz, miklos@szeredi.hu, sfrench@us.ibm.com, shaggy@linux.vnet.ibm.com, trond.myklebust@fys.uio.no, viro@zeniv.linux.org.uk


The patch titled
     fs: introduce new truncate sequence
has been added to the -mm tree.  Its filename is
     fs-introduce-new-truncate-sequence.patch

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
Subject: fs: introduce new truncate sequence
From: Nick Piggin <npiggin@suse.de>

Introduce a new truncate calling sequence into fs/mm subsystems.  Rather
than setattr > vmtruncate > truncate, have filesystems call their truncate
sequence from ->setattr if filesystem specific operations are required. 
vmtruncate is deprecated, and truncate_pagecache and inode_newsize_ok
helpers introduced previously should be used.

simple_setattr is introduced for simple in-ram filesystems to implement
the new truncate sequence.  Eventually all filesystems should be converted
to implement a setattr, and the default code in notify_change should go
away.

simple_setsize is also introduced to perform just the ATTR_SIZE portion of
simple_setattr (ie.  changing i_size and trimming pagecache).

A new attribute is introduced into inode_operations structure;
.new_truncate is a temporary hack to distinguish filesystems that
implement the new truncate system.

To implement the new truncate sequence:
- set .new_truncate = 1
- filesystem specific manipulations (eg freeing blocks) must be done in
  the setattr method rather than ->truncate.
- vmtruncate can not be used by core code to trim blocks past i_size in
  the event of write failure after allocation, so this must be performed
  in the fs code.
- make use of the better opportunity to catch errors with the above 2 changes.
- inode_setattr should not be used. generic_setattr is a new function
  to be used to copy simple attributes into the generic inode.

Big problem with the previous calling sequence: the filesystem is not
called until i_size has already changed.  This means it is not allowed to
fail the call, and also it does not know what the previous i_size was. 
Also, generic code calling vmtruncate to truncate allocated blocks in case
of error had no good way to return a meaningful error (or, for example,
atomically handle block deallocation).

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

 Documentation/filesystems/vfs.txt |    7 ++
 fs/attr.c                         |   51 +++++++++++++----
 fs/buffer.c                       |   12 +++-
 fs/direct-io.c                    |    7 +-
 fs/libfs.c                        |   83 ++++++++++++++++++++++++++++
 include/linux/fs.h                |    4 +
 mm/truncate.c                     |   10 +--
 7 files changed, 152 insertions(+), 22 deletions(-)

diff -puN Documentation/filesystems/vfs.txt~fs-introduce-new-truncate-sequence Documentation/filesystems/vfs.txt
--- a/Documentation/filesystems/vfs.txt~fs-introduce-new-truncate-sequence
+++ a/Documentation/filesystems/vfs.txt
@@ -402,11 +402,16 @@ otherwise noted.
   	started might not be in the page cache at the end of the
   	walk).
 
-  truncate: called by the VFS to change the size of a file.  The
+  truncate: Deprecated. This will not be called if ->setsize is defined.
+	Called by the VFS to change the size of a file.  The
  	i_size field of the inode is set to the desired size by the
  	VFS before this method is called.  This method is called by
  	the truncate(2) system call and related functionality.
 
+	Note: ->truncate and vmtruncate are deprecated. Do not add new
+	instances/calls of these. Filesystems shoud be converted to do their
+	truncate sequence via ->setattr().
+
   permission: called by the VFS to check for access rights on a POSIX-like
   	filesystem.
 
diff -puN fs/attr.c~fs-introduce-new-truncate-sequence fs/attr.c
--- a/fs/attr.c~fs-introduce-new-truncate-sequence
+++ a/fs/attr.c
@@ -68,14 +68,14 @@ EXPORT_SYMBOL(inode_change_ok);
  * @offset:	the new size to assign to the inode
  * @Returns:	0 on success, -ve errno on failure
  *
+ * inode_newsize_ok must be called with i_mutex held.
+ *
  * inode_newsize_ok will check filesystem limits and ulimits to check that the
  * new inode size is within limits. inode_newsize_ok will also send SIGXFSZ
  * when necessary. Caller must not proceed with inode size change if failure is
  * returned. @inode must be a file (not directory), with appropriate
  * permissions to allow truncate (inode_newsize_ok does NOT check these
  * conditions).
- *
- * inode_newsize_ok must be called with i_mutex held.
  */
 int inode_newsize_ok(struct inode *inode, loff_t offset)
 {
@@ -105,17 +105,25 @@ out_big:
 }
 EXPORT_SYMBOL(inode_newsize_ok);
 
-int inode_setattr(struct inode * inode, struct iattr * attr)
+/**
+ * generic_setattr - copy simple metadata updates into the generic inode
+ * @inode:	the inode to be updated
+ * @attr:	the new attributes
+ *
+ * generic_setattr must be called with i_mutex held.
+ *
+ * generic_setattr updates the inode's metadata with that specified
+ * in attr. Noticably missing is inode size update, which is more complex
+ * as it requires pagecache updates. See simple_setsize.
+ *
+ * The inode is not marked as dirty after this operation. The rationale is
+ * that for "simple" filesystems, the struct inode is the inode storage.
+ * The caller is free to mark the inode dirty afterwards if needed.
+ */
+void generic_setattr(struct inode *inode, struct iattr *attr)
 {
 	unsigned int ia_valid = attr->ia_valid;
 
-	if (ia_valid & ATTR_SIZE &&
-	    attr->ia_size != i_size_read(inode)) {
-		int error = vmtruncate(inode, attr->ia_size);
-		if (error)
-			return error;
-	}
-
 	if (ia_valid & ATTR_UID)
 		inode->i_uid = attr->ia_uid;
 	if (ia_valid & ATTR_GID)
@@ -136,6 +144,29 @@ int inode_setattr(struct inode * inode, 
 			mode &= ~S_ISGID;
 		inode->i_mode = mode;
 	}
+}
+EXPORT_SYMBOL(generic_setattr);
+
+/*
+ * note this function is deprecated, the new truncate sequence should be
+ * used instead -- see eg. simple_setsize, generic_setattr.
+ */
+int inode_setattr(struct inode *inode, struct iattr * attr)
+{
+	unsigned int ia_valid = attr->ia_valid;
+
+	if (ia_valid & ATTR_SIZE &&
+	    attr->ia_size != i_size_read(inode)) {
+		int error;
+
+		BUG_ON(inode->i_op->new_truncate);
+		error = vmtruncate(inode, attr->ia_size);
+		if (error)
+			return error;
+	}
+
+	generic_setattr(inode, attr);
+
 	mark_inode_dirty(inode);
 
 	return 0;
diff -puN fs/buffer.c~fs-introduce-new-truncate-sequence fs/buffer.c
--- a/fs/buffer.c~fs-introduce-new-truncate-sequence
+++ a/fs/buffer.c
@@ -1992,9 +1992,14 @@ int block_write_begin(struct file *file,
 			 * prepare_write() may have instantiated a few blocks
 			 * outside i_size.  Trim these off again. Don't need
 			 * i_size_read because we hold i_mutex.
+			 *
+			 * Filesystems which set i_op->new_truncate must
+			 * handle this themselves. Eventually this will go
+			 * away because everyone will be converted.
 			 */
 			if (pos + len > inode->i_size)
-				vmtruncate(inode, inode->i_size);
+				if (!inode->i_op->new_truncate)
+					vmtruncate(inode, inode->i_size);
 		}
 	}
 
@@ -2371,7 +2376,7 @@ int block_commit_write(struct page *page
  *
  * We are not allowed to take the i_mutex here so we have to play games to
  * protect against truncate races as the page could now be beyond EOF.  Because
- * vmtruncate() writes the inode size before removing pages, once we have the
+ * truncate writes the inode size before removing pages, once we have the
  * page lock we can determine safely if the page is beyond EOF. If it is not
  * beyond EOF, then the page is guaranteed safe against truncation until we
  * unlock the page.
@@ -2595,7 +2600,8 @@ out_release:
 	*pagep = NULL;
 
 	if (pos + len > inode->i_size)
-		vmtruncate(inode, inode->i_size);
+		if (!inode->i_op->new_truncate)
+			vmtruncate(inode, inode->i_size);
 
 	return ret;
 }
diff -puN fs/direct-io.c~fs-introduce-new-truncate-sequence fs/direct-io.c
--- a/fs/direct-io.c~fs-introduce-new-truncate-sequence
+++ a/fs/direct-io.c
@@ -1210,14 +1210,15 @@ __blockdev_direct_IO(int rw, struct kioc
 	/*
 	 * In case of error extending write may have instantiated a few
 	 * blocks outside i_size. Trim these off again for DIO_LOCKING.
-	 * NOTE: DIO_NO_LOCK/DIO_OWN_LOCK callers have to handle this by
-	 * it's own meaner.
+	 * NOTE: DIO_NO_LOCK/DIO_OWN_LOCK callers have to handle this in
+	 * their own manner.
 	 */
 	if (unlikely(retval < 0 && (rw & WRITE))) {
 		loff_t isize = i_size_read(inode);
 
 		if (end > isize && dio_lock_type == DIO_LOCKING)
-			vmtruncate(inode, isize);
+			if (!inode->i_op->new_truncate)
+				vmtruncate(inode, isize);
 	}
 
 	if (rw == READ && dio_lock_type == DIO_LOCKING)
diff -puN fs/libfs.c~fs-introduce-new-truncate-sequence fs/libfs.c
--- a/fs/libfs.c~fs-introduce-new-truncate-sequence
+++ a/fs/libfs.c
@@ -7,6 +7,7 @@
 #include <linux/pagemap.h>
 #include <linux/mount.h>
 #include <linux/vfs.h>
+#include <linux/quotaops.h>
 #include <linux/mutex.h>
 #include <linux/exportfs.h>
 #include <linux/writeback.h>
@@ -329,6 +330,88 @@ int simple_rename(struct inode *old_dir,
 	return 0;
 }
 
+/**
+ * simple_setsize - handle core mm and vfs requirements for file size change
+ * @inode: inode
+ * @newsize: new file size
+ *
+ * Returns 0 on success, -error on failure.
+ *
+ * simple_setsize must be called with inode_mutex held.
+ *
+ * simple_setsize will check that the requested new size is OK (see
+ * inode_newsize_ok), and then will perform the necessary i_size update
+ * and pagecache truncation (if necessary). It will be typically be called
+ * from the filesystem's setattr function when ATTR_SIZE is passed in.
+ *
+ * The inode itself must have correct permissions and attributes to allow
+ * i_size to be changed, this function then just checks that the new size
+ * requested is valid.
+ *
+ * In the case of simple in-memory filesystems with inodes stored solely
+ * in the inode cache, and file data in the pagecache, nothing more needs
+ * to be done to satisfy a truncate request. Filesystems with on-disk
+ * blocks for example will need to free them in the case of truncate, in
+ * that case it may be easier not to use simple_setsize (but each of its
+ * components will likely be required at some point to update pagecache
+ * and inode etc).
+ */
+int simple_setsize(struct inode *inode, loff_t newsize)
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
+	return error;
+}
+EXPORT_SYMBOL(simple_setsize);
+
+/**
+ * simple_setattr - setattr for simple in-memory filesystem
+ * @dentry: dentry
+ * @iattr: iattr structure
+ *
+ * Returns 0 on success, -error on failure.
+ *
+ * simple_setattr implements setattr for an in-memory filesystem which
+ * does not store its own file data or metadata (eg. uses the page cache
+ * and inode cache as its data store).
+ */
+int simple_setattr(struct dentry *dentry, struct iattr *iattr)
+{
+	struct inode *inode = dentry->d_inode;
+	int error;
+
+	error = inode_change_ok(inode, iattr);
+	if (error)
+		return error;
+
+	if ((iattr->ia_valid & ATTR_UID && iattr->ia_uid != inode->i_uid) ||
+	    (iattr->ia_valid & ATTR_GID && iattr->ia_gid != inode->i_gid)) {
+		error = vfs_dq_transfer(inode, iattr) ? -EDQUOT : 0;
+		if (error)
+			return error;
+	}
+
+	if (iattr->ia_valid & ATTR_SIZE) {
+		error = simple_setsize(inode, iattr->ia_size);
+		if (error)
+			return error;
+	}
+
+	generic_setattr(inode, iattr);
+
+	return error;
+}
+EXPORT_SYMBOL(simple_setattr);
+
 int simple_readpage(struct file *file, struct page *page)
 {
 	clear_highpage(page);
diff -puN include/linux/fs.h~fs-introduce-new-truncate-sequence include/linux/fs.h
--- a/include/linux/fs.h~fs-introduce-new-truncate-sequence
+++ a/include/linux/fs.h
@@ -1526,6 +1526,7 @@ struct inode_operations {
 	void * (*follow_link) (struct dentry *, struct nameidata *);
 	void (*put_link) (struct dentry *, struct nameidata *, void *);
 	void (*truncate) (struct inode *);
+	int new_truncate; /* nasty hack to transition to new truncate code */
 	int (*permission) (struct inode *, int);
 	int (*setattr) (struct dentry *, struct iattr *);
 	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *);
@@ -2347,12 +2348,14 @@ extern int dcache_dir_open(struct inode 
 extern int dcache_dir_close(struct inode *, struct file *);
 extern loff_t dcache_dir_lseek(struct file *, loff_t, int);
 extern int dcache_readdir(struct file *, void *, filldir_t);
+extern int simple_setattr(struct dentry *dentry, struct iattr *attr);
 extern int simple_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 extern int simple_statfs(struct dentry *, struct kstatfs *);
 extern int simple_link(struct dentry *, struct inode *, struct dentry *);
 extern int simple_unlink(struct inode *, struct dentry *);
 extern int simple_rmdir(struct inode *, struct dentry *);
 extern int simple_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
+extern int simple_setsize(struct inode *inode, loff_t newsize);
 extern int simple_sync_file(struct file *, struct dentry *, int);
 extern int simple_empty(struct dentry *);
 extern int simple_readpage(struct file *file, struct page *page);
@@ -2390,6 +2393,7 @@ extern int buffer_migrate_page(struct ad
 extern int inode_change_ok(struct inode *, struct iattr *);
 extern int inode_newsize_ok(struct inode *, loff_t offset);
 extern int __must_check inode_setattr(struct inode *, struct iattr *);
+extern void generic_setattr(struct inode *inode, struct iattr *attr);
 
 extern void file_update_time(struct file *file);
 
diff -puN mm/truncate.c~fs-introduce-new-truncate-sequence mm/truncate.c
--- a/mm/truncate.c~fs-introduce-new-truncate-sequence
+++ a/mm/truncate.c
@@ -543,18 +543,18 @@ EXPORT_SYMBOL(truncate_pagecache);
  * NOTE! We have to be ready to update the memory sharing
  * between the file and the memory map for a potential last
  * incomplete page.  Ugly, but necessary.
+ *
+ * This function is deprecated and simple_setsize or truncate_pagecache
+ * should be used instead.
  */
 int vmtruncate(struct inode *inode, loff_t offset)
 {
-	loff_t oldsize;
 	int error;
 
-	error = inode_newsize_ok(inode, offset);
+	error = simple_setsize(inode, offset);
 	if (error)
 		return error;
-	oldsize = inode->i_size;
-	i_size_write(inode, offset);
-	truncate_pagecache(inode, oldsize, offset);
+
 	if (inode->i_op->truncate)
 		inode->i_op->truncate(inode);
 
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

