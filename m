From: akpm@linux-foundation.org
Subject: + cs5535-clockevt-allow-the-mfgpt-irq-to-be-shared.patch added to -mm tree
Date: Mon, 06 Feb 2012 14:55:30 -0800
Message-ID: <20120206225531.03E2BA0110@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:57541 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab2BFWzb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2012 17:55:31 -0500
Received: by mail-yw0-f74.google.com with SMTP id m50so701492yhg.1
        for <mm-commits@vger.kernel.org>; Mon, 06 Feb 2012 14:55:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JRottmann@LiPPERTEmbedded.de, dilinger@queued.net, john.stultz@linaro.org, tglx@linutronix.de


The patch titled
     Subject: cs5535-clockevt: allow the MFGPT IRQ to be shared
has been added to the -mm tree.  Its filename is
     cs5535-clockevt-allow-the-mfgpt-irq-to-be-shared.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
Subject: cs5535-clockevt: allow the MFGPT IRQ to be shared

Shared timer IRQs are not a good solution, however the Geode platform has
no APIC, IRQs are a scarce resource and there is no technical reason to
forbid it rightaway.  Increased latencies and overhead due to sharing are
still better than a driver refusing to load.

Signed-off-by: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
Acked-by: Andres Salomon <dilinger@queued.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clocksource/cs5535-clockevt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/clocksource/cs5535-clockevt.c~cs5535-clockevt-allow-the-mfgpt-irq-to-be-shared drivers/clocksource/cs5535-clockevt.c
--- a/drivers/clocksource/cs5535-clockevt.c~cs5535-clockevt-allow-the-mfgpt-irq-to-be-shared
+++ a/drivers/clocksource/cs5535-clockevt.c
@@ -132,7 +132,7 @@ static irqreturn_t mfgpt_tick(int irq, v
 
 static struct irqaction mfgptirq  = {
 	.handler = mfgpt_tick,
-	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TIMER,
+	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TIMER | IRQF_SHARED,
 	.name = DRV_NAME,
 };
 
_
Subject: Subject: cs5535-clockevt: allow the MFGPT IRQ to be shared

Patches currently in -mm which might be from JRottmann@LiPPERTEmbedded.de are

cs5535-clockevt-dont-ignore-mfgpt-on-smp-capable-kernels.patch
cs5535-clockevt-allow-the-mfgpt-irq-to-be-shared.patch

