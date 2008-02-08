From: akpm@linux-foundation.org
Subject: - iget-stop-affs-from-using-iget-and-read_inode-try.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:07:15 -0800
Message-ID: <200802080806.m1886uoC014493@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48542 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933137AbYBHIVJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:21:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, hch@lst.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     iget: stop AFFS from using iget() and read_inode()
has been removed from the -mm tree.  Its filename was
     iget-stop-affs-from-using-iget-and-read_inode-try.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iget: stop AFFS from using iget() and read_inode()
From: David Howells <dhowells@redhat.com>

Stop the AFFS filesystem from using iget() and read_inode().  Replace
affs_read_inode() with affs_iget(), and call that instead of iget(). 
affs_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

affs_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/affs.h     |    3 ++-
 fs/affs/amigaffs.c |    6 ++++--
 fs/affs/inode.c    |   20 +++++++++++++-------
 fs/affs/namei.c    |   10 ++++------
 fs/affs/super.c    |   12 +++++++++---
 5 files changed, 32 insertions(+), 19 deletions(-)

diff -puN fs/affs/affs.h~iget-stop-affs-from-using-iget-and-read_inode-try fs/affs/affs.h
--- a/fs/affs/affs.h~iget-stop-affs-from-using-iget-and-read_inode-try
+++ a/fs/affs/affs.h
@@ -174,7 +174,8 @@ extern void			 affs_put_inode(struct ino
 extern void			 affs_drop_inode(struct inode *inode);
 extern void			 affs_delete_inode(struct inode *inode);
 extern void			 affs_clear_inode(struct inode *inode);
-extern void			 affs_read_inode(struct inode *inode);
+extern struct inode		*affs_iget(struct super_block *sb,
+					unsigned long ino);
 extern int			 affs_write_inode(struct inode *inode, int);
 extern int			 affs_add_entry(struct inode *dir, struct inode *inode, struct dentry *dentry, s32 type);
 
diff -puN fs/affs/amigaffs.c~iget-stop-affs-from-using-iget-and-read_inode-try fs/affs/amigaffs.c
--- a/fs/affs/amigaffs.c~iget-stop-affs-from-using-iget-and-read_inode-try
+++ a/fs/affs/amigaffs.c
@@ -170,9 +170,11 @@ affs_remove_link(struct dentry *dentry)
 		if (!link_bh)
 			goto done;
 
-		dir = iget(sb, be32_to_cpu(AFFS_TAIL(sb, link_bh)->parent));
-		if (!dir)
+		dir = affs_iget(sb, be32_to_cpu(AFFS_TAIL(sb, link_bh)->parent));
+		if (IS_ERR(dir)) {
+			retval = PTR_ERR(dir);
 			goto done;
+		}
 
 		affs_lock_dir(dir);
 		affs_fix_dcache(dentry, link_ino);
diff -puN fs/affs/inode.c~iget-stop-affs-from-using-iget-and-read_inode-try fs/affs/inode.c
--- a/fs/affs/inode.c~iget-stop-affs-from-using-iget-and-read_inode-try
+++ a/fs/affs/inode.c
@@ -15,20 +15,25 @@
 extern const struct inode_operations affs_symlink_inode_operations;
 extern struct timezone sys_tz;
 
-void
-affs_read_inode(struct inode *inode)
+struct inode *affs_iget(struct super_block *sb, unsigned long ino)
 {
-	struct super_block	*sb = inode->i_sb;
 	struct affs_sb_info	*sbi = AFFS_SB(sb);
 	struct buffer_head	*bh;
 	struct affs_head	*head;
 	struct affs_tail	*tail;
+	struct inode		*inode;
 	u32			 block;
 	u32			 size;
 	u32			 prot;
 	u16			 id;
 
-	pr_debug("AFFS: read_inode(%lu)\n",inode->i_ino);
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
+
+	pr_debug("AFFS: affs_iget(%lu)\n", inode->i_ino);
 
 	block = inode->i_ino;
 	bh = affs_bread(sb, block);
@@ -154,12 +159,13 @@ affs_read_inode(struct inode *inode)
 			 sys_tz.tz_minuteswest * 60;
 	inode->i_mtime.tv_nsec = inode->i_ctime.tv_nsec = inode->i_atime.tv_nsec = 0;
 	affs_brelse(bh);
-	return;
+	unlock_new_inode(inode);
+	return inode;
 
 bad_inode:
-	make_bad_inode(inode);
 	affs_brelse(bh);
-	return;
+	iget_failed(inode);
+	return ERR_PTR(-EIO);
 }
 
 int
diff -puN fs/affs/namei.c~iget-stop-affs-from-using-iget-and-read_inode-try fs/affs/namei.c
--- a/fs/affs/namei.c~iget-stop-affs-from-using-iget-and-read_inode-try
+++ a/fs/affs/namei.c
@@ -208,9 +208,8 @@ affs_lookup(struct inode *dir, struct de
 	affs_lock_dir(dir);
 	bh = affs_find_entry(dir, dentry);
 	affs_unlock_dir(dir);
-	if (IS_ERR(bh)) {
+	if (IS_ERR(bh))
 		return ERR_CAST(bh);
-	}
 	if (bh) {
 		u32 ino = bh->b_blocknr;
 
@@ -223,10 +222,9 @@ affs_lookup(struct inode *dir, struct de
 			ino = be32_to_cpu(AFFS_TAIL(sb, bh)->original);
 		}
 		affs_brelse(bh);
-		inode = iget(sb, ino);
-		if (!inode) {
-			return ERR_PTR(-EACCES);
-		}
+		inode = affs_iget(sb, ino);
+		if (IS_ERR(inode))
+			return ERR_PTR(PTR_ERR(inode));
 	}
 	dentry->d_op = AFFS_SB(sb)->s_flags & SF_INTL ? &affs_intl_dentry_operations : &affs_dentry_operations;
 	d_add(dentry, inode);
diff -puN fs/affs/super.c~iget-stop-affs-from-using-iget-and-read_inode-try fs/affs/super.c
--- a/fs/affs/super.c~iget-stop-affs-from-using-iget-and-read_inode-try
+++ a/fs/affs/super.c
@@ -113,7 +113,6 @@ static void destroy_inodecache(void)
 static const struct super_operations affs_sops = {
 	.alloc_inode	= affs_alloc_inode,
 	.destroy_inode	= affs_destroy_inode,
-	.read_inode	= affs_read_inode,
 	.write_inode	= affs_write_inode,
 	.put_inode	= affs_put_inode,
 	.drop_inode	= affs_drop_inode,
@@ -271,6 +270,7 @@ static int affs_fill_super(struct super_
 	unsigned long		 mount_flags;
 	int			 tmp_flags;	/* fix remount prototype... */
 	u8			 sig[4];
+	int			 ret = -EINVAL;
 
 	pr_debug("AFFS: read_super(%s)\n",data ? (const char *)data : "no options");
 
@@ -444,7 +444,12 @@ got_root:
 
 	/* set up enough so that it can read an inode */
 
-	root_inode = iget(sb, root_block);
+	root_inode = affs_iget(sb, root_block);
+	if (IS_ERR(root_inode)) {
+		ret = PTR_ERR(root_inode);
+		goto out_error_noinode;
+	}
+
 	sb->s_root = d_alloc_root(root_inode);
 	if (!sb->s_root) {
 		printk(KERN_ERR "AFFS: Get root inode failed\n");
@@ -461,12 +466,13 @@ got_root:
 out_error:
 	if (root_inode)
 		iput(root_inode);
+out_error_noinode:
 	kfree(sbi->s_bitmap);
 	affs_brelse(root_bh);
 	kfree(sbi->s_prefix);
 	kfree(sbi);
 	sb->s_fs_info = NULL;
-	return -EINVAL;
+	return ret;
 }
 
 static int
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
