From: akpm@linux-foundation.org
Subject: + savagefb-fix-black-screen-on-load-in-savage-ix.patch added to -mm tree
Date: Sun, 11 Mar 2007 04:39:03 -0800
Message-ID: <200703111239.l2BCd3ZP011692@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46142 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933286AbXCKMjG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 08:39:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     savagefb: Fix black screen on load in Savage IX
has been added to the -mm tree.  Its filename is
     savagefb-fix-black-screen-on-load-in-savage-ix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: savagefb: Fix black screen on load in Savage IX
From: "Antonino A. Daplas" <adaplas@gmail.com>

This is a hack that seems to kick start the 2D engine of the Savage IX in some
Toshiba laptops.  Without this, the laptop starts with a black screen and
occasionally crashes X.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/savage/savagefb_driver.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN drivers/video/savage/savagefb_driver.c~savagefb-fix-black-screen-on-load-in-savage-ix drivers/video/savage/savagefb_driver.c
--- a/drivers/video/savage/savagefb_driver.c~savagefb-fix-black-screen-on-load-in-savage-ix
+++ a/drivers/video/savage/savagefb_driver.c
@@ -384,6 +384,19 @@ SavageSetup2DEngine(struct savagefb_par 
 	BCI_SEND(0);
 	BCI_SEND(BCI_CMD_SETREG | (1 << 16) | BCI_GBD2);
 	BCI_SEND(GlobalBitmapDescriptor);
+
+	/*
+	 * I don't know why, sending this twice fixes the intial black screen,
+	 * prevents X from crashing at least in Toshiba laptops with SavageIX.
+	 * --Tony
+	 */
+	par->bci_ptr = 0;
+	par->SavageWaitFifo(par, 4);
+
+	BCI_SEND(BCI_CMD_SETREG | (1 << 16) | BCI_GBD1);
+	BCI_SEND(0);
+	BCI_SEND(BCI_CMD_SETREG | (1 << 16) | BCI_GBD2);
+	BCI_SEND(GlobalBitmapDescriptor);
 }
 
 static void savagefb_set_clip(struct fb_info *info)
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
