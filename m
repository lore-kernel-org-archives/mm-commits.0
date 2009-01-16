From: akpm@linux-foundation.org
Subject: [merged] video-framebuffer-fix-bug-jpegview-cannot-work-on-framebuffer-device-other-than-16bpp.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:16:21 -0800
Message-ID: <200901161916.n0GJGLuu024810@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49290 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935345AbZAPTQv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:16:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.hennerich@analog.com, cooloney@kernel.org, vapier.adi@gmail.com, mm-commits@vger.kernel.org


The patch titled
     video/framebuffer: fix bug: jpegview cannot work on framebuffer device other than 16BPP
has been removed from the -mm tree.  Its filename was
     video-framebuffer-fix-bug-jpegview-cannot-work-on-framebuffer-device-other-than-16bpp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: video/framebuffer: fix bug: jpegview cannot work on framebuffer device other than 16BPP
From: Michael Hennerich <michael.hennerich@analog.com>

Force fb_var_screeninfo color format on all Blackfin Framebuffer Drivers.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/bf54x-lq043fb.c    |   15 ++++++++++++++-
 drivers/video/bfin-t350mcqb-fb.c |   15 ++++++++++++++-
 2 files changed, 28 insertions(+), 2 deletions(-)

diff -puN drivers/video/bf54x-lq043fb.c~video-framebuffer-fix-bug-jpegview-cannot-work-on-framebuffer-device-other-than-16bpp drivers/video/bf54x-lq043fb.c
--- a/drivers/video/bf54x-lq043fb.c~video-framebuffer-fix-bug-jpegview-cannot-work-on-framebuffer-device-other-than-16bpp
+++ a/drivers/video/bf54x-lq043fb.c
@@ -335,7 +335,20 @@ static int bfin_bf54x_fb_check_var(struc
 				   struct fb_info *info)
 {
 
-	if (var->bits_per_pixel != LCD_BPP) {
+	switch (var->bits_per_pixel) {
+	case 24:/* TRUECOLOUR, 16m */
+		var->red.offset = 16;
+		var->green.offset = 8;
+		var->blue.offset = 0;
+		var->red.length = var->green.length = var->blue.length = 8;
+		var->transp.offset = 0;
+		var->transp.length = 0;
+		var->transp.msb_right = 0;
+		var->red.msb_right = 0;
+		var->green.msb_right = 0;
+		var->blue.msb_right = 0;
+		break;
+	default:
 		pr_debug("%s: depth not supported: %u BPP\n", __func__,
 			 var->bits_per_pixel);
 		return -EINVAL;
diff -puN drivers/video/bfin-t350mcqb-fb.c~video-framebuffer-fix-bug-jpegview-cannot-work-on-framebuffer-device-other-than-16bpp drivers/video/bfin-t350mcqb-fb.c
--- a/drivers/video/bfin-t350mcqb-fb.c~video-framebuffer-fix-bug-jpegview-cannot-work-on-framebuffer-device-other-than-16bpp
+++ a/drivers/video/bfin-t350mcqb-fb.c
@@ -254,7 +254,20 @@ static int bfin_t350mcqb_fb_check_var(st
 				   struct fb_info *info)
 {
 
-	if (var->bits_per_pixel != LCD_BPP) {
+	switch (var->bits_per_pixel) {
+	case 24:/* TRUECOLOUR, 16m */
+		var->red.offset = 0;
+		var->green.offset = 8;
+		var->blue.offset = 16;
+		var->red.length = var->green.length = var->blue.length = 8;
+		var->transp.offset = 0;
+		var->transp.length = 0;
+		var->transp.msb_right = 0;
+		var->red.msb_right = 0;
+		var->green.msb_right = 0;
+		var->blue.msb_right = 0;
+		break;
+	default:
 		pr_debug("%s: depth not supported: %u BPP\n", __func__,
 			 var->bits_per_pixel);
 		return -EINVAL;
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

origin.patch
input-touchscreen-driver-add-support-ad7877-touchscreen-driver.patch
input-ad7879-touchscreen-driver.patch

