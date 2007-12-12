From: akpm@linux-foundation.org
Subject: + fbcon-fix-sparse-warning-about-shadowing-p-symbol.patch added to -mm tree
Date: Tue, 11 Dec 2007 16:57:40 -0800
Message-ID: <200712120057.lBC0ve3D017805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50171 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751705AbXLLA5p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Dec 2007 19:57:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, adaplas@pol.net


The patch titled
     fbcon: fix sparse warning about shadowing 'p' symbol
has been added to the -mm tree.  Its filename is
     fbcon-fix-sparse-warning-about-shadowing-p-symbol.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbcon: fix sparse warning about shadowing 'p' symbol
From: Marcin Slusarz <marcin.slusarz@gmail.com>

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/video/console/fbcon.c~fbcon-fix-sparse-warning-about-shadowing-p-symbol drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-fix-sparse-warning-about-shadowing-p-symbol
+++ a/drivers/video/console/fbcon.c
@@ -2795,7 +2795,7 @@ static int fbcon_scrolldelta(struct vc_d
 {
 	struct fb_info *info = registered_fb[con2fb_map[fg_console]];
 	struct fbcon_ops *ops = info->fbcon_par;
-	struct display *p = &fb_display[fg_console];
+	struct display *disp = &fb_display[fg_console];
 	int offset, limit, scrollback_old;
 
 	if (softback_top) {
@@ -2833,7 +2833,7 @@ static int fbcon_scrolldelta(struct vc_d
 			logo_shown = FBCON_LOGO_CANSHOW;
 		}
 		fbcon_cursor(vc, CM_ERASE | CM_SOFTBACK);
-		fbcon_redraw_softback(vc, p, lines);
+		fbcon_redraw_softback(vc, disp, lines);
 		fbcon_cursor(vc, CM_DRAW | CM_SOFTBACK);
 		return 0;
 	}
@@ -2855,9 +2855,9 @@ static int fbcon_scrolldelta(struct vc_d
 
 	fbcon_cursor(vc, CM_ERASE);
 
-	offset = p->yscroll - scrollback_current;
-	limit = p->vrows;
-	switch (p->scrollmode) {
+	offset = disp->yscroll - scrollback_current;
+	limit = disp->vrows;
+	switch (disp->scrollmode) {
 	case SCROLL_WRAP_MOVE:
 		info->var.vmode |= FB_VMODE_YWRAP;
 		break;
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

vgacon-fix-sparse-warning-about-shadowing-i-symbol.patch
fbcon-fix-sparse-warning-about-shadowing-p-symbol.patch
fbcon-fix-sparse-warning-about-shadowing-rotate-symbol.patch
logo-move-declarations-of-logos-to-linux_logoh.patch
