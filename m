From: akpm@linux-foundation.org
Subject: - iget-stop-hppfs-from-using-iget-and-read_inode.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:08:18 -0800
Message-ID: <200802080807.m1887xYc014605@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58761 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761950AbYBHIUO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:20:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     iget: stop HPPFS from using iget() and read_inode()
has been removed from the -mm tree.  Its filename was
     iget-stop-hppfs-from-using-iget-and-read_inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iget: stop HPPFS from using iget() and read_inode()
From: David Howells <dhowells@redhat.com>

Stop the HPPFS filesystem from using iget() and read_inode().  Provide an
hppfs_iget(), and call that instead of iget().  hppfs_iget() then uses
iget_locked() directly and returns a proper error code instead of an inode in
the event of an error.

hppfs_fill_sb_common() returns any error incurred when getting the root inode
instead of EINVAL.

Note that the contents of hppfs_kern.c need to be examined:

 (*) The HPPFS inode retains a pointer to the proc dentry it is shadowing, but
     whilst it does appear to retain a reference to it, it doesn't appear to
     destroy the reference if the inode goes away.

 (*) hppfs_iget() should perhaps subsume init_inode() and hppfs_read_inode().

 (*) It would appear that all hppfs inodes are the same inode because iget()
     was being called with inode number 0, which forms the lookup key.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hppfs/hppfs_kern.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff -puN fs/hppfs/hppfs_kern.c~iget-stop-hppfs-from-using-iget-and-read_inode fs/hppfs/hppfs_kern.c
--- a/fs/hppfs/hppfs_kern.c~iget-stop-hppfs-from-using-iget-and-read_inode
+++ a/fs/hppfs/hppfs_kern.c
@@ -155,6 +155,20 @@ static void hppfs_read_inode(struct inod
 	ino->i_blocks = proc_ino->i_blocks;
 }
 
+static struct inode *hppfs_iget(struct super_block *sb)
+{
+	struct inode *inode;
+
+	inode = iget_locked(sb, 0);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (inode->i_state & I_NEW) {
+		hppfs_read_inode(inode);
+		unlock_new_inode(inode);
+	}
+	return inode;
+}
+
 static struct dentry *hppfs_lookup(struct inode *ino, struct dentry *dentry,
                                   struct nameidata *nd)
 {
@@ -190,9 +204,11 @@ static struct dentry *hppfs_lookup(struc
 	if(IS_ERR(proc_dentry))
 		return(proc_dentry);
 
-	inode = iget(ino->i_sb, 0);
-	if(inode == NULL)
+	inode = hppfs_iget(ino->i_sb);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
 		goto out_dput;
+	}
 
 	err = init_inode(inode, proc_dentry);
 	if(err)
@@ -652,7 +668,6 @@ static void hppfs_destroy_inode(struct i
 static const struct super_operations hppfs_sbops = {
 	.alloc_inode	= hppfs_alloc_inode,
 	.destroy_inode	= hppfs_destroy_inode,
-	.read_inode	= hppfs_read_inode,
 	.delete_inode	= hppfs_delete_inode,
 	.statfs		= hppfs_statfs,
 };
@@ -745,9 +760,11 @@ static int hppfs_fill_super(struct super
 	sb->s_magic = HPPFS_SUPER_MAGIC;
 	sb->s_op = &hppfs_sbops;
 
-	root_inode = iget(sb, 0);
-	if(root_inode == NULL)
+	root_inode = hppfs_iget(sb);
+	if (IS_ERR(root_inode)) {
+		err = PTR_ERR(root_inode);
 		goto out;
+	}
 
 	err = init_inode(root_inode, proc_sb->s_root);
 	if(err)
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
