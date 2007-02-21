From: akpm@linux-foundation.org
Subject: - at91_rtc-updates.patch removed from -mm tree
Date: Wed, 21 Feb 2007 02:46:30 -0800
Message-ID: <200702211046.l1LAkUbe006475@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46979 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965365AbXBUKqq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 05:46:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     at91_rtc updates
has been removed from the -mm tree.  Its filename was
     at91_rtc-updates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: at91_rtc updates
From: David Brownell <david-b@pacbell.net>

Various bug fixes to the at91rm9200 RTC:

 - alarm:  setalarm() should pay attention to the "enabled" flag

 - init:  cleaner handling of the wakeup flags, which cpu init should
   really have set up.  Doing it here is just a workaround.

 - linkage:  since the at91_rtc driver probe() routine is in the init
   section, it should use platform_driver_probe() instead of leaving
   that pointer around in the driver struct after init section removal.

 - linkage:  likewise, remove() belongs in the exit section.

Among other things, the init and alarm changes ensure that this driver
handles the new sysfs "wakealarm" attribute properly.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at91rm9200.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-at91rm9200.c~at91_rtc-updates drivers/rtc/rtc-at91rm9200.c
--- a/drivers/rtc/rtc-at91rm9200.c~at91_rtc-updates
+++ a/drivers/rtc/rtc-at91rm9200.c
@@ -164,6 +164,7 @@ static int at91_rtc_setalarm(struct devi
 	tm.tm_min = alrm->time.tm_min;
 	tm.tm_sec = alrm->time.tm_sec;
 
+	at91_sys_write(AT91_RTC_IDR, AT91_RTC_ALARM);
 	at91_sys_write(AT91_RTC_TIMALR,
 		  BIN2BCD(tm.tm_sec) << 0
 		| BIN2BCD(tm.tm_min) << 8
@@ -174,6 +175,9 @@ static int at91_rtc_setalarm(struct devi
 		| BIN2BCD(tm.tm_mday) << 24
 		| AT91_RTC_DATEEN | AT91_RTC_MTHEN);
 
+	if (alrm->enabled)
+		at91_sys_write(AT91_RTC_IER, AT91_RTC_ALARM);
+
 	pr_debug("%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __FUNCTION__,
 		at91_alarm_year, tm.tm_mon, tm.tm_mday, tm.tm_hour,
 		tm.tm_min, tm.tm_sec);
@@ -303,6 +307,12 @@ static int __init at91_rtc_probe(struct 
 		return ret;
 	}
 
+	/* cpu init code should really have flagged this device as
+	 * being wake-capable; if it didn't, do that here.
+	 */
+	if (!device_can_wakeup(&pdev->dev))
+		device_init_wakeup(&pdev->dev, 1);
+
 	rtc = rtc_device_register(pdev->name, &pdev->dev,
 				&at91_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
@@ -310,7 +320,6 @@ static int __init at91_rtc_probe(struct 
 		return PTR_ERR(rtc);
 	}
 	platform_set_drvdata(pdev, rtc);
-	device_init_wakeup(&pdev->dev, 1);
 
 	printk(KERN_INFO "AT91 Real Time Clock driver.\n");
 	return 0;
@@ -319,7 +328,7 @@ static int __init at91_rtc_probe(struct 
 /*
  * Disable and remove the RTC driver
  */
-static int __devexit at91_rtc_remove(struct platform_device *pdev)
+static int __exit at91_rtc_remove(struct platform_device *pdev)
 {
 	struct rtc_device *rtc = platform_get_drvdata(pdev);
 
@@ -331,7 +340,6 @@ static int __devexit at91_rtc_remove(str
 
 	rtc_device_unregister(rtc);
 	platform_set_drvdata(pdev, NULL);
-	device_init_wakeup(&pdev->dev, 0);
 
 	return 0;
 }
@@ -404,8 +412,7 @@ static int at91_rtc_resume(struct platfo
 #endif
 
 static struct platform_driver at91_rtc_driver = {
-	.probe		= at91_rtc_probe,
-	.remove		= at91_rtc_remove,
+	.remove		= __exit_p(at91_rtc_remove),
 	.suspend	= at91_rtc_suspend,
 	.resume		= at91_rtc_resume,
 	.driver		= {
@@ -416,7 +423,7 @@ static struct platform_driver at91_rtc_d
 
 static int __init at91_rtc_init(void)
 {
-	return platform_driver_register(&at91_rtc_driver);
+	return platform_driver_probe(&at91_rtc_driver, at91_rtc_probe);
 }
 
 static void __exit at91_rtc_exit(void)
_

Patches currently in -mm which might be from david-b@pacbell.net are

git-avr32.patch
git-md-accel.patch
8250-make-probing-for-txen-bug-a-config-option.patch
