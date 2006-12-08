From: akpm@osdl.org
Subject: - struct-path-convert-hugetlbfs.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:03:24 -0800
Message-ID: <200612082003.kB8K3O9C002067@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57154 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426278AbWLHUD2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:03:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert hugetlbfs
has been removed from the -mm tree.  Its filename was
     struct-path-convert-hugetlbfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert hugetlbfs
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/hugetlbfs/inode.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/hugetlbfs/inode.c~struct-path-convert-hugetlbfs fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~struct-path-convert-hugetlbfs
+++ a/fs/hugetlbfs/inode.c
@@ -58,7 +58,7 @@ static void huge_pagevec_release(struct 
 
 static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	loff_t len, vma_len;
 	int ret;
 
@@ -774,8 +774,8 @@ struct file *hugetlb_zero_setup(size_t s
 	d_instantiate(dentry, inode);
 	inode->i_size = size;
 	inode->i_nlink = 0;
-	file->f_vfsmnt = mntget(hugetlbfs_vfsmount);
-	file->f_dentry = dentry;
+	file->f_path.mnt = mntget(hugetlbfs_vfsmount);
+	file->f_path.dentry = dentry;
 	file->f_mapping = inode->i_mapping;
 	file->f_op = &hugetlbfs_file_operations;
 	file->f_mode = FMODE_WRITE | FMODE_READ;
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

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

