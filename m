From: akpm@linux-foundation.org
Subject: - video-superh-mobile-lcdc-driver-update.patch removed from -mm tree
Date: Wed, 23 Jul 2008 16:37:39 -0700
Message-ID: <200807232350.m6NNoHAK018650@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752026AbYGWXuc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:50:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: magnus.damm@gmail.com, damm@igel.co.jp, krzysztof.h1@poczta.fm, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     video-superh-mobile-lcdc-driver update
has been removed from the -mm tree.  Its filename was
     video-superh-mobile-lcdc-driver-update.patch

This patch was dropped because it was folded into video-superh-mobile-lcdc-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: video-superh-mobile-lcdc-driver update
From: Magnus Damm <magnus.damm@gmail.com>

  - updated license header
  - improved polling code to use cpu_relax()
  - introduced lcdc_wait_bit()
  - added lcdc_chan_is_sublcd() function
  - broke out start and stop code

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Cc: Paul Mundt <lethal@linux-sh.org>
Reviewed-by: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sh_mobile_lcdcfb.c |  147 ++++++++++++-----------------
 1 file changed, 65 insertions(+), 82 deletions(-)

diff -puN drivers/video/sh_mobile_lcdcfb.c~video-superh-mobile-lcdc-driver-update drivers/video/sh_mobile_lcdcfb.c
--- a/drivers/video/sh_mobile_lcdcfb.c~video-superh-mobile-lcdc-driver-update
+++ a/drivers/video/sh_mobile_lcdcfb.c
@@ -3,18 +3,9 @@
  *
  * Copyright (c) 2008 Magnus Damm
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
  */
 
 #include <linux/kernel.h>
@@ -49,7 +40,6 @@ struct sh_mobile_lcdc_priv {
 };
 
 /* shared registers */
-
 #define _LDDCKR 0x410
 #define _LDDCKSTPR 0x414
 #define _LDINTR 0x468
@@ -63,7 +53,6 @@ struct sh_mobile_lcdc_priv {
 #define _LDDRAR 0x904
 
 /* per-channel registers */
-
 enum { LDDCKPAT1R, LDDCKPAT2R, LDMT1R, LDMT2R, LDMT3R, LDDFR, LDSM1R,
        LDSA1R, LDMLSR, LDHCNR, LDHSYNR, LDVLNR, LDVSYNR, LDPMR };
 
@@ -119,7 +108,7 @@ static unsigned long lcdc_read_chan(stru
 }
 
 static void lcdc_write(struct sh_mobile_lcdc_priv *priv,
-		       int reg_offs, unsigned long data)
+		       unsigned long reg_offs, unsigned long data)
 {
 	iowrite32(data, priv->base + reg_offs);
 }
@@ -130,19 +119,26 @@ static unsigned long lcdc_read(struct sh
 	return ioread32(priv->base + reg_offs);
 }
 
+static void lcdc_wait_bit(struct sh_mobile_lcdc_priv *priv,
+			  unsigned long reg_offs,
+			  unsigned long mask, unsigned long until)
+{
+	while ((lcdc_read(priv, reg_offs) & mask) != until)
+		cpu_relax();
+}
+
+static int lcdc_chan_is_sublcd(struct sh_mobile_lcdc_chan *chan)
+{
+	return chan->cfg.chan == LCDC_CHAN_SUBLCD;
+}
+
 static void lcdc_sys_write_index(void *handle, unsigned long data)
 {
 	struct sh_mobile_lcdc_chan *ch = handle;
 
 	lcdc_write(ch->lcdc, _LDDWD0R, data | 0x10000000);
-
-	while (lcdc_read(ch->lcdc, _LDSR) & 2)
-	  ;
-
-	if (ch->cfg.chan == LCDC_CHAN_SUBLCD)
-		lcdc_write(ch->lcdc, _LDDWAR, 3);
-	else
-		lcdc_write(ch->lcdc, _LDDWAR, 1);
+	lcdc_wait_bit(ch->lcdc, _LDSR, 2, 0);
+	lcdc_write(ch->lcdc, _LDDWAR, 1 | (lcdc_chan_is_sublcd(ch) ? 2 : 0));
 }
 
 static void lcdc_sys_write_data(void *handle, unsigned long data)
@@ -150,14 +146,8 @@ static void lcdc_sys_write_data(void *ha
 	struct sh_mobile_lcdc_chan *ch = handle;
 
 	lcdc_write(ch->lcdc, _LDDWD0R, data | 0x11000000);
-
-	while (lcdc_read(ch->lcdc, _LDSR) & 2)
-	  ;
-
-	if (ch->cfg.chan == LCDC_CHAN_SUBLCD)
-		lcdc_write(ch->lcdc, _LDDWAR, 3);
-	else
-		lcdc_write(ch->lcdc, _LDDWAR, 1);
+	lcdc_wait_bit(ch->lcdc, _LDSR, 2, 0);
+	lcdc_write(ch->lcdc, _LDDWAR, 1 | (lcdc_chan_is_sublcd(ch) ? 2 : 0));
 }
 
 static unsigned long lcdc_sys_read_data(void *handle)
@@ -165,15 +155,8 @@ static unsigned long lcdc_sys_read_data(
 	struct sh_mobile_lcdc_chan *ch = handle;
 
 	lcdc_write(ch->lcdc, _LDDRDR, 0x01000000);
-
-	while (lcdc_read(ch->lcdc, _LDSR) & 2)
-	  ;
-
-	if (ch->cfg.chan == LCDC_CHAN_SUBLCD)
-		lcdc_write(ch->lcdc, _LDDRAR, 3);
-	else
-		lcdc_write(ch->lcdc, _LDDRAR, 1);
-
+	lcdc_wait_bit(ch->lcdc, _LDSR, 2, 0);
+	lcdc_write(ch->lcdc, _LDDRAR, 1 | (lcdc_chan_is_sublcd(ch) ? 2 : 0));
 	udelay(1);
 
 	return lcdc_read(ch->lcdc, _LDDRDR) & 0xffff;
@@ -185,7 +168,35 @@ struct sh_mobile_lcdc_sys_bus_ops sh_mob
 	lcdc_sys_read_data,
 };
 
-static int sh_mobile_lcdc_start_hw(struct sh_mobile_lcdc_priv *priv)
+static void sh_mobile_lcdc_start_stop(struct sh_mobile_lcdc_priv *priv,
+				      int start)
+{
+	unsigned long tmp = lcdc_read(priv, _LDCNT2R);
+	int k;
+
+	/* start or stop the lcdc */
+	if (start)
+		lcdc_write(priv, _LDCNT2R, tmp | START_LCDC);
+	else
+		lcdc_write(priv, _LDCNT2R, tmp & ~START_LCDC);
+
+	/* wait until power is applied/stopped on all channels */
+	for (k = 0; k < ARRAY_SIZE(priv->ch); k++)
+		if (lcdc_read(priv, _LDCNT2R) & priv->ch[k].enabled)
+			while (1) {
+				tmp = lcdc_read_chan(&priv->ch[k], LDPMR) & 3;
+				if (start && tmp == 3)
+					break;
+				if (!start && tmp == 0)
+					break;
+				cpu_relax();
+			}
+
+	if (!start)
+		lcdc_write(priv, _LDDCKSTPR, 1); /* stop dotclock */
+}
+
+static int sh_mobile_lcdc_start(struct sh_mobile_lcdc_priv *priv)
 {
 	struct sh_mobile_lcdc_chan *ch;
 	struct fb_videomode *lcd_cfg;
@@ -196,8 +207,7 @@ static int sh_mobile_lcdc_start_hw(struc
 
 	/* reset */
 	lcdc_write(priv, _LDCNT2R, lcdc_read(priv, _LDCNT2R) | LCDC_RESET);
-	while (lcdc_read(priv, _LDCNT2R) & LCDC_RESET)
-		;
+	lcdc_wait_bit(priv, _LDCNT2R, LCDC_RESET, 0);
 
 	/* enable LCDC channels */
 	tmp = lcdc_read(priv, _LDCNT2R);
@@ -208,17 +218,8 @@ static int sh_mobile_lcdc_start_hw(struc
 	/* read data from external memory, avoid using the BEU for now */
 	lcdc_write(priv, _LDCNT2R, lcdc_read(priv, _LDCNT2R) & ~DISPLAY_BEU);
 
-	/* stops the lcdc operation */
-	lcdc_write(priv, _LDCNT2R, lcdc_read(priv, _LDCNT2R) & ~START_LCDC);
-
-	/* wait until power is stopped on all channels */
-	for (k = 0; k < ARRAY_SIZE(priv->ch); k++)
-		if (lcdc_read(priv, _LDCNT2R) & priv->ch[k].enabled)
-			while (lcdc_read_chan(&priv->ch[k], LDPMR) & 3)
-				;
-
-	/* stop dotclock */
-	lcdc_write(priv, _LDDCKSTPR, 1);
+	/* stop the lcdc first */
+	sh_mobile_lcdc_start_stop(priv, 0);
 
 	/* configure clocks */
 	tmp = priv->lddckr;
@@ -234,7 +235,7 @@ static int sh_mobile_lcdc_start_hw(struc
 
 		if (m == 1)
 			m = 1 << 6;
-		tmp |= m << ((ch->cfg.chan == LCDC_CHAN_SUBLCD) ? 8 : 0);
+		tmp |= m << (lcdc_chan_is_sublcd(ch) ? 8 : 0);
 
 		lcdc_write_chan(ch, LDDCKPAT1R, 0x00000000);
 		lcdc_write_chan(ch, LDDCKPAT2R, (1 << (m/2)) - 1);
@@ -244,9 +245,7 @@ static int sh_mobile_lcdc_start_hw(struc
 
 	/* start dotclock again */
 	lcdc_write(priv, _LDDCKSTPR, 0);
-
-	while (lcdc_read(priv, _LDDCKSTPR))
-		;
+	lcdc_wait_bit(priv, _LDDCKSTPR, ~0, 0);
 
 	/* interrupts are disabled */
 	lcdc_write(priv, _LDINTR, 0);
@@ -335,14 +334,8 @@ static int sh_mobile_lcdc_start_hw(struc
 	/* display output */
 	lcdc_write(priv, _LDCNT1R, LCDC_ENABLE);
 
-	/* start the lcdc operation */
-	lcdc_write(priv, _LDCNT2R, lcdc_read(priv, _LDCNT2R) | START_LCDC);
-
-	/* wait until power is applied to all channels */
-	for (k = 0; k < ARRAY_SIZE(priv->ch); k++)
-		if (lcdc_read(priv, _LDCNT2R) & priv->ch[k].enabled)
-			while (!(lcdc_read_chan(&priv->ch[k], LDPMR) & 3))
-				;
+	/* start the lcdc */
+	sh_mobile_lcdc_start_stop(priv, 1);
 
 	/* tell the board code to enable the panel */
 	for (k = 0; k < ARRAY_SIZE(priv->ch); k++) {
@@ -355,7 +348,7 @@ static int sh_mobile_lcdc_start_hw(struc
 	return 0;
 }
 
-static void sh_mobile_lcdc_stop_hw(struct sh_mobile_lcdc_priv *priv)
+static void sh_mobile_lcdc_stop(struct sh_mobile_lcdc_priv *priv)
 {
 	struct sh_mobile_lcdc_chan *ch;
 	struct sh_mobile_lcdc_board_cfg	*board_cfg;
@@ -369,18 +362,8 @@ static void sh_mobile_lcdc_stop_hw(struc
 			board_cfg->display_off(board_cfg->board_data);
 	}
 
-	/* stops the lcdc operation */
-	lcdc_write(priv, _LDCNT2R, lcdc_read(priv, _LDCNT2R) & ~START_LCDC);
-
-	/* wait until power is stopped on all channels */
-	for (k = 0; k < ARRAY_SIZE(priv->ch); k++)
-		if (lcdc_read(priv, _LDCNT2R) & priv->ch[k].enabled)
-			while (lcdc_read_chan(&priv->ch[k], LDPMR) & 3)
-				;
-
-	/* stop dotclock */
-	lcdc_write(priv, _LDDCKSTPR, 1);
-
+	/* stop the lcdc */
+	sh_mobile_lcdc_start_stop(priv, 0);
 }
 
 static int sh_mobile_lcdc_check_interface(struct sh_mobile_lcdc_chan *ch)
@@ -410,7 +393,7 @@ static int sh_mobile_lcdc_check_interfac
 	}
 
 	/* SUBLCD only supports SYS interface */
-	if (ch->cfg.chan == LCDC_CHAN_SUBLCD) {
+	if (lcdc_chan_is_sublcd(ch)) {
 		if (ifm == 0)
 			goto bad;
 		else
@@ -649,7 +632,7 @@ static int __init sh_mobile_lcdc_probe(s
 	if (error)
 		goto err1;
 
-	error = sh_mobile_lcdc_start_hw(priv);
+	error = sh_mobile_lcdc_start(priv);
 	if (error) {
 		dev_err(&pdev->dev, "unable to start hardware\n");
 		goto err1;
@@ -690,7 +673,7 @@ static int sh_mobile_lcdc_remove(struct 
 		if (priv->ch[i].info.dev)
 			unregister_framebuffer(&priv->ch[i].info);
 
-	sh_mobile_lcdc_stop_hw(priv);
+	sh_mobile_lcdc_stop(priv);
 
 	for (i = 0; i < ARRAY_SIZE(priv->ch); i++) {
 		info = &priv->ch[i].info;
_

Patches currently in -mm which might be from magnus.damm@gmail.com are

origin.patch
video-superh-mobile-lcdc-driver.patch
video-superh-mobile-lcdc-driver-update.patch

