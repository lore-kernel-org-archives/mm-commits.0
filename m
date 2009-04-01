From: akpm@linux-foundation.org
Subject: [merged] amifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:43:40 -0700
Message-ID: <200904011843.n31IhejX010138@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37032 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932269AbZDASrj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:47:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, dilinger@debian.org, geert@linux-m68k.org, krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     amifb: check fb_alloc_cmap return value and handle failure properly
has been removed from the -mm tree.  Its filename was
     amifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: amifb: check fb_alloc_cmap return value and handle failure properly
From: Andres Salomon <dilinger@queued.net>

Signed-off-by: Andres Salomon <dilinger@debian.org>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/amifb.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/video/amifb.c~amifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly drivers/video/amifb.c
--- a/drivers/video/amifb.c~amifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly
+++ a/drivers/video/amifb.c
@@ -2437,7 +2437,9 @@ default_chipset:
 		goto amifb_error;
 	}
 
-	fb_alloc_cmap(&fb_info.cmap, 1<<fb_info.var.bits_per_pixel, 0);
+	err = fb_alloc_cmap(&fb_info.cmap, 1<<fb_info.var.bits_per_pixel, 0);
+	if (err)
+		goto amifb_error;
 
 	if (register_framebuffer(&fb_info) < 0) {
 		err = -EINVAL;
@@ -2456,7 +2458,8 @@ amifb_error:
 
 static void amifb_deinit(void)
 {
-	fb_dealloc_cmap(&fb_info.cmap);
+	if (fb_info.cmap.len)
+		fb_dealloc_cmap(&fb_info.cmap);
 	chipfree();
 	if (videomemory)
 		iounmap((void*)videomemory);
_

Patches currently in -mm which might be from dilinger@queued.net are

origin.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch

