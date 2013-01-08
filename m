From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-tps65910c-set-irq-flag-to-irqf_early_resume-during-irq-request.patch added to -mm tree
Date: Tue, 08 Jan 2013 14:04:06 -0800
Message-ID: <20130108220407.A46A92001A3@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f73.google.com ([209.85.215.73]:35230 "EHLO
	mail-la0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab3AHWEK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2013 17:04:10 -0500
Received: by mail-la0-f73.google.com with SMTP id fq13so70840lab.4
        for <mm-commits@vger.kernel.org>; Tue, 08 Jan 2013 14:04:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ldewangan@nvidia.com, broonie@opensource.wolfsonmicro.com


The patch titled
     Subject: drivers/rtc/rtc-tps65910.c: set irq flag to IRQF_EARLY_RESUME during irq request
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-tps65910c-set-irq-flag-to-irqf_early_resume-during-irq-request.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laxman Dewangan <ldewangan@nvidia.com>
Subject: drivers/rtc/rtc-tps65910.c: set irq flag to IRQF_EARLY_RESUME during irq request

All interrupt get disabled during system suspend and enabled during system
resume.  The enabling/disabling of interrupt happen in sequence of
interrupt registration with framework.

Therefore, in resume, the parent interrupt of this device enabled before
the RTC irq interrupt enabled.  If RTC is enabled for alarm wake and if
system wake by alarm then there is interrupt pending for RTC.  In resume,
the parent interrupt get enabled before the rtc interrupt and hence ISR
get served.  In ISR, it founds that rtc interrupt is disabled and so it
does not call the rtc isr handler and hence it misses the interrupt.

Setting flag for early resume so that rtc interrupt get enabled before
parent interrupt and so rtc interrupt get enabled when parent interrupt
handler check for interrupt of device and call the rtc handler if it is
there.  This way it will not miss the interrupt.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tps65910.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-tps65910.c~drivers-rtc-rtc-tps65910c-set-irq-flag-to-irqf_early_resume-during-irq-request drivers/rtc/rtc-tps65910.c
--- a/drivers/rtc/rtc-tps65910.c~drivers-rtc-rtc-tps65910c-set-irq-flag-to-irqf_early_resume-during-irq-request
+++ a/drivers/rtc/rtc-tps65910.c
@@ -267,7 +267,7 @@ static int tps65910_rtc_probe(struct pla
 	}
 
 	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
-		tps65910_rtc_interrupt, IRQF_TRIGGER_LOW,
+		tps65910_rtc_interrupt, IRQF_TRIGGER_LOW | IRQF_EARLY_RESUME,
 		dev_name(&pdev->dev), &pdev->dev);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "IRQ is not free.\n");
_

Patches currently in -mm which might be from ldewangan@nvidia.com are

origin.patch
linux-next.patch
rtc-add-rtc-driver-for-tps80031-tps80032.patch
rtc-add-rtc-driver-for-tps80031-tps80032-v2.patch
rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix.patch
drivers-rtc-rtc-tps65910c-enable-disable-wake-in-suspend-resume.patch
drivers-rtc-rtc-tps65910c-remove-unnecessary-irq-stat-save-and-restore.patch
drivers-rtc-rtc-tps65910c-use-sleep_pm_ops-macro-for-initialising-suspend-resume-callbacks.patch
drivers-rtc-rtc-tps65910c-set-irq-flag-to-irqf_early_resume-during-irq-request.patch

