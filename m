From: akpm@linux-foundation.org
Subject: + radeonfb-backlight-shutoff-flashes-momentarily.patch added to -mm tree
Date: Thu, 09 Apr 2009 15:11:38 -0700
Message-ID: <200904092211.n39MBcsi021525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762666AbZDIWPR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 18:15:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rtdrury@earthlink.net, benh@kernel.crashing.org, krzysztof.h1@poczta.fm, michel@daenzer.net


The patch titled
     radeonfb: backlight shutoff flashes momentarily
has been added to the -mm tree.  Its filename is
     radeonfb-backlight-shutoff-flashes-momentarily.patch

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
Subject: radeonfb: backlight shutoff flashes momentarily
From: "Robert T. Drury" <rtdrury@earthlink.net>

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=12845

Aluminum Powerbook G4 with Radeon 9600:

The backlight momentarily flashes brightly when turning off.  If the
backlight is originally dim, the flash is more noticeable.  This momentary
flash is stressful on the power circuit.

This patch removes the & ~LVDS_BL_MOD_EN above the first OUTREG to
LVDS_GEN_CNTL to eliminate the flash on shutoff, only for powerbook5,3 and
CHIP_FAMILY_RV350.

Signed-off-by: Robert Drury <rtdrury@earthlink.net>
Tested-by: Michel Daenzer <michel@daenzer.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/radeon_backlight.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/video/aty/radeon_backlight.c~radeonfb-backlight-shutoff-flashes-momentarily drivers/video/aty/radeon_backlight.c
--- a/drivers/video/aty/radeon_backlight.c~radeonfb-backlight-shutoff-flashes-momentarily
+++ a/drivers/video/aty/radeon_backlight.c
@@ -101,7 +101,10 @@ static int radeon_bl_update_status(struc
 		tmpPixclksCntl = INPLL(PIXCLKS_CNTL);
 		if (rinfo->is_mobility || rinfo->is_IGP)
 			OUTPLLP(PIXCLKS_CNTL, 0, ~PIXCLK_LVDS_ALWAYS_ONb);
-		lvds_gen_cntl &= ~(LVDS_BL_MOD_LEVEL_MASK | LVDS_BL_MOD_EN);
+		lvds_gen_cntl &= ~(LVDS_BL_MOD_LEVEL_MASK);
+		if(rinfo->family != CHIP_FAMILY_RV350 
+			|| !machine_is_compatible("PowerBook5,3"))
+				lvds_gen_cntl &= ~LVDS_BL_MOD_EN;
 		lvds_gen_cntl |= (radeon_bl_get_level_brightness(pdata, 0) <<
 				  LVDS_BL_MOD_LEVEL_SHIFT);
 		lvds_gen_cntl |= LVDS_DISPLAY_DIS;
diff -puN /dev/null /dev/null
_

Patches currently in -mm which might be from rtdrury@earthlink.net are

radeonfb-backlight-shutoff-flashes-momentarily.patch

