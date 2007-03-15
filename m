From: akpm@linux-foundation.org
Subject: + fbdev-avoid-vertical-overflow-when-making-space-for-the-logo.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:55:48 -0800
Message-ID: <200703151855.l2FItoan023524@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36167 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932502AbXCOS41 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:56:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net, geoffrey.levand@am.sony.com, jsimmons@infradead.org


The patch titled
     fbdev: avoid vertical overflow when making space for the logo
has been added to the -mm tree.  Its filename is
     fbdev-avoid-vertical-overflow-when-making-space-for-the-logo.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbdev: avoid vertical overflow when making space for the logo
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

fbcon_prepare_logo(): Avoid vertical overflow when making space for the logo

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
Acked-By: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN drivers/video/console/fbcon.c~fbdev-avoid-vertical-overflow-when-making-space-for-the-logo drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbdev-avoid-vertical-overflow-when-making-space-for-the-logo
+++ a/drivers/video/console/fbcon.c
@@ -618,8 +618,13 @@ static void fbcon_prepare_logo(struct vc
 			r -= cols;
 		}
 		if (!save) {
-			vc->vc_y += logo_lines;
-			vc->vc_pos += logo_lines * vc->vc_size_row;
+			int lines;
+			if (vc->vc_y + logo_lines >= rows)
+				lines = rows - vc->vc_y - 1;
+			else
+				lines = logo_lines;
+			vc->vc_y += lines;
+			vc->vc_pos += lines * vc->vc_size_row;
 		}
 	}
 	scr_memsetw((unsigned short *) vc->vc_origin,
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

bool-fbdevs-must-depend-on-fb-=-y.patch
ps3fb-thread-updates.patch
ps3av-thread-updates.patch
ps3fb-kill-superfluous-zero-initializations.patch
ps3fb-atomic-fixes.patch
ps3av-misc-updates.patch
fbdev-avoid-vertical-overflow-when-making-space-for-the-logo.patch
fbdev-fb_do_show_logo-updates.patch
fbdev-correct-image-offsets-when-rotating-logo.patch
