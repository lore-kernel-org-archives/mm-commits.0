From: akpm@linux-foundation.org
Subject: - pm3fb-switching-between-x-and-fb-fix.patch removed from -mm tree
Date: Fri, 01 Jun 2007 10:48:24 -0700
Message-ID: <200706011748.l51HmNTJ015202@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761570AbXFARs1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 13:48:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pm3fb: switching between X and fb fix
has been removed from the -mm tree.  Its filename was
     pm3fb-switching-between-x-and-fb-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pm3fb: switching between X and fb fix
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch correctly restores console state after switching from X. 
Otherwise, screen is always off after switching from X.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm3fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/pm3fb.c~pm3fb-switching-between-x-and-fb-fix drivers/video/pm3fb.c
--- a/drivers/video/pm3fb.c~pm3fb-switching-between-x-and-fb-fix
+++ a/drivers/video/pm3fb.c
@@ -498,7 +498,7 @@ static int pm3fb_set_par(struct fb_info 
 	else
 		par->video |= PM3VideoControl_LINE_DOUBLE_OFF;
 
-	if (info->var.activate == FB_ACTIVATE_NOW)
+	if ((info->var.activate & FB_ACTIVATE_MASK) == FB_ACTIVATE_NOW)
 		par->video |= PM3VideoControl_ENABLE;
 	else {
 		par->video |= PM3VideoControl_DISABLE;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
fbcon-smart-blitter-usage-for-scrolling.patch
pm2fb-white-spaces-clean-up.patch
