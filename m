From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-twlc-fix-threaded-irq-to-use-irqf_oneshot.patch added to -mm tree
Date: Mon, 09 Jul 2012 15:16:44 -0700
Message-ID: <20120709221645.252A620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:50573 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab2GIWQt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2012 18:16:49 -0400
Received: by lbbgp10 with SMTP id gp10so733817lbb.1
        for <mm-commits@vger.kernel.org>; Mon, 09 Jul 2012 15:16:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khilman@ti.com, a.zummo@towertech.it, tglx@linutronix.de


The patch titled
     Subject: drivers/rtc/rtc-twl.c: fix threaded IRQ to use IRQF_ONESHOT
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-twlc-fix-threaded-irq-to-use-irqf_oneshot.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: drivers/rtc/rtc-twl.c: fix threaded IRQ to use IRQF_ONESHOT

Patches currently in -mm which might be from khilman@ti.com are

linux-next.patch
maintainers-add-omap-cpufreq-driver-to-omap-power-management-section.patch
drivers-rtc-rtc-twlc-fix-threaded-irq-to-use-irqf_oneshot.patch

