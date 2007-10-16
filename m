From: akpm@linux-foundation.org
Subject: - fbdev-find-mode-with-the-highest-safest-refresh-rate-in-fb_find_mode.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:44:11 -0700
Message-ID: <200710162044.l9GKiBvf016121@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52208 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936130AbXJPVHv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: spock@gentoo.org, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbdev: find mode with the highest/safest refresh rate in fb_find_mode()
has been removed from the -mm tree.  Its filename was
     fbdev-find-mode-with-the-highest-safest-refresh-rate-in-fb_find_mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbdev: find mode with the highest/safest refresh rate in fb_find_mode()
From: Michal Januszewski <spock@gentoo.org>

Currently, if the refresh rate is not specified, fb_find_mode() returns the
first known video mode with the requested resolution, which provides no
guarantees wrt the refresh rate.  Change this so that the mode with the
highest refresh rate is returned when the driver provides a custom video mode
database and the monitor limits, and a mode with the safe 60 Hz refresh rate
otherwise.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/modedb.c |   41 +++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff -puN drivers/video/modedb.c~fbdev-find-mode-with-the-highest-safest-refresh-rate-in-fb_find_mode drivers/video/modedb.c
--- a/drivers/video/modedb.c~fbdev-find-mode-with-the-highest-safest-refresh-rate-in-fb_find_mode
+++ a/drivers/video/modedb.c
@@ -606,26 +606,43 @@ done:
 	DPRINTK("Trying specified video mode%s %ix%i\n",
 	    refresh_specified ? "" : " (ignoring refresh rate)", xres, yres);
 
-	diff = refresh;
+	if (!refresh_specified) {
+		/*
+		 * If the caller has provided a custom mode database and a
+		 * valid monspecs structure, we look for the mode with the
+		 * highest refresh rate.  Otherwise we play it safe it and
+		 * try to find a mode with a refresh rate closest to the
+		 * standard 60 Hz.
+		 */
+		if (db != modedb &&
+		    info->monspecs.vfmin && info->monspecs.vfmax &&
+		    info->monspecs.hfmin && info->monspecs.hfmax &&
+		    info->monspecs.dclkmax) {
+			refresh = 1000;
+		} else {
+			refresh = 60;
+		}
+	}
+
+	diff = -1;
 	best = -1;
 	for (i = 0; i < dbsize; i++) {
-		if (name_matches(db[i], name, namelen) ||
-		    (res_specified && res_matches(db[i], xres, yres))) {
-			if(!fb_try_mode(var, info, &db[i], bpp)) {
-				if(!refresh_specified || db[i].refresh == refresh)
-					return 1;
-				else {
-					if(diff > abs(db[i].refresh - refresh)) {
-						diff = abs(db[i].refresh - refresh);
-						best = i;
-					}
+		if ((name_matches(db[i], name, namelen) ||
+		    (res_specified && res_matches(db[i], xres, yres))) &&
+		    !fb_try_mode(var, info, &db[i], bpp)) {
+			if (refresh_specified && db[i].refresh == refresh) {
+				return 1;
+			} else {
+				if (abs(db[i].refresh - refresh) < diff) {
+					diff = abs(db[i].refresh - refresh);
+					best = i;
 				}
 			}
 		}
 	}
 	if (best != -1) {
 		fb_try_mode(var, info, &db[best], bpp);
-		return 2;
+		return (refresh_specified) ? 2 : 1;
 	}
 
 	diff = xres + yres;
_

Patches currently in -mm which might be from spock@gentoo.org are

origin.patch
