From: akpm@linux-foundation.org
Subject: + rtc-rtc-ab-b5ze-s3-add-sub-minute-alarm-support.patch added to
 -mm tree
Date: Wed, 14 Jan 2015 16:22:15 -0800
Message-ID: <54b70837.BpmEWBhWDPYVsUoy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43752 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbbAOAW1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Jan 2015 19:22:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arno@natisbad.org, a.zummo@towertech.it, arnd@arndb.de, broonie@kernel.org, galak@codeaurora.org, grant.likely@linaro.org, ijc+devicetree@hellion.org.uk, jason@lakedaemon.net, jgunthorpe@obsidianresearch.com, linus.walleij@linaro.org, linux@roeck-us.net, mark.rutland@arm.com, pawel.moll@arm.com, peter.huewe@infineon.com, rob.herring@calxeda.com, rob@landley.net, swarren@wwwdotorg.org, treding@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-ab-b5ze-s3: add sub-minute alarm support
has been added to the -mm tree.  Its filename is
     rtc-rtc-ab-b5ze-s3-add-sub-minute-alarm-support.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-rtc-ab-b5ze-s3-add-sub-minute-alarm-support.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-rtc-ab-b5ze-s3-add-sub-minute-alarm-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnaud Ebalard <arno@natisbad.org>
Subject: rtc: rtc-ab-b5ze-s3: add sub-minute alarm support

Abracon AB-RTCMC-32.768kHz-B5ZE-S3 alarm is only accurate to the minute. 
For that reason, UIE mode is currently not supported by the driver.  But
the device provides a watchdog timer which can be coupled with the alarm
mechanism to extend support and provide sub-minute alarm capability.

This patch implements that extension.  More precisely, it makes use of the
watchdog timer for alarms which are less that four minutes in the future
(with second accuracy) and use standard alarm mechanism for other alarms
(with minute accuracy).

Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Peter Huewe <peter.huewe@infineon.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Thierry Reding <treding@nvidia.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Landley <rob@landley.net>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Kumar Gala <galak@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ab-b5ze-s3.c |  311 +++++++++++++++++++++++++++++----
 1 file changed, 275 insertions(+), 36 deletions(-)

diff -puN drivers/rtc/rtc-ab-b5ze-s3.c~rtc-rtc-ab-b5ze-s3-add-sub-minute-alarm-support drivers/rtc/rtc-ab-b5ze-s3.c
--- a/drivers/rtc/rtc-ab-b5ze-s3.c~rtc-rtc-ab-b5ze-s3-add-sub-minute-alarm-support
+++ a/drivers/rtc/rtc-ab-b5ze-s3.c
@@ -133,6 +133,7 @@ struct abb5zes3_rtc_data {
 	int irq;
 
 	bool battery_low;
+	bool timer_alarm; /* current alarm is via timer A */
 };
 
 /*
@@ -192,6 +193,22 @@ static int _abb5zes3_rtc_update_alarm(st
 	return ret;
 }
 
+/* Enable or disable timer (watchdog timer A interrupt generation) */
+static int _abb5zes3_rtc_update_timer(struct device *dev, bool enable)
+{
+	struct abb5zes3_rtc_data *data = dev_get_drvdata(dev);
+	int ret;
+
+	ret = regmap_update_bits(data->regmap, ABB5ZES3_REG_CTRL2,
+				 ABB5ZES3_REG_CTRL2_WTAIE,
+				 enable ? ABB5ZES3_REG_CTRL2_WTAIE : 0);
+	if (ret)
+		dev_err(dev, "%s: writing timer INT failed (%d)\n",
+			__func__, ret);
+
+	return ret;
+}
+
 /*
  * Note: we only read, so regmap inner lock protection is sufficient, i.e.
  * we do not need driver's main lock protection.
@@ -277,7 +294,92 @@ static int abb5zes3_rtc_set_time(struct
 	return ret;
 }
 
-static int abb5zes3_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
+/*
+ * Set provided TAQ and Timer A registers (TIMA_CLK and TIMA) based on
+ * given number of seconds.
+ */
+static inline void sec_to_timer_a(u8 secs, u8 *taq, u8 *timer_a)
+{
+	*taq = ABB5ZES3_REG_TIMA_CLK_TAQ1; /* 1Hz */
+	*timer_a = secs;
+}
+
+/*
+ * Return current number of seconds in Timer A. As we only use
+ * timer A with a 1Hz freq, this is what we expect to have.
+ */
+static inline int sec_from_timer_a(u8 *secs, u8 taq, u8 timer_a)
+{
+	if (taq != ABB5ZES3_REG_TIMA_CLK_TAQ1) /* 1Hz */
+		return -EINVAL;
+
+	*secs = timer_a;
+
+	return 0;
+}
+
+/*
+ * Read alarm currently configured via a watchdog timer using timer A. This
+ * is done by reading current RTC time and adding remaining timer time.
+ */
+static int _abb5zes3_rtc_read_timer(struct device *dev,
+				    struct rtc_wkalrm *alarm)
+{
+	struct abb5zes3_rtc_data *data = dev_get_drvdata(dev);
+	struct rtc_time rtc_tm, *alarm_tm = &alarm->time;
+	u8 regs[ABB5ZES3_TIMA_SEC_LEN + 1];
+	unsigned long rtc_secs;
+	unsigned int reg;
+	u8 timer_secs;
+	int ret;
+
+	/*
+	 * Instead of doing two separate calls, because they are consecutive,
+	 * we grab both clockout register and Timer A section. The latter is
+	 * used to decide if timer A is enabled (as a watchdog timer).
+	 */
+	ret = regmap_bulk_read(data->regmap, ABB5ZES3_REG_TIM_CLK, regs,
+			       ABB5ZES3_TIMA_SEC_LEN + 1);
+	if (ret) {
+		dev_err(dev, "%s: reading Timer A section failed (%d)\n",
+			__func__, ret);
+		goto err;
+	}
+
+	/* get current time ... */
+	ret = _abb5zes3_rtc_read_time(dev, &rtc_tm);
+	if (ret)
+		goto err;
+
+	/* ... convert to seconds ... */
+	ret = rtc_tm_to_time(&rtc_tm, &rtc_secs);
+	if (ret)
+		goto err;
+
+	/* ... add remaining timer A time ... */
+	ret = sec_from_timer_a(&timer_secs, regs[1], regs[2]);
+	if (ret)
+		goto err;
+
+	/* ... and convert back. */
+	rtc_time_to_tm(rtc_secs + timer_secs, alarm_tm);
+
+	ret = regmap_read(data->regmap, ABB5ZES3_REG_CTRL2, &reg);
+	if (ret) {
+		dev_err(dev, "%s: reading ctrl reg failed (%d)\n",
+			__func__, ret);
+		goto err;
+	}
+
+	alarm->enabled = !!(reg & ABB5ZES3_REG_CTRL2_WTAIE);
+
+err:
+	return ret;
+}
+
+/* Read alarm currently configured via a RTC alarm registers. */
+static int _abb5zes3_rtc_read_alarm(struct device *dev,
+				    struct rtc_wkalrm *alarm)
 {
 	struct abb5zes3_rtc_data *data = dev_get_drvdata(dev);
 	struct rtc_time rtc_tm, *alarm_tm = &alarm->time;
@@ -286,7 +388,6 @@ static int abb5zes3_rtc_read_alarm(struc
 	unsigned int reg;
 	int ret;
 
-	mutex_lock(&data->lock);
 	ret = regmap_bulk_read(data->regmap, ABB5ZES3_REG_ALRM_MN, regs,
 			       ABB5ZES3_ALRM_SEC_LEN);
 	if (ret) {
@@ -340,13 +441,39 @@ static int abb5zes3_rtc_read_alarm(struc
 	alarm->enabled = !!(reg & ABB5ZES3_REG_CTRL1_AIE);
 
 err:
+	return ret;
+}
+
+/*
+ * As the Alarm mechanism supported by the chip is only accurate to the
+ * minute, we use the watchdog timer mechanism provided by timer A
+ * (up to 256 seconds w/ a second accuracy) for low alarm values (below
+ * 4 minutes). Otherwise, we use the common alarm mechanism provided
+ * by the chip. In order for that to work, we keep track of currently
+ * configured timer type via 'timer_alarm' flag in our private data
+ * structure.
+ */
+static int abb5zes3_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
+{
+	struct abb5zes3_rtc_data *data = dev_get_drvdata(dev);
+	int ret;
+
+	mutex_lock(&data->lock);
+	if (data->timer_alarm)
+		ret = _abb5zes3_rtc_read_timer(dev, alarm);
+	else
+		ret = _abb5zes3_rtc_read_alarm(dev, alarm);
 	mutex_unlock(&data->lock);
 
 	return ret;
 }
 
-/* ALARM is only accurate to the minute (not the second) */
-static int abb5zes3_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
+/*
+ * Set alarm using chip alarm mechanism. It is only accurate to the
+ * minute (not the second). The function expects alarm interrupt to
+ * be disabled.
+ */
+static int _abb5zes3_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 {
 	struct abb5zes3_rtc_data *data = dev_get_drvdata(dev);
 	struct rtc_time *alarm_tm = &alarm->time;
@@ -355,7 +482,6 @@ static int abb5zes3_rtc_set_alarm(struct
 	struct rtc_time rtc_tm;
 	int ret, enable = 1;
 
-	mutex_lock(&data->lock);
 	ret = _abb5zes3_rtc_read_time(dev, &rtc_tm);
 	if (ret)
 		goto err;
@@ -397,18 +523,13 @@ static int abb5zes3_rtc_set_alarm(struct
 		}
 	}
 
-	/* Disable the alarm before modifying it */
-	ret = _abb5zes3_rtc_update_alarm(dev, 0);
-	if (ret < 0) {
-		dev_err(dev, "%s: unable to disable the alarm (%d)\n",
-			__func__, ret);
-		goto err;
-	}
-
-	/* Program alarm registers */
-	regs[0] = bin2bcd(alarm_tm->tm_min) & 0x7f;  /* minute */
-	regs[1] = bin2bcd(alarm_tm->tm_hour) & 0x3f; /* hour */
-	regs[2] = bin2bcd(alarm_tm->tm_mday) & 0x3f; /* day of the month */
+	/*
+	 * Program all alarm registers but DW one. For each register, setting
+	 * MSB to 0 enables associated alarm.
+	 */
+	regs[0] = bin2bcd(alarm_tm->tm_min) & 0x7f;
+	regs[1] = bin2bcd(alarm_tm->tm_hour) & 0x3f;
+	regs[2] = bin2bcd(alarm_tm->tm_mday) & 0x3f;
 	regs[3] = ABB5ZES3_REG_ALRM_DW_AE; /* do not match day of the week */
 
 	ret = regmap_bulk_write(data->regmap, ABB5ZES3_REG_ALRM_MN, regs,
@@ -419,15 +540,115 @@ static int abb5zes3_rtc_set_alarm(struct
 		goto err;
 	}
 
-	/* Enable or disable alarm */
+	/* Record currently configured alarm is not a timer */
+	data->timer_alarm = 0;
+
+	/* Enable or disable alarm interrupt generation */
 	ret = _abb5zes3_rtc_update_alarm(dev, enable);
 
 err:
-	mutex_unlock(&data->lock);
+	return ret;
+}
+
+/*
+ * Set alarm using timer watchdog (via timer A) mechanism. The function expects
+ * timer A interrupt to be disabled.
+ */
+static int _abb5zes3_rtc_set_timer(struct device *dev, struct rtc_wkalrm *alarm,
+				   u8 secs)
+{
+	struct abb5zes3_rtc_data *data = dev_get_drvdata(dev);
+	u8 regs[ABB5ZES3_TIMA_SEC_LEN];
+	u8 mask = ABB5ZES3_REG_TIM_CLK_TAC0 | ABB5ZES3_REG_TIM_CLK_TAC1;
+	int ret = 0;
+
+	/* Program given number of seconds to Timer A registers */
+	sec_to_timer_a(secs, &regs[0], &regs[1]);
+	ret = regmap_bulk_write(data->regmap, ABB5ZES3_REG_TIMA_CLK, regs,
+				ABB5ZES3_TIMA_SEC_LEN);
+	if (ret < 0) {
+		dev_err(dev, "%s: writing timer section failed\n", __func__);
+		goto err;
+	}
 
+	/* Configure Timer A as a watchdog timer */
+	ret = regmap_update_bits(data->regmap, ABB5ZES3_REG_TIM_CLK,
+				 mask, ABB5ZES3_REG_TIM_CLK_TAC1);
+	if (ret)
+		dev_err(dev, "%s: failed to update timer\n", __func__);
+
+	/* Record currently configured alarm is a timer */
+	data->timer_alarm = 1;
+
+	/* Enable or disable timer interrupt generation */
+	ret = _abb5zes3_rtc_update_timer(dev, alarm->enabled);
+
+err:
 	return ret;
 }
 
+/*
+ * The chip has an alarm which is only accurate to the minute. In order to
+ * handle alarms below that limit, we use the watchdog timer function of
+ * timer A. More precisely, the timer method is used for alarms below 240
+ * seconds.
+ */
+static int abb5zes3_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
+{
+	struct abb5zes3_rtc_data *data = dev_get_drvdata(dev);
+	struct rtc_time *alarm_tm = &alarm->time;
+	unsigned long rtc_secs, alarm_secs;
+	struct rtc_time rtc_tm;
+	int ret;
+
+	mutex_lock(&data->lock);
+	ret = _abb5zes3_rtc_read_time(dev, &rtc_tm);
+	if (ret)
+		goto err;
+
+	ret = rtc_tm_to_time(&rtc_tm, &rtc_secs);
+	if (ret)
+		goto err;
+
+	ret = rtc_tm_to_time(alarm_tm, &alarm_secs);
+	if (ret)
+		goto err;
+
+	/* Let's first disable both the alarm and the timer interrupts */
+	ret = _abb5zes3_rtc_update_alarm(dev, false);
+	if (ret < 0) {
+		dev_err(dev, "%s: unable to disable alarm (%d)\n", __func__,
+			ret);
+		goto err;
+	}
+	ret = _abb5zes3_rtc_update_timer(dev, false);
+	if (ret < 0) {
+		dev_err(dev, "%s: unable to disable timer (%d)\n", __func__,
+			ret);
+		goto err;
+	}
+
+	data->timer_alarm = 0;
+
+	/*
+	 * Let's now configure the alarm; if we are expected to ring in
+	 * more than 240s, then we setup an alarm. Otherwise, a timer.
+	 */
+	if ((alarm_secs > rtc_secs) && ((alarm_secs - rtc_secs) <= 240))
+		ret = _abb5zes3_rtc_set_timer(dev, alarm,
+					      alarm_secs - rtc_secs);
+	else
+		ret = _abb5zes3_rtc_set_alarm(dev, alarm);
+
+ err:
+	mutex_unlock(&data->lock);
+
+	if (ret)
+		dev_err(dev, "%s: unable to configure alarm (%d)\n", __func__,
+			ret);
+
+	return ret;
+ }
 
 /* Enable or disable battery low irq generation */
 static inline int _abb5zes3_rtc_battery_low_irq_enable(struct regmap *regmap,
@@ -446,7 +667,7 @@ static inline int _abb5zes3_rtc_battery_
 static int abb5zes3_rtc_check_setup(struct device *dev)
 {
 	struct abb5zes3_rtc_data *data = dev_get_drvdata(dev);
-	struct regmap *regmap =  data->regmap;
+	struct regmap *regmap = data->regmap;
 	unsigned int reg;
 	int ret;
 	u8 mask;
@@ -579,7 +800,10 @@ static int abb5zes3_rtc_alarm_irq_enable
 
 	if (rtc_data->irq) {
 		mutex_lock(&rtc_data->lock);
-		ret = _abb5zes3_rtc_update_alarm(dev, enable);
+		if (rtc_data->timer_alarm)
+			ret = _abb5zes3_rtc_update_timer(dev, enable);
+		else
+			ret = _abb5zes3_rtc_update_alarm(dev, enable);
 		mutex_unlock(&rtc_data->lock);
 	}
 
@@ -629,6 +853,23 @@ static irqreturn_t _abb5zes3_rtc_interru
 		handled = IRQ_HANDLED;
 	}
 
+	/* Check watchdog Timer A flag */
+	if (regs[ABB5ZES3_REG_CTRL2] & ABB5ZES3_REG_CTRL2_WTAF) {
+		dev_dbg(dev, "RTC timer!\n");
+
+		rtc_update_irq(rtc, 1, RTC_IRQF | RTC_AF);
+
+		/*
+		 * Acknowledge and disable the alarm. Note: WTAF
+		 * flag had been cleared when reading CTRL2
+		 */
+		_abb5zes3_rtc_update_timer(dev, 0);
+
+		rtc_data->timer_alarm = 0;
+
+		handled = IRQ_HANDLED;
+	}
+
 	return handled;
 }
 
@@ -655,24 +896,28 @@ static int abb5zes3_probe(struct i2c_cli
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C |
 				     I2C_FUNC_SMBUS_BYTE_DATA |
-				     I2C_FUNC_SMBUS_I2C_BLOCK))
-		return -ENODEV;
+				     I2C_FUNC_SMBUS_I2C_BLOCK)) {
+		ret = -ENODEV;
+		goto err;
+	}
 
 	regmap = devm_regmap_init_i2c(client, &abb5zes3_rtc_regmap_config);
 	if (IS_ERR(regmap)) {
 		ret = PTR_ERR(regmap);
 		dev_err(dev, "%s: regmap allocation failed: %d\n",
 			__func__, ret);
-		return ret;
+		goto err;
 	}
 
 	ret = abb5zes3_i2c_validate_chip(regmap);
 	if (ret)
-		return ret;
+		goto err;
 
 	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
+	if (!data) {
+		ret = -ENOMEM;
+		goto err;
+	}
 
 	mutex_init(&data->lock);
 	data->regmap = regmap;
@@ -680,7 +925,7 @@ static int abb5zes3_probe(struct i2c_cli
 
 	ret = abb5zes3_rtc_check_setup(dev);
 	if (ret)
-		return ret;
+		goto err;
 
 	if (client->irq > 0) {
 		ret = devm_request_threaded_irq(dev, client->irq, NULL,
@@ -705,16 +950,9 @@ static int abb5zes3_probe(struct i2c_cli
 		dev_err(dev, "%s: unable to register RTC device (%d)\n",
 			__func__, ret);
 		device_init_wakeup(dev, false);
+		goto err;
 	}
 
-	/*
-	 * AB-B5Z5E only supports a coarse granularity alarm (one minute
-	 * resolution up to one month) so we cannot support UIE mode
-	 * using the device's alarm. Note it should be feasible to support
-	 * such a feature using one of the two timers the device provides.
-	 */
-	data->rtc->uie_unsupported = 1;
-
 	/* Enable battery low detection interrupt if battery not already low */
 	if (!data->battery_low && data->irq) {
 		ret = _abb5zes3_rtc_battery_low_irq_enable(regmap, true);
@@ -723,6 +961,7 @@ static int abb5zes3_probe(struct i2c_cli
 				"generation failed (%d)\n", __func__, ret);
 	}
 
+err:
 	return ret;
 }
 
_

Patches currently in -mm which might be from arno@natisbad.org are

rtc-rtc-isl12057-add-alarm-support-to-intersil-isl12057-rtc-driver.patch
rtc-rtc-isl12057-add-alarm-support-to-intersil-isl12057-rtc-driver-update.patch
rtc-rtc-isl12057-add-isilirq2-can-wakeup-machine-property-for-in-tree-users.patch
arm-mvebu-isl12057-rtc-chip-can-now-wake-up-rn102-rn102-and-rn2120.patch
of-add-vendor-prefix-for-abracon-corporation.patch
rtc-add-support-for-abracon-ab-rtcmc-32768khz-b5ze-s3-i2c-rtc-chip.patch
rtc-rtc-ab-b5ze-s3-add-sub-minute-alarm-support.patch
linux-next.patch
dt-bindings-use-isil-prefix-for-intersil.patch
rtc-isl12022-deprecate-use-of-isl-in-compatible-string-for-isil.patch
rtc-isl12057-deprecate-use-of-isl-in-compatible-string-for-isil.patch
staging-iio-isl29028-deprecate-use-of-isl-in-compatible-string-for-isil.patch
arm-dts-zynq-update-isl9305-compatible-string-to-use-isil-vendor-prefix.patch

