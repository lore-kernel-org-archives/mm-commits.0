From: akpm@linux-foundation.org
Subject: + fbdev-find-mode-with-the-highest-safest-refresh-rate-in-fb_find_mode.patch added to -mm tree
Date: Fri, 14 Sep 2007 19:25:16 -0700
Message-ID: <200709150225.l8F2PGUr002948@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60919 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751540AbXIOCZV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 22:25:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: spock@gentoo.org, adaplas@gmail.com


The patch titled
     fbdev: find mode with the highest/safest refresh rate in fb_find_mode()
has been added to the -mm tree.  Its filename is
     fbdev-find-mode-with-the-highest-safest-refresh-rate-in-fb_find_mode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

fbdev-export-fb_destroy_modelist.patch
connector-change-connectors-max-message-size.patch
uvesafb-add-connector-entries.patch
uvesafb-the-driver-core.patch
uvesafb-the-driver-core-uvesafb-set-the-refresh-rate-to-60hz-if-nocrtc-is-used.patch
uvesafb-the-driver-core-uvesafb-always-use-mutexes-when-accessing-uvfb_tasks.patch
uvesafb-the-driver-core-uvesafb-fix-a-typo-in-a-warning.patch
uvesafb-the-driver-core-uvesafb-use-visual_truecolor-as-the-default-visual.patch
uvesafb-the-driver-core-uvesafb-use-the-default-refresh-rate-if-the-monitor-limits-are-not-set.patch
uvesafb-the-driver-core-uvesafb-try-to-set-mode-with-default-timings-if-setting-it-with-our-own-timings-failed.patch
uvesafb-the-driver-core-dont-access-vga-registers-directly-when-running-on-non-x86.patch
uvesafb-documentation.patch
uvesafb-documentation-uvesafb-add-info-about-pmipal-yrap-and-ypan-being-available-only-on-x86.patch
fbdev-find-mode-with-the-highest-safest-refresh-rate-in-fb_find_mode.patch
