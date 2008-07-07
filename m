From: akpm@linux-foundation.org
Subject: - rtc-fix-cmos-time-error-after-writing-proc-acpi-alarm.patch removed from -mm tree
Date: Sun, 06 Jul 2008 19:58:15 -0700
Message-ID: <200807070258.m672wFtM004429@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34909 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751562AbYGGDBc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 23:01:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: huacai.chen@intel.com, a.zummo@towertech.it, lenb@kernel.org, pavel@suse.cz, yakui.zhao@intel.com, mm-commits@vger.kernel.org


The patch titled
     rtc: fix CMOS time error after writing /proc/acpi/alarm
has been removed from the -mm tree.  Its filename was
     rtc-fix-cmos-time-error-after-writing-proc-acpi-alarm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: fix CMOS time error after writing /proc/acpi/alarm
From: Huacai Chen <huacai.chen@intel.com>

When writing /proc/acpi/alarm in adjust mode, e.g.
	echo "+0000-00-00 00:00:15" >/proc/acpi/alarm
The "century" field should be read and added to "year" field before
writing, otherwise the CMOS time will go back to 2000 years ago, e.g.
	# cat /proc/acpi/alarm
	0008-06-21 11:38:46
Then the system time may be reset to the date of manufacture after
rebooting. This patch fixed this issue.

Signed-off-by: Huacai Chen <huacai.chen@intel.com>
Acked-by: Pavel Machek <pavel@suse.cz>
Acked-by: Zhao Yakui <yakui.zhao@intel.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Acked-by: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep/proc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/acpi/sleep/proc.c~rtc-fix-cmos-time-error-after-writing-proc-acpi-alarm drivers/acpi/sleep/proc.c
--- a/drivers/acpi/sleep/proc.c~rtc-fix-cmos-time-error-after-writing-proc-acpi-alarm
+++ a/drivers/acpi/sleep/proc.c
@@ -315,8 +315,11 @@ acpi_system_write_alarm(struct file *fil
 		cmos_bcd_write(day, acpi_gbl_FADT.day_alarm, rtc_control);
 	if (acpi_gbl_FADT.month_alarm)
 		cmos_bcd_write(mo, acpi_gbl_FADT.month_alarm, rtc_control);
-	if (acpi_gbl_FADT.century)
+	if (acpi_gbl_FADT.century) {
+		if (adjust)
+			yr += cmos_bcd_read(acpi_gbl_FADT.century, rtc_control) * 100;
 		cmos_bcd_write(yr / 100, acpi_gbl_FADT.century, rtc_control);
+	}
 	/* enable the rtc alarm interrupt */
 	rtc_control |= RTC_AIE;
 	CMOS_WRITE(rtc_control, RTC_CONTROL);
_

Patches currently in -mm which might be from huacai.chen@intel.com are

linux-next.patch

