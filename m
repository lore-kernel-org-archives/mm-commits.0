From: akpm@linux-foundation.org
Subject: + drivers-leds-leds-lp5523c-adjust-delays-and-add-comments-to-them.patch added to -mm tree
Date: Fri, 12 Nov 2010 11:44:58 -0800
Message-ID: <201011121944.oACJiwKv028064@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756859Ab0KLTpk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Nov 2010 14:45:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samu.p.onkalo@nokia.com, rpurdie@rpsys.net


The patch titled
     drivers/leds/leds-lp5523.c: adjust delays and add comments to them
has been added to the -mm tree.  Its filename is
     drivers-leds-leds-lp5523c-adjust-delays-and-add-comments-to-them.patch

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
Subject: drivers/leds/leds-lp5523.c: adjust delays and add comments to them
From: Samu Onkalo <samu.p.onkalo@nokia.com>

Delays were little bit too long.  Adjust delay times and add some comments
to them.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lp5523.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff -puN drivers/leds/leds-lp5523.c~drivers-leds-leds-lp5523c-adjust-delays-and-add-comments-to-them drivers/leds/leds-lp5523.c
--- a/drivers/leds/leds-lp5523.c~drivers-leds-leds-lp5523c-adjust-delays-and-add-comments-to-them
+++ a/drivers/leds/leds-lp5523.c
@@ -205,11 +205,14 @@ static int lp5523_configure(struct i2c_c
 
 	lp5523_write(client, LP5523_REG_RESET, 0xff);
 
-	usleep_range(10000, 100000);
+	usleep_range(10000, 20000); /*
+				     * Exact value is not available. 10 - 20ms
+				     * appears to be enough for reset.
+				     */
 
 	ret |= lp5523_write(client, LP5523_REG_ENABLE, LP5523_ENABLE);
-	/* Chip startup time after reset is 500 us */
-	usleep_range(1000, 10000);
+	/* Chip startup time is 500 us, 1 - 2 ms gives some margin */
+	usleep_range(1000, 2000);
 
 	ret |= lp5523_write(client, LP5523_REG_CONFIG,
 			    LP5523_AUTO_INC | LP5523_PWR_SAVE |
@@ -246,8 +249,8 @@ static int lp5523_configure(struct i2c_c
 		return -1;
 	}
 
-	/* Wait 3ms and check the engine status */
-	usleep_range(3000, 20000);
+	/* Let the programs run for couple of ms and check the engine status */
+	usleep_range(3000, 6000);
 	lp5523_read(client, LP5523_REG_STATUS, &status);
 	status &= LP5523_ENG_STATUS_MASK;
 
@@ -452,10 +455,10 @@ static ssize_t lp5523_selftest(struct de
 	/* Measure VDD (i.e. VBAT) first (channel 16 corresponds to VDD) */
 	lp5523_write(chip->client, LP5523_REG_LED_TEST_CTRL,
 				    LP5523_EN_LEDTEST | 16);
-	usleep_range(3000, 10000);
+	usleep_range(3000, 6000); /* ADC conversion time is typically 2.7 ms */
 	ret = lp5523_read(chip->client, LP5523_REG_STATUS, &status);
 	if (!(status & LP5523_LEDTEST_DONE))
-		usleep_range(3000, 10000);
+		usleep_range(3000, 6000); /* Was not ready. Wait little bit */
 
 	ret |= lp5523_read(chip->client, LP5523_REG_LED_TEST_ADC, &vdd);
 	vdd--;	/* There may be some fluctuation in measurement */
@@ -471,16 +474,16 @@ static ssize_t lp5523_selftest(struct de
 			chip->pdata->led_config[i].led_current);
 
 		lp5523_write(chip->client, LP5523_REG_LED_PWM_BASE + i, 0xff);
-		/* let current stabilize 2ms before measurements start */
-		usleep_range(2000, 10000);
+		/* let current stabilize 2 - 4ms before measurements start */
+		usleep_range(2000, 4000);
 		lp5523_write(chip->client,
 			     LP5523_REG_LED_TEST_CTRL,
 			     LP5523_EN_LEDTEST | i);
-		/* ledtest takes 2.7ms */
-		usleep_range(3000, 10000);
+		/* ADC conversion time is 2.7 ms typically */
+		usleep_range(3000, 6000);
 		ret = lp5523_read(chip->client, LP5523_REG_STATUS, &status);
 		if (!(status & LP5523_LEDTEST_DONE))
-			usleep_range(3000, 10000);
+			usleep_range(3000, 6000);/* Was not ready. Wait. */
 		ret |= lp5523_read(chip->client, LP5523_REG_LED_TEST_ADC, &adc);
 
 		if (adc >= vdd || adc < LP5523_ADC_SHORTCIRC_LIM)
@@ -933,9 +936,9 @@ static int lp5523_probe(struct i2c_clien
 
 	if (pdata->enable) {
 		pdata->enable(0);
-		usleep_range(1000, 10000);
+		usleep_range(1000, 2000); /* Keep enable down at least 1ms */
 		pdata->enable(1);
-		usleep_range(1000, 10000); /* Spec says min 500us */
+		usleep_range(1000, 2000); /* 500us abs min. */
 	}
 
 	ret = lp5523_detect(client);
_

Patches currently in -mm which might be from samu.p.onkalo@nokia.com are

drivers-misc-bh1770glcc-error-handling-in-bh1770_power_state_store.patch
leds-driver-for-national-semiconductor-lp5521-chip.patch
leds-driver-for-national-semiconductors-lp5523-chip.patch
leds-update-lp552x-support-kconfig-and-makefile.patch
documentation-led-drivers-lp5521-and-lp5523.patch
drivers-leds-leds-lp5521c-change-some-macros-to-functions.patch
drivers-leds-leds-lp5523c-change-some-macros-to-functions.patch
drivers-leds-leds-lp5521c-adjust-delays-and-add-comments-to-them.patch
drivers-leds-leds-lp5523c-adjust-delays-and-add-comments-to-them.patch
drivers-leds-leds-lp5521c-perform-sw-reset-before-detection.patch
drivers-leds-leds-lp5523c-perform-sw-reset-before-detection.patch

