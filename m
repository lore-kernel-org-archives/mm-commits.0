From: akpm@linux-foundation.org
Subject: - fbmon-fix-edid-parser-to-detect-interlace-modes.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:17:50 -0700
Message-ID: <200810182317.m9INHo4j029164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751814AbYJRXRz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:17:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jon.dufresne@gmail.com, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     fbmon: fix EDID parser to detect interlace modes
has been removed from the -mm tree.  Its filename was
     fbmon-fix-edid-parser-to-detect-interlace-modes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbmon: fix EDID parser to detect interlace modes
From: "Jon Dufresne" <jon.dufresne@gmail.com>

The current EDID parser in the linux kernel ignores interlace modes.  The
patch looks for the edid interlace flag and adjusts the vertical
resolution if it is found.

Signed-off-by: Jon Dufresne <jon.dufresne@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmon.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/video/fbmon.c~fbmon-fix-edid-parser-to-detect-interlace-modes drivers/video/fbmon.c
--- a/drivers/video/fbmon.c~fbmon-fix-edid-parser-to-detect-interlace-modes
+++ a/drivers/video/fbmon.c
@@ -564,7 +564,13 @@ static void get_detailed_timing(unsigned
 		mode->sync |= FB_SYNC_VERT_HIGH_ACT;
 	mode->refresh = PIXEL_CLOCK/((H_ACTIVE + H_BLANKING) *
 				     (V_ACTIVE + V_BLANKING));
-	mode->vmode = 0;
+	if (INTERLACED) {
+		mode->yres *= 2;
+		mode->upper_margin *= 2;
+		mode->lower_margin *= 2;
+		mode->vsync_len *= 2;
+		mode->vmode |= FB_VMODE_INTERLACED;
+	}
 	mode->flag = FB_MODE_IS_DETAILED;
 
 	DPRINTK("      %d MHz ",  PIXEL_CLOCK/1000000);
_

Patches currently in -mm which might be from jon.dufresne@gmail.com are

origin.patch

