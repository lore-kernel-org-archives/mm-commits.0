From: akpm@linux-foundation.org
Subject: - fbdev-hecubafb-bugfix-v4.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:59:24 -0700
Message-ID: <200804282159.m3SLxO1e018586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965468AbYD1V7f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:59:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jayakumar.lkml@gmail.com, adaplas@pol.net, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     fbdev: hecubafb bugfix
has been removed from the -mm tree.  Its filename was
     fbdev-hecubafb-bugfix-v4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: hecubafb bugfix
From: Jaya Kumar <jayakumar.lkml@gmail.com>

This patch is a bugfix for hecubafb_write which would return an incorrect
error value for the bytecount from framebuffer writes.

Signed-off-by: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/hecubafb.c |   52 +++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 25 deletions(-)

diff -puN drivers/video/hecubafb.c~fbdev-hecubafb-bugfix-v4 drivers/video/hecubafb.c
--- a/drivers/video/hecubafb.c~fbdev-hecubafb-bugfix-v4
+++ a/drivers/video/hecubafb.c
@@ -270,41 +270,43 @@ static void hecubafb_imageblit(struct fb
 static ssize_t hecubafb_write(struct fb_info *info, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
-	unsigned long p;
-	int err=-EINVAL;
-	struct hecubafb_par *par;
-	unsigned int xres;
-	unsigned int fbmemlength;
+	struct hecubafb_par *par = info->par;
+	unsigned long p = *ppos;
+	void *dst;
+	int err = 0;
+	unsigned long total_size;
 
-	p = *ppos;
-	par = info->par;
-	xres = info->var.xres;
-	fbmemlength = (xres * info->var.yres)/8;
+	if (info->state != FBINFO_STATE_RUNNING)
+		return -EPERM;
+
+	total_size = info->fix.smem_len;
 
-	if (p > fbmemlength)
-		return -ENOSPC;
+	if (p > total_size)
+		return -EFBIG;
 
-	err = 0;
-	if ((count + p) > fbmemlength) {
-		count = fbmemlength - p;
-		err = -ENOSPC;
+	if (count > total_size) {
+		err = -EFBIG;
+		count = total_size;
 	}
 
-	if (count) {
-		char *base_addr;
+	if (count + p > total_size) {
+		if (!err)
+			err = -ENOSPC;
 
-		base_addr = (char __force *)info->screen_base;
-		count -= copy_from_user(base_addr + p, buf, count);
-		*ppos += count;
-		err = -EFAULT;
+		count = total_size - p;
 	}
 
-	hecubafb_dpy_update(par);
+	dst = (void __force *) (info->screen_base + p);
 
-	if (count)
-		return count;
+	if (copy_from_user(dst, buf, count))
+		err = -EFAULT;
+
+	if  (!err)
+		*ppos += count;
+
+	hecubafb_dpy_update(par);
 
-	return err;
+	return (err) ? err : count;
 }
 
 static struct fb_ops hecubafb_ops = {
_

Patches currently in -mm which might be from jayakumar.lkml@gmail.com are

origin.patch
git-arm.patch

