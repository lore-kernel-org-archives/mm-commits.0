From: akpm@linux-foundation.org
Subject: + cirrusfb-fix-error-paths-in-cirrusfb_xxx_register.patch added to -mm tree
Date: Tue, 24 Feb 2009 14:57:16 -0800
Message-ID: <200902242257.n1OMvGM3018363@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755998AbZBXW5T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 17:57:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     cirrusfb: fix error paths in cirrusfb_xxx_register()
has been added to the -mm tree.  Its filename is
     cirrusfb-fix-error-paths-in-cirrusfb_xxx_register.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cirrusfb: fix error paths in cirrusfb_xxx_register()
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Balance iomap and iounmap and alloc and free calls in case of error druing
device register (probing).

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-fix-error-paths-in-cirrusfb_xxx_register drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-fix-error-paths-in-cirrusfb_xxx_register
+++ a/drivers/video/cirrusfb.c
@@ -2090,8 +2090,6 @@ static int __devinit cirrusfb_register(s
 
 err_dealloc_cmap:
 	fb_dealloc_cmap(&info->cmap);
-	cinfo->unmap(info);
-	framebuffer_release(info);
 	return err;
 }
 
@@ -2328,18 +2326,15 @@ static int __devinit cirrusfb_zorro_regi
 	zorro_set_drvdata(z, info);
 
 	ret = cirrusfb_register(info);
-	if (ret) {
-		if (btype == BT_PICASSO4) {
-			iounmap(info->screen_base);
-			iounmap(cinfo->regbase - 0x600000);
-		} else if (board_addr > 0x01000000)
-			iounmap(info->screen_base);
-	}
-	return ret;
+	if (!ret)
+		return 0
+
+	if (btype == BT_PICASSO4 || board_addr > 0x01000000)
+		iounmap(info->screen_base);
 
 err_unmap_regbase:
-	/* Parental advisory: explicit hack */
-	iounmap(cinfo->regbase - 0x600000);
+	if (btype == BT_PICASSO4)
+		iounmap(cinfo->regbase - 0x600000);
 err_release_region:
 	release_region(board_addr, board_size);
 err_release_fb:
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

linux-next.patch
cirrusfb-fix-laguna-chipset-memory-detection-and-clock-setting.patch
cirrusfb-add-laguna-additional-overflow-register.patch
cirrusfb-add-mmio-registers-for-laguna-chipsets.patch
cirrusfb-do-not-calculate-line-length-twice.patch
cirrusfb-use-5-6-5-rgb-for-16bpp-mode.patch
cirrusfb-various-improvements.patch
cirrusfb-laguna-chipset-8bpp-fix.patch
cirrusfb-check_var-improvements.patch
cirrusfb-various-laguna-fixes.patch
cirrusfb-acceleration-improvements.patch
cirrusfb-add-imageblit-function.patch
cirrusfb-fix-error-paths-in-cirrusfb_xxx_register.patch
drivers-video-sgivwfbc-fix-memory-leaks-in-removal-path.patch
tdfxfb-fix-memory-leaks-in-removal-path.patch
tridentfb-fix-memory-leaks-in-removal-path.patch
vfb-fix-memory-leaks-in-removal-path.patch
sstfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
stifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
valkyriefb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
68328fb-fix-cmap-memory-leaks.patch
amba-clcd-fix-cmap-memory-leaks.patch
amifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
asiliantfb-fix-cmap-memory-leaks.patch
asiliantfb-fix-cmap-memory-leaks-fix.patch

