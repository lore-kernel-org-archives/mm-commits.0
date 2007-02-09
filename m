From: akpm@linux-foundation.org
Subject: + fbdev-modedb-allow-refresh-rates-for-named-video-modes.patch added to -mm tree
Date: Fri, 09 Feb 2007 01:26:37 -0800
Message-ID: <200702090926.l199QbFc009498@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38611 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946251AbXBIJ1o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 04:27:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, benh@kernel.crashing.org, jsimmons@infradead.org, paulus@samba.org


The patch titled
     fbdev modedb: allow refresh rates for named video modes
has been added to the -mm tree.  Its filename is
     fbdev-modedb-allow-refresh-rates-for-named-video-modes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
ps3-add-shutdown-to-virtual-uart-port-driver-framework.patch
ps3-av-settings-driver.patch
fbdev-modedb-allow-refresh-rates-for-named-video-modes.patch
fbdev-modedb-make-more-pointer-parameters-const.patch
fb_videomode_to_var-reset-virtual-screen-parameters.patch
ps3-preallocate-bootmem-memory-for-ps3fb.patch
ps3-virtual-frame-buffer-driver.patch
ps3-disable-display-flipping-during-mode-changes.patch
ps3-cleanup-ps3fb-before-clearing-hpte.patch
ps3-ps3av-fb-defconfig-updates.patch
