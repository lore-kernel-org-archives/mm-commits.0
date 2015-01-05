From: akpm@linux-foundation.org
Subject: + rtc-imx-dryice-trivial-clean-up-code.patch added to -mm tree
Date: Mon, 05 Jan 2015 13:38:53 -0800
Message-ID: <54ab046d.NPzBfQJbZces3Xws%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58165 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbbAEViy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2015 16:38:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbe@pengutronix.de, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-imxdi.c: trivial clean up code
has been added to the -mm tree.  Its filename is
     rtc-imx-dryice-trivial-clean-up-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-imx-dryice-trivial-clean-up-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-imx-dryice-trivial-clean-up-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

rtc-imx-dryice-trivial-clean-up-code.patch
rtc-imx-dryice-add-more-known-register-bits.patch

