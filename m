From: akpm@linux-foundation.org
Subject: [merged] rtc-add-rv3029c2-rtc-support.patch removed from -mm tree
Date: Fri, 27 May 2011 12:57:05 -0700
Message-ID: <201105271955.p4RJtAGl017432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42116 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932150Ab1E0Tzw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:55:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hs@denx.de, a.zummo@towertech.it, gregory.hermant@calao-systems.com, mcuos.com@gmail.com, w.sang@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     rtc: add rv3029c2 RTC support
has been removed from the -mm tree.  Its filename was
     rtc-add-rv3029c2-rtc-support.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: rtc: add rv3029c2 RTC support
=46rom: Heiko Schocher <hs@denx.de>

Add support for the Micro Crystal RV3029-C2 RTC chips.

Signed-off-by: Heiko Schocher <hs@denx.de>
Signed-off-by: Gregory Hermant <gregory.hermant@calao-systems.com>
Cc: Wan ZongShun <mcuos.com@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig        |    9=20
 drivers/rtc/Makefile       |    1=20
 drivers/rtc/rtc-rv3029c2.c |  454 +++++++++++++++++++++++++++++++++++
 3 files changed, 464 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-add-rv3029c2-rtc-support drivers/rtc/=
Kconfig
--- a/drivers/rtc/Kconfig~rtc-add-rv3029c2-rtc-support
+++ a/drivers/rtc/Kconfig
@@ -360,6 +360,15 @@ config RTC_DRV_EM3027
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-em3027.
=20
+config RTC_DRV_RV3029C2
+	tristate "Micro Crystal RTC"
+	help
+	  If you say yes here you get support for the Micro Crystal
+	  RV3029-C2 RTC chips.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-rv3029c2.
+
 endif # I2C
=20
 comment "SPI RTC drivers"
diff -puN drivers/rtc/Makefile~rtc-add-rv3029c2-rtc-support drivers/rtc=
/Makefile
--- a/drivers/rtc/Makefile~rtc-add-rv3029c2-rtc-support
+++ a/drivers/rtc/Makefile
@@ -82,6 +82,7 @@ obj-$(CONFIG_RTC_DRV_RP5C01)	+=3D rtc-rp5c
 obj-$(CONFIG_RTC_DRV_RS5C313)	+=3D rtc-rs5c313.o
 obj-$(CONFIG_RTC_DRV_RS5C348)	+=3D rtc-rs5c348.o
 obj-$(CONFIG_RTC_DRV_RS5C372)	+=3D rtc-rs5c372.o
+obj-$(CONFIG_RTC_DRV_RV3029C2)	+=3D rtc-rv3029c2.o
 obj-$(CONFIG_RTC_DRV_RX8025)	+=3D rtc-rx8025.o
 obj-$(CONFIG_RTC_DRV_RX8581)	+=3D rtc-rx8581.o
 obj-$(CONFIG_RTC_DRV_S35390A)	+=3D rtc-s35390a.o
diff -puN /dev/null drivers/rtc/rtc-rv3029c2.c
--- /dev/null
+++ a/drivers/rtc/rtc-rv3029c2.c
@@ -0,0 +1,454 @@
+/*
+ * Micro Crystal RV-3029C2 rtc class driver
+ *
+ * Author: Gregory Hermant <gregory.hermant@calao-systems.com>
+ *
+ * based on previously existing rtc class drivers
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * NOTE: Currently this driver only supports the bare minimum for read
+ * and write the RTC and alarms. The extra features provided by this c=
hip
+ * (trickle charger, eeprom, T=C2=B0 compensation) are unavailable.
+ */
+
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/bcd.h>
+#include <linux/rtc.h>
+
+/* Register map */
+/* control section */
+#define RV3029C2_ONOFF_CTRL		0x00
+#define RV3029C2_IRQ_CTRL		0x01
+#define RV3029C2_IRQ_CTRL_AIE		(1 << 0)
+#define RV3029C2_IRQ_FLAGS		0x02
+#define RV3029C2_IRQ_FLAGS_AF		(1 << 0)
+#define RV3029C2_STATUS			0x03
+#define RV3029C2_STATUS_VLOW1		(1 << 2)
+#define RV3029C2_STATUS_VLOW2		(1 << 3)
+#define RV3029C2_STATUS_SR		(1 << 4)
+#define RV3029C2_STATUS_PON		(1 << 5)
+#define RV3029C2_STATUS_EEBUSY		(1 << 7)
+#define RV3029C2_RST_CTRL		0x04
+#define RV3029C2_CONTROL_SECTION_LEN	0x05
+
+/* watch section */
+#define RV3029C2_W_SEC			0x08
+#define RV3029C2_W_MINUTES		0x09
+#define RV3029C2_W_HOURS		0x0A
+#define RV3029C2_REG_HR_12_24		(1<<6)  /* 24h/12h mode */
+#define RV3029C2_REG_HR_PM		(1<<5)  /* PM/AM bit in 12h mode */
+#define RV3029C2_W_DATE			0x0B
+#define RV3029C2_W_DAYS			0x0C
+#define RV3029C2_W_MONTHS		0x0D
+#define RV3029C2_W_YEARS		0x0E
+#define RV3029C2_WATCH_SECTION_LEN	0x07
+
+/* alarm section */
+#define RV3029C2_A_SC			0x10
+#define RV3029C2_A_MN			0x11
+#define RV3029C2_A_HR			0x12
+#define RV3029C2_A_DT			0x13
+#define RV3029C2_A_DW			0x14
+#define RV3029C2_A_MO			0x15
+#define RV3029C2_A_YR			0x16
+#define RV3029C2_ALARM_SECTION_LEN	0x07
+
+/* timer section */
+#define RV3029C2_TIMER_LOW		0x18
+#define RV3029C2_TIMER_HIGH		0x19
+
+/* temperature section */
+#define RV3029C2_TEMP_PAGE		0x20
+
+/* eeprom data section */
+#define RV3029C2_E2P_EEDATA1		0x28
+#define RV3029C2_E2P_EEDATA2		0x29
+
+/* eeprom control section */
+#define RV3029C2_CONTROL_E2P_EECTRL	0x30
+#define RV3029C2_TRICKLE_1K		(1<<0)  /*  1K resistance */
+#define RV3029C2_TRICKLE_5K		(1<<1)  /*  5K resistance */
+#define RV3029C2_TRICKLE_20K		(1<<2)  /* 20K resistance */
+#define RV3029C2_TRICKLE_80K		(1<<3)  /* 80K resistance */
+#define RV3029C2_CONTROL_E2P_XTALOFFSET	0x31
+#define RV3029C2_CONTROL_E2P_QCOEF	0x32
+#define RV3029C2_CONTROL_E2P_TURNOVER	0x33
+
+/* user ram section */
+#define RV3029C2_USR1_RAM_PAGE		0x38
+#define RV3029C2_USR1_SECTION_LEN	0x04
+#define RV3029C2_USR2_RAM_PAGE		0x3C
+#define RV3029C2_USR2_SECTION_LEN	0x04
+
+static int
+rv3029c2_i2c_read_regs(struct i2c_client *client, u8 reg, u8 *buf,
+	unsigned len)
+{
+	int ret;
+
+	if ((reg > RV3029C2_USR1_RAM_PAGE + 7) ||
+		(reg + len > RV3029C2_USR1_RAM_PAGE + 8))
+		return -EINVAL;
+
+	ret =3D i2c_smbus_read_i2c_block_data(client, reg, len, buf);
+	if (ret < 0)
+		return ret;
+	if (ret < len)
+		return -EIO;
+	return 0;
+}
+
+static int
+rv3029c2_i2c_write_regs(struct i2c_client *client, u8 reg, u8 const bu=
f[],
+			unsigned len)
+{
+	if ((reg > RV3029C2_USR1_RAM_PAGE + 7) ||
+		(reg + len > RV3029C2_USR1_RAM_PAGE + 8))
+		return -EINVAL;
+
+	return i2c_smbus_write_i2c_block_data(client, reg, len, buf);
+}
+
+static int
+rv3029c2_i2c_get_sr(struct i2c_client *client, u8 *buf)
+{
+	int ret =3D rv3029c2_i2c_read_regs(client, RV3029C2_STATUS, buf, 1);
+
+	if (ret < 0)
+		return -EIO;
+	dev_dbg(&client->dev, "status =3D 0x%.2x (%d)\n", buf[0], buf[0]);
+	return 0;
+}
+
+static int
+rv3029c2_i2c_set_sr(struct i2c_client *client, u8 val)
+{
+	u8 buf[1];
+	int sr;
+
+	buf[0] =3D val;
+	sr =3D rv3029c2_i2c_write_regs(client, RV3029C2_STATUS, buf, 1);
+	dev_dbg(&client->dev, "status =3D 0x%.2x (%d)\n", buf[0], buf[0]);
+	if (sr < 0)
+		return -EIO;
+	return 0;
+}
+
+static int
+rv3029c2_i2c_read_time(struct i2c_client *client, struct rtc_time *tm)
+{
+	u8 buf[1];
+	int ret;
+	u8 regs[RV3029C2_WATCH_SECTION_LEN] =3D { 0, };
+
+	ret =3D rv3029c2_i2c_get_sr(client, buf);
+	if (ret < 0) {
+		dev_err(&client->dev, "%s: reading SR failed\n", __func__);
+		return -EIO;
+	}
+
+	ret =3D rv3029c2_i2c_read_regs(client, RV3029C2_W_SEC , regs,
+					RV3029C2_WATCH_SECTION_LEN);
+	if (ret < 0) {
+		dev_err(&client->dev, "%s: reading RTC section failed\n",
+			__func__);
+		return ret;
+	}
+
+	tm->tm_sec =3D bcd2bin(regs[RV3029C2_W_SEC-RV3029C2_W_SEC]);
+	tm->tm_min =3D bcd2bin(regs[RV3029C2_W_MINUTES-RV3029C2_W_SEC]);
+
+	/* HR field has a more complex interpretation */
+	{
+		const u8 _hr =3D regs[RV3029C2_W_HOURS-RV3029C2_W_SEC];
+		if (_hr & RV3029C2_REG_HR_12_24) {
+			/* 12h format */
+			tm->tm_hour =3D bcd2bin(_hr & 0x1f);
+			if (_hr & RV3029C2_REG_HR_PM)	/* PM flag set */
+				tm->tm_hour +=3D 12;
+		} else /* 24h format */
+			tm->tm_hour =3D bcd2bin(_hr & 0x3f);
+	}
+
+	tm->tm_mday =3D bcd2bin(regs[RV3029C2_W_DATE-RV3029C2_W_SEC]);
+	tm->tm_mon =3D bcd2bin(regs[RV3029C2_W_MONTHS-RV3029C2_W_SEC]) - 1;
+	tm->tm_year =3D bcd2bin(regs[RV3029C2_W_YEARS-RV3029C2_W_SEC]) + 100;
+	tm->tm_wday =3D bcd2bin(regs[RV3029C2_W_DAYS-RV3029C2_W_SEC]) - 1;
+
+	return 0;
+}
+
+static int rv3029c2_rtc_read_time(struct device *dev, struct rtc_time =
*tm)
+{
+	return rv3029c2_i2c_read_time(to_i2c_client(dev), tm);
+}
+
+static int
+rv3029c2_i2c_read_alarm(struct i2c_client *client, struct rtc_wkalrm *=
alarm)
+{
+	struct rtc_time *const tm =3D &alarm->time;
+	int ret;
+	u8 regs[8];
+
+	ret =3D rv3029c2_i2c_get_sr(client, regs);
+	if (ret < 0) {
+		dev_err(&client->dev, "%s: reading SR failed\n", __func__);
+		return -EIO;
+	}
+
+	ret =3D rv3029c2_i2c_read_regs(client, RV3029C2_A_SC, regs,
+					RV3029C2_ALARM_SECTION_LEN);
+
+	if (ret < 0) {
+		dev_err(&client->dev, "%s: reading alarm section failed\n",
+			__func__);
+		return ret;
+	}
+
+	tm->tm_sec =3D bcd2bin(regs[RV3029C2_A_SC-RV3029C2_A_SC] & 0x7f);
+	tm->tm_min =3D bcd2bin(regs[RV3029C2_A_MN-RV3029C2_A_SC] & 0x7f);
+	tm->tm_hour =3D bcd2bin(regs[RV3029C2_A_HR-RV3029C2_A_SC] & 0x3f);
+	tm->tm_mday =3D bcd2bin(regs[RV3029C2_A_DT-RV3029C2_A_SC] & 0x3f);
+	tm->tm_mon =3D bcd2bin(regs[RV3029C2_A_MO-RV3029C2_A_SC] & 0x1f) - 1;
+	tm->tm_year =3D bcd2bin(regs[RV3029C2_A_YR-RV3029C2_A_SC] & 0x7f) + 1=
00;
+	tm->tm_wday =3D bcd2bin(regs[RV3029C2_A_DW-RV3029C2_A_SC] & 0x07) - 1=
;
+
+	return 0;
+}
+
+static int
+rv3029c2_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
+{
+	return rv3029c2_i2c_read_alarm(to_i2c_client(dev), alarm);
+}
+
+static int rv3029c2_rtc_i2c_alarm_set_irq(struct i2c_client *client,
+					int enable)
+{
+	int ret;
+	u8 buf[1];
+
+	/* enable AIE irq */
+	ret =3D rv3029c2_i2c_read_regs(client, RV3029C2_IRQ_CTRL,	buf, 1);
+	if (ret < 0) {
+		dev_err(&client->dev, "can't read INT reg\n");
+		return ret;
+	}
+	if (enable)
+		buf[0] |=3D RV3029C2_IRQ_CTRL_AIE;
+	else
+		buf[0] &=3D ~RV3029C2_IRQ_CTRL_AIE;
+
+	ret =3D rv3029c2_i2c_write_regs(client, RV3029C2_IRQ_CTRL, buf, 1);
+	if (ret < 0) {
+		dev_err(&client->dev, "can't set INT reg\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int rv3029c2_rtc_i2c_set_alarm(struct i2c_client *client,
+					struct rtc_wkalrm *alarm)
+{
+	struct rtc_time *const tm =3D &alarm->time;
+	int ret;
+	u8 regs[8];
+
+	/*
+	 * The clock has an 8 bit wide bcd-coded register (they never learn)
+	 * for the year. tm_year is an offset from 1900 and we are interested
+	 * in the 2000-2099 range, so any value less than 100 is invalid.
+	*/
+	if (tm->tm_year < 100)
+		return -EINVAL;
+
+	ret =3D rv3029c2_i2c_get_sr(client, regs);
+	if (ret < 0) {
+		dev_err(&client->dev, "%s: reading SR failed\n", __func__);
+		return -EIO;
+	}
+	regs[RV3029C2_A_SC-RV3029C2_A_SC] =3D bin2bcd(tm->tm_sec & 0x7f);
+	regs[RV3029C2_A_MN-RV3029C2_A_SC] =3D bin2bcd(tm->tm_min & 0x7f);
+	regs[RV3029C2_A_HR-RV3029C2_A_SC] =3D bin2bcd(tm->tm_hour & 0x3f);
+	regs[RV3029C2_A_DT-RV3029C2_A_SC] =3D bin2bcd(tm->tm_mday & 0x3f);
+	regs[RV3029C2_A_MO-RV3029C2_A_SC] =3D bin2bcd((tm->tm_mon & 0x1f) - 1=
);
+	regs[RV3029C2_A_DW-RV3029C2_A_SC] =3D bin2bcd((tm->tm_wday & 7) - 1);
+	regs[RV3029C2_A_YR-RV3029C2_A_SC] =3D bin2bcd((tm->tm_year & 0x7f) - =
100);
+
+	ret =3D rv3029c2_i2c_write_regs(client, RV3029C2_A_SC, regs,
+					RV3029C2_ALARM_SECTION_LEN);
+	if (ret < 0)
+		return ret;
+
+	if (alarm->enabled) {
+		u8 buf[1];
+
+		/* clear AF flag */
+		ret =3D rv3029c2_i2c_read_regs(client, RV3029C2_IRQ_FLAGS,
+						buf, 1);
+		if (ret < 0) {
+			dev_err(&client->dev, "can't read alarm flag\n");
+			return ret;
+		}
+		buf[0] &=3D ~RV3029C2_IRQ_FLAGS_AF;
+		ret =3D rv3029c2_i2c_write_regs(client, RV3029C2_IRQ_FLAGS,
+						buf, 1);
+		if (ret < 0) {
+			dev_err(&client->dev, "can't set alarm flag\n");
+			return ret;
+		}
+		/* enable AIE irq */
+		ret =3D rv3029c2_rtc_i2c_alarm_set_irq(client, 1);
+		if (ret)
+			return ret;
+
+		dev_dbg(&client->dev, "alarm IRQ armed\n");
+	} else {
+		/* disable AIE irq */
+		ret =3D rv3029c2_rtc_i2c_alarm_set_irq(client, 1);
+		if (ret)
+			return ret;
+
+		dev_dbg(&client->dev, "alarm IRQ disabled\n");
+	}
+
+	return 0;
+}
+
+static int rv3029c2_rtc_set_alarm(struct device *dev, struct rtc_wkalr=
m *alarm)
+{
+	return rv3029c2_rtc_i2c_set_alarm(to_i2c_client(dev), alarm);
+}
+
+static int
+rv3029c2_i2c_set_time(struct i2c_client *client, struct rtc_time const=
 *tm)
+{
+	u8 regs[8];
+	int ret;
+
+	/*
+	 * The clock has an 8 bit wide bcd-coded register (they never learn)
+	 * for the year. tm_year is an offset from 1900 and we are interested
+	 * in the 2000-2099 range, so any value less than 100 is invalid.
+	*/
+	if (tm->tm_year < 100)
+		return -EINVAL;
+
+	regs[RV3029C2_W_SEC-RV3029C2_W_SEC] =3D bin2bcd(tm->tm_sec);
+	regs[RV3029C2_W_MINUTES-RV3029C2_W_SEC] =3D bin2bcd(tm->tm_min);
+	regs[RV3029C2_W_HOURS-RV3029C2_W_SEC] =3D bin2bcd(tm->tm_hour);
+	regs[RV3029C2_W_DATE-RV3029C2_W_SEC] =3D bin2bcd(tm->tm_mday);
+	regs[RV3029C2_W_MONTHS-RV3029C2_W_SEC] =3D bin2bcd(tm->tm_mon+1);
+	regs[RV3029C2_W_DAYS-RV3029C2_W_SEC] =3D bin2bcd((tm->tm_wday & 7)+1)=
;
+	regs[RV3029C2_W_YEARS-RV3029C2_W_SEC] =3D bin2bcd(tm->tm_year - 100);
+
+	ret =3D rv3029c2_i2c_write_regs(client, RV3029C2_W_SEC, regs,
+					RV3029C2_WATCH_SECTION_LEN);
+	if (ret < 0)
+		return ret;
+
+	ret =3D rv3029c2_i2c_get_sr(client, regs);
+	if (ret < 0) {
+		dev_err(&client->dev, "%s: reading SR failed\n", __func__);
+		return ret;
+	}
+	/* clear PON bit */
+	ret =3D rv3029c2_i2c_set_sr(client, (regs[0] & ~RV3029C2_STATUS_PON))=
;
+	if (ret < 0) {
+		dev_err(&client->dev, "%s: reading SR failed\n", __func__);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int rv3029c2_rtc_set_time(struct device *dev, struct rtc_time *=
tm)
+{
+	return rv3029c2_i2c_set_time(to_i2c_client(dev), tm);
+}
+
+static const struct rtc_class_ops rv3029c2_rtc_ops =3D {
+	.read_time	=3D rv3029c2_rtc_read_time,
+	.set_time	=3D rv3029c2_rtc_set_time,
+	.read_alarm	=3D rv3029c2_rtc_read_alarm,
+	.set_alarm	=3D rv3029c2_rtc_set_alarm,
+};
+
+static struct i2c_device_id rv3029c2_id[] =3D {
+	{ "rv3029c2", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, rv3029c2_id);
+
+static int __devinit
+rv3029c2_probe(struct i2c_client *client, const struct i2c_device_id *=
id)
+{
+	struct rtc_device *rtc;
+	int rc =3D 0;
+	u8 buf[1];
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_EMUL))
+		return -ENODEV;
+
+	rtc =3D rtc_device_register(client->name,
+				&client->dev, &rv3029c2_rtc_ops,
+				THIS_MODULE);
+
+	if (IS_ERR(rtc))
+		return PTR_ERR(rtc);
+
+	i2c_set_clientdata(client, rtc);
+
+	rc =3D rv3029c2_i2c_get_sr(client, buf);
+	if (rc < 0) {
+		dev_err(&client->dev, "reading status failed\n");
+		goto exit_unregister;
+	}
+
+	return 0;
+
+exit_unregister:
+	rtc_device_unregister(rtc);
+
+	return rc;
+}
+
+static int __devexit rv3029c2_remove(struct i2c_client *client)
+{
+	struct rtc_device *rtc =3D i2c_get_clientdata(client);
+
+	rtc_device_unregister(rtc);
+
+	return 0;
+}
+
+static struct i2c_driver rv3029c2_driver =3D {
+	.driver =3D {
+		.name =3D "rtc-rv3029c2",
+	},
+	.probe =3D rv3029c2_probe,
+	.remove =3D __devexit_p(rv3029c2_remove),
+	.id_table =3D rv3029c2_id,
+};
+
+static int __init rv3029c2_init(void)
+{
+	return i2c_add_driver(&rv3029c2_driver);
+}
+
+static void __exit rv3029c2_exit(void)
+{
+	i2c_del_driver(&rv3029c2_driver);
+}
+
+module_init(rv3029c2_init);
+module_exit(rv3029c2_exit);
+
+MODULE_AUTHOR("Gregory Hermant <gregory.hermant@calao-systems.com>");
+MODULE_DESCRIPTION("Micro Crystal RV3029C2 RTC driver");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from hs@denx.de are

origin.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
