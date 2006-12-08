From: akpm@osdl.org
Subject: - struct-path-convert-jffs2.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:03:52 -0800
Message-ID: <200612082003.kB8K3qXZ002115@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57224 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426257AbWLHUD5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:03:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert jffs2
has been removed from the -mm tree.  Its filename was
     struct-path-convert-jffs2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert jffs2
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/jffs2/dir.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/jffs2/dir.c~struct-path-convert-jffs2 fs/jffs2/dir.c
--- a/fs/jffs2/dir.c~struct-path-convert-jffs2
+++ a/fs/jffs2/dir.c
@@ -123,11 +123,11 @@ static int jffs2_readdir(struct file *fi
 {
 	struct jffs2_inode_info *f;
 	struct jffs2_sb_info *c;
-	struct inode *inode = filp->f_dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct jffs2_full_dirent *fd;
 	unsigned long offset, curofs;
 
-	D1(printk(KERN_DEBUG "jffs2_readdir() for dir_i #%lu\n", filp->f_dentry->d_inode->i_ino));
+	D1(printk(KERN_DEBUG "jffs2_readdir() for dir_i #%lu\n", filp->f_path.dentry->d_inode->i_ino));
 
 	f = JFFS2_INODE_INFO(inode);
 	c = JFFS2_SB_INFO(inode->i_sb);
@@ -141,7 +141,7 @@ static int jffs2_readdir(struct file *fi
 		offset++;
 	}
 	if (offset == 1) {
-		unsigned long pino = parent_ino(filp->f_dentry);
+		unsigned long pino = parent_ino(filp->f_path.dentry);
 		D1(printk(KERN_DEBUG "Dirent 1: \"..\", ino #%lu\n", pino));
 		if (filldir(dirent, "..", 2, 1, pino, DT_DIR) < 0)
 			goto out;
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

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

