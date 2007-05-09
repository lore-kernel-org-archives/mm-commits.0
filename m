From: akpm@linux-foundation.org
Subject: - cirrusfb-convert-to-generic-boolean.patch removed from -mm tree
Date: Tue, 08 May 2007 20:00:39 -0700
Message-ID: <200705090300.l4930doR010593@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032889AbXEIDAr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:00:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ricknu-0@student.ltu.se, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     cirrusfb: convert to generic boolean
has been removed from the -mm tree.  Its filename was
     cirrusfb-convert-to-generic-boolean.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cirrusfb: convert to generic boolean
From: Richard Knutsson <ricknu-0@student.ltu.se>

Convert to generic boolean.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
DESC
sm501fb-printk-warning-fixes
EDESC

drivers/video/sm501fb.c: In function 'sm501fb_cursor':
drivers/video/sm501fb.c:992: warning: format '%08x' expects type 'unsigned int', but argument 3 has type 'long unsigned int'
drivers/video/sm501fb.c:992: warning: format '%08x' expects type 'unsigned int', but argument 4 has type 'long unsigned int'

Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |   69 ++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 39 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-convert-to-generic-boolean drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-convert-to-generic-boolean
+++ a/drivers/video/cirrusfb.c
@@ -98,15 +98,6 @@
 #define assert(expr)
 #endif
 
-#ifdef TRUE
-#undef TRUE
-#endif
-#ifdef FALSE
-#undef FALSE
-#endif
-#define TRUE  1
-#define FALSE 0
-
 #define MB_ (1024*1024)
 #define KB_ (1024)
 
@@ -146,9 +137,9 @@ static const struct cirrusfb_board_info_
 	char *name;		/* ASCII name of chipset */
 	long maxclock[5];		/* maximum video clock */
 	/* for  1/4bpp, 8bpp 15/16bpp, 24bpp, 32bpp - numbers from xorg code */
-	unsigned init_sr07 : 1;	/* init SR07 during init_vgachip() */
-	unsigned init_sr1f : 1; /* write SR1F during init_vgachip() */
-	unsigned scrn_start_bit19 : 1; /* construct bit 19 of screen start address */
+	bool init_sr07 : 1; /* init SR07 during init_vgachip() */
+	bool init_sr1f : 1; /* write SR1F during init_vgachip() */
+	bool scrn_start_bit19 : 1; /* construct bit 19 of screen start address */
 
 	/* initial SR07 value, then for each mode */
 	unsigned char sr07;
@@ -166,9 +157,9 @@ static const struct cirrusfb_board_info_
 			/* the SD64/P4 have a higher max. videoclock */
 			140000, 140000, 140000, 140000, 140000,
 		},
-		.init_sr07		= TRUE,
-		.init_sr1f		= TRUE,
-		.scrn_start_bit19	= TRUE,
+		.init_sr07		= true,
+		.init_sr1f		= true,
+		.scrn_start_bit19	= true,
 		.sr07			= 0xF0,
 		.sr07_1bpp		= 0xF0,
 		.sr07_8bpp		= 0xF1,
@@ -180,9 +171,9 @@ static const struct cirrusfb_board_info_
 			/* guess */
 			90000, 90000, 90000, 90000, 90000
 		},
-		.init_sr07		= TRUE,
-		.init_sr1f		= TRUE,
-		.scrn_start_bit19	= FALSE,
+		.init_sr07		= true,
+		.init_sr1f		= true,
+		.scrn_start_bit19	= false,
 		.sr07			= 0x80,
 		.sr07_1bpp		= 0x80,
 		.sr07_8bpp		= 0x81,
@@ -194,9 +185,9 @@ static const struct cirrusfb_board_info_
 			/* guess */
 			90000, 90000, 90000, 90000, 90000
 		},
-		.init_sr07		= TRUE,
-		.init_sr1f		= TRUE,
-		.scrn_start_bit19	= FALSE,
+		.init_sr07		= true,
+		.init_sr1f		= true,
+		.scrn_start_bit19	= false,
 		.sr07			= 0x20,
 		.sr07_1bpp		= 0x20,
 		.sr07_8bpp		= 0x21,
@@ -208,9 +199,9 @@ static const struct cirrusfb_board_info_
 			/* guess */
 			90000, 90000, 90000, 90000, 90000
 		},
-		.init_sr07		= TRUE,
-		.init_sr1f		= TRUE,
-		.scrn_start_bit19	= FALSE,
+		.init_sr07		= true,
+		.init_sr1f		= true,
+		.scrn_start_bit19	= false,
 		.sr07			= 0x80,
 		.sr07_1bpp		= 0x80,
 		.sr07_8bpp		= 0x81,
@@ -221,9 +212,9 @@ static const struct cirrusfb_board_info_
 		.maxclock		= {
 			135100, 135100, 85500, 85500, 0
 		},
-		.init_sr07		= TRUE,
-		.init_sr1f		= FALSE,
-		.scrn_start_bit19	= TRUE,
+		.init_sr07		= true,
+		.init_sr1f		= false,
+		.scrn_start_bit19	= true,
 		.sr07			= 0x20,
 		.sr07_1bpp		= 0x20,
 		.sr07_8bpp		= 0x21,
@@ -235,9 +226,9 @@ static const struct cirrusfb_board_info_
 			/* for the GD5430.  GD5446 can do more... */
 			85500, 85500, 50000, 28500, 0
 		},
-		.init_sr07		= TRUE,
-		.init_sr1f		= TRUE,
-		.scrn_start_bit19	= TRUE,
+		.init_sr07		= true,
+		.init_sr1f		= true,
+		.scrn_start_bit19	= true,
 		.sr07			= 0xA0,
 		.sr07_1bpp		= 0xA1,
 		.sr07_1bpp_mux		= 0xA7,
@@ -250,9 +241,9 @@ static const struct cirrusfb_board_info_
 		.maxclock		= {
 			135100, 200000, 200000, 135100, 135100
 		},
-		.init_sr07		= TRUE,
-		.init_sr1f		= TRUE,
-		.scrn_start_bit19	= TRUE,
+		.init_sr07		= true,
+		.init_sr1f		= true,
+		.scrn_start_bit19	= true,
 		.sr07			= 0x10,
 		.sr07_1bpp		= 0x11,
 		.sr07_8bpp		= 0x11,
@@ -264,9 +255,9 @@ static const struct cirrusfb_board_info_
 			/* guess */
 			135100, 135100, 135100, 135100, 135100,
 		},
-		.init_sr07		= FALSE,
-		.init_sr1f		= FALSE,
-		.scrn_start_bit19	= TRUE,
+		.init_sr07		= false,
+		.init_sr1f		= false,
+		.scrn_start_bit19	= true,
 	}
 };
 
@@ -815,7 +806,7 @@ static int cirrusfb_check_var(struct fb_
 
 	default:
 		DPRINTK("Unsupported bpp size: %d\n", var->bits_per_pixel);
-		assert (FALSE);
+		assert(false);
 		/* should never occur */
 		break;
 	}
@@ -886,7 +877,7 @@ static int cirrusfb_decode_var (const st
 
 	default:
 		DPRINTK("Unsupported bpp size: %d\n", var->bits_per_pixel);
-		assert (FALSE);
+		assert(false);
 		/* should never occur */
 		break;
 	}
@@ -3203,7 +3194,7 @@ void cirrusfb_dbg_print_regs (caddr_t re
 			break;
 		default:
 			/* should never occur */
-			assert (FALSE);
+			assert(false);
 			break;
 		}
 
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se are

origin.patch
