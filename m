From: akpm@linux-foundation.org
Subject: [merged] fb-fix-fb_pan_display-range-check.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:02:49 -0700
Message-ID: <200909232002.n8NK2nGP017962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46343 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752421AbZIWUKF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:10:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: FlorianSchandinat@gmx.de, b18973@freescale.com, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     fb: fix fb_pan_display range check
has been removed from the -mm tree.  Its filename was
     fb-fix-fb_pan_display-range-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fb: fix fb_pan_display range check
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Fix the range check for panning.  The current code fails to detect some
invalid values (very high ones that can occur if an app tries to move
further up/left than 0,0) as the check uses the unknown values for
calculation so that an overflow can occur.

To fix this it is sufficient to move the calculation to the right side to
use only trusted values.

Kai Jiang detected this problem and proposed an initial patch.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Kai Jiang <b18973@freescale.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/fbmem.c~fb-fix-fb_pan_display-range-check drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fb-fix-fb_pan_display-range-check
+++ a/drivers/video/fbmem.c
@@ -871,8 +871,8 @@ fb_pan_display(struct fb_info *info, str
 		err = -EINVAL;
 
 	if (err || !info->fbops->fb_pan_display ||
-	    var->yoffset + yres > info->var.yres_virtual ||
-	    var->xoffset + info->var.xres > info->var.xres_virtual)
+	    var->yoffset > info->var.yres_virtual - yres ||
+	    var->xoffset > info->var.xres_virtual - info->var.xres)
 		return -EINVAL;
 
 	if ((err = info->fbops->fb_pan_display(var, info)))
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

origin.patch

