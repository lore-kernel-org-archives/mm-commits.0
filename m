From: akpm@linux-foundation.org
Subject: - fbcon-fix-typo-and-bogus-logic-in-get_default_font.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:54:58 -0700
Message-ID: <200707312354.l6VNswQX029188@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44884 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758443AbXGaXzh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 19:55:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbcon: Fix typo and bogus logic in get_default_font
has been removed from the -mm tree.  Its filename was
     fbcon-fix-typo-and-bogus-logic-in-get_default_font.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
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
tridentfb-coding-style-improvement.patch
tdfxfb-coding-style-improvement.patch
tdfxfb-3-fixes.patch
tdfxfb-palette-fixes.patch
