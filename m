From: akpm@linux-foundation.org
Subject: - rtc-suspend-resume-restores-system-clock.patch removed from -mm tree
Date: Tue, 08 May 2007 19:54:13 -0700
Message-ID: <200705090254.l492sDKr009780@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032273AbXEICy3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:54:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     rtc: suspend()/resume() restores system clock
has been removed from the -mm tree.  Its filename was
     rtc-suspend-resume-restores-system-clock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc: suspend()/resume() restores system clock
From: David Brownell <david-b@pacbell.net>

RTC class suspend/resume support, re-initializing the system clock on resume
from the clock used to initialize it at boot time.

 - The reinit-on-resume is hooked to the existing RTC_HCTOSYS config
   option, on the grounds that a clock good enough for init must also
   be good enough for re-init.

 - Inlining a version of the code used by ARM, to save and restore the
   delta between a selected RTC and the current system wall-clock time.

 - Removes calls to that ARM code from AT91, OMAP1, and S3C RTCs.  This
   means that systems using those RTCs across suspend/resume will likely
   want to change their kernel configs to enable RTC_HCTOSYS.

   If HCTOSYS isn't using a second RTC (with battery?), this changes the
   system's initial date from Jan 1970 to the epoch this hardware uses:
   1998 for AT91, 2000 for OMAP1 (assuming no split power mode), etc.

This goes on top of the patch series removing "struct class_device" usage
from the RTC framework.  That's all needed for class suspend()/resume().

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Acked-By: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig          |   24 +++++++---
 drivers/rtc/class.c          |   74 +++++++++++++++++++++++++++++++++
 drivers/rtc/rtc-at91rm9200.c |   30 -------------
 drivers/rtc/rtc-omap.c       |   17 -------
 drivers/rtc/rtc-s3c.c        |   22 ---------
 5 files changed, 91 insertions(+), 76 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-suspend-resume-restores-system-clock drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-suspend-resume-restores-system-clock
+++ a/drivers/rtc/Kconfig
@@ -21,21 +21,31 @@ config RTC_CLASS
 	  will be called rtc-class.
 
 config RTC_HCTOSYS
-	bool "Set system time from RTC on startup"
+	bool "Set system time from RTC on startup and resume"
 	depends on RTC_CLASS = y
 	default y
 	help
-	  If you say yes here, the system time will be set using
-	  the value read from the specified RTC device. This is useful
-	  in order to avoid unnecessary fsck runs.
+	  If you say yes here, the system time (wall clock) will be set using
+	  the value read from a specified RTC device. This is useful to avoid
+	  unnecessary fsck runs at boot time, and to network better.
 
 config RTC_HCTOSYS_DEVICE
-	string "The RTC to read the time from"
+	string "RTC used to set the system time"
 	depends on RTC_HCTOSYS = y
 	default "rtc0"
 	help
-	  The RTC device that will be used as the source for
-	  the system time, usually rtc0.
+	  The RTC device that will be used to (re)initialize the system
+	  clock, usually rtc0.  Initialization is done when the system
+	  starts up, and when it resumes from a low power state.
+
+	  This clock should be battery-backed, so that it reads the correct
+	  time when the system boots from a power-off state.  Otherwise, your
+	  system will need an external clock source (like an NTP server).
+
+	  If the clock you specify here is not battery backed, it may still
+	  be useful to reinitialize system time when resuming from system
+	  sleep states.  Do not specify an RTC here unless it stays powered
+	  during all this system's supported sleep states.
 
 config RTC_DEBUG
 	bool "RTC debug support"
diff -puN drivers/rtc/class.c~rtc-suspend-resume-restores-system-clock drivers/rtc/class.c
--- a/drivers/rtc/class.c~rtc-suspend-resume-restores-system-clock
+++ a/drivers/rtc/class.c
@@ -32,6 +32,78 @@ static void rtc_device_release(struct de
 	kfree(rtc);
 }
 
+#if defined(CONFIG_PM) && defined(CONFIG_RTC_HCTOSYS_DEVICE)
+
+/*
+ * On suspend(), measure the delta between one RTC and the
+ * system's wall clock; restore it on resume().
+ */
+
+static struct timespec	delta;
+static time_t		oldtime;
+
+static int rtc_suspend(struct device *dev, pm_message_t mesg)
+{
+	struct rtc_device	*rtc = to_rtc_device(dev);
+	struct rtc_time		tm;
+
+	if (strncmp(rtc->dev.bus_id,
+				CONFIG_RTC_HCTOSYS_DEVICE,
+				BUS_ID_SIZE) != 0)
+		return 0;
+
+	rtc_read_time(rtc, &tm);
+	rtc_tm_to_time(&tm, &oldtime);
+
+	/* RTC precision is 1 second; adjust delta for avg 1/2 sec err */
+	set_normalized_timespec(&delta,
+				xtime.tv_sec - oldtime,
+				xtime.tv_nsec - (NSEC_PER_SEC >> 1));
+
+	return 0;
+}
+
+static int rtc_resume(struct device *dev)
+{
+	struct rtc_device	*rtc = to_rtc_device(dev);
+	struct rtc_time		tm;
+	time_t			newtime;
+	struct timespec		time;
+
+	if (strncmp(rtc->dev.bus_id,
+				CONFIG_RTC_HCTOSYS_DEVICE,
+				BUS_ID_SIZE) != 0)
+		return 0;
+
+	rtc_read_time(rtc, &tm);
+	if (rtc_valid_tm(&tm) != 0) {
+		pr_debug("%s:  bogus resume time\n", rtc->dev.bus_id);
+		return 0;
+	}
+	rtc_tm_to_time(&tm, &newtime);
+	if (newtime <= oldtime) {
+		if (newtime < oldtime)
+			pr_debug("%s:  time travel!\n", rtc->dev.bus_id);
+		return 0;
+	}
+
+	/* restore wall clock using delta against this RTC;
+	 * adjust again for avg 1/2 second RTC sampling error
+	 */
+	set_normalized_timespec(&time,
+				newtime + delta.tv_sec,
+				(NSEC_PER_SEC >> 1) + delta.tv_nsec);
+	do_settimeofday(&time);
+
+	return 0;
+}
+
+#else
+#define rtc_suspend	NULL
+#define rtc_resume	NULL
+#endif
+
+
 /**
  * rtc_device_register - register w/ RTC class
  * @dev: the device to register
@@ -143,6 +215,8 @@ static int __init rtc_init(void)
 		printk(KERN_ERR "%s: couldn't create class\n", __FILE__);
 		return PTR_ERR(rtc_class);
 	}
+	rtc_class->suspend = rtc_suspend;
+	rtc_class->resume = rtc_resume;
 	rtc_dev_init();
 	rtc_sysfs_init(rtc_class);
 	return 0;
diff -puN drivers/rtc/rtc-at91rm9200.c~rtc-suspend-resume-restores-system-clock drivers/rtc/rtc-at91rm9200.c
--- a/drivers/rtc/rtc-at91rm9200.c~rtc-suspend-resume-restores-system-clock
+++ a/drivers/rtc/rtc-at91rm9200.c
@@ -348,21 +348,10 @@ static int __exit at91_rtc_remove(struct
 
 /* AT91RM9200 RTC Power management control */
 
-static struct timespec at91_rtc_delta;
 static u32 at91_rtc_imr;
 
 static int at91_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	struct rtc_time tm;
-	struct timespec time;
-
-	time.tv_nsec = 0;
-
-	/* calculate time delta for suspend */
-	at91_rtc_readtime(&pdev->dev, &tm);
-	rtc_tm_to_time(&tm, &time.tv_sec);
-	save_time_delta(&at91_rtc_delta, &time);
-
 	/* this IRQ is shared with DBGU and other hardware which isn't
 	 * necessarily doing PM like we are...
 	 */
@@ -374,36 +363,17 @@ static int at91_rtc_suspend(struct platf
 		else
 			at91_sys_write(AT91_RTC_IDR, at91_rtc_imr);
 	}
-
-	pr_debug("%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __FUNCTION__,
-		1900 + tm.tm_year, tm.tm_mon, tm.tm_mday,
-		tm.tm_hour, tm.tm_min, tm.tm_sec);
-
 	return 0;
 }
 
 static int at91_rtc_resume(struct platform_device *pdev)
 {
-	struct rtc_time tm;
-	struct timespec time;
-
-	time.tv_nsec = 0;
-
-	at91_rtc_readtime(&pdev->dev, &tm);
-	rtc_tm_to_time(&tm, &time.tv_sec);
-	restore_time_delta(&at91_rtc_delta, &time);
-
 	if (at91_rtc_imr) {
 		if (device_may_wakeup(&pdev->dev))
 			disable_irq_wake(AT91_ID_SYS);
 		else
 			at91_sys_write(AT91_RTC_IER, at91_rtc_imr);
 	}
-
-	pr_debug("%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __FUNCTION__,
-		1900 + tm.tm_year, tm.tm_mon, tm.tm_mday,
-		tm.tm_hour, tm.tm_min, tm.tm_sec);
-
 	return 0;
 }
 #else
diff -puN drivers/rtc/rtc-omap.c~rtc-suspend-resume-restores-system-clock drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-suspend-resume-restores-system-clock
+++ a/drivers/rtc/rtc-omap.c
@@ -488,19 +488,10 @@ static int __devexit omap_rtc_remove(str
 
 #ifdef CONFIG_PM
 
-static struct timespec rtc_delta;
 static u8 irqstat;
 
 static int omap_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	struct rtc_time rtc_tm;
-	struct timespec time;
-
-	time.tv_nsec = 0;
-	omap_rtc_read_time(NULL, &rtc_tm);
-	rtc_tm_to_time(&rtc_tm, &time.tv_sec);
-
-	save_time_delta(&rtc_delta, &time);
 	irqstat = rtc_read(OMAP_RTC_INTERRUPTS_REG);
 
 	/* FIXME the RTC alarm is not currently acting as a wakeup event
@@ -517,14 +508,6 @@ static int omap_rtc_suspend(struct platf
 
 static int omap_rtc_resume(struct platform_device *pdev)
 {
-	struct rtc_time rtc_tm;
-	struct timespec time;
-
-	time.tv_nsec = 0;
-	omap_rtc_read_time(NULL, &rtc_tm);
-	rtc_tm_to_time(&rtc_tm, &time.tv_sec);
-
-	restore_time_delta(&rtc_delta, &time);
 	if (device_may_wakeup(&pdev->dev))
 		disable_irq_wake(omap_rtc_alarm);
 	else
diff -puN drivers/rtc/rtc-s3c.c~rtc-suspend-resume-restores-system-clock drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-suspend-resume-restores-system-clock
+++ a/drivers/rtc/rtc-s3c.c
@@ -548,37 +548,15 @@ static int ticnt_save;
 
 static int s3c_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	struct rtc_time tm;
-	struct timespec time;
-
-	time.tv_nsec = 0;
-
 	/* save TICNT for anyone using periodic interrupts */
-
 	ticnt_save = readb(s3c_rtc_base + S3C2410_TICNT);
-
-	/* calculate time delta for suspend */
-
-	s3c_rtc_gettime(&pdev->dev, &tm);
-	rtc_tm_to_time(&tm, &time.tv_sec);
-	save_time_delta(&s3c_rtc_delta, &time);
 	s3c_rtc_enable(pdev, 0);
-
 	return 0;
 }
 
 static int s3c_rtc_resume(struct platform_device *pdev)
 {
-	struct rtc_time tm;
-	struct timespec time;
-
-	time.tv_nsec = 0;
-
 	s3c_rtc_enable(pdev, 1);
-	s3c_rtc_gettime(&pdev->dev, &tm);
-	rtc_tm_to_time(&tm, &time.tv_sec);
-	restore_time_delta(&s3c_rtc_delta, &time);
-
 	writeb(ticnt_save, s3c_rtc_base + S3C2410_TICNT);
 	return 0;
 }
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
acpi-driver-model-flags-and-platform_enable_wake.patch
update-documentation-driver-model-platformtxt.patch
use-common-cpu_is_xxx-macros-on-at91-and-avr32.patch
atmel_spi-remove-unnecessary-and-wrong-ifdefs.patch
