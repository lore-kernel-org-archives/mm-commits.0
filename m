From: akpm@linux-foundation.org
Subject: + workaround-rtc-related-acpi-table-bugs.patch added to -mm tree
Date: Fri, 13 Apr 2007 13:36:49 -0700
Message-ID: <200704132036.l3DKanAk008841@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49991 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030224AbXDMUiL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 16:38:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, lenb@kernel.org


The patch titled
     workaround rtc-related acpi table bugs
has been added to the -mm tree.  Its filename is
     workaround-rtc-related-acpi-table-bugs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 drivers/acpi/glue.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/glue.c~workaround-rtc-related-acpi-table-bugs drivers/acpi/glue.c
--- a/drivers/acpi/glue.c~workaround-rtc-related-acpi-table-bugs
+++ a/drivers/acpi/glue.c
@@ -316,13 +316,19 @@ static int __init acpi_rtc_init(void)
 		rtc_info.wake_on = rtc_wake_on;
 		rtc_info.wake_off = rtc_wake_off;
 
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
 
@@ -331,7 +337,7 @@ static int __init acpi_rtc_init(void)
 
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
doc-gpiotxt-describes-open-drain-emulation.patch
make-proc-acpi-wakeup-more-useful.patch
update-documentation-driver-model-platformtxt.patch
at91_cf-minor-fix.patch
scsi-newstyle-hotplug-coldplug-support.patch
usb-gadget-rndis-fix-struct-rndis_packet_msg_type.patch
blackfin-on-chip-rtc-controller-driver.patch
blackfin-blackfin-on-chip-spi-controller-driver.patch
rework-pm_ops-pm_disk_mode-kill-misuse.patch
power-management-remove-firmware-disk-mode.patch
power-management-implement-pm_opsvalid-for-everybody.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
init-dma-masks-in-pnp_dev.patch
rtc-add-rtc-class-driver-for-the-maxim-max6900.patch
char-cs5535_gpio-add-module_device_table.patch
parport-dev-driver-model-support.patch
parport-dev-driver-model-support-powerpc-fix.patch
layered-parport-code-uses-parport-dev.patch
pnpacpi-sets-pnpdev-devarchdata.patch
pnpacpi-sets-pnpdev-devarchdata-fix.patch
fix-hotplug-for-legacy-platform-drivers.patch
minor-spi_butterfly-cleanup.patch
rtc-remove-sys-class-rtc-dev.patch
rtc-rtc-interfaces-dont-use-class_device.patch
rtc-simplified-rtc-sysfs-attribute-handling.patch
rtc-simplified-proc-driver-rtc-handling.patch
rtc-remove-rest-of-class_device.patch
rtc-suspend-resume-restores-system-clock.patch
rtc-simplified-rtc-sysfs-attribute-handling-tidy.patch
rtc-update-to-class-device-removal-patches.patch
rtc-kconfig-cleanup.patch
rtc-cmos-wakeup-interface.patch
acpi-wakeup-hooks-for-rtc-cmos.patch
workaround-rtc-related-acpi-table-bugs.patch
revert-rtc-add-rtc_merge_alarm.patch
remove-rtc_alm_set-mode-bugs.patch
