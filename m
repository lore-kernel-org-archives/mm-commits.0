From: akpm@linux-foundation.org
Subject: - iget-stop-hostfs-from-using-iget-and-read_inode.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:08:15 -0800
Message-ID: <200802080807.m1887ul9014602@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60834 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933073AbYBHIVF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:21:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, hch@lst.de, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     iget: stop HOSTFS from using iget() and read_inode()
has been removed from the -mm tree.  Its filename was
     iget-stop-hostfs-from-using-iget-and-read_inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iget: stop HOSTFS from using iget() and read_inode()
From: David Howells <dhowells@redhat.com>

Stop the HOSTFS filesystem from using iget() and read_inode().  Provide
hostfs_iget(), and call that instead of iget().  hostfs_iget() then uses
iget_locked() directly and returns a proper error code instead of an inode in
the event of an error.

hostfs_fill_sb_common() returns any error incurred when getting the root inode
instead of EINVAL.

Note that the contents of hostfs_kern.c need to be examined:

 (*) hostfs_iget() should perhaps subsume init_inode() and hostfs_read_inode().

 (*) It would appear that all hostfs inodes are the same inode because iget()
     was being called with inode number 0 - which forms the lookup key.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Jeff Dike <jdike@addtoit.com>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hostfs/hostfs_kern.c |   57 +++++++++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 19 deletions(-)

diff -puN fs/hostfs/hostfs_kern.c~iget-stop-hostfs-from-using-iget-and-read_inode fs/hostfs/hostfs_kern.c
--- a/fs/hostfs/hostfs_kern.c~iget-stop-hostfs-from-using-iget-and-read_inode
+++ a/fs/hostfs/hostfs_kern.c
@@ -202,7 +202,7 @@ static char *follow_link(char *link)
 	return ERR_PTR(n);
 }
 
-static int read_inode(struct inode *ino)
+static int hostfs_read_inode(struct inode *ino)
 {
 	char *name;
 	int err = 0;
@@ -233,6 +233,25 @@ static int read_inode(struct inode *ino)
 	return err;
 }
 
+static struct inode *hostfs_iget(struct super_block *sb)
+{
+	struct inode *inode;
+	long ret;
+
+	inode = iget_locked(sb, 0);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (inode->i_state & I_NEW) {
+		ret = hostfs_read_inode(inode);
+		if (ret < 0) {
+			iget_failed(inode);
+			return ERR_PTR(ret);
+		}
+		unlock_new_inode(inode);
+	}
+	return inode;
+}
+
 int hostfs_statfs(struct dentry *dentry, struct kstatfs *sf)
 {
 	/*
@@ -303,17 +322,11 @@ static void hostfs_destroy_inode(struct 
 	kfree(HOSTFS_I(inode));
 }
 
-static void hostfs_read_inode(struct inode *inode)
-{
-	read_inode(inode);
-}
-
 static const struct super_operations hostfs_sbops = {
 	.alloc_inode	= hostfs_alloc_inode,
 	.drop_inode	= generic_delete_inode,
 	.delete_inode   = hostfs_delete_inode,
 	.destroy_inode	= hostfs_destroy_inode,
-	.read_inode	= hostfs_read_inode,
 	.statfs		= hostfs_statfs,
 };
 
@@ -571,10 +584,11 @@ int hostfs_create(struct inode *dir, str
 	char *name;
 	int error, fd;
 
-	error = -ENOMEM;
-	inode = iget(dir->i_sb, 0);
-	if (inode == NULL)
+	inode = hostfs_iget(dir->i_sb);
+	if (IS_ERR(inode)) {
+		error = PTR_ERR(inode);
 		goto out;
+	}
 
 	error = init_inode(inode, dentry);
 	if (error)
@@ -615,10 +629,11 @@ struct dentry *hostfs_lookup(struct inod
 	char *name;
 	int err;
 
-	err = -ENOMEM;
-	inode = iget(ino->i_sb, 0);
-	if (inode == NULL)
+	inode = hostfs_iget(ino->i_sb);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
 		goto out;
+	}
 
 	err = init_inode(inode, dentry);
 	if (err)
@@ -736,11 +751,13 @@ int hostfs_mknod(struct inode *dir, stru
 {
 	struct inode *inode;
 	char *name;
-	int err = -ENOMEM;
+	int err;
 
-	inode = iget(dir->i_sb, 0);
-	if (inode == NULL)
+	inode = hostfs_iget(dir->i_sb);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
 		goto out;
+	}
 
 	err = init_inode(inode, dentry);
 	if (err)
@@ -952,9 +969,11 @@ static int hostfs_fill_sb_common(struct 
 
 	sprintf(host_root_path, "%s/%s", root_ino, req_root);
 
-	root_inode = iget(sb, 0);
-	if (root_inode == NULL)
+	root_inode = hostfs_iget(sb);
+	if (IS_ERR(root_inode)) {
+		err = PTR_ERR(root_inode);
 		goto out_free;
+	}
 
 	err = init_inode(root_inode, NULL);
 	if (err)
@@ -972,7 +991,7 @@ static int hostfs_fill_sb_common(struct 
 	if (sb->s_root == NULL)
 		goto out_put;
 
-	err = read_inode(root_inode);
+	err = hostfs_read_inode(root_inode);
 	if (err) {
 		/* No iput in this case because the dput does that for us */
 		dput(sb->s_root);
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
