From: akpm@osdl.org
Subject: + time-re-add-verify_pmtmr_rate.patch added to -mm tree
Date: Wed, 06 Dec 2006 21:31:09 -0800
Message-ID: <200612070531.kB75V9It031522@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50585 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968821AbWLGFd4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 00:33:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, ak@suse.de, ijc@hellion.org.uk, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org


The patch titled
     time: re-add verify_pmtmr_rate
has been added to the -mm tree.  Its filename is
     time-re-add-verify_pmtmr_rate.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: time: re-add verify_pmtmr_rate
From: john stultz <johnstul@us.ibm.com>

This patch re-adds the verify_pmtmr_rate functionality from 2.6.17 that
I dropped 2.6.18.

This resolves problems seen on older K6 ASUS boards where the ACPI PM
timer runs too fast.

See:
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=211902
http://bugme.osdl.org/show_bug.cgi?id=2375

Thanks to Ian Campbell for re-reporting this and testing the fix!

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Ian Campbell <ijc@hellion.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/clocksource/acpi_pm.c |   36 ++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff -puN drivers/clocksource/acpi_pm.c~time-re-add-verify_pmtmr_rate drivers/clocksource/acpi_pm.c
--- a/drivers/clocksource/acpi_pm.c~time-re-add-verify_pmtmr_rate
+++ a/drivers/clocksource/acpi_pm.c
@@ -142,6 +142,39 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SE
 			acpi_pm_check_graylist);
 #endif
 
+#ifndef CONFIG_X86_64
+#include "mach_timer.h"
+#define PMTMR_EXPECTED_RATE \
+  ((CALIBRATE_LATCH * (PMTMR_TICKS_PER_SEC >> 10)) / (CLOCK_TICK_RATE>>10))
+/*
+ * Some boards have the PMTMR running way too fast. We check
+ * the PMTMR rate against PIT channel 2 to catch these cases.
+ */
+static int verify_pmtmr_rate(void)
+{
+	u32 value1, value2;
+	unsigned long count, delta;
+
+	mach_prepare_counter();
+	value1 = read_pmtmr();
+	mach_countup(&count);
+	value2 = read_pmtmr();
+	delta = (value2 - value1) & ACPI_PM_MASK;
+
+	/* Check that the PMTMR delta is within 5% of what we expect */
+	if (delta < (PMTMR_EXPECTED_RATE * 19) / 20 ||
+	    delta > (PMTMR_EXPECTED_RATE * 21) / 20) {
+		printk(KERN_INFO "PM-Timer running at invalid rate: %lu%% "
+			"of normal - aborting.\n",
+			100UL * delta / PMTMR_EXPECTED_RATE);
+		return -1;
+	}
+
+	return 0;
+}
+#else
+#define verify_pmtmr_rate() (0)
+#endif
 
 static int __init init_acpi_pm_clocksource(void)
 {
@@ -173,6 +206,9 @@ static int __init init_acpi_pm_clocksour
 	return -ENODEV;
 
 pm_good:
+	if (verify_pmtmr_rate() != 0)
+		return -ENODEV;
+
 	return clocksource_register(&clocksource_acpi_pm);
 }
 
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

time-re-add-verify_pmtmr_rate.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
updated-hrtimers-state-tracking.patch
updated-hrtimers-clean-up-callback-tracking.patch
updated-hrtimers-move-and-add-documentation.patch
updated-add-a-framework-to-manage-clock-event-devices.patch
updated-acpi-include-apich.patch
updated-i386-convert-to-clock-event-devices.patch
updated-pm_timer-allow-early-access-and-move-externs-to-a-header-file.patch
updated-high-res-timers-core.patch
updated-gtod-mark-tsc-unusable-for-highres-timers.patch
updated-dynticks-core-code.patch
updated-dyntick-add-nohz-stats-to-proc-stat.patch
updated-dynticks-i386-arch-code.patch
updated-debugging-feature-timer-stats.patch
clockevents-core-check-for-clock-event-device-handler-being-non-null-before-calling-it.patch
clocksource-add-usage-of-config_sysfs.patch
clocksource-small-cleanup-2.patch
clocksource-small-cleanup-2-fix.patch
clocksource-small-acpi_pm-cleanup.patch

