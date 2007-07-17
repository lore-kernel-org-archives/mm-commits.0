From: akpm@linux-foundation.org
Subject: - nvidiafb-adjust-flags-to-take-advantage-of-new-scroll-method.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:06:43 -0700
Message-ID: <200707172306.l6HN6h7Y012044@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33991 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936874AbXGQXUJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:20:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     nvidiafb: adjust flags to take advantage of new scroll method
has been removed from the -mm tree.  Its filename was
     nvidiafb-adjust-flags-to-take-advantage-of-new-scroll-method.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 2 insertions(+)

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

origin.patch
