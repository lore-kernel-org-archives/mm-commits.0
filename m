From: akpm@linux-foundation.org
Subject: [folded] leds-add-driver-for-lm3530-als-update.patch removed from -mm tree
Date: Tue, 22 Mar 2011 15:55:34 -0700
Message-ID: <201103222255.p2MMtYV8032509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753030Ab1CVWzs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Mar 2011 18:55:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shreshthakumar.sahu@stericsson.com, linus.walleij@stericsson.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds-add-driver-for-lm3530-als-update
has been removed from the -mm tree.  Its filename was
     leds-add-driver-for-lm3530-als-update.patch

This patch was dropped because it was folded into leds-add-driver-for-lm3530-als.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds-add-driver-for-lm3530-als-update
From: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>

changes in v3:
  modified according to comments from Andrew Morton
  - rectify sloppy string comparision; now using sysfs_streq()
  - remove unnecessary LM3530_BL_MODE_MAX and use ARRAY_SIZE

Signed-off-by: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lm3530.c |   11 ++++-------
 include/linux/led-lm3530.h |    1 -
 2 files changed, 4 insertions(+), 8 deletions(-)

diff -puN drivers/leds/leds-lm3530.c~leds-add-driver-for-lm3530-als-update drivers/leds/leds-lm3530.c
--- a/drivers/leds/leds-lm3530.c~leds-add-driver-for-lm3530-als-update
+++ a/drivers/leds/leds-lm3530.c
@@ -122,15 +122,12 @@ static const u8 lm3530_reg[LM3530_REG_MA
 	LM3530_ALS_Z4T_REG,
 };
 
-static int lm3530_get_mode_from_str(const char *str, int count)
+static int lm3530_get_mode_from_str(const char *str)
 {
 	int i;
 
-	if (str[0] == '\n')
-		return -1;
-
-	for (i = 0; i < LM3530_BL_MODE_MAX; i++)
-		if (!strncmp(mode_map[i].mode, str, count))
+	for (i = 0; i < ARRAY_SIZE(mode_map); i++)
+		if (sysfs_streq(str, mode_map[i].mode))
 			return mode_map[i].mode_val;
 
 	return -1;
@@ -239,7 +236,7 @@ static ssize_t lm3530_mode_set(struct de
 	struct lm3530_data *drvdata = i2c_get_clientdata(client);
 	int mode;
 
-	mode = lm3530_get_mode_from_str(buf, size-1);
+	mode = lm3530_get_mode_from_str(buf);
 	if (mode < 0) {
 		dev_err(dev, "Invalid mode\n");
 		return -EINVAL;
diff -puN include/linux/led-lm3530.h~leds-add-driver-for-lm3530-als-update include/linux/led-lm3530.h
--- a/include/linux/led-lm3530.h~leds-add-driver-for-lm3530-als-update
+++ a/include/linux/led-lm3530.h
@@ -62,7 +62,6 @@ enum lm3530_mode {
 	LM3530_BL_MODE_MANUAL = 0,	/* "man" */
 	LM3530_BL_MODE_ALS,		/* "als" */
 	LM3530_BL_MODE_PWM,		/* "pwm" */
-	LM3530_BL_MODE_MAX,
 };
 
 /* ALS input select */
_

Patches currently in -mm which might be from shreshthakumar.sahu@stericsson.com are

leds-add-driver-for-lm3530-als.patch

