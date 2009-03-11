From: akpm@linux-foundation.org
Subject: + fix-radeon-backlight-shutoff-flashes-momentarily.patch added to -mm tree
Date: Wed, 11 Mar 2009 14:04:05 -0700
Message-ID: <200903112104.n2BL45G7003745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751178AbZCKVGH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Mar 2009 17:06:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rtdrury@earthlink.net, benh@kernel.crashing.org, krzysztof.h1@poczta.fm


The patch titled
     radeonfb: fix: backlight shutoff flashes momentarily
has been added to the -mm tree.  Its filename is
     fix-radeon-backlight-shutoff-flashes-momentarily.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: radeonfb: fix: backlight shutoff flashes momentarily
From: "Robert T. Drury" <rtdrury@earthlink.net>

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=12845

Aluminum powerbook G4 with radeon.

The backlight momentarily flashes brightly when turning off.  If the
backlight is originally dim, the flash is more noticeable.  This momentary
flash is stressful on the power circuit.

The first OUTREG to LVDS_GEN_CNTL causes the flashing problem.  To fix,
remove the first manipulation of lvds_gen_cntl above it.

Second manipulation of lvds_gen_cntl does nothing (level always zero). 
The first manipulation was needed so the display would not be garbled
after turning the backlight back on, but at least on my powerbook, the
garbling seems to go away when the udelay is 1000.

Signed-off-by: Robert Drury <rtdrury@earthlink.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/radeon_backlight.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/video/aty/radeon_backlight.c~fix-radeon-backlight-shutoff-flashes-momentarily drivers/video/aty/radeon_backlight.c
--- a/drivers/video/aty/radeon_backlight.c~fix-radeon-backlight-shutoff-flashes-momentarily
+++ a/drivers/video/aty/radeon_backlight.c
@@ -101,12 +101,9 @@ static int radeon_bl_update_status(struc
 		tmpPixclksCntl = INPLL(PIXCLKS_CNTL);
 		if (rinfo->is_mobility || rinfo->is_IGP)
 			OUTPLLP(PIXCLKS_CNTL, 0, ~PIXCLK_LVDS_ALWAYS_ONb);
-		lvds_gen_cntl &= ~(LVDS_BL_MOD_LEVEL_MASK | LVDS_BL_MOD_EN);
-		lvds_gen_cntl |= (radeon_bl_get_level_brightness(pdata, 0) <<
-				  LVDS_BL_MOD_LEVEL_SHIFT);
 		lvds_gen_cntl |= LVDS_DISPLAY_DIS;
 		OUTREG(LVDS_GEN_CNTL, lvds_gen_cntl);
-		udelay(100);
+		udelay(1000);
 		lvds_gen_cntl &= ~(LVDS_ON | LVDS_EN);
 		OUTREG(LVDS_GEN_CNTL, lvds_gen_cntl);
 		lvds_gen_cntl &= ~(LVDS_DIGON);
_

Patches currently in -mm which might be from rtdrury@earthlink.net are

fix-radeon-backlight-shutoff-flashes-momentarily.patch

