From: akpm@osdl.org
Subject: - struct-path-convert-v4l.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:05:25 -0800
Message-ID: <200612082005.kB8K5PqT002296@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57516 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426319AbWLHUFc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:05:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert v4l
has been removed from the -mm tree.  Its filename was
     struct-path-convert-v4l.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert v4l
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/media/video/compat_ioctl32.c |    2 +-
 drivers/media/video/videodev.c       |    2 +-
 drivers/media/video/zoran_procfs.c   |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/media/video/compat_ioctl32.c~struct-path-convert-v4l drivers/media/video/compat_ioctl32.c
--- a/drivers/media/video/compat_ioctl32.c~struct-path-convert-v4l
+++ a/drivers/media/video/compat_ioctl32.c
@@ -118,7 +118,7 @@ static int native_ioctl(struct file *fil
 		ret = file->f_op->unlocked_ioctl(file, cmd, arg);
 	else if (file->f_op->ioctl) {
 		lock_kernel();
-		ret = file->f_op->ioctl(file->f_dentry->d_inode, file, cmd, arg);
+		ret = file->f_op->ioctl(file->f_path.dentry->d_inode, file, cmd, arg);
 		unlock_kernel();
 	}
 
diff -puN drivers/media/video/videodev.c~struct-path-convert-v4l drivers/media/video/videodev.c
--- a/drivers/media/video/videodev.c~struct-path-convert-v4l
+++ a/drivers/media/video/videodev.c
@@ -105,7 +105,7 @@ static DEFINE_MUTEX(videodev_lock);
 
 struct video_device* video_devdata(struct file *file)
 {
-	return video_device[iminor(file->f_dentry->d_inode)];
+	return video_device[iminor(file->f_path.dentry->d_inode)];
 }
 
 /*
diff -puN drivers/media/video/zoran_procfs.c~struct-path-convert-v4l drivers/media/video/zoran_procfs.c
--- a/drivers/media/video/zoran_procfs.c~struct-path-convert-v4l
+++ a/drivers/media/video/zoran_procfs.c
@@ -144,7 +144,7 @@ static int zoran_open(struct inode *inod
 static ssize_t zoran_write(struct file *file, const char __user *buffer,
 			size_t count, loff_t *ppos)
 {
-	struct zoran *zr = PDE(file->f_dentry->d_inode)->data;
+	struct zoran *zr = PDE(file->f_path.dentry->d_inode)->data;
 	char *string, *sp;
 	char *line, *ldelim, *varname, *svar, *tdelim;
 
@@ -165,7 +165,7 @@ static ssize_t zoran_write(struct file *
 	}
 	string[count] = 0;
 	dprintk(4, KERN_INFO "%s: write_proc: name=%s count=%zu zr=%p\n",
-		ZR_DEVNAME(zr), file->f_dentry->d_name.name, count, zr);
+		ZR_DEVNAME(zr), file->f_path.dentry->d_name.name, count, zr);
 	ldelim = " \t\n";
 	tdelim = "=";
 	line = strpbrk(sp, ldelim);
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

struct-path-convert-v4l.patch
struct-path-convert-video.patch
struct-path-convert-zorro.patch

