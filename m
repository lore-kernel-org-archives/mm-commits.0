From: akpm@linux-foundation.org
Subject: + backlight-add-s6e63m0-amoled-lcd-panel-driver-update.patch added to -mm tree
Date: Fri, 30 Apr 2010 14:04:09 -0700
Message-ID: <201004302104.o3UL49VQ013414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33865 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756650Ab0D3VEM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 17:04:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daeinki@gmail.com


The patch titled
     backlight-add-s6e63m0-amoled-lcd-panel-driver update
has been added to the -mm tree.  Its filename is
     backlight-add-s6e63m0-amoled-lcd-panel-driver-update.patch

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
Subject: backlight-add-s6e63m0-amoled-lcd-panel-driver update
From: InKi Dae <daeinki@gmail.com>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/s6e63m0.c |   72 +++++++++++++++++++++-------
 1 file changed, 54 insertions(+), 18 deletions(-)

diff -puN drivers/video/backlight/s6e63m0.c~backlight-add-s6e63m0-amoled-lcd-panel-driver-update drivers/video/backlight/s6e63m0.c
--- a/drivers/video/backlight/s6e63m0.c~backlight-add-s6e63m0-amoled-lcd-panel-driver-update
+++ a/drivers/video/backlight/s6e63m0.c
@@ -420,13 +420,25 @@ static int _s6e63m0_gamma_ctl(struct s6e
 
 	/* disable gamma table updating. */
 	ret = s6e63m0_spi_write(lcd, 0xfa, 0x00);
+	if (ret) {
+		dev_err(lcd->dev, "failed to disable gamma table updating.\n");
+		goto gamma_err;
+	}
 
-	for (i = 0 ; i < GAMMA_TABLE_COUNT; i++)
-		ret |= s6e63m0_spi_write(lcd, DATA_ONLY, gamma[i]);
+	for (i = 0 ; i < GAMMA_TABLE_COUNT; i++) {
+		ret = s6e63m0_spi_write(lcd, DATA_ONLY, gamma[i]);
+		if (ret) {
+			dev_err(lcd->dev, "failed to set gamma table.\n");
+			goto gamma_err;
+		}
+	}
 
 	/* update gamma table. */
-	ret |= s6e63m0_spi_write(lcd, 0xfa, 0x01);
+	ret = s6e63m0_spi_write(lcd, 0xfa, 0x01);
+	if (ret)
+		dev_err(lcd->dev, "failed to update gamma table.\n");
 
+gamma_err:
 	return ret;
 }
 
@@ -442,24 +454,38 @@ static int s6e63m0_gamma_ctl(struct s6e6
 
 static int s6e63m0_ldi_init(struct s6e63m0 *lcd)
 {
-	int ret;
-
-	ret = s6e63m0_panel_send_sequence(lcd, SEQ_PANEL_CONDITION_SET);
-	ret |= s6e63m0_panel_send_sequence(lcd, SEQ_DISPLAY_CONDITION_SET);
-	ret |= s6e63m0_panel_send_sequence(lcd, SEQ_GAMMA_SETTING);
-	ret |= s6e63m0_panel_send_sequence(lcd, SEQ_ETC_CONDITION_SET);
-	ret |= s6e63m0_panel_send_sequence(lcd, SEQ_ACL_ON);
-	ret |= s6e63m0_panel_send_sequence(lcd, SEQ_ELVSS_ON);
+	int ret, i;
+	const unsigned short *init_seq[] = {
+		SEQ_PANEL_CONDITION_SET,
+		SEQ_DISPLAY_CONDITION_SET,
+		SEQ_GAMMA_SETTING,
+		SEQ_ETC_CONDITION_SET,
+		SEQ_ACL_ON,
+		SEQ_ELVSS_ON,
+	};
+
+	for (i = 0; i < ARRAY_SIZE(init_seq); i++) {
+		ret = s6e63m0_panel_send_sequence(lcd, init_seq[i]);
+		if (ret)
+			break;
+	}
 
 	return ret;
 }
 
 static int s6e63m0_ldi_enable(struct s6e63m0 *lcd)
 {
-	int ret = 0;
-
-	ret = s6e63m0_panel_send_sequence(lcd, SEQ_STAND_BY_OFF);
-	ret = s6e63m0_panel_send_sequence(lcd, SEQ_DISPLAY_ON);
+	int ret = 0, i;
+	const unsigned short *enable_seq[] = {
+		SEQ_STAND_BY_OFF,
+		SEQ_DISPLAY_ON,
+	};
+
+	for (i = 0; i < ARRAY_SIZE(enable_seq); i++) {
+		ret = s6e63m0_panel_send_sequence(lcd, enable_seq[i]);
+		if (ret)
+			break;
+	}
 
 	return ret;
 }
@@ -508,12 +534,22 @@ static int s6e63m0_power_on(struct s6e63
 	}
 
 	ret = s6e63m0_ldi_init(lcd);
-	ret |= s6e63m0_ldi_enable(lcd);
+	if (ret) {
+		dev_err(lcd->dev, "failed to initialize ldi.\n");
+		return ret;
+	}
+
+	ret = s6e63m0_ldi_enable(lcd);
+	if (ret) {
+		dev_err(lcd->dev, "failed to enable ldi.\n");
+		return ret;
+	}
+
 	/* set brightness to current value after power on or resume. */
-	ret |= s6e63m0_gamma_ctl(lcd, bd->props.brightness);
+	ret = s6e63m0_gamma_ctl(lcd, bd->props.brightness);
 	if (ret) {
 		dev_err(lcd->dev, "lcd gamma setting failed.\n");
-		return -EIO;
+		return ret;
 	}
 
 	return 0;
_

Patches currently in -mm which might be from daeinki@gmail.com are

backlight-add-s6e63m0-amoled-lcd-panel-driver.patch
backlight-add-s6e63m0-amoled-lcd-panel-driver-checkpatch-fixes.patch
backlight-add-s6e63m0-amoled-lcd-panel-driver-update.patch

