From: akpm@linux-foundation.org
Subject: [merged] rtc-imx-dryice-trivial-clean-up-code.patch removed from
 -mm tree
Date: Mon, 16 Feb 2015 12:19:05 -0800
Message-ID: <54e250b9.E2ZzMNT0CS6/f2gp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51393 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbbBPUTl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:19:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbe@pengutronix.de, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-imxdi.c: trivial clean up code
has been removed from the -mm tree.  Its filename was
     rtc-imx-dryice-trivial-clean-up-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Juergen Borleis <jbe@pengutronix.de>
Subject: drivers/rtc/rtc-imxdi.c: trivial clean up code

Signed-off-by: Juergen Borleis <jbe@pengutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-imxdi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-imxdi.c~rtc-imx-dryice-trivial-clean-up-code drivers/rtc/rtc-imxdi.c
--- a/drivers/rtc/rtc-imxdi.c~rtc-imx-dryice-trivial-clean-up-code
+++ a/drivers/rtc/rtc-imxdi.c
@@ -313,7 +313,7 @@ static irqreturn_t dryice_norm_irq(int i
 	dier = __raw_readl(imxdi->ioaddr + DIER);
 
 	/* handle write complete and write error cases */
-	if ((dier & DIER_WCIE)) {
+	if (dier & DIER_WCIE) {
 		/*If the write wait queue is empty then there is no pending
 		  operations. It means the interrupt is for DryIce -Security.
 		  IRQ must be returned as none.*/
@@ -322,7 +322,7 @@ static irqreturn_t dryice_norm_irq(int i
 
 		/* DSR_WCF clears itself on DSR read */
 		dsr = __raw_readl(imxdi->ioaddr + DSR);
-		if ((dsr & (DSR_WCF | DSR_WEF))) {
+		if (dsr & (DSR_WCF | DSR_WEF)) {
 			/* mask the interrupt */
 			di_int_disable(imxdi, DIER_WCIE);
 
@@ -335,7 +335,7 @@ static irqreturn_t dryice_norm_irq(int i
 	}
 
 	/* handle the alarm case */
-	if ((dier & DIER_CAIE)) {
+	if (dier & DIER_CAIE) {
 		/* DSR_WCF clears itself on DSR read */
 		dsr = __raw_readl(imxdi->ioaddr + DSR);
 		if (dsr & DSR_CAF) {
_

Patches currently in -mm which might be from jbe@pengutronix.de are

origin.patch

