From: akpm@linux-foundation.org
Subject: - epson1355fb-color-setting-fixes.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:07:16 -0700
Message-ID: <200707172307.l6HN7G9n012166@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45195 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758826AbXGQXPJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     epson1355fb: color setting fixes
has been removed from the -mm tree.  Its filename was
     epson1355fb-color-setting-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: epson1355fb: color setting fixes
From: "Antonino A. Daplas" <adaplas@gmail.com>

- the pseudo_palette is only 16 elements long
- allocate the pseudo_palette as part of epson1355_par

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/epson1355fb.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/video/epson1355fb.c~epson1355fb-color-setting-fixes drivers/video/epson1355fb.c
--- a/drivers/video/epson1355fb.c~epson1355fb-color-setting-fixes
+++ a/drivers/video/epson1355fb.c
@@ -63,6 +63,7 @@
 
 struct epson1355_par {
 	unsigned long reg_addr;
+	u32 pseudo_palette[16];
 };
 
 /* ------------------------------------------------------------------------- */
@@ -635,7 +636,7 @@ int __init epson1355fb_probe(struct plat
 		goto bail;
 	}
 
-	info = framebuffer_alloc(sizeof(struct epson1355_par) + sizeof(u32) * 256, &dev->dev);
+	info = framebuffer_alloc(sizeof(struct epson1355_par), &dev->dev);
 	if (!info) {
 		rc = -ENOMEM;
 		goto bail;
@@ -648,7 +649,7 @@ int __init epson1355fb_probe(struct plat
 		rc = -ENOMEM;
 		goto bail;
 	}
-	info->pseudo_palette = (void *)(default_par + 1);
+	info->pseudo_palette = default_par->pseudo_palette;
 
 	info->screen_base = ioremap(EPSON1355FB_FB_PHYS, EPSON1355FB_FB_LEN);
 	if (!info->screen_base) {
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
