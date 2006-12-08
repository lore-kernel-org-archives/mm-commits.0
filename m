From: akpm@osdl.org
Subject: - struct-path-convert-jffs.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:03:49 -0800
Message-ID: <200612082003.kB8K3ngU002108@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57212 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426262AbWLHUDy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:03:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert jffs
has been removed from the -mm tree.  Its filename was
     struct-path-convert-jffs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert jffs
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/jffs/inode-v23.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/jffs/inode-v23.c~struct-path-convert-jffs fs/jffs/inode-v23.c
--- a/fs/jffs/inode-v23.c~struct-path-convert-jffs
+++ a/fs/jffs/inode-v23.c
@@ -566,7 +566,7 @@ static int
 jffs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 {
 	struct jffs_file *f;
-	struct dentry *dentry = filp->f_dentry;
+	struct dentry *dentry = filp->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	struct jffs_control *c = (struct jffs_control *)inode->i_sb->s_fs_info;
 	int j;
@@ -1372,7 +1372,7 @@ jffs_file_write(struct file *filp, const
 	struct jffs_control *c;
 	struct jffs_file *f;
 	struct jffs_node *node;
-	struct dentry *dentry = filp->f_dentry;
+	struct dentry *dentry = filp->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	int recoverable = 0;
 	size_t written = 0;
@@ -1380,7 +1380,7 @@ jffs_file_write(struct file *filp, const
 	loff_t pos = *ppos;
 	int err;
 
-	inode = filp->f_dentry->d_inode;
+	inode = filp->f_path.dentry->d_inode;
 
 	D2(printk("***jffs_file_write(): inode: 0x%p (ino: %lu), "
 		  "filp: 0x%p, buf: 0x%p, count: %d\n",
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

struct-path-convert-jffs.patch
struct-path-convert-jffs2.patch
struct-path-convert-jfs.patch
struct-path-convert-kernel.patch
struct-path-convert-lockd.patch
struct-path-convert-md.patch
struct-path-convert-minix.patch
struct-path-convert-mips.patch
struct-path-convert-mm.patch
struct-path-convert-nbd.patch
struct-path-convert-ncpfs.patch
struct-path-convert-net.patch
struct-path-convert-netfilter.patch
struct-path-convert-netlink.patch
struct-path-convert-ocfs2.patch
struct-path-convert-openpromfs.patch
struct-path-convert-oprofile.patch
struct-path-convert-parisc.patch
struct-path-convert-pci.patch
struct-path-convert-pcmcia.patch
struct-path-convert-powerpc.patch
struct-path-convert-ppc.patch
struct-path-convert-qnx4.patch
struct-path-convert-ramfs.patch
struct-path-convert-reiserfs.patch
struct-path-convert-romfs.patch
struct-path-convert-s390-drivers.patch
struct-path-convert-s390.patch
struct-path-convert-sbus.patch
struct-path-convert-scsi.patch
struct-path-convert-selinux.patch
struct-path-convert-sh.patch
struct-path-convert-smbfs.patch
struct-path-convert-sound.patch
struct-path-convert-sparc.patch
struct-path-convert-sparc64.patch
struct-path-convert-sunrpc.patch
struct-path-convert-sysv.patch
struct-path-convert-udf.patch
struct-path-convert-ufs.patch
struct-path-convert-unix.patch
struct-path-convert-usb.patch
struct-path-convert-v4l.patch
struct-path-convert-video.patch
struct-path-convert-zorro.patch

