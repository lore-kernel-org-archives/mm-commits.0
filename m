From: akpm@linux-foundation.org
Subject: + iget-stop-hppfs-from-using-iget-and-read_inode.patch added to -mm tree
Date: Sat, 27 Oct 2007 00:52:29 -0700
Message-ID: <200710270752.l9R7qTFD003634@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52742 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752602AbXJ0Hwn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Oct 2007 03:52:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     iget: stop HPPFS from using iget() and read_inode()
has been added to the -mm tree.  Its filename is
     iget-stop-hppfs-from-using-iget-and-read_inode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
