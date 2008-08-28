From: akpm@linux-foundation.org
Subject: + tdfxfb-fix-frame-buffer-name-overrun.patch added to -mm tree
Date: Thu, 28 Aug 2008 16:37:19 -0700
Message-ID: <200808282337.m7SNbJ7E020376@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44655 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757503AbYH1Xha (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Aug 2008 19:37:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, geert@linux-m68k.org


The patch titled
     tdfxfb: fix frame buffer name overrun
has been added to the -mm tree.  Its filename is
     tdfxfb-fix-frame-buffer-name-overrun.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tdfxfb: fix frame buffer name overrun
From: Krzysztof Helt <krzysztof.h1@wp.pl>

If there are more then one graphics card handled by the tdfxfb driver the
name of the frame buffer overruns reserved name size.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tdfxfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/tdfxfb.c~tdfxfb-fix-frame-buffer-name-overrun drivers/video/tdfxfb.c
--- a/drivers/video/tdfxfb.c~tdfxfb-fix-frame-buffer-name-overrun
+++ a/drivers/video/tdfxfb.c
@@ -95,7 +95,6 @@ static inline int mtrr_del(int reg, unsi
 #define VOODOO5_MAX_PIXCLOCK 350000
 
 static struct fb_fix_screeninfo tdfx_fix __devinitdata = {
-	.id =		"3Dfx",
 	.type =		FB_TYPE_PACKED_PIXELS,
 	.visual =	FB_VISUAL_PSEUDOCOLOR,
 	.ypanstep =	1,
@@ -1196,6 +1195,7 @@ static int __devinit tdfxfb_probe(struct
 		return -ENOMEM;
 
 	default_par = info->par;
+	strcpy(tdfx_fix.id, "3Dfx");
 
 	/* Configure the default fb_fix_screeninfo first */
 	switch (pdev->device) {
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

cirrusfb-check_par-fixes.patch
tdfxfb-fix-sdram-memory-size-detection.patch
tdfxfb-fix-frame-buffer-name-overrun.patch
linux-next.patch
fb-metronome-printk-format-warning.patch
rtc-m48t59-reduce-structure-m48t59_private.patch
rtc-m48t59-add-support-for-m48t02-and-m48t59-chips-2nd-rev.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch
neofb-reduce-panning-function.patch
viafb-accelc-accelh-update.patch
viafb-viafbdevc-update.patch
fbdev-kconfig-update.patch
fbdev-kconfig-update-fix.patch
neofb-kill-some-redundant-code.patch
vga16fb-remove-open_lock-mutex.patch
neofb-remove-open_lock-mutex.patch

