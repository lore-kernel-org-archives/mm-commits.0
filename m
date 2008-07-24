From: akpm@linux-foundation.org
Subject: - tdfxfb-remove-ypan-checks-done-by-a-higher-layer.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:32:13 -0700
Message-ID: <200807242332.m6ONWD7P011811@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756196AbYGXXcP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:32:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     tdfxfb: remove ypan checks done by a higher layer
has been removed from the -mm tree.  Its filename was
     tdfxfb-remove-ypan-checks-done-by-a-higher-layer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tdfxfb: remove ypan checks done by a higher layer
From: Krzysztof Helt <krzysztof.h1@wp.pl>

These checks and assignments are done by a higher layer so remove them
from the driver.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tdfxfb.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/video/tdfxfb.c~tdfxfb-remove-ypan-checks-done-by-a-higher-layer drivers/video/tdfxfb.c
--- a/drivers/video/tdfxfb.c~tdfxfb-remove-ypan-checks-done-by-a-higher-layer
+++ a/drivers/video/tdfxfb.c
@@ -836,16 +836,12 @@ static int tdfxfb_pan_display(struct fb_
 	struct tdfx_par *par = info->par;
 	u32 addr = var->yoffset * info->fix.line_length;
 
-	if (nopan || var->xoffset || (var->yoffset > var->yres_virtual))
-		return -EINVAL;
-	if ((var->yoffset + var->yres > var->yres_virtual && nowrap))
+	if (nopan || var->xoffset)
 		return -EINVAL;
 
 	banshee_make_room(par, 1);
 	tdfx_outl(par, VIDDESKSTART, addr);
 
-	info->var.xoffset = var->xoffset;
-	info->var.yoffset = var->yoffset;
 	return 0;
 }
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch

