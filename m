From: akpm@linux-foundation.org
Subject: + fbcon-fix-typo-and-bogus-logic-in-get_default_font.patch added to -mm tree
Date: Thu, 26 Jul 2007 12:00:03 -0700
Message-ID: <200707261900.l6QJ034m015574@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45211 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759638AbXGZTAO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 15:00:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     fbcon: Fix typo and bogus logic in get_default_font
has been added to the -mm tree.  Its filename is
     fbcon-fix-typo-and-bogus-logic-in-get_default_font.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbcon: Fix typo and bogus logic in get_default_font
From: "Antonino A. Daplas" <adaplas@gmail.com>

Reported in: Bugzilla Bug 8727

Fix typo and bogus logic in get_default_font(). The bug results in
get_default_font() returning a font that may not be displayed properly by a
framebuffer driver.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fonts.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/console/fonts.c~fbcon-fix-typo-and-bogus-logic-in-get_default_font drivers/video/console/fonts.c
--- a/drivers/video/console/fonts.c~fbcon-fix-typo-and-bogus-logic-in-get_default_font
+++ a/drivers/video/console/fonts.c
@@ -133,8 +133,8 @@ const struct font_desc *get_default_font
 	if ((yres < 400) == (f->height <= 8))
 	    c += 1000;
 
-	if (!(font_w & (1 << (f->width - 1))) ||
-	    !(font_w & (1 << (f->height - 1))))
+	if ((font_w & (1 << (f->width - 1))) &&
+	    (font_h & (1 << (f->height - 1))))
 	    c += 1000;
 
 	if (c > cc) {
_

Patches currently in -mm which might be from adaplas@gmail.com are

fbcon-fix-typo-and-bogus-logic-in-get_default_font.patch
fbdev-fix-logo-if-logo-depth-is-less-than-framebuffer-depth.patch
s3c2410fb-fix-s3c2410-compilation.patch
xilinxfbremove-__initdata-from-xilinx_fb_fix-and-xilinx_fb_var.patch
xilinxfb-dont-bail-if-the-xilinxfb-platform-device-doesnt-have-any-pdata.patch
lxfb-geode-add-framebuffer-support-for-the-amd-geode-lx.patch
fbdev-export-fb_destroy_modelist.patch
connector-change-connectors-max-message-size.patch
uvesafb-add-connector-entries.patch
uvesafb-the-driver-core.patch
uvesafb-documentation.patch
pm3fb-copyarea-and-partial-imageblit-suppor.patch
skeletonfb-wrong-field-name-fix.patch
pm3fb-header-file-reduction.patch
pm3fb-imageblit-improved.patch
pm3fb-3-small-fixes.patch
pm3fb-improvements-and-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option.patch
pm2fb-accelerated-imageblit.patch
pm2fb-source-code-improvements.patch
pm2fb-permedia-2v-initialization-fixes.patch
pm2fb-accelerated-24-bit-fillrect.patch
sm501fb-update-suspend-and-resume-code.patch
sm501fb-call-fb-suspend-function-during-suspend-and-resume.patch
sm501fb-ensure-panel-interface-is-not-tristated-when-setup.patch
mbxfb-improvements-and-new-features.patch
pxafb-add-support-for-other-palette-formats.patch
stifb-detect-cards-in-double-buffer-mode-more-reliably.patch
tdfxfb-coding-style-improvement.patch
tridentfb-coding-style-improvement.patch
tdfxfb-3-fixes.patch
tdfxfb-palette-fixes.patch
