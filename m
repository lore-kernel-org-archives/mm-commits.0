From: akpm@linux-foundation.org
Subject: + rtc-release-correct-region-in-error-path.patch added to -mm tree
Date: Wed, 24 Oct 2007 16:06:58 -0700
Message-ID: <200710242306.l9ON6wk8017160@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55923 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755171AbXJXXH3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 19:07:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, a.zummo@towertech.it, david-b@pacbell.net, ralf@linux-mips.org


The patch titled
     rtc: release correct region in error path
has been added to the -mm tree.  Its filename is
     rtc-release-correct-region-in-error-path.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -919,6 +919,14 @@ static const struct file_operations rtc_
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
@@ -993,10 +1001,7 @@ no_irq:
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
@@ -1010,7 +1015,7 @@ no_irq:
 		free_irq(RTC_IRQ, NULL);
 		rtc_has_irq = 0;
 #endif
-		release_region(RTC_PORT(0), RTC_IO_EXTENT);
+		rtc_release_region();
 		return -ENODEV;
 	}
 
@@ -1092,10 +1097,7 @@ static void __exit rtc_exit (void)
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

serial-keep-the-dtr-setting-for-serial-console.patch
rtc-release-correct-region-in-error-path.patch
rtc-fallback-to-requesting-only-the-ports-we-actually-use.patch
pnp-simplify-pnp_activate_dev-and-pnp_disable_dev-return-values.patch
