From: akpm@linux-foundation.org
Subject: - rtc-use-set_mmss-when-set_time-is-not-available.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:19:17 -0800
Message-ID: <200901072219.n07MJHa7018622@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41519 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758868AbZAGWht (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:37:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.zummo@towertech.it, buytenh@wantstofly.org, david-b@pacbell.net, galak@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     rtc: use set_mmss when set_time is not available
has been removed from the -mm tree.  Its filename was
     rtc-use-set_mmss-when-set_time-is-not-available.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
