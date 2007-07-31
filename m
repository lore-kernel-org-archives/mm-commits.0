From: akpm@linux-foundation.org
Subject: - xilinxfbremove-__initdata-from-xilinx_fb_fix-and-xilinx_fb_var.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:55:05 -0700
Message-ID: <200707312355.l6VNt58m029203@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53043 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762471AbXHAARQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:17:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: grant.likely@secretlab.ca, adaplas@gmail.com, akonovalov@ru.mvista.com, mm-commits@vger.kernel.org


The patch titled
     xilinxfb:Remove __initdata from xilinx_fb_fix and xilinx_fb_var
has been removed from the -mm tree.  Its filename was
     xilinxfbremove-__initdata-from-xilinx_fb_fix-and-xilinx_fb_var.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
