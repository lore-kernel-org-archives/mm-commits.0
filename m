From: akpm@linux-foundation.org
Subject: - rtc-release-correct-region-in-error-path.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:10:10 -0800
Message-ID: <200711152110.lAFLAAFx015529@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57504 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932597AbXKOVSD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:18:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, a.zummo@towertech.it, david-b@pacbell.net, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     rtc: release correct region in error path
has been removed from the -mm tree.  Its filename was
     rtc-release-correct-region-in-error-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc: release correct region in error path
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

The misc_register() error path always released an I/O port region,
even if the region was memory-mapped (only mips uses memory-mapped RTC,
as far as I can see).

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rtc.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff -puN drivers/char/rtc.c~rtc-release-correct-region-in-error-path drivers/char/rtc.c
--- a/drivers/char/rtc.c~rtc-release-correct-region-in-error-path
+++ a/drivers/char/rtc.c
@@ -918,6 +918,14 @@ static const struct file_operations rtc_
 };
 #endif
 
+static void rtc_release_region(void)
+{
+	if (RTC_IOMAPPED)
+		release_region(RTC_PORT(0), RTC_IO_EXTENT);
+	else
+		release_mem_region(RTC_PORT(0), RTC_IO_EXTENT);
+}
+
 static int __init rtc_init(void)
 {
 #ifdef CONFIG_PROC_FS
@@ -992,10 +1000,7 @@ no_irq:
 		/* Yeah right, seeing as irq 8 doesn't even hit the bus. */
 		rtc_has_irq = 0;
 		printk(KERN_ERR "rtc: IRQ %d is not free.\n", RTC_IRQ);
-		if (RTC_IOMAPPED)
-			release_region(RTC_PORT(0), RTC_IO_EXTENT);
-		else
-			release_mem_region(RTC_PORT(0), RTC_IO_EXTENT);
+		rtc_release_region();
 		return -EIO;
 	}
 	hpet_rtc_timer_init();
@@ -1009,7 +1014,7 @@ no_irq:
 		free_irq(RTC_IRQ, NULL);
 		rtc_has_irq = 0;
 #endif
-		release_region(RTC_PORT(0), RTC_IO_EXTENT);
+		rtc_release_region();
 		return -ENODEV;
 	}
 
@@ -1091,10 +1096,7 @@ static void __exit rtc_exit (void)
 	if (rtc_has_irq)
 		free_irq (rtc_irq, &rtc_port);
 #else
-	if (RTC_IOMAPPED)
-		release_region(RTC_PORT(0), RTC_IO_EXTENT);
-	else
-		release_mem_region(RTC_PORT(0), RTC_IO_EXTENT);
+	rtc_release_region();
 #ifdef RTC_IRQ
 	if (rtc_has_irq)
 		free_irq (RTC_IRQ, NULL);
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
export-acpi_check_resource_conflict.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
serial-keep-the-dtr-setting-for-serial-console.patch
rtc-cmos-exports-nvram-in-sysfs.patch
pnp-simplify-pnp_activate_dev-and-pnp_disable_dev-return-values.patch
pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch
dont-touch-fs_struct-in-drivers.patch
