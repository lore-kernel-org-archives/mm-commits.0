From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-tps65910c-set-irq-flag-to-irqf_early_resume-during-irq-request.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:43:50 -0800
Message-ID: <20130222204350.A2EDD31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:63404 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758182Ab3BVUnv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:43:51 -0500
Received: by mail-qe0-f74.google.com with SMTP id a11so104178qen.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:43:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ldewangan@nvidia.com, broonie@opensource.wolfsonmicro.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-tps65910.c: set irq flag to IRQF_EARLY_RESUME during irq request
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-tps65910c-set-irq-flag-to-irqf_early_resume-during-irq-request.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

