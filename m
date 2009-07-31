From: akpm@linux-foundation.org
Subject: + viafb-remove-duplicated-cx700-register-init.patch added to -mm tree
Date: Thu, 30 Jul 2009 17:42:28 -0700
Message-ID: <200907310042.n6V0gThg020496@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750745AbZGaAnU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 20:43:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn


The patch titled
     viafb: remove duplicated CX700 register init
has been added to the -mm tree.  Its filename is
     viafb-remove-duplicated-cx700-register-init.patch

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
Subject: viafb: remove duplicated CX700 register init
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

The current code initializes the register for CX700 chips 2 times due to a
missing break as discovered by Harald Welte.

As CX700 and VX800 have exactly the same register initialization we can
use one for both to avoid duplicated code.

As this is a pure code cleanup no measurable runtime effects are expected.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/hw.c      |    5 --
 drivers/video/via/viamode.c |   61 ----------------------------------
 drivers/video/via/viamode.h |    1 
 3 files changed, 1 insertion(+), 66 deletions(-)

diff -puN drivers/video/via/hw.c~viafb-remove-duplicated-cx700-register-init drivers/video/via/hw.c
--- a/drivers/video/via/hw.c~viafb-remove-duplicated-cx700-register-init
+++ a/drivers/video/via/hw.c
@@ -2271,11 +2271,8 @@ int viafb_setmode(int vmode_index, int h
 		break;
 
 	case UNICHROME_CX700:
-		viafb_write_regx(CX700_ModeXregs, NUM_TOTAL_CX700_ModeXregs);
-
 	case UNICHROME_VX800:
-		viafb_write_regx(VX800_ModeXregs, NUM_TOTAL_VX800_ModeXregs);
-
+		viafb_write_regx(CX700_ModeXregs, NUM_TOTAL_CX700_ModeXregs);
 		break;
 	}
 
diff -puN drivers/video/via/viamode.c~viafb-remove-duplicated-cx700-register-init drivers/video/via/viamode.c
--- a/drivers/video/via/viamode.c~viafb-remove-duplicated-cx700-register-init
+++ a/drivers/video/via/viamode.c
@@ -329,67 +329,6 @@ struct io_reg CX700_ModeXregs[] = { {VIA
 {VIACR, CRD2, 0xFF, 0xFF}	/* TMDS/LVDS control register.         */
 };
 
-/* For VT3353: Common Setting for Video Mode */
-struct io_reg VX800_ModeXregs[] = { {VIASR, SR10, 0xFF, 0x01},
-{VIASR, SR15, 0x02, 0x02},
-{VIASR, SR16, 0xBF, 0x08},
-{VIASR, SR17, 0xFF, 0x1F},
-{VIASR, SR18, 0xFF, 0x4E},
-{VIASR, SR1A, 0xFB, 0x08},
-{VIASR, SR1B, 0xFF, 0xF0},
-{VIASR, SR1E, 0xFF, 0x01},
-{VIASR, SR2A, 0xFF, 0x00},
-{VIASR, SR2D, 0xFF, 0xFF},	/* VCK and LCK PLL power on.           */
-{VIACR, CR0A, 0xFF, 0x1E},	/* Cursor Start                        */
-{VIACR, CR0B, 0xFF, 0x00},	/* Cursor End                          */
-{VIACR, CR0E, 0xFF, 0x00},	/* Cursor Location High                */
-{VIACR, CR0F, 0xFF, 0x00},	/* Cursor Localtion Low                */
-{VIACR, CR32, 0xFF, 0x00},
-{VIACR, CR33, 0xFF, 0x00},
-{VIACR, CR34, 0xFF, 0x00},
-{VIACR, CR35, 0xFF, 0x00},
-{VIACR, CR36, 0x08, 0x00},
-{VIACR, CR47, 0xC8, 0x00},	/* Clear VCK Plus. */
-{VIACR, CR62, 0xFF, 0x00},	/* Secondary Display Starting Address  */
-{VIACR, CR63, 0xFF, 0x00},	/* Secondary Display Starting Address  */
-{VIACR, CR64, 0xFF, 0x00},	/* Secondary Display Starting Address  */
-{VIACR, CRA3, 0xFF, 0x00},	/* Secondary Display Starting Address  */
-{VIACR, CR69, 0xFF, 0x00},
-{VIACR, CR6A, 0xFF, 0x40},
-{VIACR, CR6B, 0xFF, 0x00},
-{VIACR, CR6C, 0xFF, 0x00},
-{VIACR, CR7A, 0xFF, 0x01},	/* LCD Scaling Parameter 1             */
-{VIACR, CR7B, 0xFF, 0x02},	/* LCD Scaling Parameter 2             */
-{VIACR, CR7C, 0xFF, 0x03},	/* LCD Scaling Parameter 3             */
-{VIACR, CR7D, 0xFF, 0x04},	/* LCD Scaling Parameter 4             */
-{VIACR, CR7E, 0xFF, 0x07},	/* LCD Scaling Parameter 5             */
-{VIACR, CR7F, 0xFF, 0x0A},	/* LCD Scaling Parameter 6             */
-{VIACR, CR80, 0xFF, 0x0D},	/* LCD Scaling Parameter 7             */
-{VIACR, CR81, 0xFF, 0x13},	/* LCD Scaling Parameter 8             */
-{VIACR, CR82, 0xFF, 0x16},	/* LCD Scaling Parameter 9             */
-{VIACR, CR83, 0xFF, 0x19},	/* LCD Scaling Parameter 10            */
-{VIACR, CR84, 0xFF, 0x1C},	/* LCD Scaling Parameter 11            */
-{VIACR, CR85, 0xFF, 0x1D},	/* LCD Scaling Parameter 12            */
-{VIACR, CR86, 0xFF, 0x1E},	/* LCD Scaling Parameter 13            */
-{VIACR, CR87, 0xFF, 0x1F},	/* LCD Scaling Parameter 14            */
-{VIACR, CR88, 0xFF, 0x40},	/* LCD Panel Type                      */
-{VIACR, CR89, 0xFF, 0x00},	/* LCD Timing Control 0                */
-{VIACR, CR8A, 0xFF, 0x88},	/* LCD Timing Control 1                */
-{VIACR, CRD4, 0xFF, 0x81},	/* Second power sequence control       */
-{VIACR, CR8B, 0xFF, 0x5D},	/* LCD Power Sequence Control 0        */
-{VIACR, CR8C, 0xFF, 0x2B},	/* LCD Power Sequence Control 1        */
-{VIACR, CR8D, 0xFF, 0x6F},	/* LCD Power Sequence Control 2        */
-{VIACR, CR8E, 0xFF, 0x2B},	/* LCD Power Sequence Control 3        */
-{VIACR, CR8F, 0xFF, 0x01},	/* LCD Power Sequence Control 4        */
-{VIACR, CR90, 0xFF, 0x01},	/* LCD Power Sequence Control 5        */
-{VIACR, CR91, 0xFF, 0x80},	/* 24/12 bit LVDS Data off             */
-{VIACR, CR96, 0xFF, 0x00},
-{VIACR, CR97, 0xFF, 0x00},
-{VIACR, CR99, 0xFF, 0x00},
-{VIACR, CR9B, 0xFF, 0x00},
-{VIACR, CRD2, 0xFF, 0xFF}	/* TMDS/LVDS control register.         */
-};
