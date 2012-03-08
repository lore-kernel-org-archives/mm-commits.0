From: akpm@linux-foundation.org
Subject: [merged] cs5535-clockevt-allow-the-mfgpt-irq-to-be-shared.patch removed from -mm tree
Date: Thu, 08 Mar 2012 11:17:53 -0800
Message-ID: <20120308191753.679FCA06CB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:54444 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758339Ab2CHTRy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Mar 2012 14:17:54 -0500
Received: by mail-fa0-f74.google.com with SMTP id a19so31135faa.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Mar 2012 11:17:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: JRottmann@LiPPERTEmbedded.de, dilinger@queued.net, john.stultz@linaro.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: cs5535-clockevt: allow the MFGPT IRQ to be shared
has been removed from the -mm tree.  Its filename was
     cs5535-clockevt-allow-the-mfgpt-irq-to-be-shared.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from JRottmann@LiPPERTEmbedded.de are

linux-next.patch

