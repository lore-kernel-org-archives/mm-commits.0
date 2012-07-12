From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-twlc-fix-threaded-irq-to-use-irqf_oneshot.patch removed from -mm tree
Date: Thu, 12 Jul 2012 12:37:25 -0700
Message-ID: <20120712193725.C05721E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:57595 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030747Ab2GLTh0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 15:37:26 -0400
Received: by qcqs25 with SMTP id s25so267943qcq.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 12:37:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khilman@ti.com, a.zummo@towertech.it, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-twl.c: fix threaded IRQ to use IRQF_ONESHOT
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-twlc-fix-threaded-irq-to-use-irqf_oneshot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kevin Hilman <khilman@ti.com>
Subject: drivers/rtc/rtc-twl.c: fix threaded IRQ to use IRQF_ONESHOT

Requesting a threaded interrupt without a primary handler and without
IRQF_ONESHOT is dangerous, and after commit 1c6c6952 ("genirq: Reject
bogus threaded irq requests"), these requests are rejected.  This causes
->probe() to fail, and the RTC driver not to be availble.

To fix, add IRQF_ONESHOT to the IRQ flags.

Tested on OMAP3730/OveroSTORM and OMAP4430/Panda board using rtcwake to
wake from system suspend multiple times.

Signed-off-by: Kevin Hilman <khilman@ti.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-twl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-twl.c~drivers-rtc-rtc-twlc-fix-threaded-irq-to-use-irqf_oneshot drivers/rtc/rtc-twl.c
--- a/drivers/rtc/rtc-twl.c~drivers-rtc-rtc-twlc-fix-threaded-irq-to-use-irqf_oneshot
+++ a/drivers/rtc/rtc-twl.c
@@ -510,7 +510,7 @@ static int __devinit twl_rtc_probe(struc
 	}
 
 	ret = request_threaded_irq(irq, NULL, twl_rtc_interrupt,
-				   IRQF_TRIGGER_RISING,
+				   IRQF_TRIGGER_RISING | IRQF_ONESHOT,
 				   dev_name(&rtc->dev), rtc);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "IRQ is not free.\n");
_

Patches currently in -mm which might be from khilman@ti.com are

origin.patch
linux-next.patch

