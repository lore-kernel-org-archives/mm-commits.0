From: akpm@linux-foundation.org
Subject: - tgafb-actually-allocate-memory-for-the-pseudo_palette.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:07:34 -0700
Message-ID: <200707172307.l6HN7YF7012201@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48113 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935876AbXGQXPZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, macro@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     tgafb: actually allocate memory for the pseudo_palette
has been removed from the -mm tree.  Its filename was
     tgafb-actually-allocate-memory-for-the-pseudo_palette.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tgafb: actually allocate memory for the pseudo_palette
From: "Antonino A. Daplas" <adaplas@gmail.com>

No memory allocation was done for the pseudo_palette.  Allocate one for it.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Acked-by: "Maciej W. Rozycki" <macro@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tgafb.c |    2 +-
 include/video/tgafb.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/tgafb.c~tgafb-actually-allocate-memory-for-the-pseudo_palette drivers/video/tgafb.c
--- a/drivers/video/tgafb.c~tgafb-actually-allocate-memory-for-the-pseudo_palette
+++ a/drivers/video/tgafb.c
@@ -1634,7 +1634,7 @@ tgafb_register(struct device *dev)
 		      FBINFO_HWACCEL_IMAGEBLIT | FBINFO_HWACCEL_FILLRECT;
 	info->fbops = &tgafb_ops;
 	info->screen_base = par->tga_fb_base;
-	info->pseudo_palette = (void *)(par + 1);
+	info->pseudo_palette = par->palette;
 
 	/* This should give a reasonable default video mode.  */
 	if (tga_bus_pci) {
diff -puN include/video/tgafb.h~tgafb-actually-allocate-memory-for-the-pseudo_palette include/video/tgafb.h
--- a/include/video/tgafb.h~tgafb-actually-allocate-memory-for-the-pseudo_palette
+++ a/include/video/tgafb.h
@@ -216,6 +216,7 @@ struct tga_par {
 	u32 pll_freq;			/* pixclock in mhz */
 	u32 bits_per_pixel;		/* bits per pixel */
 	u32 sync_on_green;		/* set if sync is on green */
+	u32 palette[16];
 };
 
 
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
