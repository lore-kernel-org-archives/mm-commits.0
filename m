From: akpm@linux-foundation.org
Subject: [merged] rtc-coh901331-fix-braces-in-resume-code.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:11:02 -0800
Message-ID: <201003091911.o29JB247031634@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755569Ab0CITME (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:12:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: james@albanarts.com, a.zummo@towertech.it, linus.walleij@stericsson.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     rtc-coh901331: fix braces in resume code
has been removed from the -mm tree.  Its filename was
     rtc-coh901331-fix-braces-in-resume-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-coh901331: fix braces in resume code
From: James Hogan <james@albanarts.com>

The else part of the if statement is indented but does not have braces
around it. It clearly should since it uses clk_enable and clk_disable
which are supposed to balance.

Signed-off-by: James Hogan <james@albanarts.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-coh901331.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-coh901331.c~rtc-coh901331-fix-braces-in-resume-code drivers/rtc/rtc-coh901331.c
--- a/drivers/rtc/rtc-coh901331.c~rtc-coh901331-fix-braces-in-resume-code
+++ a/drivers/rtc/rtc-coh901331.c
@@ -271,12 +271,13 @@ static int coh901331_resume(struct platf
 {
 	struct coh901331_port *rtap = dev_get_drvdata(&pdev->dev);
 
-	if (device_may_wakeup(&pdev->dev))
+	if (device_may_wakeup(&pdev->dev)) {
 		disable_irq_wake(rtap->irq);
-	else
+	} else {
 		clk_enable(rtap->clk);
 		writel(rtap->irqmaskstore, rtap->virtbase + COH901331_IRQ_MASK);
 		clk_disable(rtap->clk);
+	}
 	return 0;
 }
 #else
_

Patches currently in -mm which might be from james@albanarts.com are


