From: akpm@linux-foundation.org
Subject: [merged] rtc-pcf8523-add-low-battery-voltage-support.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:43:20 -0800
Message-ID: <20130222204320.A526A31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:56460 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757477Ab3BVUnV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:43:21 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so104032ghb.4
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:43:21 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.nilsson@axis.com, thierry.reding@avionic-design.de, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-pcf8523: add low battery voltage support
has been removed from the -mm tree.  Its filename was
     rtc-pcf8523-add-low-battery-voltage-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jesper Nilsson <jesper.nilsson@axis.com>
Subject: rtc-pcf8523: add low battery voltage support

Implement reading of the battery voltage low signal for rtc-pcf8523.

The bit is read-only and cannot be cleared by software, so no
clear function is implemented.

[akpm@linux-foundation.org: omit pcf8563_rtc_ioctl() if CONFIG_RTC_INTF_DEV=n]
Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8523.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff -puN drivers/rtc/rtc-pcf8523.c~rtc-pcf8523-add-low-battery-voltage-support drivers/rtc/rtc-pcf8523.c
--- a/drivers/rtc/rtc-pcf8523.c~rtc-pcf8523-add-low-battery-voltage-support
+++ a/drivers/rtc/rtc-pcf8523.c
@@ -23,6 +23,7 @@
 #define REG_CONTROL3_PM_VDD (1 << 6) /* switch-over disabled */
 #define REG_CONTROL3_PM_DSM (1 << 5) /* direct switching mode */
 #define REG_CONTROL3_PM_MASK 0xe0
+#define REG_CONTROL3_BLF (1 << 2) /* battery low bit, read-only */
 
 #define REG_SECONDS  0x03
 #define REG_SECONDS_OS (1 << 7)
@@ -250,9 +251,39 @@ static int pcf8523_rtc_set_time(struct d
 	return pcf8523_start_rtc(client);
 }
 
+#ifdef CONFIG_RTC_INTF_DEV
+static int pcf8523_rtc_ioctl(struct device *dev, unsigned int cmd,
+			     unsigned long arg)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	u8 value;
+	int ret = 0, err;
+
+	switch (cmd) {
+	case RTC_VL_READ:
+		err = pcf8523_read(client, REG_CONTROL3, &value);
+		if (err < 0)
+			return err;
+
+		if (value & REG_CONTROL3_BLF)
+			ret = 1;
+
+		if (copy_to_user((void __user *)arg, &ret, sizeof(int)))
+			return -EFAULT;
+
+		return 0;
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+#else
+#define pcf8523_rtc_ioctl NULL
+#endif
+
 static const struct rtc_class_ops pcf8523_rtc_ops = {
 	.read_time = pcf8523_rtc_read_time,
 	.set_time = pcf8523_rtc_set_time,
+	.ioctl = pcf8523_rtc_ioctl,
 };
 
 static int pcf8523_probe(struct i2c_client *client,
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

origin.patch
linux-next.patch

