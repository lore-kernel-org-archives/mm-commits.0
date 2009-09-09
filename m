From: akpm@linux-foundation.org
Subject: + rtc-add-hctosys-sysfs-attribute.patch added to -mm tree
Date: Tue, 08 Sep 2009 17:39:43 -0700
Message-ID: <200909090039.n890dhnA024704@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751013AbZIIAkZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2009 20:40:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg59@srcf.ucam.org, a.zummo@towertech.it, broonie@opensource.wolfsonmicro.com, david-b@pacbell.net, mjg@redhat.com


The patch titled
     rtc: add boot_timesource sysfs attribute
has been added to the -mm tree.  Its filename is
     rtc-add-hctosys-sysfs-attribute.patch

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
Subject: rtc: add boot_timesource sysfs attribute
From: Matthew Garrett <mjg59@srcf.ucam.org>

CONFIG_RTC_HCTOSYS allows the kernel to read the system time from the RTC
at boot and resume, avoiding the need for userspace to do so. 
Unfortunately userspace currently has no way to know whether this
configuration option is enabled and thus cannot sensibly choose whether to
run hwclock itself or not.  Add a hctosys sysfs attribute which indicates
whether a given RTC set the system clock.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/rtc.txt   |    2 ++
 drivers/rtc/rtc-sysfs.c |   14 ++++++++++++++
 2 files changed, 16 insertions(+)

diff -puN Documentation/rtc.txt~rtc-add-hctosys-sysfs-attribute Documentation/rtc.txt
--- a/Documentation/rtc.txt~rtc-add-hctosys-sysfs-attribute
+++ a/Documentation/rtc.txt
@@ -143,6 +143,8 @@ rtc attributes without requiring the use
 are in the RTC's timezone, rather than in system time.
 
 date:  	   	 RTC-provided date
+hctosys:   	 1 if the RTC provided the system time at boot via the
+		 CONFIG_RTC_HCTOSYS kernel option, 0 otherwise
 max_user_freq:	 The maximum interrupt rate an unprivileged user may request
 		 from this RTC.
 name:		 The name of the RTC corresponding to this sysfs directory
diff -puN drivers/rtc/rtc-sysfs.c~rtc-add-hctosys-sysfs-attribute drivers/rtc/rtc-sysfs.c
--- a/drivers/rtc/rtc-sysfs.c~rtc-add-hctosys-sysfs-attribute
+++ a/drivers/rtc/rtc-sysfs.c
@@ -102,6 +102,19 @@ rtc_sysfs_set_max_user_freq(struct devic
 	return n;
 }
 
+static ssize_t
+rtc_sysfs_show_hctosys(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+#ifdef CONFIG_RTC_HCTOSYS_DEVICE
+	if (strcmp(dev_name(&to_rtc_device(dev)->dev),
+		   CONFIG_RTC_HCTOSYS_DEVICE) == 0)
+		return sprintf(buf, "1\n");
+	else
+#endif
+		return sprintf(buf, "0\n");
+}
+
 static struct device_attribute rtc_attrs[] = {
 	__ATTR(name, S_IRUGO, rtc_sysfs_show_name, NULL),
 	__ATTR(date, S_IRUGO, rtc_sysfs_show_date, NULL),
@@ -109,6 +122,7 @@ static struct device_attribute rtc_attrs
 	__ATTR(since_epoch, S_IRUGO, rtc_sysfs_show_since_epoch, NULL),
 	__ATTR(max_user_freq, S_IRUGO | S_IWUSR, rtc_sysfs_show_max_user_freq,
 			rtc_sysfs_set_max_user_freq),
+	__ATTR(hctosys, S_IRUGO, rtc_sysfs_show_hctosys, NULL),
 	{ },
 };
 
_

Patches currently in -mm which might be from mjg59@srcf.ucam.org are

rtc-add-hctosys-sysfs-attribute.patch

