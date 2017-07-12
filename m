From: akpm@linux-foundation.org
Subject: [patch 94/96] video: fbdev: omap: move inline before
 return type
Date: Wed, 12 Jul 2017 14:37:46 -0700
Message-ID: <20170712213746.a5zakR04H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55338 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752363AbdGLVhr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:37:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, b.zolnierkie@samsung.com, joe@perches.com, mm-commits@vger.kernel.org, tomi.valkeinen@ti.com, torvalds@linux-foundation.org

From: Joe Perches <joe@perches.com>
Subject: video: fbdev: omap: move inline before return type

Make the code like the rest of the kernel.

Link: http://lkml.kernel.org/r/bc5927726abc70d7c066df7ab4cb7cfce4a7b577.1499284835.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbdev/omap/lcdc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/fbdev/omap/lcdc.c~video-fbdev-omap-move-inline-before-return-type drivers/video/fbdev/omap/lcdc.c
--- a/drivers/video/fbdev/omap/lcdc.c~video-fbdev-omap-move-inline-before-return-type
+++ a/drivers/video/fbdev/omap/lcdc.c
@@ -79,12 +79,12 @@ static struct omap_lcd_controller {
 	unsigned long		vram_size;
 } lcdc;
 
-static void inline enable_irqs(int mask)
+static inline void enable_irqs(int mask)
 {
 	lcdc.irq_mask |= mask;
 }
 
-static void inline disable_irqs(int mask)
+static inline void disable_irqs(int mask)
 {
 	lcdc.irq_mask &= ~mask;
 }
@@ -466,7 +466,7 @@ static void calc_ck_div(int is_tft, int
 	}
 }
 
-static void inline setup_regs(void)
+static inline void setup_regs(void)
 {
 	u32 l;
 	struct lcd_panel *panel = lcdc.fbdev->panel;
_
