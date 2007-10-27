From: akpm@linux-foundation.org
Subject: + iget-stop-procfs-from-using-iget-and-read_inode.patch added to -mm tree
Date: Sat, 27 Oct 2007 00:47:44 -0700
Message-ID: <200710270747.l9R7licm003413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43705 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751976AbXJ0Hr5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Oct 2007 03:47:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, ebiederm@xmission.com


The patch titled
     iget: stop PROCFS from using iget() and read_inode()
has been added to the -mm tree.  Its filename is
     iget-stop-procfs-from-using-iget-and-read_inode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iget: stop PROCFS from using iget() and read_inode()
From: David Howells <dhowells@redhat.com>

Stop the PROCFS filesystem from using iget() and read_inode().  Merge
procfs_read_inode() into procfs_get_inode(), and have that call iget_locked()
instead of iget().

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/inode.c |   60 +++++++++++++++++++++-------------------------
 1 file changed, 28 insertions(+), 32 deletions(-)

diff -puN fs/proc/inode.c~iget-stop-procfs-from-using-iget-and-read_inode fs/proc/inode.c
--- a/fs/proc/inode.c~iget-stop-procfs-from-using-iget-and-read_inode
+++ a/fs/proc/inode.c
@@ -78,11 +78,6 @@ static void proc_delete_inode(struct ino
 
 struct vfsmount *proc_mnt;
 
-static void proc_read_inode(struct inode * inode)
-{
-	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
-}
-
 static struct kmem_cache * proc_inode_cachep;
 
 static struct inode *proc_alloc_inode(struct super_block *sb)
@@ -133,7 +128,6 @@ static int proc_remount(struct super_blo
 static const struct super_operations proc_sops = {
 	.alloc_inode	= proc_alloc_inode,
 	.destroy_inode	= proc_destroy_inode,
-	.read_inode	= proc_read_inode,
 	.drop_inode	= generic_delete_inode,
 	.delete_inode	= proc_delete_inode,
 	.statfs		= simple_statfs,
@@ -406,39 +400,41 @@ struct inode *proc_get_inode(struct supe
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
+				}
+				else
+					inode->i_fop = de->proc_fops;
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
iget-stop-qnx4-from-using-iget-and-read_inode-try.patch
iget-stop-romfs-from-using-iget-and-read_inode.patch
iget-stop-the-sysv-filesystem-from-using-iget-and.patch
iget-stop-ufs-from-using-iget-and-read_inode-try.patch
iget-stop-openpromfs-from-using-iget-and.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hppfs-from-using-iget-and-read_inode.patch
iget-remove-iget-and-the-read_inode-super-op-as.patch
mutex-subsystem-synchro-test-module.patch
