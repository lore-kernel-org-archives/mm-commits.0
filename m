From: akpm@linux-foundation.org
Subject: [folded-merged] goldfish-framebuffer-driver-fix.patch removed from -mm tree
Date: Thu, 21 Feb 2013 16:10:27 -0800
Message-ID: <20130222001028.2619131C016@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:37690 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab3BVAKa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 19:10:30 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so15039ggn.2
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 16:10:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, FlorianSchandinat@gmx.de, alan@linux.intel.com, arve@android.com, bruce.j.beare@intel.com, jun.nakajima@intel.com, mikechan@google.com, sheng@linux.intel.com, thomas.keel@intel.com, tomi.valkeinen@ti.com, xiaohui.xin@intel.com, yunhong.jiang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: goldfish-framebuffer-driver-fix
has been removed from the -mm tree.  Its filename was
     goldfish-framebuffer-driver-fix.patch

This patch was dropped because it was folded into goldfish-framebuffer-=
driver.patch

------------------------------------------------------
=46rom: Andrew Morton <akpm@linux-foundation.org>
Subject: goldfish-framebuffer-driver-fix

fix (silly) sparse warnings

Cc: Alan Cox <alan@linux.intel.com>
Cc: Arve Hj=F8nnev=E5g <arve@android.com>
Cc: Bruce Beare <bruce.j.beare@intel.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Jun Nakajima <jun.nakajima@intel.com>
Cc: Mike A. Chan <mikechan@google.com>
Cc: Sheng Yang <sheng@linux.intel.com>
Cc: Tom Keel <thomas.keel@intel.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Xiaohui Xin <xiaohui.xin@intel.com>
Cc: Yunhong Jiang <yunhong.jiang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/goldfishfb.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/video/goldfishfb.c~goldfish-framebuffer-driver-fix dr=
ivers/video/goldfishfb.c
--- a/drivers/video/goldfishfb.c~goldfish-framebuffer-driver-fix
+++ a/drivers/video/goldfishfb.c
@@ -244,11 +244,12 @@ static int goldfish_fb_probe(struct plat
 	fb->fb.var.blue.length =3D 5;
=20
 	framesize =3D width * height * 2 * 2;
-	fb->fb.screen_base =3D dma_alloc_coherent(&pdev->dev, framesize,
+	fb->fb.screen_base =3D (char __force __iomem *)dma_alloc_coherent(
+						&pdev->dev, framesize,
 						&fbpaddr, GFP_KERNEL);
 	pr_debug("allocating frame buffer %d * %d, got %p\n",
 					width, height, fb->fb.screen_base);
-	if (fb->fb.screen_base =3D=3D 0) {
+	if (fb->fb.screen_base =3D=3D NULL) {
 		ret =3D -ENOMEM;
 		goto err_alloc_screen_base_failed;
 	}
@@ -277,7 +278,8 @@ err_register_framebuffer_failed:
 err_request_irq_failed:
 err_fb_set_var_failed:
 	dma_free_coherent(&pdev->dev, framesize,
-				fb->fb.screen_base, fb->fb.fix.smem_start);
+				(void *)fb->fb.screen_base,
+				fb->fb.fix.smem_start);
 err_alloc_screen_base_failed:
 err_no_irq:
 	iounmap(fb->reg_base);
@@ -296,7 +298,7 @@ static int goldfish_fb_remove(struct pla
 	unregister_framebuffer(&fb->fb);
 	free_irq(fb->irq, fb);
=20
-	dma_free_coherent(&pdev->dev, framesize, fb->fb.screen_base,
+	dma_free_coherent(&pdev->dev, framesize, (void *)fb->fb.screen_base,
 						fb->fb.fix.smem_start);
 	iounmap(fb->reg_base);
 	return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

origin.patch
bugh-prevent-double-evaulation-of-in-build_bug_on.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg.patch
goldfish-framebuffer-driver.patch
ocfs2-remove-kfree-redundant-null-checks.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
sys_prctl-coding-style-cleanup.patch
backlight-add-lms501kf03-lcd-driver.patch
drivers-video-backlight-makefile-cleanup.patch
checkpatch-dont-emit-the-camelcase-warning-for-pagefoo.patch
rtc-max77686-add-maxim-77686-driver.patch
rtc-pcf8523-add-low-battery-voltage-support.patch
rtc-add-rtc-driver-for-tps80031-tps80032.patch
rtc-add-support-for-spi-rtc-rx4581.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
