From: akpm@linux-foundation.org
Subject: - fbdev-avoid-vertical-overflow-when-making-space-for-the-logo.patch removed from -mm tree
Date: Tue, 08 May 2007 19:59:47 -0700
Message-ID: <200705090259.l492xl4b010447@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032773AbXEIDAV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:00:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net, geoffrey.levand@am.sony.com, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     fbdev: avoid vertical overflow when making space for the logo
has been removed from the -mm tree.  Its filename was
     fbdev-avoid-vertical-overflow-when-making-space-for-the-logo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
