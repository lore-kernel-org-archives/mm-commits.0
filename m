From: akpm@linux-foundation.org
Subject: [merged] rtc-tx4939-drop-irqf_shared.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:44:26 -0700
Message-ID: <200906182244.n5IMiQoE003444@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758851AbZFRWoh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:44:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc-tx4939: drop IRQF_SHARED
has been removed from the -mm tree.  Its filename was
     rtc-tx4939-drop-irqf_shared.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-tx4939: drop IRQF_SHARED
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

IRQF_SHARED should not be used with IRQF_DISABLED.  This RTC have a
dedicated irq line to SoC's internal interrupt controller so there is
no reason to use IRQF_SHARED.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tx4939.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-tx4939.c~rtc-tx4939-drop-irqf_shared drivers/rtc/rtc-tx4939.c
--- a/drivers/rtc/rtc-tx4939.c~rtc-tx4939-drop-irqf_shared
+++ a/drivers/rtc/rtc-tx4939.c
@@ -261,10 +261,8 @@ static int __init tx4939_rtc_probe(struc
 
 	tx4939_rtc_cmd(pdata->rtcreg, TX4939_RTCCTL_COMMAND_NOP);
 	if (devm_request_irq(&pdev->dev, irq, tx4939_rtc_interrupt,
-			     IRQF_DISABLED | IRQF_SHARED,
-			     pdev->name, &pdev->dev) < 0) {
+			     IRQF_DISABLED, pdev->name, &pdev->dev) < 0)
 		return -EBUSY;
-	}
 	rtc = rtc_device_register(pdev->name, &pdev->dev,
 				  &tx4939_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
rtc-make-rtc_update_irq-callable-with-irqs-enabled-v2.patch
linux-next.patch
txx9dmac-use-dma_unmap_single-if-dma_compl_srcdest_unmap_single-was-set.patch
kgdb-kgdboc-console-poll-hooks-for-serial_txx9-uart.patch
serial_txx9-use-container_of-instead-of-direct-cast.patch

