From: akpm@linux-foundation.org
Subject: [merged] rtc-ds1553-drop-irqf_shared.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:44:28 -0700
Message-ID: <200906182244.n5IMiSYT003504@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48441 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758897AbZFRWok (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:44:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc-ds1553: drop IRQF_SHARED
has been removed from the -mm tree.  Its filename was
     rtc-ds1553-drop-irqf_shared.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-ds1553: drop IRQF_SHARED
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

IRQF_SHARED should not be used with IRQF_DISABLED.  There is no in-tree
user of this driver and only out-of-tree user I know uses a dedicated irq
line for this RTC.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1553.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-ds1553.c~rtc-ds1553-drop-irqf_shared drivers/rtc/rtc-ds1553.c
--- a/drivers/rtc/rtc-ds1553.c~rtc-ds1553-drop-irqf_shared
+++ a/drivers/rtc/rtc-ds1553.c
@@ -329,8 +329,7 @@ static int __devinit ds1553_rtc_probe(st
 	if (pdata->irq > 0) {
 		writeb(0, ioaddr + RTC_INTERRUPTS);
 		if (request_irq(pdata->irq, ds1553_rtc_interrupt,
-				IRQF_DISABLED | IRQF_SHARED,
-				pdev->name, pdev) < 0) {
+				IRQF_DISABLED, pdev->name, pdev) < 0) {
 			dev_warn(&pdev->dev, "interrupt not available.\n");
 			pdata->irq = 0;
 		}
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
rtc-make-rtc_update_irq-callable-with-irqs-enabled-v2.patch
linux-next.patch
txx9dmac-use-dma_unmap_single-if-dma_compl_srcdest_unmap_single-was-set.patch
kgdb-kgdboc-console-poll-hooks-for-serial_txx9-uart.patch
serial_txx9-use-container_of-instead-of-direct-cast.patch

