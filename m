From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-s35390ac-add-wakealarm-support-for-rtc-s35390a-rtc-chip.patch added to -mm tree
Date: Wed, 26 Sep 2012 12:55:33 -0700
Message-ID: <20120926195533.B10401E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:51749 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab2IZTze (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Sep 2012 15:55:34 -0400
Received: by yhl10 with SMTP id 10so13830yhl.1
        for <mm-commits@vger.kernel.org>; Wed, 26 Sep 2012 12:55:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.brainbug.langer@googlemail.com


The patch titled
     Subject: drivers/rtc/rtc-s35390a.c: add wakealarm support for rtc-s35390A rtc chip
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-s35390ac-add-wakealarm-support-for-rtc-s35390a-rtc-chip.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michael Langer <michael.brainbug.langer@googlemail.com>
Subject: drivers/rtc/rtc-s35390a.c: add wakealarm support for rtc-s35390A rtc chip

Add basic get/set alarm support for the Seiko Instruments S-35390A.  The
chip is used on the QNAP TS-219P+ NAS device.

Signed-off-by: Michael Langer <michael.brainbug.langer@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s35390a.c |  116 ++++++++++++++++++++++++++++++++++++
 1 file changed, 116 insertions(+)

diff -puN drivers/rtc/rtc-s35390a.c~drivers-rtc-rtc-s35390ac-add-wakealarm-support-for-rtc-s35390a-rtc-chip drivers/rtc/rtc-s35390a.c
--- a/drivers/rtc/rtc-s35390a.c~drivers-rtc-rtc-s35390ac-add-wakealarm-support-for-rtc-s35390a-rtc-chip
+++ a/drivers/rtc/rtc-s35390a.c
@@ -19,6 +19,8 @@
 #define S35390A_CMD_STATUS1	0
 #define S35390A_CMD_STATUS2	1
 #define S35390A_CMD_TIME1	2
+#define S35390A_CMD_TIME2	3
+#define S35390A_CMD_INT2_REG1	5
 
 #define S35390A_BYTE_YEAR	0
 #define S35390A_BYTE_MONTH	1
@@ -28,12 +30,23 @@
 #define S35390A_BYTE_MINS	5
 #define S35390A_BYTE_SECS	6
 
+#define S35390A_ALRM_BYTE_WDAY	0
+#define S35390A_ALRM_BYTE_HOURS	1
+#define S35390A_ALRM_BYTE_MINS	2
+
 #define S35390A_FLAG_POC	0x01
 #define S35390A_FLAG_BLD	0x02
 #define S35390A_FLAG_24H	0x40
 #define S35390A_FLAG_RESET	0x80
 #define S35390A_FLAG_TEST	0x01
 
+#define S35390A_INT2_MODE_MASK		0xF0
+
+#define S35390A_INT2_MODE_NOINTR	0x00
+#define S35390A_INT2_MODE_FREQ		0x10
+#define S35390A_INT2_MODE_ALARM		0x40
+#define S35390A_INT2_MODE_PMIN_EDG	0x20
+
 static const struct i2c_device_id s35390a_id[] = {
 	{ "s35390a", 0 },
 	{ }
@@ -193,6 +206,104 @@ static int s35390a_get_datetime(struct i
 	return rtc_valid_tm(tm);
 }
 
+static int s35390a_set_alarm(struct i2c_client *client, struct rtc_wkalrm *alm)
+{
+	struct s35390a *s35390a = i2c_get_clientdata(client);
+	char buf[3], sts = 0;
+	int err, i;
+
+	dev_dbg(&client->dev, "%s: alm is secs=%d, mins=%d, hours=%d mday=%d, "\
+		"mon=%d, year=%d, wday=%d\n", __func__, alm->time.tm_sec,
+		alm->time.tm_min, alm->time.tm_hour, alm->time.tm_mday,
+		alm->time.tm_mon, alm->time.tm_year, alm->time.tm_wday);
+
+	/* disable interrupt */
+	err = s35390a_set_reg(s35390a, S35390A_CMD_STATUS2, &sts, sizeof(sts));
+	if (err < 0)
+		return err;
+
+	/* clear pending interrupt, if any */
+	err = s35390a_get_reg(s35390a, S35390A_CMD_STATUS1, &sts, sizeof(sts));
+	if (err < 0)
+		return err;
+
+	if (alm->enabled)
+		sts = S35390A_INT2_MODE_ALARM;
+	else
+		sts = S35390A_INT2_MODE_NOINTR;
+
+	/* This chip expects the bits of each byte to be in reverse order */
+	sts = bitrev8(sts);
+
+	/* set interupt mode*/
+	err = s35390a_set_reg(s35390a, S35390A_CMD_STATUS2, &sts, sizeof(sts));
+	if (err < 0)
+		return err;
+
+	if (alm->time.tm_wday != -1)
+		buf[S35390A_ALRM_BYTE_WDAY] = bin2bcd(alm->time.tm_wday) | 0x80;
+
+	buf[S35390A_ALRM_BYTE_HOURS] = s35390a_hr2reg(s35390a,
+			alm->time.tm_hour) | 0x80;
+	buf[S35390A_ALRM_BYTE_MINS] = bin2bcd(alm->time.tm_min) | 0x80;
+
+	if (alm->time.tm_hour >= 12)
+		buf[S35390A_ALRM_BYTE_HOURS] |= 0x40;
+
+	for (i = 0; i < 3; ++i)
+		buf[i] = bitrev8(buf[i]);
+
+	err = s35390a_set_reg(s35390a, S35390A_CMD_INT2_REG1, buf,
+								sizeof(buf));
+
+	return err;
+}
+
+static int s35390a_read_alarm(struct i2c_client *client, struct rtc_wkalrm *alm)
+{
+	struct s35390a *s35390a = i2c_get_clientdata(client);
+	char buf[3], sts;
+	int i, err;
+
+	err = s35390a_get_reg(s35390a, S35390A_CMD_STATUS2, &sts, sizeof(sts));
+	if (err < 0)
+		return err;
+
+	if (bitrev8(sts) != S35390A_INT2_MODE_ALARM)
+		return -EINVAL;
+
+	err = s35390a_get_reg(s35390a, S35390A_CMD_INT2_REG1, buf, sizeof(buf));
+	if (err < 0)
+		return err;
+
+	/* This chip returns the bits of each byte in reverse order */
+	for (i = 0; i < 3; ++i) {
+		buf[i] = bitrev8(buf[i]);
+		buf[i] &= ~0x80;
+	}
+
+	alm->time.tm_wday = bcd2bin(buf[S35390A_ALRM_BYTE_WDAY]);
+	alm->time.tm_hour = s35390a_reg2hr(s35390a,
+						buf[S35390A_ALRM_BYTE_HOURS]);
+	alm->time.tm_min = bcd2bin(buf[S35390A_ALRM_BYTE_MINS]);
+
+	dev_dbg(&client->dev, "%s: alm is mins=%d, hours=%d, wday=%d\n",
+			__func__, alm->time.tm_min, alm->time.tm_hour,
+			alm->time.tm_wday);
+
+	return 0;
+}
+
+static int s35390a_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
+{
+	return s35390a_read_alarm(to_i2c_client(dev), alm);
+}
+
+static int s35390a_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
+{
+	return s35390a_set_alarm(to_i2c_client(dev), alm);
+}
+
 static int s35390a_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	return s35390a_get_datetime(to_i2c_client(dev), tm);
@@ -206,6 +317,9 @@ static int s35390a_rtc_set_time(struct d
 static const struct rtc_class_ops s35390a_rtc_ops = {
 	.read_time	= s35390a_rtc_read_time,
 	.set_time	= s35390a_rtc_set_time,
+	.set_alarm	= s35390a_rtc_set_alarm,
+	.read_alarm	= s35390a_rtc_read_alarm,
+
 };
 
 static struct i2c_driver s35390a_driver;
@@ -270,6 +384,8 @@ static int s35390a_probe(struct i2c_clie
 	if (s35390a_get_datetime(client, &tm) < 0)
 		dev_warn(&client->dev, "clock needs to be set\n");
 
+	device_set_wakeup_capable(&client->dev, 1);
+
 	s35390a->rtc = rtc_device_register(s35390a_driver.driver.name,
 				&client->dev, &s35390a_rtc_ops, THIS_MODULE);
 
_

Patches currently in -mm which might be from michael.brainbug.langer@googlemail.com are

drivers-rtc-rtc-s35390ac-add-wakealarm-support-for-rtc-s35390a-rtc-chip.patch

