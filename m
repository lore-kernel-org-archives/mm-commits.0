From: akpm@linux-foundation.org
Subject: + rtc-restore-alarm-after-resume.patch added to -mm tree
Date: Mon, 05 Jan 2015 14:41:30 -0800
Message-ID: <54ab131a.o6QwGU2mIYm4JjoP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58552 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbbAEWlb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2015 17:41:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew.garrett@nebula.com, a.zummo@towertech.it, gabriele.mzt@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: restore alarm after resume
has been added to the -mm tree.  Its filename is
     rtc-restore-alarm-after-resume.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-restore-alarm-after-resume.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-restore-alarm-after-resume.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Garrett <matthew.garrett@nebula.com>
Subject: rtc: restore alarm after resume

Some platform firmware may interfere with the RTC alarm over suspend,
resulting in the kernel and hardware having different ideas about system
state but also potentially causing problems with firmware that assumes the
OS will clean this case up.  This patch saves the RTC alarm state on
suspend and will restore it on resume if the alarm has not yet fired - if
it has, it will clear the RTC alarm.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Tested-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/class.c |   24 ++++++++++++++++++++++++
 include/linux/rtc.h |    4 ++++
 2 files changed, 28 insertions(+)

diff -puN drivers/rtc/class.c~rtc-restore-alarm-after-resume drivers/rtc/class.c
--- a/drivers/rtc/class.c~rtc-restore-alarm-after-resume
+++ a/drivers/rtc/class.c
@@ -55,6 +55,8 @@ static int rtc_suspend(struct device *de
 	struct timespec64	delta, delta_delta;
 	int err;
 
+	rtc->valid_alarm = !rtc_read_alarm(rtc, &rtc->alarm);
+
 	if (has_persistent_clock())
 		return 0;
 
@@ -102,6 +104,27 @@ static int rtc_resume(struct device *dev
 	struct timespec64	sleep_time;
 	int err;
 
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
 	if (has_persistent_clock())
 		return 0;
 
@@ -145,6 +168,7 @@ static int rtc_resume(struct device *dev
 	if (sleep_time.tv_sec >= 0)
 		timekeeping_inject_sleeptime64(&sleep_time);
 	rtc_hctosys_ret = 0;
+
 	return 0;
 }
 
diff -puN include/linux/rtc.h~rtc-restore-alarm-after-resume include/linux/rtc.h
--- a/include/linux/rtc.h~rtc-restore-alarm-after-resume
+++ a/include/linux/rtc.h
@@ -133,6 +133,10 @@ struct rtc_device
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

rtc-restore-alarm-after-resume.patch

