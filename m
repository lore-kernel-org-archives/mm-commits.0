From: akpm@linux-foundation.org
Subject: [merged] drivers-video-msm-update-to-new-kernel.patch removed from -mm tree
Date: Fri, 13 Nov 2009 11:27:23 -0800
Message-ID: <200911131927.nADJRNsP030490@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757227AbZKMT1V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 14:27:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     drivers/video/msm: update to new kernel
has been removed from the -mm tree.  Its filename was
     drivers-video-msm-update-to-new-kernel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/msm: update to new kernel
From: Pavel Machek <pavel@ucw.cz>

TASK_INTERRUPTIBLE and friends are now only available after including
<linux/sched.h>, so include it when needed.

bus_id is no longer available/necessary, so remove that.

Android pmem driver is not available in mainline, so remove its hooks
from drivers/video.

Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/video/msm/mddi.c~drivers-video-msm-update-to-new-kernel drivers/video/msm/mddi.c
--- a/drivers/video/msm/mddi.c~drivers-video-msm-update-to-new-kernel
+++ a/drivers/video/msm/mddi.c
@@ -24,6 +24,7 @@
 #include <linux/spinlock.h>
 #include <linux/clk.h>
 #include <linux/io.h>
+#include <linux/sched.h>
 #include <mach/msm_iomap.h>
 #include <mach/irqs.h>
 #include <mach/board.h>
diff -puN drivers/video/msm/mddi_client_nt35399.c~drivers-video-msm-update-to-new-kernel drivers/video/msm/mddi_client_nt35399.c
--- a/drivers/video/msm/mddi_client_nt35399.c~drivers-video-msm-update-to-new-kernel
+++ a/drivers/video/msm/mddi_client_nt35399.c
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
+#include <linux/sched.h>
 #include <linux/gpio.h>
 #include <mach/msm_fb.h>
 
diff -puN drivers/video/msm/mddi_client_toshiba.c~drivers-video-msm-update-to-new-kernel drivers/video/msm/mddi_client_toshiba.c
--- a/drivers/video/msm/mddi_client_toshiba.c~drivers-video-msm-update-to-new-kernel
+++ a/drivers/video/msm/mddi_client_toshiba.c
@@ -20,6 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/gpio.h>
+#include <linux/sched.h>
 #include <mach/msm_fb.h>
 
 
diff -puN drivers/video/msm/mdp.c~drivers-video-msm-update-to-new-kernel drivers/video/msm/mdp.c
--- a/drivers/video/msm/mdp.c~drivers-video-msm-update-to-new-kernel
+++ a/drivers/video/msm/mdp.c
@@ -22,9 +22,6 @@
 #include <linux/wait.h>
 #include <linux/clk.h>
 #include <linux/file.h>
-#ifdef CONFIG_ANDROID_PMEM
-#include <linux/android_pmem.h>
-#endif
 #include <linux/major.h>
 
 #include <mach/msm_iomap.h>
@@ -262,11 +259,6 @@ int get_img(struct mdp_img *img, struct 
 	struct file *file;
 	unsigned long vstart;
 
-#ifdef CONFIG_ANDROID_PMEM
-	if (!get_pmem_file(img->memory_id, start, &vstart, len, filep))
-		return 0;
-#endif
-
 	file = fget_light(img->memory_id, &put_needed);
 	if (file == NULL)
 		return -1;
@@ -283,12 +275,6 @@ int get_img(struct mdp_img *img, struct 
 
 void put_img(struct file *src_file, struct file *dst_file)
 {
-#ifdef CONFIG_ANDROID_PMEM
-	if (src_file)
-		put_pmem_file(src_file);
-	if (dst_file)
-		put_pmem_file(dst_file);
-#endif
 }
 
 int mdp_blit(struct mdp_device *mdp_dev, struct fb_info *fb,
@@ -320,9 +306,6 @@ int mdp_blit(struct mdp_device *mdp_dev,
 	if (unlikely(get_img(&req->dst, fb, &dst_start, &dst_len, &dst_file))) {
 		printk(KERN_ERR "mpd_ppp: could not retrieve dst image from "
 				"memory\n");
-#ifdef CONFIG_ANDROID_PMEM
-		put_pmem_file(src_file);
-#endif
 		return -EINVAL;
 	}
 	mutex_lock(&mdp_mutex);
@@ -499,7 +482,6 @@ int mdp_probe(struct platform_device *pd
 	/* register mdp device */
 	mdp->mdp_dev.dev.parent = &pdev->dev;
 	mdp->mdp_dev.dev.class = mdp_class;
-	snprintf(mdp->mdp_dev.dev.bus_id, BUS_ID_SIZE, "mdp%d", pdev->id);
 
 	/* if you can remove the platform device you'd have to implement
 	 * this:
diff -puN drivers/video/msm/mdp_ppp.c~drivers-video-msm-update-to-new-kernel drivers/video/msm/mdp_ppp.c
--- a/drivers/video/msm/mdp_ppp.c~drivers-video-msm-update-to-new-kernel
+++ a/drivers/video/msm/mdp_ppp.c
@@ -16,7 +16,6 @@
 #include <linux/file.h>
 #include <linux/delay.h>
 #include <linux/msm_mdp.h>
-#include <linux/android_pmem.h>
 #include <mach/msm_fb.h>
 
 #include "mdp_hw.h"
@@ -579,25 +578,6 @@ static int valid_src_dst(unsigned long s
 static void flush_imgs(struct mdp_blit_req *req, struct mdp_regs *regs,
 		       struct file *src_file, struct file *dst_file)
 {
-#ifdef CONFIG_ANDROID_PMEM
-	uint32_t src0_len, src1_len, dst0_len, dst1_len;
-
-	/* flush src images to memory before dma to mdp */
-	get_len(&req->src, &req->src_rect, regs->src_bpp, &src0_len,
-		&src1_len);
-	flush_pmem_file(src_file, req->src.offset, src0_len);
-	if (IS_PSEUDOPLNR(req->src.format))
-		flush_pmem_file(src_file, req->src.offset + src0_len,
-				src1_len);
-
-	/* flush dst images */
-	get_len(&req->dst, &req->dst_rect, regs->dst_bpp, &dst0_len,
-		&dst1_len);
-	flush_pmem_file(dst_file, req->dst.offset, dst0_len);
-	if (IS_PSEUDOPLNR(req->dst.format))
-		flush_pmem_file(dst_file, req->dst.offset + dst0_len,
-				dst1_len);
-#endif
 }
 
 static void get_chroma_addr(struct mdp_img *img, struct mdp_rect *rect,
_

Patches currently in -mm which might be from pavel@ucw.cz are

linux-next.patch
serial_cs-oxsemi-quirk-breaks-resume.patch
scripts-get_maintainerpl-add-roles-and-rolestats.patch
scripts-get_maintainerpl-fix-non-with-git-blame-and-cleanups.patch
msm_sdccc-add-missing-include-fix-compilation.patch
msm_sdccc-add-missing-include-fix-compilation-checkpatch-fixes.patch
lis3lv02d-axis-remap-and-resource-setup-release.patch
lis3lv02d-i2c-support.patch
vt-make-the-default-cursor-shape-configurable.patch
fatfs-use-common-time_to_tm-in-fat_time_unix2fat.patch

