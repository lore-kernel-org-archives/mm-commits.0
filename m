From: akpm@linux-foundation.org
Subject: [merged] cirrusfb-fix-error-paths-in-cirrusfb_xxx_register.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:42:49 -0700
Message-ID: <200904011842.n31IgnTO009818@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763532AbZDASo5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:44:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: fix error paths in cirrusfb_xxx_register()
has been removed from the -mm tree.  Its filename was
     cirrusfb-fix-error-paths-in-cirrusfb_xxx_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
+		return 0;
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

origin.patch
linux-next.patch
tdfxfb-move-i2c-functionality-into-the-tdfxfb.patch
tdfxfb-make-use-of-ddc-information-about-connected-monitor.patch

