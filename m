From: akpm@linux-foundation.org
Subject: + rtc-add-pcf85063-support.patch added to -mm tree
Date: Tue, 22 Jul 2014 13:54:16 -0700
Message-ID: <53cecf78.Dc2bvDTdEk3LeWWY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:45270 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaGVUyR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Jul 2014 16:54:17 -0400
Received: by mail-oa0-f73.google.com with SMTP id g18so78625oah.4
        for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2014 13:54:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: san@rosetechnology.dk, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: add pcf85063 support
has been added to the -mm tree.  Its filename is
     rtc-add-pcf85063-support.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-add-pcf85063-support.p=
atch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-add-pcf85063-support.p=
atch

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
=46rom: S=F8ren Andersen <san@rosetechnology.dk>
Subject: rtc: add pcf85063 support

Add support for the pcf85063 rtc chip.

Signed-off-by: Soeren Andersen <san@rosetechnology.dk>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/i2c/trivial-devices.txt |    1=20
 drivers/rtc/Kconfig                                       |    8=20
 drivers/rtc/Makefile                                      |    1=20
 drivers/rtc/rtc-pcf85063.c                                |  204 +++++=
+++++
 4 files changed, 214 insertions(+)

diff -puN Documentation/devicetree/bindings/i2c/trivial-devices.txt~rtc=
-add-pcf85063-support Documentation/devicetree/bindings/i2c/trivial-dev=
ices.txt
--- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt~rtc-add=
-pcf85063-support
+++ a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
@@ -69,6 +69,7 @@ nuvoton,npct501		i2c trusted platform mo
 nxp,pca9556		Octal SMBus and I2C registered interface
 nxp,pca9557		8-bit I2C-bus and SMBus I/O port with reset
 nxp,pcf8563		Real-time clock/calendar
+nxp,pcf85063		Tiny Real-Time Clock
 ovti,ov5642		OV5642: Color CMOS QSXGA (5-megapixel) Image Sensor with =
OmniBSI and Embedded TrueFocus
 pericom,pt7c4338	Real-time Clock Module
 plx,pex8648		48-Lane, 12-Port PCI Express Gen 2 (5.0 GT/s) Switch
diff -puN drivers/rtc/Kconfig~rtc-add-pcf85063-support drivers/rtc/Kcon=
fig
--- a/drivers/rtc/Kconfig~rtc-add-pcf85063-support
+++ a/drivers/rtc/Kconfig
@@ -373,6 +373,14 @@ config RTC_DRV_PCF8563
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-pcf8563.
=20
+config RTC_DRV_PCF85063
+	tristate "nxp PCF85063"
+	help
+	  If you say yes here you get support for the PCF85063 RTC chip
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-pcf85063.
+
 config RTC_DRV_PCF8583
 	tristate "Philips PCF8583"
 	help
diff -puN drivers/rtc/Makefile~rtc-add-pcf85063-support drivers/rtc/Mak=
efile
--- a/drivers/rtc/Makefile~rtc-add-pcf85063-support
+++ a/drivers/rtc/Makefile
@@ -97,6 +97,7 @@ obj-$(CONFIG_RTC_DRV_PCAP)	+=3D rtc-pcap.o
 obj-$(CONFIG_RTC_DRV_PCF2127)	+=3D rtc-pcf2127.o
 obj-$(CONFIG_RTC_DRV_PCF8523)	+=3D rtc-pcf8523.o
 obj-$(CONFIG_RTC_DRV_PCF8563)	+=3D rtc-pcf8563.o
+obj-$(CONFIG_RTC_DRV_PCF85063)	+=3D rtc-pcf85063.o
 obj-$(CONFIG_RTC_DRV_PCF8583)	+=3D rtc-pcf8583.o
 obj-$(CONFIG_RTC_DRV_PCF2123)	+=3D rtc-pcf2123.o
 obj-$(CONFIG_RTC_DRV_PCF50633)	+=3D rtc-pcf50633.o
diff -puN /dev/null drivers/rtc/rtc-pcf85063.c
--- /dev/null
+++ a/drivers/rtc/rtc-pcf85063.c
@@ -0,0 +1,204 @@
+/*
+ * An I2C driver for the PCF85063 RTC
+ * Copyright 2014 Rose Technology
+ *
+ * Author: S=C3=B8ren Andersen <san@rosetechnology.dk>
+ * Maintainers: http://www.nslu2-linux.org/
+ *
+ * based on the other drivers in this same directory.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/i2c.h>
+#include <linux/bcd.h>
+#include <linux/rtc.h>
+#include <linux/module.h>
+
+#define DRV_VERSION "0.0.1"
+
+#define PCF85063_REG_CTRL1		0x00 /* status */
+#define PCF85063_REG_CTRL2		0x01
+
+#define PCF85063_REG_SC			0x04 /* datetime */
+#define PCF85063_REG_MN			0x05
+#define PCF85063_REG_HR			0x06
+#define PCF85063_REG_DM			0x07
+#define PCF85063_REG_DW			0x08
+#define PCF85063_REG_MO			0x09
+#define PCF85063_REG_YR			0x0A
+
+#define PCF85063_MO_C			0x80 /* century */
+
+static struct i2c_driver pcf85063_driver;
+
+struct pcf85063 {
+	struct rtc_device *rtc;
+	int c_polarity;	/* 0: MO_C=3D1 means 19xx, otherwise MO_C=3D1 means 2=
0xx */
+	int voltage_low; /* incicates if a low_voltage was detected */
+};
+
+/*
+ * In the routines that deal directly with the pcf85063 hardware, we u=
se
+ * rtc_time -- month 0-11, hour 0-23, yr =3D calendar year-epoch.
+ */
+static int pcf85063_get_datetime(struct i2c_client *client, struct rtc=
_time *tm)
+{
+	struct pcf85063 *pcf85063 =3D i2c_get_clientdata(client);
+	unsigned char buf[13] =3D { PCF85063_REG_CTRL1 };
+
+	struct i2c_msg msgs[] =3D {
+		{/* setup read ptr */
+			.addr =3D client->addr,
+			.len =3D 1,
+			.buf =3D buf
+		},
+		{/* read status + date */
+			.addr =3D client->addr,
+			.flags =3D I2C_M_RD,
+			.len =3D 13,
+			.buf =3D buf
+		},
+	};
+	/* read registers */
+	if ((i2c_transfer(client->adapter, msgs, 2)) !=3D 2) {
+		dev_err(&client->dev, "%s: read error\n", __func__);
+		return -EIO;
+	}
+
+	tm->tm_sec =3D bcd2bin(buf[PCF85063_REG_SC] & 0x7F);
+	tm->tm_min =3D bcd2bin(buf[PCF85063_REG_MN] & 0x7F);
+	tm->tm_hour =3D bcd2bin(buf[PCF85063_REG_HR] & 0x3F); /* rtc hr 0-23 =
*/
+	tm->tm_mday =3D bcd2bin(buf[PCF85063_REG_DM] & 0x3F);
+	tm->tm_wday =3D buf[PCF85063_REG_DW] & 0x07;
+	tm->tm_mon =3D bcd2bin(buf[PCF85063_REG_MO] & 0x1F) - 1; /* rtc mn 1-=
12 */
+	tm->tm_year =3D bcd2bin(buf[PCF85063_REG_YR]);
+	if (tm->tm_year < 70)
+		tm->tm_year +=3D 100;	/* assume we are in 1970...2069 */
+	/* detect the polarity heuristically. see note above. */
+	pcf85063->c_polarity =3D (buf[PCF85063_REG_MO] & PCF85063_MO_C) ?
+		(tm->tm_year >=3D 100) : (tm->tm_year < 100);
+
+	/* the clock can give out invalid datetime, but we cannot return
+	 * -EINVAL otherwise hwclock will refuse to set the time on bootup.
+	 */
+	if (rtc_valid_tm(tm) < 0)
+		dev_err(&client->dev, "retrieved date/time is not valid.\n");
+
+	return 0;
+}
+
+static int pcf85063_set_datetime(struct i2c_client *client, struct rtc=
_time *tm)
+{
+	int i =3D 0, err =3D 0;
+	unsigned char buf[11];
+
+	/* Control & status */
+	buf[PCF85063_REG_CTRL1] =3D 0;
+	buf[PCF85063_REG_CTRL2] =3D 5;
+
+	/* hours, minutes and seconds */
+	buf[PCF85063_REG_SC] =3D bin2bcd(tm->tm_sec) & 0x7F;
+
+	buf[PCF85063_REG_MN] =3D bin2bcd(tm->tm_min);
+	buf[PCF85063_REG_HR] =3D bin2bcd(tm->tm_hour);
+
+	/* Day of month, 1 - 31 */
+	buf[PCF85063_REG_DM] =3D bin2bcd(tm->tm_mday);
+
+	/* Day, 0 - 6 */
+	buf[PCF85063_REG_DW] =3D tm->tm_wday & 0x07;
+
+	/* month, 1 - 12 */
+	buf[PCF85063_REG_MO] =3D bin2bcd(tm->tm_mon + 1);
+
+	/* year and century */
+	buf[PCF85063_REG_YR] =3D bin2bcd(tm->tm_year % 100);
+
+	/* write register's data */
+	for (i =3D 0; i < sizeof(buf); i++) {
+		unsigned char data[2] =3D { i, buf[i] };
+
+		err =3D i2c_master_send(client, data, sizeof(data));
+		if (err !=3D sizeof(data)) {
+			dev_err(&client->dev, "%s: err=3D%d addr=3D%02x, data=3D%02x\n",
+					__func__, err, data[0], data[1]);
+			return -EIO;
+		}
+	}
+
+	return 0;
+}
+
+static int pcf85063_rtc_read_time(struct device *dev, struct rtc_time =
*tm)
+{
+	return pcf85063_get_datetime(to_i2c_client(dev), tm);
+}
+
+static int pcf85063_rtc_set_time(struct device *dev, struct rtc_time *=
tm)
+{
+	return pcf85063_set_datetime(to_i2c_client(dev), tm);
+}
+
+static const struct rtc_class_ops pcf85063_rtc_ops =3D {
+	.read_time	=3D pcf85063_rtc_read_time,
+	.set_time	=3D pcf85063_rtc_set_time
+};
+
+static int pcf85063_probe(struct i2c_client *client,
+				const struct i2c_device_id *id)
+{
+	struct pcf85063 *pcf85063;
+
+	dev_dbg(&client->dev, "%s\n", __func__);
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
+		return -ENODEV;
+
+	pcf85063 =3D devm_kzalloc(&client->dev, sizeof(struct pcf85063),
+				GFP_KERNEL);
+	if (!pcf85063)
+		return -ENOMEM;
+
+	dev_info(&client->dev, "chip found, driver version " DRV_VERSION "\n"=
);
+
+	i2c_set_clientdata(client, pcf85063);
+
+	pcf85063->rtc =3D devm_rtc_device_register(&client->dev,
+				pcf85063_driver.driver.name,
+				&pcf85063_rtc_ops, THIS_MODULE);
+
+	return PTR_ERR_OR_ZERO(pcf85063->rtc);
+}
+
+static const struct i2c_device_id pcf85063_id[] =3D {
+	{ "pcf85063", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, pcf85063_id);
+
+#ifdef CONFIG_OF
+static const struct of_device_id pcf85063_of_match[] =3D {
+	{ .compatible =3D "nxp,pcf85063" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, pcf85063_of_match);
+#endif
+
+static struct i2c_driver pcf85063_driver =3D {
+	.driver		=3D {
+		.name	=3D "rtc-pcf85063",
+		.owner	=3D THIS_MODULE,
+		.of_match_table =3D of_match_ptr(pcf85063_of_match),
+	},
+	.probe		=3D pcf85063_probe,
+	.id_table	=3D pcf85063_id,
+};
+
+module_i2c_driver(pcf85063_driver);
+
+MODULE_AUTHOR("S=C3=B8ren Andersen <san@rosetechnology.dk>");
+MODULE_DESCRIPTION("PCF85063 RTC driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
_

Patches currently in -mm which might be from san@rosetechnology.dk are

rtc-add-pcf85063-support.patch
rtc-add-pcf85063-support-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
