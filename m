From: akpm@osdl.org
Subject: - struct-path-convert-hpfs.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:03:20 -0800
Message-ID: <200612082003.kB8K3KMl002061@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57143 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426274AbWLHUDZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:03:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert hpfs
has been removed from the -mm tree.  Its filename was
     struct-path-convert-hpfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert hpfs
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/hpfs/dir.c  |    4 ++--
 fs/hpfs/file.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/hpfs/dir.c~struct-path-convert-hpfs fs/hpfs/dir.c
--- a/fs/hpfs/dir.c~struct-path-convert-hpfs
+++ a/fs/hpfs/dir.c
@@ -24,7 +24,7 @@ static loff_t hpfs_dir_lseek(struct file
 	loff_t new_off = off + (whence == 1 ? filp->f_pos : 0);
 	loff_t pos;
 	struct quad_buffer_head qbh;
-	struct inode *i = filp->f_dentry->d_inode;
+	struct inode *i = filp->f_path.dentry->d_inode;
 	struct hpfs_inode_info *hpfs_inode = hpfs_i(i);
 	struct super_block *s = i->i_sb;
 
@@ -52,7 +52,7 @@ fail:
 
 static int hpfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 {
-	struct inode *inode = filp->f_dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct hpfs_inode_info *hpfs_inode = hpfs_i(inode);
 	struct quad_buffer_head qbh;
 	struct hpfs_dirent *de;
diff -puN fs/hpfs/file.c~struct-path-convert-hpfs fs/hpfs/file.c
--- a/fs/hpfs/file.c~struct-path-convert-hpfs
+++ a/fs/hpfs/file.c
@@ -115,7 +115,7 @@ static ssize_t hpfs_file_write(struct fi
 
 	retval = do_sync_write(file, buf, count, ppos);
 	if (retval > 0)
-		hpfs_i(file->f_dentry->d_inode)->i_dirty = 1;
+		hpfs_i(file->f_path.dentry->d_inode)->i_dirty = 1;
 	return retval;
 }
 
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

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

