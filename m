From: akpm@linux-foundation.org
Subject: - iget-stop-the-sysv-filesystem-from-using-iget-and.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:08:05 -0800
Message-ID: <200802080807.m1887kPx014587@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52863 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762006AbYBHIU2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:20:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     iget: stop the SYSV filesystem from using iget() and read_inode()
has been removed from the -mm tree.  Its filename was
     iget-stop-the-sysv-filesystem-from-using-iget-and.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iget: stop the SYSV filesystem from using iget() and read_inode()
From: David Howells <dhowells@redhat.com>

Stop the SYSV filesystem from using iget() and read_inode().  Replace
sysv_read_inode() with sysv_iget(), and call that instead of iget(). 
sysv_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysv/inode.c |   25 ++++++++++++++++---------
 fs/sysv/namei.c |    6 +++---
 fs/sysv/super.c |    4 ++--
 fs/sysv/sysv.h  |    1 +
 4 files changed, 22 insertions(+), 14 deletions(-)

diff -puN fs/sysv/inode.c~iget-stop-the-sysv-filesystem-from-using-iget-and fs/sysv/inode.c
--- a/fs/sysv/inode.c~iget-stop-the-sysv-filesystem-from-using-iget-and
+++ a/fs/sysv/inode.c
@@ -169,20 +169,27 @@ void sysv_set_inode(struct inode *inode,
 		init_special_inode(inode, inode->i_mode, rdev);
 }
 
-static void sysv_read_inode(struct inode *inode)
+struct inode *sysv_iget(struct super_block *sb, unsigned int ino)
 {
-	struct super_block * sb = inode->i_sb;
 	struct sysv_sb_info * sbi = SYSV_SB(sb);
 	struct buffer_head * bh;
 	struct sysv_inode * raw_inode;
 	struct sysv_inode_info * si;
-	unsigned int block, ino = inode->i_ino;
+	struct inode *inode;
+	unsigned int block;
 
 	if (!ino || ino > sbi->s_ninodes) {
 		printk("Bad inode number on dev %s: %d is out of range\n",
-		       inode->i_sb->s_id, ino);
-		goto bad_inode;
+		       sb->s_id, ino);
+		return ERR_PTR(-EIO);
 	}
+
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
+
 	raw_inode = sysv_raw_inode(sb, ino, &bh);
 	if (!raw_inode) {
 		printk("Major problem: unable to read inode from dev %s\n",
@@ -214,11 +221,12 @@ static void sysv_read_inode(struct inode
 			       old_decode_dev(fs32_to_cpu(sbi, si->i_data[0])));
 	else
 		sysv_set_inode(inode, 0);
-	return;
+	unlock_new_inode(inode);
+	return inode;
 
 bad_inode:
-	make_bad_inode(inode);
-	return;
+	iget_failed(inode);
+	return ERR_PTR(-EIO);
 }
 
 static struct buffer_head * sysv_update_inode(struct inode * inode)
@@ -328,7 +336,6 @@ static void init_once(struct kmem_cache 
 const struct super_operations sysv_sops = {
 	.alloc_inode	= sysv_alloc_inode,
 	.destroy_inode	= sysv_destroy_inode,
-	.read_inode	= sysv_read_inode,
 	.write_inode	= sysv_write_inode,
 	.delete_inode	= sysv_delete_inode,
 	.put_super	= sysv_put_super,
diff -puN fs/sysv/namei.c~iget-stop-the-sysv-filesystem-from-using-iget-and fs/sysv/namei.c
--- a/fs/sysv/namei.c~iget-stop-the-sysv-filesystem-from-using-iget-and
+++ a/fs/sysv/namei.c
@@ -53,9 +53,9 @@ static struct dentry *sysv_lookup(struct
 	ino = sysv_inode_by_name(dentry);
 
 	if (ino) {
-		inode = iget(dir->i_sb, ino);
-		if (!inode)
-			return ERR_PTR(-EACCES);
+		inode = sysv_iget(dir->i_sb, ino);
+		if (IS_ERR(inode))
+			return ERR_CAST(inode);
 	}
 	d_add(dentry, inode);
 	return NULL;
diff -puN fs/sysv/super.c~iget-stop-the-sysv-filesystem-from-using-iget-and fs/sysv/super.c
--- a/fs/sysv/super.c~iget-stop-the-sysv-filesystem-from-using-iget-and
+++ a/fs/sysv/super.c
@@ -332,8 +332,8 @@ static int complete_read_super(struct su
 	sb->s_magic = SYSV_MAGIC_BASE + sbi->s_type;
 	/* set up enough so that it can read an inode */
 	sb->s_op = &sysv_sops;
-	root_inode = iget(sb,SYSV_ROOT_INO);
-	if (!root_inode || is_bad_inode(root_inode)) {
+	root_inode = sysv_iget(sb, SYSV_ROOT_INO);
+	if (IS_ERR(root_inode)) {
 		printk("SysV FS: get root inode failed\n");
 		return 0;
 	}
diff -puN fs/sysv/sysv.h~iget-stop-the-sysv-filesystem-from-using-iget-and fs/sysv/sysv.h
--- a/fs/sysv/sysv.h~iget-stop-the-sysv-filesystem-from-using-iget-and
+++ a/fs/sysv/sysv.h
@@ -141,6 +141,7 @@ extern int __sysv_write_begin(struct fil
 			struct page **pagep, void **fsdata);
 
 /* inode.c */
+extern struct inode *sysv_iget(struct super_block *, unsigned int);
 extern int sysv_write_inode(struct inode *, int);
 extern int sysv_sync_inode(struct inode *);
 extern int sysv_sync_file(struct file *, struct dentry *, int);
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
