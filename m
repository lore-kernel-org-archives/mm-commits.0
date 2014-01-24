From: akpm@linux-foundation.org
Subject: [merged] rtc-add-hym8563-rtc-driver.patch removed from -mm tree
Date: Fri, 24 Jan 2014 11:02:42 -0800
Message-ID: <52e2b8d2.xX/7FZqynIfn44sV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43748 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbaAXTCn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:02:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, swarren@wwwdotorg.org, rob.herring@calxeda.com, richard.weinberger@gmail.com, pawel.moll@arm.com, mturquette@linaro.org, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, grant.likely@linaro.org, broonie@kernel.org, heiko@sntech.de

Subject: [merged] rtc-add-hym8563-rtc-driver.patch removed from -mm tree
To: heiko@sntech.de,broonie@kernel.org,grant.likely@linaro.org,ijc+devicetree@hellion.org.uk,mark.rutland@arm.com,mturquette@linaro.org,pawel.moll@arm.com,richard.weinberger@gmail.com,rob.herring@calxeda.com,swarren@wwwdotorg.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:02:42 -0800


The patch titled
     Subject: rtc: add hym8563 rtc-driver
has been removed from the -mm tree.  Its filename was
     rtc-add-hym8563-rtc-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Heiko Stuebner <heiko@sntech.de>
Subject: rtc: add hym8563 rtc-driver

The Haoyu Microelectronics HYM8563 provides rtc and alarm functions as
well as a clock output of up to 32kHz.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig       |   11 
 drivers/rtc/Makefile      |    1 
 drivers/rtc/rtc-hym8563.c |  606 ++++++++++++++++++++++++++++++++++++
 3 files changed, 618 insertions(+)

diff -puN drivers/rtc/Kconfig~rtc-add-hym8563-rtc-driver drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-add-hym8563-rtc-driver
+++ a/drivers/rtc/Kconfig
@@ -212,6 +212,17 @@ config RTC_DRV_DS3232
 	  This driver can also be built as a module.  If so, the module
 	  will be called rtc-ds3232.
 
+config RTC_DRV_HYM8563
+	tristate "Haoyu Microelectronics HYM8563"
+	depends on I2C && OF
+	help
+	  Say Y to enable support for the HYM8563 I2C RTC chip. Apart
+	  from the usual rtc functions it provides a clock output of
+	  up to 32kHz.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-hym8563.
+
 config RTC_DRV_LP8788
 	tristate "TI LP8788 RTC driver"
 	depends on MFD_LP8788
diff -puN drivers/rtc/Makefile~rtc-add-hym8563-rtc-driver drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-add-hym8563-rtc-driver
+++ a/drivers/rtc/Makefile
@@ -55,6 +55,7 @@ obj-$(CONFIG_RTC_DRV_EP93XX)	+= rtc-ep93
 obj-$(CONFIG_RTC_DRV_FM3130)	+= rtc-fm3130.o
 obj-$(CONFIG_RTC_DRV_GENERIC)	+= rtc-generic.o
 obj-$(CONFIG_RTC_DRV_HID_SENSOR_TIME) += rtc-hid-sensor-time.o
+obj-$(CONFIG_RTC_DRV_HYM8563)	+= rtc-hym8563.o
 obj-$(CONFIG_RTC_DRV_IMXDI)	+= rtc-imxdi.o
 obj-$(CONFIG_RTC_DRV_ISL1208)	+= rtc-isl1208.o
 obj-$(CONFIG_RTC_DRV_ISL12022)	+= rtc-isl12022.o
diff -puN /dev/null drivers/rtc/rtc-hym8563.c
--- /dev/null
+++ a/drivers/rtc/rtc-hym8563.c
@@ -0,0 +1,606 @@
+/*
+ * Haoyu HYM8563 RTC driver
+ *
+ * Copyright (C) 2013 MundoReader S.L.
+ * Author: Heiko Stuebner <heiko@sntech.de>
+ *
+ * based on rtc-HYM8563
+ * Copyright (C) 2010 ROCKCHIP, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/clk-provider.h>
+#include <linux/i2c.h>
+#include <linux/bcd.h>
+#include <linux/rtc.h>
+
+#define HYM8563_CTL1		0x00
+#define HYM8563_CTL1_TEST	BIT(7)
+#define HYM8563_CTL1_STOP	BIT(5)
+#define HYM8563_CTL1_TESTC	BIT(3)
+
+#define HYM8563_CTL2		0x01
+#define HYM8563_CTL2_TI_TP	BIT(4)
+#define HYM8563_CTL2_AF		BIT(3)
+#define HYM8563_CTL2_TF		BIT(2)
+#define HYM8563_CTL2_AIE	BIT(1)
+#define HYM8563_CTL2_TIE	BIT(0)
+
+#define HYM8563_SEC		0x02
+#define HYM8563_SEC_VL		BIT(7)
+#define HYM8563_SEC_MASK	0x7f
+
+#define HYM8563_MIN		0x03
+#define HYM8563_MIN_MASK	0x7f
+
+#define HYM8563_HOUR		0x04
+#define HYM8563_HOUR_MASK	0x3f
+
+#define HYM8563_DAY		0x05
+#define HYM8563_DAY_MASK	0x3f
+
+#define HYM8563_WEEKDAY		0x06
+#define HYM8563_WEEKDAY_MASK	0x07
+
+#define HYM8563_MONTH		0x07
+#define HYM8563_MONTH_CENTURY	BIT(7)
+#define HYM8563_MONTH_MASK	0x1f
+
+#define HYM8563_YEAR		0x08
+
+#define HYM8563_ALM_MIN		0x09
+#define HYM8563_ALM_HOUR	0x0a
+#define HYM8563_ALM_DAY		0x0b
+#define HYM8563_ALM_WEEK	0x0c
+
+/* Each alarm check can be disabled by setting this bit in the register */
+#define HYM8563_ALM_BIT_DISABLE	BIT(7)
+
+#define HYM8563_CLKOUT		0x0d
+#define HYM8563_CLKOUT_DISABLE	BIT(7)
+#define HYM8563_CLKOUT_32768	0
+#define HYM8563_CLKOUT_1024	1
+#define HYM8563_CLKOUT_32	2
+#define HYM8563_CLKOUT_1	3
+#define HYM8563_CLKOUT_MASK	3
+
+#define HYM8563_TMR_CTL		0x0e
+#define HYM8563_TMR_CTL_ENABLE	BIT(7)
+#define HYM8563_TMR_CTL_4096	0
+#define HYM8563_TMR_CTL_64	1
+#define HYM8563_TMR_CTL_1	2
+#define HYM8563_TMR_CTL_1_60	3
+#define HYM8563_TMR_CTL_MASK	3
+
+#define HYM8563_TMR_CNT		0x0f
+
+struct hym8563 {
+	struct i2c_client	*client;
+	struct rtc_device	*rtc;
+	bool			valid;
+#ifdef CONFIG_COMMON_CLK
+	struct clk_hw		clkout_hw;
+#endif
+};
+
+/*
+ * RTC handling
+ */
+
+static int hym8563_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct hym8563 *hym8563 = i2c_get_clientdata(client);
+	u8 buf[7];
+	int ret;
+
+	if (!hym8563->valid) {
+		dev_warn(&client->dev, "no valid clock/calendar values available\n");
+		return -EPERM;
+	}
+
+	ret = i2c_smbus_read_i2c_block_data(client, HYM8563_SEC, 7, buf);
+
+	tm->tm_sec = bcd2bin(buf[0] & HYM8563_SEC_MASK);
+	tm->tm_min = bcd2bin(buf[1] & HYM8563_MIN_MASK);
+	tm->tm_hour = bcd2bin(buf[2] & HYM8563_HOUR_MASK);
+	tm->tm_mday = bcd2bin(buf[3] & HYM8563_DAY_MASK);
+	tm->tm_wday = bcd2bin(buf[4] & HYM8563_WEEKDAY_MASK); /* 0 = Sun */
+	tm->tm_mon = bcd2bin(buf[5] & HYM8563_MONTH_MASK) - 1; /* 0 = Jan */
+	tm->tm_year = bcd2bin(buf[6]) + 100;
+
+	return 0;
+}
+
+static int hym8563_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct hym8563 *hym8563 = i2c_get_clientdata(client);
+	u8 buf[7];
+	int ret;
+
+	/* Years >= 2100 are to far in the future, 19XX is to early */
+	if (tm->tm_year < 100 || tm->tm_year >= 200)
+		return -EINVAL;
+
+	buf[0] = bin2bcd(tm->tm_sec);
+	buf[1] = bin2bcd(tm->tm_min);
+	buf[2] = bin2bcd(tm->tm_hour);
+	buf[3] = bin2bcd(tm->tm_mday);
+	buf[4] = bin2bcd(tm->tm_wday);
+	buf[5] = bin2bcd(tm->tm_mon + 1);
+
+	/*
+	 * While the HYM8563 has a century flag in the month register,
+	 * it does not seem to carry it over a subsequent write/read.
+	 * So we'll limit ourself to 100 years, starting at 2000 for now.
+	 */
+	buf[6] = tm->tm_year - 100;
+
+	/*
+	 * CTL1 only contains TEST-mode bits apart from stop,
+	 * so no need to read the value first
+	 */
+	ret = i2c_smbus_write_byte_data(client, HYM8563_CTL1,
+						HYM8563_CTL1_STOP);
+	if (ret < 0)
+		return ret;
+
+	ret = i2c_smbus_write_i2c_block_data(client, HYM8563_SEC, 7, buf);
+	if (ret < 0)
+		return ret;
+
+	ret = i2c_smbus_write_byte_data(client, HYM8563_CTL1, 0);
+	if (ret < 0)
+		return ret;
+
+	hym8563->valid = true;
+
+	return 0;
+}
+
+static int hym8563_rtc_alarm_irq_enable(struct device *dev,
+					unsigned int enabled)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	int data;
+
+	data = i2c_smbus_read_byte_data(client, HYM8563_CTL2);
+	if (data < 0)
+		return data;
+
+	if (enabled)
+		data |= HYM8563_CTL2_AIE;
+	else
+		data &= ~HYM8563_CTL2_AIE;
+
+	return i2c_smbus_write_byte_data(client, HYM8563_CTL2, data);
+};
+
+static int hym8563_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct rtc_time *alm_tm = &alm->time;
+	u8 buf[4];
+	int ret;
+
+	ret = i2c_smbus_read_i2c_block_data(client, HYM8563_ALM_MIN, 4, buf);
+	if (ret < 0)
+		return ret;
+
+	/* The alarm only has a minute accuracy */
+	alm_tm->tm_sec = -1;
+
+	alm_tm->tm_min = (buf[0] & HYM8563_ALM_BIT_DISABLE) ?
+					-1 :
+					bcd2bin(buf[0] & HYM8563_MIN_MASK);
+	alm_tm->tm_hour = (buf[1] & HYM8563_ALM_BIT_DISABLE) ?
+					-1 :
+					bcd2bin(buf[1] & HYM8563_HOUR_MASK);
+	alm_tm->tm_mday = (buf[2] & HYM8563_ALM_BIT_DISABLE) ?
+					-1 :
+					bcd2bin(buf[2] & HYM8563_DAY_MASK);
+	alm_tm->tm_wday = (buf[3] & HYM8563_ALM_BIT_DISABLE) ?
+					-1 :
+					bcd2bin(buf[3] & HYM8563_WEEKDAY_MASK);
+
+	alm_tm->tm_mon = -1;
+	alm_tm->tm_year = -1;
+
+	ret = i2c_smbus_read_byte_data(client, HYM8563_CTL2);
+	if (ret < 0)
+		return ret;
+
+	if (ret & HYM8563_CTL2_AIE)
+		alm->enabled = 1;
+
+	return 0;
+}
+
+static int hym8563_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct rtc_time *alm_tm = &alm->time;
+	u8 buf[4];
+	int ret;
+
+	/*
+	 * The alarm has no seconds so deal with it
+	 */
+	if (alm_tm->tm_sec) {
+		alm_tm->tm_sec = 0;
+		alm_tm->tm_min++;
+		if (alm_tm->tm_min >= 60) {
+			alm_tm->tm_min = 0;
+			alm_tm->tm_hour++;
+			if (alm_tm->tm_hour >= 24) {
+				alm_tm->tm_hour = 0;
+				alm_tm->tm_mday++;
+				if (alm_tm->tm_mday > 31)
+					alm_tm->tm_mday = 0;
+			}
+		}
+	}
+
+	ret = i2c_smbus_read_byte_data(client, HYM8563_CTL2);
+	if (ret < 0)
+		return ret;
+
+	ret &= ~HYM8563_CTL2_AIE;
+
+	ret = i2c_smbus_write_byte_data(client, HYM8563_CTL2, ret);
+	if (ret < 0)
+		return ret;
+
+	buf[0] = (alm_tm->tm_min < 60 && alm_tm->tm_min >= 0) ?
+			bin2bcd(alm_tm->tm_min) : HYM8563_ALM_BIT_DISABLE;
+
+	buf[1] = (alm_tm->tm_hour < 24 && alm_tm->tm_hour >= 0) ?
+			bin2bcd(alm_tm->tm_hour) : HYM8563_ALM_BIT_DISABLE;
+
+	buf[2] = (alm_tm->tm_mday <= 31 && alm_tm->tm_mday >= 1) ?
+			bin2bcd(alm_tm->tm_mday) : HYM8563_ALM_BIT_DISABLE;
+
+	buf[3] = (alm_tm->tm_wday < 7 && alm_tm->tm_wday >= 0) ?
+			bin2bcd(alm_tm->tm_wday) : HYM8563_ALM_BIT_DISABLE;
+
+	ret = i2c_smbus_write_i2c_block_data(client, HYM8563_ALM_MIN, 4, buf);
+	if (ret < 0)
+		return ret;
+
+	return hym8563_rtc_alarm_irq_enable(dev, alm->enabled);
+}
+
+static const struct rtc_class_ops hym8563_rtc_ops = {
+	.read_time		= hym8563_rtc_read_time,
+	.set_time		= hym8563_rtc_set_time,
+	.alarm_irq_enable	= hym8563_rtc_alarm_irq_enable,
+	.read_alarm		= hym8563_rtc_read_alarm,
+	.set_alarm		= hym8563_rtc_set_alarm,
+};
+
+/*
+ * Handling of the clkout
+ */
+
+#ifdef CONFIG_COMMON_CLK
+#define clkout_hw_to_hym8563(_hw) container_of(_hw, struct hym8563, clkout_hw)
+
+static int clkout_rates[] = {
+	32768,
+	1024,
+	32,
+	1,
+};
+
+static unsigned long hym8563_clkout_recalc_rate(struct clk_hw *hw,
+						unsigned long parent_rate)
+{
+	struct hym8563 *hym8563 = clkout_hw_to_hym8563(hw);
+	struct i2c_client *client = hym8563->client;
+	int ret = i2c_smbus_read_byte_data(client, HYM8563_CLKOUT);
+
+	if (ret < 0 || ret & HYM8563_CLKOUT_DISABLE)
+		return 0;
+
+	ret &= HYM8563_CLKOUT_MASK;
+	return clkout_rates[ret];
+}
+
+static long hym8563_clkout_round_rate(struct clk_hw *hw, unsigned long rate,
+				      unsigned long *prate)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(clkout_rates); i++)
+		if (clkout_rates[i] <= rate)
+			return clkout_rates[i];
+
+	return 0;
+}
+
+static int hym8563_clkout_set_rate(struct clk_hw *hw, unsigned long rate,
+				   unsigned long parent_rate)
+{
+	struct hym8563 *hym8563 = clkout_hw_to_hym8563(hw);
+	struct i2c_client *client = hym8563->client;
+	int ret = i2c_smbus_read_byte_data(client, HYM8563_CLKOUT);
+	int i;
+
+	if (ret < 0)
+		return ret;
+
+	for (i = 0; i < ARRAY_SIZE(clkout_rates); i++)
+		if (clkout_rates[i] == rate) {
+			ret &= ~HYM8563_CLKOUT_MASK;
+			ret |= i;
+			return i2c_smbus_write_byte_data(client,
+							 HYM8563_CLKOUT, ret);
+		}
+
+	return -EINVAL;
+}
+
+static int hym8563_clkout_control(struct clk_hw *hw, bool enable)
+{
+	struct hym8563 *hym8563 = clkout_hw_to_hym8563(hw);
+	struct i2c_client *client = hym8563->client;
+	int ret = i2c_smbus_read_byte_data(client, HYM8563_CLKOUT);
+
+	if (ret < 0)
+		return ret;
+
+	if (enable)
+		ret &= ~HYM8563_CLKOUT_DISABLE;
+	else
+		ret |= HYM8563_CLKOUT_DISABLE;
+
+	return i2c_smbus_write_byte_data(client, HYM8563_CLKOUT, ret);
+}
+
+static int hym8563_clkout_prepare(struct clk_hw *hw)
+{
+	return hym8563_clkout_control(hw, 1);
+}
+
+static void hym8563_clkout_unprepare(struct clk_hw *hw)
+{
+	hym8563_clkout_control(hw, 0);
+}
+
+static int hym8563_clkout_is_prepared(struct clk_hw *hw)
+{
+	struct hym8563 *hym8563 = clkout_hw_to_hym8563(hw);
+	struct i2c_client *client = hym8563->client;
+	int ret = i2c_smbus_read_byte_data(client, HYM8563_CLKOUT);
+
+	if (ret < 0)
+		return ret;
+
+	return !(ret & HYM8563_CLKOUT_DISABLE);
+}
+
+const struct clk_ops hym8563_clkout_ops = {
+	.prepare = hym8563_clkout_prepare,
+	.unprepare = hym8563_clkout_unprepare,
+	.is_prepared = hym8563_clkout_is_prepared,
+	.recalc_rate = hym8563_clkout_recalc_rate,
+	.round_rate = hym8563_clkout_round_rate,
+	.set_rate = hym8563_clkout_set_rate,
+};
+
+static struct clk *hym8563_clkout_register_clk(struct hym8563 *hym8563)
+{
+	struct i2c_client *client = hym8563->client;
+	struct device_node *node = client->dev.of_node;
+	struct clk *clk;
+	struct clk_init_data init;
+	int ret;
+
+	ret = i2c_smbus_write_byte_data(client, HYM8563_CLKOUT,
+						HYM8563_CLKOUT_DISABLE);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	init.name = "hym8563-clkout";
+	init.ops = &hym8563_clkout_ops;
+	init.flags = CLK_IS_ROOT;
+	init.parent_names = NULL;
+	init.num_parents = 0;
+	hym8563->clkout_hw.init = &init;
+
+	/* register the clock */
+	clk = clk_register(&client->dev, &hym8563->clkout_hw);
+
+	if (!IS_ERR(clk))
+		of_clk_add_provider(node, of_clk_src_simple_get, clk);
+
+	return clk;
+}
+#endif
+
+/*
+ * The alarm interrupt is implemented as a level-low interrupt in the
+ * hym8563, while the timer interrupt uses a falling edge.
+ * We don't use the timer at all, so the interrupt is requested to
+ * use the level-low trigger.
+ */
+static irqreturn_t hym8563_irq(int irq, void *dev_id)
+{
+	struct hym8563 *hym8563 = (struct hym8563 *)dev_id;
+	struct i2c_client *client = hym8563->client;
+	struct mutex *lock = &hym8563->rtc->ops_lock;
+	int data, ret;
+
+	mutex_lock(lock);
+
+	/* Clear the alarm flag */
+
+	data = i2c_smbus_read_byte_data(client, HYM8563_CTL2);
+	if (data < 0) {
+		dev_err(&client->dev, "%s: error reading i2c data %d\n",
+			__func__, data);
+		goto out;
+	}
+
+	data &= ~HYM8563_CTL2_AF;
+
+	ret = i2c_smbus_write_byte_data(client, HYM8563_CTL2, data);
+	if (ret < 0) {
+		dev_err(&client->dev, "%s: error writing i2c data %d\n",
+			__func__, ret);
+	}
+
+out:
+	mutex_unlock(lock);
+	return IRQ_HANDLED;
+}
+
+static int hym8563_init_device(struct i2c_client *client)
+{
+	int ret;
+
+	/* Clear stop flag if present */
+	ret = i2c_smbus_write_byte_data(client, HYM8563_CTL1, 0);
+	if (ret < 0)
+		return ret;
+
+	ret = i2c_smbus_read_byte_data(client, HYM8563_CTL2);
+	if (ret < 0)
+		return ret;
+
+	/* Disable alarm and timer interrupts */
+	ret &= ~HYM8563_CTL2_AIE;
+	ret &= ~HYM8563_CTL2_TIE;
+
+	/* Clear any pending alarm and timer flags */
+	if (ret & HYM8563_CTL2_AF)
+		ret &= ~HYM8563_CTL2_AF;
+
+	if (ret & HYM8563_CTL2_TF)
+		ret &= ~HYM8563_CTL2_TF;
+
+	ret &= ~HYM8563_CTL2_TI_TP;
+
+	return i2c_smbus_write_byte_data(client, HYM8563_CTL2, ret);
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int hym8563_suspend(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	int ret;
+
+	if (device_may_wakeup(dev)) {
+		ret = enable_irq_wake(client->irq);
+		if (ret) {
+			dev_err(dev, "enable_irq_wake failed, %d\n", ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int hym8563_resume(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+
+	if (device_may_wakeup(dev))
+		disable_irq_wake(client->irq);
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(hym8563_pm_ops, hym8563_suspend, hym8563_resume);
+
+static int hym8563_probe(struct i2c_client *client,
+			 const struct i2c_device_id *id)
+{
+	struct hym8563 *hym8563;
+	int ret;
+
+	hym8563 = devm_kzalloc(&client->dev, sizeof(*hym8563), GFP_KERNEL);
+	if (!hym8563)
+		return -ENOMEM;
+
+	hym8563->client = client;
+	i2c_set_clientdata(client, hym8563);
+
+	device_set_wakeup_capable(&client->dev, true);
+
+	ret = hym8563_init_device(client);
+	if (ret) {
+		dev_err(&client->dev, "could not init device, %d\n", ret);
+		return ret;
+	}
+
+	ret = devm_request_threaded_irq(&client->dev, client->irq,
+					NULL, hym8563_irq,
+					IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+					client->name, hym8563);
+	if (ret < 0) {
+		dev_err(&client->dev, "irq %d request failed, %d\n",
+			client->irq, ret);
+		return ret;
+	}
+
+	/* check state of calendar information */
+	ret = i2c_smbus_read_byte_data(client, HYM8563_SEC);
+	if (ret < 0)
+		return ret;
+
+	hym8563->valid = !(ret & HYM8563_SEC_VL);
+	dev_dbg(&client->dev, "rtc information is %s\n",
+		hym8563->valid ? "valid" : "invalid");
+
+	hym8563->rtc = devm_rtc_device_register(&client->dev, client->name,
+						&hym8563_rtc_ops, THIS_MODULE);
+	if (IS_ERR(hym8563->rtc))
+		return PTR_ERR(hym8563->rtc);
+
+#ifdef CONFIG_COMMON_CLK
+	hym8563_clkout_register_clk(hym8563);
+#endif
+
+	return 0;
+}
+
+static const struct i2c_device_id hym8563_id[] = {
+	{ "hym8563", 0 },
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, hym8563_id);
+
+static struct of_device_id hym8563_dt_idtable[] = {
+	{ .compatible = "haoyu,hym8563" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, hym8563_dt_idtable);
+
+static struct i2c_driver hym8563_driver = {
+	.driver		= {
+		.name	= "rtc-hym8563",
+		.owner	= THIS_MODULE,
+		.pm	= &hym8563_pm_ops,
+		.of_match_table	= of_match_ptr(hym8563_dt_idtable),
+	},
+	.probe		= hym8563_probe,
+	.id_table	= hym8563_id,
+};
+
+module_i2c_driver(hym8563_driver);
+
+MODULE_AUTHOR("Heiko Stuebner <heiko@sntech.de>");
+MODULE_DESCRIPTION("HYM8563 RTC driver");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from heiko@sntech.de are

origin.patch
linux-next.patch

