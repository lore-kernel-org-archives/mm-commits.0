From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-cmos-use-dev_warn-dev_dbg-instead-of-printk-pr_debug.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:44:41 -0800
Message-ID: <20130222204441.A06B15A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:39948 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758377Ab3BVUom (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:44:42 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so103948yhz.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:44:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-cmos: use dev_warn()/dev_dbg() instead of printk()/pr_debug()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-cmos-use-dev_warn-dev_dbg-instead-of-printk-pr_debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-cmos: use dev_warn()/dev_dbg() instead of printk()/pr_debug()

Fix the checkpatch warning as below:

  WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~rtc-rtc-cmos-use-dev_warn-dev_dbg-instead-of-printk-pr_debug drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-rtc-cmos-use-dev_warn-dev_dbg-instead-of-printk-pr_debug
+++ a/drivers/rtc/rtc-cmos.c
@@ -706,7 +706,7 @@ cmos_do_probe(struct device *dev, struct
 			rtc_cmos_int_handler = hpet_rtc_interrupt;
 			err = hpet_register_irq_handler(cmos_interrupt);
 			if (err != 0) {
-				printk(KERN_WARNING "hpet_register_irq_handler "
+				dev_warn(dev, "hpet_register_irq_handler "
 						" failed in rtc_init().");
 				goto cleanup1;
 			}
@@ -731,8 +731,7 @@ cmos_do_probe(struct device *dev, struct
 		goto cleanup2;
 	}
 
-	pr_info("%s: %s%s, %zd bytes nvram%s\n",
-		dev_name(&cmos_rtc.rtc->dev),
+	dev_info(dev, "%s%s, %zd bytes nvram%s\n",
 		!is_valid_irq(rtc_irq) ? "no alarms" :
 			cmos_rtc.mon_alrm ? "alarms up to one year" :
 			cmos_rtc.day_alrm ? "alarms up to one month" :
@@ -820,8 +819,7 @@ static int cmos_suspend(struct device *d
 			enable_irq_wake(cmos->irq);
 	}
 
-	pr_debug("%s: suspend%s, ctrl %02x\n",
-			dev_name(&cmos_rtc.rtc->dev),
+	dev_dbg(dev, "suspend%s, ctrl %02x\n",
 			(tmp & RTC_AIE) ? ", alarm may wake" : "",
 			tmp);
 
@@ -876,9 +874,7 @@ static int cmos_resume(struct device *de
 		spin_unlock_irq(&rtc_lock);
 	}
 
-	pr_debug("%s: resume, ctrl %02x\n",
-			dev_name(&cmos_rtc.rtc->dev),
-			tmp);
+	dev_dbg(dev, "resume, ctrl %02x\n", tmp);
 
 	return 0;
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

