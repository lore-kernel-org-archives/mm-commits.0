From: akpm@osdl.org
Subject: - struct-path-convert-block_drivers.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:02:45 -0800
Message-ID: <200612082002.kB8K2jfV002000@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57063 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426245AbWLHUCt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:02:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert block_drivers
has been removed from the -mm tree.  Its filename was
     struct-path-convert-block_drivers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert block_drivers
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/block/acsi_slm.c |    4 ++--
 drivers/block/cciss.c    |    2 +-
 drivers/block/loop.c     |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/block/acsi_slm.c~struct-path-convert-block_drivers drivers/block/acsi_slm.c
--- a/drivers/block/acsi_slm.c~struct-path-convert-block_drivers
+++ a/drivers/block/acsi_slm.c
@@ -363,7 +363,7 @@ static ssize_t slm_read( struct file *fi
 						 loff_t *ppos )
 
 {
-	struct inode *node = file->f_dentry->d_inode;
+	struct inode *node = file->f_path.dentry->d_inode;
 	unsigned long page;
 	int length;
 	int end;
@@ -618,7 +618,7 @@ static ssize_t slm_write( struct file *f
 						  loff_t *ppos )
 
 {
-	struct inode *node = file->f_dentry->d_inode;
+	struct inode *node = file->f_path.dentry->d_inode;
 	int		device = iminor(node);
 	int		n, filled, w, h;
 
diff -puN drivers/block/cciss.c~struct-path-convert-block_drivers drivers/block/cciss.c
--- a/drivers/block/cciss.c~struct-path-convert-block_drivers
+++ a/drivers/block/cciss.c
@@ -535,7 +535,7 @@ static int do_ioctl(struct file *f, unsi
 {
 	int ret;
 	lock_kernel();
-	ret = cciss_ioctl(f->f_dentry->d_inode, f, cmd, arg);
+	ret = cciss_ioctl(f->f_path.dentry->d_inode, f, cmd, arg);
 	unlock_kernel();
 	return ret;
 }
diff -puN drivers/block/loop.c~struct-path-convert-block_drivers drivers/block/loop.c
--- a/drivers/block/loop.c~struct-path-convert-block_drivers
+++ a/drivers/block/loop.c
@@ -1000,7 +1000,7 @@ loop_get_status(struct loop_device *lo, 
 
 	if (lo->lo_state != Lo_bound)
 		return -ENXIO;
-	error = vfs_getattr(file->f_vfsmnt, file->f_dentry, &stat);
+	error = vfs_getattr(file->f_path.mnt, file->f_path.dentry, &stat);
 	if (error)
 		return error;
 	memset(info, 0, sizeof(*info));
@@ -1287,7 +1287,7 @@ loop_get_status_compat(struct loop_devic
 
 static long lo_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	struct loop_device *lo = inode->i_bdev->bd_disk->private_data;
 	int err;
 
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

struct-path-convert-block_drivers.patch
struct-path-convert-char-drivers.patch
struct-path-convert-coda.patch
struct-path-convert-cosa.patch
struct-path-convert-cramfs.patch
struct-path-convert-cris.patch
struct-path-convert-drm.patch
struct-path-convert-efs.patch
struct-path-convert-freevxfs.patch
struct-path-convert-frv.patch
struct-path-convert-fuse.patch
struct-path-convert-gfs2.patch
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

