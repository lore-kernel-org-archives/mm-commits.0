From: akpm@linux-foundation.org
Subject: + fbmon-fix-edid-parser-to-detect-interlace-modes.patch added to -mm tree
Date: Mon, 22 Sep 2008 16:33:44 -0700
Message-ID: <200809222333.m8MNXi0V003951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40377 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753341AbYIVXeU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Sep 2008 19:34:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jon.dufresne@gmail.com, krzysztof.h1@poczta.fm


The patch titled
     fbmon: fix EDID parser to detect interlace modes
has been added to the -mm tree.  Its filename is
     fbmon-fix-edid-parser-to-detect-interlace-modes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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

fbmon-fix-edid-parser-to-detect-interlace-modes.patch

