From: akpm@linux-foundation.org
Subject: +
 rtc-rtc-isl12057-add-alarm-support-to-intersil-isl12057-rtc-driver.patch
 added to -mm tree
Date: Tue, 25 Nov 2014 13:30:35 -0800
Message-ID: <5474f4fb.n1mYYvyU/vkyWNQI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50048 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaKYVag (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Nov 2014 16:30:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arno@natisbad.org, a.zummo@towertech.it, broonie@kernel.org, grant.likely@linaro.org, linus.walleij@linaro.org, mark.rutland@arm.com, peter.huewe@infineon.com, treding@nvidia.com, uwe@kleine-koenig.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-isl12057.c: add alarm support to Intersil=
 ISL12057 RTC driver
has been added to the -mm tree.  Its filename is
     rtc-rtc-isl12057-add-alarm-support-to-intersil-isl12057-rtc-driver=
=2Epatch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-rtc-isl12057-add-alarm=
-support-to-intersil-isl12057-rtc-driver.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/rtc-rtc-isl12057-add-a=
larm-support-to-intersil-isl12057-rtc-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Arnaud Ebalard <arno@natisbad.org>
Subject: drivers/rtc/rtc-isl12057.c: add alarm support to Intersil ISL1=
2057 RTC driver

This patch adds alarm support to Intersil ISL12057 driver.  This allows=
 to
configure the chip to generate an interrupt when the alarm matches curr=
ent
time value.  Alarm can be programmed up to one month in the future and =
is
accurate to the second.

The patch was developed to support two different configurations: system=
s
w/ and w/o RTC chip IRQ line connected to the main CPU.

The latter is the one found on current 3 kernel users of the chip for
which support was initially developed (Netgear ReadyNAS 102, 104 and 21=
20
NAS).  On those devices, the IRQ#2 pin of the chip is not connected to =
the
SoC but to a PMIC.  This allows setting an alarm, powering off the devi=
ce
and have it wake up when the alarm rings.  To support that configuratio=
n
the driver does the following:

 1. it has alarm_irq_enable() function returns -ENOTTY when no IRQ
    is passed to the driver.
 2. it marks the device as a wakeup source in all cases (whether an
    IRQ is passed to the driver or not) to have 'wakealarm' sysfs
    entry created.
 3. it marks the device has not supporting UIE mode when no IRQ is
    passed to the driver (see the commmit message of c9f5c7e7a84f)

This specific configuration was tested on a ReadyNAS 102 by setting an
alarm, powering off the device and see it reboot as expected when the
alarm rang.

The former configuration was tested on a Netgear ReadyNAS 102 after som=
e
soldering of the IRQ#2 pin of the RTC chip to a MPP line of the SoC (th=
e
one used usually handles the reset button).  The test was performed usi=
ng
a modified .dts file reflecting this change (see below) and rtc-test.c
program available in Documentation/rtc.txt.  This test program ran as
expected, which validates alarm supports, including interrupt support.

As a side note, the ISL12057 remains in the list of trivial devices, i.=
e.=20
no specific DT binding being added by this patch: i2c core automaticall=
y
handles extraction of IRQ line info from .dts file.  For instance, if o=
ne
wants to reference the interrupt line for the alarm in its .dts file,
adding interrupt and interrupt-parent properties works as expected:

          isl12057: isl12057@68 {
                  compatible =3D3D "isil,isl12057";
                  interrupt-parent =3D3D <&gpio0>;
                  interrupts =3D3D <6 IRQ_TYPE_EDGE_FALLING>;
                  reg =3D3D <0x68>;
          };

=46WIW, if someone is looking for a way to test alarm support on a syst=
em on
which the chip IRQ line has the ability to boot the system (e.g.  Ready=
NAS
102, 104, etc):

    # echo 0 > /sys/class/rtc/rtc0/wakealarm
    # echo `date '+%s' -d '+ 1 minutes'` > /sys/class/rtc/rtc0/wakealar=
m
    # shutdown -h now

With the commands above, after a minute, the system comes back to life.

Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Peter Huewe <peter.huewe@infineon.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Thierry Reding <treding@nvidia.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Uwe Kleine-K=F6nig <uwe@kleine-koenig.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/i2c/trivial-devices.txt |    2=20
 drivers/rtc/rtc-isl12057.c                                |  324 +++++=
++++-
 2 files changed, 315 insertions(+), 11 deletions(-)

diff -puN Documentation/devicetree/bindings/i2c/trivial-devices.txt~rtc=
-rtc-isl12057-add-alarm-support-to-intersil-isl12057-rtc-driver Documen=
tation/devicetree/bindings/i2c/trivial-devices.txt
--- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt~rtc-rtc=
-isl12057-add-alarm-support-to-intersil-isl12057-rtc-driver
+++ a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
@@ -55,7 +55,7 @@ fsl,sgtl5000		SGTL5000: Ultra Low-Power
 gmt,g751		G751: Digital Temperature Sensor and Thermal Watchdog with T=
wo-Wire Interface
 infineon,slb9635tt	Infineon SLB9635 (Soft-) I2C TPM (old protocol, max=
 100khz)
 infineon,slb9645tt	Infineon SLB9645 I2C TPM (new protocol, max 400khz)
-isil,isl12057		Intersil ISL12057 I2C RTC Chip
+isil,isl12057		Intersil ISL12057 I2C RTC/Alarm Chip
 maxim,ds1050		5 Bit Programmable, Pulse-Width Modulator
 maxim,max1237		Low-Power, 4-/12-Channel, 2-Wire Serial, 12-Bit ADCs
 maxim,max6625		9-Bit/12-Bit Temperature Sensors with I=C2=B2C-Compatib=
le Serial Interface
diff -puN drivers/rtc/rtc-isl12057.c~rtc-rtc-isl12057-add-alarm-support=
-to-intersil-isl12057-rtc-driver drivers/rtc/rtc-isl12057.c
--- a/drivers/rtc/rtc-isl12057.c~rtc-rtc-isl12057-add-alarm-support-to-=
intersil-isl12057-rtc-driver
+++ a/drivers/rtc/rtc-isl12057.c
@@ -1,5 +1,5 @@
 /*
- * rtc-isl12057 - Driver for Intersil ISL12057 I2C Real Time Clock
+ * rtc-isl12057 - Driver for Intersil ISL12057 I2C Real Time Clock / A=
larm
  *
  * Copyright (C) 2013, Arnaud EBALARD <arno@natisbad.org>
  *
@@ -79,8 +79,10 @@
 #define ISL12057_MEM_MAP_LEN	0x10
=20
 struct isl12057_rtc_data {
+	struct rtc_device *rtc;
 	struct regmap *regmap;
 	struct mutex lock;
+	int irq;
 };
=20
 static void isl12057_rtc_regs_to_tm(struct rtc_time *tm, u8 *regs)
@@ -160,14 +162,47 @@ static int isl12057_i2c_validate_chip(st
 	return 0;
 }
=20
-static int isl12057_rtc_read_time(struct device *dev, struct rtc_time =
*tm)
+static int _isl12057_rtc_clear_alarm(struct device *dev)
+{
+	struct isl12057_rtc_data *data =3D dev_get_drvdata(dev);
+	int ret;
+
+	ret =3D regmap_update_bits(data->regmap, ISL12057_REG_SR,
+				 ISL12057_REG_SR_A1F, 0);
+	if (ret)
+		dev_err(dev, "%s: clearing alarm failed (%d)\n", __func__, ret);
+
+	return ret;
+}
+
+static int _isl12057_rtc_update_alarm(struct device *dev, int enable)
+{
+	struct isl12057_rtc_data *data =3D dev_get_drvdata(dev);
+	int ret;
+
+	ret =3D regmap_update_bits(data->regmap, ISL12057_REG_INT,
+				 ISL12057_REG_INT_A1IE,
+				 enable ? ISL12057_REG_INT_A1IE : 0);
+	if (ret)
+		dev_err(dev, "%s: changing alarm interrupt flag failed (%d)\n",
+			__func__, ret);
+
+	return ret;
+}
+
+/*
+ * Note: as we only read from device and do not perform any update, th=
ere is
+ * no need for an equivalent function which would try and get driver's=
 main
+ * lock. Here, it is safe for everyone if we just use regmap internal =
lock
+ * on the device when reading.
+ */
+static int _isl12057_rtc_read_time(struct device *dev, struct rtc_time=
 *tm)
 {
 	struct isl12057_rtc_data *data =3D dev_get_drvdata(dev);
 	u8 regs[ISL12057_RTC_SEC_LEN];
 	unsigned int sr;
 	int ret;
=20
-	mutex_lock(&data->lock);
 	ret =3D regmap_read(data->regmap, ISL12057_REG_SR, &sr);
 	if (ret) {
 		dev_err(dev, "%s: unable to read oscillator status flag (%d)\n",
@@ -187,8 +222,6 @@ static int isl12057_rtc_read_time(struct
 			__func__, ret);
=20
 out:
-	mutex_unlock(&data->lock);
-
 	if (ret)
 		return ret;
=20
@@ -197,6 +230,168 @@ out:
 	return rtc_valid_tm(tm);
 }
=20
+static int isl12057_rtc_update_alarm(struct device *dev, int enable)
+{
+	struct isl12057_rtc_data *data =3D dev_get_drvdata(dev);
+	int ret;
+
+	mutex_lock(&data->lock);
+	ret =3D _isl12057_rtc_update_alarm(dev, enable);
+	mutex_unlock(&data->lock);
+
+	return ret;
+}
+
+static int isl12057_rtc_read_alarm(struct device *dev, struct rtc_wkal=
rm *alarm)
+{
+	struct isl12057_rtc_data *data =3D dev_get_drvdata(dev);
+	struct rtc_time rtc_tm, *alarm_tm =3D &alarm->time;
+	unsigned long rtc_secs, alarm_secs;
+	u8 regs[ISL12057_A1_SEC_LEN];
+	unsigned int ir;
+	int ret;
+
+	mutex_lock(&data->lock);
+	ret =3D regmap_bulk_read(data->regmap, ISL12057_REG_A1_SC, regs,
+			       ISL12057_A1_SEC_LEN);
+	if (ret) {
+		dev_err(dev, "%s: reading alarm section failed (%d)\n",
+			__func__, ret);
+		goto err_unlock;
+	}
+
+	alarm_tm->tm_sec  =3D bcd2bin(regs[0] & 0x7f);
+	alarm_tm->tm_min  =3D bcd2bin(regs[1] & 0x7f);
+	alarm_tm->tm_hour =3D bcd2bin(regs[2] & 0x3f);
+	alarm_tm->tm_mday =3D bcd2bin(regs[3] & 0x3f);
+	alarm_tm->tm_wday =3D -1;
+
+	/*
+	 * The alarm section does not store year/month. We use the ones in rt=
c
+	 * section as a basis and increment month and then year if needed to =
get
+	 * alarm after current time.
+	 */
+	ret =3D _isl12057_rtc_read_time(dev, &rtc_tm);
+	if (ret)
+		goto err_unlock;
+
+	alarm_tm->tm_year =3D rtc_tm.tm_year;
+	alarm_tm->tm_mon =3D rtc_tm.tm_mon;
+
+	ret =3D rtc_tm_to_time(&rtc_tm, &rtc_secs);
+	if (ret)
+		goto err_unlock;
+
+	ret =3D rtc_tm_to_time(alarm_tm, &alarm_secs);
+	if (ret)
+		goto err_unlock;
+
+	if (alarm_secs < rtc_secs) {
+		if (alarm_tm->tm_mon =3D=3D 11) {
+			alarm_tm->tm_mon =3D 0;
+			alarm_tm->tm_year +=3D 1;
+		} else {
+			alarm_tm->tm_mon +=3D 1;
+		}
+	}
+
+	ret =3D regmap_read(data->regmap, ISL12057_REG_INT, &ir);
+	if (ret) {
+		dev_err(dev, "%s: reading alarm interrupt flag failed (%d)\n",
+			__func__, ret);
+		goto err_unlock;
+	}
+
+	alarm->enabled =3D !!(ir & ISL12057_REG_INT_A1IE);
+
+err_unlock:
+	mutex_unlock(&data->lock);
+
+	return ret;
+}
+
+static int isl12057_rtc_set_alarm(struct device *dev, struct rtc_wkalr=
m *alarm)
+{
+	struct isl12057_rtc_data *data =3D dev_get_drvdata(dev);
+	struct rtc_time *alarm_tm =3D &alarm->time;
+	unsigned long rtc_secs, alarm_secs;
+	u8 regs[ISL12057_A1_SEC_LEN];
+	struct rtc_time rtc_tm;
+	int ret, enable =3D 1;
+
+	mutex_lock(&data->lock);
+	ret =3D _isl12057_rtc_read_time(dev, &rtc_tm);
+	if (ret)
+		goto err_unlock;
+
+	ret =3D rtc_tm_to_time(&rtc_tm, &rtc_secs);
+	if (ret)
+		goto err_unlock;
+
+	ret =3D rtc_tm_to_time(alarm_tm, &alarm_secs);
+	if (ret)
+		goto err_unlock;
+
+	/* If alarm time is before current time, disable the alarm */
+	if (!alarm->enabled || alarm_secs <=3D rtc_secs) {
+		enable =3D 0;
+	} else {
+		/*
+		 * Chip only support alarms up to one month in the future. Let's
+		 * return an error if we get something after that limit.
+		 * Comparison is done by incrementing rtc_tm month field by one
+		 * and checking alarm value is still below.
+		 */
+		if (rtc_tm.tm_mon =3D=3D 11) { /* handle year wrapping */
+			rtc_tm.tm_mon =3D 0;
+			rtc_tm.tm_year +=3D 1;
+		} else {
+			rtc_tm.tm_mon +=3D 1;
+		}
+
+		ret =3D rtc_tm_to_time(&rtc_tm, &rtc_secs);
+		if (ret)
+			goto err_unlock;
+
+		if (alarm_secs > rtc_secs) {
+			dev_err(dev, "%s: max for alarm is one month (%d)\n",
+				__func__, ret);
+			ret =3D -EINVAL;
+			goto err_unlock;
+		}
+	}
+
+	/* Disable the alarm before modifying it */
+	ret =3D _isl12057_rtc_update_alarm(dev, 0);
+	if (ret < 0) {
+		dev_err(dev, "%s: unable to disable the alarm (%d)\n",
+			__func__, ret);
+		goto err_unlock;
+	}
+
+	/* Program alarm registers */
+	regs[0] =3D bin2bcd(alarm_tm->tm_sec) & 0x7f;
+	regs[1] =3D bin2bcd(alarm_tm->tm_min) & 0x7f;
+	regs[2] =3D bin2bcd(alarm_tm->tm_hour) & 0x3f;
+	regs[3] =3D bin2bcd(alarm_tm->tm_mday) & 0x3f;
+
+	ret =3D regmap_bulk_write(data->regmap, ISL12057_REG_A1_SC, regs,
+				ISL12057_A1_SEC_LEN);
+	if (ret < 0) {
+		dev_err(dev, "%s: writing alarm section failed (%d)\n",
+			__func__, ret);
+		goto err_unlock;
+	}
+
+	/* Enable or disable alarm */
+	ret =3D _isl12057_rtc_update_alarm(dev, enable);
+
+err_unlock:
+	mutex_unlock(&data->lock);
+
+	return ret;
+}
+
 static int isl12057_rtc_set_time(struct device *dev, struct rtc_time *=
tm)
 {
 	struct isl12057_rtc_data *data =3D dev_get_drvdata(dev);
@@ -262,9 +457,48 @@ static int isl12057_check_rtc_status(str
 	return 0;
 }
=20
+static int isl12057_rtc_alarm_irq_enable(struct device *dev,
+					 unsigned int enable)
+{
+	struct isl12057_rtc_data *rtc_data =3D dev_get_drvdata(dev);
+	int ret =3D -ENOTTY;
+
+	if (rtc_data->irq)
+		ret =3D isl12057_rtc_update_alarm(dev, enable);
+
+	return ret;
+}
+
+static irqreturn_t isl12057_rtc_interrupt(int irq, void *data)
+{
+	struct i2c_client *client =3D data;
+	struct isl12057_rtc_data *rtc_data =3D dev_get_drvdata(&client->dev);
+	struct rtc_device *rtc =3D rtc_data->rtc;
+	int ret, handled =3D IRQ_NONE;
+	unsigned int sr;
+
+	ret =3D regmap_read(rtc_data->regmap, ISL12057_REG_SR, &sr);
+	if (!ret && (sr & ISL12057_REG_SR_A1F)) {
+		dev_dbg(&client->dev, "RTC alarm!\n");
+
+		rtc_update_irq(rtc, 1, RTC_IRQF | RTC_AF);
+
+		/* Acknowledge and disable the alarm */
+		_isl12057_rtc_clear_alarm(&client->dev);
+		_isl12057_rtc_update_alarm(&client->dev, 0);
+
+		handled =3D IRQ_HANDLED;
+	}
+
+	return handled;
+}
+
 static const struct rtc_class_ops rtc_ops =3D {
-	.read_time =3D isl12057_rtc_read_time,
+	.read_time =3D _isl12057_rtc_read_time,
 	.set_time =3D isl12057_rtc_set_time,
+	.read_alarm =3D isl12057_rtc_read_alarm,
+	.set_alarm =3D isl12057_rtc_set_alarm,
+	.alarm_irq_enable =3D isl12057_rtc_alarm_irq_enable,
 };
=20
 static struct regmap_config isl12057_rtc_regmap_config =3D {
@@ -277,7 +511,6 @@ static int isl12057_probe(struct i2c_cli
 {
 	struct device *dev =3D &client->dev;
 	struct isl12057_rtc_data *data;
-	struct rtc_device *rtc;
 	struct regmap *regmap;
 	int ret;
=20
@@ -310,10 +543,79 @@ static int isl12057_probe(struct i2c_cli
 	data->regmap =3D regmap;
 	dev_set_drvdata(dev, data);
=20
-	rtc =3D devm_rtc_device_register(dev, DRV_NAME, &rtc_ops, THIS_MODULE=
);
-	return PTR_ERR_OR_ZERO(rtc);
+	if (client->irq > 0) {
+		ret =3D devm_request_threaded_irq(dev, client->irq, NULL,
+						isl12057_rtc_interrupt,
+						IRQF_SHARED|IRQF_ONESHOT,
+						DRV_NAME, client);
+		if (!ret)
+			data->irq =3D client->irq;
+		else
+			dev_err(dev, "%s: irq %d unavailable (%d)\n", __func__,
+				client->irq, ret);
+	}
+
+	/*
+	 * This is needed to have 'wakealarm' sysfs entry available. One
+	 * would expect the device to be marked as a wakeup source only
+	 * when an IRQ pin of the RTC is routed to an interrupt line of the
+	 * CPU. In practice, such an IRQ pin can be connected to a PMIC and
+	 * this allows the device to be powered up when RTC alarm rings.
+	 */
+	device_init_wakeup(dev, true);
+
+	data->rtc =3D devm_rtc_device_register(dev, DRV_NAME, &rtc_ops,
+					     THIS_MODULE);
+	ret =3D PTR_ERR_OR_ZERO(data->rtc);
+	if (ret) {
+		dev_err(dev, "%s: unable to register RTC device (%d)\n",
+			__func__, ret);
+		goto err;
+	}
+
+	/* We cannot support UIE mode if we do not have an IRQ line */
+	if (!data->irq)
+		data->rtc->uie_unsupported =3D 1;
+
+err:
+	return ret;
 }
=20
+static int isl12057_remove(struct i2c_client *client)
+{
+	struct isl12057_rtc_data *rtc_data =3D dev_get_drvdata(&client->dev);
+
+	if (rtc_data->irq > 0)
+		device_init_wakeup(&client->dev, false);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int isl12057_rtc_suspend(struct device *dev)
+{
+	struct isl12057_rtc_data *rtc_data =3D dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev))
+		return enable_irq_wake(rtc_data->irq);
+
+	return 0;
+}
+
+static int isl12057_rtc_resume(struct device *dev)
+{
+	struct isl12057_rtc_data *rtc_data =3D dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev))
+		return disable_irq_wake(rtc_data->irq);
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(isl12057_rtc_pm_ops, isl12057_rtc_suspend,
+			 isl12057_rtc_resume);
+
 #ifdef CONFIG_OF
 static const struct of_device_id isl12057_dt_match[] =3D {
 	{ .compatible =3D "isl,isl12057" },  /* obsolete */
@@ -332,13 +634,15 @@ static struct i2c_driver isl12057_driver
 	.driver =3D {
 		.name =3D DRV_NAME,
 		.owner =3D THIS_MODULE,
+		.pm =3D &isl12057_rtc_pm_ops,
 		.of_match_table =3D of_match_ptr(isl12057_dt_match),
 	},
 	.probe	  =3D isl12057_probe,
+	.remove	  =3D isl12057_remove,
 	.id_table =3D isl12057_id,
 };
 module_i2c_driver(isl12057_driver);
=20
 MODULE_AUTHOR("Arnaud EBALARD <arno@natisbad.org>");
-MODULE_DESCRIPTION("Intersil ISL12057 RTC driver");
+MODULE_DESCRIPTION("Intersil ISL12057 RTC/Alarm driver");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from arno@natisbad.org are

rtc-rtc-isl12057-fix-masking-of-register-values.patch
rtc-rtc-isl12057-add-support-for-century-bit.patch
rtc-rtc-isl12057-add-proper-handling-of-oscillator-failure-bit.patch
rtc-rtc-isl12057-fix-isil-vs-isl-naming-for-intersil.patch
rtc-rtc-isl12057-report-error-code-upon-failure-in-dev_err-calls.patch
rtc-rtc-isl12057-add-alarm-support-to-intersil-isl12057-rtc-driver.patc=
h
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
