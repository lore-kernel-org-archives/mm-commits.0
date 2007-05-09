From: akpm@linux-foundation.org
Subject: - acpi-wakeup-hooks-for-rtc-cmos.patch removed from -mm tree
Date: Tue, 08 May 2007 19:54:32 -0700
Message-ID: <200705090254.l492sWoX009813@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032367AbXEICz7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:55:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     ACPI wakeup hooks for rtc-cmos
has been removed from the -mm tree.  Its filename was
     acpi-wakeup-hooks-for-rtc-cmos.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ACPI wakeup hooks for rtc-cmos
From: David Brownell <david-b@pacbell.net>

Remove /proc/acpi/alarm file when the rtc-cmos "wakealarm" file is available.
Instead, provide hooks that rtc-cmos will use.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/glue.c       |   37 +++++++++++++++++++++++++++++++++++-
 drivers/acpi/sleep/proc.c |   19 ++++++++++++++++--
 2 files changed, 53 insertions(+), 3 deletions(-)

diff -puN drivers/acpi/glue.c~acpi-wakeup-hooks-for-rtc-cmos drivers/acpi/glue.c
--- a/drivers/acpi/glue.c~acpi-wakeup-hooks-for-rtc-cmos
+++ a/drivers/acpi/glue.c
@@ -245,6 +245,35 @@ arch_initcall(init_acpi_device_notify);
 
 #if defined(CONFIG_RTC_DRV_CMOS) || defined(CONFIG_RTC_DRV_CMOS_MODULE)
 
+#ifdef CONFIG_PM
+static u32 rtc_handler(void *context)
+{
+	acpi_clear_event(ACPI_EVENT_RTC);
+	acpi_disable_event(ACPI_EVENT_RTC, 0);
+	return ACPI_INTERRUPT_HANDLED;
+}
+
+static inline void rtc_wake_setup(void)
+{
+	acpi_install_fixed_event_handler(ACPI_EVENT_RTC, rtc_handler, NULL);
+}
+
+static void rtc_wake_on(struct device *dev)
+{
+	acpi_clear_event(ACPI_EVENT_RTC);
+	acpi_enable_event(ACPI_EVENT_RTC, 0);
+}
+
+static void rtc_wake_off(struct device *dev)
+{
+	acpi_disable_event(ACPI_EVENT_RTC, 0);
+}
+#else
+#define rtc_wake_setup()	do{}while(0)
+#define rtc_wake_on		NULL
+#define rtc_wake_off		NULL
+#endif
+
 /* Every ACPI platform has a mc146818 compatible "cmos rtc".  Here we find
  * its device node and pass extra config data.  This helps its driver use
  * capabilities that the now-obsolete mc146818 didn't have, and informs it
@@ -283,11 +312,17 @@ static int __init acpi_rtc_init(void)
 	struct device *dev = get_rtc_dev();
 
 	if (dev) {
+		rtc_wake_setup();
+		rtc_info.wake_on = rtc_wake_on;
+		rtc_info.wake_off = rtc_wake_off;
+
 		rtc_info.rtc_day_alarm = acpi_gbl_FADT.day_alarm;
 		rtc_info.rtc_mon_alarm = acpi_gbl_FADT.month_alarm;
 		rtc_info.rtc_century = acpi_gbl_FADT.century;
 
-		/* NOTE:  acpi_gbl_FADT->rtcs4 is NOT currently useful */
+		/* NOTE:  S4_RTC_WAKE is NOT currently useful to Linux */
+		if (acpi_gbl_FADT.flags & ACPI_FADT_S4_RTC_WAKE)
+			printk("ACPI: RTC can wake from S4\n");
 
 		dev->platform_data = &rtc_info;
 
diff -puN drivers/acpi/sleep/proc.c~acpi-wakeup-hooks-for-rtc-cmos drivers/acpi/sleep/proc.c
--- a/drivers/acpi/sleep/proc.c~acpi-wakeup-hooks-for-rtc-cmos
+++ a/drivers/acpi/sleep/proc.c
@@ -70,6 +70,14 @@ acpi_system_write_sleep(struct file *fil
 }
 #endif				/* CONFIG_ACPI_SLEEP_PROC_SLEEP */
 
+#if defined(CONFIG_RTC_DRV_CMOS) || defined(CONFIG_RTC_DRV_CMOS_MODULE)
+/* use /sys/class/rtc/rtcX/wakealarm instead; it's not ACPI-specific */
+#else
+#define	HAVE_ACPI_LEGACY_ALARM
+#endif
+
+#ifdef	HAVE_ACPI_LEGACY_ALARM
+
 static int acpi_system_alarm_seq_show(struct seq_file *seq, void *offset)
 {
 	u32 sec, min, hr;
@@ -341,6 +349,8 @@ acpi_system_write_alarm(struct file *fil
       end:
 	return_VALUE(result ? result : count);
 }
+#endif	/* HAVE_ACPI_LEGACY_ALARM */
+
 
 extern struct list_head acpi_wakeup_device_list;
 extern spinlock_t acpi_device_lock;
@@ -464,6 +474,7 @@ static const struct file_operations acpi
 };
 #endif				/* CONFIG_ACPI_SLEEP_PROC_SLEEP */
 
+#ifdef	HAVE_ACPI_LEGACY_ALARM
 static const struct file_operations acpi_system_alarm_fops = {
 	.open = acpi_system_alarm_open_fs,
 	.read = seq_read,
@@ -479,8 +490,9 @@ static u32 rtc_handler(void *context)
 
 	return ACPI_INTERRUPT_HANDLED;
 }
+#endif	/* HAVE_ACPI_LEGACY_ALARM */
 
-static int acpi_sleep_proc_init(void)
+static int __init acpi_sleep_proc_init(void)
 {
 	struct proc_dir_entry *entry = NULL;
 
@@ -496,6 +508,7 @@ static int acpi_sleep_proc_init(void)
 		entry->proc_fops = &acpi_system_sleep_fops;
 #endif
 
+#ifdef	HAVE_ACPI_LEGACY_ALARM
 	/* 'alarm' [R/W] */
 	entry =
 	    create_proc_entry("alarm", S_IFREG | S_IRUGO | S_IWUSR,
@@ -503,6 +516,9 @@ static int acpi_sleep_proc_init(void)
 	if (entry)
 		entry->proc_fops = &acpi_system_alarm_fops;
 
+	acpi_install_fixed_event_handler(ACPI_EVENT_RTC, rtc_handler, NULL);
+#endif	/* HAVE_ACPI_LEGACY_ALARM */
+
 	/* 'wakeup device' [R/W] */
 	entry =
 	    create_proc_entry("wakeup", S_IFREG | S_IRUGO | S_IWUSR,
@@ -510,7 +526,6 @@ static int acpi_sleep_proc_init(void)
 	if (entry)
 		entry->proc_fops = &acpi_system_wakeup_device_fops;
 
-	acpi_install_fixed_event_handler(ACPI_EVENT_RTC, rtc_handler, NULL);
 	return 0;
 }
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
acpi-driver-model-flags-and-platform_enable_wake.patch
update-documentation-driver-model-platformtxt.patch
use-common-cpu_is_xxx-macros-on-at91-and-avr32.patch
atmel_spi-remove-unnecessary-and-wrong-ifdefs.patch
