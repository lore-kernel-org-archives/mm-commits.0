From: akpm@linux-foundation.org
Subject: + viafb-reorder-initialization-for-dual-framebuffer-mode.patch added to -mm tree
Date: Tue, 09 Feb 2010 15:40:55 -0800
Message-ID: <201002092340.o19Netgo008551@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35281 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751940Ab0BIXl3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Feb 2010 18:41:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn


The patch titled
     viafb: reorder initialization for dual framebuffer mode
has been added to the -mm tree.  Its filename is
     viafb-reorder-initialization-for-dual-framebuffer-mode.patch

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
Subject: viafb: reorder initialization for dual framebuffer mode
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

This patch reorders the initialization for dual framebuffer mode to not
ignore the settings for the first mode.  Previously they were overwritten
with the settings for the second one before they were applied.

This should have no effect on non dual framebuffer mode and do what the
user intended (initalization to desired modes) in dual framebuffer mode.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/viafbdev.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/via/viafbdev.c~viafb-reorder-initialization-for-dual-framebuffer-mode drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-reorder-initialization-for-dual-framebuffer-mode
+++ a/drivers/video/via/viafbdev.c
@@ -1960,6 +1960,9 @@ static int __devinit via_pci_probe(struc
 	default_var.lower_margin = 4;
 	default_var.hsync_len = default_var.left_margin;
 	default_var.vsync_len = 4;
+	viafb_setup_fixinfo(&viafbinfo->fix, viaparinfo);
+	viafb_check_var(&default_var, viafbinfo);
+	viafbinfo->var = default_var;
 
 	if (viafb_dual_fb) {
 		viafbinfo1 = framebuffer_alloc(viafb_par_length, &pdev->dev);
@@ -2015,9 +2018,6 @@ static int __devinit via_pci_probe(struc
 			&viafbinfo1->fix);
 	}
 
-	viafb_setup_fixinfo(&viafbinfo->fix, viaparinfo);
-	viafb_check_var(&default_var, viafbinfo);
-	viafbinfo->var = default_var;
 	viafb_update_fix(viafbinfo);
 	viaparinfo->depth = fb_get_color_depth(&viafbinfo->var,
 		&viafbinfo->fix);
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

viafb-deprecate-private-ioctls.patch
viafb-remove-dead-code.patch
viafb-split-global-index-up.patch
viafb-split-global-index-up-fix.patch
viafb-remove-the-remaining-via_res_-uses.patch
viafb-some-dvi-cleanup.patch
viafb-yet-another-dead-code-removal.patch
viafb-reorder-initialization-for-dual-framebuffer-mode.patch
viafb-video-address-setting-revisited.patch
viafb-make-viafb_set_par-more-dual-framebuffer-compatible.patch
drivers-video-via-fix-continuation-line-formats.patch

