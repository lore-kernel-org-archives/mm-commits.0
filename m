From: akpm@osdl.org
Subject: - struct-path-convert-hppfs.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:03:22 -0800
Message-ID: <200612082003.kB8K3Mik002064@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57147 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426275AbWLHUD0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:03:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert hppfs
has been removed from the -mm tree.  Its filename was
     struct-path-convert-hppfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert hppfs
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/hppfs/hppfs_kern.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/hppfs/hppfs_kern.c~struct-path-convert-hppfs fs/hppfs/hppfs_kern.c
--- a/fs/hppfs/hppfs_kern.c~struct-path-convert-hppfs
+++ a/fs/hppfs/hppfs_kern.c
@@ -221,7 +221,7 @@ static ssize_t read_proc(struct file *fi
 	ssize_t (*read)(struct file *, char __user *, size_t, loff_t *);
 	ssize_t n;
 
-	read = file->f_dentry->d_inode->i_fop->read;
+	read = file->f_path.dentry->d_inode->i_fop->read;
 
 	if(!is_user)
 		set_fs(KERNEL_DS);
@@ -320,7 +320,7 @@ static ssize_t hppfs_write(struct file *
 	ssize_t (*write)(struct file *, const char __user *, size_t, loff_t *);
 	int err;
 
-	write = proc_file->f_dentry->d_inode->i_fop->write;
+	write = proc_file->f_path.dentry->d_inode->i_fop->write;
 
 	proc_file->f_pos = file->f_pos;
 	err = (*write)(proc_file, buf, len, &proc_file->f_pos);
@@ -464,7 +464,7 @@ static int hppfs_open(struct inode *inod
 	if(data == NULL)
 		goto out;
 
-	host_file = dentry_name(file->f_dentry, strlen("/rw"));
+	host_file = dentry_name(file->f_path.dentry, strlen("/rw"));
 	if(host_file == NULL)
 		goto out_free2;
 
@@ -547,7 +547,7 @@ static loff_t hppfs_llseek(struct file *
 	loff_t (*llseek)(struct file *, loff_t, int);
 	loff_t ret;
 
-	llseek = proc_file->f_dentry->d_inode->i_fop->llseek;
+	llseek = proc_file->f_path.dentry->d_inode->i_fop->llseek;
 	if(llseek != NULL){
 		ret = (*llseek)(proc_file, off, where);
 		if(ret < 0)
@@ -591,10 +591,10 @@ static int hppfs_readdir(struct file *fi
 	struct hppfs_dirent dirent = ((struct hppfs_dirent)
 		                      { .vfs_dirent  	= ent,
 					.filldir 	= filldir,
-					.dentry  	= file->f_dentry } );
+					.dentry  	= file->f_path.dentry } );
 	int err;
 
-	readdir = proc_file->f_dentry->d_inode->i_fop->readdir;
+	readdir = proc_file->f_path.dentry->d_inode->i_fop->readdir;
 
 	proc_file->f_pos = file->f_pos;
 	err = (*readdir)(proc_file, &dirent, hppfs_filldir);
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

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

