From: akpm@linux-foundation.org
Subject: [merged]
 rtc-rtc-imxdi-check-the-return-value-from-clk_prepare_enable.patch removed
 from -mm tree
Date: Fri, 04 Apr 2014 12:34:42 -0700
Message-ID: <533f0952.NPM2tKfOHi7cfbL6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43474 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439AbaDDTem (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:34:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabio.estevam@freescale.com

Subject: [merged] rtc-rtc-imxdi-check-the-return-value-from-clk_prepare_enable.patch removed from -mm tree
To: fabio.estevam@freescale.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:34:42 -0700


The patch titled
     Subject: drivers/rtc/rtc-imxdi.c: check the return value from clk_prepare_enable()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-imxdi-check-the-return-value-from-clk_prepare_enable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabio Estevam <fabio.estevam@freescale.com>
Subject: drivers/rtc/rtc-imxdi.c: check the return value from clk_prepare_enable()

clk_prepare_enable() may fail, so let's check its return value and
propagate it in the case of error.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-imxdi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-imxdi.c~rtc-rtc-imxdi-check-the-return-value-from-clk_prepare_enable drivers/rtc/rtc-imxdi.c
--- a/drivers/rtc/rtc-imxdi.c~rtc-rtc-imxdi-check-the-return-value-from-clk_prepare_enable
+++ a/drivers/rtc/rtc-imxdi.c
@@ -401,7 +401,9 @@ static int __init dryice_rtc_probe(struc
 	imxdi->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(imxdi->clk))
 		return PTR_ERR(imxdi->clk);
-	clk_prepare_enable(imxdi->clk);
+	rc = clk_prepare_enable(imxdi->clk);
+	if (rc)
+		return rc;
 
 	/*
 	 * Initialize dryice hardware
_

Patches currently in -mm which might be from fabio.estevam@freescale.com are

origin.patch
linux-next.patch

