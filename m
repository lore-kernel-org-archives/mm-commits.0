From: akpm@linux-foundation.org
Subject: - atmel_lcdfb-wiring-bgr-to-rgb-color-mode.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:58:41 -0700
Message-ID: <200804282158.m3SLwfvB018510@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60121 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965436AbYD1V66 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:58:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.ferre@atmel.com, adaplas@pol.net, avictor.za@gmail.com, dbrownell@users.sourceforge.net, hcegtvedt@atmel.com, hskinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     atmel_lcdfb: wiring BGR to RGB color mode
has been removed from the -mm tree.  Its filename was
     atmel_lcdfb-wiring-bgr-to-rgb-color-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_lcdfb: wiring BGR to RGB color mode
From: Nicolas Ferre <nicolas.ferre@atmel.com>

Adds different wiring mode for the LCD screen.

The legacy atmel LCDC IP uses a non standard color mode, "BGR-555.1" instead
"RGB-565".  The major part of graphic stacks for embedded systems uses only
"RGB-565".  It is possible to swap LCD IOs instead of doing this bit swapping
by software (See application note AT91SAM9 LCD Controller
http://www.atmel.com/dyn/resources/prod_documents/doc6300.pdf)

This wire swapping is done on the at91sam9rl-ek board (board code
using this patch will come later).

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Andrew Victor <avictor.za@gmail.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/atmel_lcdfb.c |   27 ++++++++++++++++++++++-----
 include/video/atmel_lcdc.h  |   10 ++++++++++
 2 files changed, 32 insertions(+), 5 deletions(-)

diff -puN drivers/video/atmel_lcdfb.c~atmel_lcdfb-wiring-bgr-to-rgb-color-mode drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c~atmel_lcdfb-wiring-bgr-to-rgb-color-mode
+++ a/drivers/video/atmel_lcdfb.c
@@ -338,19 +338,35 @@ static int atmel_lcdfb_check_var(struct 
 		break;
 	case 15:
 	case 16:
-		var->red.offset = 0;
+		if (sinfo->lcd_wiring_mode == ATMEL_LCDC_WIRING_RGB) {
+			/* RGB:565 mode */
+			var->red.offset = 11;
+			var->blue.offset = 0;
+			var->green.length = 6;
+		} else {
+			/* BGR:555 mode */
+			var->red.offset = 0;
+			var->blue.offset = 10;
+			var->green.length = 5;
+		}
 		var->green.offset = 5;
-		var->blue.offset = 10;
-		var->red.length = var->green.length = var->blue.length = 5;
+		var->red.length = var->blue.length = 5;
 		break;
 	case 32:
 		var->transp.offset = 24;
 		var->transp.length = 8;
 		/* fall through */
 	case 24:
-		var->red.offset = 0;
+		if (sinfo->lcd_wiring_mode == ATMEL_LCDC_WIRING_RGB) {
+			/* RGB:888 mode */
+			var->red.offset = 16;
+			var->blue.offset = 0;
+		} else {
+			/* BGR:888 mode */
+			var->red.offset = 0;
+			var->blue.offset = 16;
+		}
 		var->green.offset = 8;
-		var->blue.offset = 16;
 		var->red.length = var->green.length = var->blue.length = 8;
 		break;
 	default:
@@ -697,6 +713,7 @@ static int __init atmel_lcdfb_probe(stru
 		sinfo->atmel_lcdfb_power_control = pdata_sinfo->atmel_lcdfb_power_control;
 		sinfo->guard_time = pdata_sinfo->guard_time;
 		sinfo->lcdcon_is_backlight = pdata_sinfo->lcdcon_is_backlight;
+		sinfo->lcd_wiring_mode = pdata_sinfo->lcd_wiring_mode;
 	} else {
 		dev_err(dev, "cannot get default configuration\n");
 		goto free_info;
diff -puN include/video/atmel_lcdc.h~atmel_lcdfb-wiring-bgr-to-rgb-color-mode include/video/atmel_lcdc.h
--- a/include/video/atmel_lcdc.h~atmel_lcdfb-wiring-bgr-to-rgb-color-mode
+++ a/include/video/atmel_lcdc.h
@@ -22,6 +22,15 @@
 #ifndef __ATMEL_LCDC_H__
 #define __ATMEL_LCDC_H__
 
+
+/* Way LCD wires are connected to the chip:
+ * Some Atmel chips use BGR color mode (instead of standard RGB)
+ * A swapped wiring onboard can bring to RGB mode.
+ */
+#define ATMEL_LCDC_WIRING_BGR	0
+#define ATMEL_LCDC_WIRING_RGB	1
+
+
  /* LCD Controller info data structure, stored in device platform_data */
 struct atmel_lcdfb_info {
 	spinlock_t		lock;
@@ -42,6 +51,7 @@ struct atmel_lcdfb_info {
 	u8			saved_lcdcon;
 
 	u8			default_bpp;
+	u8			lcd_wiring_mode;
 	unsigned int		default_lcdcon2;
 	unsigned int		default_dmacon;
 	void (*atmel_lcdfb_power_control)(int on);
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

origin.patch

