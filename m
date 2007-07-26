From: akpm@linux-foundation.org
Subject: + xilinxfbremove-__initdata-from-xilinx_fb_fix-and-xilinx_fb_var.patch added to -mm tree
Date: Thu, 26 Jul 2007 12:00:07 -0700
Message-ID: <200707261900.l6QJ07ZJ015584@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34822 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759810AbXGZTAX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 15:00:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: grant.likely@secretlab.ca, adaplas@gmail.com, akonovalov@ru.mvista.com


The patch titled
     xilinxfb:Remove __initdata from xilinx_fb_fix and xilinx_fb_var
has been added to the -mm tree.  Its filename is
     xilinxfbremove-__initdata-from-xilinx_fb_fix-and-xilinx_fb_var.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: xilinxfb:Remove __initdata from xilinx_fb_fix and xilinx_fb_var
From: Grant Likely <grant.likely@secretlab.ca>

xilinxfb_drv_probe refers to both tables, but it cannot be initdata.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Andrei Konovalov <akonovalov@ru.mvista.com>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/xilinxfb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/xilinxfb.c~xilinxfbremove-__initdata-from-xilinx_fb_fix-and-xilinx_fb_var drivers/video/xilinxfb.c
--- a/drivers/video/xilinxfb.c~xilinxfbremove-__initdata-from-xilinx_fb_fix-and-xilinx_fb_var
+++ a/drivers/video/xilinxfb.c
@@ -79,7 +79,7 @@
 /*
  * Here are the default fb_fix_screeninfo and fb_var_screeninfo structures
  */
-static struct fb_fix_screeninfo xilinx_fb_fix __initdata = {
+static struct fb_fix_screeninfo xilinx_fb_fix = {
 	.id =		"Xilinx",
 	.type =		FB_TYPE_PACKED_PIXELS,
 	.visual =	FB_VISUAL_TRUECOLOR,
@@ -88,7 +88,7 @@ static struct fb_fix_screeninfo xilinx_f
 	.accel =	FB_ACCEL_NONE
 };
 
-static struct fb_var_screeninfo xilinx_fb_var __initdata = {
+static struct fb_var_screeninfo xilinx_fb_var = {
 	.xres =			XRES,
 	.yres =			YRES,
 	.xres_virtual =		XRES_VIRTUAL,
_

Patches currently in -mm which might be from grant.likely@secretlab.ca are

xilinxfbremove-__initdata-from-xilinx_fb_fix-and-xilinx_fb_var.patch
xilinxfb-dont-bail-if-the-xilinxfb-platform-device-doesnt-have-any-pdata.patch
