From: akpm@linux-foundation.org
Subject: [merged] rtc_sysfs_show_hctosys-return-0-if-resume-failed.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:17:20 -0700
Message-ID: <20121005201720.C9EE31E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:60081 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757300Ab2JEURV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:17:21 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so172454yhl.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:17:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@fries.net, David@Fries.net, a.zummo@towertech.it, mjg@redhat.com, sfr@canb.auug.org.au, u.kleine-koenig@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc_sysfs_show_hctosys(): display 0 if resume failed
has been removed from the -mm tree.  Its filename was
     rtc_sysfs_show_hctosys-return-0-if-resume-failed.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: David Fries <david@fries.net>
Subject: rtc_sysfs_show_hctosys(): display 0 if resume failed

Without this patch /sys/class/rtc/$CONFIG_RTC_HCTOSYS_DEVICE/hctosys
contains a 1 (meaning "This rtc was used to initialize the system
clock") even if setting the time by do_settimeofday() at bootup failed.
The RTC can also be used to set the clock on resume, if it did 1,
otherwise 0.  Previously there was no indication if the RTC was used
to set the clock in resume.

This uses only CONFIG_RTC_HCTOSYS_DEVICE for conditional compilation
instead of it and CONFIG_RTC_HCTOSYS to be more consistent.
rtc_hctosys_ret was moved to class.c so class.c no longer depends on
hctosys.c.

[sfr@canb.auug.org.au: fix build]
Signed-off-by: David Fries <David@Fries.net>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/class.c     |    8 +++++++-
 drivers/rtc/hctosys.c   |    4 +---
 drivers/rtc/rtc-sysfs.c |    6 ++++++
 include/linux/rtc.h     |    2 +-
 4 files changed, 15 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/class.c~rtc_sysfs_show_hctosys-return-0-if-resume=
-failed drivers/rtc/class.c
--- a/drivers/rtc/class.c~rtc_sysfs_show_hctosys-return-0-if-resume-fai=
led
+++ a/drivers/rtc/class.c
@@ -31,8 +31,12 @@ static void rtc_device_release(struct de
 	kfree(rtc);
 }
=20
-#if defined(CONFIG_PM) && defined(CONFIG_RTC_HCTOSYS_DEVICE)
+#ifdef CONFIG_RTC_HCTOSYS_DEVICE
+/* Result of the last RTC to system clock attempt. */
+int rtc_hctosys_ret =3D -ENODEV;
+#endif
=20
+#if defined(CONFIG_PM) && defined(CONFIG_RTC_HCTOSYS_DEVICE)
 /*
  * On suspend(), measure the delta between one RTC and the
  * system's wall clock; restore it on resume().
@@ -84,6 +88,7 @@ static int rtc_resume(struct device *dev
 	struct timespec		new_system, new_rtc;
 	struct timespec		sleep_time;
=20
+	rtc_hctosys_ret =3D -ENODEV;
 	if (strcmp(dev_name(&rtc->dev), CONFIG_RTC_HCTOSYS_DEVICE) !=3D 0)
 		return 0;
=20
@@ -117,6 +122,7 @@ static int rtc_resume(struct device *dev
=20
 	if (sleep_time.tv_sec >=3D 0)
 		timekeeping_inject_sleeptime(&sleep_time);
+	rtc_hctosys_ret =3D 0;
 	return 0;
 }
=20
diff -puN drivers/rtc/hctosys.c~rtc_sysfs_show_hctosys-return-0-if-resu=
me-failed drivers/rtc/hctosys.c
--- a/drivers/rtc/hctosys.c~rtc_sysfs_show_hctosys-return-0-if-resume-f=
ailed
+++ a/drivers/rtc/hctosys.c
@@ -22,8 +22,6 @@
  * the best guess is to add 0.5s.
  */
=20
-int rtc_hctosys_ret =3D -ENODEV;
-
 static int __init rtc_hctosys(void)
 {
 	int err =3D -ENODEV;
@@ -56,7 +54,7 @@ static int __init rtc_hctosys(void)
=20
 	rtc_tm_to_time(&tm, &tv.tv_sec);
=20
-	do_settimeofday(&tv);
+	err =3D do_settimeofday(&tv);
=20
 	dev_info(rtc->dev.parent,
 		"setting system clock to "
diff -puN drivers/rtc/rtc-sysfs.c~rtc_sysfs_show_hctosys-return-0-if-re=
sume-failed drivers/rtc/rtc-sysfs.c
--- a/drivers/rtc/rtc-sysfs.c~rtc_sysfs_show_hctosys-return-0-if-resume=
-failed
+++ a/drivers/rtc/rtc-sysfs.c
@@ -102,6 +102,12 @@ rtc_sysfs_set_max_user_freq(struct devic
 	return n;
 }
=20
+/**
+ * rtc_sysfs_show_hctosys - indicate if the given RTC set the system t=
ime
+ *
+ * Returns 1 if the system clock was set by this RTC at the last
+ * boot or resume event.
+ */
 static ssize_t
 rtc_sysfs_show_hctosys(struct device *dev, struct device_attribute *at=
tr,
 		char *buf)
diff -puN include/linux/rtc.h~rtc_sysfs_show_hctosys-return-0-if-resume=
-failed include/linux/rtc.h
--- a/include/linux/rtc.h~rtc_sysfs_show_hctosys-return-0-if-resume-fai=
led
+++ a/include/linux/rtc.h
@@ -276,7 +276,7 @@ static inline bool is_leap_year(unsigned
 	return (!(year % 4) && (year % 100)) || !(year % 400);
 }
=20
-#ifdef CONFIG_RTC_HCTOSYS
+#ifdef CONFIG_RTC_HCTOSYS_DEVICE
 extern int rtc_hctosys_ret;
 #else
 #define rtc_hctosys_ret -ENODEV
_

Patches currently in -mm which might be from david@fries.net are

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
