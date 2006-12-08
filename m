From: akpm@osdl.org
Subject: - struct-path-convert-mips.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:04:07 -0800
Message-ID: <200612082004.kB8K47C8002145@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57273 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426282AbWLHUEP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:04:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert mips
has been removed from the -mm tree.  Its filename was
     struct-path-convert-mips.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert mips
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/mips/kernel/rtlx.c    |    6 +++---
 arch/mips/kernel/sysirix.c |   10 +++++-----
 arch/mips/kernel/vpe.c     |    2 +-
 arch/mips/lasat/sysctl.c   |    6 +++---
 4 files changed, 12 insertions(+), 12 deletions(-)

diff -puN arch/mips/kernel/rtlx.c~struct-path-convert-mips arch/mips/kernel/rtlx.c
--- a/arch/mips/kernel/rtlx.c~struct-path-convert-mips
+++ a/arch/mips/kernel/rtlx.c
@@ -415,7 +415,7 @@ static unsigned int file_poll(struct fil
 	int minor;
 	unsigned int mask = 0;
 
-	minor = iminor(file->f_dentry->d_inode);
+	minor = iminor(file->f_path.dentry->d_inode);
 
 	poll_wait(file, &channel_wqs[minor].rt_queue, wait);
 	poll_wait(file, &channel_wqs[minor].lx_queue, wait);
@@ -437,7 +437,7 @@ static unsigned int file_poll(struct fil
 static ssize_t file_read(struct file *file, char __user * buffer, size_t count,
 			 loff_t * ppos)
 {
-	int minor = iminor(file->f_dentry->d_inode);
+	int minor = iminor(file->f_path.dentry->d_inode);
 
 	/* data available? */
 	if (!rtlx_read_poll(minor, (file->f_flags & O_NONBLOCK) ? 0 : 1)) {
@@ -454,7 +454,7 @@ static ssize_t file_write(struct file *f
 	struct rtlx_channel *rt;
 	DECLARE_WAITQUEUE(wait, current);
 
-	minor = iminor(file->f_dentry->d_inode);
+	minor = iminor(file->f_path.dentry->d_inode);
 	rt = &rtlx->channel[minor];
 
 	/* any space left... */
diff -puN arch/mips/kernel/sysirix.c~struct-path-convert-mips arch/mips/kernel/sysirix.c
--- a/arch/mips/kernel/sysirix.c~struct-path-convert-mips
+++ a/arch/mips/kernel/sysirix.c
@@ -732,7 +732,7 @@ asmlinkage int irix_fstatfs(unsigned int
 		goto out;
 	}
 
-	error = vfs_statfs(file->f_dentry, &kbuf);
+	error = vfs_statfs(file->f_path.dentry, &kbuf);
 	if (error)
 		goto out_f;
 
@@ -1041,7 +1041,7 @@ asmlinkage unsigned long irix_mmap32(uns
 			unsigned long old_pos;
 			long max_size = offset + len;
 
-			if (max_size > file->f_dentry->d_inode->i_size) {
+			if (max_size > file->f_path.dentry->d_inode->i_size) {
 				old_pos = sys_lseek (fd, max_size - 1, 0);
 				sys_write (fd, (void __user *) "", 1);
 				sys_lseek (fd, old_pos, 0);
@@ -1406,7 +1406,7 @@ asmlinkage int irix_fstatvfs(int fd, str
 		error = -EBADF;
 		goto out;
 	}
-	error = vfs_statfs(file->f_dentry, &kbuf);
+	error = vfs_statfs(file->f_path.dentry, &kbuf);
 	if (error)
 		goto out_f;
 
@@ -1526,7 +1526,7 @@ asmlinkage int irix_mmap64(struct pt_reg
 			unsigned long old_pos;
 			long max_size = off2 + len;
 
-			if (max_size > file->f_dentry->d_inode->i_size) {
+			if (max_size > file->f_path.dentry->d_inode->i_size) {
 				old_pos = sys_lseek (fd, max_size - 1, 0);
 				sys_write (fd, (void __user *) "", 1);
 				sys_lseek (fd, old_pos, 0);
@@ -1658,7 +1658,7 @@ asmlinkage int irix_fstatvfs64(int fd, s
 		error = -EBADF;
 		goto out;
 	}
-	error = vfs_statfs(file->f_dentry, &kbuf);
+	error = vfs_statfs(file->f_path.dentry, &kbuf);
 	if (error)
 		goto out_f;
 
diff -puN arch/mips/kernel/vpe.c~struct-path-convert-mips arch/mips/kernel/vpe.c
--- a/arch/mips/kernel/vpe.c~struct-path-convert-mips
+++ a/arch/mips/kernel/vpe.c
@@ -1179,7 +1179,7 @@ static ssize_t vpe_write(struct file *fi
 	size_t ret = count;
 	struct vpe *v;
 
-	minor = iminor(file->f_dentry->d_inode);
+	minor = iminor(file->f_path.dentry->d_inode);
 	if ((v = get_vpe(minor)) == NULL)
 		return -ENODEV;
 
diff -puN arch/mips/lasat/sysctl.c~struct-path-convert-mips arch/mips/lasat/sysctl.c
--- a/arch/mips/lasat/sysctl.c~struct-path-convert-mips
+++ a/arch/mips/lasat/sysctl.c
@@ -286,11 +286,11 @@ int proc_lasat_eeprom_value(ctl_table *t
 		mutex_unlock(&lasat_info_mutex);
 		return r;
 	}
-	if (filp && filp->f_dentry)
+	if (filp && filp->f_path.dentry)
 	{
-		if (!strcmp(filp->f_dentry->d_name.name, "prid"))
+		if (!strcmp(filp->f_path.dentry->d_name.name, "prid"))
 			lasat_board_info.li_eeprom_info.prid = lasat_board_info.li_prid;
-		if (!strcmp(filp->f_dentry->d_name.name, "debugaccess"))
+		if (!strcmp(filp->f_path.dentry->d_name.name, "debugaccess"))
 			lasat_board_info.li_eeprom_info.debugaccess = lasat_board_info.li_debugaccess;
 	}
 	lasat_write_eeprom_info();
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

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

