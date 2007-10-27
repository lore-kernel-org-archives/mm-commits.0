From: akpm@linux-foundation.org
Subject: + iget-stop-cifs-from-using-iget-and-read_inode-try.patch added to -mm tree
Date: Sat, 27 Oct 2007 00:44:43 -0700
Message-ID: <200710270744.l9R7ihdn003278@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33065 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751558AbXJ0HpB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Oct 2007 03:45:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, sfrench@us.ibm.com


The patch titled
     iget: stop CIFS from using iget() and read_inode()
has been added to the -mm tree.  Its filename is
     iget-stop-cifs-from-using-iget-and-read_inode-try.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iget: stop CIFS from using iget() and read_inode()
From: David Howells <dhowells@redhat.com>

Stop the CIFS filesystem from using iget() and read_inode().  Replace
cifs_read_inode() with cifs_iget(), and call that instead of iget(). 
cifs_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

cifs_read_super() now returns any error incurred when getting the root inode
instead of ENOMEM.

cifs_iget() needs examining.  The comment "can not call macro FreeXid here
since in a void func" is no longer true.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/cifsfs.c |    8 ++++----
 fs/cifs/cifsfs.h |    1 +
 fs/cifs/inode.c  |   22 +++++++++++++++++++---
 3 files changed, 24 insertions(+), 7 deletions(-)

diff -puN fs/cifs/cifsfs.c~iget-stop-cifs-from-using-iget-and-read_inode-try fs/cifs/cifsfs.c
--- a/fs/cifs/cifsfs.c~iget-stop-cifs-from-using-iget-and-read_inode-try
+++ a/fs/cifs/cifsfs.c
@@ -122,10 +122,11 @@ cifs_read_super(struct super_block *sb, 
 #endif
 	sb->s_blocksize = CIFS_MAX_MSGSIZE;
 	sb->s_blocksize_bits = 14;	/* default 2**14 = CIFS_MAX_MSGSIZE */
-	inode = iget(sb, ROOT_I);
+	inode = cifs_iget(sb, ROOT_I);
 
-	if (!inode) {
-		rc = -ENOMEM;
+	if (IS_ERR(inode)) {
+		rc = PTR_ERR(inode);
+		inode = NULL;
 		goto out_no_root;
 	}
 
@@ -477,7 +478,6 @@ static int cifs_remount(struct super_blo
 }
 
 static const struct super_operations cifs_super_ops = {
-	.read_inode = cifs_read_inode,
 	.put_super = cifs_put_super,
 	.statfs = cifs_statfs,
 	.alloc_inode = cifs_alloc_inode,
diff -puN fs/cifs/cifsfs.h~iget-stop-cifs-from-using-iget-and-read_inode-try fs/cifs/cifsfs.h
--- a/fs/cifs/cifsfs.h~iget-stop-cifs-from-using-iget-and-read_inode-try
+++ a/fs/cifs/cifsfs.h
@@ -43,6 +43,7 @@ extern void cifs_read_inode(struct inode
 
 /* Functions related to inodes */
 extern const struct inode_operations cifs_dir_inode_ops;
+extern struct inode *cifs_iget(struct super_block *, unsigned long);
 extern int cifs_create(struct inode *, struct dentry *, int,
 		       struct nameidata *);
 extern struct dentry *cifs_lookup(struct inode *, struct dentry *,
diff -puN fs/cifs/inode.c~iget-stop-cifs-from-using-iget-and-read_inode-try fs/cifs/inode.c
--- a/fs/cifs/inode.c~iget-stop-cifs-from-using-iget-and-read_inode-try
+++ a/fs/cifs/inode.c
@@ -586,10 +586,18 @@ static const struct inode_operations cif
 };
 
 /* gets root inode */
-void cifs_read_inode(struct inode *inode)
+struct inode *cifs_iget(struct super_block *sb, unsigned long ino)
 {
-	int xid, rc;
+	int xid;
 	struct cifs_sb_info *cifs_sb;
+	struct inode *inode;
+	long rc;
+
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
 
 	cifs_sb = CIFS_SB(inode->i_sb);
 	xid = GetXid();
@@ -606,10 +614,18 @@ void cifs_read_inode(struct inode *inode
 		inode->i_fop = &simple_dir_operations;
 		inode->i_uid = cifs_sb->mnt_uid;
 		inode->i_gid = cifs_sb->mnt_gid;
+		_FreeXid(xid);
+		iget_failed(inode);
+		return ERR_PTR(rc);
 	}
 
-	/* can not call macro FreeXid here since in a void func */
+	unlock_new_inode(inode);
+
+	/* can not call macro FreeXid here since in a void func
+	 * TODO: This is no longer true
+	 */
 	_FreeXid(xid);
+	return inode;
 }
 
 int cifs_unlink(struct inode *inode, struct dentry *direntry)
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
iget-stop-ext2-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
iget-stop-fat-from-using-iget-and-read_inode-try.patch
iget-stop-freevxfs-from-using-iget-and-read_inode.patch
iget-stop-fuse-from-using-iget-and-read_inode-try.patch
iget-stop-hfsplus-from-using-iget-and-read_inode.patch
iget-stop-isofs-from-using-read_inode.patch
iget-stop-jffs2-from-using-iget-and-read_inode.patch
iget-stop-jfs-from-using-iget-and-read_inode-try.patch
iget-stop-the-minix-filesystem-from-using-iget-and.patch
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
