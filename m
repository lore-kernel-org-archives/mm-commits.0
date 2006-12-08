From: akpm@osdl.org
Subject: - struct-path-convert-hfs.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:03:14 -0800
Message-ID: <200612082003.kB8K3EQw002052@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57125 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426258AbWLHUDT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:03:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert hfs
has been removed from the -mm tree.  Its filename was
     struct-path-convert-hfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert hfs
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/hfs/dir.c   |    2 +-
 fs/hfs/inode.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/hfs/dir.c~struct-path-convert-hfs fs/hfs/dir.c
--- a/fs/hfs/dir.c~struct-path-convert-hfs
+++ a/fs/hfs/dir.c
@@ -53,7 +53,7 @@ done:
  */
 static int hfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 {
-	struct inode *inode = filp->f_dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct super_block *sb = inode->i_sb;
 	int len, err;
 	char strbuf[HFS_MAX_NAMELEN];
diff -puN fs/hfs/inode.c~struct-path-convert-hfs fs/hfs/inode.c
--- a/fs/hfs/inode.c~struct-path-convert-hfs
+++ a/fs/hfs/inode.c
@@ -102,7 +102,7 @@ static ssize_t hfs_direct_IO(int rw, str
 		const struct iovec *iov, loff_t offset, unsigned long nr_segs)
 {
 	struct file *file = iocb->ki_filp;
-	struct inode *inode = file->f_dentry->d_inode->i_mapping->host;
+	struct inode *inode = file->f_path.dentry->d_inode->i_mapping->host;
 
 	return blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
 				  offset, nr_segs, hfs_get_block, NULL);
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

struct-path-convert-hfs.patch
struct-path-convert-hfsplus.patch
struct-path-convert-hostfs.patch
struct-path-convert-hpfs.patch
struct-path-convert-hppfs.patch
struct-path-convert-hugetlbfs.patch
struct-path-convert-i2c-drivers.patch
struct-path-convert-ia64.patch
struct-path-convert-ieee1394.patch
struct-path-convert-infiniband.patch
struct-path-convert-ipc.patch
struct-path-convert-ipmi.patch
struct-path-convert-isapnp.patch
struct-path-convert-isdn.patch
struct-path-convert-ixj.patch
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

