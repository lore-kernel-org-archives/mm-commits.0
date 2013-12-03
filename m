From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-mxcc-remove-unneeded-label.patch added to -mm
 tree
Date: Tue, 03 Dec 2013 12:34:08 -0800
Message-ID: <529e4040.A3InxzuGMt+bdBrH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767Ab3LCUeJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Dec 2013 15:34:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabio.estevam@freescale.com

Subject: + drivers-rtc-rtc-mxcc-remove-unneeded-label.patch added to -mm tree
To: fabio.estevam@freescale.com
From: akpm@linux-foundation.org
Date: Tue, 03 Dec 2013 12:34:08 -0800


The patch titled
     Subject: drivers/rtc/rtc-mxc.c: remove unneeded label
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-mxcc-remove-unneeded-label.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-mxcc-remove-unneeded-label.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-mxcc-remove-unneeded-label.patch

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
Subject: drivers/rtc/rtc-mxc.c: remove unneeded label

There is no need to jump to the 'exit_free_pdata' label when
devm_clk_get() fails, as we can directly return the error and simplify the
code a bit.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mxc.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-mxc.c~drivers-rtc-rtc-mxcc-remove-unneeded-label drivers/rtc/rtc-mxc.c
--- a/drivers/rtc/rtc-mxc.c~drivers-rtc-rtc-mxcc-remove-unneeded-label
+++ a/drivers/rtc/rtc-mxc.c
@@ -391,8 +391,7 @@ static int mxc_rtc_probe(struct platform
 	pdata->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(pdata->clk)) {
 		dev_err(&pdev->dev, "unable to get clock!\n");
-		ret = PTR_ERR(pdata->clk);
-		goto exit_free_pdata;
+		return PTR_ERR(pdata->clk);
 	}
 
 	clk_prepare_enable(pdata->clk);
@@ -447,8 +446,6 @@ static int mxc_rtc_probe(struct platform
 exit_put_clk:
 	clk_disable_unprepare(pdata->clk);
 
-exit_free_pdata:
