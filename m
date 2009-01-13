From: akpm@linux-foundation.org
Subject: + video-framebuffer-fix-bug-jpegview-cannot-work-on-framebuffer-device-other-than-16bpp.patch added to -mm tree
Date: Mon, 12 Jan 2009 19:51:49 -0800
Message-ID: <200901130351.n0D3pnsQ014127@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47524 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754140AbZAMDwA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 22:52:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.hennerich@analog.com, cooloney@kernel.org, vapier.adi@gmail.com


The patch titled
     video/framebuffer: fix bug: jpegview cannot work on framebuffer device other than 16BPP
has been added to the -mm tree.  Its filename is
     video-framebuffer-fix-bug-jpegview-cannot-work-on-framebuffer-device-other-than-16bpp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

input-touchscreen-driver-add-support-ad7877-touchscreen-driver.patch
input-ad7879-touchscreen-driver.patch
video-framebuffer-fix-bug-jpegview-cannot-work-on-framebuffer-device-other-than-16bpp.patch

