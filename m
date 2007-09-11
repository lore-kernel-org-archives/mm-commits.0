From: akpm@linux-foundation.org
Subject: + intel-fb-support-for-interlaced-video-modes.patch added to -mm tree
Date: Mon, 10 Sep 2007 22:46:44 -0700
Message-ID: <200709110546.l8B5kiAK027902@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57137 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752339AbXIKFqv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 01:46:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khc@pm.waw.pl, adaplas@pol.net, akpm@linux-foundation.org


The patch titled
     Intel FB: support for interlaced video modes
has been added to the -mm tree.  Its filename is
     intel-fb-support-for-interlaced-video-modes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Intel FB: support for interlaced video modes
From: Krzysztof Halasa <khc@pm.waw.pl>

Intel framebuffer now supports interlaced video modes.

Signed-off-by: Krzysztof Halasa <khc@pm.waw.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/intelfb/intelfbhw.c |   12 +++++++-----
 drivers/video/intelfb/intelfbhw.h |    4 ++++
 2 files changed, 11 insertions(+), 5 deletions(-)

diff -puN drivers/video/intelfb/intelfbhw.c~intel-fb-support-for-interlaced-video-modes drivers/video/intelfb/intelfbhw.c
--- a/drivers/video/intelfb/intelfbhw.c~intel-fb-support-for-interlaced-video-modes
+++ a/drivers/video/intelfb/intelfbhw.c
@@ -323,11 +323,7 @@ intelfbhw_validate_mode(struct intelfb_i
 		return 1;
 	}
 
-	/* Check for interlaced/doublescan modes. */
-	if (var->vmode & FB_VMODE_INTERLACED) {
-		WRN_MSG("Mode is interlaced.\n");
-		return 1;
-	}
+	/* Check for doublescan modes. */
 	if (var->vmode & FB_VMODE_DOUBLE) {
 		WRN_MSG("Mode is double-scan.\n");
 		return 1;
@@ -1220,6 +1216,12 @@ intelfbhw_mode_to_hw(struct intelfb_info
 
 	/* Set the palette to 8-bit mode. */
 	*pipe_conf &= ~PIPECONF_GAMMA;
+
+	if (var->vmode & FB_VMODE_INTERLACED)
+		*pipe_conf |= PIPECONF_INTERLACE_W_FIELD_INDICATION;
+	else
+		*pipe_conf &= ~PIPECONF_INTERLACE_MASK;
+
 	return 0;
 }
 
diff -puN drivers/video/intelfb/intelfbhw.h~intel-fb-support-for-interlaced-video-modes drivers/video/intelfb/intelfbhw.h
--- a/drivers/video/intelfb/intelfbhw.h~intel-fb-support-for-interlaced-video-modes
+++ a/drivers/video/intelfb/intelfbhw.h
@@ -286,6 +286,10 @@
 #define PIPECONF_UNLOCKED		0
 #define PIPECONF_GAMMA			(1 << 24)
 #define PIPECONF_PALETTE		0
+#define PIPECONF_PROGRESSIVE			(0 << 21)
+#define PIPECONF_INTERLACE_W_FIELD_INDICATION	(6 << 21)
+#define PIPECONF_INTERLACE_FIELD_0_ONLY		(7 << 21)
+#define PIPECONF_INTERLACE_MASK			(7 << 21)
 
 #define DISPARB			0x70030
 #define DISPARB_AEND_MASK		0x1ff
_

Patches currently in -mm which might be from khc@pm.waw.pl are

intel-fb-pixel-clock-calculation-fix.patch
intel-fb-support-for-interlaced-video-modes.patch
