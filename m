From: akpm@linux-foundation.org
Subject: [merged]
 drivers-rtc-rtc-sirfsocc-add-alarm_irq_enable-support.patch removed from
 -mm tree
Date: Thu, 11 Dec 2014 11:07:23 -0800
Message-ID: <5489eb6b.0szfjtuk10dBZOkA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45950 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaLKTHY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 14:07:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hao.liu@csr.com, Baohua.Song@csr.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-sirfsoc.c: add alarm_irq_enable support
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-sirfsocc-add-alarm_irq_enable-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: hao liu <hao.liu@csr.com>
Subject: drivers/rtc/rtc-sirfsoc.c: add alarm_irq_enable support

Add missed alarm_irq_enable() callback for CSR SiRFSoC RTCs.

[akpm@linux-foundation.org: remove unneeded cast]
Signed-off-by: hao liu <hao.liu@csr.com>
Signed-off-by: Barry Song <Baohua.Song@csr.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-sirfsoc.c |   27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-sirfsoc.c~drivers-rtc-rtc-sirfsocc-add-alarm_irq_enable-support drivers/rtc/rtc-sirfsoc.c
--- a/drivers/rtc/rtc-sirfsoc.c~drivers-rtc-rtc-sirfsocc-add-alarm_irq_enable-support
+++ a/drivers/rtc/rtc-sirfsoc.c
@@ -209,12 +209,37 @@ static int sirfsoc_rtc_ioctl(struct devi
 	}
 }
 
+static int sirfsoc_rtc_alarm_irq_enable(struct device *dev,
+		unsigned int enabled)
+{
+	unsigned long rtc_status_reg = 0x0;
+	struct sirfsoc_rtc_drv *rtcdrv;
+
+	rtcdrv = dev_get_drvdata(dev);
+
+	local_irq_disable();
+
+	rtc_status_reg = sirfsoc_rtc_iobrg_readl(
+				rtcdrv->rtc_base + RTC_STATUS);
+	if (enabled)
+		rtc_status_reg |= SIRFSOC_RTC_AL0E;
+	else
+		rtc_status_reg &= ~SIRFSOC_RTC_AL0E;
+
+	sirfsoc_rtc_iobrg_writel(rtc_status_reg, rtcdrv->rtc_base + RTC_STATUS);
+	local_irq_enable();
+
+	return 0;
+
+}
+
 static const struct rtc_class_ops sirfsoc_rtc_ops = {
 	.read_time = sirfsoc_rtc_read_time,
 	.set_time = sirfsoc_rtc_set_time,
 	.read_alarm = sirfsoc_rtc_read_alarm,
 	.set_alarm = sirfsoc_rtc_set_alarm,
-	.ioctl = sirfsoc_rtc_ioctl
+	.ioctl = sirfsoc_rtc_ioctl,
+	.alarm_irq_enable = sirfsoc_rtc_alarm_irq_enable
 };
 
 static irqreturn_t sirfsoc_rtc_irq_handler(int irq, void *pdata)
_

Patches currently in -mm which might be from hao.liu@csr.com are

origin.patch

