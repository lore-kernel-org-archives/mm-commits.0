From: akpm@linux-foundation.org
Subject: [failures] radeonfb-backlight-shutoff-flashes-momentarily.patch removed from -mm tree
Date: Fri, 10 Apr 2009 01:47:11 -0700
Message-ID: <200904100847.n3A8lBbj031336@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755704AbZDJIuq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 04:50:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rtdrury@earthlink.net, benh@kernel.crashing.org, krzysztof.h1@poczta.fm, michel@daenzer.net, mm-commits@vger.kernel.org


The patch titled
     radeonfb: backlight shutoff flashes momentarily
has been removed from the -mm tree.  Its filename was
     radeonfb-backlight-shutoff-flashes-momentarily.patch

This patch was dropped because it had testing failures

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
radeonfb-backlight-shutoff-flashes-momentarily-checkpatch-fixes.patch

