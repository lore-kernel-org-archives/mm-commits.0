From: akpm@linux-foundation.org
Subject: + intel-fb-force-even-line-count-in-interlaced-mode.patch added to -mm tree
Date: Mon, 24 Sep 2007 14:17:06 -0700
Message-ID: <200709242117.l8OLH6XB018134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42698 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754742AbXIXVRW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Sep 2007 17:17:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khc@pm.waw.pl, adaplas@pol.net, sylvain.meyer@worldonline.fr


The patch titled
     Intel FB: force even line count in interlaced mode
has been added to the -mm tree.  Its filename is
     intel-fb-force-even-line-count-in-interlaced-mode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Intel FB: force even line count in interlaced mode
From: Krzysztof Halasa <khc@pm.waw.pl>

Intel FB: the chip adds two halflines automatically in interlaced mode,
force even line count for the right timings.

Signed-off-by: Krzysztof Halasa <khc@pm.waw.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: <sylvain.meyer@worldonline.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/intelfb/intelfbhw.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+)

diff -puN drivers/video/intelfb/intelfbhw.c~intel-fb-force-even-line-count-in-interlaced-mode drivers/video/intelfb/intelfbhw.c
--- a/drivers/video/intelfb/intelfbhw.c~intel-fb-force-even-line-count-in-interlaced-mode
+++ a/drivers/video/intelfb/intelfbhw.c
@@ -317,6 +317,14 @@ int intelfbhw_validate_mode(struct intel
 			var->yres, VACTIVE_MASK + 1);
 		return 1;
 	}
+	if (var->xres < 4) {
+		WRN_MSG("X resolution too small (%d vs 4).\n", var->xres);
+		return 1;
+	}
+	if (var->yres < 4) {
+		WRN_MSG("Y resolution too small (%d vs 4).\n", var->yres);
+		return 1;
+	}
 
 	/* Check for doublescan modes. */
 	if (var->vmode & FB_VMODE_DOUBLE) {
@@ -324,6 +332,11 @@ int intelfbhw_validate_mode(struct intel
 		return 1;
 	}
 
+	if ((var->vmode & FB_VMODE_INTERLACED) && (var->yres & 1)) {
+		WRN_MSG("Odd number of lines in interlaced mode\n");
+		return 1;
+	}
+
 	/* Check if clock is OK. */
 	tmp = 1000000000 / var->pixclock;
 	if (tmp < MIN_CLOCK) {
@@ -1127,6 +1140,8 @@ int intelfbhw_mode_to_hw(struct intelfb_
 		hblank_end);
 
 	vactive = var->yres;
+	if (var->vmode & FB_VMODE_INTERLACED)
+		vactive--; /* the chip adds 2 halflines automatically */
 	vsync_start = vactive + var->lower_margin;
 	vsync_end = vsync_start + var->vsync_len;
 	vtotal = vsync_end + var->upper_margin;
_

Patches currently in -mm which might be from khc@pm.waw.pl are

git-wireless.patch
intel-fb-support-for-interlaced-video-modes.patch
intel-fb-whitespace-bracket-and-other-clean-ups.patch
intel-fb-obvious-changes-and-corrections.patch
intel-fb-force-even-line-count-in-interlaced-mode.patch
intel-fb-more-interlaced-mode-support.patch
