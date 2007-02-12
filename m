From: akpm@linux-foundation.org
Subject: - fbdev-modedb-allow-refresh-rates-for-named-video-modes.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:50:11 -0800
Message-ID: <200702122250.l1CMoBdg014206@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45824 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030407AbXBLWuq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:50:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, benh@kernel.crashing.org, jsimmons@infradead.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     fbdev modedb: allow refresh rates for named video modes
has been removed from the -mm tree.  Its filename was
     fbdev-modedb-allow-refresh-rates-for-named-video-modes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbdev modedb: allow refresh rates for named video modes
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

fbdev modedb: Take into account the specified refresh rates for video modes
specified by name, so e.g.  all of `720p', `720p@60', and `720p@50' work.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: James Simmons <jsimmons@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/modedb.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/video/modedb.c~fbdev-modedb-allow-refresh-rates-for-named-video-modes drivers/video/modedb.c
--- a/drivers/video/modedb.c~fbdev-modedb-allow-refresh-rates-for-named-video-modes
+++ a/drivers/video/modedb.c
@@ -610,10 +610,8 @@ done:
 	diff = refresh;
 	best = -1;
 	for (i = 0; i < dbsize; i++) {
-		if ((name_matches(db[i], name, namelen) &&
-			!fb_try_mode(var, info, &db[i], bpp)))
-			return 1;
-		if (res_specified && res_matches(db[i], xres, yres)) {
+		if (name_matches(db[i], name, namelen) ||
+		    (res_specified && res_matches(db[i], xres, yres))) {
 			if(!fb_try_mode(var, info, &db[i], bpp)) {
 				if(!refresh_specified || db[i].refresh == refresh)
 					return 1;
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
