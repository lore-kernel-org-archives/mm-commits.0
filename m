From: akpm@linux-foundation.org
Subject: +
 rtc-rtc-imxdi-check-the-return-value-from-clk_prepare_enable.patch added to -mm tree
Date: Mon, 27 Jan 2014 15:08:08 -0800
Message-ID: <52e6e6d8.F6RSe3wbKr2bEHfY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37062 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbaA0XII (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jan 2014 18:08:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabio.estevam@freescale.com

Subject: + rtc-rtc-imxdi-check-the-return-value-from-clk_prepare_enable.patch added to -mm tree
To: fabio.estevam@freescale.com
From: akpm@linux-foundation.org
Date: Mon, 27 Jan 2014 15:08:08 -0800


The patch titled
     Subject: drivers/rtc/rtc-imxdi.c: check the return value from clk_prepare_enable()
has been added to the -mm tree.  Its filename is
     rtc-rtc-imxdi-check-the-return-value-from-clk_prepare_enable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-rtc-imxdi-check-the-return-value-from-clk_prepare_enable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-rtc-imxdi-check-the-return-value-from-clk_prepare_enable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
rtc-rtc-imxdi-check-the-return-value-from-clk_prepare_enable.patch
linux-next.patch

