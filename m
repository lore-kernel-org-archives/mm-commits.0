From: akpm@linux-foundation.org
Subject: - iget-stop-cifs-from-using-iget-and-read_inode-try.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:07:26 -0800
Message-ID: <200802080807.m18877Cj014511@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36903 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932307AbYBHIVC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:21:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, hch@lst.de, sfrench@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     iget: stop CIFS from using iget() and read_inode()
has been removed from the -mm tree.  Its filename was
     iget-stop-cifs-from-using-iget-and-read_inode-try.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/cifsfs.c |    8 ++++----
 fs/cifs/cifsfs.h |    1 +
 fs/cifs/inode.c  |   22 +++++++++++++++++++---
 3 files changed, 24 insertions(+), 7 deletions(-)

diff -puN fs/cifs/cifsfs.c~iget-stop-cifs-from-using-iget-and-read_inode-try fs/cifs/cifsfs.c
--- a/fs/cifs/cifsfs.c~iget-stop-cifs-from-using-iget-and-read_inode-try
+++ a/fs/cifs/cifsfs.c
@@ -147,10 +147,11 @@ cifs_read_super(struct super_block *sb, 
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
 
@@ -520,7 +521,6 @@ static int cifs_remount(struct super_blo
 }
 
 static const struct super_operations cifs_super_ops = {
-	.read_inode = cifs_read_inode,
 	.put_super = cifs_put_super,
 	.statfs = cifs_statfs,
 	.alloc_inode = cifs_alloc_inode,
diff -puN fs/cifs/cifsfs.h~iget-stop-cifs-from-using-iget-and-read_inode-try fs/cifs/cifsfs.h
--- a/fs/cifs/cifsfs.h~iget-stop-cifs-from-using-iget-and-read_inode-try
+++ a/fs/cifs/cifsfs.h
@@ -44,6 +44,7 @@ extern void cifs_read_inode(struct inode
 
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
