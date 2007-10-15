From: akpm@linux-foundation.org
Subject: + rtc-add-max_user_freq-to-sysfs.patch added to -mm tree
Date: Mon, 15 Oct 2007 12:12:53 -0700
Message-ID: <200710151912.l9FJCrOi020376@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42319 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757759AbXJOTN3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 15:13:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan@kdzbn.homelinux.net, a.zummo@towertech.it, david-b@pacbell.net


The patch titled
     rtc: add max_user_freq to sysfs
has been added to the -mm tree.  Its filename is
     rtc-add-max_user_freq-to-sysfs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rtc: add max_user_freq to sysfs
From: Bryan Kadzban <bryan@kdzbn.homelinux.net>

drivers/char/rtc.c exposed a sysctl to change the maximum frequency at
which a non-root user could ask the RTC to generate interrupts (via the
RTC_IRQP_SET ioctl).  This value is no longer available under the new RTC
subsystem, so add it to sysfs for each RTC device.

Works for me on x86_64 (both reads and writes), using rtc-cmos.

Signed-off-by: Bryan Kadzban <bryan@kdzbn.homelinux.net>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-sysfs.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff -puN drivers/rtc/rtc-sysfs.c~rtc-add-max_user_freq-to-sysfs drivers/rtc/rtc-sysfs.c
--- a/drivers/rtc/rtc-sysfs.c~rtc-add-max_user_freq-to-sysfs
+++ a/drivers/rtc/rtc-sysfs.c
@@ -73,11 +73,35 @@ rtc_sysfs_show_since_epoch(struct device
 	return retval;
 }
 
+static ssize_t
+rtc_sysfs_show_max_user_freq(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	return sprintf(buf, "%d\n", to_rtc_device(dev)->max_user_freq);
+}
+
+static ssize_t
+rtc_sysfs_set_max_user_freq(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t n)
+{
+	struct rtc_device *rtc = to_rtc_device(dev);
+	unsigned long val = simple_strtoul(buf, NULL, 0);
+
+	if (val >= 4096 || val == 0)
+		return -EINVAL;
+
+	rtc->max_user_freq = (int)val;
+
+	return n;
+}
+
 static struct device_attribute rtc_attrs[] = {
 	__ATTR(name, S_IRUGO, rtc_sysfs_show_name, NULL),
 	__ATTR(date, S_IRUGO, rtc_sysfs_show_date, NULL),
 	__ATTR(time, S_IRUGO, rtc_sysfs_show_time, NULL),
 	__ATTR(since_epoch, S_IRUGO, rtc_sysfs_show_since_epoch, NULL),
+	__ATTR(max_user_freq, S_IRUGO | S_IWUSR, rtc_sysfs_show_max_user_freq,
+			rtc_sysfs_set_max_user_freq),
 	{ },
 };
 
_

Patches currently in -mm which might be from bryan@kdzbn.homelinux.net are

rtc-add-max_user_freq-to-sysfs.patch
