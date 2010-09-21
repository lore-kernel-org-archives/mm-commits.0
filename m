From: akpm@linux-foundation.org
Subject: + viafb-limit-lcd-code-impact.patch added to -mm tree
Date: Tue, 21 Sep 2010 15:37:05 -0700
Message-ID: <201009212237.o8LMb5wC006778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751749Ab0IUWhm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 18:37:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, corbet@lwn.net


The patch titled
     viafb: limit LCD code impact
has been added to the -mm tree.  Its filename is
     viafb-limit-lcd-code-impact.patch

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
Subject: viafb: limit LCD code impact
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Clean the LCD code up.  Forbid overwritting global decisions like what IGA
should be used as the source and whether to enable the second display
channel.  Additionally it removes a bit code duplication.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/lcd.c |   31 -------------------------------
 1 file changed, 31 deletions(-)

diff -puN drivers/video/via/lcd.c~viafb-limit-lcd-code-impact drivers/video/via/lcd.c
--- a/drivers/video/via/lcd.c~viafb-limit-lcd-code-impact
+++ a/drivers/video/via/lcd.c
@@ -818,19 +818,12 @@ void viafb_lcd_disable(void)
 		viafb_write_reg_mask(SR3D, VIASR, 0x00, 0x20);
 		/* 24 bit DI data paht off */
 		viafb_write_reg_mask(CR91, VIACR, 0x80, 0x80);
-		/* Simultaneout disabled   */
-		viafb_write_reg_mask(CR6B, VIACR, 0x00, 0x08);
 	}
 
 	/* Disable expansion bit   */
 	viafb_write_reg_mask(CR79, VIACR, 0x00, 0x01);
-	/* CRT path set to IGA1    */
-	viafb_write_reg_mask(SR16, VIASR, 0x00, 0x40);
 	/* Simultaneout disabled   */
 	viafb_write_reg_mask(CR6B, VIACR, 0x00, 0x08);
-	/* IGA2 path disabled      */
-	viafb_write_reg_mask(CR6A, VIACR, 0x00, 0x80);
-
 }
 
 static void set_lcd_output_path(int set_iga, int output_interface)
@@ -892,33 +885,9 @@ void viafb_lcd_enable(void)
 		viafb_write_reg_mask(SR3D, VIASR, 0x20, 0x20);
 		/* 24 bit DI data paht on  */
 		viafb_write_reg_mask(CR91, VIACR, 0x00, 0x80);
-
-		/* Set data source selection bit by iga path */
-		if (viaparinfo->lvds_setting_info->iga_path == IGA1) {
-			/* DFP-H set to IGA1       */
-			viafb_write_reg_mask(CR97, VIACR, 0x00, 0x10);
-			/* DFP-L set to IGA1       */
-			viafb_write_reg_mask(CR99, VIACR, 0x00, 0x10);
-		} else {
-			/* DFP-H set to IGA2       */
-			viafb_write_reg_mask(CR97, VIACR, 0x10, 0x10);
-			/* DFP-L set to IGA2       */
-			viafb_write_reg_mask(CR99, VIACR, 0x10, 0x10);
-		}
 		/* LCD enabled             */
 		viafb_write_reg_mask(CR6A, VIACR, 0x48, 0x48);
 	}
-
-	if (viaparinfo->lvds_setting_info->iga_path == IGA1) {
-		/* CRT path set to IGA2    */
-		viafb_write_reg_mask(SR16, VIASR, 0x40, 0x40);
-		/* IGA2 path disabled      */
-		viafb_write_reg_mask(CR6A, VIACR, 0x00, 0x80);
-		/* IGA2 path enabled       */
-	} else {		/* IGA2 */
-		viafb_write_reg_mask(CR6A, VIACR, 0x80, 0x80);
-	}
