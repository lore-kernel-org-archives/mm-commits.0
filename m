From: akpm@linux-foundation.org
Subject: - intel-fb-force-even-line-count-in-interlaced-mode.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:44:46 -0700
Message-ID: <200710162044.l9GKik1r016194@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46235 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933284AbXJPVXf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:23:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khc@pm.waw.pl, adaplas@pol.net, sylvain.meyer@worldonline.fr, mm-commits@vger.kernel.org


The patch titled
     Intel FB: force even line count in interlaced mode
has been removed from the -mm tree.  Its filename was
     intel-fb-force-even-line-count-in-interlaced-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 15 insertions(+)

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

origin.patch
git-wireless.patch
