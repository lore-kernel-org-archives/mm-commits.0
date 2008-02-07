From: akpm@linux-foundation.org
Subject: - rtc-cmos-alarm-acts-as-oneshot.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:27:15 -0800
Message-ID: <200802070026.m170QuXC006970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50425 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933243AbYBGApq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     rtc-cmos alarm acts as oneshot
has been removed from the -mm tree.  Its filename was
     rtc-cmos-alarm-acts-as-oneshot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-cmos alarm acts as oneshot
From: David Brownell <david-b@pacbell.net>

Start making the rtc-cmos alarm act more like a oneshot alarm by disabling
that alarm after its IRQ fires.  (ACPI hooks are also needed.)

The Linux RTC framework has previously been a bit vague in this area, but
any other behavior is problematic and not very portable.  RTCs with full
YYYY-MM-DD HH:MM[:SS] alarms won't have a problem here.  Only ones with
partial match criteria, with the most visible example being the PC RTC, get
confused.  (Because the criteria will match repeatedly.)

Update comments relating to that oneshot behavior and timezone handling. 
(Timezones are another issue that's mostly visible with rtc-cmos.  That's
because PCs often dual-boot MS-Windows, which likes its RTC to match local
wall-clock time instead of UTC.)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c  |   14 +++++++++++++-
 drivers/rtc/rtc-dev.c   |    9 +++++++++
 drivers/rtc/rtc-sysfs.c |   19 +++++++++++++------
 3 files changed, 35 insertions(+), 7 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~rtc-cmos-alarm-acts-as-oneshot drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-cmos-alarm-acts-as-oneshot
+++ a/drivers/rtc/rtc-cmos.c
@@ -472,10 +472,22 @@ static struct cmos_rtc	cmos_rtc;
 static irqreturn_t cmos_interrupt(int irq, void *p)
 {
 	u8		irqstat;
+	u8		rtc_control;
 
 	spin_lock(&rtc_lock);
 	irqstat = CMOS_READ(RTC_INTR_FLAGS);
-	irqstat &= (CMOS_READ(RTC_CONTROL) & RTC_IRQMASK) | RTC_IRQF;
+	rtc_control = CMOS_READ(RTC_CONTROL);
+	irqstat &= (rtc_control & RTC_IRQMASK) | RTC_IRQF;
+
+	/* All Linux RTC alarms should be treated as if they were oneshot.
+	 * Similar code may be needed in system wakeup paths, in case the
+	 * alarm woke the system.
+	 */
+	if (irqstat & RTC_AIE) {
+		rtc_control &= ~RTC_AIE;
+		CMOS_WRITE(rtc_control, RTC_CONTROL);
+		CMOS_READ(RTC_INTR_FLAGS);
+	}
 	spin_unlock(&rtc_lock);
 
 	if (is_intr(irqstat)) {
diff -puN drivers/rtc/rtc-dev.c~rtc-cmos-alarm-acts-as-oneshot drivers/rtc/rtc-dev.c
--- a/drivers/rtc/rtc-dev.c~rtc-cmos-alarm-acts-as-oneshot
+++ a/drivers/rtc/rtc-dev.c
@@ -246,6 +246,15 @@ static int rtc_dev_ioctl(struct inode *i
 	/* if the driver does not provide the ioctl interface
 	 * or if that particular ioctl was not implemented
 	 * (-ENOIOCTLCMD), we will try to emulate here.
+	 *
+	 * Drivers *SHOULD NOT* provide ioctl implementations
+	 * for these requests.  Instead, provide methods to
+	 * support the following code, so that the RTC's main
+	 * features are accessible without using ioctls.
+	 *
+	 * RTC and alarm times will be in UTC, by preference,
+	 * but dual-booting with MS-Windows implies RTCs must
+	 * use the local wall clock time.
 	 */
 
 	switch (cmd) {
diff -puN drivers/rtc/rtc-sysfs.c~rtc-cmos-alarm-acts-as-oneshot drivers/rtc/rtc-sysfs.c
--- a/drivers/rtc/rtc-sysfs.c~rtc-cmos-alarm-acts-as-oneshot
+++ a/drivers/rtc/rtc-sysfs.c
@@ -17,6 +17,13 @@
 
 /* device attributes */
 
+/*
+ * NOTE:  RTC times displayed in sysfs use the RTC's timezone.  That's
+ * ideally UTC.  However, PCs that also boot to MS-Windows normally use
+ * the local time and change to match daylight savings time.  That affects
+ * attributes including date, time, since_epoch, and wakealarm.
+ */
+
 static ssize_t
 rtc_sysfs_show_name(struct device *dev, struct device_attribute *attr,
 		char *buf)
@@ -113,13 +120,13 @@ rtc_sysfs_show_wakealarm(struct device *
 	unsigned long alarm;
 	struct rtc_wkalrm alm;
 
-	/* Don't show disabled alarms; but the RTC could leave the
-	 * alarm enabled after it's already triggered.  Alarms are
-	 * conceptually one-shot, even though some common hardware
-	 * (PCs) doesn't actually work that way.
+	/* Don't show disabled alarms.  For uniformity, RTC alarms are
+	 * conceptually one-shot, even though some common RTCs (on PCs)
+	 * don't actually work that way.
 	 *
-	 * REVISIT maybe we should require RTC implementations to
-	 * disable the RTC alarm after it triggers, for uniformity.
+	 * NOTE: RTC implementations where the alarm doesn't match an
+	 * exact YYYY-MM-DD HH:MM[:SS] date *must* disable their RTC
+	 * alarms after they trigger, to ensure one-shot semantics.
 	 */
 	retval = rtc_read_alarm(to_rtc_device(dev), &alm);
 	if (retval == 0 && alm.enabled) {
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
at91-correct-at91sam9263ek-lcd-power-gpio-pin.patch
i2c-isp1301_omap-new-style-i2c-driver-updates-part-1.patch
git-input.patch
git-mmc.patch
git-mtd.patch
basic-pwm-driver-for-avr32-and-at91.patch
basic-pwm-driver-for-avr32-and-at91-fix.patch
pwm-led-driver.patch
