From: akpm@osdl.org
Subject: - struct-path-convert-pcmcia.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:04:36 -0800
Message-ID: <200612082004.kB8K4aRH002204@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57360 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426292AbWLHUEk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:04:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert pcmcia
has been removed from the -mm tree.  Its filename was
     struct-path-convert-pcmcia.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert pcmcia
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/pcmcia/pcmcia_ioctl.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/pcmcia/pcmcia_ioctl.c~struct-path-convert-pcmcia drivers/pcmcia/pcmcia_ioctl.c
--- a/drivers/pcmcia/pcmcia_ioctl.c~struct-path-convert-pcmcia
+++ a/drivers/pcmcia/pcmcia_ioctl.c
@@ -486,7 +486,7 @@ static ssize_t ds_read(struct file *file
     user_info_t *user;
     int ret;
 
-    ds_dbg(2, "ds_read(socket %d)\n", iminor(file->f_dentry->d_inode));
+    ds_dbg(2, "ds_read(socket %d)\n", iminor(file->f_path.dentry->d_inode));
 
     if (count < 4)
 	return -EINVAL;
@@ -511,7 +511,7 @@ static ssize_t ds_read(struct file *file
 static ssize_t ds_write(struct file *file, const char __user *buf,
 			size_t count, loff_t *ppos)
 {
-    ds_dbg(2, "ds_write(socket %d)\n", iminor(file->f_dentry->d_inode));
+    ds_dbg(2, "ds_write(socket %d)\n", iminor(file->f_path.dentry->d_inode));
 
     if (count != 4)
 	return -EINVAL;
@@ -529,7 +529,7 @@ static u_int ds_poll(struct file *file, 
     struct pcmcia_socket *s;
     user_info_t *user;
 
-    ds_dbg(2, "ds_poll(socket %d)\n", iminor(file->f_dentry->d_inode));
+    ds_dbg(2, "ds_poll(socket %d)\n", iminor(file->f_path.dentry->d_inode));
 
     user = file->private_data;
     if (CHECK_USER(user))
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

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

