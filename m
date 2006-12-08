From: akpm@osdl.org
Subject: - struct-path-convert-sbus.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:04:54 -0800
Message-ID: <200612082004.kB8K4sfC002241@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57410 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426312AbWLHUFA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:05:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert sbus
has been removed from the -mm tree.  Its filename was
     struct-path-convert-sbus.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert sbus
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/sbus/char/bpp.c         |    4 ++--
 drivers/sbus/char/cpwatchdog.c  |    2 +-
 drivers/sbus/char/display7seg.c |    2 +-
 drivers/sbus/char/openprom.c    |    2 +-
 drivers/sbus/char/vfc_dev.c     |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/sbus/char/bpp.c~struct-path-convert-sbus drivers/sbus/char/bpp.c
--- a/drivers/sbus/char/bpp.c~struct-path-convert-sbus
+++ a/drivers/sbus/char/bpp.c
@@ -621,7 +621,7 @@ static long read_ecp(unsigned minor, cha
 static ssize_t bpp_read(struct file *f, char __user *c, size_t cnt, loff_t * ppos)
 {
       long rc;
-      unsigned minor = iminor(f->f_dentry->d_inode);
+      unsigned minor = iminor(f->f_path.dentry->d_inode);
       if (minor >= BPP_NO) return -ENODEV;
       if (!instances[minor].present) return -ENODEV;
 
@@ -774,7 +774,7 @@ static long write_ecp(unsigned minor, co
 static ssize_t bpp_write(struct file *f, const char __user *c, size_t cnt, loff_t * ppos)
 {
       long errno = 0;
-      unsigned minor = iminor(f->f_dentry->d_inode);
+      unsigned minor = iminor(f->f_path.dentry->d_inode);
       if (minor >= BPP_NO) return -ENODEV;
       if (!instances[minor].present) return -ENODEV;
 
diff -puN drivers/sbus/char/cpwatchdog.c~struct-path-convert-sbus drivers/sbus/char/cpwatchdog.c
--- a/drivers/sbus/char/cpwatchdog.c~struct-path-convert-sbus
+++ a/drivers/sbus/char/cpwatchdog.c
@@ -404,7 +404,7 @@ static long wd_compat_ioctl(struct file 
 	case WIOCSTOP:
 	case WIOCGSTAT:
 		lock_kernel();
-		rval = wd_ioctl(file->f_dentry->d_inode, file, cmd, arg);
+		rval = wd_ioctl(file->f_path.dentry->d_inode, file, cmd, arg);
 		unlock_kernel();
 		break;
 	/* everything else is handled by the generic compat layer */
diff -puN drivers/sbus/char/display7seg.c~struct-path-convert-sbus drivers/sbus/char/display7seg.c
--- a/drivers/sbus/char/display7seg.c~struct-path-convert-sbus
+++ a/drivers/sbus/char/display7seg.c
@@ -121,7 +121,7 @@ static long d7s_ioctl(struct file *file,
 	__u8 ireg = 0;
 	int error = 0;
 
-	if (D7S_MINOR != iminor(file->f_dentry->d_inode))
+	if (D7S_MINOR != iminor(file->f_path.dentry->d_inode))
 		return -ENODEV;
 
 	lock_kernel();
diff -puN drivers/sbus/char/openprom.c~struct-path-convert-sbus drivers/sbus/char/openprom.c
--- a/drivers/sbus/char/openprom.c~struct-path-convert-sbus
+++ a/drivers/sbus/char/openprom.c
@@ -676,7 +676,7 @@ static long openprom_compat_ioctl(struct
 	case OPROMSETCUR:
 	case OPROMPCI2NODE:
 	case OPROMPATH2NODE:
-		rval = openprom_ioctl(file->f_dentry->d_inode, file, cmd, arg);
+		rval = openprom_ioctl(file->f_path.dentry->d_inode, file, cmd, arg);
 		break;
 	}
 
diff -puN drivers/sbus/char/vfc_dev.c~struct-path-convert-sbus drivers/sbus/char/vfc_dev.c
--- a/drivers/sbus/char/vfc_dev.c~struct-path-convert-sbus
+++ a/drivers/sbus/char/vfc_dev.c
@@ -610,7 +610,7 @@ static int vfc_mmap(struct file *file, s
 	unsigned int map_size, ret, map_offset;
 	struct vfc_dev *dev;
 	
-	dev = vfc_get_dev_ptr(iminor(file->f_dentry->d_inode));
+	dev = vfc_get_dev_ptr(iminor(file->f_path.dentry->d_inode));
 	if(dev == NULL)
 		return -ENODEV;
 
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

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

