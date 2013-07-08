From: akpm@linux-foundation.org
Subject: [merged]
 rtc-add-ability-to-push-out-an-existing-wakealarm-using-sysfs.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:33:18 -0700
Message-ID: <51db13fe.5MTaDuC8iAiT4RQy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51210 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab3GHTdT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:33:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rjw@sisk.pl, dianders@chromium.org, a.zummo@towertech.it, bhthompson@chromium.org

Subject: [merged] rtc-add-ability-to-push-out-an-existing-wakealarm-using-sysfs.patch removed from -mm tree
To: bhthompson@chromium.org,a.zummo@towertech.it,dianders@chromium.org,rjw@sisk.pl,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:33:18 -0700


The patch titled
     Subject: rtc: add ability to push out an existing wakealarm using sysfs
has been removed from the -mm tree.  Its filename was
     rtc-add-ability-to-push-out-an-existing-wakealarm-using-sysfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bernie Thompson <bhthompson@chromium.org>
Subject: rtc: add ability to push out an existing wakealarm using sysfs

This adds the ability for the rtc sysfs code to handle += characters at
the beginning of a wakealarm setting string.  This will allow the user to
attempt to push out an existing wakealarm by a provided amount.

In the case that the += characters are provided but the alarm is not
active -EINVAL is returned.

his is useful, at least for my purposes in suspend/resume testing.  The
basic test goes something like:

1. Set a wake alarm from userspace 5 seconds in the future

2. Start the suspend process (echo mem > /sys/power/state)

3. After ~2.5 seconds if userspace is still running (using another
   thread to check this), move the wake alarm 5 more seconds

If the "move" involves an unset of the wakealarm then there's a period
   of time where the system is midway through suspending but has no wake
   alarm.  It will get stuck.

We'd rather not remove the "move" since the idea is to avoid a
cancelled suspend when the alarm fires _during_ suspend.  It is
difficult for the test to tell the difference between a suspend that
was cancelled because the alarm fired too early and a suspend that was

Signed-off-by: Bernie Thompson <bhthompson@chromium.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Doug Anderson <dianders@chromium.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/rtc.txt   |    7 ++++---
 drivers/rtc/rtc-sysfs.c |   20 +++++++++++++++-----
 2 files changed, 19 insertions(+), 8 deletions(-)

diff -puN Documentation/rtc.txt~rtc-add-ability-to-push-out-an-existing-wakealarm-using-sysfs Documentation/rtc.txt
--- a/Documentation/rtc.txt~rtc-add-ability-to-push-out-an-existing-wakealarm-using-sysfs
+++ a/Documentation/rtc.txt
@@ -153,9 +153,10 @@ since_epoch:	 The number of seconds sinc
 time:		 RTC-provided time
 wakealarm:	 The time at which the clock will generate a system wakeup
 		 event. This is a one shot wakeup event, so must be reset
-		 after wake if a daily wakeup is required. Format is either
-		 seconds since the epoch or, if there's a leading +, seconds
-		 in the future.
+		 after wake if a daily wakeup is required. Format is seconds since
+		 the epoch by default, or if there's a leading +, seconds in the
+		 future, or if there is a leading +=, seconds ahead of the current
+		 alarm.
 
 IOCTL INTERFACE
 ---------------
diff -puN drivers/rtc/rtc-sysfs.c~rtc-add-ability-to-push-out-an-existing-wakealarm-using-sysfs drivers/rtc/rtc-sysfs.c
--- a/drivers/rtc/rtc-sysfs.c~rtc-add-ability-to-push-out-an-existing-wakealarm-using-sysfs
+++ a/drivers/rtc/rtc-sysfs.c
@@ -164,6 +164,7 @@ rtc_sysfs_set_wakealarm(struct device *d
 {
 	ssize_t retval;
 	unsigned long now, alarm;
+	unsigned long push = 0;
 	struct rtc_wkalrm alm;
 	struct rtc_device *rtc = to_rtc_device(dev);
 	char *buf_ptr;
@@ -180,13 +181,17 @@ rtc_sysfs_set_wakealarm(struct device *d
 	buf_ptr = (char *)buf;
 	if (*buf_ptr == '+') {
 		buf_ptr++;
-		adjust = 1;
+		if (*buf_ptr == '=') {
+			buf_ptr++;
+			push = 1;
+		} else
+			adjust = 1;
 	}
 	alarm = simple_strtoul(buf_ptr, NULL, 0);
 	if (adjust) {
 		alarm += now;
 	}
-	if (alarm > now) {
+	if (alarm > now || push) {
 		/* Avoid accidentally clobbering active alarms; we can't
 		 * entirely prevent that here, without even the minimal
 		 * locking from the /dev/rtcN api.
@@ -194,9 +199,14 @@ rtc_sysfs_set_wakealarm(struct device *d
 		retval = rtc_read_alarm(rtc, &alm);
 		if (retval < 0)
 			return retval;
-		if (alm.enabled)
-			return -EBUSY;
