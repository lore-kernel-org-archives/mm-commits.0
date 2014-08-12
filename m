From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-pcf8563-add-alarm-support.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:38:48 -0700
Message-ID: <53ea6d48.lrpcAkqBRyvVhBcy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yk0-f201.google.com ([209.85.160.201]:34110 "EHLO
	mail-yk0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929AbaHLTit (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:38:49 -0400
Received: by mail-yk0-f201.google.com with SMTP id 142so1306880ykq.4
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:38:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdonnefort@gmail.com, a.zummo@towertech.it, andrew@lunn.ch, dan.carpenter@oracle.com, jason@lakedaemon.net, simon.guinot@sequanux.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-pcf8563.c: add alarm support
has been removed from the -mm tree.  Its filename was
     rtc-rtc-pcf8563-add-alarm-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vincent Donnefort <vdonnefort@gmail.com>
Subject: drivers/rtc/rtc-pcf8563.c: add alarm support

This patch adds alarm support for the NXP PCF8563 chip.

Signed-off-by: Vincent Donnefort <vdonnefort@gmail.com>
Cc: Simon Guinot <simon.guinot@sequanux.org>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8563.c |  157 +++++++++++++++++++++++++++++++++++-
 1 file changed, 153 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-pcf8563.c~rtc-rtc-pcf8563-add-alarm-support drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~rtc-rtc-pcf8563-add-alarm-support
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -26,6 +26,8 @@
 
 #define PCF8563_REG_ST1		0x00 /* status */
 #define PCF8563_REG_ST2		0x01
+#define PCF8563_BIT_AIE		(1 << 1)
+#define PCF8563_BIT_AF		(1 << 3)
 
 #define PCF8563_REG_SC		0x02 /* datetime */
 #define PCF8563_REG_MN		0x03
@@ -36,9 +38,6 @@
 #define PCF8563_REG_YR		0x08
 
 #define PCF8563_REG_AMN		0x09 /* alarm */
-#define PCF8563_REG_AHR		0x0A
-#define PCF8563_REG_ADM		0x0B
-#define PCF8563_REG_ADW		0x0C
 
 #define PCF8563_REG_CLKO	0x0D /* clock out */
 #define PCF8563_REG_TMRC	0x0E /* timer control */
@@ -67,6 +66,8 @@ struct pcf8563 {
 	 */
 	int c_polarity;	/* 0: MO_C=1 means 19xx, otherwise MO_C=1 means 20xx */
 	int voltage_low; /* incicates if a low_voltage was detected */
+
+	struct i2c_client *client;
 };
 
 static int pcf8563_read_block_data(struct i2c_client *client, unsigned char reg,
@@ -115,6 +116,69 @@ static int pcf8563_write_block_data(stru
 	return 0;
 }
 
+static int pcf8563_set_alarm_mode(struct i2c_client *client, bool on)
+{
+	unsigned char buf[2];
+	int err;
+
+	err = pcf8563_read_block_data(client, PCF8563_REG_ST2, 1, buf + 1);
+	if (err < 0)
+		return err;
+
+	if (on)
+		buf[1] |= PCF8563_BIT_AIE;
+	else
+		buf[1] &= ~PCF8563_BIT_AIE;
+
+	buf[1] &= ~PCF8563_BIT_AF;
+	buf[0] = PCF8563_REG_ST2;
+
+	err = pcf8563_write_block_data(client, PCF8563_REG_ST2, 1, buf + 1);
+	if (err < 0) {
+		dev_err(&client->dev, "%s: write error\n", __func__);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int pcf8563_get_alarm_mode(struct i2c_client *client, unsigned char *en,
+				  unsigned char *pen)
+{
+	unsigned char buf;
+	int err;
+
+	err = pcf8563_read_block_data(client, PCF8563_REG_ST2, 1, &buf);
+	if (err)
+		return err;
+
+	if (en)
+		*en = !!(buf & PCF8563_BIT_AIE);
+	if (pen)
+		*pen = !!(buf & PCF8563_BIT_AF);
+
+	return 0;
+}
+
+static irqreturn_t pcf8563_irq(int irq, void *dev_id)
+{
+	struct pcf8563 *pcf8563 = i2c_get_clientdata(dev_id);
+	int err;
+	char pending;
+
+	err = pcf8563_get_alarm_mode(pcf8563->client, NULL, &pending);
+	if (err < 0)
+		return err;
+
+	if (pending) {
+		rtc_update_irq(pcf8563->rtc, 1, RTC_IRQF | RTC_AF);
+		pcf8563_set_alarm_mode(pcf8563->client, 1);
+		return IRQ_HANDLED;
+	}
+
+	return IRQ_NONE;
+}
+
 /*
  * In the routines that deal directly with the pcf8563 hardware, we use
  * rtc_time -- month 0-11, hour 0-23, yr = calendar year-epoch.
@@ -257,16 +321,83 @@ static int pcf8563_rtc_set_time(struct d
 	return pcf8563_set_datetime(to_i2c_client(dev), tm);
 }
 
+static int pcf8563_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *tm)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	unsigned char buf[4];
+	int err;
+
+	err = pcf8563_read_block_data(client, PCF8563_REG_AMN, 4, buf);
+	if (err)
+		return err;
+
+	dev_dbg(&client->dev,
+		"%s: raw data is min=%02x, hr=%02x, mday=%02x, wday=%02x\n",
+		__func__, buf[0], buf[1], buf[2], buf[3]);
+
+	tm->time.tm_min = bcd2bin(buf[0] & 0x7F);
+	tm->time.tm_hour = bcd2bin(buf[1] & 0x7F);
+	tm->time.tm_mday = bcd2bin(buf[2] & 0x1F);
+	tm->time.tm_wday = bcd2bin(buf[3] & 0x7);
+	tm->time.tm_mon = -1;
+	tm->time.tm_year = -1;
+	tm->time.tm_yday = -1;
+	tm->time.tm_isdst = -1;
+
+	err = pcf8563_get_alarm_mode(client, &tm->enabled, &tm->pending);
+	if (err < 0)
+		return err;
+
+	dev_dbg(&client->dev, "%s: tm is mins=%d, hours=%d, mday=%d, wday=%d,"
+		" enabled=%d, pending=%d\n", __func__, tm->time.tm_min,
+		tm->time.tm_hour, tm->time.tm_mday, tm->time.tm_wday,
+		tm->enabled, tm->pending);
+
+	return 0;
+}
+
+static int pcf8563_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *tm)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	unsigned char buf[4];
+	int err;
+
+	dev_dbg(dev, "%s, min=%d hour=%d wday=%d mday=%d "
+		"enabled=%d pending=%d\n", __func__,
+		tm->time.tm_min, tm->time.tm_hour, tm->time.tm_wday,
+		tm->time.tm_mday, tm->enabled, tm->pending);
+
+	buf[0] = bin2bcd(tm->time.tm_min);
+	buf[1] = bin2bcd(tm->time.tm_hour);
+	buf[2] = bin2bcd(tm->time.tm_mday);
+	buf[3] = tm->time.tm_wday & 0x07;
+
+	err = pcf8563_write_block_data(client, PCF8563_REG_AMN, 4, buf);
+	if (err)
+		return err;
+
+	return pcf8563_set_alarm_mode(client, 1);
+}
+
+static int pcf8563_irq_enable(struct device *dev, unsigned int enabled)
+{
+	return pcf8563_set_alarm_mode(to_i2c_client(dev), !!enabled);
+}
+
 static const struct rtc_class_ops pcf8563_rtc_ops = {
 	.ioctl		= pcf8563_rtc_ioctl,
 	.read_time	= pcf8563_rtc_read_time,
 	.set_time	= pcf8563_rtc_set_time,
+	.read_alarm	= pcf8563_rtc_read_alarm,
+	.set_alarm	= pcf8563_rtc_set_alarm,
+	.alarm_irq_enable = pcf8563_irq_enable,
 };
 
 static int pcf8563_probe(struct i2c_client *client,
 				const struct i2c_device_id *id)
 {
 	struct pcf8563 *pcf8563;
+	int err;
 
 	dev_dbg(&client->dev, "%s\n", __func__);
 
@@ -281,12 +412,30 @@ static int pcf8563_probe(struct i2c_clie
 	dev_info(&client->dev, "chip found, driver version " DRV_VERSION "\n");
 
 	i2c_set_clientdata(client, pcf8563);
+	pcf8563->client = client;
+	device_set_wakeup_capable(&client->dev, 1);
 
 	pcf8563->rtc = devm_rtc_device_register(&client->dev,
 				pcf8563_driver.driver.name,
 				&pcf8563_rtc_ops, THIS_MODULE);
 
-	return PTR_ERR_OR_ZERO(pcf8563->rtc);
+	if (IS_ERR(pcf8563->rtc))
+		return PTR_ERR(pcf8563->rtc);
+
+	if (client->irq > 0) {
+		err = devm_request_threaded_irq(&client->dev, client->irq,
+				NULL, pcf8563_irq,
+				IRQF_SHARED|IRQF_ONESHOT|IRQF_TRIGGER_FALLING,
+				pcf8563->rtc->name, client);
+		if (err) {
+			dev_err(&client->dev, "unable to request IRQ %d\n",
+								client->irq);
+			return err;
+		}
+
+	}
+
+	return 0;
 }
 
 static const struct i2c_device_id pcf8563_id[] = {
_

Patches currently in -mm which might be from vdonnefort@gmail.com are

origin.patch

