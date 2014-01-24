From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-mxcc-remove-unneeded-label.patch removed from -mm tree
Date: Fri, 24 Jan 2014 11:02:30 -0800
Message-ID: <52e2b8c6.yagzSYERPhkxgbNc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43721 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbaAXTCa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:02:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabio.estevam@freescale.com

Subject: [merged] drivers-rtc-rtc-mxcc-remove-unneeded-label.patch removed from -mm tree
To: fabio.estevam@freescale.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:02:30 -0800


The patch titled
     Subject: drivers/rtc/rtc-mxc.c: remove unneeded label
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-mxcc-remove-unneeded-label.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
