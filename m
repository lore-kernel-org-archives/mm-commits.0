From: akpm@linux-foundation.org
Subject: + pvr2fb-fix-oops-when-pseudo_palette-is-written.patch added to -mm tree
Date: Wed, 01 Aug 2007 15:40:40 -0700
Message-ID: <200708012240.l71MeeJp021129@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52867 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753620AbXHAWlQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2007 18:41:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com, adrianmcmenamin@gmail.com


The patch titled
     pvr2fb: Fix oops when pseudo_palette is written
has been added to the -mm tree.  Its filename is
     pvr2fb-fix-oops-when-pseudo_palette-is-written.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pvr2fb: Fix oops when pseudo_palette is written
From: "Antonino A. Daplas" <adaplas@gmail.com>

Reported by: Adrian McMenamin <adrianmcmenamin@gmail.com>

This driver will oops when the pseudo_palette[] is written as u32 but not when
written as u16.  When written as u32, it corrupts the adjacent 'mmio_base'
field of struct pvr2fb_par.  Fix by using framebuffer_alloc()/release() to
allocate struct fb_info and struct pvr2fb_par, and create the pseudo_palette[]
as part of struct pvr2fb_par.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pvr2fb.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/video/pvr2fb.c~pvr2fb-fix-oops-when-pseudo_palette-is-written drivers/video/pvr2fb.c
--- a/drivers/video/pvr2fb.c~pvr2fb-fix-oops-when-pseudo_palette-is-written
+++ a/drivers/video/pvr2fb.c
@@ -143,6 +143,7 @@ static struct pvr2fb_par {
 	unsigned char is_lowres;	/* Is horizontal pixel-doubling enabled? */
 
 	unsigned long mmio_base;	/* MMIO base */
+	u32 palette[16];
 } *currentpar;
 
 static struct fb_info *fb_info;
@@ -790,7 +791,7 @@ static int __devinit pvr2fb_common_init(
 	fb_info->fbops		= &pvr2fb_ops;
 	fb_info->fix		= pvr2_fix;
 	fb_info->par		= currentpar;
-	fb_info->pseudo_palette	= (void *)(fb_info->par + 1);
+	fb_info->pseudo_palette	= currentpar->palette;
 	fb_info->flags		= FBINFO_DEFAULT | FBINFO_HWACCEL_YPAN;
 
 	if (video_output == VO_VGA)
@@ -1082,14 +1083,15 @@ static int __init pvr2fb_init(void)
 #endif
 	size = sizeof(struct fb_info) + sizeof(struct pvr2fb_par) + 16 * sizeof(u32);
 
-	fb_info = kzalloc(size, GFP_KERNEL);
+	fb_info = framebuffer_alloc(sizeof(struct pvr2fb_par), NULL);
+
 	if (!fb_info) {
 		printk(KERN_ERR "Failed to allocate memory for fb_info\n");
 		return -ENOMEM;
 	}
 
 
-	currentpar = (struct pvr2fb_par *)(fb_info + 1);
+	currentpar = fb_info->par;
 
 	for (i = 0; i < ARRAY_SIZE(board_driver); i++) {
 		struct pvr2_board *pvr_board = board_driver + i;
@@ -1102,7 +1104,7 @@ static int __init pvr2fb_init(void)
 		if (ret != 0) {
 			printk(KERN_ERR "pvr2fb: Failed init of %s device\n",
 				pvr_board->name);
-			kfree(fb_info);
+			framebuffer_release(fb_info);
 			break;
 		}
 	}
@@ -1126,7 +1128,7 @@ static void __exit pvr2fb_exit(void)
 #endif
 
 	unregister_framebuffer(fb_info);
-	kfree(fb_info);
+	framebuffer_release(fb_info);
 }
 
 module_init(pvr2fb_init);
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
stifb-detect-cards-in-double-buffer-mode-more-reliably.patch
fbcon-kill-compile-warning.patch
pvr2fb-fix-oops-when-pseudo_palette-is-written.patch
pvr2fb-consolidated-cleanup-of-pvr2fbc.patch
pvr2fb-update-documentation-fb-pvr2fbtxt.patch
matroxfb-rectify-jitter-g450-g550.patch
fbdev-export-fb_destroy_modelist.patch
connector-change-connectors-max-message-size.patch
uvesafb-add-connector-entries.patch
uvesafb-the-driver-core.patch
uvesafb-documentation.patch
pm3fb-copyarea-and-partial-imageblit-suppor.patch
skeletonfb-wrong-field-name-fix.patch
pm3fb-header-file-reduction.patch
pm3fb-imageblit-improved.patch
pm3fb-3-small-fixes.patch
pm3fb-improvements-and-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option.patch
pm2fb-accelerated-imageblit.patch
pm2fb-source-code-improvements.patch
pm2fb-permedia-2v-initialization-fixes.patch
pm2fb-accelerated-24-bit-fillrect.patch
sm501fb-update-suspend-and-resume-code.patch
sm501fb-call-fb-suspend-function-during-suspend-and-resume.patch
sm501fb-ensure-panel-interface-is-not-tristated-when-setup.patch
mbxfb-improvements-and-new-features.patch
pxafb-add-support-for-other-palette-formats.patch
tridentfb-coding-style-improvement.patch
tdfxfb-coding-style-improvement.patch
tdfxfb-3-fixes.patch
tdfxfb-palette-fixes.patch
fbdev-fix-incorrect-timings-in-some-modedb-entries.patch
tdfxfb-code-improvements.patch
tdfxfb-hardware-cursor.patch
tdfxfb-mtrr-support.patch
pm2fb-checkpatch-fixes.patch
pm3fb-checkpatch-fixes.patch
