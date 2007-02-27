From: akpm@linux-foundation.org
Subject: + neofb-fill-transp-msb_right-with-the-correct.patch added to -mm tree
Date: Tue, 27 Feb 2007 13:10:12 -0800
Message-ID: <200702272110.l1RLAG4s028699@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52297 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbXB0VKT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 16:10:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     neofb: fill transp->msb_right with the correct  value
has been added to the -mm tree.  Its filename is
     neofb-fill-transp-msb_right-with-the-correct.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: neofb: fill transp->msb_right with the correct  value
From: "Antonino A. Daplas" <adaplas@gmail.com>

Fill transp->msb_right with the correct value.  fbcon ignores this, but user
apps may not.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/neofb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/neofb.c~neofb-fill-transp-msb_right-with-the-correct drivers/video/neofb.c
--- a/drivers/video/neofb.c~neofb-fill-transp-msb_right-with-the-correct
+++ a/drivers/video/neofb.c
@@ -665,6 +665,7 @@ neofb_check_var(struct fb_var_screeninfo
 	var->red.msb_right = 0;
 	var->green.msb_right = 0;
 	var->blue.msb_right = 0;
+	var->transp.msb_right = 0;
 
 	switch (var->bits_per_pixel) {
 	case 8:		/* PSEUDOCOLOUR, 256 */
_

Patches currently in -mm which might be from adaplas@gmail.com are

patch-maintainers-update-email-address.patch
atyfb-fix-kconfig-error.patch
fbdev-add-ultrasharp-uxga-to-broken-monitor-database.patch
intelfb-fix-ring-space-calculation.patch
nvidiafb-bring-back-generic-ddc-reading.patch
fbdev-ignore-vesa-modes-if-framebuffer-is-disabled.patch
fbdev-fix-obvious-bug-in-show_pan.patch
neofb-fill-transp-msb_right-with-the-correct.patch
atyfb-kill-dead-code.patch
fbdev-mm-deferred-io-support.patch
fbdev-hecuba-framebuffer-driver.patch
