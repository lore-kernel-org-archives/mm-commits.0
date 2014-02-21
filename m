From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-ds1307c-add-alarm-support-for-mcp7941x-chips.patch added to -mm tree
Date: Fri, 21 Feb 2014 12:00:17 -0800
Message-ID: <5307b051.StgONBWkDHUX55lF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57956 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaBUUAS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 15:00:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sebastian.hesselbarth@gmail.com, jason@lakedaemon.net, gregory.clement@free-electrons.com, andrew@lunn.ch, simon.guinot@sequanux.org

Subject: + drivers-rtc-rtc-ds1307c-add-alarm-support-for-mcp7941x-chips.patch added to -mm tree
To: simon.guinot@sequanux.org,andrew@lunn.ch,gregory.clement@free-electrons.com,jason@lakedaemon.net,sebastian.hesselbarth@gmail.com
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 12:00:17 -0800


The patch titled
     Subject: drivers/rtc/rtc-ds1307.c: add alarm support for mcp7941x chips
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-ds1307c-add-alarm-support-for-mcp7941x-chips.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-ds1307c-add-alarm-support-for-mcp7941x-chips.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-ds1307c-add-alarm-support-for-mcp7941x-chips.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Simon Guinot <simon.guinot@sequanux.org>
Subject: drivers/rtc/rtc-ds1307.c: add alarm support for mcp7941x chips

Add alarm support for the Microchip RTC devices MCP794xx.  Note that two
programmable alarms are provided by the chip but only one is used by the
driver.

Signed-off-by: Simon Guinot <simon.guinot@sequanux.org>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |  183 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 182 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-ds1307.c~drivers-rtc-rtc-ds1307c-add-alarm-support-for-mcp7941x-chips drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~drivers-rtc-rtc-ds1307c-add-alarm-support-for-mcp7941x-chips
+++ a/drivers/rtc/rtc-ds1307.c
@@ -154,6 +154,7 @@ static const struct chip_desc chips[last
 		.alarm		= 1,
 	},
 	[mcp7941x] = {
+		.alarm		= 1,
 		/* this is battery backed SRAM */
 		.nvram_offset	= 0x20,
 		.nvram_size	= 0x40,
@@ -606,6 +607,178 @@ static const struct rtc_class_ops ds13xx
 
 /*----------------------------------------------------------------------*/
 
+/*
+ * Alarm support for mcp7941x devices.
+ */
+
+#define MCP7941X_REG_CONTROL		0x07
+#	define MCP7941X_BIT_ALM0_EN	0x10
+#	define MCP7941X_BIT_ALM1_EN	0x20
+#define MCP7941X_REG_ALARM0_BASE	0x0a
+#define MCP7941X_REG_ALARM0_CTRL	0x0d
+#define MCP7941X_REG_ALARM1_BASE	0x11
+#define MCP7941X_REG_ALARM1_CTRL	0x14
+#	define MCP7941X_BIT_ALMX_IF	(1 << 3)
+#	define MCP7941X_BIT_ALMX_C0	(1 << 4)
+#	define MCP7941X_BIT_ALMX_C1	(1 << 5)
+#	define MCP7941X_BIT_ALMX_C2	(1 << 6)
+#	define MCP7941X_BIT_ALMX_POL	(1 << 7)
+#	define MCP7941X_MSK_ALMX_MATCH	(MCP7941X_BIT_ALMX_C0 | \
+					 MCP7941X_BIT_ALMX_C1 | \
+					 MCP7941X_BIT_ALMX_C2)
+
+static void mcp7941x_work(struct work_struct *work)
+{
+	struct ds1307 *ds1307 = container_of(work, struct ds1307, work);
+	struct i2c_client *client = ds1307->client;
+	int reg, ret;
+
+	mutex_lock(&ds1307->rtc->ops_lock);
+
+	/* Check and clear alarm 0 interrupt flag. */
+	reg = i2c_smbus_read_byte_data(client, MCP7941X_REG_ALARM0_CTRL);
+	if (reg < 0)
+		goto out;
+	if (!(reg & MCP7941X_BIT_ALMX_IF))
+		goto out;
+	reg &= ~MCP7941X_BIT_ALMX_IF;
+	ret = i2c_smbus_write_byte_data(client, MCP7941X_REG_ALARM0_CTRL, reg);
+	if (ret < 0)
+		goto out;
+
+	/* Disable alarm 0. */
+	reg = i2c_smbus_read_byte_data(client, MCP7941X_REG_CONTROL);
+	if (reg < 0)
+		goto out;
+	reg &= ~MCP7941X_BIT_ALM0_EN;
+	ret = i2c_smbus_write_byte_data(client, MCP7941X_REG_CONTROL, reg);
+	if (ret < 0)
+		goto out;
+
+	rtc_update_irq(ds1307->rtc, 1, RTC_AF | RTC_IRQF);
+
+out:
+	if (test_bit(HAS_ALARM, &ds1307->flags))
+		enable_irq(client->irq);
+	mutex_unlock(&ds1307->rtc->ops_lock);
+}
+
+static int mcp7941x_read_alarm(struct device *dev, struct rtc_wkalrm *t)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct ds1307 *ds1307 = i2c_get_clientdata(client);
+	u8 *regs = ds1307->regs;
+	int ret;
+
+	if (!test_bit(HAS_ALARM, &ds1307->flags))
+		return -EINVAL;
+
+	/* Read control and alarm 0 registers. */
+	ret = ds1307->read_block_data(client, MCP7941X_REG_CONTROL, 10, regs);
+	if (ret < 0)
+		return ret;
+
+	t->enabled = !!(regs[0] & MCP7941X_BIT_ALM0_EN);
+
+	/* Report alarm 0 time assuming 24-hour and day-of-month modes. */
+	t->time.tm_sec = bcd2bin(ds1307->regs[3] & 0x7f);
+	t->time.tm_min = bcd2bin(ds1307->regs[4] & 0x7f);
+	t->time.tm_hour = bcd2bin(ds1307->regs[5] & 0x3f);
+	t->time.tm_wday = bcd2bin(ds1307->regs[6] & 0x7) - 1;
+	t->time.tm_mday = bcd2bin(ds1307->regs[7] & 0x3f);
+	t->time.tm_mon = bcd2bin(ds1307->regs[8] & 0x1f) - 1;
+	t->time.tm_year = -1;
+	t->time.tm_yday = -1;
+	t->time.tm_isdst = -1;
+
+	dev_dbg(dev, "%s, sec=%d min=%d hour=%d wday=%d mday=%d mon=%d "
+		"enabled=%d polarity=%d irq=%d match=%d\n", __func__,
+		t->time.tm_sec, t->time.tm_min, t->time.tm_hour,
+		t->time.tm_wday, t->time.tm_mday, t->time.tm_mon, t->enabled,
+		!!(ds1307->regs[6] & MCP7941X_BIT_ALMX_POL),
+		!!(ds1307->regs[6] & MCP7941X_BIT_ALMX_IF),
+		(ds1307->regs[6] & MCP7941X_MSK_ALMX_MATCH) >> 4);
+
+	return 0;
+}
+
+static int mcp7941x_set_alarm(struct device *dev, struct rtc_wkalrm *t)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct ds1307 *ds1307 = i2c_get_clientdata(client);
+	unsigned char *regs = ds1307->regs;
+	int ret;
+
+	if (!test_bit(HAS_ALARM, &ds1307->flags))
+		return -EINVAL;
+
+	dev_dbg(dev, "%s, sec=%d min=%d hour=%d wday=%d mday=%d mon=%d "
+		"enabled=%d pending=%d\n", __func__,
+		t->time.tm_sec, t->time.tm_min, t->time.tm_hour,
+		t->time.tm_wday, t->time.tm_mday, t->time.tm_mon,
+		t->enabled, t->pending);
+
+	/* Read control and alarm 0 registers. */
+	ret = ds1307->read_block_data(client, MCP7941X_REG_CONTROL, 10, regs);
+	if (ret < 0)
+		return ret;
+
+	/* Set alarm 0, using 24-hour and day-of-month modes. */
+	regs[3] = bin2bcd(t->time.tm_sec);
+	regs[4] = bin2bcd(t->time.tm_min);
+	regs[5] = bin2bcd(t->time.tm_hour);
+	regs[6] = bin2bcd(t->time.tm_wday) + 1;
+	regs[7] = bin2bcd(t->time.tm_mday);
+	regs[8] = bin2bcd(t->time.tm_mon) + 1;
+
+	/* Clear the alarm 0 interrupt flag. */
+	regs[6] &= ~MCP7941X_BIT_ALMX_IF;
+	/* Set alarm match: second, minute, hour, day, date, month. */
+	regs[6] |= MCP7941X_MSK_ALMX_MATCH;
+
+	if (t->enabled)
+		regs[0] |= MCP7941X_BIT_ALM0_EN;
+	else
+		regs[0] &= ~MCP7941X_BIT_ALM0_EN;
+
+	ret = ds1307->write_block_data(client, MCP7941X_REG_CONTROL, 10, regs);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int mcp7941x_alarm_irq_enable(struct device *dev, unsigned int enabled)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct ds1307 *ds1307 = i2c_get_clientdata(client);
+	int reg;
+
+	if (!test_bit(HAS_ALARM, &ds1307->flags))
+		return -EINVAL;
+
+	reg = i2c_smbus_read_byte_data(client, MCP7941X_REG_CONTROL);
+	if (reg < 0)
+		return reg;
+
+	if (enabled)
+		reg |= MCP7941X_BIT_ALM0_EN;
+	else
+		reg &= ~MCP7941X_BIT_ALM0_EN;
+
+	return i2c_smbus_write_byte_data(client, MCP7941X_REG_CONTROL, reg);
+}
+
+static const struct rtc_class_ops mcp7941x_rtc_ops = {
+	.read_time	= ds1307_get_time,
+	.set_time	= ds1307_set_time,
+	.read_alarm	= mcp7941x_read_alarm,
+	.set_alarm	= mcp7941x_set_alarm,
+	.alarm_irq_enable = mcp7941x_alarm_irq_enable,
+};
+
+/*----------------------------------------------------------------------*/
+
 static ssize_t
 ds1307_nvram_read(struct file *filp, struct kobject *kobj,
 		struct bin_attribute *attr,
@@ -678,6 +851,7 @@ static int ds1307_probe(struct i2c_clien
 		[ds_1339] = DS1339_BIT_BBSQI,
 		[ds_3231] = DS3231_BIT_BBSQW,
 	};
+	const struct rtc_class_ops *rtc_ops = &ds13xx_rtc_ops;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)
 	    && !i2c_check_functionality(adapter, I2C_FUNC_SMBUS_I2C_BLOCK))
@@ -816,6 +990,13 @@ static int ds1307_probe(struct i2c_clien
 	case ds_1388:
 		ds1307->offset = 1; /* Seconds starts at 1 */
 		break;
+	case mcp7941x:
+		rtc_ops = &mcp7941x_rtc_ops;
+		if (ds1307->client->irq > 0 && chip->alarm) {
+			INIT_WORK(&ds1307->work, mcp7941x_work);
+			want_irq = true;
+		}
+		break;
 	default:
 		break;
 	}
@@ -929,7 +1110,7 @@ read_rtc:
 
 	device_set_wakeup_capable(&client->dev, want_irq);
 	ds1307->rtc = devm_rtc_device_register(&client->dev, client->name,
-				&ds13xx_rtc_ops, THIS_MODULE);
+				rtc_ops, THIS_MODULE);
 	if (IS_ERR(ds1307->rtc)) {
 		err = PTR_ERR(ds1307->rtc);
 		dev_err(&client->dev,
_

Patches currently in -mm which might be from simon.guinot@sequanux.org are

drivers-rtc-rtc-ds1307c-fix-sysfs-wakealarm-attribute-creation.patch
drivers-rtc-rtc-ds1307c-add-alarm-support-for-mcp7941x-chips.patch

