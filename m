From: akpm@osdl.org
Subject: - struct-path-convert-s390-drivers.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:04:50 -0800
Message-ID: <200612082004.kB8K4olx002235@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57402 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426306AbWLHUEy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:04:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert s390-drivers
has been removed from the -mm tree.  Its filename was
     struct-path-convert-s390-drivers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert s390-drivers
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/s390/block/dasd_ioctl.c |    2 +-
 drivers/s390/char/fs3270.c      |    4 ++--
 drivers/s390/char/tape_char.c   |    8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/s390/block/dasd_ioctl.c~struct-path-convert-s390-drivers drivers/s390/block/dasd_ioctl.c
--- a/drivers/s390/block/dasd_ioctl.c~struct-path-convert-s390-drivers
+++ a/drivers/s390/block/dasd_ioctl.c
@@ -430,7 +430,7 @@ dasd_compat_ioctl(struct file *filp, uns
 	int rval;
 
 	lock_kernel();
-	rval = dasd_ioctl(filp->f_dentry->d_inode, filp, cmd, arg);
+	rval = dasd_ioctl(filp->f_path.dentry->d_inode, filp, cmd, arg);
 	unlock_kernel();
 
 	return (rval == -EINVAL) ? -ENOIOCTLCMD : rval;
diff -puN drivers/s390/char/fs3270.c~struct-path-convert-s390-drivers drivers/s390/char/fs3270.c
--- a/drivers/s390/char/fs3270.c~struct-path-convert-s390-drivers
+++ a/drivers/s390/char/fs3270.c
@@ -419,9 +419,9 @@ fs3270_open(struct inode *inode, struct 
 	struct idal_buffer *ib;
 	int minor, rc;
 
-	if (imajor(filp->f_dentry->d_inode) != IBM_FS3270_MAJOR)
+	if (imajor(filp->f_path.dentry->d_inode) != IBM_FS3270_MAJOR)
 		return -ENODEV;
-	minor = iminor(filp->f_dentry->d_inode);
+	minor = iminor(filp->f_path.dentry->d_inode);
 	/* Check for minor 0 multiplexer. */
 	if (minor == 0) {
 		struct tty_struct *tty;
diff -puN drivers/s390/char/tape_char.c~struct-path-convert-s390-drivers drivers/s390/char/tape_char.c
--- a/drivers/s390/char/tape_char.c~struct-path-convert-s390-drivers
+++ a/drivers/s390/char/tape_char.c
@@ -298,13 +298,13 @@ tapechar_open (struct inode *inode, stru
 	int minor, rc;
 
 	DBF_EVENT(6, "TCHAR:open: %i:%i\n",
-		imajor(filp->f_dentry->d_inode),
-		iminor(filp->f_dentry->d_inode));
+		imajor(filp->f_path.dentry->d_inode),
+		iminor(filp->f_path.dentry->d_inode));
 
-	if (imajor(filp->f_dentry->d_inode) != tapechar_major)
+	if (imajor(filp->f_path.dentry->d_inode) != tapechar_major)
 		return -ENODEV;
 
-	minor = iminor(filp->f_dentry->d_inode);
+	minor = iminor(filp->f_path.dentry->d_inode);
 	device = tape_get_device(minor / TAPE_MINORS_PER_DEV);
 	if (IS_ERR(device)) {
 		DBF_EVENT(3, "TCHAR:open: tape_get_device() failed\n");
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

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

