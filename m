From: akpm@linux-foundation.org
Subject: + rtc-use-set_mmss-when-set_time-is-not-available.patch added to -mm tree
Date: Fri, 21 Nov 2008 15:47:43 -0800
Message-ID: <200811212347.mALNlhIo002309@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752974AbYKUXsd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 18:48:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.zummo@towertech.it, buytenh@wantstofly.org, david-b@pacbell.net, galak@kernel.crashing.org


The patch titled
     rtc: use set_mmss when set_time is not available
has been added to the -mm tree.  Its filename is
     rtc-use-set_mmss-when-set_time-is-not-available.patch

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
Subject: rtc: use set_mmss when set_time is not available
From: Alessandro Zummo <a.zummo@towertech.it>

Drivers should only need to implement either set_mmss (counter based RTCs)
or set_time (most RTCs).  The RTC subsystem will handle them
appropriately.

Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c  |   11 ++++++++---
 drivers/rtc/rtc-ds1672.c |   22 ----------------------
 drivers/rtc/rtc-ep93xx.c |   13 -------------
 drivers/rtc/rtc-test.c   |    8 +-------
 4 files changed, 9 insertions(+), 45 deletions(-)

diff -puN drivers/rtc/interface.c~rtc-use-set_mmss-when-set_time-is-not-available drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~rtc-use-set_mmss-when-set_time-is-not-available
+++ a/drivers/rtc/interface.c
@@ -50,10 +50,15 @@ int rtc_set_time(struct rtc_device *rtc,
 
 	if (!rtc->ops)
 		err = -ENODEV;
-	else if (!rtc->ops->set_time)
-		err = -EINVAL;
-	else
+	else if (rtc->ops->set_time)
 		err = rtc->ops->set_time(rtc->dev.parent, tm);
+	else if (rtc->ops->set_mmss) {
+		unsigned long secs;
+		err = rtc_tm_to_time(tm, &secs);
+		if (err == 0)
+			err = rtc->ops->set_mmss(rtc->dev.parent, secs);
+	} else
+		err = -EINVAL;
 
 	mutex_unlock(&rtc->ops_lock);
 	return err;
diff -puN drivers/rtc/rtc-ds1672.c~rtc-use-set_mmss-when-set_time-is-not-available drivers/rtc/rtc-ds1672.c
--- a/drivers/rtc/rtc-ds1672.c~rtc-use-set_mmss-when-set_time-is-not-available
+++ a/drivers/rtc/rtc-ds1672.c
@@ -83,32 +83,11 @@ static int ds1672_set_mmss(struct i2c_cl
 	return 0;
 }
 
-static int ds1672_set_datetime(struct i2c_client *client, struct rtc_time *tm)
-{
-	unsigned long secs;
-
-	dev_dbg(&client->dev,
-		"%s: secs=%d, mins=%d, hours=%d, "
-		"mday=%d, mon=%d, year=%d, wday=%d\n",
-		__func__,
-		tm->tm_sec, tm->tm_min, tm->tm_hour,
-		tm->tm_mday, tm->tm_mon, tm->tm_year, tm->tm_wday);
-
-	rtc_tm_to_time(tm, &secs);
-
-	return ds1672_set_mmss(client, secs);
-}
-
 static int ds1672_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	return ds1672_get_datetime(to_i2c_client(dev), tm);
 }
 
-static int ds1672_rtc_set_time(struct device *dev, struct rtc_time *tm)
-{
-	return ds1672_set_datetime(to_i2c_client(dev), tm);
-}
-
 static int ds1672_rtc_set_mmss(struct device *dev, unsigned long secs)
 {
 	return ds1672_set_mmss(to_i2c_client(dev), secs);
@@ -152,7 +131,6 @@ static DEVICE_ATTR(control, S_IRUGO, sho
 
 static const struct rtc_class_ops ds1672_rtc_ops = {
 	.read_time = ds1672_rtc_read_time,
-	.set_time = ds1672_rtc_set_time,
 	.set_mmss = ds1672_rtc_set_mmss,
 };
 
diff -puN drivers/rtc/rtc-ep93xx.c~rtc-use-set_mmss-when-set_time-is-not-available drivers/rtc/rtc-ep93xx.c
--- a/drivers/rtc/rtc-ep93xx.c~rtc-use-set_mmss-when-set_time-is-not-available
+++ a/drivers/rtc/rtc-ep93xx.c
@@ -49,18 +49,6 @@ static int ep93xx_rtc_set_mmss(struct de
 	return 0;
 }
 
-static int ep93xx_rtc_set_time(struct device *dev, struct rtc_time *tm)
-{
-	int err;
-	unsigned long secs;
-
-	err = rtc_tm_to_time(tm, &secs);
-	if (err != 0)
-		return err;
-
-	return ep93xx_rtc_set_mmss(dev, secs);
-}
-
 static int ep93xx_rtc_proc(struct device *dev, struct seq_file *seq)
 {
 	unsigned short preload, delete;
@@ -75,7 +63,6 @@ static int ep93xx_rtc_proc(struct device
 
 static const struct rtc_class_ops ep93xx_rtc_ops = {
 	.read_time	= ep93xx_rtc_read_time,
-	.set_time	= ep93xx_rtc_set_time,
 	.set_mmss	= ep93xx_rtc_set_mmss,
 	.proc		= ep93xx_rtc_proc,
 };
diff -puN drivers/rtc/rtc-test.c~rtc-use-set_mmss-when-set_time-is-not-available drivers/rtc/rtc-test.c
--- a/drivers/rtc/rtc-test.c~rtc-use-set_mmss-when-set_time-is-not-available
+++ a/drivers/rtc/rtc-test.c
@@ -34,14 +34,9 @@ static int test_rtc_read_time(struct dev
 	return 0;
 }
 
-static int test_rtc_set_time(struct device *dev,
-	struct rtc_time *tm)
-{
-	return 0;
-}
-
 static int test_rtc_set_mmss(struct device *dev, unsigned long secs)
 {
+	dev_info(dev, "%s, secs = %lu\n", __func__, secs);
 	return 0;
 }
 
@@ -78,7 +73,6 @@ static int test_rtc_ioctl(struct device 
 static const struct rtc_class_ops test_rtc_ops = {
 	.proc = test_rtc_proc,
 	.read_time = test_rtc_read_time,
-	.set_time = test_rtc_set_time,
 	.read_alarm = test_rtc_read_alarm,
 	.set_alarm = test_rtc_set_alarm,
 	.set_mmss = test_rtc_set_mmss,
_

Patches currently in -mm which might be from a.zummo@towertech.it are

origin.patch
genrtc-disable-genrtc-on-blackfin-systems.patch
rtc-ds1307-smbus-compatibility.patch
rtc-ds1307-remove-legacy-probe-checks.patch
rtc-struct-device-replace-bus_id-with-dev_name-dev_set_name.patch
rtc-bunch-of-drivers-fix-no-irq-case-handing.patch
rtc-move-power-of-2-periodic-frequency-check-down-into-drivers-v2.patch
rtc-driver-for-pxa27x-and-pxa3xx-soc.patch
rtc-pxa27x-pxa3xx-driver-fixes-revised.patch
rtc-add-alarm-update-irq-interfaces-version-5.patch
rtc-rtc-ds1390-probe-sequence-and-misc-fixes.patch
rtc-kconfig-cleanup.patch
rtc-au1000-on-chip-counter0-as-rtc-driver.patch
rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch
rtc-rtc-max6902-fixes-v3.patch
rtc-rtc-ds3234-fixes-v2.patch
rtc-use-set_mmss-when-set_time-is-not-available.patch

