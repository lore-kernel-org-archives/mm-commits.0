From: akpm@linux-foundation.org
Subject: + leds-add-driver-for-lm3530-als-update.patch added to -mm tree
Date: Fri, 21 Jan 2011 15:20:31 -0800
Message-ID: <201101212320.p0LNKVH6007024@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47608 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753861Ab1AUXVM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Jan 2011 18:21:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shreshthakumar.sahu@stericsson.com, linus.walleij@stericsson.com, rpurdie@rpsys.net


The patch titled
     leds-add-driver-for-lm3530-als-update
has been added to the -mm tree.  Its filename is
     leds-add-driver-for-lm3530-als-update.patch

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
leds-add-driver-for-lm3530-als-update.patch

