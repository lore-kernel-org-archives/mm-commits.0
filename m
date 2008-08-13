From: akpm@linux-foundation.org
Subject: - atmel_lcdfb-set-ypanstep-to-1-and-enable-y-panning-on-at91.patch removed from -mm tree
Date: Wed, 13 Aug 2008 01:52:55 -0700
Message-ID: <200808130852.m7D8qtkM008266@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752570AbYHMJF2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 05:05:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haavard.skinnemoen@atmel.com, hskinnemoen@atmel.com, krzysztof.h1@wp.pl, nicolas.ferre@atmel.com, mm-commits@vger.kernel.org


The patch titled
     atmel_lcdfb: set ypanstep to 1 and enable y-panning on AT91
has been removed from the -mm tree.  Its filename was
     atmel_lcdfb-set-ypanstep-to-1-and-enable-y-panning-on-at91.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_lcdfb: set ypanstep to 1 and enable y-panning on AT91
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

Panning in the y-direction can be done by simply changing the DMA base
address.  This code is already in place, but FBIOPAN_DISPLAY will
currently fail because ypanstep is 0.

Set ypanstep to 1 to indicate that we do support y-panning and also set
the necessary acceleration flags on AT91 (AVR32 already have them.)

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/atmel_lcdfb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/video/atmel_lcdfb.c~atmel_lcdfb-set-ypanstep-to-1-and-enable-y-panning-on-at91 drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c~atmel_lcdfb-set-ypanstep-to-1-and-enable-y-panning-on-at91
+++ a/drivers/video/atmel_lcdfb.c
@@ -39,7 +39,9 @@
 #endif
 
 #if defined(CONFIG_ARCH_AT91)
-#define	ATMEL_LCDFB_FBINFO_DEFAULT	FBINFO_DEFAULT
+#define	ATMEL_LCDFB_FBINFO_DEFAULT	(FBINFO_DEFAULT \
+					 | FBINFO_PARTIAL_PAN_OK \
+					 | FBINFO_HWACCEL_YPAN)
 
 static inline void atmel_lcdfb_update_dma2d(struct atmel_lcdfb_info *sinfo,
 					struct fb_var_screeninfo *var)
@@ -177,7 +179,7 @@ static struct fb_fix_screeninfo atmel_lc
 	.type		= FB_TYPE_PACKED_PIXELS,
 	.visual		= FB_VISUAL_TRUECOLOR,
 	.xpanstep	= 0,
-	.ypanstep	= 0,
+	.ypanstep	= 1,
 	.ywrapstep	= 0,
 	.accel		= FB_ACCEL_NONE,
 };
_

Patches currently in -mm which might be from haavard.skinnemoen@atmel.com are

linux-next.patch

