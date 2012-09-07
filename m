From: akpm@linux-foundation.org
Subject: + rtc_sysfs_show_hctosys-return-0-if-resume-failed.patch added to -mm tree
Date: Fri, 07 Sep 2012 16:56:36 -0700
Message-ID: <20120907235637.1F6345C0213@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:54277 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758824Ab2IGX4k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Sep 2012 19:56:40 -0400
Received: by lagw12 with SMTP id w12so5347lag.1
        for <mm-commits@vger.kernel.org>; Fri, 07 Sep 2012 16:56:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@fries.net, David@Fries.net, a.zummo@towertech.it, mjg@redhat.com, u.kleine-koenig@pengutronix.de


The patch titled
     Subject: rtc_sysfs_show_hctosys(): display 0 if resume failed
has been added to the -mm tree.  Its filename is
     rtc_sysfs_show_hctosys-return-0-if-resume-failed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: David Fries <david@fries.net>
Subject: rtc_sysfs_show_hctosys(): display 0 if resume failed

The original rtc_sysfs_show_hctosys() returnd 1 if this device was the
CONFIG_RTC_HCTOSYS_DEVICE device.  A later patch checked rtc_hctosys_re=
t
from boot, this verifies that the boot do_settimeofday() succeeded, and
sets rtc_hctosys_ret in resume to indicate when adjusting the clock fro=
m
resume fails.

This uses only CONFIG_RTC_HCTOSYS_DEVICE for conditional compilation
instead of it and CONFIG_RTC_HCTOSYS.  rtc_hctosys_ret was moved to
class.c so rtc_hctosys can be removed with just a Kconfig change if boo=
t
time setting isn't desired.

Signed-off-by: David Fries <David@Fries.net>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/class.c     |    5 ++++-
 drivers/rtc/hctosys.c   |    4 +---
 drivers/rtc/rtc-sysfs.c |    6 ++++++
 include/linux/rtc.h     |    2 +-
 4 files changed, 12 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/class.c~rtc_sysfs_show_hctosys-return-0-if-resume=
-failed drivers/rtc/class.c
--- a/drivers/rtc/class.c~rtc_sysfs_show_hctosys-return-0-if-resume-fai=
led
+++ a/drivers/rtc/class.c
@@ -39,7 +39,8 @@ static void rtc_device_release(struct de
  */
=20
 static struct timespec old_rtc, old_system, old_delta;
-
+/* Result of the last RTC to system clock attempt. */
+int rtc_hctosys_ret =3D -ENODEV;
=20
 static int rtc_suspend(struct device *dev, pm_message_t mesg)
 {
@@ -84,6 +85,7 @@ static int rtc_resume(struct device *dev
 	struct timespec		new_system, new_rtc;
 	struct timespec		sleep_time;
=20
+	rtc_hctosys_ret =3D -ENODEV;
 	if (strcmp(dev_name(&rtc->dev), CONFIG_RTC_HCTOSYS_DEVICE) !=3D 0)
 		return 0;
=20
@@ -117,6 +119,7 @@ static int rtc_resume(struct device *dev
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

rtc_sysfs_show_hctosys-return-0-if-resume-failed.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
