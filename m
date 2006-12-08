From: akpm@osdl.org
Subject: - struct-path-convert-infiniband.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:03:33 -0800
Message-ID: <200612082003.kB8K3XvU002085@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57178 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426261AbWLHUDi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:03:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert infiniband
has been removed from the -mm tree.  Its filename was
     struct-path-convert-infiniband.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert infiniband
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/infiniband/core/uverbs_main.c        |    6 +++---
 drivers/infiniband/hw/ipath/ipath_file_ops.c |    4 ++--
 drivers/infiniband/hw/ipath/ipath_fs.c       |   10 +++++-----
 3 files changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/infiniband/core/uverbs_main.c~struct-path-convert-infiniband drivers/infiniband/core/uverbs_main.c
--- a/drivers/infiniband/core/uverbs_main.c~struct-path-convert-infiniband
+++ a/drivers/infiniband/core/uverbs_main.c
@@ -534,9 +534,9 @@ struct file *ib_uverbs_alloc_event_file(
 	 * module reference.
 	 */
 	filp->f_op 	   = fops_get(&uverbs_event_fops);
-	filp->f_vfsmnt 	   = mntget(uverbs_event_mnt);
-	filp->f_dentry 	   = dget(uverbs_event_mnt->mnt_root);
-	filp->f_mapping    = filp->f_dentry->d_inode->i_mapping;
+	filp->f_path.mnt 	   = mntget(uverbs_event_mnt);
+	filp->f_path.dentry 	   = dget(uverbs_event_mnt->mnt_root);
+	filp->f_mapping    = filp->f_path.dentry->d_inode->i_mapping;
 	filp->f_flags      = O_RDONLY;
 	filp->f_mode       = FMODE_READ;
 	filp->private_data = ev_file;
diff -puN drivers/infiniband/hw/ipath/ipath_file_ops.c~struct-path-convert-infiniband drivers/infiniband/hw/ipath/ipath_file_ops.c
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c~struct-path-convert-infiniband
+++ a/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -1745,9 +1745,9 @@ static int ipath_assign_port(struct file
 		goto done;
 	}
 
-	i_minor = iminor(fp->f_dentry->d_inode) - IPATH_USER_MINOR_BASE;
+	i_minor = iminor(fp->f_path.dentry->d_inode) - IPATH_USER_MINOR_BASE;
 	ipath_cdbg(VERBOSE, "open on dev %lx (minor %d)\n",
-		   (long)fp->f_dentry->d_inode->i_rdev, i_minor);
+		   (long)fp->f_path.dentry->d_inode->i_rdev, i_minor);
 
 	if (i_minor)
 		ret = find_free_port(i_minor - 1, fp, uinfo);
diff -puN drivers/infiniband/hw/ipath/ipath_fs.c~struct-path-convert-infiniband drivers/infiniband/hw/ipath/ipath_fs.c
--- a/drivers/infiniband/hw/ipath/ipath_fs.c~struct-path-convert-infiniband
+++ a/drivers/infiniband/hw/ipath/ipath_fs.c
@@ -118,7 +118,7 @@ static ssize_t atomic_counters_read(stru
 	u16 i;
 	struct ipath_devdata *dd;
 
-	dd = file->f_dentry->d_inode->i_private;
+	dd = file->f_path.dentry->d_inode->i_private;
 
 	for (i = 0; i < NUM_COUNTERS; i++)
 		counters[i] = ipath_snap_cntr(dd, i);
@@ -138,7 +138,7 @@ static ssize_t atomic_node_info_read(str
 	struct ipath_devdata *dd;
 	u64 guid;
 
-	dd = file->f_dentry->d_inode->i_private;
+	dd = file->f_path.dentry->d_inode->i_private;
 
 	guid = be64_to_cpu(dd->ipath_guid);
 
@@ -177,7 +177,7 @@ static ssize_t atomic_port_info_read(str
 	u32 tmp, tmp2;
 	struct ipath_devdata *dd;
 
-	dd = file->f_dentry->d_inode->i_private;
+	dd = file->f_path.dentry->d_inode->i_private;
 
 	/* so we only initialize non-zero fields. */
 	memset(portinfo, 0, sizeof portinfo);
@@ -324,7 +324,7 @@ static ssize_t flash_read(struct file *f
 		goto bail;
 	}
 
-	dd = file->f_dentry->d_inode->i_private;
+	dd = file->f_path.dentry->d_inode->i_private;
 	if (ipath_eeprom_read(dd, pos, tmp, count)) {
 		ipath_dev_err(dd, "failed to read from flash\n");
 		ret = -ENXIO;
@@ -377,7 +377,7 @@ static ssize_t flash_write(struct file *
 		goto bail_tmp;
 	}
 
-	dd = file->f_dentry->d_inode->i_private;
+	dd = file->f_path.dentry->d_inode->i_private;
 	if (ipath_eeprom_write(dd, pos, tmp, count)) {
 		ret = -ENXIO;
 		ipath_dev_err(dd, "failed to write to flash\n");
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

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

