From: akpm@linux-foundation.org
Subject: - pm2fb-reset-transparency-settings.patch removed from -mm tree
Date: Tue, 08 May 2007 20:02:33 -0700
Message-ID: <200705090302.l4932XWS010848@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33358 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1033292AbXEIDCf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:02:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pm2fb: reset transparency settings
has been removed from the -mm tree.  Its filename was
     pm2fb-reset-transparency-settings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pm2fb: reset transparency settings
From: Krzysztof Helt < krzysztof.h1@wp.pl>

This patch resets transparency settings when depth changes.  Otherwise the 16
and 24-bit modes work incorrectly after switching from 32-bit mode.

Signed-off-by: Krzysztof Helt < krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm2fb.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/video/pm2fb.c~pm2fb-reset-transparency-settings drivers/video/pm2fb.c
--- a/drivers/video/pm2fb.c~pm2fb-reset-transparency-settings
+++ a/drivers/video/pm2fb.c
@@ -645,6 +645,8 @@ static int pm2fb_check_var(struct fb_var
 		return -EINVAL;
 	}
 
+	var->transp.offset = 0;
+	var->transp.length = 0;
 	switch(var->bits_per_pixel) {
 	case 8:
 		var->red.length = var->green.length = var->blue.length = 8;
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
vt8623fb-fix-compile-warnings.patch
vt8623fb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
arkfb-fix-compiler-warnings.patch
arkfb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch
svgalib-move-fb_get_caps-to-svgalib.patch
