From: akpm@linux-foundation.org
Subject: + rtc-hctosys-only-claim-the-rtc-provided-the-system-time-if-it-did.patch added to -mm tree
Date: Thu, 11 Feb 2010 14:42:59 -0800
Message-ID: <201002112242.o1BMgxnX000569@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42532 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756902Ab0BKWnN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Feb 2010 17:43:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, a.zummo@towertech.it, p_gortmaker@yahoo.com


The patch titled
     rtc/hctosys: only claim the RTC provided the system time if it did
has been added to the -mm tree.  Its filename is
     rtc-hctosys-only-claim-the-rtc-provided-the-system-time-if-it-did.=
patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: rtc/hctosys: only claim the RTC provided the system time if it=
 did
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

Moreover change error handling in rtc_hctosys() to use goto and so
reduce the indention level.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/hctosys.c   |   63 +++++++++++++++++++++-----------------
 drivers/rtc/rtc-sysfs.c |    5 +--
 include/linux/rtc.h     |    6 +++
 3 files changed, 45 insertions(+), 29 deletions(-)

diff -puN drivers/rtc/hctosys.c~rtc-hctosys-only-claim-the-rtc-provided=
-the-system-time-if-it-did drivers/rtc/hctosys.c
--- a/drivers/rtc/hctosys.c~rtc-hctosys-only-claim-the-rtc-provided-the=
-system-time-if-it-did
+++ a/drivers/rtc/hctosys.c
@@ -22,48 +22,57 @@
  * the best guess is to add 0.5s.
  */
=20
+int rtc_hctosys_ret =3D -ENODEV;
+
 static int __init rtc_hctosys(void)
 {
-	int err;
+	int err =3D -ENODEV;
 	struct rtc_time tm;
+	struct timespec tv =3D {
+		.tv_nsec =3D NSEC_PER_SEC >> 1,
+	};
 	struct rtc_device *rtc =3D rtc_class_open(CONFIG_RTC_HCTOSYS_DEVICE);
=20
 	if (rtc =3D=3D NULL) {
-		printk("%s: unable to open rtc device (%s)\n",
+		pr_err("%s: unable to open rtc device (%s)\n",
 			__FILE__, CONFIG_RTC_HCTOSYS_DEVICE);
-		return -ENODEV;
+		goto err_open;
 	}
=20
 	err =3D rtc_read_time(rtc, &tm);
-	if (err =3D=3D 0) {
-		err =3D rtc_valid_tm(&tm);
-		if (err =3D=3D 0) {
-			struct timespec tv;
-
-			tv.tv_nsec =3D NSEC_PER_SEC >> 1;
-
-			rtc_tm_to_time(&tm, &tv.tv_sec);
-
-			do_settimeofday(&tv);
-
-			dev_info(rtc->dev.parent,
-				"setting system clock to "
-				"%d-%02d-%02d %02d:%02d:%02d UTC (%u)\n",
-				tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
-				tm.tm_hour, tm.tm_min, tm.tm_sec,
-				(unsigned int) tv.tv_sec);
-		}
-		else
-			dev_err(rtc->dev.parent,
-				"hctosys: invalid date/time\n");
-	}
-	else
+	if (err) {
 		dev_err(rtc->dev.parent,
 			"hctosys: unable to read the hardware clock\n");
+		goto err_read;
+
+	}
=20
+	err =3D rtc_valid_tm(&tm);
+	if (err) {
+		dev_err(rtc->dev.parent,
+			"hctosys: invalid date/time\n");
+		goto err_invalid;
+	}
+
+	rtc_tm_to_time(&tm, &tv.tv_sec);
+
+	do_settimeofday(&tv);
+
+	dev_info(rtc->dev.parent,
+		"setting system clock to "
+		"%d-%02d-%02d %02d:%02d:%02d UTC (%u)\n",
+		tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
+		tm.tm_hour, tm.tm_min, tm.tm_sec,
+		(unsigned int) tv.tv_sec);
+
+err_invalid:
+err_read:
 	rtc_class_close(rtc);
=20
-	return 0;
+err_open:
+	rtc_hctosys_ret =3D err;
+
+	return err;
 }
=20
 late_initcall(rtc_hctosys);
diff -puN drivers/rtc/rtc-sysfs.c~rtc-hctosys-only-claim-the-rtc-provid=
ed-the-system-time-if-it-did drivers/rtc/rtc-sysfs.c
--- a/drivers/rtc/rtc-sysfs.c~rtc-hctosys-only-claim-the-rtc-provided-t=
he-system-time-if-it-did
+++ a/drivers/rtc/rtc-sysfs.c
@@ -107,8 +107,9 @@ rtc_sysfs_show_hctosys(struct device *de
 		char *buf)
 {
 #ifdef CONFIG_RTC_HCTOSYS_DEVICE
-	if (strcmp(dev_name(&to_rtc_device(dev)->dev),
-		   CONFIG_RTC_HCTOSYS_DEVICE) =3D=3D 0)
+	if (rtc_hctosys_ret =3D=3D 0 &&
+			strcmp(dev_name(&to_rtc_device(dev)->dev),
+				CONFIG_RTC_HCTOSYS_DEVICE) =3D=3D 0)
 		return sprintf(buf, "1\n");
 	else
 #endif
diff -puN include/linux/rtc.h~rtc-hctosys-only-claim-the-rtc-provided-t=
he-system-time-if-it-did include/linux/rtc.h
--- a/include/linux/rtc.h~rtc-hctosys-only-claim-the-rtc-provided-the-s=
ystem-time-if-it-did
+++ a/include/linux/rtc.h
@@ -238,6 +238,12 @@ static inline bool is_leap_year(unsigned
 	return (!(year % 4) && (year % 100)) || !(year % 400);
 }
=20
+#ifdef CONFIG_RTC_HCTOSYS
+extern int rtc_hctosys_ret;
+#else
+#define rtc_hctosys_ret -ENODEV
+#endif
+
 #endif /* __KERNEL__ */
=20
 #endif /* _LINUX_RTC_H_ */
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

linux-next.patch
x86-move-hp-wmis-probe-function-to-devinittext.patch
platform-drivers-move-probe-to-devinittext-in-arch-arm.patch
media-move-omap24xxcams-probe-function-to-devinittext.patch
i2c-move-i2c_omaps-probe-function-to-devinittext.patch
hrtimer-correct-a-few-numbers-in-comments.patch
clockevents-ensure-taht-min_delta_ns-is-increased-in-error-path.patch
net-move-am79c961s-probe-function-to-devinittext.patch
genirq-warn-about-irqf_sharedirqf_disabled-at-the-right-place.patch
platform-drivers-move-probe-to-devinittext-in-drivers-scsi.patch
rtc-pcf2123-move-pcf2123_remove-to-devexittext.patch
rtc-hctosys-only-claim-the-rtc-provided-the-system-time-if-it-did.patch
platform-drivers-move-probe-to-devinittext-in-drivers-video.patch
auxdisplay-move-cfag12864bfbs-probe-function-to-devinittext.patch
w1-move-omap_hdqs-probe-function-to-devinittext.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
