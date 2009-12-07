From: akpm@linux-foundation.org
Subject: + viafb-cosmetic-cleanup-of-function-integrated_lvds_enable.patch added to -mm tree
Date: Mon, 07 Dec 2009 13:32:37 -0800
Message-ID: <200912072132.nB7LWbHl002016@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48223 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935592AbZLGVdN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Dec 2009 16:33:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laforge@gnumonks.org, FlorianSchandinat@gmx.de, HaraldWelte@viatech.com, JosephChan@via.com.tw, ScottFang@viatech.com.cn, krzysztof.h1@poczta.fm


The patch titled
     viafb: cosmetic cleanup of function integrated_lvds_enable()
has been added to the -mm tree.  Its filename is
     viafb-cosmetic-cleanup-of-function-integrated_lvds_enable.patch

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
Subject: viafb: cosmetic cleanup of function integrated_lvds_enable()
From: Harald Welte <laforge@gnumonks.org>

A humble attempt to simplify the coding style to improve readability

Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/lcd.c |   40 +++++++++++++-------------------------
 1 file changed, 14 insertions(+), 26 deletions(-)

diff -puN drivers/video/via/lcd.c~viafb-cosmetic-cleanup-of-function-integrated_lvds_enable drivers/video/via/lcd.c
--- a/drivers/video/via/lcd.c~viafb-cosmetic-cleanup-of-function-integrated_lvds_enable
+++ a/drivers/video/via/lcd.c
@@ -1134,45 +1134,33 @@ static void integrated_lvds_enable(struc
 			    *plvds_setting_info,
 			    struct lvds_chip_information *plvds_chip_info)
 {
-	bool turn_on_first_powersequence = false;
-	bool turn_on_second_powersequence = false;
-
 	DEBUG_MSG(KERN_INFO "integrated_lvds_enable, out_interface:%d\n",
 		  plvds_chip_info->output_interface);
 	if (plvds_setting_info->lcd_mode == LCD_SPWG)
 		viafb_write_reg_mask(CRD2, VIACR, 0x00, BIT0 + BIT1);
-	 else
+	else
 		viafb_write_reg_mask(CRD2, VIACR, 0x03, BIT0 + BIT1);
-	if (INTERFACE_LVDS0LVDS1 == plvds_chip_info->output_interface)
-		turn_on_first_powersequence = true;
-	if (INTERFACE_LVDS0 == plvds_chip_info->output_interface)
-		turn_on_first_powersequence = true;
-	if (INTERFACE_LVDS1 == plvds_chip_info->output_interface)
-		turn_on_second_powersequence = true;
-
-	if (turn_on_second_powersequence) {
-		/* Use second power sequence control: */
-
-		/* Use hardware control power sequence. */
-		viafb_write_reg_mask(CRD3, VIACR, 0, BIT0);
-
-		/* Turn on back light. */
-		viafb_write_reg_mask(CRD3, VIACR, 0, BIT6 + BIT7);
 
-		/* Turn on hardware power sequence. */
-		viafb_write_reg_mask(CRD4, VIACR, 0x02, BIT1);
-	}
-	if (turn_on_first_powersequence) {
+	switch (plvds_chip_info->output_interface) {
+	case INTERFACE_LVDS0LVDS1:
+	case INTERFACE_LVDS0:
 		/* Use first power sequence control: */
-
 		/* Use hardware control power sequence. */
 		viafb_write_reg_mask(CR91, VIACR, 0, BIT0);
-
 		/* Turn on back light. */
 		viafb_write_reg_mask(CR91, VIACR, 0, BIT6 + BIT7);
