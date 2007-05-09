From: akpm@linux-foundation.org
Subject: - fbcon-check-console-fb-mapping-in-fbcon_get_requirement.patch removed from -mm tree
Date: Tue, 08 May 2007 20:02:31 -0700
Message-ID: <200705090302.l4932VU2010844@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44754 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1033287AbXEIDCe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:02:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbcon: check console-fb mapping in fbcon_get_requirement
has been removed from the -mm tree.  Its filename was
     fbcon-check-console-fb-mapping-in-fbcon_get_requirement.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbcon: check console-fb mapping in fbcon_get_requirement
From: "Antonino A. Daplas" <adaplas@gmail.com>

- Check the console-to-fb mapping in fbcon_get_requirement(), otherwise the
  value returned may not be valid for the driver.

- Minor cleanup

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN drivers/video/console/fbcon.c~fbcon-check-console-fb-mapping-in-fbcon_get_requirement drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-check-console-fb-mapping-in-fbcon_get_requirement
+++ a/drivers/video/console/fbcon.c
@@ -3048,14 +3048,14 @@ static void fbcon_get_requirement(struct
 {
 	struct vc_data *vc;
 	struct display *p;
-	int charcnt;
 
 	if (caps->flags) {
-		int i;
+		int i, charcnt;
 
 		for (i = first_fb_vc; i <= last_fb_vc; i++) {
 			vc = vc_cons[i].d;
-			if (vc && vc->vc_mode == KD_TEXT) {
+			if (vc && vc->vc_mode == KD_TEXT &&
+			    info->node == con2fb_map[i]) {
 				p = &fb_display[i];
 				caps->x |= 1 << (vc->vc_font.width - 1);
 				caps->y |= 1 << (vc->vc_font.height - 1);
@@ -3068,14 +3068,13 @@ static void fbcon_get_requirement(struct
 	} else {
 		vc = vc_cons[fg_console].d;
 
-		if (vc && vc->vc_mode == KD_TEXT) {
+		if (vc && vc->vc_mode == KD_TEXT &&
+		    info->node == con2fb_map[fg_console]) {
 			p = &fb_display[fg_console];
-			caps->x |= 1 << (vc->vc_font.width - 1);
-			caps->y |= 1 << (vc->vc_font.height - 1);
-			charcnt = (p->userfont) ?
+			caps->x = 1 << (vc->vc_font.width - 1);
+			caps->y = 1 << (vc->vc_font.height - 1);
+			caps->len = (p->userfont) ?
 				FNTCHARCNT(p->fontdata) : 256;
-			if (caps->len < charcnt)
-				caps->len = charcnt;
 		}
 	}
 }
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
vt8623fb-fix-compile-warnings.patch
vt8623fb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
arkfb-fix-compiler-warnings.patch
arkfb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch
svgalib-move-fb_get_caps-to-svgalib.patch
