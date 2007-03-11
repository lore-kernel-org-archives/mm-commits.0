From: akpm@linux-foundation.org
Subject: + savagefb-fix-compile-error-if-debugging-is-enabled.patch added to -mm tree
Date: Sun, 11 Mar 2007 04:39:10 -0800
Message-ID: <200703111239.l2BCdBte011695@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46146 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933290AbXCKMjN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 08:39:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     savagefb: Fix compile error if debugging is enabled
has been added to the -mm tree.  Its filename is
     savagefb-fix-compile-error-if-debugging-is-enabled.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: savagefb: Fix compile error if debugging is enabled
From: "Antonino A. Daplas" <adaplas@gmail.com>

SavagePrintRegs() requires struct savagefb_par.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/savage/savagefb_driver.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/video/savage/savagefb_driver.c~savagefb-fix-compile-error-if-debugging-is-enabled drivers/video/savage/savagefb_driver.c
--- a/drivers/video/savage/savagefb_driver.c~savagefb-fix-compile-error-if-debugging-is-enabled
+++ a/drivers/video/savage/savagefb_driver.c
@@ -509,7 +509,7 @@ static int common_calc_clock(long freq, 
 #ifdef SAVAGEFB_DEBUG
 /* This function is used to debug, it prints out the contents of s3 regs */
 
-static void SavagePrintRegs(void)
+static void SavagePrintRegs(struct savagefb_par *par)
 {
 	unsigned char i;
 	int vgaCRIndex = 0x3d4;
@@ -1538,7 +1538,7 @@ static int savagefb_set_par(struct fb_in
 	savagefb_set_fix(info);
 	savagefb_set_clip(info);
 
-	SavagePrintRegs();
+	SavagePrintRegs(par);
 	return 0;
 }
 
@@ -2168,7 +2168,6 @@ static int __devinit savagefb_probe(stru
 	int video_len;
 
 	DBG("savagefb_probe");
-	SavagePrintRegs();
 
 	info = framebuffer_alloc(sizeof(struct savagefb_par), &dev->dev);
 	if (!info)
_

Patches currently in -mm which might be from adaplas@gmail.com are

fbdev-add-ultrasharp-uxga-to-broken-monitor-database.patch
intelfb-fix-ring-space-calculation.patch
nvidiafb-bring-back-generic-ddc-reading.patch
fbdev-ignore-vesa-modes-if-framebuffer-is-disabled.patch
fbdev-fix-obvious-bug-in-show_pan.patch
neofb-fill-transp-msb_right-with-the-correct.patch
atyfb-kill-dead-code.patch
fbdev-mm-deferred-io-support.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-mm-deferred-io-support-fix-2.patch
fbdev-hecuba-framebuffer-driver.patch
fbdev-hecuba-framebuffer-driver-fix.patch
sstfb-fix-pixclock-setting-on-voodoo-1-2-cards.patch
savagefb-fix-black-screen-on-load-in-savage-ix.patch
savagefb-fix-compile-error-if-debugging-is-enabled.patch
