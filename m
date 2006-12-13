From: akpm@osdl.org
Subject: + rtc-framework-rtc_wkalrmenabled-reporting-updates.patch added to -mm tree
Date: Tue, 12 Dec 2006 17:31:04 -0800
Message-ID: <200612130131.kBD1V4d4023966@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37978 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587AbWLMBbV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Dec 2006 20:31:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net


The patch titled
     rtc framewok: rtc_wkalrm.enabled reporting updates
has been added to the -mm tree.  Its filename is
     rtc-framework-rtc_wkalrmenabled-reporting-updates.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rtc framewok: rtc_wkalrm.enabled reporting updates
From: David Brownell <david-b@pacbell.net>

Fix a glitch in the procfs dumping of whether the alarm IRQ is enabled: use
the traditional name (from drivers/char/rtc.c and many other places) of
"alarm_IRQ", not "alrm_wakeup" (which didn't even match the efirtc code, which
originated that reporting API).

Also, update a few of the RTC drivers to stop providing that duplicate status,
and/or to expose it properly when reporting the alarm state.  We really don't
want every RTC driver doing their own thing here...

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/rtc/rtc-at91rm9200.c |    5 +++--
 drivers/rtc/rtc-omap.c       |    3 +--
 drivers/rtc/rtc-proc.c       |    2 +-
 drivers/rtc/rtc-s3c.c        |    6 ++----
 drivers/rtc/rtc-sa1100.c     |    4 +---
 5 files changed, 8 insertions(+), 12 deletions(-)

diff -puN drivers/rtc/rtc-at91rm9200.c~rtc-framework-rtc_wkalrmenabled-reporting-updates drivers/rtc/rtc-at91rm9200.c
--- a/drivers/rtc/rtc-at91rm9200.c~rtc-framework-rtc_wkalrmenabled-reporting-updates
+++ a/drivers/rtc/rtc-at91rm9200.c
@@ -137,6 +137,9 @@ static int at91_rtc_readalarm(struct dev
 	tm->tm_yday = rtc_year_days(tm->tm_mday, tm->tm_mon, tm->tm_year);
 	tm->tm_year = at91_alarm_year - 1900;
 
+	alrm->enabled = (at91_sys_read(AT91_RTC_IMR) & AT91_RTC_ALARM)
+			? 1 : 0;
+
 	pr_debug("%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __FUNCTION__,
 		1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
 		tm->tm_hour, tm->tm_min, tm->tm_sec);
@@ -223,8 +226,6 @@ static int at91_rtc_proc(struct device *
 {
 	unsigned long imr = at91_sys_read(AT91_RTC_IMR);
 
-	seq_printf(seq, "alarm_IRQ\t: %s\n",
-			(imr & AT91_RTC_ALARM) ? "yes" : "no");
 	seq_printf(seq, "update_IRQ\t: %s\n",
 			(imr & AT91_RTC_ACKUPD) ? "yes" : "no");
 	seq_printf(seq, "periodic_IRQ\t: %s\n",
diff -puN drivers/rtc/rtc-omap.c~rtc-framework-rtc_wkalrmenabled-reporting-updates drivers/rtc/rtc-omap.c
--- a/drivers/rtc/rtc-omap.c~rtc-framework-rtc_wkalrmenabled-reporting-updates
+++ a/drivers/rtc/rtc-omap.c
@@ -279,9 +279,8 @@ static int omap_rtc_read_alarm(struct de
 	local_irq_enable();
 
 	bcd2tm(&alm->time);
-	alm->pending = !!(rtc_read(OMAP_RTC_INTERRUPTS_REG)
+	alm->enabled = !!(rtc_read(OMAP_RTC_INTERRUPTS_REG)
 			& OMAP_RTC_INTERRUPTS_IT_ALARM);
-	alm->enabled = alm->pending && device_may_wakeup(dev);
 
 	return 0;
 }
diff -puN drivers/rtc/rtc-proc.c~rtc-framework-rtc_wkalrmenabled-reporting-updates drivers/rtc/rtc-proc.c
--- a/drivers/rtc/rtc-proc.c~rtc-framework-rtc_wkalrmenabled-reporting-updates
+++ a/drivers/rtc/rtc-proc.c
@@ -65,7 +65,7 @@ static int rtc_proc_show(struct seq_file
 			seq_printf(seq, "%02d\n", alrm.time.tm_mday);
 		else
 			seq_printf(seq, "**\n");
-		seq_printf(seq, "alrm_wakeup\t: %s\n",
+		seq_printf(seq, "alarm_IRQ\t: %s\n",
 				alrm.enabled ? "yes" : "no");
 		seq_printf(seq, "alrm_pending\t: %s\n",
 				alrm.pending ? "yes" : "no");
diff -puN drivers/rtc/rtc-s3c.c~rtc-framework-rtc_wkalrmenabled-reporting-updates drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-framework-rtc_wkalrmenabled-reporting-updates
+++ a/drivers/rtc/rtc-s3c.c
@@ -191,6 +191,8 @@ static int s3c_rtc_getalarm(struct devic
 
 	alm_en = readb(base + S3C2410_RTCALM);
 
+	alrm->enabled = (alm_en & S3C2410_RTCALM_ALMEN) ? 1 : 0;
+
 	pr_debug("read alarm %02x %02x.%02x.%02x %02x/%02x/%02x\n",
 		 alm_en,
 		 alm_tm->tm_year, alm_tm->tm_mon, alm_tm->tm_mday,
@@ -331,12 +333,8 @@ static int s3c_rtc_ioctl(struct device *
 
 static int s3c_rtc_proc(struct device *dev, struct seq_file *seq)
 {
-	unsigned int rtcalm = readb(s3c_rtc_base + S3C2410_RTCALM);
 	unsigned int ticnt = readb(s3c_rtc_base + S3C2410_TICNT);
 
-	seq_printf(seq, "alarm_IRQ\t: %s\n",
-		   (rtcalm & S3C2410_RTCALM_ALMEN) ? "yes" : "no" );
-
 	seq_printf(seq, "periodic_IRQ\t: %s\n",
 		     (ticnt & S3C2410_TICNT_ENABLE) ? "yes" : "no" );
 
diff -puN drivers/rtc/rtc-sa1100.c~rtc-framework-rtc_wkalrmenabled-reporting-updates drivers/rtc/rtc-sa1100.c
--- a/drivers/rtc/rtc-sa1100.c~rtc-framework-rtc_wkalrmenabled-reporting-updates
+++ a/drivers/rtc/rtc-sa1100.c
@@ -289,9 +289,7 @@ static int sa1100_rtc_set_alarm(struct d
 
 static int sa1100_rtc_proc(struct device *dev, struct seq_file *seq)
 {
-	seq_printf(seq, "trim/divider\t: 0x%08lx\n", RTTR);
-	seq_printf(seq, "alarm_IRQ\t: %s\n",
-			(RTSR & RTSR_ALE) ? "yes" : "no" );
+	seq_printf(seq, "trim/divider\t: 0x%08x\n", (u32) RTTR);
 	seq_printf(seq, "update_IRQ\t: %s\n",
 			(RTSR & RTSR_HZE) ? "yes" : "no");
 	seq_printf(seq, "periodic_IRQ\t: %s\n",
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
fix-more-workqueue-build-breakage-tps65010.patch
another-build-fix-header-rearrangements-osk.patch
watchdog-omap_wdt-build-fix.patch
rtc-remove-syslog-spam-on-registration.patch
rtc-framework-rtc_wkalrmenabled-reporting-updates.patch

