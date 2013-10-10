From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-puv3c-use-dev_dbg-instead-of-pr_debug.patch
 added to -mm tree
Date: Thu, 10 Oct 2013 15:52:03 -0700
Message-ID: <52572f93.+lgi5CXZ4nLoODVu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab3JJWwE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Oct 2013 18:52:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com, gxt@mprc.pku.edu.cn, a.zummo@towertech.it, sangjung.woo@samsung.com

Subject: + drivers-rtc-rtc-puv3c-use-dev_dbg-instead-of-pr_debug.patch added to -mm tree
To: sangjung.woo@samsung.com,a.zummo@towertech.it,gxt@mprc.pku.edu.cn,joe@perches.com
From: akpm@linux-foundation.org
Date: Thu, 10 Oct 2013 15:52:03 -0700


The patch titled
     Subject: drivers/rtc/rtc-puv3.c: use dev_dbg() instead of pr_debug()
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-puv3c-use-dev_dbg-instead-of-pr_debug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-puv3c-use-dev_dbg-instead-of-pr_debug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-puv3c-use-dev_dbg-instead-of-pr_debug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sangjung Woo <sangjung.woo@samsung.com>
Subject: drivers/rtc/rtc-puv3.c: use dev_dbg() instead of pr_debug()

Because dev_*() are used along with pr_debug() function in this code, the
debug message is not tidy.  This patch converts from pr_debug() to
dev_dbg() since dev_*() are encouraged to use in device driver code.

Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-puv3.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN drivers/rtc/rtc-puv3.c~drivers-rtc-rtc-puv3c-use-dev_dbg-instead-of-pr_debug drivers/rtc/rtc-puv3.c
--- a/drivers/rtc/rtc-puv3.c~drivers-rtc-rtc-puv3c-use-dev_dbg-instead-of-pr_debug
+++ a/drivers/rtc/rtc-puv3.c
@@ -53,11 +53,11 @@ static irqreturn_t puv3_rtc_tickirq(int
 }
 
 /* Update control registers */
-static void puv3_rtc_setaie(int to)
+static void puv3_rtc_setaie(struct device *dev, int to)
 {
 	unsigned int tmp;
 
-	pr_debug("%s: aie=%d\n", __func__, to);
+	dev_dbg(dev, "%s: aie=%d\n", __func__, to);
 
 	tmp = readl(RTC_RTSR) & ~RTC_RTSR_ALE;
 
@@ -71,7 +71,7 @@ static int puv3_rtc_setpie(struct device
 {
 	unsigned int tmp;
 
-	pr_debug("%s: pie=%d\n", __func__, enabled);
+	dev_debug(dev, "%s: pie=%d\n", __func__, enabled);
 
 	spin_lock_irq(&puv3_rtc_pie_lock);
 	tmp = readl(RTC_RTSR) & ~RTC_RTSR_HZE;
@@ -90,7 +90,7 @@ static int puv3_rtc_gettime(struct devic
 {
 	rtc_time_to_tm(readl(RTC_RCNR), rtc_tm);
 
-	pr_debug("read time %02x.%02x.%02x %02x/%02x/%02x\n",
+	dev_dbg(dev, "read time %02x.%02x.%02x %02x/%02x/%02x\n",
 		 rtc_tm->tm_year, rtc_tm->tm_mon, rtc_tm->tm_mday,
 		 rtc_tm->tm_hour, rtc_tm->tm_min, rtc_tm->tm_sec);
 
@@ -101,7 +101,7 @@ static int puv3_rtc_settime(struct devic
 {
 	unsigned long rtc_count = 0;
 
-	pr_debug("set time %02d.%02d.%02d %02d/%02d/%02d\n",
+	dev_dbg(dev, "set time %02d.%02d.%02d %02d/%02d/%02d\n",
 		 tm->tm_year, tm->tm_mon, tm->tm_mday,
 		 tm->tm_hour, tm->tm_min, tm->tm_sec);
 
@@ -119,7 +119,7 @@ static int puv3_rtc_getalarm(struct devi
 
 	alrm->enabled = readl(RTC_RTSR) & RTC_RTSR_ALE;
 
-	pr_debug("read alarm %02x %02x.%02x.%02x %02x/%02x/%02x\n",
+	dev_dbg(dev, "read alarm %02x %02x.%02x.%02x %02x/%02x/%02x\n",
 		 alrm->enabled,
 		 alm_tm->tm_year, alm_tm->tm_mon, alm_tm->tm_mday,
 		 alm_tm->tm_hour, alm_tm->tm_min, alm_tm->tm_sec);
@@ -132,7 +132,7 @@ static int puv3_rtc_setalarm(struct devi
 	struct rtc_time *tm = &alrm->time;
 	unsigned long rtcalarm_count = 0;
 
-	pr_debug("puv3_rtc_setalarm: %d, %02x/%02x/%02x %02x.%02x.%02x\n",
+	dev_dbg(dev, "puv3_rtc_setalarm: %d, %02x/%02x/%02x %02x.%02x.%02x\n",
 		 alrm->enabled,
 		 tm->tm_mday & 0xff, tm->tm_mon & 0xff, tm->tm_year & 0xff,
 		 tm->tm_hour & 0xff, tm->tm_min & 0xff, tm->tm_sec);
@@ -140,7 +140,7 @@ static int puv3_rtc_setalarm(struct devi
 	rtc_tm_to_time(tm, &rtcalarm_count);
 	writel(rtcalarm_count, RTC_RTAR);
 
-	puv3_rtc_setaie(alrm->enabled);
+	puv3_rtc_setaie(&dev->dev, alrm->enabled);
 
 	if (alrm->enabled)
 		enable_irq_wake(puv3_rtc_alarmno);
@@ -227,7 +227,7 @@ static int puv3_rtc_remove(struct platfo
 	rtc_device_unregister(rtc);
 
 	puv3_rtc_setpie(&dev->dev, 0);
-	puv3_rtc_setaie(0);
+	puv3_rtc_setaie(&dev->dev, 0);
 
 	release_resource(puv3_rtc_mem);
 	kfree(puv3_rtc_mem);
@@ -241,7 +241,7 @@ static int puv3_rtc_probe(struct platfor
 	struct resource *res;
 	int ret;
 
-	pr_debug("%s: probe=%p\n", __func__, pdev);
+	dev_dbg(&pdev->dev, "%s: probe=%p\n", __func__, pdev);
 
 	/* find the IRQs */
 	puv3_rtc_tickno = platform_get_irq(pdev, 1);
@@ -256,7 +256,7 @@ static int puv3_rtc_probe(struct platfor
 		return -ENOENT;
 	}
 
-	pr_debug("PKUnity_rtc: tick irq %d, alarm irq %d\n",
+	dev_dbg(&pdev->dev, "PKUnity_rtc: tick irq %d, alarm irq %d\n",
 		 puv3_rtc_tickno, puv3_rtc_alarmno);
 
 	/* get the memory region */
_

Patches currently in -mm which might be from sangjung.woo@samsung.com are

drivers-rtc-rtc-puv3c-use-dev_dbg-instead-of-pr_debug.patch

