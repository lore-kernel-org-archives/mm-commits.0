From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-s3cc-allow-multiple-open-allow-no-ioctl-opened-rtc-to-have-irq.patch removed from -mm tree
Date: Fri, 26 Aug 2011 12:07:10 -0700
Message-ID: <201108261903.p7QJ3suK005735@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753588Ab1HZTFL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 15:05:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: myungjoo.ham@samsung.com, a.zummo@towertech.it, chaos.youn@samsung.com, kgene.kim@samsung.com, kyungmin.park@samsung.com, mm-commits@vger.kernel.org


The patch titled
     drivers/rtc/rtc-s3c.c: allow multiple open / allow no-ioctl-open'ed rtc to have irq.
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-s3cc-allow-multiple-open-allow-no-ioctl-opened-rtc-to-have-irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/rtc/rtc-s3c.c: allow multiple open / allow no-ioctl-open'ed rtc to have irq.
From: MyungJoo Ham <myungjoo.ham@samsung.com>

The previous rtc-s3c had two issues related with its IRQ.

1.  Users cannot open rtc multiple times because an open operation
   calls request_irq on the same IRQ.  (e.g., two user processes wants to
   open and read RTC time from rtc-s3c at the same time)

2.  If alarm is set and no one has the rtc opened with filesystem
   (either the alarm is set by kernel/boot-loader or user set an alarm and
   closed rtc dev file), the pending bit is not cleared and no further
   interrupt is invoked.  When the alarm is used by the system itself such
   as a resume from suspend-to-RAM or other Low-power modes/idle, this is
   a critical issue.

This patch mitigates these issues by calling request_irq at probe and
free_irq at remove.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Changhwan Youn <chaos.youn@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |   67 ++++++++++++++--------------------------
 1 file changed, 25 insertions(+), 42 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-allow-multiple-open-allow-no-ioctl-opened-rtc-to-have-irq drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-allow-multiple-open-allow-no-ioctl-opened-rtc-to-have-irq
+++ a/drivers/rtc/rtc-s3c.c
@@ -319,49 +319,7 @@ static int s3c_rtc_proc(struct device *d
 	return 0;
 }
 
-static int s3c_rtc_open(struct device *dev)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct rtc_device *rtc_dev = platform_get_drvdata(pdev);
-	int ret;
-
-	ret = request_irq(s3c_rtc_alarmno, s3c_rtc_alarmirq,
-			  IRQF_DISABLED,  "s3c2410-rtc alarm", rtc_dev);
-
-	if (ret) {
-		dev_err(dev, "IRQ%d error %d\n", s3c_rtc_alarmno, ret);
-		return ret;
-	}
-
-	ret = request_irq(s3c_rtc_tickno, s3c_rtc_tickirq,
-			  IRQF_DISABLED,  "s3c2410-rtc tick", rtc_dev);
-
-	if (ret) {
-		dev_err(dev, "IRQ%d error %d\n", s3c_rtc_tickno, ret);
-		goto tick_err;
-	}
-
-	return ret;
-
- tick_err:
-	free_irq(s3c_rtc_alarmno, rtc_dev);
-	return ret;
-}
-
-static void s3c_rtc_release(struct device *dev)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct rtc_device *rtc_dev = platform_get_drvdata(pdev);
-
-	/* do not clear AIE here, it may be needed for wake */
-
-	free_irq(s3c_rtc_alarmno, rtc_dev);
-	free_irq(s3c_rtc_tickno, rtc_dev);
-}
-
 static const struct rtc_class_ops s3c_rtcops = {
-	.open		= s3c_rtc_open,
-	.release	= s3c_rtc_release,
 	.read_time	= s3c_rtc_gettime,
 	.set_time	= s3c_rtc_settime,
 	.read_alarm	= s3c_rtc_getalarm,
@@ -425,6 +383,9 @@ static int __devexit s3c_rtc_remove(stru
 {
 	struct rtc_device *rtc = platform_get_drvdata(dev);
 
+	free_irq(s3c_rtc_alarmno, rtc);
+	free_irq(s3c_rtc_tickno, rtc);
+
 	platform_set_drvdata(dev, NULL);
 	rtc_device_unregister(rtc);
 
@@ -548,10 +509,32 @@ static int __devinit s3c_rtc_probe(struc
 
 	s3c_rtc_setfreq(&pdev->dev, 1);
 
+	ret = request_irq(s3c_rtc_alarmno, s3c_rtc_alarmirq,
+			  IRQF_DISABLED,  "s3c2410-rtc alarm", rtc);
+	if (ret) {
+		dev_err(&pdev->dev, "IRQ%d error %d\n", s3c_rtc_alarmno, ret);
+		goto err_alarm_irq;
+	}
+
+	ret = request_irq(s3c_rtc_tickno, s3c_rtc_tickirq,
+			  IRQF_DISABLED,  "s3c2410-rtc tick", rtc);
+	if (ret) {
+		dev_err(&pdev->dev, "IRQ%d error %d\n", s3c_rtc_tickno, ret);
+		free_irq(s3c_rtc_alarmno, rtc);
+		goto err_tick_irq;
+	}
+
 	clk_disable(rtc_clk);
 
 	return 0;
 
+ err_tick_irq:
+	free_irq(s3c_rtc_alarmno, rtc);
+
+ err_alarm_irq:
+	platform_set_drvdata(pdev, NULL);
+	rtc_device_unregister(rtc);
+
  err_nortc:
 	s3c_rtc_enable(pdev, 0);
 	clk_disable(rtc_clk);
_

Patches currently in -mm which might be from myungjoo.ham@samsung.com are

origin.patch
linux-next.patch

