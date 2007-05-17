From: akpm@linux-foundation.org
Subject: + nvidiafb-adjust-flags-to-take-advantage-of-new-scroll-method.patch added to -mm tree
Date: Thu, 17 May 2007 12:00:40 -0700
Message-ID: <200705171900.l4HJ0eJZ030616@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41780 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753931AbXEQTBy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 15:01:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     nvidiafb: adjust flags to take advantage of new scroll method
has been added to the -mm tree.  Its filename is
     nvidiafb-adjust-flags-to-take-advantage-of-new-scroll-method.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: nvidiafb: adjust flags to take advantage of new scroll method
From: "Antonino A. Daplas" <adaplas@gmail.com>

The SCROLL_MOVE method has been optimized such that it is significantly faster
than SCROLL_REDRAW.  Adjust flags to indicate that blitting is preferred over
rendering.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/nvidia/nvidia.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/video/nvidia/nvidia.c~nvidiafb-adjust-flags-to-take-advantage-of-new-scroll-method drivers/video/nvidia/nvidia.c
--- a/drivers/video/nvidia/nvidia.c~nvidiafb-adjust-flags-to-take-advantage-of-new-scroll-method
+++ a/drivers/video/nvidia/nvidia.c
@@ -674,6 +674,7 @@ static int nvidiafb_set_par(struct fb_in
 		info->fbops->fb_sync = nvidiafb_sync;
 		info->pixmap.scan_align = 4;
 		info->flags &= ~FBINFO_HWACCEL_DISABLED;
+		info->flags |= FBINFO_READS_FAST;
 		NVResetGraphics(info);
 	} else {
 		info->fbops->fb_imageblit = cfb_imageblit;
@@ -682,6 +683,7 @@ static int nvidiafb_set_par(struct fb_in
 		info->fbops->fb_sync = NULL;
 		info->pixmap.scan_align = 1;
 		info->flags |= FBINFO_HWACCEL_DISABLED;
+		info->flags &= ~FBINFO_READS_FAST;
 	}
 
 	par->cursor_reset = 1;
_

Patches currently in -mm which might be from adaplas@gmail.com are

fbdev-cleanup-of-sparc-fb-options.patch
pm2fb-rdac_wr-barriers-clean-up.patch
pm3fb-various-fixes.patch
w100fb-fix-compile-warnings.patch
ps3fb-use-fb_sys_-instead-of-fb_cfb_.patch
imxfb-remove-ifdefs.patch
imxfb-fix-memory-hole.patch
fbcon-smart-blitter-usage-for-scrolling.patch
nvidiafb-adjust-flags-to-take-advantage-of-new-scroll-method.patch
