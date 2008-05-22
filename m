From: akpm@linux-foundation.org
Subject: + fbcon-make-logo_height-a-local-variable.patch added to -mm tree
Date: Thu, 22 May 2008 16:49:44 -0700
Message-ID: <200805222349.m4MNniHL027790@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759443AbYEVXtr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 May 2008 19:49:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     fbcon: make logo_height a local variable
has been added to the -mm tree.  Its filename is
     fbcon-make-logo_height-a-local-variable.patch

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
Subject: fbcon: make logo_height a local variable
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Make logo_height variable local in the only function it is used.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/video/console/fbcon.c~fbcon-make-logo_height-a-local-variable drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-make-logo_height-a-local-variable
+++ a/drivers/video/console/fbcon.c
@@ -107,9 +107,7 @@ static struct display fb_display[MAX_NR_
 
 static signed char con2fb_map[MAX_NR_CONSOLES];
 static signed char con2fb_map_boot[MAX_NR_CONSOLES];
-#ifndef MODULE
-static int logo_height;
-#endif
+
 static int logo_lines;
 /* logo_shown is an index to vc_cons when >= 0; otherwise follows FBCON_LOGO
    enums.  */
@@ -607,6 +605,7 @@ static void fbcon_prepare_logo(struct vc
 	struct fbcon_ops *ops = info->fbcon_par;
 	int cnt, erase = vc->vc_video_erase_char, step;
 	unsigned short *save = NULL, *r, *q;
+	int logo_height;
 
 	if (info->flags & FBINFO_MODULE) {
 		logo_shown = FBCON_LOGO_DONTSHOW;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

sm501-reverse-fpen-vbiasen-flags-behaviour.patch
s3c2410-ensure-that-fb_blank_powerdown-shuts-down-the-controller.patch
s3c2410-add-error-print-if-we-cannot-add-attribute.patch
s3c2410-clean-out-changelog-header-and-tidy.patch
s3c2410-fix-driver-module_alias.patch
tridentfb-replace-macros-with-functions.patch
tridentfb-convert-fb_info-into-allocated-one.patch
tridentfb-move-global-pseudo-palette-into-structure.patch
tridentfb-move-global-chip_id-into-structure.patch
tridentfb-move-global-flat-panel-variable-into-structure.patch
tridentfb-convert-is_blade-and-is_xp-macros-into-functions.patch
tridentfb-move-global-acceleration-hooks-into-structure.patch
tridentfb-make-use-of-functions-and-constants-from-the-vgah.patch
tridentfb-fix-timing-calculations.patch
tridentfb-use-mmio-access-for-clock-setting.patch
tridentfb-fix-clock-settings-for-older-trident-96xx-chips.patch
tridentfb-improve-probe-function.patch
tridentfb-improved-register-values-on-tgui-9680.patch
tridentfb-add-tgui-9440-support.patch
tridentfb-fix-unitialized-pseudo_palette.patch
tridentfb-improve-check_var-function.patch
tridentfb-preserve-memory-type-settings.patch
tridentfb-fix-hi-color-modes-for-tgui-9440.patch
tridentfb-add-acceleration-for-tgui-families.patch
tridentfb-acceleration-code-improvements.patch
tridentfb-acceleration-bug-fixes.patch
tridentfb-various-pixclock-and-timing-improvements.patch
tridentfb-acceleration-constants-change.patch
tridentfb-source-code-improvements.patch
tridentfb-fix-console-freeze-when-switching-from-x11.patch
amifb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
atafb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
fbcon-make-logo_height-a-local-variable.patch

