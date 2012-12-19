From: akpm@linux-foundation.org
Subject: + rtc-pcf8523-add-low-battery-voltage-support.patch added to -mm tree
Date: Wed, 19 Dec 2012 14:04:24 -0800
Message-ID: <20121219220425.77EBB100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:48727 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab2LSWE0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 17:04:26 -0500
Received: by mail-qc0-f201.google.com with SMTP id a6so291176qch.0
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 14:04:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.nilsson@axis.com, thierry.reding@avionic-design.de


The patch titled
     Subject: rtc-pcf8523: add low battery voltage support
has been added to the -mm tree.  Its filename is
     rtc-pcf8523-add-low-battery-voltage-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jesper Nilsson <jesper.nilsson@axis.com>
Subject: rtc-pcf8523: add low battery voltage support

Implement reading of the battery voltage low signal for rtc-pcf8523.

The bit is read-only and cannot be cleared by software, so no
clear function is implemented.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8523.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

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
@@ -250,9 +251,35 @@ static int pcf8523_rtc_set_time(struct d
 	return pcf8523_start_rtc(client);
 }
 
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
cris-use-int-for-ssize_t-to-match-size_t.patch
rtc-pcf8523-add-low-battery-voltage-support.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch

