From: akpm@linux-foundation.org
Subject: + viafb-remove-lvds-initialization.patch added to -mm tree
Date: Wed, 26 Aug 2009 17:26:16 -0700
Message-ID: <200908270026.n7R0QGfk027712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35290 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754183AbZH0A0T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Aug 2009 20:26:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn


The patch titled
     viafb: remove LVDS initialization
has been added to the -mm tree.  Its filename is
     viafb-remove-lvds-initialization.patch

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
Subject: viafb: remove LVDS initialization
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

At least for VX800 this initialization is not very good as some parts of
the register are written with reserved values.  This makes the display go
white in some configurations and not usable until the framebuffer is
removed.  It's better to not initialize it as it allows to use a
previously (by BIOS) correctly configured display.

This patch makes some displays work but might cause problems on others. 
This is bad but can not be easily avoided.  If this causes some
regressions it's probably the best to fix it in the 'active' display setup
code.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/viamode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/video/via/viamode.c~viafb-remove-lvds-initialization drivers/video/via/viamode.c
--- a/drivers/video/via/viamode.c~viafb-remove-lvds-initialization
+++ a/drivers/video/via/viamode.c
@@ -309,8 +309,7 @@ struct io_reg CX700_ModeXregs[] = { {VIA
 {VIACR, CR96, 0xFF, 0x00},
 {VIACR, CR97, 0xFF, 0x00},
 {VIACR, CR99, 0xFF, 0x00},
-{VIACR, CR9B, 0xFF, 0x00},
-{VIACR, CRD2, 0xFF, 0xFF}	/* TMDS/LVDS control register.         */
+{VIACR, CR9B, 0xFF, 0x00}
 };
 
 /* Video Mode Table */
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

viafb-remove-duplicated-cx700-register-init.patch
viafb-remove-temporary-start-address-setting.patch
viafb-merge-viafb_update_viafb_par-in-viafb_update_fix.patch
viafb-split-viafb_set_start_addr-up.patch
viafb-fix-ioremap_nocache-error-handling.patch
viafb-clean-up-viamodeh.patch
viafb-remove-duplicated-mode-information.patch
viafb-clean-up-duoview.patch
viafb-clean-up-virtual-memory-handling.patch
viafb-remove-unused-video-device-stuff.patch
viafb-remove-lvds-initialization.patch
viafb-another-small-cleanup-of-viafb_par.patch
viafb-improve-viafb_par.patch
fb-fix-fb_pan_display-range-check.patch
fb-do-not-ignore-fb_set_par-errors.patch

