From: akpm@linux-foundation.org
Subject: + pm3fb-switching-between-x-and-fb-fix.patch added to -mm tree
Date: Thu, 31 May 2007 15:24:18 -0700
Message-ID: <200705312224.l4VMOI1s029470@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60066 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751182AbXEaWYV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2007 18:24:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     pm3fb: switching between X and fb fix
has been added to the -mm tree.  Its filename is
     pm3fb-switching-between-x-and-fb-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+), 1 deletion(-)

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
skeletonfb-fix-of-xxxfb_setup-ifdef.patch
fbcon-smart-blitter-usage-for-scrolling.patch
pm3fb-switching-between-x-and-fb-fix.patch
pm2fb-white-spaces-clean-up.patch
