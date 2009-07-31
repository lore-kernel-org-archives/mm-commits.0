From: akpm@linux-foundation.org
Subject: + viafb-remove-temporary-start-address-setting.patch added to -mm tree
Date: Thu, 30 Jul 2009 17:42:31 -0700
Message-ID: <200907310042.n6V0gVsS020607@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37607 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751023AbZGaAnX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 20:43:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn


The patch titled
     viafb: remove temporary start address setting
has been added to the -mm tree.  Its filename is
     viafb-remove-temporary-start-address-setting.patch

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
Subject: viafb: remove temporary start address setting
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Currently the start address is set to an initial value every time
viafb_setmode is called.

This is not done consistently along graphic cores and not even the whole
address but often only parts of it.  On top of that it seems useless as
the real/final address will be set by viafb_set_start_addr a few lines
later.

Remove this superfluous initalization to shrink register initalization and
as a start to decouple primary and secondary display.  Code cleanup, no
notable runtime change expected.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/viamode.c |   17 -----------------
 1 file changed, 17 deletions(-)

diff -puN drivers/video/via/viamode.c~viafb-remove-temporary-start-address-setting drivers/video/via/viamode.c
--- a/drivers/video/via/viamode.c~viafb-remove-temporary-start-address-setting
+++ a/drivers/video/via/viamode.c
@@ -100,12 +100,8 @@ struct io_reg CN400_ModeXregs[] = { {VIA
 {VIACR, CR0F, 0xFF, 0x00},	/* Cursor Localtion Low                */
 {VIACR, CR32, 0xFF, 0x00},
 {VIACR, CR33, 0xFF, 0x00},
-{VIACR, CR34, 0xFF, 0x00},
 {VIACR, CR35, 0xFF, 0x00},
 {VIACR, CR36, 0x08, 0x00},
-{VIACR, CR62, 0xFF, 0x00},	/* Secondary Display Starting Address  */
-{VIACR, CR63, 0xFF, 0x00},	/* Secondary Display Starting Address  */
-{VIACR, CR64, 0xFF, 0x00},	/* Secondary Display Starting Address  */
 {VIACR, CR69, 0xFF, 0x00},
 {VIACR, CR6A, 0xFF, 0x40},
 {VIACR, CR6B, 0xFF, 0x00},
@@ -159,16 +155,12 @@ struct io_reg CN700_ModeXregs[] = { {VIA
 {VIASR, CR30, 0xFF, 0x04},
 {VIACR, CR32, 0xFF, 0x00},
 {VIACR, CR33, 0x7F, 0x00},
-{VIACR, CR34, 0xFF, 0x00},
 {VIACR, CR35, 0xFF, 0x00},
 {VIACR, CR36, 0xFF, 0x31},
 {VIACR, CR41, 0xFF, 0x80},
 {VIACR, CR42, 0xFF, 0x00},
 {VIACR, CR55, 0x80, 0x00},
 {VIACR, CR5D, 0x80, 0x00},	/*Horizontal Retrace Start bit[11] should be 0*/
-{VIACR, CR62, 0xFF, 0x00},	/* Secondary Display Starting Address */
-{VIACR, CR63, 0xFF, 0x00},	/* Secondary Display Starting Address */
-{VIACR, CR64, 0xFF, 0x00},	/* Secondary Display Starting Address */
 {VIACR, CR68, 0xFF, 0x67},	/* Default FIFO For IGA2 */
 {VIACR, CR69, 0xFF, 0x00},
 {VIACR, CR6A, 0xFD, 0x40},
@@ -233,9 +225,6 @@ struct io_reg KM400_ModeXregs[] = {
 	{VIACR, CR55, 0x80, 0x00},
 	{VIACR, CR5D, 0x80, 0x00},
 	{VIACR, CR36, 0xFF, 0x01},	/* Power Mangement 3                  */
-	{VIACR, CR62, 0xFF, 0x00},	/* Secondary Display Starting Address */
-	{VIACR, CR63, 0xFF, 0x00},	/* Secondary Display Starting Address */
-	{VIACR, CR64, 0xFF, 0x00},	/* Secondary Display Starting Address */
 	{VIACR, CR68, 0xFF, 0x67},	/* Default FIFO For IGA2              */
 	{VIACR, CR6A, 0x20, 0x20},	/* Extended FIFO On                   */
 	{VIACR, CR7A, 0xFF, 0x01},	/* LCD Scaling Parameter 1            */
@@ -285,14 +274,9 @@ struct io_reg CX700_ModeXregs[] = { {VIA
 {VIACR, CR0F, 0xFF, 0x00},	/* Cursor Localtion Low                */
 {VIACR, CR32, 0xFF, 0x00},
 {VIACR, CR33, 0xFF, 0x00},
-{VIACR, CR34, 0xFF, 0x00},
 {VIACR, CR35, 0xFF, 0x00},
 {VIACR, CR36, 0x08, 0x00},
 {VIACR, CR47, 0xC8, 0x00},	/* Clear VCK Plus. */
-{VIACR, CR62, 0xFF, 0x00},	/* Secondary Display Starting Address  */
-{VIACR, CR63, 0xFF, 0x00},	/* Secondary Display Starting Address  */
-{VIACR, CR64, 0xFF, 0x00},	/* Secondary Display Starting Address  */
-{VIACR, CRA3, 0xFF, 0x00},	/* Secondary Display Starting Address  */
 {VIACR, CR69, 0xFF, 0x00},
 {VIACR, CR6A, 0xFF, 0x40},
 {VIACR, CR6B, 0xFF, 0x00},
@@ -340,7 +324,6 @@ struct io_reg CLE266_ModeXregs[] = { {VI
 {VIASR, SR1A, 0xFB, 0x08},
 
 {VIACR, CR32, 0xFF, 0x00},
-{VIACR, CR34, 0xFF, 0x00},
 {VIACR, CR35, 0xFF, 0x00},
 {VIACR, CR36, 0x08, 0x00},
 {VIACR, CR6A, 0xFF, 0x80},
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

viafb-fix-rmmod-bug.patch
viafb-remove-duplicated-cx700-register-init.patch
viafb-remove-temporary-start-address-setting.patch

