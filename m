From: akpm@osdl.org
Subject: - struct-path-convert-coda.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:02:50 -0800
Message-ID: <200612082002.kB8K2osU002008@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57080 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426251AbWLHUCz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:02:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert coda
has been removed from the -mm tree.  Its filename was
     struct-path-convert-coda.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert coda
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/coda/dir.c   |    8 ++++----
 fs/coda/file.c  |   14 +++++++-------
 fs/coda/inode.c |    2 +-
 3 files changed, 12 insertions(+), 12 deletions(-)

diff -puN fs/coda/dir.c~struct-path-convert-coda fs/coda/dir.c
--- a/fs/coda/dir.c~struct-path-convert-coda
+++ a/fs/coda/dir.c
@@ -441,7 +441,7 @@ static int coda_rename(struct inode *old
 /* file operations for directories */
 int coda_readdir(struct file *coda_file, void *dirent, filldir_t filldir)
 {
-	struct dentry *coda_dentry = coda_file->f_dentry;
+	struct dentry *coda_dentry = coda_file->f_path.dentry;
 	struct coda_file_info *cfi;
 	struct file *host_file;
 	struct inode *host_inode;
@@ -453,7 +453,7 @@ int coda_readdir(struct file *coda_file,
 
 	coda_vfs_stat.readdir++;
 
-	host_inode = host_file->f_dentry->d_inode;
+	host_inode = host_file->f_path.dentry->d_inode;
 	mutex_lock(&host_inode->i_mutex);
 	host_file->f_pos = coda_file->f_pos;
 
@@ -544,14 +544,14 @@ static int coda_venus_readdir(struct fil
 		/* catch truncated reads */
 		if (ret < vdir_size || ret < vdir_size + vdir->d_namlen) {
 			printk("coda_venus_readdir: short read: %ld\n",
-			       filp->f_dentry->d_inode->i_ino);
+			       filp->f_path.dentry->d_inode->i_ino);
 			ret = -EBADF;
 			break;
 		}
 		/* validate whether the directory file actually makes sense */
 		if (vdir->d_reclen < vdir_size + vdir->d_namlen) {
 			printk("coda_venus_readdir: Invalid dir: %ld\n",
-			       filp->f_dentry->d_inode->i_ino);
+			       filp->f_path.dentry->d_inode->i_ino);
 			ret = -EBADF;
 			break;
 		}
diff -puN fs/coda/file.c~struct-path-convert-coda fs/coda/file.c
--- a/fs/coda/file.c~struct-path-convert-coda
+++ a/fs/coda/file.c
@@ -66,7 +66,7 @@ coda_file_sendfile(struct file *coda_fil
 static ssize_t
 coda_file_write(struct file *coda_file, const char __user *buf, size_t count, loff_t *ppos)
 {
-	struct inode *host_inode, *coda_inode = coda_file->f_dentry->d_inode;
+	struct inode *host_inode, *coda_inode = coda_file->f_path.dentry->d_inode;
 	struct coda_file_info *cfi;
 	struct file *host_file;
 	ssize_t ret;
@@ -78,7 +78,7 @@ coda_file_write(struct file *coda_file, 
 	if (!host_file->f_op || !host_file->f_op->write)
 		return -EINVAL;
 
-	host_inode = host_file->f_dentry->d_inode;
+	host_inode = host_file->f_path.dentry->d_inode;
 	mutex_lock(&coda_inode->i_mutex);
 
 	ret = host_file->f_op->write(host_file, buf, count, ppos);
@@ -106,8 +106,8 @@ coda_file_mmap(struct file *coda_file, s
 	if (!host_file->f_op || !host_file->f_op->mmap)
 		return -ENODEV;
 
-	coda_inode = coda_file->f_dentry->d_inode;
-	host_inode = host_file->f_dentry->d_inode;
+	coda_inode = coda_file->f_path.dentry->d_inode;
+	host_inode = host_file->f_path.dentry->d_inode;
 	coda_file->f_mapping = host_file->f_mapping;
 	if (coda_inode->i_mapping == &coda_inode->i_data)
 		coda_inode->i_mapping = host_inode->i_mapping;
@@ -190,7 +190,7 @@ int coda_flush(struct file *coda_file, f
 	cfi = CODA_FTOC(coda_file);
 	BUG_ON(!cfi || cfi->cfi_magic != CODA_MAGIC);
 
-	coda_inode = coda_file->f_dentry->d_inode;
+	coda_inode = coda_file->f_path.dentry->d_inode;
 
 	err = venus_store(coda_inode->i_sb, coda_i2f(coda_inode), coda_flags,
 			  coda_file->f_uid);
@@ -233,7 +233,7 @@ int coda_release(struct inode *coda_inod
 		err = venus_close(coda_inode->i_sb, coda_i2f(coda_inode),
 				  coda_flags, coda_file->f_uid);
 
-	host_inode = cfi->cfi_container->f_dentry->d_inode;
+	host_inode = cfi->cfi_container->f_path.dentry->d_inode;
 	cii = ITOC(coda_inode);
 
 	/* did we mmap this file? */
@@ -270,7 +270,7 @@ int coda_fsync(struct file *coda_file, s
 	coda_vfs_stat.fsync++;
 
 	if (host_file->f_op && host_file->f_op->fsync) {
-		host_dentry = host_file->f_dentry;
+		host_dentry = host_file->f_path.dentry;
 		host_inode = host_dentry->d_inode;
 		mutex_lock(&host_inode->i_mutex);
 		err = host_file->f_op->fsync(host_file, host_dentry, datasync);
diff -puN fs/coda/inode.c~struct-path-convert-coda fs/coda/inode.c
--- a/fs/coda/inode.c~struct-path-convert-coda
+++ a/fs/coda/inode.c
@@ -119,7 +119,7 @@ static int get_device_index(struct coda_
 	file = fget(data->fd);
 	inode = NULL;
 	if(file)
-		inode = file->f_dentry->d_inode;
+		inode = file->f_path.dentry->d_inode;
 	
 	if(!inode || !S_ISCHR(inode->i_mode) ||
 	   imajor(inode) != CODA_PSDEV_MAJOR) {
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

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

