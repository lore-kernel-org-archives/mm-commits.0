From: akpm@osdl.org
Subject: - struct-path-convert-hostfs.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:03:18 -0800
Message-ID: <200612082003.kB8K3Ilu002058@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57138 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426269AbWLHUDX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:03:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert hostfs
has been removed from the -mm tree.  Its filename was
     struct-path-convert-hostfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert hostfs
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/hostfs/hostfs_kern.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/hostfs/hostfs_kern.c~struct-path-convert-hostfs fs/hostfs/hostfs_kern.c
--- a/fs/hostfs/hostfs_kern.c~struct-path-convert-hostfs
+++ a/fs/hostfs/hostfs_kern.c
@@ -35,7 +35,7 @@ static inline struct hostfs_inode_info *
 	return(list_entry(inode, struct hostfs_inode_info, vfs_inode));
 }
 
-#define FILE_HOSTFS_I(file) HOSTFS_I((file)->f_dentry->d_inode)
+#define FILE_HOSTFS_I(file) HOSTFS_I((file)->f_path.dentry->d_inode)
 
 int hostfs_d_delete(struct dentry *dentry)
 {
@@ -325,7 +325,7 @@ int hostfs_readdir(struct file *file, vo
 	unsigned long long next, ino;
 	int error, len;
 
-	name = dentry_name(file->f_dentry, 0);
+	name = dentry_name(file->f_path.dentry, 0);
 	if(name == NULL) return(-ENOMEM);
 	dir = open_dir(name, &error);
 	kfree(name);
@@ -366,7 +366,7 @@ int hostfs_file_open(struct inode *ino, 
 	if(w)
 		r = 1;
 
-	name = dentry_name(file->f_dentry, 0);
+	name = dentry_name(file->f_path.dentry, 0);
 	if(name == NULL)
 		return(-ENOMEM);
 
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

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

