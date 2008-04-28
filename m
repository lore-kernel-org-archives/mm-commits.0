From: akpm@linux-foundation.org
Subject: - rtc-add-the-support-for-alarm-time-relative-to-current-time-in-sysfs.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:50:22 -0700
Message-ID: <200804282150.m3SLoMW1017468@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934590AbYD1Vul (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:50:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yakui.zhao@intel.com, a.zummo@towertech.it, dbrownell@users.sourceforge.net, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     rtc: add the support for alarm time relative to current time in sysfs
has been removed from the -mm tree.  Its filename was
     rtc-add-the-support-for-alarm-time-relative-to-current-time-in-sysfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: add the support for alarm time relative to current time in sysfs
From: Zhao Yakui <yakui.zhao@intel.com>

In current kernel if we want to set the alarm time, the absolute time the
seconds relative to 1970-01-01 00:00:00) should be written into
/sys/class/rtc/rtc0/wakealarm.  It is not convenient.

It is more reasonable to add the support for the alarm time relative to
current RTC time.(the unit is second)

For example:
If the RTC is required to generate alarm after 2 minutes, the following
will be OK.
	echo +120 > /sys/class/rtc/rtc0/wakealarm
or      echo +0x78 > /sys/class/rtc/rtc0/wakealarm

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-sysfs.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-sysfs.c~rtc-add-the-support-for-alarm-time-relative-to-current-time-in-sysfs drivers/rtc/rtc-sysfs.c
--- a/drivers/rtc/rtc-sysfs.c~rtc-add-the-support-for-alarm-time-relative-to-current-time-in-sysfs
+++ a/drivers/rtc/rtc-sysfs.c
@@ -145,6 +145,8 @@ rtc_sysfs_set_wakealarm(struct device *d
 	unsigned long now, alarm;
 	struct rtc_wkalrm alm;
 	struct rtc_device *rtc = to_rtc_device(dev);
+	char *buf_ptr;
+	int adjust = 0;
 
 	/* Only request alarms that trigger in the future.  Disable them
 	 * by writing another time, e.g. 0 meaning Jan 1 1970 UTC.
@@ -154,7 +156,15 @@ rtc_sysfs_set_wakealarm(struct device *d
 		return retval;
 	rtc_tm_to_time(&alm.time, &now);
 
-	alarm = simple_strtoul(buf, NULL, 0);
+	buf_ptr = (char *)buf;
+	if (*buf_ptr == '+') {
+		buf_ptr++;
+		adjust = 1;
+	}
+	alarm = simple_strtoul(buf_ptr, NULL, 0);
+	if (adjust) {
+		alarm += now;
+	}
 	if (alarm > now) {
 		/* Avoid accidentally clobbering active alarms; we can't
 		 * entirely prevent that here, without even the minimal
_

Patches currently in -mm which might be from yakui.zhao@intel.com are

origin.patch
git-acpi.patch
acpi-check-a-return-value-correctly-in-acpi_power_get_context.patch

