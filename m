From: akpm@linux-foundation.org
Subject: - workaround-rtc-related-acpi-table-bugs.patch removed from -mm tree
Date: Tue, 08 May 2007 19:54:34 -0700
Message-ID: <200705090254.l492sYBS009816@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032368AbXEICz5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:55:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     workaround rtc-related acpi table bugs
has been removed from the -mm tree.  Its filename was
     workaround-rtc-related-acpi-table-bugs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: workaround rtc-related acpi table bugs
From: David Brownell <david-b@pacbell.net>

This works around a bug seen in some RTC-related ACPI table entries, and
tweaks related diagnostics to follow the ACPI convention.

The bug prevents misleading boot-time messages: platforms affected by this
bug wrongly report they can support alarms up to one year in the future,
when in fact the longest alarm is just 24 hours.  That will surprise anyone
trying to use those extended alarms.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/glue.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/glue.c~workaround-rtc-related-acpi-table-bugs drivers/acpi/glue.c
--- a/drivers/acpi/glue.c~workaround-rtc-related-acpi-table-bugs
+++ a/drivers/acpi/glue.c
@@ -316,13 +316,20 @@ static int __init acpi_rtc_init(void)
 		rtc_info.wake_on = rtc_wake_on;
 		rtc_info.wake_off = rtc_wake_off;
 
+		/* workaround bug in some ACPI tables */
+		if (acpi_gbl_FADT.month_alarm && !acpi_gbl_FADT.day_alarm) {
+			DBG("bogus FADT month_alarm\n");
+			acpi_gbl_FADT.month_alarm = 0;
+		}
+
 		rtc_info.rtc_day_alarm = acpi_gbl_FADT.day_alarm;
 		rtc_info.rtc_mon_alarm = acpi_gbl_FADT.month_alarm;
 		rtc_info.rtc_century = acpi_gbl_FADT.century;
 
 		/* NOTE:  S4_RTC_WAKE is NOT currently useful to Linux */
 		if (acpi_gbl_FADT.flags & ACPI_FADT_S4_RTC_WAKE)
-			printk("ACPI: RTC can wake from S4\n");
+			printk(PREFIX "RTC can wake from S4\n");
+
 
 		dev->platform_data = &rtc_info;
 
@@ -331,7 +338,7 @@ static int __init acpi_rtc_init(void)
 
 		put_device(dev);
 	} else
-		pr_debug("ACPI: RTC unavailable?\n");
+		DBG("RTC unavailable?\n");
 	return 0;
 }
 /* do this between RTC subsys_initcall() and rtc_cmos driver_initcall() */
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
acpi-driver-model-flags-and-platform_enable_wake.patch
update-documentation-driver-model-platformtxt.patch
use-common-cpu_is_xxx-macros-on-at91-and-avr32.patch
atmel_spi-remove-unnecessary-and-wrong-ifdefs.patch
