From: akpm@linux-foundation.org
Subject: - iget-stop-procfs-from-using-iget-and-read_inode.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:07:58 -0800
Message-ID: <200802080807.m1887dCO014570@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57511 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932851AbYBHIUr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:20:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, ebiederm@xmission.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     iget: stop PROCFS from using iget() and read_inode()
has been removed from the -mm tree.  Its filename was
     iget-stop-procfs-from-using-iget-and-read_inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iget: stop PROCFS from using iget() and read_inode()
From: David Howells <dhowells@redhat.com>

Stop the PROCFS filesystem from using iget() and read_inode().  Merge
procfs_read_inode() into procfs_get_inode(), and have that call iget_locked()
instead of iget().

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |   60 +++++++++++++++++++++-------------------------
 1 file changed, 28 insertions(+), 32 deletions(-)

diff -puN fs/proc/inode.c~iget-stop-procfs-from-using-iget-and-read_inode fs/proc/inode.c
--- a/fs/proc/inode.c~iget-stop-procfs-from-using-iget-and-read_inode
+++ a/fs/proc/inode.c
@@ -73,11 +73,6 @@ static void proc_delete_inode(struct ino
 
 struct vfsmount *proc_mnt;
 
-static void proc_read_inode(struct inode * inode)
-{
-	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
-}
-
 static struct kmem_cache * proc_inode_cachep;
 
 static struct inode *proc_alloc_inode(struct super_block *sb)
@@ -128,7 +123,6 @@ static int proc_remount(struct super_blo
 static const struct super_operations proc_sops = {
 	.alloc_inode	= proc_alloc_inode,
 	.destroy_inode	= proc_destroy_inode,
-	.read_inode	= proc_read_inode,
 	.drop_inode	= generic_delete_inode,
 	.delete_inode	= proc_delete_inode,
 	.statfs		= simple_statfs,
@@ -401,39 +395,41 @@ struct inode *proc_get_inode(struct supe
 	if (de != NULL && !try_module_get(de->owner))
 		goto out_mod;
 
-	inode = iget(sb, ino);
+	inode = iget_locked(sb, ino);
 	if (!inode)
 		goto out_ino;
-
-	PROC_I(inode)->fd = 0;
-	PROC_I(inode)->pde = de;
-	if (de) {
-		if (de->mode) {
-			inode->i_mode = de->mode;
-			inode->i_uid = de->uid;
-			inode->i_gid = de->gid;
-		}
-		if (de->size)
-			inode->i_size = de->size;
-		if (de->nlink)
-			inode->i_nlink = de->nlink;
-		if (de->proc_iops)
-			inode->i_op = de->proc_iops;
-		if (de->proc_fops) {
-			if (S_ISREG(inode->i_mode)) {
+	if (inode->i_state & I_NEW) {
+		inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
+		PROC_I(inode)->fd = 0;
+		PROC_I(inode)->pde = de;
+		if (de) {
+			if (de->mode) {
+				inode->i_mode = de->mode;
+				inode->i_uid = de->uid;
+				inode->i_gid = de->gid;
+			}
+			if (de->size)
+				inode->i_size = de->size;
+			if (de->nlink)
+				inode->i_nlink = de->nlink;
+			if (de->proc_iops)
+				inode->i_op = de->proc_iops;
+			if (de->proc_fops) {
+				if (S_ISREG(inode->i_mode)) {
 #ifdef CONFIG_COMPAT
-				if (!de->proc_fops->compat_ioctl)
-					inode->i_fop =
-						&proc_reg_file_ops_no_compat;
-				else
+					if (!de->proc_fops->compat_ioctl)
+						inode->i_fop =
+							&proc_reg_file_ops_no_compat;
+					else
 #endif
-					inode->i_fop = &proc_reg_file_ops;
+						inode->i_fop = &proc_reg_file_ops;
+				} else {
+					inode->i_fop = de->proc_fops;
+				}
 			}
-			else
-				inode->i_fop = de->proc_fops;
 		}
+		unlock_new_inode(inode);
 	}
-
 	return inode;
 
 out_ino:
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
