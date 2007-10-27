From: akpm@linux-foundation.org
Subject: + iget-remove-iget-and-the-read_inode-super-op-as.patch added to -mm tree
Date: Sat, 27 Oct 2007 00:52:31 -0700
Message-ID: <200710270752.l9R7qVv8003637@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35195 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752602AbXJ0Hwp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Oct 2007 03:52:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     iget: remove iget() and the read_inode() super op as being obsolete
has been added to the -mm tree.  Its filename is
     iget-remove-iget-and-the-read_inode-super-op-as.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iget: remove iget() and the read_inode() super op as being obsolete
From: David Howells <dhowells@redhat.com>

Remove the old iget() call and the read_inode() superblock operation it uses
as these are really obsolete, and the use of read_inode() does not produce
proper error handling (no distinction between ENOMEM and EIO when marking an
inode bad).

Furthermore, this removes the temptation to use iget() to find an inode by
number in a filesystem from code outside that filesystem.

iget_locked() should be used instead.  A new function is added in an earlier
patch (iget_failed) that is to be called to mark an inode as bad, unlock it
and release it should the get routine fail.  Mark iget() and read_inode() as
being obsolete and remove references to them from the documentation.

Typically a filesystem will be modified such that the read_inode function
becomes an internal iget function, for example the following:

	void thingyfs_read_inode(struct inode *inode)
	{
		...
	}

would be changed into something like:

	struct inode *thingyfs_iget(struct super_block *sp, unsigned long ino)
	{
		struct inode *inode;
		int ret;

		inode = iget_locked(sb, ino);
		if (!inode)
			return ERR_PTR(-ENOMEM);
		if (!(inode->i_state & I_NEW))
			return inode;

		...
		unlock_new_inode(inode);
		return inode;
	error:
		iget_failed(inode);
		return ERR_PTR(ret);
	}

and then thingyfs_iget() would be called rather than iget(), for example:

	ret = -EINVAL;
	inode = iget(sb, ino);
	if (!inode || is_bad_inode(inode))
		goto error;

becomes:

	inode = thingyfs_iget(sb, ino);
	if (IS_ERR(inode)) {
		ret = PTR_ERR(inode);
		goto error;
	}

Note that is_bad_inode() does not need to be called.  The error returned by
thingyfs_iget() should render it unnecessary.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/Locking |    3 ---
 Documentation/filesystems/porting |   12 ++++++------
 Documentation/filesystems/vfs.txt |   17 +++--------------
 fs/inode.c                        |    4 ----
 include/linux/fs.h                |   14 --------------
 5 files changed, 9 insertions(+), 41 deletions(-)

diff -puN Documentation/filesystems/Locking~iget-remove-iget-and-the-read_inode-super-op-as Documentation/filesystems/Locking
--- a/Documentation/filesystems/Locking~iget-remove-iget-and-the-read_inode-super-op-as
+++ a/Documentation/filesystems/Locking
@@ -90,7 +90,6 @@ of the locking scheme for directory oper
 prototypes:
 	struct inode *(*alloc_inode)(struct super_block *sb);
 	void (*destroy_inode)(struct inode *);
-	void (*read_inode) (struct inode *);
 	void (*dirty_inode) (struct inode *);
 	int (*write_inode) (struct inode *, int);
 	void (*put_inode) (struct inode *);
@@ -114,7 +113,6 @@ locking rules:
 			BKL	s_lock	s_umount
 alloc_inode:		no	no	no
 destroy_inode:		no
-read_inode:		no				(see below)
 dirty_inode:		no				(must not sleep)
 write_inode:		no
 put_inode:		no
@@ -133,7 +131,6 @@ show_options:		no				(vfsmount->sem)
 quota_read:		no	no	no		(see below)
 quota_write:		no	no	no		(see below)
 
-->read_inode() is not a method - it's a callback used in iget().
 ->remount_fs() will have the s_umount lock if it's already mounted.
 When called from get_sb_single, it does NOT have the s_umount lock.
 ->quota_read() and ->quota_write() functions are both guaranteed to
diff -puN Documentation/filesystems/porting~iget-remove-iget-and-the-read_inode-super-op-as Documentation/filesystems/porting
--- a/Documentation/filesystems/porting~iget-remove-iget-and-the-read_inode-super-op-as
+++ a/Documentation/filesystems/porting
@@ -34,8 +34,8 @@ FOO_I(inode) (see in-tree filesystems fo
 
 Make them ->alloc_inode and ->destroy_inode in your super_operations.
 
-Keep in mind that now you need explicit initialization of private data -
-typically in ->read_inode() and after getting an inode from new_inode().
+Keep in mind that now you need explicit initialization of private data
+typically between calling iget_locked() and unlocking the inode.
 
 At some point that will become mandatory.
 
@@ -173,10 +173,10 @@ should be a non-blocking function that i
 newly created inode to allow the test function to succeed. 'data' is
 passed as an opaque value to both test and set functions.
 
-When the inode has been created by iget5_locked(), it will be returned with
-the I_NEW flag set and will still be locked. read_inode has not been
-called so the file system still has to finalize the initialization. Once
-the inode is initialized it must be unlocked by calling unlock_new_inode().
+When the inode has been created by iget5_locked(), it will be returned with the
+I_NEW flag set and will still be locked.  The filesystem then needs to finalize
+the initialization. Once the inode is initialized it must be unlocked by
+calling unlock_new_inode().
 
 The filesystem is responsible for setting (and possibly testing) i_ino
 when appropriate. There is also a simpler iget_locked function that
diff -puN Documentation/filesystems/vfs.txt~iget-remove-iget-and-the-read_inode-super-op-as Documentation/filesystems/vfs.txt
--- a/Documentation/filesystems/vfs.txt~iget-remove-iget-and-the-read_inode-super-op-as
+++ a/Documentation/filesystems/vfs.txt
@@ -203,8 +203,6 @@ struct super_operations {
         struct inode *(*alloc_inode)(struct super_block *sb);
         void (*destroy_inode)(struct inode *);
 
-        void (*read_inode) (struct inode *);
-
         void (*dirty_inode) (struct inode *);
         int (*write_inode) (struct inode *, int);
         void (*put_inode) (struct inode *);
@@ -242,15 +240,6 @@ or bottom half).
   	->alloc_inode was defined and simply undoes anything done by
 	->alloc_inode.
 
-  read_inode: this method is called to read a specific inode from the
-        mounted filesystem.  The i_ino member in the struct inode is
-	initialized by the VFS to indicate which inode to read. Other
-	members are filled in by this method.
-
-	You can set this to NULL and use iget5_locked() instead of iget()
-	to read inodes.  This is necessary for filesystems for which the
-	inode number is not sufficient to identify an inode.
-
   dirty_inode: this method is called by the VFS to mark an inode dirty.
 
   write_inode: this method is called when the VFS needs to write an
@@ -308,9 +297,9 @@ or bottom half).
 
   quota_write: called by the VFS to write to filesystem quota file.
 
-The read_inode() method is responsible for filling in the "i_op"
-field. This is a pointer to a "struct inode_operations" which
-describes the methods that can be performed on individual inodes.
+Whoever sets up the inode is responsible for filling in the "i_op" field. This
+is a pointer to a "struct inode_operations" which describes the methods that
+can be performed on individual inodes.
 
 
 The Inode Object
diff -puN fs/inode.c~iget-remove-iget-and-the-read_inode-super-op-as fs/inode.c
--- a/fs/inode.c~iget-remove-iget-and-the-read_inode-super-op-as
+++ a/fs/inode.c
@@ -928,8 +928,6 @@ EXPORT_SYMBOL(ilookup);
  * @set:	callback used to initialize a new struct inode
  * @data:	opaque data pointer to pass to @test and @set
  *
- * This is iget() without the read_inode() portion of get_new_inode().
- *
  * iget5_locked() uses ifind() to search for the inode specified by @hashval
  * and @data in the inode cache and if present it is returned with an increased
  * reference count. This is a generalized version of iget_locked() for file
@@ -966,8 +964,6 @@ EXPORT_SYMBOL(iget5_locked);
  * @sb:		super block of file system
  * @ino:	inode number to get
  *
- * This is iget() without the read_inode() portion of get_new_inode_fast().
- *
  * iget_locked() uses ifind_fast() to search for the inode specified by @ino in
  * the inode cache and if present it is returned with an increased reference
  * count. This is for file systems where the inode number is sufficient for
diff -puN include/linux/fs.h~iget-remove-iget-and-the-read_inode-super-op-as include/linux/fs.h
--- a/include/linux/fs.h~iget-remove-iget-and-the-read_inode-super-op-as
+++ a/include/linux/fs.h
@@ -1246,8 +1246,6 @@ struct super_operations {
    	struct inode *(*alloc_inode)(struct super_block *sb);
 	void (*destroy_inode)(struct inode *);
 
-	void (*read_inode) (struct inode *);
-  
    	void (*dirty_inode) (struct inode *);
 	int (*write_inode) (struct inode *, int);
 	void (*put_inode) (struct inode *);
@@ -1756,18 +1754,6 @@ extern struct inode * iget5_locked(struc
 extern struct inode * iget_locked(struct super_block *, unsigned long);
 extern void unlock_new_inode(struct inode *);
 
-static inline struct inode *iget(struct super_block *sb, unsigned long ino)
-{
-	struct inode *inode = iget_locked(sb, ino);
-	
-	if (inode && (inode->i_state & I_NEW)) {
-		sb->s_op->read_inode(inode);
-		unlock_new_inode(inode);
-	}
-
-	return inode;
-}
-
 extern void __iget(struct inode * inode);
 extern void iget_failed(struct inode *);
 extern void clear_inode(struct inode *);
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
64-bit-i_version-afs-fixes.patch
add-an-err_cast-function-to-complement-err_ptr-and-co.patch
convert-err_ptrptr_errp-instances-to-err_castp.patch
iget-introduce-a-function-to-register-iget-failure.patch
iget-use-iget_failed-in-afs.patch
iget-use-iget_failed-in-gfs2.patch
iget-stop-affs-from-using-iget-and-read_inode-try.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-autofs-from-using-iget-and-read_inode.patch
iget-stop-befs-from-using-iget-and-read_inode-try.patch
iget-stop-bfs-from-using-iget-and-read_inode-try.patch
iget-stop-cifs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
iget-stop-fat-from-using-iget-and-read_inode-try.patch
iget-stop-freevxfs-from-using-iget-and-read_inode.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-fuse-from-using-iget-and-read_inode-try.patch
iget-stop-hfsplus-from-using-iget-and-read_inode.patch
iget-stop-isofs-from-using-read_inode.patch
iget-stop-jffs2-from-using-iget-and-read_inode.patch
iget-stop-jfs-from-using-iget-and-read_inode-try.patch
iget-stop-the-minix-filesystem-from-using-iget-and.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-openpromfs-from-using-iget-and.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-hppfs-from-using-iget-and-read_inode.patch
iget-remove-iget-and-the-read_inode-super-op-as.patch
mutex-subsystem-synchro-test-module.patch
