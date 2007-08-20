From: akpm@linux-foundation.org
Subject: + cyber2000fb-rename-bit-macro.patch added to -mm tree
Date: Mon, 20 Aug 2007 13:42:24 -0700
Message-ID: <200708202042.l7KKgOKq022229@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33117 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751583AbXHTUp5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 16:45:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, adaplas@pol.net, rmk@arm.linux.org.uk


The patch titled
     cyber2000fb, rename BIT macro
has been added to the -mm tree.  Its filename is
     cyber2000fb-rename-bit-macro.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cyber2000fb, rename BIT macro
From: Jiri Slaby <jirislaby@gmail.com>

cyber2000fb, rename BIT macro

BIT will be global macro for (1 << x)

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cyber2000fb.c |   44 +++++++++++++++++-----------------
 1 files changed, 22 insertions(+), 22 deletions(-)

diff -puN drivers/video/cyber2000fb.c~cyber2000fb-rename-bit-macro drivers/video/cyber2000fb.c
--- a/drivers/video/cyber2000fb.c~cyber2000fb-rename-bit-macro
+++ a/drivers/video/cyber2000fb.c
@@ -550,7 +550,7 @@ cyber2000fb_decode_crtc(struct par_info 
 {
 	u_int Htotal, Hblankend, Hsyncend;
 	u_int Vtotal, Vdispend, Vblankstart, Vblankend, Vsyncstart, Vsyncend;
-#define BIT(v,b1,m,b2) (((v >> b1) & m) << b2)
+#define ENCODE_BIT(v,b1,m,b2) (((v >> b1) & m) << b2)
 
 	hw->crtc[13] = hw->pitch;
 	hw->crtc[17] = 0xe3;
@@ -570,13 +570,13 @@ cyber2000fb_decode_crtc(struct par_info 
 
 	Hblankend   = (Htotal - 4*8) >> 3;
 
-	hw->crtc[3] = BIT(Hblankend,  0, 0x1f,  0) |
-		      BIT(1,          0, 0x01,  7);
+	hw->crtc[3] = ENCODE_BIT(Hblankend,  0, 0x1f,  0) |
+		      ENCODE_BIT(1,          0, 0x01,  7);
 
 	Hsyncend    = (var->xres + var->right_margin + var->hsync_len) >> 3;
 
-	hw->crtc[5] = BIT(Hsyncend,   0, 0x1f,  0) |
-		      BIT(Hblankend,  5, 0x01,  7);
+	hw->crtc[5] = ENCODE_BIT(Hsyncend,   0, 0x1f,  0) |
+		      ENCODE_BIT(Hblankend,  5, 0x01,  7);
 
 	Vdispend    = var->yres - 1;
 	Vsyncstart  = var->yres + var->lower_margin;
@@ -591,20 +591,20 @@ cyber2000fb_decode_crtc(struct par_info 
 	Vblankend   = Vtotal - 10;
 
 	hw->crtc[6]  = Vtotal;
-	hw->crtc[7]  = BIT(Vtotal,     8, 0x01,  0) |
-			BIT(Vdispend,   8, 0x01,  1) |
-			BIT(Vsyncstart, 8, 0x01,  2) |
-			BIT(Vblankstart,8, 0x01,  3) |
-			BIT(1,          0, 0x01,  4) |
-	        	BIT(Vtotal,     9, 0x01,  5) |
-			BIT(Vdispend,   9, 0x01,  6) |
-			BIT(Vsyncstart, 9, 0x01,  7);
-	hw->crtc[9]  = BIT(0,          0, 0x1f,  0) |
-		        BIT(Vblankstart,9, 0x01,  5) |
-			BIT(1,          0, 0x01,  6);
+	hw->crtc[7]  = ENCODE_BIT(Vtotal,     8, 0x01,  0) |
+			ENCODE_BIT(Vdispend,   8, 0x01,  1) |
+			ENCODE_BIT(Vsyncstart, 8, 0x01,  2) |
+			ENCODE_BIT(Vblankstart,8, 0x01,  3) |
+			ENCODE_BIT(1,          0, 0x01,  4) |
+	        	ENCODE_BIT(Vtotal,     9, 0x01,  5) |
+			ENCODE_BIT(Vdispend,   9, 0x01,  6) |
+			ENCODE_BIT(Vsyncstart, 9, 0x01,  7);
+	hw->crtc[9]  = ENCODE_BIT(0,          0, 0x1f,  0) |
+		        ENCODE_BIT(Vblankstart,9, 0x01,  5) |
+			ENCODE_BIT(1,          0, 0x01,  6);
 	hw->crtc[10] = Vsyncstart;
-	hw->crtc[11] = BIT(Vsyncend,   0, 0x0f,  0) |
-		       BIT(1,          0, 0x01,  7);
+	hw->crtc[11] = ENCODE_BIT(Vsyncend,   0, 0x0f,  0) |
+		       ENCODE_BIT(1,          0, 0x01,  7);
 	hw->crtc[12] = Vdispend;
 	hw->crtc[15] = Vblankstart;
 	hw->crtc[16] = Vblankend;
@@ -616,10 +616,10 @@ cyber2000fb_decode_crtc(struct par_info 
 	 * 4=LINECOMP:10 5-IVIDEO 6=FIXCNT
 	 */
 	hw->crtc_ofl =
-		BIT(Vtotal,     10, 0x01,  0) |
-		BIT(Vdispend,   10, 0x01,  1) |
-		BIT(Vsyncstart, 10, 0x01,  2) |
-		BIT(Vblankstart,10, 0x01,  3) |
+		ENCODE_BIT(Vtotal,     10, 0x01,  0) |
+		ENCODE_BIT(Vdispend,   10, 0x01,  1) |
+		ENCODE_BIT(Vsyncstart, 10, 0x01,  2) |
+		ENCODE_BIT(Vblankstart,10, 0x01,  3) |
 		EXT_CRT_VRTOFL_LINECOMP10;
 
 	/* woody: set the interlaced bit... */
_

Patches currently in -mm which might be from jirislaby@gmail.com are

net-add-ath5k-wireless-driver.patch
net-add-ath5k-wireless-driver-fix.patch
epcac-reformat-comments-and-coding-style-improvements.patch
char-mxser_new-upgrade-to-110.patch
char-mxser_new-move-to-pci_vdevice.patch
char-mxser_new-remove-useless-comments-in-mxser_cards.patch
char-moxa-fix-and-optimise-empty-timer.patch
char-cyclades-remove-bottom-half-processing.patch
char-cyclades-make-the-isr-code-readable.patch
char-cyclades-move-spin_lock-to-one-place.patch
char-cyclades-fix-some-w-warnings.patch
fs-select-remove-unused-macros.patch
cyber2000fb-rename-bit-macro.patch
i2c-pxa-rename-bit-macro-to-pxa_bit.patch
s2io-rename-bit-macro.patch
amba-pl011-rename-bit-macro.patch
define-first-set-of-bit-macros.patch
get-rid-of-input-bit-duplicate-defines.patch
define-global-bit-macro.patch
flashpoint-use-bit-instead-of-bitw.patch
shrink_slab-handle-bad-shrinkers.patch
