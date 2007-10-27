From: akpm@linux-foundation.org
Subject: + iget-stop-hostfs-from-using-iget-and-read_inode.patch added to -mm tree
Date: Sat, 27 Oct 2007 00:52:09 -0700
Message-ID: <200710270752.l9R7q9Jh003615@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58857 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754531AbXJ0Hwd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Oct 2007 03:52:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, jdike@addtoit.com


The patch titled
     iget: stop HOSTFS from using iget() and read_inode()
has been added to the -mm tree.  Its filename is
     iget-stop-hostfs-from-using-iget-and-read_inode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hostfs/hostfs_kern.c |   59 +++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 20 deletions(-)

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
@@ -972,8 +991,8 @@ static int hostfs_fill_sb_common(struct 
 	if (sb->s_root == NULL)
 		goto out_put;
 
-	err = read_inode(root_inode);
-	if (err) {
+	err = hostfs_read_inode(root_inode);
+	if (err){
 		/* No iput in this case because the dput does that for us */
 		dput(sb->s_root);
 		sb->s_root = NULL;
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
iget-stop-hppfs-from-using-iget-and-read_inode.patch
iget-remove-iget-and-the-read_inode-super-op-as.patch
mutex-subsystem-synchro-test-module.patch
