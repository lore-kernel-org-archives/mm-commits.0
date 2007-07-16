From: akpm@linux-foundation.org
Subject: - update-documentation-filesystems-vfstxt-second-part.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:58:53 -0700
Message-ID: <200707162058.l6GKwraF002376@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54365 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757308AbXGPVKN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:10:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bbpetkov@yahoo.de, mm-commits@vger.kernel.org


The patch titled
     update Documentation/filesystems/vfs.txt
has been removed from the -mm tree.  Its filename was
     update-documentation-filesystems-vfstxt-second-part.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: update Documentation/filesystems/vfs.txt
From: Borislav Petkov <bbpetkov@yahoo.de>

Update Documentation/filesystems/vfs.txt

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/vfs.txt |   29 +++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff -puN Documentation/filesystems/vfs.txt~update-documentation-filesystems-vfstxt-second-part Documentation/filesystems/vfs.txt
--- a/Documentation/filesystems/vfs.txt~update-documentation-filesystems-vfstxt-second-part
+++ a/Documentation/filesystems/vfs.txt
@@ -197,7 +197,7 @@ struct super_operations
 -----------------------
 
 This describes how the VFS can manipulate the superblock of your
-filesystem. As of kernel 2.6.13, the following members are defined:
+filesystem. As of kernel 2.6.22, the following members are defined:
 
 struct super_operations {
         struct inode *(*alloc_inode)(struct super_block *sb);
@@ -220,8 +220,6 @@ struct super_operations {
         void (*clear_inode) (struct inode *);
         void (*umount_begin) (struct super_block *);
 
-        void (*sync_inodes) (struct super_block *sb,
-                                struct writeback_control *wbc);
         int (*show_options)(struct seq_file *, struct vfsmount *);
 
         ssize_t (*quota_read)(struct super_block *, int, char *, size_t, loff_t);
@@ -304,9 +302,6 @@ or bottom half).
 
   umount_begin: called when the VFS is unmounting a filesystem.
 
-  sync_inodes: called when the VFS is writing out dirty data associated with
-  	a superblock.
-
   show_options: called by the VFS to show mount options for /proc/<pid>/mounts.
 
   quota_read: called by the VFS to read from filesystem quota file.
@@ -328,7 +323,7 @@ struct inode_operations
 -----------------------
 
 This describes how the VFS can manipulate an inode in your
-filesystem. As of kernel 2.6.13, the following members are defined:
+filesystem. As of kernel 2.6.22, the following members are defined:
 
 struct inode_operations {
 	int (*create) (struct inode *,struct dentry *,int, struct nameidata *);
@@ -352,6 +347,7 @@ struct inode_operations {
 	ssize_t (*getxattr) (struct dentry *, const char *, void *, size_t);
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
 	int (*removexattr) (struct dentry *, const char *);
+	void (*truncate_range)(struct inode *, loff_t, loff_t);
 };
 
 Again, all methods are called without any locks being held, unless
@@ -448,6 +444,9 @@ otherwise noted.
   removexattr: called by the VFS to remove an extended attribute from
   	a file. This method is called by removexattr(2) system call.
 
+  truncate_range: a method provided by the underlying filesystem to truncate a
+  	range of blocks , i.e. punch a hole somewhere in a file.
+
 
 The Address Space Object
 ========================
@@ -526,7 +525,7 @@ struct address_space_operations
 -------------------------------
 
 This describes how the VFS can manipulate mapping of a file to page cache in
-your filesystem. As of kernel 2.6.16, the following members are defined:
+your filesystem. As of kernel 2.6.22, the following members are defined:
 
 struct address_space_operations {
 	int (*writepage)(struct page *page, struct writeback_control *wbc);
@@ -547,6 +546,7 @@ struct address_space_operations {
 			int);
 	/* migrate the contents of a page to the specified target */
 	int (*migratepage) (struct page *, struct page *);
+	int (*launder_page) (struct page *);
 };
 
   writepage: called by the VM to write a dirty page to backing store.
@@ -693,6 +693,10 @@ struct address_space_operations {
 	transfer any private data across and update any references
         that it has to the page.
 
+  launder_page: Called before freeing a page - it writes back the dirty page. To
+  	prevent redirtying the page, it is kept locked during the whole
+	operation.
+
 The File Object
 ===============
 
@@ -703,9 +707,10 @@ struct file_operations
 ----------------------
 
 This describes how the VFS can manipulate an open file. As of kernel
-2.6.17, the following members are defined:
+2.6.22, the following members are defined:
 
 struct file_operations {
+	struct module *owner;
 	loff_t (*llseek) (struct file *, loff_t, int);
 	ssize_t (*read) (struct file *, char __user *, size_t, loff_t *);
 	ssize_t (*write) (struct file *, const char __user *, size_t, loff_t *);
@@ -732,10 +737,8 @@ struct file_operations {
 	int (*check_flags)(int);
 	int (*dir_notify)(struct file *filp, unsigned long arg);
 	int (*flock) (struct file *, int, struct file_lock *);
-	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, size_t, unsigned 
-int);
-	ssize_t (*splice_read)(struct file *, struct pipe_inode_info *, size_t, unsigned  
-int);
+	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, size_t, unsigned int);
+	ssize_t (*splice_read)(struct file *, struct pipe_inode_info *, size_t, unsigned int);
 };
 
 Again, all methods are called without any locks being held, unless
_

Patches currently in -mm which might be from bbpetkov@yahoo.de are

origin.patch
