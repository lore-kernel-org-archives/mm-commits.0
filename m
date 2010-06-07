From: akpm@linux-foundation.org
Subject: + rtc-fixes-and-new-functionality-for-fm3130.patch added to -mm tree
Date: Mon, 07 Jun 2010 13:33:22 -0700
Message-ID: <201006072033.o57KXNQo026773@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751406Ab0FGUdk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jun 2010 16:33:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geomatsi@gmail.com, a.zummo@towertech.it, mcuos.com@gmail.com, slapin@ossfans.org


The patch titled
     rtc: fixes and new functionality for fm3130
has been added to the -mm tree.  Its filename is
     rtc-fixes-and-new-functionality-for-fm3130.patch

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
Subject: rtc: fixes and new functionality for fm3130
From: Sergey Matyukevich <geomatsi@gmail.com>

- add sanity check for alarm data in fm3130_probe

- fix fm3130_set_alarm.

  According to the datasheet, setting match bit '0' indicates that the
  corresponding alarm field will be used in the match process

- add operation alarm_irq_enable operation which is responsible for
  handling RTC_AIE_ON, RTC_AIE_OFF ioctls

- remove clearing of AF bit after reading rtc/alarm control register:
  according to datasheet this bit is cleared anyway when rtc/alarm control
  register is read

Signed-off-by: Sergey Matyukevich <geomatsi@gmail.com>
Acked-by: Wan ZongShun <mcuos.com@gmail.com>
Acked-by: Sergey Lapin <slapin@ossfans.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-fm3130.c |  187 ++++++++++++++++++++++++++-----------
 1 file changed, 132 insertions(+), 55 deletions(-)

diff -puN drivers/rtc/rtc-fm3130.c~rtc-fixes-and-new-functionality-for-fm3130 drivers/rtc/rtc-fm3130.c
--- a/drivers/rtc/rtc-fm3130.c~rtc-fixes-and-new-functionality-for-fm3130
+++ a/drivers/rtc/rtc-fm3130.c
@@ -52,8 +52,8 @@ struct fm3130 {
 	struct i2c_msg		msg[4];
 	struct i2c_client	*client;
 	struct rtc_device	*rtc;
+	int			alarm_valid;
 	int			data_valid;
-	int			alarm;
 };
 static const struct i2c_device_id fm3130_id[] = {
 	{ "fm3130", 0 },
@@ -87,11 +87,7 @@ static void fm3130_rtc_mode(struct devic
 		dev_dbg(dev, "invalid mode %d\n", mode);
 		break;
 	}
-	/* Checking for alarm */
-	if (fm3130->regs[FM3130_RTC_CONTROL] & FM3130_RTC_CONTROL_BIT_AF) {
-		fm3130->alarm = 1;
-		fm3130->regs[FM3130_RTC_CONTROL] &= ~FM3130_RTC_CONTROL_BIT_AF;
-	}
+
 	i2c_smbus_write_byte_data(fm3130->client,
 		 FM3130_RTC_CONTROL, fm3130->regs[FM3130_RTC_CONTROL]);
 }
@@ -208,6 +204,15 @@ static int fm3130_read_alarm(struct devi
 	struct fm3130 *fm3130 = dev_get_drvdata(dev);
 	int tmp;
 	struct rtc_time *tm = &alrm->time;
+
+	if (!fm3130->alarm_valid) {
+		/* We have invalid alarm in RTC, probably due
+		to battery faults or other problems. Return EIO
+		for now, it will allow us to set alarm value later
+		instead of error during probing which disables device */
+		return -EIO;
+	}
+
 	/* read the RTC alarm registers all at once */
 	tmp = i2c_transfer(to_i2c_adapter(fm3130->client->dev.parent),
 			&fm3130->msg[2], 2);
@@ -222,20 +227,31 @@ static int fm3130_read_alarm(struct devi
 			fm3130->regs[FM3130_ALARM_DATE],
 			fm3130->regs[FM3130_ALARM_MONTHS]);
 
-
 	tm->tm_sec	= bcd2bin(fm3130->regs[FM3130_ALARM_SECONDS] & 0x7F);
 	tm->tm_min	= bcd2bin(fm3130->regs[FM3130_ALARM_MINUTES] & 0x7F);
 	tm->tm_hour	= bcd2bin(fm3130->regs[FM3130_ALARM_HOURS] & 0x3F);
 	tm->tm_mday	= bcd2bin(fm3130->regs[FM3130_ALARM_DATE] & 0x3F);
 	tm->tm_mon	= bcd2bin(fm3130->regs[FM3130_ALARM_MONTHS] & 0x1F);
+
 	if (tm->tm_mon > 0)
 		tm->tm_mon -= 1; /* RTC is 1-12, tm_mon is 0-11 */
+
 	dev_dbg(dev, "%s secs=%d, mins=%d, "
 		"hours=%d, mday=%d, mon=%d, year=%d, wday=%d\n",
 		"read alarm", tm->tm_sec, tm->tm_min,
 		tm->tm_hour, tm->tm_mday,
 		tm->tm_mon, tm->tm_year, tm->tm_wday);
 
+	/* check if alarm enabled */
+	fm3130->regs[FM3130_RTC_CONTROL] =
+		i2c_smbus_read_byte_data(fm3130->client, FM3130_RTC_CONTROL);
+
+	if ((fm3130->regs[FM3130_RTC_CONTROL] & FM3130_RTC_CONTROL_BIT_AEN) &&
+		(~fm3130->regs[FM3130_RTC_CONTROL] &
+			FM3130_RTC_CONTROL_BIT_CAL)) {
+		alrm->enabled = 1;
+	}
+
 	return 0;
 }
 
@@ -251,25 +267,20 @@ static int fm3130_set_alarm(struct devic
 		tm->tm_hour, tm->tm_mday,
 		tm->tm_mon, tm->tm_year, tm->tm_wday);
 
-	if (tm->tm_sec != -1)
-		fm3130->regs[FM3130_ALARM_SECONDS] =
-			bin2bcd(tm->tm_sec) | 0x80;
-
-	if (tm->tm_min != -1)
-		fm3130->regs[FM3130_ALARM_MINUTES] =
-			bin2bcd(tm->tm_min) | 0x80;
-
-	if (tm->tm_hour != -1)
-		fm3130->regs[FM3130_ALARM_HOURS] =
-			bin2bcd(tm->tm_hour) | 0x80;
-
-	if (tm->tm_mday != -1)
-		fm3130->regs[FM3130_ALARM_DATE] =
-			bin2bcd(tm->tm_mday) | 0x80;
-
-	if (tm->tm_mon != -1)
-		fm3130->regs[FM3130_ALARM_MONTHS] =
-			bin2bcd(tm->tm_mon + 1) | 0x80;
+	fm3130->regs[FM3130_ALARM_SECONDS] =
+		(tm->tm_sec != -1) ? bin2bcd(tm->tm_sec) : 0x80;
+
+	fm3130->regs[FM3130_ALARM_MINUTES] =
+		(tm->tm_min != -1) ? bin2bcd(tm->tm_min) : 0x80;
+
+	fm3130->regs[FM3130_ALARM_HOURS] =
+		(tm->tm_hour != -1) ? bin2bcd(tm->tm_hour) : 0x80;
+
+	fm3130->regs[FM3130_ALARM_DATE] =
+		(tm->tm_mday != -1) ? bin2bcd(tm->tm_mday) : 0x80;
+
+	fm3130->regs[FM3130_ALARM_MONTHS] =
+		(tm->tm_mon != -1) ? bin2bcd(tm->tm_mon + 1) : 0x80;
 
 	dev_dbg(dev, "alarm write %02x %02x %02x %02x %02x\n",
 			fm3130->regs[FM3130_ALARM_SECONDS],
@@ -285,11 +296,8 @@ static int fm3130_set_alarm(struct devic
 	}
 	fm3130->regs[FM3130_RTC_CONTROL] =
 		i2c_smbus_read_byte_data(fm3130->client, FM3130_RTC_CONTROL);
-	/* Checking for alarm */
-	if (fm3130->regs[FM3130_RTC_CONTROL] & FM3130_RTC_CONTROL_BIT_AF) {
-		fm3130->alarm = 1;
-		fm3130->regs[FM3130_RTC_CONTROL] &= ~FM3130_RTC_CONTROL_BIT_AF;
-	}
+
+	/* enable or disable alarm */
 	if (alrm->enabled) {
 		i2c_smbus_write_byte_data(fm3130->client, FM3130_RTC_CONTROL,
 			(fm3130->regs[FM3130_RTC_CONTROL] &
@@ -298,16 +306,55 @@ static int fm3130_set_alarm(struct devic
 	} else {
 		i2c_smbus_write_byte_data(fm3130->client, FM3130_RTC_CONTROL,
 			fm3130->regs[FM3130_RTC_CONTROL] &
-				~(FM3130_RTC_CONTROL_BIT_AEN));
+				~(FM3130_RTC_CONTROL_BIT_CAL) &
+					~(FM3130_RTC_CONTROL_BIT_AEN));
 	}
+
+	/* We assume here that data is valid once written */
+	if (!fm3130->alarm_valid)
+		fm3130->alarm_valid = 1;
+
 	return 0;
 }
 
+int fm3130_alarm_irq_enable(struct device *dev, unsigned int enabled)
+{
+	struct fm3130 *fm3130 = dev_get_drvdata(dev);
+	int ret = 0;
+
+	fm3130->regs[FM3130_RTC_CONTROL] =
+		i2c_smbus_read_byte_data(fm3130->client, FM3130_RTC_CONTROL);
+
+	dev_dbg(dev, "alarm_irq_enable: enable=%d, FM3130_RTC_CONTROL=%02x\n",
+		enabled, fm3130->regs[FM3130_RTC_CONTROL]);
+
+	switch (enabled) {
+	case 0:		/* alarm off */
+		ret = i2c_smbus_write_byte_data(fm3130->client,
+			FM3130_RTC_CONTROL, fm3130->regs[FM3130_RTC_CONTROL] &
+				~(FM3130_RTC_CONTROL_BIT_CAL) &
+					~(FM3130_RTC_CONTROL_BIT_AEN));
+		break;
+	case 1:		/* alarm on */
+		ret = i2c_smbus_write_byte_data(fm3130->client,
+			FM3130_RTC_CONTROL, (fm3130->regs[FM3130_RTC_CONTROL] &
+				~(FM3130_RTC_CONTROL_BIT_CAL)) |
+					FM3130_RTC_CONTROL_BIT_AEN);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
 static const struct rtc_class_ops fm3130_rtc_ops = {
 	.read_time	= fm3130_get_time,
 	.set_time	= fm3130_set_time,
 	.read_alarm	= fm3130_read_alarm,
 	.set_alarm	= fm3130_set_alarm,
+	.alarm_irq_enable = fm3130_alarm_irq_enable,
 };
 
 static struct i2c_driver fm3130_driver;
@@ -356,6 +403,7 @@ static int __devinit fm3130_probe(struct
 	fm3130->msg[3].len = FM3130_ALARM_REGS;
 	fm3130->msg[3].buf = &fm3130->regs[FM3130_ALARM_SECONDS];
 
+	fm3130->alarm_valid = 0;
 	fm3130->data_valid = 0;
 
 	tmp = i2c_transfer(adapter, fm3130->msg, 4);
@@ -370,12 +418,6 @@ static int __devinit fm3130_probe(struct
 	fm3130->regs[FM3130_CAL_CONTROL] =
 		i2c_smbus_read_byte_data(client, FM3130_CAL_CONTROL);
 
-	/* Checking for alarm */
-	if (fm3130->regs[FM3130_RTC_CONTROL] & FM3130_RTC_CONTROL_BIT_AF) {
-		fm3130->alarm = 1;
-		fm3130->regs[FM3130_RTC_CONTROL] &= ~FM3130_RTC_CONTROL_BIT_AF;
-	}
-
 	/* Disabling calibration mode */
 	if (fm3130->regs[FM3130_RTC_CONTROL] & FM3130_RTC_CONTROL_BIT_CAL) {
 		i2c_smbus_write_byte_data(client, FM3130_RTC_CONTROL,
@@ -400,44 +442,79 @@ static int __devinit fm3130_probe(struct
 			fm3130->regs[FM3130_CAL_CONTROL] &
 				~(FM3130_CAL_CONTROL_BIT_nOSCEN));
 
-	/* oscillator fault?  clear flag, and warn */
-	if (fm3130->regs[FM3130_RTC_CONTROL] & FM3130_RTC_CONTROL_BIT_LB)
+	/* low battery?  clear flag, and warn */
+	if (fm3130->regs[FM3130_RTC_CONTROL] & FM3130_RTC_CONTROL_BIT_LB) {
+		i2c_smbus_write_byte_data(client, FM3130_RTC_CONTROL,
+			fm3130->regs[FM3130_RTC_CONTROL] &
+				~(FM3130_RTC_CONTROL_BIT_LB));
 		dev_warn(&client->dev, "Low battery!\n");
+	}
 
-	/* oscillator fault?  clear flag, and warn */
+	/* check if Power On Reset bit is set */
 	if (fm3130->regs[FM3130_RTC_CONTROL] & FM3130_RTC_CONTROL_BIT_POR) {
 		i2c_smbus_write_byte_data(client, FM3130_RTC_CONTROL,
 			fm3130->regs[FM3130_RTC_CONTROL] &
 				~FM3130_RTC_CONTROL_BIT_POR);
-		dev_warn(&client->dev, "SET TIME!\n");
+		dev_dbg(&client->dev, "POR bit is set\n");
 	}
 	/* ACS is controlled by alarm */
 	i2c_smbus_write_byte_data(client, FM3130_ALARM_WP_CONTROL, 0x80);
 
-	/* TODO */
-	/* TODO need to sanity check alarm */
-	tmp = fm3130->regs[FM3130_RTC_SECONDS];
-	tmp = bcd2bin(tmp & 0x7f);
-	if (tmp > 60)
-		goto exit_bad;
+	/* alarm registers sanity check */
+	tmp = bcd2bin(fm3130->regs[FM3130_RTC_SECONDS] & 0x7f);
+	if (tmp > 59)
+		goto bad_alarm;
+
 	tmp = bcd2bin(fm3130->regs[FM3130_RTC_MINUTES] & 0x7f);
-	if (tmp > 60)
-		goto exit_bad;
+	if (tmp > 59)
+		goto bad_alarm;
+
+	tmp = bcd2bin(fm3130->regs[FM3130_RTC_HOURS] & 0x3f);
+	if (tmp > 23)
+		goto bad_alarm;
 
 	tmp = bcd2bin(fm3130->regs[FM3130_RTC_DATE] & 0x3f);
 	if (tmp == 0 || tmp > 31)
-		goto exit_bad;
+		goto bad_alarm;
 
 	tmp = bcd2bin(fm3130->regs[FM3130_RTC_MONTHS] & 0x1f);
 	if (tmp == 0 || tmp > 12)
-		goto exit_bad;
+		goto bad_alarm;
+
+	fm3130->alarm_valid = 1;
+
+bad_alarm:
 
-	tmp = fm3130->regs[FM3130_RTC_HOURS];
+	/* clock registers sanity chek */
+	tmp = bcd2bin(fm3130->regs[FM3130_RTC_SECONDS] & 0x7f);
+	if (tmp > 59)
+		goto bad_clock;
+
+	tmp = bcd2bin(fm3130->regs[FM3130_RTC_MINUTES] & 0x7f);
+	if (tmp > 59)
+		goto bad_clock;
+
+	tmp = bcd2bin(fm3130->regs[FM3130_RTC_HOURS] & 0x3f);
+	if (tmp > 23)
+		goto bad_clock;
+
+	tmp = bcd2bin(fm3130->regs[FM3130_RTC_DAY] & 0x7);
+	if (tmp == 0 || tmp > 7)
+		goto bad_clock;
+
+	tmp = bcd2bin(fm3130->regs[FM3130_RTC_DATE] & 0x3f);
+	if (tmp == 0 || tmp > 31)
+		goto bad_clock;
+
+	tmp = bcd2bin(fm3130->regs[FM3130_RTC_MONTHS] & 0x1f);
+	if (tmp == 0 || tmp > 12)
+		goto bad_clock;
 
 	fm3130->data_valid = 1;
 
-exit_bad:
-	if (!fm3130->data_valid)
+bad_clock:
+
+	if (!fm3130->data_valid || !fm3130->alarm_valid)
 		dev_dbg(&client->dev,
 				"%s: %02x %02x %02x %02x %02x %02x %02x %02x"
 				"%02x %02x %02x %02x %02x %02x %02x\n",
_

Patches currently in -mm which might be from geomatsi@gmail.com are

rtc-fixes-and-new-functionality-for-fm3130.patch
rtc-fixes-and-new-functionality-for-fm3130-fix.patch

