From: akpm@osdl.org
Subject: - rtc-fix-error-case.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:12:17 -0800
Message-ID: <200612140612.kBE6CHLL002072@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52298 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946AbWLNGNG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:13:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, mm-commits@vger.kernel.org


The patch titled
     rtc: fx error case
has been removed from the -mm tree.  Its filename was
     rtc-fix-error-case.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc: fx error case
From: "Jan Beulich" <jbeulich@novell.com>

Ensure RTC driver doesn't use its timer when it doesn't get to set it up
(as it cannot currently prevent other of its functions to be called from
outside when not built as a module - probably this should also be
addressed).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/rtc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/char/rtc.c~rtc-fix-error-case drivers/char/rtc.c
--- a/drivers/char/rtc.c~rtc-fix-error-case
+++ a/drivers/char/rtc.c
@@ -958,6 +958,7 @@ static int __init rtc_init(void)
 		}
 	}
 #endif
+	rtc_has_irq = 0;
 	printk(KERN_ERR "rtc_init: no PC rtc found\n");
 	return -EIO;
 
@@ -972,6 +973,7 @@ found:
 	 * PCI Slot 2 INTA# (and some INTx# in Slot 1).
 	 */
 	if (request_irq(rtc_irq, rtc_interrupt, IRQF_SHARED, "rtc", (void *)&rtc_port)) {
+		rtc_has_irq = 0;
 		printk(KERN_ERR "rtc: cannot register IRQ %d\n", rtc_irq);
 		return -EIO;
 	}
@@ -982,6 +984,9 @@ no_irq:
 	else
 		r = request_mem_region(RTC_PORT(0), RTC_IO_EXTENT, "rtc");
 	if (!r) {
+#ifdef RTC_IRQ
+		rtc_has_irq = 0;
+#endif
 		printk(KERN_ERR "rtc: I/O resource %lx is not free.\n",
 		       (long)(RTC_PORT(0)));
 		return -EIO;
@@ -996,6 +1001,7 @@ no_irq:
 
 	if(request_irq(RTC_IRQ, rtc_int_handler_ptr, IRQF_DISABLED, "rtc", NULL)) {
 		/* Yeah right, seeing as irq 8 doesn't even hit the bus. */
+		rtc_has_irq = 0;
 		printk(KERN_ERR "rtc: IRQ %d is not free.\n", RTC_IRQ);
 		if (RTC_IOMAPPED)
 			release_region(RTC_PORT(0), RTC_IO_EXTENT);
@@ -1012,6 +1018,7 @@ no_irq:
 	if (misc_register(&rtc_dev)) {
 #ifdef RTC_IRQ
 		free_irq(RTC_IRQ, NULL);
+		rtc_has_irq = 0;
 #endif
 		release_region(RTC_PORT(0), RTC_IO_EXTENT);
 		return -ENODEV;
@@ -1021,6 +1028,7 @@ no_irq:
 	if (!ent) {
 #ifdef RTC_IRQ
 		free_irq(RTC_IRQ, NULL);
+		rtc_has_irq = 0;
 #endif
 		release_region(RTC_PORT(0), RTC_IO_EXTENT);
 		misc_deregister(&rtc_dev);
_

Patches currently in -mm which might be from jbeulich@novell.com are


