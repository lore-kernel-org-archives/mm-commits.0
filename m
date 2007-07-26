From: akpm@linux-foundation.org
Subject: + pm2fb-accelerated-24-bit-fillrect.patch added to -mm tree
Date: Thu, 26 Jul 2007 12:00:40 -0700
Message-ID: <200707261900.l6QJ0enM015652@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48783 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761429AbXGZTM2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 15:12:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     pm2fb: accelerated 24-bit fillrect
has been added to the -mm tree.  Its filename is
     pm2fb-accelerated-24-bit-fillrect.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pm2fb: accelerated 24-bit fillrect
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch adds accelerated fillrect for 24-bit depth.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm2fb.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/video/pm2fb.c~pm2fb-accelerated-24-bit-fillrect drivers/video/pm2fb.c
--- a/drivers/video/pm2fb.c~pm2fb-accelerated-24-bit-fillrect
+++ a/drivers/video/pm2fb.c
@@ -1077,7 +1077,13 @@ static void pm2fb_fillrect (struct fb_in
 		pm2_WR(par, PM2R_RENDER,
 				PM2F_RENDER_RECTANGLE | PM2F_RENDER_FASTFILL);
 	} else {
-		cfb_fillrect(info, region);
+		WAIT_FIFO(par, 4);
+		pm2_WR(par, PM2R_COLOR_DDA_MODE, 1);
+		pm2_WR(par, PM2R_CONSTANT_COLOR, color);
+		wmb();
+		pm2_WR(par, PM2R_RENDER,
+				PM2F_RENDER_RECTANGLE | PM2F_INCREASE_X | PM2F_INCREASE_Y );
+		pm2_WR(par, PM2R_COLOR_DDA_MODE, 0);
 	}
 }
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

git-hwmon.patch
pm3fb-copyarea-and-partial-imageblit-suppor.patch
skeletonfb-wrong-field-name-fix.patch
pm3fb-header-file-reduction.patch
pm3fb-imageblit-improved.patch
pm3fb-3-small-fixes.patch
pm3fb-improvements-and-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option.patch
pm2fb-accelerated-imageblit.patch
pm2fb-source-code-improvements.patch
pm2fb-permedia-2v-initialization-fixes.patch
pm2fb-accelerated-24-bit-fillrect.patch
tdfxfb-coding-style-improvement.patch
tridentfb-coding-style-improvement.patch
tdfxfb-3-fixes.patch
tdfxfb-palette-fixes.patch
