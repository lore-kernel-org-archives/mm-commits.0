From: akpm@linux-foundation.org
Subject: [folded] leds-add-driver-for-tca6507-led-controller-fix-44.patch removed from -mm tree
Date: Tue, 10 Jan 2012 14:48:15 -0800
Message-ID: <20120110224815.95D801003D2@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:35507 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374Ab2AJWsQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 17:48:16 -0500
Received: by yenm5 with SMTP id m5so13312yen.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 14:48:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: LEDS tca6507 fixes
has been removed from the -mm tree.  Its filename was
     leds-add-driver-for-tca6507-led-controller-fix-44.patch

This patch was dropped because it was folded into leds-add-driver-for-tca6507-led-controller.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: LEDS tca6507 fixes

- various improvements to comments.
- bug in choose_times() which was counting down instead of up
- Change choice algorithm to allow change-time to be longer
  if requested 'msec' is odd (i.e. use lsb of 'msec' as a flag).
- bug in set_code wasn't shifting mask properly.
- dev_dbg messages so we can monitor the choice funciton.
- make spinlock irq-safe so that gpio.set() and others can be
  called from interrupt handler.
- set client_data before ->setup call back as it could set the
  GPIO value immediately.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-tca6507.c |  132 +++++++++++++++++++++++-----------
 1 file changed, 93 insertions(+), 39 deletions(-)

diff -puN drivers/leds/leds-tca6507.c~leds-add-driver-for-tca6507-led-controller-fix-44 drivers/leds/leds-tca6507.c
--- a/drivers/leds/leds-tca6507.c~leds-add-driver-for-tca6507-led-controller-fix-44
+++ a/drivers/leds/leds-tca6507.c
@@ -24,29 +24,41 @@
  * This driver does not support double-blink so 'second-off' always matches
  * 'off'.
  *
- * Only 16 different times can be programmed is a roughly logarithmic scale from
- * 64ms to 16320ms.   Times that cannot be closely matched with these must be
+ * Only 16 different times can be programmed in a roughly logarithmic scale from
+ * 64ms to 16320ms.  To be precise the possible times are:
+ *    0, 64, 128, 192, 256, 384, 512, 768,
+ *    1024, 1536, 2048, 3072, 4096, 5760, 8128, 16320
+ *
+ * Times that cannot be closely matched with these must be
  * handled in software.  This driver allows 12.5% error in matching.
  *
  * This driver does not allow rise/fall rates to be set explicitly.  When trying
  * to match a given 'on' or 'off' period, an appropriate pair of 'change' and
- * 'hold' times are chosen to get a close match, with the 'change' being the
- * smaller.
+ * 'hold' times are chosen to get a close match.  If the target delay is even,
+ * the 'change' number will be the smaller; if odd, the 'hold' number will be
+ * the smaller.
+
+ * Choosing pairs of delays with 12.5% errors allows us to match delays in the
+ * ranges: 56-72, 112-144, 168-216, 224-27504, 28560-36720.
+ * 26% of the achievable sums can be matched by multiple pairings. For example
+ * 1536 == 1536+0, 1024+512, or 768+768.  This driver will always choose the
+ * pairing with the least maximum - 768+768 in this case.  Other pairings are
+ * not available.
  *
  * Access to the 3 levels and 2 blinks are on a first-come, first-served basis.
  * Access can be shared by multiple leds if they have the same level and
  * either same blink rates, or some don't blink.
  * When a led changes, it relinquishes access and tries again, so it might
  * lose access to hardware blink.
- * If a blink engine cannot be allocated, software blink is used.  If the
- * desired brightness cannot be allocated, the closest available non-zero
+ * If a blink engine cannot be allocated, software blink is used.
+ * If the desired brightness cannot be allocated, the closest available non-zero
  * brightness is used.  As 'full' is always available, the worst case would be
  * to have two different blink rates at '1', with Max at '2', then other leds
  * will have to choose between '2' and '16'.  Hopefully this is not likely.
  *
- * Each bank (BANK0 and BANK1) have two usage counts - Leds using the brightness
- * and leds using the blink.  It can only be reprogrammed when appropriate
- * counter is zero.  The MASTER level has as single usage count.
+ * Each bank (BANK0 and BANK1) has two usage counts - LEDs using the brightness
+ * and LEDs using the blink.  It can only be reprogrammed when the appropriate
+ * counter is zero.  The MASTER level has a single usage count.
  *
  * Each Led has programmable 'on' and 'off' time as milliseconds.  With each
  * there is a flag saying if it was explicitly requested or defaulted.
@@ -58,8 +70,10 @@
  * lists for each output: the name, default trigger, and whether the signal
  * is being used as a GPiO rather than an led.  'struct led_plaform_data'
  * is used for this.  If 'name' is NULL, the output isn't used.  If 'flags'
- * is non-zero, the output is a GPO.  The 'flags' for the first GPIO should
- * be the base gpio number, or -1.
+ * is TCA6507_MAKE_CPIO, the output is a GPO.
+ * The "struct led_platform_data" can be embedded in a
+ * "struct tca6507_platform_data" which adds a 'gpio_base' for the GPiOs,
+ * and a 'setup' callback which is called once the GPiOs are available.
  *
  */
 
@@ -74,6 +88,7 @@
 
 /* LED select registers determine the source that drives LED outputs */
 #define TCA6507_LS_LED_OFF	0x0	/* Output HI-Z (off) */
+#define TCA6507_LS_LED_OFF1	0x1	/* Output HI-Z (off) - not used */
 #define TCA6507_LS_LED_PWM0	0x2	/* Output LOW with Bank0 rate */
 #define TCA6507_LS_LED_PWM1	0x3	/* Output LOW with Bank1 rate */
 #define TCA6507_LS_LED_ON	0x4	/* Output LOW (on) */
@@ -91,7 +106,7 @@ static int bank_source[3] = {
 	TCA6507_LS_LED_PWM1,
 	TCA6507_LS_LED_MIR,
 };
-static int blink_source[3] = {
+static int blink_source[2] = {
 	TCA6507_LS_BLINK0,
 	TCA6507_LS_BLINK1,
 };
@@ -99,6 +114,10 @@ static int blink_source[3] = {
 /* PWM registers */
 #define	TCA6507_REG_CNT			11
 
+/*
+ * 0x00, 0x01, 0x02 encode the TCA6507_LS_* values, each output
+ * owns one bit in each register
+ */
 #define	TCA6507_FADE_ON			0x03
 #define	TCA6507_FULL_ON			0x04
 #define	TCA6507_FADE_OFF		0x05
@@ -132,10 +151,11 @@ static inline int TO_BRIGHT(int level)
 
 #define NUM_LEDS 7
 struct tca6507_chip {
-	int			reg_set;	/* a '1' means the register
+	int			reg_set;	/* One bit per register where
+						 * a '1' means the register
 						 * should be written */
 	u8			reg_file[TCA6507_REG_CNT];
-	/* Bank 0 is Master Intensity */
+	/* Bank 2 is Master Intensity and doesn't use times */
 	struct bank {
 		int level;
 		int ontime, offtime;
@@ -153,7 +173,7 @@ struct tca6507_chip {
 		int			ontime, offtime;
 		int			on_dflt, off_dflt;
 		int			bank;	/* Bank used, or -1 */
-		int			blink;	/* 1 if we are hardware-blinking */
+		int			blink;	/* Set if hardware-blinking */
 	} leds[NUM_LEDS];
 #ifdef CONFIG_GPIOLIB
 	struct gpio_chip		gpio;
@@ -172,9 +192,13 @@ static int choose_times(int msec, int *c
 {
 	/*
 	 * Choose two timecodes which add to 'msec' as near as possible.
-	 * The first returned should be the larger and is the 'on' of 'off'
-	 * time.  The second will be used as a 'fade-on' or 'fade-off' time.
-	 * If cannot get within 1/8, fail.
+	 * The first returned is the 'on' or 'off' time.  The second is to be
+	 * used as a 'fade-on' or 'fade-off' time.  If 'msec' is even,
+	 * the first will not be smaller than the second.  If 'msec' is odd,
+	 * the first will not be larger than the second.
+	 * If we cannot get a sum within 1/8 of 'msec' fail with -EINVAL,
+	 * otherwise return the sum that was achieved, plus 1 if the first is
+	 * smaller.
 	 * If two possibilities are equally good (e.g. 512+0, 256+256), choose
 	 * the first pair so there is more change-time visible (i.e. it is
 	 * softer).
@@ -193,7 +217,7 @@ static int choose_times(int msec, int *c
 			continue;
 		if (t > tmax)
 			break;
-		for (c2 = 0; c2 <= c1; c2--) {
+		for (c2 = 0; c2 <= c1; c2++) {
 			int tt = t + time_codes[c2];
 			int d;
 			if (tt < tmin)
@@ -209,11 +233,22 @@ static int choose_times(int msec, int *c
 			*c2p = c2;
 			diff = d;
 			if (d == 0)
-				return 0;
+				return msec;
 		}
 	}
-	if (diff < 65536)
-		return 0;
+	if (diff < 65536) {
+		int actual;
+		if (msec & 1) {
+			c1 = *c2p;
+			*c2p = *c1p;
+			*c1p = c1;
+		}
+		actual = time_codes[*c1p] + time_codes[*c2p];
+		if (*c1p < *c2p)
+			return actual + 1;
+		else
+			return actual;
+	}
 	/* No close match */
 	return -EINVAL;
 }
@@ -244,10 +279,13 @@ static void set_select(struct tca6507_ch
  */
 static void set_code(struct tca6507_chip *tca, int reg, int bank, int new)
 {
-	int mask = (0xF << bank);
-	int n = tca->reg_file[reg] & ~mask;
-	if (bank)
+	int mask = 0xF;
+	int n;
+	if (bank) {
+		mask <<= 4;
 		new <<= 4;
+	}
+	n = tca->reg_file[reg] & ~mask;
 	n |= new;
 	if (tca->reg_file[reg] != n) {
 		tca->reg_file[reg] = n;
@@ -274,17 +312,24 @@ static void set_level(struct tca6507_chi
 static void set_times(struct tca6507_chip *tca, int bank)
 {
 	int c1, c2;
+	int result;
 
-	choose_times(tca->bank[bank].ontime, &c1, &c2);
+	result = choose_times(tca->bank[bank].ontime, &c1, &c2);
+	dev_dbg(&tca->client->dev,
+		"Chose on  times %d(%d) %d(%d) for %dms\n", c1, time_codes[c1],
+		c2, time_codes[c2], tca->bank[bank].ontime);
 	set_code(tca, TCA6507_FADE_ON, bank, c2);
 	set_code(tca, TCA6507_FULL_ON, bank, c1);
-	tca->bank[bank].ontime = time_codes[c1] + time_codes[c2];
+	tca->bank[bank].ontime = result;
 
-	choose_times(tca->bank[bank].offtime, &c1, &c2);
+	result = choose_times(tca->bank[bank].offtime, &c1, &c2);
+	dev_dbg(&tca->client->dev,
+		"Chose off times %d(%d) %d(%d) for %dms\n", c1, time_codes[c1],
+		c2, time_codes[c2], tca->bank[bank].offtime);
 	set_code(tca, TCA6507_FADE_OFF, bank, c2);
 	set_code(tca, TCA6507_FIRST_OFF, bank, c1);
 	set_code(tca, TCA6507_SECOND_OFF, bank, c1);
-	tca->bank[bank].offtime = time_codes[c1] + time_codes[c2];
+	tca->bank[bank].offtime = result;
 
 	set_code(tca, TCA6507_INITIALIZE, bank, INIT_CODE);
 }
@@ -300,11 +345,11 @@ static void tca6507_work(struct work_str
 	u8 file[TCA6507_REG_CNT];
 	int r;
 
-	spin_lock(&tca->lock);
+	spin_lock_irq(&tca->lock);
 	set = tca->reg_set;
 	memcpy(file, tca->reg_file, TCA6507_REG_CNT);
 	tca->reg_set = 0;
-	spin_unlock(&tca->lock);
+	spin_unlock_irq(&tca->lock);
 
 	for (r = 0; r < TCA6507_REG_CNT; r++)
 		if (set & (1<<r))
@@ -327,7 +372,7 @@ static void led_release(struct tca6507_l
 
 static int led_prepare(struct tca6507_led *led)
 {
-	/* Assign this led to a bank. configuring that bank if necessary */
+	/* Assign this led to a bank, configuring that bank if necessary. */
 	int level = TO_LEVEL(led->led_cdev.brightness);
 	struct tca6507_chip *tca = led->chip;
 	int c1, c2;
@@ -386,7 +431,11 @@ static int led_prepare(struct tca6507_le
 		return 0;
 	}
 
-	/* We have on/off time so we need to try to allocate a timing bank. */
+	/*
+	 * We have on/off time so we need to try to allocate a timing bank.
+	 * First check if times are compatible with hardware and give up if
+	 * not.
+	 */
 	if (choose_times(led->ontime, &c1, &c2) < 0)
 		return -EINVAL;
 	if (choose_times(led->offtime, &c1, &c2) < 0)
@@ -466,8 +515,9 @@ static int led_assign(struct tca6507_led
 {
 	struct tca6507_chip *tca = led->chip;
 	int err;
+	unsigned long flags;
 
-	spin_lock(&tca->lock);
+	spin_lock_irqsave(&tca->lock, flags);
 	led_release(led);
 	err = led_prepare(led);
 	if (err) {
@@ -479,7 +529,7 @@ static int led_assign(struct tca6507_led
 		led->offtime = 0;
 		led_prepare(led);
 	}
-	spin_unlock(&tca->lock);
+	spin_unlock_irqrestore(&tca->lock, flags);
 
 	if (tca->reg_set)
 		schedule_work(&tca->work);
@@ -539,15 +589,16 @@ static void tca6507_gpio_set_value(struc
 				   unsigned offset, int val)
 {
 	struct tca6507_chip *tca = container_of(gc, struct tca6507_chip, gpio);
+	unsigned long flags;
 
-	spin_lock(&tca->lock);
+	spin_lock_irqsave(&tca->lock, flags);
 	/*
 	 * 'OFF' is floating high, and 'ON' is pulled down, so it has the
 	 * inverse sense of 'val'.
 	 */
 	set_select(tca, tca->gpio_map[offset],
 		   val ? TCA6507_LS_LED_OFF : TCA6507_LS_LED_ON);
-	spin_unlock(&tca->lock);
+	spin_unlock_irqrestore(&tca->lock, flags);
 	if (tca->reg_set)
 		schedule_work(&tca->work);
 }
@@ -558,6 +609,7 @@ static int tca6507_gpio_direction_output
 	tca6507_gpio_set_value(gc, offset, val);
 	return 0;
 }
+
 static int tca6507_probe_gpios(struct i2c_client *client,
 			       struct tca6507_chip *tca,
 			       struct tca6507_platform_data *pdata)
@@ -643,6 +695,7 @@ static int __devinit tca6507_probe(struc
 	tca->client = client;
 	INIT_WORK(&tca->work, tca6507_work);
 	spin_lock_init(&tca->lock);
+	i2c_set_clientdata(client, tca);
 
 	for (i = 0; i < NUM_LEDS; i++) {
 		struct tca6507_led *l = tca->leds + i;
@@ -665,7 +718,6 @@ static int __devinit tca6507_probe(struc
 	err = tca6507_probe_gpios(client, tca, pdata);
 	if (err)
 		goto exit;
-	i2c_set_clientdata(client, tca);
 	/* set all registers to known state - zero */
 	tca->reg_set = 0x7f;
 	schedule_work(&tca->work);
@@ -675,6 +727,8 @@ exit:
 	while (i--)
 		if (tca->leds[i].led_cdev.name)
 			led_classdev_unregister(&tca->leds[i].led_cdev);
+	cancel_work_sync(&tca->work);
+	i2c_set_clientdata(client, NULL);
 	kfree(tca);
 	return err;
 }
@@ -691,8 +745,8 @@ static int __devexit tca6507_remove(stru
 	}
 	tca6507_remove_gpio(tca);
 	cancel_work_sync(&tca->work);
-	kfree(tca);
 	i2c_set_clientdata(client, NULL);
+	kfree(tca);
 
 	return 0;
 }
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
leds-add-driver-for-tca6507-led-controller.patch

