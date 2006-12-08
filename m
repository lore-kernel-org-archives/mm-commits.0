From: akpm@osdl.org
Subject: - struct-path-convert-video.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:05:27 -0800
Message-ID: <200612082005.kB8K5RXr002305@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57519 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426322AbWLHUFd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:05:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert video
has been removed from the -mm tree.  Its filename was
     struct-path-convert-video.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert video
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/arcfb.c       |    2 +-
 drivers/video/epson1355fb.c |    4 ++--
 drivers/video/fbmem.c       |    8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/video/arcfb.c~struct-path-convert-video drivers/video/arcfb.c
--- a/drivers/video/arcfb.c~struct-path-convert-video
+++ a/drivers/video/arcfb.c
@@ -454,7 +454,7 @@ static ssize_t arcfb_write(struct file *
 	unsigned int xres;
 
 	p = *ppos;
-	inode = file->f_dentry->d_inode;
+	inode = file->f_path.dentry->d_inode;
 	fbidx = iminor(inode);
 	info = registered_fb[fbidx];
 
diff -puN drivers/video/epson1355fb.c~struct-path-convert-video drivers/video/epson1355fb.c
--- a/drivers/video/epson1355fb.c~struct-path-convert-video
+++ a/drivers/video/epson1355fb.c
@@ -405,7 +405,7 @@ static inline unsigned long copy_to_user
 static ssize_t
 epson1355fb_read(struct file *file, char *buf, size_t count, loff_t * ppos)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	int fbidx = iminor(inode);
 	struct fb_info *info = registered_fb[fbidx];
 	unsigned long p = *ppos;
@@ -437,7 +437,7 @@ static ssize_t
 epson1355fb_write(struct file *file, const char *buf,
 		  size_t count, loff_t * ppos)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	int fbidx = iminor(inode);
 	struct fb_info *info = registered_fb[fbidx];
 	unsigned long p = *ppos;
diff -puN drivers/video/fbmem.c~struct-path-convert-video drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~struct-path-convert-video
+++ a/drivers/video/fbmem.c
@@ -572,7 +572,7 @@ static ssize_t
 fb_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 {
 	unsigned long p = *ppos;
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	int fbidx = iminor(inode);
 	struct fb_info *info = registered_fb[fbidx];
 	u32 *buffer, *dst;
@@ -647,7 +647,7 @@ static ssize_t
 fb_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 {
 	unsigned long p = *ppos;
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	int fbidx = iminor(inode);
 	struct fb_info *info = registered_fb[fbidx];
 	u32 *buffer, *src;
@@ -1081,7 +1081,7 @@ static int fb_get_fscreeninfo(struct ino
 static long
 fb_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	int fbidx = iminor(inode);
 	struct fb_info *info = registered_fb[fbidx];
 	struct fb_ops *fb = info->fbops;
@@ -1121,7 +1121,7 @@ fb_compat_ioctl(struct file *file, unsig
 static int 
 fb_mmap(struct file *file, struct vm_area_struct * vma)
 {
-	int fbidx = iminor(file->f_dentry->d_inode);
+	int fbidx = iminor(file->f_path.dentry->d_inode);
 	struct fb_info *info = registered_fb[fbidx];
 	struct fb_ops *fb = info->fbops;
 	unsigned long off;
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

struct-path-convert-video.patch
struct-path-convert-zorro.patch

