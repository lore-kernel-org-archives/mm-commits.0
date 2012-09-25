From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-m41t80c-remove-disabled-alarm-functionality.patch added to -mm tree
Date: Tue, 25 Sep 2012 14:58:41 -0700
Message-ID: <20120925215842.0D5E25C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:59196 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab2IYV6o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Sep 2012 17:58:44 -0400
Received: by faet1 with SMTP id t1so473584fae.1
        for <mm-commits@vger.kernel.org>; Tue, 25 Sep 2012 14:58:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pebolle@tiscali.nl, john.stultz@linaro.org


The patch titled
     Subject: drivers/rtc/rtc-m41t80.c: remove disabled alarm functionality
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-m41t80c-remove-disabled-alarm-functionality.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Paul Bolle <pebolle@tiscali.nl>
Subject: drivers/rtc/rtc-m41t80.c: remove disabled alarm functionality

Commit c3b79770e51ab1fd ("rtc: m41t80: Workaround broken alarm
functionality") disabled m41t80's alarm functions.  But since those
functions were not touched, building this driver triggers these GCC
warnings:

    drivers/rtc/rtc-m41t80.c:216:12: warning: 'm41t80_rtc_alarm_irq_enable' defined but not used [-Wunused-function]
    drivers/rtc/rtc-m41t80.c:238:12: warning: 'm41t80_rtc_set_alarm' defined but not used [-Wunused-function]
    drivers/rtc/rtc-m41t80.c:308:12: warning: 'm41t80_rtc_read_alarm' defined but not used [-Wunused-function]

Remove these functions (and the commented out references to them) to
silence these warnings.  Anyone wanting to fix the alarm irq functionality
can easily find the removed code in the git log of this file or through
some web searches.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m41t80.c |  157 -------------------------------------
 1 file changed, 4 insertions(+), 153 deletions(-)

diff -puN drivers/rtc/rtc-m41t80.c~drivers-rtc-rtc-m41t80c-remove-disabled-alarm-functionality drivers/rtc/rtc-m41t80.c
--- a/drivers/rtc/rtc-m41t80.c~drivers-rtc-rtc-m41t80c-remove-disabled-alarm-functionality
+++ a/drivers/rtc/rtc-m41t80.c
@@ -213,163 +213,14 @@ static int m41t80_rtc_set_time(struct de
 	return m41t80_set_datetime(to_i2c_client(dev), tm);
 }
 
-static int m41t80_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
-{
-	struct i2c_client *client = to_i2c_client(dev);
-	int rc;
-
-	rc = i2c_smbus_read_byte_data(client, M41T80_REG_ALARM_MON);
-	if (rc < 0)
-		goto err;
-
-	if (enabled)
-		rc |= M41T80_ALMON_AFE;
-	else
-		rc &= ~M41T80_ALMON_AFE;
-
-	if (i2c_smbus_write_byte_data(client, M41T80_REG_ALARM_MON, rc) < 0)
-		goto err;
-
-	return 0;
-err:
-	return -EIO;
-}
-
-static int m41t80_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *t)
-{
-	struct i2c_client *client = to_i2c_client(dev);
-	u8 wbuf[1 + M41T80_ALARM_REG_SIZE];
-	u8 *buf = &wbuf[1];
-	u8 *reg = buf - M41T80_REG_ALARM_MON;
-	u8 dt_addr[1] = { M41T80_REG_ALARM_MON };
-	struct i2c_msg msgs_in[] = {
-		{
-			.addr	= client->addr,
-			.flags	= 0,
-			.len	= 1,
-			.buf	= dt_addr,
-		},
-		{
-			.addr	= client->addr,
-			.flags	= I2C_M_RD,
-			.len	= M41T80_ALARM_REG_SIZE,
-			.buf	= buf,
-		},
-	};
-	struct i2c_msg msgs[] = {
-		{
-			.addr	= client->addr,
-			.flags	= 0,
-			.len	= 1 + M41T80_ALARM_REG_SIZE,
-			.buf	= wbuf,
-		 },
-	};
-
-	if (i2c_transfer(client->adapter, msgs_in, 2) < 0) {
-		dev_err(&client->dev, "read error\n");
-		return -EIO;
-	}
-	reg[M41T80_REG_ALARM_MON] &= ~(0x1f | M41T80_ALMON_AFE);
-	reg[M41T80_REG_ALARM_DAY] = 0;
-	reg[M41T80_REG_ALARM_HOUR] &= ~(0x3f | 0x80);
-	reg[M41T80_REG_ALARM_MIN] = 0;
-	reg[M41T80_REG_ALARM_SEC] = 0;
-
-	wbuf[0] = M41T80_REG_ALARM_MON; /* offset into rtc's regs */
-	reg[M41T80_REG_ALARM_SEC] |= t->time.tm_sec >= 0 ?
-		bin2bcd(t->time.tm_sec) : 0x80;
-	reg[M41T80_REG_ALARM_MIN] |= t->time.tm_min >= 0 ?
-		bin2bcd(t->time.tm_min) : 0x80;
-	reg[M41T80_REG_ALARM_HOUR] |= t->time.tm_hour >= 0 ?
-		bin2bcd(t->time.tm_hour) : 0x80;
-	reg[M41T80_REG_ALARM_DAY] |= t->time.tm_mday >= 0 ?
-		bin2bcd(t->time.tm_mday) : 0x80;
-	if (t->time.tm_mon >= 0)
-		reg[M41T80_REG_ALARM_MON] |= bin2bcd(t->time.tm_mon + 1);
-	else
-		reg[M41T80_REG_ALARM_DAY] |= 0x40;
-
-	if (i2c_transfer(client->adapter, msgs, 1) != 1) {
-		dev_err(&client->dev, "write error\n");
-		return -EIO;
-	}
-
-	if (t->enabled) {
-		reg[M41T80_REG_ALARM_MON] |= M41T80_ALMON_AFE;
-		if (i2c_smbus_write_byte_data(client, M41T80_REG_ALARM_MON,
-					      reg[M41T80_REG_ALARM_MON]) < 0) {
-			dev_err(&client->dev, "write error\n");
-			return -EIO;
-		}
-	}
-	return 0;
-}
-
-static int m41t80_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *t)
-{
-	struct i2c_client *client = to_i2c_client(dev);
-	u8 buf[M41T80_ALARM_REG_SIZE + 1]; /* all alarm regs and flags */
-	u8 dt_addr[1] = { M41T80_REG_ALARM_MON };
-	u8 *reg = buf - M41T80_REG_ALARM_MON;
-	struct i2c_msg msgs[] = {
-		{
-			.addr	= client->addr,
-			.flags	= 0,
-			.len	= 1,
-			.buf	= dt_addr,
-		},
-		{
-			.addr	= client->addr,
-			.flags	= I2C_M_RD,
-			.len	= M41T80_ALARM_REG_SIZE + 1,
-			.buf	= buf,
-		},
-	};
-
-	if (i2c_transfer(client->adapter, msgs, 2) < 0) {
-		dev_err(&client->dev, "read error\n");
-		return -EIO;
-	}
-	t->time.tm_sec = -1;
-	t->time.tm_min = -1;
-	t->time.tm_hour = -1;
-	t->time.tm_mday = -1;
-	t->time.tm_mon = -1;
-	if (!(reg[M41T80_REG_ALARM_SEC] & 0x80))
-		t->time.tm_sec = bcd2bin(reg[M41T80_REG_ALARM_SEC] & 0x7f);
-	if (!(reg[M41T80_REG_ALARM_MIN] & 0x80))
-		t->time.tm_min = bcd2bin(reg[M41T80_REG_ALARM_MIN] & 0x7f);
-	if (!(reg[M41T80_REG_ALARM_HOUR] & 0x80))
-		t->time.tm_hour = bcd2bin(reg[M41T80_REG_ALARM_HOUR] & 0x3f);
-	if (!(reg[M41T80_REG_ALARM_DAY] & 0x80))
-		t->time.tm_mday = bcd2bin(reg[M41T80_REG_ALARM_DAY] & 0x3f);
-	if (!(reg[M41T80_REG_ALARM_DAY] & 0x40))
-		t->time.tm_mon = bcd2bin(reg[M41T80_REG_ALARM_MON] & 0x1f) - 1;
-	t->time.tm_year = -1;
-	t->time.tm_wday = -1;
-	t->time.tm_yday = -1;
-	t->time.tm_isdst = -1;
-	t->enabled = !!(reg[M41T80_REG_ALARM_MON] & M41T80_ALMON_AFE);
-	t->pending = !!(reg[M41T80_REG_FLAGS] & M41T80_FLAGS_AF);
-	return 0;
-}
-
+/*
+ * XXX - m41t80 alarm functionality is reported broken.
+ * until it is fixed, don't register alarm functions.
+ */
 static struct rtc_class_ops m41t80_rtc_ops = {
 	.read_time = m41t80_rtc_read_time,
 	.set_time = m41t80_rtc_set_time,
-	/*
-	 * XXX - m41t80 alarm functionality is reported broken.
-	 * until it is fixed, don't register alarm functions.
-	 *
-	.read_alarm = m41t80_rtc_read_alarm,
-	.set_alarm = m41t80_rtc_set_alarm,
-	*/
 	.proc = m41t80_rtc_proc,
-	/*
-	 * See above comment on broken alarm
-	 *
-	.alarm_irq_enable = m41t80_rtc_alarm_irq_enable,
-	*/
 };
 
 #if defined(CONFIG_RTC_INTF_SYSFS) || defined(CONFIG_RTC_INTF_SYSFS_MODULE)
_

Patches currently in -mm which might be from pebolle@tiscali.nl are

linux-next.patch
drivers-rtc-rtc-m41t80c-remove-disabled-alarm-functionality.patch

