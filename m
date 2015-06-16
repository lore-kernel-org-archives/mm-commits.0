From: akpm@linux-foundation.org
Subject: [-] rtc-restore-alarm-after-resume.patch removed from -mm tree
Date: Tue, 16 Jun 2015 13:04:53 -0700
Message-ID: <55808165.hiH35JcNS5jJCs3A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35759 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757204AbbFPUEy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Jun 2015 16:04:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew.garrett@nebula.com, a.zummo@towertech.it, alexandre.belloni@free-electrons.com, gabriele.mzt@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: restore alarm after resume
has been removed from the -mm tree.  Its filename was
     rtc-restore-alarm-after-resume.patch

This patch was dropped because Alexandre is taking care of it

------------------------------------------------------
From: Matthew Garrett <matthew.garrett@nebula.com>
Subject: rtc: restore alarm after resume

Some platform firmware may interfere with the RTC alarm over suspend,
resulting in the kernel and hardware having different ideas about system
state but also potentially causing problems with firmware that assumes the
OS will clean this case up.  This patch saves the RTC alarm state on
suspend and will restore it on resume if the alarm has not yet fired - if
it has, it will clear the RTC alarm.



The case we've seen is Intel Rapid Start, which is a firmware-mediated
feature that automatically transitions systems from suspend-to-RAM to
suspend-to-disk without OS involvement.  It does this by setting the RTC
alarm and a flag that indicates that on wake it should perform the
transition rather than re-starting the OS.  However, if the OS has set a
wakeup alarm that would wake the machine earlier, it refuses to overwrite
it and allows the system to wake instead.

This fails in the following situation:

1) User configures Intel Rapid Start to transition after (say) 15
minutes
2) User suspends to RAM. Firmware sets the wakeup alarm for 15 minutes
in the future
3) User resumes after 5 minutes. Firmware does not reset the alarm, and
as such it is still set for 10 minutes in the future
4) User suspends after 5 minutes. Firmware notices that the alarm is set
for 5 minutes in the future, which is less than the 15 minute transition
threshold. It therefore assumes that the user wants the machine to wake
in 5 minutes
5) System resumes after 5 minutes

The worst case scenario here is that the user may have put the system in a
bag between (4) and (5), resulting in it running in a confined space and
potentially overheating.  This seems reasonably important.  The Rapid
Start support code got added in 3.11, but it can be configured in the
firmware regardless of kernel support.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Tested-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/class.c |   24 ++++++++++++++++++++++++
 include/linux/rtc.h |    4 ++++
 2 files changed, 28 insertions(+)

diff -puN drivers/rtc/class.c~rtc-restore-alarm-after-resume drivers/rtc/class.c
--- a/drivers/rtc/class.c~rtc-restore-alarm-after-resume
+++ a/drivers/rtc/class.c
@@ -61,6 +61,8 @@ static int rtc_suspend(struct device *de
 	if (strcmp(dev_name(&rtc->dev), CONFIG_RTC_HCTOSYS_DEVICE) != 0)
 		return 0;
 
+	rtc->valid_alarm = !rtc_read_alarm(rtc, &rtc->alarm);
+
 	/* snapshot the current RTC and system time at suspend*/
 	err = rtc_read_time(rtc, &tm);
 	if (err < 0) {
@@ -105,6 +107,27 @@ static int rtc_resume(struct device *dev
 	if (timekeeping_rtc_skipresume())
 		return 0;
 
+	/*
+	 * Ensure that the platform hasn't overwritten a pending alarm while
+	 * suspended
+	 */
+	if (rtc->valid_alarm) {
+		long now, scheduled;
+
+		rtc_read_time(rtc, &tm);
+		rtc_tm_to_time(&rtc->alarm.time, &scheduled);
+		rtc_tm_to_time(&tm, &now);
+
+		/* Clear the alarm registers if it went off during suspend */
+		if (scheduled <= now) {
+			rtc_time_to_tm(0, &rtc->alarm.time);
+			rtc->alarm.enabled = 0;
+		}
+
+		if (rtc->ops && rtc->ops->set_alarm)
+			rtc->ops->set_alarm(rtc->dev.parent, &rtc->alarm);
+	}
+
 	rtc_hctosys_ret = -ENODEV;
 	if (strcmp(dev_name(&rtc->dev), CONFIG_RTC_HCTOSYS_DEVICE) != 0)
 		return 0;
@@ -141,6 +164,7 @@ static int rtc_resume(struct device *dev
 	if (sleep_time.tv_sec >= 0)
 		timekeeping_inject_sleeptime64(&sleep_time);
 	rtc_hctosys_ret = 0;
+
 	return 0;
 }
 
diff -puN include/linux/rtc.h~rtc-restore-alarm-after-resume include/linux/rtc.h
--- a/include/linux/rtc.h~rtc-restore-alarm-after-resume
+++ a/include/linux/rtc.h
@@ -134,6 +134,10 @@ struct rtc_device
 	/* Some hardware can't support UIE mode */
 	int uie_unsupported;
 
+#ifdef CONFIG_PM_SLEEP
+	struct rtc_wkalrm alarm;
+	bool valid_alarm;
+#endif
 #ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
 	struct work_struct uie_task;
 	struct timer_list uie_timer;
_

Patches currently in -mm which might be from matthew.garrett@nebula.com are


