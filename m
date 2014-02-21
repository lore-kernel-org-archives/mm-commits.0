From: akpm@linux-foundation.org
Subject: + rtc-mc13xxx-make-rtc_read_time-more-readable.patch added to -mm tree
Date: Fri, 21 Feb 2014 15:10:05 -0800
Message-ID: <5307dccd.3W9+D9SKw9xl79tY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59160 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625AbaBUXKG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 18:10:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, u.kleine-koenig@pengutronix.de, kernel@pengutronix.de, shc_work@mail.ru

Subject: + rtc-mc13xxx-make-rtc_read_time-more-readable.patch added to -mm tree
To: shc_work@mail.ru,kernel@pengutronix.de,u.kleine-koenig@pengutronix.de
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 15:10:05 -0800


The patch titled
     Subject: rtc: mc13xxx: make rtc_read_time() more readable
has been added to the -mm tree.  Its filename is
     rtc-mc13xxx-make-rtc_read_time-more-readable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-mc13xxx-make-rtc_read_time-more-readable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-mc13xxx-make-rtc_read_time-more-readable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Shiyan <shc_work@mail.ru>
Subject: rtc: mc13xxx: make rtc_read_time() more readable

Remove unnecessary locks when reading the time and make the read operation
until the values of day matched between reading the seconds, it will make
the mc13xxx_rtc_read_time() procedure more readable.  Additionally, patch
introduced a "seconds in a day" definition.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Sascha Hauer <kernel@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mc13xxx.c |   63 ++++++++++++++----------------------
 1 file changed, 25 insertions(+), 38 deletions(-)

diff -puN drivers/rtc/rtc-mc13xxx.c~rtc-mc13xxx-make-rtc_read_time-more-readable drivers/rtc/rtc-mc13xxx.c
--- a/drivers/rtc/rtc-mc13xxx.c~rtc-mc13xxx-make-rtc_read_time-more-readable
+++ a/drivers/rtc/rtc-mc13xxx.c
@@ -23,6 +23,8 @@
 #define MC13XXX_RTCDAY	22
 #define MC13XXX_RTCDAYA	23
 
+#define SEC_PER_DAY	(24 * 60 * 60)
+
 struct mc13xxx_rtc {
 	struct rtc_device *rtc;
 	struct mc13xxx *mc13xxx;
@@ -61,42 +63,27 @@ static int mc13xxx_rtc_read_time(struct
 {
 	struct mc13xxx_rtc *priv = dev_get_drvdata(dev);
 	unsigned int seconds, days1, days2;
-	unsigned long s1970;
-	int ret;
 
 	if (!priv->valid)
 		return -ENODATA;
 
-	mc13xxx_lock(priv->mc13xxx);
-
-	ret = mc13xxx_reg_read(priv->mc13xxx, MC13XXX_RTCDAY, &days1);
-	if (unlikely(ret))
-		goto out;
-
-	ret = mc13xxx_reg_read(priv->mc13xxx, MC13XXX_RTCTOD, &seconds);
-	if (unlikely(ret))
-		goto out;
-
-	ret = mc13xxx_reg_read(priv->mc13xxx, MC13XXX_RTCDAY, &days2);
-out:
-	mc13xxx_unlock(priv->mc13xxx);
-
-	if (ret)
-		return ret;
-
-	if (days2 == days1 + 1) {
-		if (seconds >= 86400 / 2)
-			days2 = days1;
-		else
-			days1 = days2;
-	}
-
-	if (days1 != days2)
-		return -EIO;
+	do {
+		int ret;
 
-	s1970 = days1 * 86400 + seconds;
+		ret = mc13xxx_reg_read(priv->mc13xxx, MC13XXX_RTCDAY, &days1);
+		if (ret)
+			return ret;
+
+		ret = mc13xxx_reg_read(priv->mc13xxx, MC13XXX_RTCTOD, &seconds);
+		if (ret)
+			return ret;
+
+		ret = mc13xxx_reg_read(priv->mc13xxx, MC13XXX_RTCDAY, &days2);
+		if (ret)
+			return ret;
+	} while (days1 != days2);
 
-	rtc_time_to_tm(s1970, tm);
+	rtc_time_to_tm(days1 * SEC_PER_DAY + seconds, tm);
 
 	return rtc_valid_tm(tm);
 }
@@ -108,8 +95,8 @@ static int mc13xxx_rtc_set_mmss(struct d
 	unsigned int alarmseconds;
 	int ret;
 
-	seconds = secs % 86400;
-	days = secs / 86400;
+	seconds = secs % SEC_PER_DAY;
+	days = secs / SEC_PER_DAY;
 
 	mc13xxx_lock(priv->mc13xxx);
 
@@ -121,7 +108,7 @@ static int mc13xxx_rtc_set_mmss(struct d
 	if (unlikely(ret))
 		goto out;
 
-	if (alarmseconds < 86400) {
+	if (alarmseconds < SEC_PER_DAY) {
 		ret = mc13xxx_reg_write(priv->mc13xxx,
 				MC13XXX_RTCTODA, 0x1ffff);
 		if (unlikely(ret))
@@ -145,7 +132,7 @@ static int mc13xxx_rtc_set_mmss(struct d
 		goto out;
 
 	/* restore alarm */
-	if (alarmseconds < 86400) {
+	if (alarmseconds < SEC_PER_DAY) {
 		ret = mc13xxx_reg_write(priv->mc13xxx,
 				MC13XXX_RTCTODA, alarmseconds);
 		if (unlikely(ret))
@@ -181,7 +168,7 @@ static int mc13xxx_rtc_read_alarm(struct
 	ret = mc13xxx_reg_read(priv->mc13xxx, MC13XXX_RTCTODA, &seconds);
 	if (unlikely(ret))
 		goto out;
-	if (seconds >= 86400) {
+	if (seconds >= SEC_PER_DAY) {
 		ret = -ENODATA;
 		goto out;
 	}
@@ -202,7 +189,7 @@ out:
 	alarm->enabled = enabled;
 	alarm->pending = pending;
 
-	s1970 = days * 86400 + seconds;
+	s1970 = days * SEC_PER_DAY + seconds;
 
 	rtc_time_to_tm(s1970, &alarm->time);
 	dev_dbg(dev, "%s: %lu\n", __func__, s1970);
@@ -240,8 +227,8 @@ static int mc13xxx_rtc_set_alarm(struct
 	if (unlikely(ret))
 		goto out;
 
-	seconds = s1970 % 86400;
-	days = s1970 / 86400;
+	seconds = s1970 % SEC_PER_DAY;
+	days = s1970 / SEC_PER_DAY;
 
 	ret = mc13xxx_reg_write(priv->mc13xxx, MC13XXX_RTCDAYA, days);
 	if (unlikely(ret))
_

Patches currently in -mm which might be from shc_work@mail.ru are

rtc-mc13xxx-remove-__exit_p.patch
rtc-mc13xxx-request-irqs-after-rtc-registration.patch
rtc-mc13xxx-simplify-alarm_irq_enable.patch
rtc-mc13xxx-fix-1hz-interrupt.patch
rtc-mc13xxx-change-rtc-validation-scheme.patch
rtc-mc13xxx-make-rtc_read_time-more-readable.patch
linux-next.patch

