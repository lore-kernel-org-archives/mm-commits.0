From: akpm@linux-foundation.org
Subject: - iget-stop-efs-from-using-iget-and-read_inode-try.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:07:28 -0800
Message-ID: <200802080807.m1887936014514@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35493 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761887AbYBHIUc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:20:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     iget: stop EFS from using iget() and read_inode()
has been removed from the -mm tree.  Its filename was
     iget-stop-efs-from-using-iget-and-read_inode-try.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iget: stop EFS from using iget() and read_inode()
From: David Howells <dhowells@redhat.com>

Stop the EFS filesystem from using iget() and read_inode().  Replace
efs_read_inode() with efs_iget(), and call that instead of iget().  efs_iget()
then uses iget_locked() directly and returns a proper error code instead of an
inode in the event of an error.

efs_fill_super() returns any error incurred when getting the root inode
instead of EACCES.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/efs/inode.c         |   25 +++++++++++++++++--------
 fs/efs/namei.c         |   23 ++++++++++++-----------
 fs/efs/super.c         |   16 +++++++++++-----
 include/linux/efs_fs.h |    2 +-
 4 files changed, 41 insertions(+), 25 deletions(-)

diff -puN fs/efs/inode.c~iget-stop-efs-from-using-iget-and-read_inode-try fs/efs/inode.c
--- a/fs/efs/inode.c~iget-stop-efs-from-using-iget-and-read_inode-try
+++ a/fs/efs/inode.c
@@ -45,17 +45,26 @@ static inline void extent_copy(efs_exten
 	return;
 }
 
-void efs_read_inode(struct inode *inode)
+struct inode *efs_iget(struct super_block *super, unsigned long ino)
 {
 	int i, inode_index;
 	dev_t device;
 	u32 rdev;
 	struct buffer_head *bh;
-	struct efs_sb_info    *sb = SUPER_INFO(inode->i_sb);
-	struct efs_inode_info *in = INODE_INFO(inode);
+	struct efs_sb_info    *sb = SUPER_INFO(super);
+	struct efs_inode_info *in;
 	efs_block_t block, offset;
 	struct efs_dinode *efs_inode;
-  
+	struct inode *inode;
+
+	inode = iget_locked(super, ino);
+	if (IS_ERR(inode))
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
+
+	in = INODE_INFO(inode);
+
 	/*
 	** EFS layout:
 	**
@@ -159,13 +168,13 @@ void efs_read_inode(struct inode *inode)
 			break;
 	}
 
-	return;
+	unlock_new_inode(inode);
+	return inode;
         
 read_inode_error:
 	printk(KERN_WARNING "EFS: failed to read inode %lu\n", inode->i_ino);
-	make_bad_inode(inode);
-
-	return;
+	iget_failed(inode);
+	return ERR_PTR(-EIO);
 }
 
 static inline efs_block_t
diff -puN fs/efs/namei.c~iget-stop-efs-from-using-iget-and-read_inode-try fs/efs/namei.c
--- a/fs/efs/namei.c~iget-stop-efs-from-using-iget-and-read_inode-try
+++ a/fs/efs/namei.c
@@ -66,9 +66,10 @@ struct dentry *efs_lookup(struct inode *
 	lock_kernel();
 	inodenum = efs_find_entry(dir, dentry->d_name.name, dentry->d_name.len);
 	if (inodenum) {
-		if (!(inode = iget(dir->i_sb, inodenum))) {
+		inode = efs_iget(dir->i_sb, inodenum);
+		if (IS_ERR(inode)) {
 			unlock_kernel();
-			return ERR_PTR(-EACCES);
+			return ERR_CAST(inode);
 		}
 	}
 	unlock_kernel();
@@ -84,12 +85,11 @@ static struct inode *efs_nfs_get_inode(s
 
 	if (ino == 0)
 		return ERR_PTR(-ESTALE);
-	inode = iget(sb, ino);
-	if (inode == NULL)
-		return ERR_PTR(-ENOMEM);
+	inode = efs_iget(sb, ino);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
 
-	if (is_bad_inode(inode) ||
-	    (generation && inode->i_generation != generation)) {
+	if (generation && inode->i_generation != generation) {
 		iput(inode);
 		return ERR_PTR(-ESTALE);
 	}
@@ -116,7 +116,7 @@ struct dentry *efs_get_parent(struct den
 	struct dentry *parent;
 	struct inode *inode;
 	efs_ino_t ino;
-	int error;
+	long error;
 
 	lock_kernel();
 
@@ -125,10 +125,11 @@ struct dentry *efs_get_parent(struct den
 	if (!ino)
 		goto fail;
 
-	error = -EACCES;
-	inode = iget(child->d_inode->i_sb, ino);
-	if (!inode)
+	inode = efs_iget(child->d_inode->i_sb, ino);
+	if (IS_ERR(inode)) {
+		error = PTR_ERR(inode);
 		goto fail;
+	}
 
 	error = -ENOMEM;
 	parent = d_alloc_anon(inode);
diff -puN fs/efs/super.c~iget-stop-efs-from-using-iget-and-read_inode-try fs/efs/super.c
--- a/fs/efs/super.c~iget-stop-efs-from-using-iget-and-read_inode-try
+++ a/fs/efs/super.c
@@ -107,7 +107,6 @@ static int efs_remount(struct super_bloc
 static const struct super_operations efs_superblock_operations = {
 	.alloc_inode	= efs_alloc_inode,
 	.destroy_inode	= efs_destroy_inode,
-	.read_inode	= efs_read_inode,
 	.put_super	= efs_put_super,
 	.statfs		= efs_statfs,
 	.remount_fs	= efs_remount,
@@ -247,6 +246,7 @@ static int efs_fill_super(struct super_b
 	struct efs_sb_info *sb;
 	struct buffer_head *bh;
 	struct inode *root;
+	int ret = -EINVAL;
 
  	sb = kzalloc(sizeof(struct efs_sb_info), GFP_KERNEL);
 	if (!sb)
@@ -303,12 +303,18 @@ static int efs_fill_super(struct super_b
 	}
 	s->s_op   = &efs_superblock_operations;
 	s->s_export_op = &efs_export_ops;
-	root = iget(s, EFS_ROOTINODE);
+	root = efs_iget(s, EFS_ROOTINODE);
+	if (IS_ERR(root)) {
+		printk(KERN_ERR "EFS: get root inode failed\n");
+		ret = PTR_ERR(root);
+		goto out_no_fs;
+	}
+
 	s->s_root = d_alloc_root(root);
- 
 	if (!(s->s_root)) {
-		printk(KERN_ERR "EFS: get root inode failed\n");
+		printk(KERN_ERR "EFS: get root dentry failed\n");
 		iput(root);
+		ret = -ENOMEM;
 		goto out_no_fs;
 	}
 
@@ -318,7 +324,7 @@ out_no_fs_ul:
 out_no_fs:
 	s->s_fs_info = NULL;
 	kfree(sb);
-	return -EINVAL;
+	return ret;
 }
 
 static int efs_statfs(struct dentry *dentry, struct kstatfs *buf) {
diff -puN include/linux/efs_fs.h~iget-stop-efs-from-using-iget-and-read_inode-try include/linux/efs_fs.h
--- a/include/linux/efs_fs.h~iget-stop-efs-from-using-iget-and-read_inode-try
+++ a/include/linux/efs_fs.h
@@ -41,7 +41,7 @@ extern const struct inode_operations efs
 extern const struct file_operations efs_dir_operations;
 extern const struct address_space_operations efs_symlink_aops;
 
-extern void efs_read_inode(struct inode *);
+extern struct inode *efs_iget(struct super_block *, unsigned long);
 extern efs_block_t efs_map_block(struct inode *, efs_block_t);
 extern int efs_get_block(struct inode *, sector_t, struct buffer_head *, int);
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
iget-stop-unionfs-from-using-iget-and-read_inode-fix-2.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
tty-let-architectures-override-the-user-kernel-macros.patch
aout-move-stack_top-to-asm-processorh.patch
aout-mark-arches-that-support-aout-format.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
usb-net2280-cant-have-a-function-called-show_registers.patch
mn10300-allocate-serial-port-uart-ids-for-on-chip-serial-ports.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
mn10300-add-platform-mtd-support-for-the-asb2303-board.patch
fs-afs-securityc-fix-uninitialized-var-warning.patch
procfs-constify-function-pointer-tables.patch
avoid-overflows-in-kernel-timec.patch
mount-options-fix-afs.patch
remove-aout-interpreter-support-in-elf-loader.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
mutex-subsystem-synchro-test-module.patch
