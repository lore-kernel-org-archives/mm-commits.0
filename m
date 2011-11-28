From: akpm@linux-foundation.org
Subject: + rtc-ab8500-add-calibration-attribute-to-ab8500-rtc.patch added to -mm tree
Date: Mon, 28 Nov 2011 15:13:04 -0800
Message-ID: <201111282313.pASND5uO006922@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:54478 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab1K1XNG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2011 18:13:06 -0500
Received: by qyk15 with SMTP id 15so363569qyk.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2011 15:13:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mark.godfrey@stericsson.com, a.zummo@towertech.it, linus.walleij@stericsson.com


The patch titled
     Subject: rtc/ab8500: Add calibration attribute to AB8500 RTC
has been added to the -mm tree.  Its filename is
     rtc-ab8500-add-calibration-attribute-to-ab8500-rtc.patch

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
From: Mark Godfrey <mark.godfrey@stericsson.com>
Subject: rtc/ab8500: Add calibration attribute to AB8500 RTC

The rtc_calibration attribute allows user-space to get and set the
AB8500's RtcCalibration register.  The AB8500 will then use the value in
this register to compensate for RTC drift every 60 seconds.

Signed-off-by: Mark Godfrey <mark.godfrey@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-rtc-rtc0-device-rtc_calibration |   12 +
 drivers/rtc/rtc-ab8500.c                                              |  109 ++++++++++
 2 files changed, 121 insertions(+)

diff -puN /dev/null Documentation/ABI/testing/sysfs-class-rtc-rtc0-device-rtc_calibration
--- /dev/null
+++ a/Documentation/ABI/testing/sysfs-class-rtc-rtc0-device-rtc_calibration
@@ -0,0 +1,12 @@
+What:           Attribute for calibrating ST-Ericsson AB8500 Real Time Clock
+Date:           Oct 2011
+KernelVersion:  3.0
+Contact:        Mark Godfrey <mark.godfrey@stericsson.com>
+Description:    The rtc_calibration attribute allows the userspace to
+                calibrate the AB8500.s 32KHz Real Time Clock.
+                Every 60 seconds the AB8500 will correct the RTC's value
+                by adding to it the value of this attribute.
+                The range of the attribute is -127 to +127 in units of
+                30.5 micro-seconds (half-parts-per-million of the 32KHz clock)
+Users:          The /vendor/st-ericsson/base_utilities/core/rtc_calibration
+                daemon uses this interface.
diff -puN drivers/rtc/rtc-ab8500.c~rtc-ab8500-add-calibration-attribute-to-ab8500-rtc drivers/rtc/rtc-ab8500.c
--- a/drivers/rtc/rtc-ab8500.c~rtc-ab8500-add-calibration-attribute-to-ab8500-rtc
+++ a/drivers/rtc/rtc-ab8500.c
@@ -258,6 +258,106 @@ static int ab8500_rtc_set_alarm(struct d
 	return ab8500_rtc_irq_enable(dev, alarm->enabled);
 }
 
+
+static int ab8500_rtc_set_calibration(struct device *dev, int calibration)
+{
+	int retval;
+	u8  rtccal = 0;
+
+	/*
+	 * Check that the calibration value (which is in units of 0.5 parts-per-million)
+	 * is in the AB8500's range for RtcCalibration register.
+	 */
+	if ((calibration < -127) || (calibration > 127)) {
+		dev_err(dev, "RtcCalibration value outside permitted range\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * The AB8500 uses sign (in bit7) and magnitude (in bits0-7)
+	 * so need to convert to this sort of representation before writing
+	 * into RtcCalibration register...
+	 */
+	if (calibration >= 0)
+		rtccal = 0x7F & calibration;
+	else
+		rtccal = ~(calibration -1) | 0x80;
+
+	retval = abx500_set_register_interruptible(dev, AB8500_RTC,
+			AB8500_RTC_CALIB_REG, rtccal);
+
+	return retval;
+}
+
+static int ab8500_rtc_get_calibration(struct device *dev, int *calibration)
+{
+	int retval;
+	u8  rtccal = 0;
+
+	retval =  abx500_get_register_interruptible(dev, AB8500_RTC,
+			AB8500_RTC_CALIB_REG, &rtccal);
+	if (retval >= 0) {
+		/*
+		 * The AB8500 uses sign (in bit7) and magnitude (in bits0-7)
+		 * so need to convert value from RtcCalibration register into
+		 * a two's complement signed value...
+		 */
+		if (rtccal & 0x80)
+			*calibration = 0 - (rtccal & 0x7F);
+		else
+			*calibration = 0x7F & rtccal;
+	}
+
+	return retval;
+}
+
+static ssize_t ab8500_sysfs_store_rtc_calibration(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	int retval;
+	int calibration = 0;
+
+	if (sscanf(buf, " %i ", &calibration) != 1) {
+		dev_err(dev, "Failed to store RTC calibration attribute\n");
+		return -EINVAL;
+	}
+
+	retval = ab8500_rtc_set_calibration(dev, calibration);
+
+	return retval ? retval : count;
+}
+
+static ssize_t ab8500_sysfs_show_rtc_calibration(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	int  retval = 0;
+	int  calibration = 0;
+
+	retval = ab8500_rtc_get_calibration(dev, &calibration);
+	if (retval < 0) {
+		dev_err(dev, "Failed to read RTC calibration attribute\n");
+		sprintf(buf, "0\n");
+		return retval;
+	}
+
+	return sprintf(buf, "%d\n", calibration);
+}
+
+static DEVICE_ATTR(rtc_calibration, S_IRUGO | S_IWUSR,
+		   ab8500_sysfs_show_rtc_calibration,
+		   ab8500_sysfs_store_rtc_calibration);
+
+static int ab8500_sysfs_rtc_register(struct device *dev)
+{
+	return device_create_file(dev, &dev_attr_rtc_calibration);
+}
+
+static void ab8500_sysfs_rtc_unregister(struct device *dev)
+{
+	device_remove_file(dev, &dev_attr_rtc_calibration);
+}
+
 static irqreturn_t rtc_alarm_handler(int irq, void *data)
 {
 	struct rtc_device *rtc = data;
@@ -327,6 +427,13 @@ static int __devinit ab8500_rtc_probe(st
 
 	platform_set_drvdata(pdev, rtc);
 
+
+	err = ab8500_sysfs_rtc_register(&pdev->dev);
+	if (err) {
+		dev_err(&pdev->dev, "sysfs RTC failed to register\n");
+		return err;
+	}
+
 	return 0;
 }
 
@@ -335,6 +442,8 @@ static int __devexit ab8500_rtc_remove(s
 	struct rtc_device *rtc = platform_get_drvdata(pdev);
 	int irq = platform_get_irq_byname(pdev, "ALARM");
 
+	ab8500_sysfs_rtc_unregister(&pdev->dev);
+
 	free_irq(irq, rtc);
 	rtc_device_unregister(rtc);
 	platform_set_drvdata(pdev, NULL);
_
Subject: Subject: rtc/ab8500: Add calibration attribute to AB8500 RTC

Patches currently in -mm which might be from mark.godfrey@stericsson.com are

rtc-ab8500-add-calibration-attribute-to-ab8500-rtc.patch

