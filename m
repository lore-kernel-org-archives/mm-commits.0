From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-pcf8563c-add-rtc_vl_read-rtc_vl_clr-ioctl-feature.patch removed from -mm tree
Date: Thu, 31 May 2012 12:20:25 -0700
Message-ID: <20120531192025.79F23A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:60590 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933081Ab2EaTU2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:20:28 -0400
Received: by lbbgp10 with SMTP id gp10so86026lbb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:20:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.stein@systec-electronic.com, a.zummo@towertech.it, jesper.nilsson@axis.com, starvik@axis.com, wfg@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-pcf8563.c: add RTC_VL_READ/RTC_VL_CLR ioctl feature
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-pcf8563c-add-rtc_vl_read-rtc_vl_clr-ioctl-feature.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Alexander Stein <alexander.stein@systec-electronic.com>
Subject: drivers/rtc/rtc-pcf8563.c: add RTC_VL_READ/RTC_VL_CLR ioctl feature

Changes are based on arch/cris/arch-v10/drivers/pcf8563.c

[akpm@linux-foundation.org: fix sparse warning]
Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Mikael Starvik <starvik@axis.com>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Wu Fengguang <wfg@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8563.c |   44 +++++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-pcf8563.c~drivers-rtc-rtc-pcf8563c-add-rtc_vl_read-rtc_vl_clr-ioctl-feature drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~drivers-rtc-rtc-pcf8563c-add-rtc_vl_read-rtc_vl_clr-ioctl-feature
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -64,6 +64,7 @@ struct pcf8563 {
 	 * 1970...2069.
 	 */
 	int c_polarity;	/* 0: MO_C=1 means 19xx, otherwise MO_C=1 means 20xx */
+	int voltage_low; /* incicates if a low_voltage was detected */
 };
 
 /*
@@ -86,9 +87,11 @@ static int pcf8563_get_datetime(struct i
 		return -EIO;
 	}
 
-	if (buf[PCF8563_REG_SC] & PCF8563_SC_LV)
+	if (buf[PCF8563_REG_SC] & PCF8563_SC_LV) {
+		pcf8563->voltage_low = 1;
 		dev_info(&client->dev,
 			"low voltage detected, date/time is not reliable.\n");
+	}
 
 	dev_dbg(&client->dev,
 		"%s: raw data is st1=%02x, st2=%02x, sec=%02x, min=%02x, hr=%02x, "
@@ -173,6 +176,44 @@ static int pcf8563_set_datetime(struct i
 	return 0;
 }
 
+#ifdef CONFIG_RTC_INTF_DEV
+static int pcf8563_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
+{
+	struct pcf8563 *pcf8563 = i2c_get_clientdata(to_i2c_client(dev));
+	struct rtc_time tm;
+
+	switch (cmd) {
+	case RTC_VL_READ:
+		if (pcf8563->voltage_low)
+			dev_info(dev, "low voltage detected, date/time is not reliable.\n");
+
+		if (copy_to_user((void __user *)arg, &pcf8563->voltage_low,
+					sizeof(int)))
+			return -EFAULT;
+		return 0;
+	case RTC_VL_CLR:
+		/*
+		 * Clear the VL bit in the seconds register in case
+		 * the time has not been set already (which would
+		 * have cleared it). This does not really matter
+		 * because of the cached voltage_low value but do it
+		 * anyway for consistency.
+		 */
+		if (pcf8563_get_datetime(to_i2c_client(dev), &tm))
+			pcf8563_set_datetime(to_i2c_client(dev), &tm);
+
+		/* Clear the cached value. */
+		pcf8563->voltage_low = 0;
+
+		return 0;
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+#else
+#define pcf8563_rtc_ioctl NULL
+#endif
+
 static int pcf8563_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	return pcf8563_get_datetime(to_i2c_client(dev), tm);
@@ -184,6 +225,7 @@ static int pcf8563_rtc_set_time(struct d
 }
 
 static const struct rtc_class_ops pcf8563_rtc_ops = {
+	.ioctl		= pcf8563_rtc_ioctl,
 	.read_time	= pcf8563_rtc_read_time,
 	.set_time	= pcf8563_rtc_set_time,
 };
_

Patches currently in -mm which might be from alexander.stein@systec-electronic.com are

origin.patch
linux-next.patch

