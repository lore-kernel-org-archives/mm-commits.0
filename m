From: akpm@linux-foundation.org
Subject: + drivers-video-nuc900fbc-fix-lcd-build-error.patch added to -mm tree
Date: Wed, 23 Jun 2010 22:38:51 -0700
Message-ID: <201006240538.o5O5clIf020484@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752050Ab0FXFiw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jun 2010 01:38:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mcuos.com@gmail.com, rurality.wq@gmail.com


The patch titled
     drivers/video/nuc900fb.c: fix lcd build error
has been added to the -mm tree.  Its filename is
     drivers-video-nuc900fbc-fix-lcd-build-error.patch

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
Subject: drivers/video/nuc900fb.c: fix lcd build error
From: Wan ZongShun <mcuos.com@gmail.com>

Fix a nuc900 lcd build error.

Since the 'nuc900_driver_clksrc_div()' API cannot be merged into mainline
successfully, I removed this clock source selection hook in this driver. 
This means nuc900 lcd driver has to select default clock source from the
external crystal now.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
Cc: Qiang Wang <rurality.wq@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/nuc900fb.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/video/nuc900fb.c~drivers-video-nuc900fbc-fix-lcd-build-error drivers/video/nuc900fb.c
--- a/drivers/video/nuc900fb.c~drivers-video-nuc900fbc-fix-lcd-build-error
+++ a/drivers/video/nuc900fb.c
@@ -596,8 +596,6 @@ static int __devinit nuc900fb_probe(stru
 		goto release_regs;
 	}
 
-	nuc900_driver_clksrc_div(&pdev->dev, "ext", 0x2);
-
 	fbi->clk = clk_get(&pdev->dev, NULL);
 	if (!fbi->clk || IS_ERR(fbi->clk)) {
 		printk(KERN_ERR "nuc900-lcd:failed to get lcd clock source\n");
_

Patches currently in -mm which might be from mcuos.com@gmail.com are

linux-next.patch
rtc-fix-ds1388-time-corruption.patch
drivers-video-nuc900fbc-fix-lcd-build-error.patch
maintainers-update-arm-nuvoton-w90x900-arm-architecture-file-patterns.patch
nuc900-rtc-change-the-waiting-for-device-ready-implement.patch
rtc-nuc900-fix-checking-of-args-during-time-setting.patch
drivers-rtc-rtc-pcf8563c-remove-unused-struct.patch
rtc-pxa-remove-unused-field.patch
rtc-m48t59-kfreenull-is-ok.patch
rtc-rtc-mxc-remove-six-unused-fields.patch
rtc-fixes-and-new-functionality-for-fm3130.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch
rtc-pxa-remove-unnecessary-private-ops-ioctl.patch
drivers-rtc-rtc-pl031c-remove-unused-include-linux-versionh.patch
rtc-driver-for-the-dryice-block-found-in-imx25-chips.patch
rtc-add-intersil-isl12022-rtc-driver.patch
rtc-m41t80-use-rtc_valid_tm-to-check-returned-tm.patch
rtc-max6900-use-rtc_valid_tm-to-check-returning-tm.patch
rtc-m48t59-use-rtc_valid_tm-to-check-returned-tm.patch
rtc-m48t86-use-rtc_valid_tm-to-check-returned-tm.patch

